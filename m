Return-path: <linux-media-owner@vger.kernel.org>
Received: from pne-smtpout2-sn2.hy.skanova.net ([81.228.8.164]:47054 "EHLO
	pne-smtpout2-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752169AbZCWTk0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Mar 2009 15:40:26 -0400
Message-ID: <49C7E5A1.9010501@gmail.com>
Date: Mon, 23 Mar 2009 20:40:17 +0100
From: =?ISO-8859-1?Q?Erik_Andr=E9n?= <erik.andren@gmail.com>
MIME-Version: 1.0
To: Hans de Goede <j.w.r.degoede@hhs.nl>
CC: linux-media@vger.kernel.org
Subject: libv4l, yuv420 and gspca-stv06xx conversion
Content-Type: multipart/mixed;
 boundary="------------000508080201020005080304"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------000508080201020005080304
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi Hans,
I'm trying to get gstreamer and the yuv420 format conversion in
libv4l to play nice with the gspca-stv06xx driver. Currently this is
not working.

The resolution of the vv6410 sensor is 356*292 pixels and the native
format of the camera is V4L2_PIX_FMT_SGRBG8.
This produces a total image size of 103952 bytes which gets page
aligned to 106496.

When requesting to conversion to yuv420 in gstreamer I launch
gst-launch with the following parameters:
gst-launch-0.10 -v v4l2src queue-size=4 ! ffmpegcolorspace ! xvimageink

gstreamer then proceeds with complaining that it received a frame of
 size 155928 bytes but it expected a frame of size 156512 bytes.

The delivered 155928 size seems sane as 155928 / 356 gives 438 and
155928 / 292 gives 534.

Furthermore, the difference between the received size and the
expected size is 584 bytes which is 2x the height.

Anyhow, I hacked libv4l2.c and padded the frame with 584 in order to
acheive the requested 156512 bytes. This worked and yielded the
attached image.

I'm currently at loss what's the root cause of this.

Could the page align interfer somehow with the frame size?
What's the correct image size? The converted image is clearly correct.

Hans,
do you have any ideas on how to further debug this issue?

RGB images work as intended although they need to be whitebalanced.

Thanks,
Erik
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAknH5aEACgkQN7qBt+4UG0EQGgCcDdOEhW9Wz/TvU6kGtF3iRJDK
ID0An1V+bxCX5zKzBQ1n5L7q1j2dg0Dp
=EegQ
-----END PGP SIGNATURE-----

--------------000508080201020005080304
Content-Type: image/jpeg;
 name="yuv420.jpg"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="yuv420.jpg"

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
vd02KOONRP0T7IZJ5NFNzd/E+/yif//Z
--------------000508080201020005080304--
