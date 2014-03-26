Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:55179 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755829AbaCZVLA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Mar 2014 17:11:00 -0400
Received: by mail-wi0-f173.google.com with SMTP id f8so5188807wiw.0
        for <linux-media@vger.kernel.org>; Wed, 26 Mar 2014 14:10:59 -0700 (PDT)
From: James Hogan <james.hogan@imgtec.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, James Hogan <james.hogan@imgtec.com>,
	=?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>
Subject: [PATCH 2/3] rc-main: Limit to a single wakeup protocol group
Date: Wed, 26 Mar 2014 21:08:32 +0000
Message-Id: <1395868113-17950-3-git-send-email-james.hogan@imgtec.com>
In-Reply-To: <1395868113-17950-1-git-send-email-james.hogan@imgtec.com>
References: <1395868113-17950-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Limit the enabled wakeup protocols to be within a protocol group, as
defined by the proto_names array. For example this prevents the
selection of both rc-5 and nec, while allowing rc-5 alone (which
encompasses both normal rc-5 and rc-5x).

It doesn't usually make sense to enable more than one wakeup protocol
since only a single protocol can usually be used for wakeup at a time,
and doing so with encode based wakeup will result in an arbitrary
protocol being used if multiple are possible.

Reported-by: Antti Seppälä <a.seppala@gmail.com>
Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Antti Seppälä <a.seppala@gmail.com>
---
Sorry it took a little while to get around to submitting this.
---
 drivers/media/rc/rc-main.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index e067fee..79d1060 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -979,6 +979,19 @@ static ssize_t store_protocols(struct device *device,
 		goto out;
 	}
 
+	if (fattr->type == RC_FILTER_WAKEUP) {
+		/* A proto_names entry must cover enabled wakeup protocols */
+		for (i = 0; i < ARRAY_SIZE(proto_names); i++)
+			if (type & proto_names[i].type &&
+			    !(type & ~proto_names[i].type))
+				break;
+		if (i == ARRAY_SIZE(proto_names)) {
+			IR_dprintk(1, "Multiple distinct wakeup protocols\n");
+			ret = -EINVAL;
+			goto out;
+		}
+	}
+
 	change_protocol = (fattr->type == RC_FILTER_NORMAL)
 		? dev->change_protocol : dev->change_wakeup_protocol;
 	if (change_protocol) {
-- 
1.8.3.2

