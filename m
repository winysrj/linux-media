Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:59621 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812AbaIKS3d (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Sep 2014 14:29:33 -0400
Received: from mfilter4-d.gandi.net (mfilter4-d.gandi.net [217.70.178.134])
	by relay5-d.mail.gandi.net (Postfix) with ESMTP id 38A0E41C06C
	for <linux-media@vger.kernel.org>; Thu, 11 Sep 2014 20:29:31 +0200 (CEST)
Received: from relay5-d.mail.gandi.net ([217.70.183.197])
	by mfilter4-d.gandi.net (mfilter4-d.gandi.net [10.0.15.180]) (amavisd-new, port 10024)
	with ESMTP id qmBip3cosMLf for <linux-media@vger.kernel.org>;
	Thu, 11 Sep 2014 20:29:29 +0200 (CEST)
Received: from nuvo (mon69-7-83-155-44-161.fbx.proxad.net [83.155.44.161])
	(Authenticated sender: hadess@hadess.net)
	by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id C03F241C061
	for <linux-media@vger.kernel.org>; Thu, 11 Sep 2014 20:29:29 +0200 (CEST)
Message-ID: <1410460155.32328.26.camel@hadess.net>
Subject: OV5648 and GC2235 camera drivers?
From: Bastien Nocera <hadess@hadess.net>
To: linux-media@vger.kernel.org
Date: Thu, 11 Sep 2014 20:29:15 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hey,

I have this tablet:
http://www.onda-tablet.com/onda-v975w-quad-core-win-8-tablet-9-7-inch-retina-screen-ram-2gb-wifi-32gb.html
which according to its BIOS has a GC2235 front camera and a OV5648 rear
camera.

The DSDT for the device is here:
https://bugzilla.kernel.org/attachment.cgi?id=149331

Look for "Device (CAM2)" for the OV5648 camera, and "Device (CAM3)" for
the GC2235 camera.

It looks like there are Android drivers for those devices:
https://github.com/NoelMacwan/Kernel-C6806-KOT49H.S2.2052/blob/master/drivers/media/platform/msm/camera_v2/sensor/ov5648.c
and:
http://dl.linux-sunxi.org/SDK/A80/A80_SDK_20140728_stripped/lichee/linux-3.4/drivers/media/video/sunxi-vfe/device/gc2235.c

I have no idea which framework the first one is using, but the second
one looks like it could be used on an upstream Linux kernel (with some
cleaning up...).

Does anyone know if somebody is working on support for those drivers,
either upstream or in a staging tree somewhere?

Cheers

