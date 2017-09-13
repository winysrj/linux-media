Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00252a01.pphosted.com ([62.209.51.214]:2430 "EHLO
        mx07-00252a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751399AbdIMPIq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Sep 2017 11:08:46 -0400
Received: from pps.filterd (m0102628.ppops.net [127.0.0.1])
        by mx07-00252a01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v8DF58Bp023539
        for <linux-media@vger.kernel.org>; Wed, 13 Sep 2017 16:08:44 +0100
Received: from mail-wr0-f199.google.com (mail-wr0-f199.google.com [209.85.128.199])
        by mx07-00252a01.pphosted.com with ESMTP id 2cv5pysxkj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
        for <linux-media@vger.kernel.org>; Wed, 13 Sep 2017 16:08:44 +0100
Received: by mail-wr0-f199.google.com with SMTP id d6so490219wrd.7
        for <linux-media@vger.kernel.org>; Wed, 13 Sep 2017 08:08:44 -0700 (PDT)
From: Dave Stevenson <dave.stevenson@raspberrypi.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Eric Anholt <eric@anholt.net>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        linux-media@vger.kernel.org, linux-rpi-kernel@lists.infradead.org,
        devicetree@vger.kernel.org
Cc: Dave Stevenson <dave.stevenson@raspberrypi.org>
Subject: [PATCH v2 1/4] [media] v4l2-common: Add helper function for fourcc to string
Date: Wed, 13 Sep 2017 16:07:46 +0100
Message-Id: <e6dfbe4afd3f1db4c3f8a81c0813dc418896f5e1.1505314390.git.dave.stevenson@raspberrypi.org>
In-Reply-To: <cover.1505140980.git.dave.stevenson@raspberrypi.org>
References: <cover.1505140980.git.dave.stevenson@raspberrypi.org>
In-Reply-To: <cover.1505314390.git.dave.stevenson@raspberrypi.org>
References: <cover.1505314390.git.dave.stevenson@raspberrypi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

New helper function char *v4l2_fourcc2s(u32 fourcc, char *buf)
that converts a fourcc into a nice printable version.

Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.org>
---
 drivers/media/v4l2-core/v4l2-common.c | 18 ++++++++++++++++++
 include/media/v4l2-common.h           |  3 +++
 2 files changed, 21 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-common.c b/drivers/media/v4l2-core/v4l2-common.c
index a5ea1f5..0219895 100644
--- a/drivers/media/v4l2-core/v4l2-common.c
+++ b/drivers/media/v4l2-core/v4l2-common.c
@@ -405,3 +405,21 @@ void v4l2_get_timestamp(struct timeval *tv)
 	tv->tv_usec = ts.tv_nsec / NSEC_PER_USEC;
 }
 EXPORT_SYMBOL_GPL(v4l2_get_timestamp);
+
+char *v4l2_fourcc2s(u32 fourcc, char *buf)
+{
+	buf[0] = fourcc & 0x7f;
+	buf[1] = (fourcc >> 8) & 0x7f;
+	buf[2] = (fourcc >> 16) & 0x7f;
+	buf[3] = (fourcc >> 24) & 0x7f;
+	if (fourcc & (1 << 31)) {
+		buf[4] = '-';
+		buf[5] = 'B';
+		buf[6] = 'E';
+		buf[7] = '\0';
+	} else {
+		buf[4] = '\0';
+	}
+	return buf;
+}
+EXPORT_SYMBOL_GPL(v4l2_fourcc2s);
diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
index aac8b7b..5b0fff9 100644
--- a/include/media/v4l2-common.h
+++ b/include/media/v4l2-common.h
@@ -264,4 +264,7 @@ const struct v4l2_frmsize_discrete *v4l2_find_nearest_format(
 
 void v4l2_get_timestamp(struct timeval *tv);
 
+#define V4L2_FOURCC_MAX_SIZE 8
+char *v4l2_fourcc2s(u32 fourcc, char *buf);
+
 #endif /* V4L2_COMMON_H_ */
-- 
2.7.4
