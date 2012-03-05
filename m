Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34479 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755267Ab2CEJei (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Mar 2012 04:34:38 -0500
Date: Mon, 5 Mar 2012 03:34:30 -0600
From: Jonathan Nieder <jrnieder@gmail.com>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Skippy le Grand Gourou <lecotegougdelaforce@free.fr>,
	linux-media@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [bug?] ov519 fails to handle Hercules Deluxe webcam
Message-ID: <20120305093430.GA14386@burratino>
References: <20120304223239.22117.54556.reportbug@deepthought>
 <20120305003801.GB27427@burratino>
 <20120305102101.652b46e7@tele>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="VS++wcV0S1rZb1Fb"
Content-Disposition: inline
In-Reply-To: <20120305102101.652b46e7@tele>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--VS++wcV0S1rZb1Fb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Jean-Francois Moine wrote:
>> Skippy le Grand Gourou wrote[1]:

>>> Hercules Deluxe USB webcam won't work, see the end of the kernel
>>> log.
>> [...]
>>> [521041.808976] gspca: probing 05a9:4519
>>> [521042.469094] ov519: I2C synced in 3 attempt(s)
>>> [521042.469097] ov519: starting OV7xx0 configuration
>>> [521042.469793] ov519: Unknown image sensor version: 2
>>> [521042.469795] ov519: Failed to configure OV7xx0
[...]
>>> [528513.526783] gspca: main v2.7.0 registered
>>> [528513.527299] gspca: probing 05a9:4519
>>> [528514.190995] ov519: I2C synced in 3 attempt(s)
>>> [528514.190998] ov519: starting OV7xx0 configuration
>>> [528514.192570] ov519: Sensor is an OV7610
[...]
> The git commit b877a9a7fb0 (gspca - ov519: Fix sensor detection
> problems) may have fix this problem.

Oh!  Yep, the symptoms match well --- sorry I missed it.

> To be sure, try the gspca test version from my web site.

Skippy, assuming that works (and I expect it would), could you try the
attached patch against 2.6.32.y?  It works like this:

 0. Prerequisites:
	apt-get install git build-essential

 1. Get the kernel, if you don't already have it:
	git clone \
	 git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git

 2. Fetch point releases:
	cd linux
	git remote add -f stable \
	 git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git

 3. Try the 2.6.32.y branch:

	git checkout stable/linux-2.6.32.y
	cp /boot/config-$(uname -r) .config; # current configuration
	make localmodconfig; # optional: minimize configuration
	make; # optionally with -j<num> for parallel build
	fakeroot -u make deb-pkg
	dpkg -i ../<name of package>
	reboot

    "make localmodconfig" works by leaving out drivers whose modules are
    not currently loaded, so take care to make sure the gspca and ov519
    modules are built.  ("make nconfig" customizes the configuration.)

    Hopefully this kernel reproduces the bug.

 4. See if the patch helps:

	git am -3sc <path to patch>
	make; # maybe with -j4
	fakeroot -u make deb-pkg
	dpkg -i ../<name of package>
	reboot

Hopeful,
Jonathan

--VS++wcV0S1rZb1Fb
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="media-gspca-ov519-Fix-sensor-detection-problems.patch"
Content-Transfer-Encoding: quoted-printable

=46rom: Jean-Fran=C3=A7ois Moine <moinejf@free.fr>
Date: Sun, 3 Jul 2011 05:17:27 -0300
Subject: [media] gspca - ov519: Fix sensor detection problems

commit b877a9a7fb00d96bae4ab49c69f1be65b3e87e61 upstream.

The sensor of some webcams could not be detected due to timing problems
in sensor register reading. This patch adds bridge register readings
before sensor register reading.

Signed-off-by: Jean-Fran=C3=A7ois Moine <moinejf@free.fr>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
---
 drivers/media/video/gspca/ov519.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/video/gspca/ov519.c b/drivers/media/video/gspca/=
ov519.c
index e16557819782..7a31e432d038 100644
--- a/drivers/media/video/gspca/ov519.c
+++ b/drivers/media/video/gspca/ov519.c
@@ -1314,11 +1314,14 @@ static int ov518_i2c_r(struct sd *sd, __u8 reg)
 	rc =3D reg_w(sd, R518_I2C_CTL, 0x03);
 	if (rc < 0)
 		return rc;
+	reg_r8(sd, R518_I2C_CTL);
=20
 	/* Initiate 2-byte read cycle */
 	rc =3D reg_w(sd, R518_I2C_CTL, 0x05);
 	if (rc < 0)
 		return rc;
+	reg_r8(sd, R518_I2C_CTL);
+
 	value =3D reg_r(sd, R51x_I2C_DATA);
 	PDEBUG(D_USBI, "i2c [0x%02X] -> 0x%02X", reg, value);
 	return value;
--=20
1.7.9.2


--VS++wcV0S1rZb1Fb--
