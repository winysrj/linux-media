Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:48971 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753573AbeBSTJ0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Feb 2018 14:09:26 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Alexandre-Xavier =?ISO-8859-1?Q?Labont=E9=2DLamoureux?=
        <axdoomer@gmail.com>
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-media@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: Bug: Two device nodes created in /dev for a single UVC webcam
Date: Mon, 19 Feb 2018 21:10:05 +0200
Message-ID: <46032915.v1itnVjfQo@avalon>
In-Reply-To: <CAKTMqxuF1BNy+xoEnArvc+S_NgucBKna6iOExKj8CxjF0qC2Jw@mail.gmail.com>
References: <CAKTMqxtRQvZqZGQ0oWSf79b3ZGs6Stpctx9yqi8X1Myq-CY2JA@mail.gmail.com> <dd70c226-e7db-e55e-e467-a6b0d1e7849d@ideasonboard.com> <CAKTMqxuF1BNy+xoEnArvc+S_NgucBKna6iOExKj8CxjF0qC2Jw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alexandre-Xavier,

On Monday, 19 February 2018 19:29:24 EET Alexandre-Xavier Labont=E9-Lamoure=
ux=20
wrote:
> Hi Kieran,
>=20
> This is how I built the drivers:
>=20
> $ git clone --depth=3D1 git://linuxtv.org/media_build.git
> $ cd media_build
> $ ./build --main-git
>=20
> I then installed the newly built kernel modules:
>=20
> $ sudo make install
>=20
> Once the modules were updated, I restarted my computer to make sure
> every module got reloaded. I didn't make any changes to the code and I
> found the issues after trying each of those programs individually
> after I restarted my computer.
>=20
> This was the latest commit when I cloned the repo:
>=20
> commit d144cfe4b3c37ece55ae27778c99765d4943c4fa
> Author: Jasmin Jessich <jasmin@anw.at>
> Date:   Fri Feb 16 22:40:49 2018 +0100
>     Re-generated v3.12_kfifo_in.patch
>=20
> My version of VLC is 2.2.6. Here's a copy of the relevant data of
> VLC's log file in case it can help: https://paste.debian.net/1011025/
> In this case, I tried to open /dev/video0 first and /dev/video1 second.
>=20
> I can also try with ffplay:
> $ ffplay /dev/video0
>=20
> I get this: [video4linux2,v4l2 @ 0x7f2160000920]
> ioctl(VIDIOC_STREAMON): Message too long
> /dev/video0: Message too long
>=20
> A new message appears in dmesg: uvcvideo: Failed to submit URB 0 (-90).

That's interesting, and possibly unrelated to the patch series that added=20
metadata capture support. Would you be able to revert that patch series and=
=20
see if the problem still occurs ? The four commits to be reverted are

088ead25524583e2200aa99111bea2f66a86545a
3bc85817d7982ed53fbc9b150b0205beff68ca5c
94c53e26dc74744cc4f9a8ddc593b7aef96ba764
31a96f4c872e8fb953c853630f69d5de6ec961c9

And if you could bisect the issue it would be even better :-)

Could you also send me the output of lsusb -v for your camera (you can=20
restrict it to the camera with -d VID:PID), running as root if possible ?

> $ ffplay /dev/video1
>=20
> I get this:
> [video4linux2,v4l2 @ 0x7f00ec000920] ioctl(VIDIOC_G_INPUT):
> Inappropriate ioctl for device
> /dev/video1: Inappropriate ioctl for device
>=20
> Like Guennadi said, /dev/video1 is a metadata node, so I don't expect
> it to work. In the case of /dev/video0, I can't tell what could be
> wrong from the error message.

=2D-=20
Regards,

Laurent Pinchart
