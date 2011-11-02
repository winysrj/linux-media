Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2099 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752306Ab1KBLqW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 2 Nov 2011 07:46:22 -0400
Date: Wed, 2 Nov 2011 09:45:08 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: devel@driverdev.osuosl.org, Greg KH <gregkh@suse.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 3/3] staging/Makefile: Don't compile a media driver there
Message-ID: <20111102094508.5a4eded5@redhat.com>
In-Reply-To: <cover.1320233265.git.mchehab@redhat.com>
References: <cover.1320233265.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Otherwise, with driver as "y", compilation will break:

drivers/staging/media/as102/built-in.o: In function `as10x_cmd_get_demod_stats':
/home/v4l/work_trees/linux-next/drivers/staging/media/as102/as10x_cmd.c:306: multiple definition of `as10x_cmd_get_demod_stats'
drivers/staging/media/built-in.o:/home/v4l/work_trees/linux-next/drivers/staging/media/as102/as10x_cmd.c:306: first defined here
drivers/staging/media/as102/built-in.o:(.data+0x88): multiple definition of `as102_st_fw1'
drivers/staging/media/built-in.o:(.data+0x88): first defined here

as the same driver is already at staging/media/Makefile.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
index cf92bc1..c1a60ef 100644
--- a/drivers/staging/Makefile
+++ b/drivers/staging/Makefile
@@ -58,4 +58,3 @@ obj-$(CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4)	+= ste_rmi4/
 obj-$(CONFIG_DRM_PSB)		+= gma500/
 obj-$(CONFIG_INTEL_MEI)		+= mei/
 obj-$(CONFIG_MFD_NVEC)		+= nvec/
-obj-$(CONFIG_DVB_AS102)		+= media/as102/
-- 
1.7.6.4

