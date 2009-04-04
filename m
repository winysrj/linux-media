Return-path: <linux-media-owner@vger.kernel.org>
Received: from pne-smtpout1-sn2.hy.skanova.net ([81.228.8.83]:37923 "EHLO
	pne-smtpout1-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751541AbZDDVb6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 4 Apr 2009 17:31:58 -0400
Message-ID: <49D7C17B.80708@gmail.com>
Date: Sat, 04 Apr 2009 22:22:19 +0200
From: =?ISO-8859-1?Q?Erik_Andr=E9n?= <erik.andren@gmail.com>
MIME-Version: 1.0
To: Hans de Goede <j.w.r.degoede@hhs.nl>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: libv4l: Possibility of changing the current pixelformat on the fly
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi,

While trying to get hflip and vflip working for the stv06xx webcam
bridge coupled to the vv6410 sensor I've come across the following
problem.

When flipping the image horizontally, vertically or both, the sensor
pixel ordering changes. In the m5602 driver I was able to compensate
for this in the bridge code. In the stv06xx I don't have this
option. One way of solving this problem is by changing the
pixelformat on the fly, i. e V4L2_PIX_FMT_SGRB8 is the normal
format. When a vertical flip is required, change the format to
V4L2_SBGGR8.

My current understanding of libv4l is that it probes the pixelformat
  upon device open. In order for this to work we would need either
poll the current pixelformat regularly or implement some kind of
notification mechanism upon a flipping request.

What do you think is this the right way to go or is there another
alternative.

Best regards,
Erik
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAknXwXcACgkQN7qBt+4UG0GVfwCfQjWjSu2fdyrgl3BRGlum3cJi
aFAAoKBrKtTezxcnAbmmvM1cLpYOWvvf
=4D37
-----END PGP SIGNATURE-----
