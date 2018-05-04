Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751558AbeEDSpX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 4 May 2018 14:45:23 -0400
Received: from mail.kernel.org (unknown [91.207.57.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 940AB214C5
        for <linux-media@vger.kernel.org>; Fri,  4 May 2018 18:45:22 +0000 (UTC)
Date: Fri, 4 May 2018 20:45:13 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: 4.17-rc3 regression in UVC driver
Message-ID: <20180504181900.pm72mxyueqb3fu3z@earth.universe>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="7ksofjbnqa2rsyfs"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--7ksofjbnqa2rsyfs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

I just got the following error message every ms with 4.17-rc3 after
upgrading to for first ~192 seconds after system start (Debian
4.17~rc3-1~exp1 kernel) on my Thinkpad X250:

> uvcvideo: Failed to query (GET_MIN) UVC control 2 on unit 1: -32 (exp. 1).

I see /dev/video0 and /dev/video1. The first one seems to be
functional. The second one does not work and does not make
sense to me (the system has only one webcam). I did not try to
bisect anything. Here is some more information, that might
be useful:

> sre@earth ~ % mpv /dev/video1=20
> Playing: /dev/video1
> [ffmpeg/demuxer] video4linux2,v4l2: ioctl(VIDIOC_G_INPUT): Inappropriate =
ioctl for device
> [lavf] avformat_open_input() failed
> Failed to recognize file format.
> sre@earth ~ % udevadm info /dev/video0
> P: /devices/pci0000:00/0000:00:14.0/usb1/1-8/1-8:1.0/video4linux/video0
> N: video0
> E: DEVNAME=3D/dev/video0
> E: DEVPATH=3D/devices/pci0000:00/0000:00:14.0/usb1/1-8/1-8:1.0/video4linu=
x/video0
> E: MAJOR=3D81
> E: MINOR=3D0
> E: SUBSYSTEM=3Dvideo4linux
> sre@earth ~ % udevadm info /dev/video1
> P: /devices/pci0000:00/0000:00:14.0/usb1/1-8/1-8:1.0/video4linux/video1
> N: video1
> E: DEVNAME=3D/dev/video1
> E: DEVPATH=3D/devices/pci0000:00/0000:00:14.0/usb1/1-8/1-8:1.0/video4linu=
x/video1
> E: MAJOR=3D81
> E: MINOR=3D1
> E: SUBSYSTEM=3Dvideo4linux
> sre@earth ~ % lsusb -d 04ca:703c
> Bus 001 Device 004: ID 04ca:703c Lite-On Technology Corp.=20

-- Sebastian

--7ksofjbnqa2rsyfs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAlrsqjQACgkQ2O7X88g7
+prDRw/+MSsZ5Ux1ee2pXojulWVJcG7cig1v9IjnGrKY41yxdDhKHELoAVK6KYyo
O6ffNDZDVCwrPfWufQAb3FtLqegRmZ7kUeTksHYsIHzWDtdTRRyiRknRbmaf+7w1
HOtrcZiID8SPTE0g98YPFSTVfW6L9Bknn0d7X4vX9T2zE7wgWlc0m70qO314DSEK
gEWUK2mpQ3CwhfOoGeVFnAHVKLppWtqK0d/j5JPpk4QkVXYcqV7T7+iSgAjdyEsJ
uKIwdmonj0E2ApABxz+6T/sXHlOErg6jn+7ywejq2XUsh9AbzNUX4nOOhaVjpbql
j/4wSJmK/32hlCbXfLystuQFM5qlrLxUSfdJ+/6BmnldW0H+24CK+DPc6ZCEpQFK
U0HsDhcxq4JFKNPcvg+jbmn/EcidaeS9MRwOXZXiV1ZbvtyFM9U3Av4CyXSLOcic
MPkSFOvghH0OvC+9EtkEoAw80j54Eg6vPs/APRBAt/bgoJvP4SHgpJs7G/+C0fqL
hbSWo3NSox8n/UP62y1B9GwS4djxyFKvQ68wQMG0nHYHIEnGAn4aZj9wXLuTaRLT
IfzUQtcylLfxC083RyBYoQwK81hUez0S6Vsz9opTc7coZWl7WyAoHV8jvwYhTqYz
rTpKi12zFIdlvIObOYiRHEOp2M2S4QZW6oOEv2u1aaTAliNlpUA=
=e/5O
-----END PGP SIGNATURE-----

--7ksofjbnqa2rsyfs--
