Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:46935
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752041AbdIANY5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Sep 2017 09:24:57 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH v2 27/27] media: dst_ca: remove CA_SET_DESCR boilerplate
Date: Fri,  1 Sep 2017 10:24:49 -0300
Message-Id: <7c3a5b3fee1e681d2e0fb1d68862cce7c207c986.1504272067.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504272067.git.mchehab@s-opensource.com>
References: <cover.1504272067.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504272067.git.mchehab@s-opensource.com>
References: <cover.1504272067.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This ioctl is not implemented at dst_ca driver. There's just
a boilerplate code there. Remove it, as it is unlikely that
anyone would implement it those days.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/pci/bt8xx/dst_ca.c | 17 -----------------
 1 file changed, 17 deletions(-)

diff --git a/drivers/media/pci/bt8xx/dst_ca.c b/drivers/media/pci/bt8xx/dst_ca.c
index 5ebb86f22935..530b3e9764ce 100644
--- a/drivers/media/pci/bt8xx/dst_ca.c
+++ b/drivers/media/pci/bt8xx/dst_ca.c
@@ -57,13 +57,6 @@ static unsigned int verbose = 5;
 module_param(verbose, int, 0644);
 MODULE_PARM_DESC(verbose, "verbose startup messages, default is 1 (yes)");
 
-/*	Need some more work	*/
-static int ca_set_slot_descr(void)
-{
-	/*	We could make this more graceful ?	*/
-	return -EOPNOTSUPP;
-}
-
 static void put_command_and_length(u8 *data, int command, int length)
 {
 	data[0] = (command >> 16) & 0xff;
@@ -615,16 +608,6 @@ static long dst_ca_ioctl(struct file *file, unsigned int cmd, unsigned long ioct
 		}
 		dprintk(verbose, DST_CA_INFO, 1, " -->CA_GET_DESCR_INFO Success !");
 		break;
-	case CA_SET_DESCR:
-		dprintk(verbose, DST_CA_INFO, 1, " Setting descrambler");
-		result = ca_set_slot_descr();
-		if (result < 0) {
-			dprintk(verbose, DST_CA_ERROR, 1, " -->CA_SET_DESCR Failed !");
-			result = -1;
-			goto free_mem_and_exit;
-		}
-		dprintk(verbose, DST_CA_INFO, 1, " -->CA_SET_DESCR Success !");
-		break;
 	default:
 		result = -EOPNOTSUPP;
 	}
-- 
2.13.5
