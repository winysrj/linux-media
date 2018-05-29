Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:56551 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751091AbeE2IsY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 May 2018 04:48:24 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: niklas.soderlund@ragnatech.se, laurent.pinchart@ideasonboard.com
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH v5 04/10] media: rcar-vin: Cleanup notifier in error path
Date: Tue, 29 May 2018 10:48:02 +0200
Message-Id: <1527583688-314-5-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1527583688-314-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1527583688-314-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

During the notifier initialization, memory for the list of associated async
subdevices is reserved during the fwnode endpoint parsing from the v4l2-async
framework. If the notifier registration fails, that memory should be released
and the notifier 'cleaned up'.

Catch the notifier registration error and perform the cleanup both for the
group and the parallel notifiers.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>

---
v5:
- new patch

---
 drivers/media/platform/rcar-vin/rcar-core.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index d3aadf3..f7a28e9 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -573,10 +573,15 @@ static int rvin_parallel_graph_init(struct rvin_dev *vin)
 	ret = v4l2_async_notifier_register(&vin->v4l2_dev, &vin->notifier);
 	if (ret < 0) {
 		vin_err(vin, "Notifier registration failed\n");
-		return ret;
+		goto error_notifier_cleanup;
 	}

 	return 0;
+
+error_notifier_cleanup:
+	v4l2_async_notifier_cleanup(&vin->group->notifier);
+
+	return ret;
 }

 /* -----------------------------------------------------------------------------
@@ -775,10 +780,15 @@ static int rvin_mc_parse_of_graph(struct rvin_dev *vin)
 					   &vin->group->notifier);
 	if (ret < 0) {
 		vin_err(vin, "Notifier registration failed\n");
-		return ret;
+		goto error_notifier_cleanup;
 	}

 	return 0;
+
+error_notifier_cleanup:
+	v4l2_async_notifier_cleanup(&vin->group->notifier);
+
+	return ret;
 }

 static int rvin_mc_init(struct rvin_dev *vin)
--
2.7.4
