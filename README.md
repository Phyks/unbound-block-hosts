This is a script to download, parse and convert some hosts files into Unbound
compatible configurations file. Now using only Bash and Python stuff.

Just run `./run.sh` and add `include: /var/unbound/includes/dnsblock.conf` in
your Unbound server config.


# Old version

**Note**: This is a fork of https://github.com/jodrell/unbound-block-hosts. You should use the original repo. This fork adds support for other hosts lists such as malwaredomains and Yoyo, but the patch is quite ugly. Feel free to PR a cleaner version. Use this fork only if you have to handle such lists and not Pollock's one.

# NAME

unbound-block-hosts - a script to convert Dan Pollock's ad blocking hosts file
into Unbound local-data

# SYNOPSIS

    unbound-block-hosts [OPTIONS]

# INTRODUCTION

Dan Pollock (http://someonewhocares.org/) maintains a hosts file that can be
used by individual users to block hosts that contain advertisements, spyware,
web trackers and other unpleasant, annoying or malicious content.

This script converts this file into a format that can be loaded into the Unbound
DNS server, allowing this list to be consumed by an entire network, or by
devices (such as smart phones and tablets) which don't support a local hosts
file.

# USAGE

unbound-block-hosts supports the following arguments:

- `--address=ADDRESS`

    The IP address to resolve to. This is `127.0.0.1` by default.

- `--v6address=ADDRESS`

    The IPv6 address to resolve to. This is `::1` by default.

- `--url=URL`

    The URL to retrieve. This is [http://someonewhocares.org/hosts/hosts](http://someonewhocares.org/hosts/hosts) by default.

- `--file=FILE`

    The file to write. This is `/var/unbound/local-blocking-data.conf` by default.

- `--SECTION`

    The source file contains a number of sections, which can be enabled or disabled
    as required. By default, all sections are enabled except for `shock-sites` and
    `maybe-spy`.

This script will compare the modification time of the local file to that on the
remote server, and won't request the file if it hasn't been updated.

# INTEGRATING INTO UNBOUND

To use the output of this file with Unbound, use the `include` directive within
the `server` block, like so:

        server:
                access-control: 0.0.0.0/8 allow
                include: /var/unbound/local-blocking-data.conf

# COPYRIGHT

Copyright 2015 Gavin Brown &lt;gavin.brown@uk.com>

This program is Free Software, you can use it and/or modify it under the same
terms as Perl itself.

# SEE ALSO

- [https://github.com/jodrell/unbound-block-hosts](https://github.com/jodrell/unbound-block-hosts)
- [http://someonewhocares.org/hosts/](http://someonewhocares.org/hosts/)
