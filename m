Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2420 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750762Ab2HNEMv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Aug 2012 00:12:51 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q7E4CpGj022283
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 14 Aug 2012 00:12:51 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/3] ioctl-number.txt: Remove legacy private ioctl's from media drivers
Date: Tue, 14 Aug 2012 01:12:43 -0300
Message-Id: <1344917565-22396-2-git-send-email-mchehab@redhat.com>
In-Reply-To: <1344917565-22396-1-git-send-email-mchehab@redhat.com>
References: <1344917565-22396-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

None of those drivers use private ioctl's, as they all got converted
to the standard V4L2 ones.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 Documentation/ioctl/ioctl-number.txt | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/Documentation/ioctl/ioctl-number.txt b/Documentation/ioctl/ioctl-number.txt
index 849b771..2152b0e 100644
--- a/Documentation/ioctl/ioctl-number.txt
+++ b/Documentation/ioctl/ioctl-number.txt
@@ -178,7 +178,6 @@ Code  Seq#(hex)	Include File		Comments
 'V'	C0	linux/ivtv.h		conflict!
 'V'	C0	media/davinci/vpfe_capture.h	conflict!
 'V'	C0	media/si4713.h		conflict!
-'V'	C0-CF	drivers/media/video/mxb.h	conflict!
 'W'	00-1F	linux/watchdog.h	conflict!
 'W'	00-1F	linux/wanrouter.h	conflict!
 'W'	00-3F	sound/asound.h		conflict!
@@ -204,8 +203,6 @@ Code  Seq#(hex)	Include File		Comments
 'c'	A0-AF   arch/x86/include/asm/msr.h	conflict!
 'd'	00-FF	linux/char/drm/drm/h	conflict!
 'd'	02-40	pcmcia/ds.h		conflict!
-'d'	10-3F	drivers/media/video/dabusb.h	conflict!
-'d'	C0-CF	drivers/media/video/saa7191.h	conflict!
 'd'	F0-FF	linux/digi1.h
 'e'	all	linux/digi1.h		conflict!
 'e'	00-1F	drivers/net/irda/irtty-sir.h	conflict!
@@ -267,9 +264,7 @@ Code  Seq#(hex)	Include File		Comments
 'v'	00-1F	linux/ext2_fs.h		conflict!
 'v'	00-1F	linux/fs.h		conflict!
 'v'	00-0F	linux/sonypi.h		conflict!
-'v'	C0-DF	media/pwc-ioctl.h	conflict!
 'v'	C0-FF	linux/meye.h		conflict!
-'v'	D0-DF	drivers/media/video/cpia2/cpia2dev.h	conflict!
 'w'	all				CERN SCI driver
 'y'	00-1F				packet based user level communications
 					<mailto:zapman@interlan.net>
-- 
1.7.11.2

