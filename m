Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:58646 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729155AbeKOVp5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Nov 2018 16:45:57 -0500
Date: Thu, 15 Nov 2018 03:38:20 -0800
From: Mauro Carvalho Chehab <mchehab@kernel.org>
To: Paul Menzel <pmenzel@molgen.mpg.de>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Logitech QuickCam USB detected by Linux, but not user space
 applications
Message-ID: <20181115033813.6ff626d5@silica.lan>
In-Reply-To: <b9140bbf-1537-1431-1250-da0a21208992@molgen.mpg.de>
References: <b9140bbf-1537-1431-1250-da0a21208992@molgen.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 15 Nov 2018 11:42:32 +0100
Paul Menzel <pmenzel@molgen.mpg.de> escreveu:

> Dear Linux folks,
>=20
>=20
> I tried to get a Logitech QuickCam USB camera working, but unfortunately,=
 it is=20
> not detected by user space (Cheese, MPlayer).

Could you please try it with Camorama?

	https://github.com/alessio/camorama

>=20
> It=E2=80=99s an old device, so it could be broken, but as it=E2=80=99s de=
tected by the Linux
> kernel, I wanted to check with you first.
>=20
> Linux 4.18.10 from Debian Sid/unstable is used.
>=20
> ```
> $ dmesg
> [=E2=80=A6]
> [ 2891.404361] usb 3-3: new full-speed USB device number 4 using ohci-pci
> [ 2891.626934] usb 3-3: New USB device found, idVendor=3D046d, idProduct=
=3D092e, bcdDevice=3D 0.00
> [ 2891.626945] usb 3-3: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D0
> [ 2891.626951] usb 3-3: Product: Camera
> [ 2891.626957] usb 3-3: Manufacturer:
> [ 2893.110249] calling  media_devnode_init+0x0/0x1000 [media] @ 11704
> [ 2893.110256] media: Linux media interface: v0.10
> [ 2893.110329] initcall media_devnode_init+0x0/0x1000 [media] returned 0 =
after 56 usecs
> [ 2893.210078] calling  videodev_init+0x0/0x79 [videodev] @ 11704
> [ 2893.210084] videodev: Linux video capture interface: v2.00
> [ 2893.210123] initcall videodev_init+0x0/0x79 [videodev] returned 0 afte=
r 21 usecs
> [ 2893.333140] calling  gspca_init+0x0/0x1000 [gspca_main] @ 11704
> [ 2893.333148] gspca_main: v2.14.0 registered
> [ 2893.333161] initcall gspca_init+0x0/0x1000 [gspca_main] returned 0 aft=
er 3 usecs
> [ 2893.370672] calling  sd_driver_init+0x0/0x1000 [gspca_spca561] @ 11704
> [ 2893.370751] gspca_main: spca561-2.14.0 probing 046d:092e
> [ 2893.482675] input: spca561 as /devices/pci0000:00/0000:00:12.0/usb3/3-=
3/input/input17
> [ 2893.485415] usbcore: registered new interface driver spca561
> [ 2893.485434] initcall sd_driver_init+0x0/0x1000 [gspca_spca561] returne=
d 0 after 112054 usecs
> [=E2=80=A6]
> $ ls -l /dev/video*
> crw-rw----+ 1 root video 81, 0 Nov 15 09:26 /dev/video0
>=20
> $ mplayer tv:// -tv driver=3Dv4l2:device=3D/dev/video0
> MPlayer 1.3.0 (Debian), built with gcc-8 (C) 2000-2016 MPlayer Team
> do_connect: could not connect to socket
> connect: No such file or directory
> Failed to open LIRC support. You will not be able to use your remote cont=
rol.
>=20
> Playing tv://.
> TV file format detected.
> Selected driver: v4l2
>  name: Video 4 Linux 2 input
>  author: Martin Olschewski <olschewski@zpr.uni-koeln.de>
>  comment: first try, more to come ;-)
> v4l2: your device driver does not support VIDIOC_G_STD ioctl, VIDIOC_G_PA=
RM was used instead.
> Selected device: Camera
>  Capabilities:  video capture  read/write  streaming
>  supported norms:
>  inputs: 0 =3D spca561;
>  Current input: 0
>  Current format: unknown (0x31363553)

The problem is likely here: mplayer is probably not using libv4l2. Without
that, it can't decode the spca561 specific output format. It is probably
due to some option used when mplayer was built.

In the case of Cheese, it uses Gstreamer, with defaults to not use libv4l2
either. On newest versions of it, there is an environment var that would
allow enabling it (I don't remember what var).

Anyway, Camorama is always built with libv4l2, so it should work out of
the box (although I recommend it to use the latest version, as we did
lots of improvements there, including support for the latest Gtk libraries).

> tv.c: norm_from_string(pal): Bogus norm parameter, setting default.
> v4l2: ioctl enum norm failed: Inappropriate ioctl for device
> Error: Cannot set norm!
> Selected input hasn't got a tuner!
> v4l2: ioctl set mute failed: Invalid argument
> v4l2: ioctl query control failed: Invalid argument
> v4l2: ioctl query control failed: Invalid argument
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> Cannot find codec matching selected -vo and video format 0x31363553.
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> No stream found.
>=20
> v4l2: ioctl set mute failed: Invalid argument
> v4l2: 0 frames successfully processed, 0 frames dropped.
>=20
> Exiting... (End of file)
> ```
>=20
> Do you have an idea, what the issue. I know it worked fine several years
> ago.



Cheers,
Mauro
