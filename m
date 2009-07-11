Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:2888 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164AbZGKT3A (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Jul 2009 15:29:00 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Andy Walls <awalls@radix.net>
Subject: Re: Short experiment with libudev to support media controller concept
Date: Sat, 11 Jul 2009 21:28:54 +0200
Cc: linux-media@vger.kernel.org
References: <1246729935.2826.43.camel@morgan.walls.org> <1247339986.2817.28.camel@morgan.walls.org>
In-Reply-To: <1247339986.2817.28.camel@morgan.walls.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907112128.54340.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 11 July 2009 21:19:46 Andy Walls wrote:
> On Sat, 2009-07-04 at 13:52 -0400, Andy Walls wrote:
> > Hans,
> >
> > The inline source file at the end of this post is a small program I
> > used to play with libudev to see if it would complement the media
> > controller concept (as you suspected it would).
> >
> > Documentation on the libudev calls is here:
> >
> > 	http://www.kernel.org/pub/linux/utils/kernel/hotplug/libudev/
> >
> > The test program I wrote takes a (type,major,minor) tuple and lists the
> > device node and device symlinks as fetched by libudev.
> >
> > My test setup was a little strange since libudev is no longer
> > maintained separately but is bundled in with udev.  On my Fedora 9
> > system I have udev v124 (Fedora 9 stock) and libudev v143 (custom built
> > from the udev 143 source).
> >
> > Here's some output:
> >
> >
> > $ ./finddev -c -M 81 -m 9
> > Requested device: type 'c', major 81, minor 9
> > Device directory path: '/dev'
> > Device node: '/dev/video0'
> > Device link: '/dev/video'
> >
> > $ ls -alR /dev/* | grep '[ /]video0'
> > lrwxrwxrwx  1 root root          6 2009-07-04 08:34 /dev/video ->
> > video0 crw-rw----+ 1 root root    81,   9 2009-07-04 08:34 /dev/video0
> >
> > (OK for video nodes)
> >
> >
> > $ ./finddev -c -M 116 -m 6
> > Requested device: type 'c', major 116, minor 6
> > Device directory path: '/dev'
> > Device node: '/dev/snd/pcmC0D0p'
> >
> > $ ls -alR /dev/* | grep '[ /]pcmC0D0p'
> > crw-rw----+  1 root root 116, 6 2009-07-04 13:43 pcmC0D0p
> >
> > (OK for ALSA PCM stream nodes).
> >
> >
> > Do you have any other particular questions about libudev's
> > capabilities?
>
> OK, so more tests.  Two Major groups: with udev still running and with
> udev not running (killed after I log in).
>
> Case 1:
>
> - udev running:
> - Adding a manual symlink
>    # cd /dev
>    # ln -s video0 mpeg0
>
> Result: finddev using libudev doesn't find the manual symlink
>
>
> Case 2:
>
> - udev running
> - A manual mknod
>    # cd /dev
>    # mknod mpeg0 c 81 9
>
> Result: finddev doesn't find the manually created device node
>
>
> Case 3:
> - same as case 2, but manually delete /dev/video0
>
> Result: finddev reports /dev/video0 ! :(

That's not surprising as cases 1-3 by-pass udev, so libudev knows nothing 
about those changes.

>
>
> Case 4:
> - same as case 3
> - add to 50-udev-default.rules:
> 	KERNEL=="video[0-9]*", SYMLINK+="mpeg%n"
> - Reload udev rules
> 	udevadm control --reload_rules
> 	udevadm trigger --subsystem-match=video4linux
>
> Result: findddev reports the new '/dev/mpeg0' symlink for /dev/video0 as
> well as the the '/dev/video' synmlink and the '/dev/video0' device
> node. :)

Nice!

>
> Case 5:
> - same as case 3
> - add to 50-udev-default.rules:
> 	KERNEL=="video[0-9]*", NAME="mpeg%n"
> - Reload udev rules
> 	udevadm control --reload_rules
> 	udevadm trigger --subsystem-match=video4linux
>
> Result: SELinux gripes at me because HAL is allowed to acces the
> attributes of /dev/mpeg*. :)
> finddev reports the new /dev/mpeg0 and the /dev/video symlink to it and
> they both exist in the filesystem. :)

Nice again!

>
> Case 6:
> - after case 5
> - kill udevd. :)
>
> Result: finddev finds /dev/mpeg0 and the /dev/video symlink

Nice test :-) and nice result.

> Case 7:
> - after case 6:
> - manually remove /dev/mpeg0 and /dev/video
>
> Result: finddev reports /dev/mpeg0 and the /dev/video symlink. :?

Similar to cases 1-3: you bypass udev so libudev won't know about it.

>
>
> Apparently libudev uses what's in the udev database and /sys but doesn't
> look in the /dev directory for manual actions, even when udevd is dead.

That makes sense as udev is basically in charge of the /dev/ contents and 
making manual /dev/ changes while udev is running defeats the purpose of 
udev.

I'm really happy finddev finds the symlinks as well. This means that the 
major and minor numbers are all that is needed in order to reliably find 
the right device nodes in /dev.

Thanks!

	Hans

>
> Regards,
> Andy
>
> > Regards,
> > Andy
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
