Return-path: <mchehab@pedra>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:56015 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371Ab1AGNrk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Jan 2011 08:47:40 -0500
Date: Fri, 7 Jan 2011 16:46:51 +0300
From: Dan Carpenter <error27@gmail.com>
To: Andreas Oberritter <obi@linuxtv.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch v2] [media] av7110: check for negative array offset
Message-ID: <20110107134651.GH1717@bicker>
References: <20110106194059.GC1717@bicker>
 <4D270A9F.7080104@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D270A9F.7080104@linuxtv.org>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

info->num comes from the user.  It's type int.  If the user passes
in a negative value that would cause memory corruption.

Signed-off-by: Dan Carpenter <error27@gmail.com>
---
V2: change the check instead of making num and unsigned int

diff --git a/drivers/media/dvb/ttpci/av7110_ca.c b/drivers/media/dvb/ttpci/av7110_ca.c
index 122c728..923a8e2 100644
--- a/drivers/media/dvb/ttpci/av7110_ca.c
+++ b/drivers/media/dvb/ttpci/av7110_ca.c
@@ -277,7 +277,7 @@ static int dvb_ca_ioctl(struct file *file, unsigned int cmd, void *parg)
 	{
 		ca_slot_info_t *info=(ca_slot_info_t *)parg;
 
-		if (info->num > 1)
+		if ((unsigned)info->num > 1)
 			return -EINVAL;
 		av7110->ci_slot[info->num].num = info->num;
 		av7110->ci_slot[info->num].type = FW_CI_LL_SUPPORT(av7110->arm_app) ?
