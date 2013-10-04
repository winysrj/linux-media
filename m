Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:3809 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754782Ab3JDOCK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Oct 2013 10:02:10 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH 04/14] tuner-xs2028.c: fix sparse warnings
Date: Fri,  4 Oct 2013 16:01:42 +0200
Message-Id: <1380895312-30863-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1380895312-30863-1-git-send-email-hverkuil@xs4all.nl>
References: <1380895312-30863-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

drivers/media/tuners/tuner-xc2028.c:575:24: warning: cast to restricted __le16
drivers/media/tuners/tuner-xc2028.c:686:21: warning: cast to restricted __le16

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/tuners/tuner-xc2028.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/tuners/tuner-xc2028.c b/drivers/media/tuners/tuner-xc2028.c
index 878d2c4..e287a74 100644
--- a/drivers/media/tuners/tuner-xc2028.c
+++ b/drivers/media/tuners/tuner-xc2028.c
@@ -572,7 +572,7 @@ static int load_firmware(struct dvb_frontend *fe, unsigned int type,
 			return -EINVAL;
 		}
 
-		size = le16_to_cpu(*(__u16 *) p);
+		size = le16_to_cpu(*(__le16 *) p);
 		p += sizeof(size);
 
 		if (size == 0xffff)
@@ -683,7 +683,7 @@ static int load_scode(struct dvb_frontend *fe, unsigned int type,
 		/* 16 SCODE entries per file; each SCODE entry is 12 bytes and
 		 * has a 2-byte size header in the firmware format. */
 		if (priv->firm[pos].size != 14 * 16 || scode >= 16 ||
-		    le16_to_cpu(*(__u16 *)(p + 14 * scode)) != 12)
+		    le16_to_cpu(*(__le16 *)(p + 14 * scode)) != 12)
 			return -EINVAL;
 		p += 14 * scode + 2;
 	}
-- 
1.8.3.2

