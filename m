Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay10.mail.gandi.net ([217.70.178.230]:35123 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754324AbeFLJns (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Jun 2018 05:43:48 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: niklas.soderlund@ragnatech.se, laurent.pinchart@ideasonboard.com
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH v6 04/10] media: rcar-vin: Cleanup notifier in error path
Date: Tue, 12 Jun 2018 11:43:26 +0200
Message-Id: <1528796612-7387-5-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1528796612-7387-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1528796612-7387-1-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

During the notifier initialization, memory for the list of associated async
subdevices is reserved during the fwnode endpoint parsing from the v4l2-async
framework. If the notifier registration fails, that memory should be released
and the notifier 'cleaned up'.

Catch the notifier registration error and perform the cleanup both for the
group and the parallel notifiers.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
Acked-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

---
v5 -> v6:
- replace goto call with direct 'v4l2_async_notifier_cleanup()'
---
 drivers/media/platform/rcar-vin/rcar-core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index 72ffd19..b00387f 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -571,6 +571,7 @@ static int rvin_parallel_graph_init(struct rvin_dev *vin)
 	ret = v4l2_async_notifier_register(&vin->v4l2_dev, &vin->notifier);
 	if (ret < 0) {
 		vin_err(vin, "Notifier registration failed\n");
+		v4l2_async_notifier_cleanup(&vin->group->notifier);
 		return ret;
 	}

@@ -773,6 +774,7 @@ static int rvin_mc_parse_of_graph(struct rvin_dev *vin)
 					   &vin->group->notifier);
 	if (ret < 0) {
 		vin_err(vin, "Notifier registration failed\n");
+		v4l2_async_notifier_cleanup(&vin->group->notifier);
 		return ret;
 	}

--
2.7.4
