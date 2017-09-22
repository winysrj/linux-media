Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:46533
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752166AbdIVVrM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Sep 2017 17:47:12 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 1/8] media: tuner-types: add kernel-doc markups for struct tunertype
Date: Fri, 22 Sep 2017 18:46:59 -0300
Message-Id: <375a66118102a2c6a8bf4d2619b0ab818d320604.1506116720.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1506116720.git.mchehab@s-opensource.com>
References: <cover.1506116720.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1506116720.git.mchehab@s-opensource.com>
References: <cover.1506116720.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This struct is lacking documentation. Add it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 include/media/tuner-types.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/include/media/tuner-types.h b/include/media/tuner-types.h
index aed539068d2d..55bc14093c0f 100644
--- a/include/media/tuner-types.h
+++ b/include/media/tuner-types.h
@@ -170,6 +170,21 @@ struct tuner_params {
 	struct tuner_range *ranges;
 };
 
+/**
+ * struct tunertype - describes the known tuners.
+ *
+ * @name:	string with the tuner's name.
+ * @count:	size of &struct tuner_params array.
+ * @params:	pointer to &struct tuner_params array.
+ *
+ * @min:	minimal tuner frequency, in 62.5 kHz step.
+ *		should be multiplied to 16 to convert to MHz.
+ * @max:	minimal tuner frequency, in 62.5 kHz step.
+ *		Should be multiplied to 16 to convert to MHz.
+ * @stepsize:	frequency step, in Hz.
+ * @initdata:	optional byte sequence to initialize the tuner.
+ * @sleepdata:	optional byte sequence to power down the tuner.
+ */
 struct tunertype {
 	char *name;
 	unsigned int count;
-- 
2.13.5
