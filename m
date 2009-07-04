Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:59500 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750926AbZGDRyN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 4 Jul 2009 13:54:13 -0400
Subject: Short experiment with libudev to support media controller concept
From: Andy Walls <awalls@radix.net>
To: hverkuil@xs4all.nl
Cc: linux-media@vger.kernel.org
Content-Type: text/plain
Date: Sat, 04 Jul 2009 13:52:15 -0400
Message-Id: <1246729935.2826.43.camel@morgan.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans,

The inline source file at the end of this post is a small program I used
to play with libudev to see if it would complement the media controller
concept (as you suspected it would).

Documentation on the libudev calls is here:

	http://www.kernel.org/pub/linux/utils/kernel/hotplug/libudev/

The test program I wrote takes a (type,major,minor) tuple and lists the
device node and device symlinks as fetched by libudev.

My test setup was a little strange since libudev is no longer maintained
separately but is bundled in with udev.  On my Fedora 9 system I have
udev v124 (Fedora 9 stock) and libudev v143 (custom built from the udev
143 source).

Here's some output:

$ ./finddev -c -M 1 -m 3
Requested device: type 'c', major 1, minor 3
Device directory path: '/dev'
Device node: '/dev/null'
Device link: '/dev/XOR'

$ ls -al /dev/ | grep '[ /]null'
crw-rw-rw-   1 root root     1,   3 2009-07-04 08:34 null
lrwxrwxrwx   1 root root          4 2009-07-04 08:34 X0R -> null
lrwxrwxrwx   1 root root          4 2009-07-04 08:34 XOR -> null

(Hmmm, not perfect for /dev/null)


$ ./finddev -b -M 11 -m 0
Requested device: type 'b', major 11, minor 0
Device directory path: '/dev'
Device node: '/dev/sr0'
Device link: '/dev/scd0'
Device link: '/dev/disk/by-path/pci-0000:00:14.1-scsi-1:0:0:0'
Device link: '/dev/cdrom'
Device link: '/dev/cdrw'

$ ls -alR /dev/* | grep '[ /]sr0'
lrwxrwxrwx  1 root root          3 2009-07-04 08:34 /dev/cdrom -> sr0
lrwxrwxrwx  1 root root          3 2009-07-04 08:34 /dev/cdrw -> sr0
lrwxrwxrwx  1 root root          3 2009-07-04 08:34 /dev/scd0 -> sr0
brw-rw----+ 1 root disk    11,   0 2009-07-04 08:34 /dev/sr0
lrwxrwxrwx 1 root root   9 2009-07-04 08:34 pci-0000:00:14.1-scsi-1:0:0:0 -> ../../sr0

(OK for the CDROM drive.)


$ ./finddev -c -M 81 -m 9
Requested device: type 'c', major 81, minor 9
Device directory path: '/dev'
Device node: '/dev/video0'
Device link: '/dev/video'

$ ls -alR /dev/* | grep '[ /]video0'
lrwxrwxrwx  1 root root          6 2009-07-04 08:34 /dev/video -> video0
crw-rw----+ 1 root root    81,   9 2009-07-04 08:34 /dev/video0

(OK for video nodes)


$ ./finddev -c -M 116 -m 6
Requested device: type 'c', major 116, minor 6
Device directory path: '/dev'
Device node: '/dev/snd/pcmC0D0p'

$ ls -alR /dev/* | grep '[ /]pcmC0D0p'
crw-rw----+  1 root root 116, 6 2009-07-04 13:43 pcmC0D0p

(OK for ALSA PCM stream nodes).


Do you have any other particular questions about libudev's capabilities?

Regards,
Andy



/*
 *  finddev.c - Find a device node given (type,major,minor) using libudev
 *  Copyright (C) 2009  Andy Walls <awalls@radix.net>
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License along
 *  with this program; if not, write to the Free Software Foundation, Inc.,
 *  51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 *
 *  Compilation:
 *  	gcc -o finddev finddev.c -Wall -ludev
 *
 *  Example invocation (/dev/null on my system):
 *  	./finddev -c -M 1 -m 3
 */

#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <libudev.h>

struct parsed_args {
	int major;
	int minor;
	char type;
};

int parse_args(int argc, char *argv[], struct parsed_args *args)
{
	int c, ret;

	ret = 0;
	args->major = args->minor = -1;
	args->type = 'c';

	while ((c = getopt(argc, argv, "bcM:m:")) != -1) {
		switch (c) {
		case 'b': args->type = 'b';           break;
		case 'c': args->type = 'c';           break;
		case 'M': args->major = atoi(optarg); break;
		case 'm': args->minor = atoi(optarg); break;
		default:  ret = -1;                   break;
		}
	}
	if (ret || args->major == -1 || args->minor == -1) {
		fprintf(stderr, "Usage: %s [-b|-c] -M major -m minor\n",
			argv[0]);
		ret = -1;
	}
	return ret;
}

int main(int argc, char *argv[])
{
	struct parsed_args args;
	dev_t devnum;
	struct udev *udev;
	struct udev_device *udev_device;
	const char *s;
	struct udev_list_entry *udev_list_entry;

	if (parse_args(argc,argv, &args))
		exit(1);

	printf("Requested device: type '%c', major %d, minor %d\n",
	       args.type, args.major, args.minor);

	devnum = makedev(args.major, args.minor);

	udev = udev_new();
	if (udev == NULL) {
		fprintf(stderr, "udev_new() failed\n");
		exit(2);
	}

	printf("Device directory path: '%s'\n", udev_get_dev_path(udev));

	udev_device = udev_device_new_from_devnum(udev, args.type, devnum);

	if (udev_device == NULL) {
		fprintf(stderr, "udev_device_new_from_devnum() failed\n");
		udev_unref(udev);
		exit(3);
	}

	s = udev_device_get_devnode(udev_device);
	if (s) {
		printf("Device node: '%s'\n", s);
	} else {
		fprintf(stderr, "udev_device_get_devnode() failed\n");
		udev_device_unref(udev_device);
		udev_unref(udev);
		exit(4);
	}

	udev_list_entry_foreach(udev_list_entry,
			     udev_device_get_devlinks_list_entry(udev_device)) {
		s = udev_list_entry_get_name(udev_list_entry);
		printf("Device link: '%s'\n", s);
	}

	udev_device_unref(udev_device);
	udev_unref(udev);
	exit(0);
}



