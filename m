Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54776 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753566AbbFHTyd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Jun 2015 15:54:33 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-api@vger.kernel.org
Subject: [PATCH 22/26] [media] frontend: Fix a typo at the comments
Date: Mon,  8 Jun 2015 16:54:06 -0300
Message-Id: <0a02f00e9330b9f14a46a7b87195f8c151ad2bcf.1433792665.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1433792665.git.mchehab@osg.samsung.com>
References: <cover.1433792665.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1433792665.git.mchehab@osg.samsung.com>
References: <cover.1433792665.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The description of struct dtv_stats has a spmall typo:
	FE_SCALE_DECIBELS instead of FE_SCALE_DECIBEL

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/include/uapi/linux/dvb/frontend.h b/include/uapi/linux/dvb/frontend.h
index 46c7fd1143a5..0380e62fc8b2 100644
--- a/include/uapi/linux/dvb/frontend.h
+++ b/include/uapi/linux/dvb/frontend.h
@@ -435,13 +435,13 @@ enum fecap_scale_params {
  *
  * In other words, for ISDB, those values should be filled like:
  *	u.st.stat.svalue[0] = global statistics;
- *	u.st.stat.scale[0] = FE_SCALE_DECIBELS;
+ *	u.st.stat.scale[0] = FE_SCALE_DECIBEL;
  *	u.st.stat.value[1] = layer A statistics;
  *	u.st.stat.scale[1] = FE_SCALE_NOT_AVAILABLE (if not available);
  *	u.st.stat.svalue[2] = layer B statistics;
- *	u.st.stat.scale[2] = FE_SCALE_DECIBELS;
+ *	u.st.stat.scale[2] = FE_SCALE_DECIBEL;
  *	u.st.stat.svalue[3] = layer C statistics;
- *	u.st.stat.scale[3] = FE_SCALE_DECIBELS;
+ *	u.st.stat.scale[3] = FE_SCALE_DECIBEL;
  *	u.st.len = 4;
  */
 struct dtv_stats {
-- 
2.4.2

