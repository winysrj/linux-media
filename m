Return-path: <linux-media-owner@vger.kernel.org>
Received: from skynet.bu.edu ([128.197.167.9]:37195 "EHLO skynet.bu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755001AbZCABjT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Feb 2009 20:39:19 -0500
Message-ID: <49A9E4F0.1030005@bu.edu>
Date: Sat, 28 Feb 2009 20:29:20 -0500
From: "Erik S. Beiser" <erikb@bu.edu>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH] cx88: Add IR support to pcHDTV HD3000 & HD5500
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

cx88: Add IR support to pcHDTV HD3000 & HD5500

Signed-off-by: Erik S. Beiser <erikb@bu.edu>

---

Idea originally from http://www.pchdtv.com/forum/viewtopic.php?t=1529
I made it into this small patch and added the HD3000 support also, which I have  I've actually
been using this for over a year, updating for new kernel versions.  I'm tired of doing so,
and would like to try and have it merged upstream -- I hope I got all the patch-mechanics
correct.  I just updated and tested it today on 2.6.28.7 vanilla.  Thanks.

--- linux/drivers/media/video/cx88/cx88-input.c.orig	2009-02-20 17:41:27.000000000 -0500
+++ linux/drivers/media/video/cx88/cx88-input.c	2009-02-28 15:58:34.000000000 -0500
@@ -226,6 +226,8 @@ int cx88_ir_init(struct cx88_core *core,
 	case CX88_BOARD_HAUPPAUGE_HVR3000:
 	case CX88_BOARD_HAUPPAUGE_HVR4000:
 	case CX88_BOARD_HAUPPAUGE_HVR4000LITE:
+	case CX88_BOARD_PCHDTV_HD3000:
+	case CX88_BOARD_PCHDTV_HD5500:
 		ir_codes = ir_codes_hauppauge_new;
 		ir_type = IR_TYPE_RC5;
 		ir->sampling = 1;
@@ -466,6 +468,8 @@ void cx88_ir_irq(struct cx88_core *core)
 	case CX88_BOARD_HAUPPAUGE_HVR3000:
 	case CX88_BOARD_HAUPPAUGE_HVR4000:
 	case CX88_BOARD_HAUPPAUGE_HVR4000LITE:
+	case CX88_BOARD_PCHDTV_HD3000:
+	case CX88_BOARD_PCHDTV_HD5500:
 		ircode = ir_decode_biphase(ir->samples, ir->scount, 5, 7);
 		ir_dprintk("biphase decoded: %x\n", ircode);
 		/*


