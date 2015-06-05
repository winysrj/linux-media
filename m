Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49069 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932407AbbFEO2G (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Jun 2015 10:28:06 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Andy Walls <awalls@md.metrocast.net>
Subject: [PATCH 06/11] [media] ivtv: fix two smatch warnings
Date: Fri,  5 Jun 2015 11:27:39 -0300
Message-Id: <8b4193726e8c8a0b88df2493aca77d61449464ca.1433514004.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1433514004.git.mchehab@osg.samsung.com>
References: <cover.1433514004.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1433514004.git.mchehab@osg.samsung.com>
References: <cover.1433514004.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Smatch currently produces two warnings:
	drivers/media/pci/ivtv/ivtv-fileops.c:901 ivtv_v4l2_close() warn: suspicious bitop condition
	drivers/media/pci/ivtv/ivtv-fileops.c:1026 ivtv_open() warn: suspicious bitop condition

Those are false positives, but it is not hard to get rid of them by
using a different way to evaluate the macro, splitting the logical
boolean evaluation from the bitmap one.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/pci/ivtv/ivtv-driver.h b/drivers/media/pci/ivtv/ivtv-driver.h
index e8b6c7ad2ba9..ee0ef6e48c7d 100644
--- a/drivers/media/pci/ivtv/ivtv-driver.h
+++ b/drivers/media/pci/ivtv/ivtv-driver.h
@@ -830,7 +830,8 @@ static inline int ivtv_raw_vbi(const struct ivtv *itv)
 	do {								\
 		struct v4l2_subdev *__sd;				\
 		__v4l2_device_call_subdevs_p(&(itv)->v4l2_dev, __sd,	\
-			!(hw) || (__sd->grp_id & (hw)), o, f , ##args);	\
+			 !(hw) ? true : (__sd->grp_id & (hw)),		\
+			 o, f, ##args);					\
 	} while (0)
 
 #define ivtv_call_all(itv, o, f, args...) ivtv_call_hw(itv, 0, o, f , ##args)
-- 
2.4.2

