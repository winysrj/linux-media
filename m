Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:47831 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751322AbZGTOVx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jul 2009 10:21:53 -0400
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n6KELrDg018342
	for <linux-media@vger.kernel.org>; Mon, 20 Jul 2009 10:21:53 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n6KELqC2009028
	for <linux-media@vger.kernel.org>; Mon, 20 Jul 2009 10:21:52 -0400
Received: from xavier.bos.redhat.com (xavier.bos.redhat.com [10.16.16.50])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id n6KELqIi030862
	for <linux-media@vger.kernel.org>; Mon, 20 Jul 2009 10:21:52 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Subject: [PATCH] dvb: make digital side of pcHDTV HD-3000 functional again
Date: Mon, 20 Jul 2009 10:20:47 -0400
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907201020.47581.jarod@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The dvb side of the pcHDTV HD-3000 doesn't work since at least 2.6.29.
The crux of the problem is this: the HD-3000's device ID matches the
modalias for the cx8800 driver, but not the cx8802 driver, which is
required to set up the digital side of the card. You can load up
cx8802 just fine, but cx88-dvb falls on its face, because the call
to cx8802_register_driver() attempts to traverse the cx8802_devlist,
which is completely empty. The list is only populated by the
cx8802_probe() function, which never gets called for the HD-3000, as
its device ID isn't matched by the cx8802 driver, so you wind up
getting an -ENODEV return from cx8802_register_driver() back to
cx88-dvb, and as a result, no digital side of the card for you.

Long story short, by simply adding a vendor/device/subvendor/subdevice
block to cx88-mpeg.c, cx8802_probe() will run, the cx88-2_devlist
will get populated, cx8802_register_driver() won't fail, and cx88-dvb
can actually load up all the way on this card. Channel scanning is
of course currently failing for me still (works fine on several other
cards I have handy), but that's another problem for another day...

There might be a Better Way to do this, and I'm open to suggestions
and willing to try them out, but this Works For Me.

Signed-off-by: Jarod Wilson <jarod@redhat.com>

diff -r d754a2d5a376 linux/drivers/media/video/cx88/cx88-mpeg.c
--- a/linux/drivers/media/video/cx88/cx88-mpeg.c	Wed Jul 15 07:28:02 2009 -0300
+++ b/linux/drivers/media/video/cx88/cx88-mpeg.c	Sat Jul 18 02:07:37 2009 -0400
@@ -893,6 +893,11 @@
 		.device       = 0x8802,
 		.subvendor    = PCI_ANY_ID,
 		.subdevice    = PCI_ANY_ID,
+	},{	/* pcHDTV HD-3000 */
+		.vendor       = 0x14f1,
+		.device       = 0x8800,
+		.subvendor    = 0x7063,
+		.subdevice    = 0x3000,
 	},{
 		/* --- end of list --- */
 	}

-- 
Jarod Wilson
jarod@redhat.com
