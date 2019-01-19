Return-Path: <SRS0=jH9h=P3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A2D3C61CE4
	for <linux-media@archiver.kernel.org>; Sat, 19 Jan 2019 21:46:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E970C2084C
	for <linux-media@archiver.kernel.org>; Sat, 19 Jan 2019 21:46:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KIL7gCV/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729760AbfASVqR (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 19 Jan 2019 16:46:17 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40229 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729731AbfASVqQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 19 Jan 2019 16:46:16 -0500
Received: by mail-wr1-f66.google.com with SMTP id p4so19104079wrt.7;
        Sat, 19 Jan 2019 13:46:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=fpUvrYP64FN5NwOLadPNJrZi+hirqUYiz7DdK6pImqY=;
        b=KIL7gCV/wV0OYKWmTi0vIGgWBfwVwPXuh/hpba6tpM97R2v5JHGpeOaH8IxH91kPtA
         44dnHxxLYaSv2WVqnqaFIhAgRlBtcXB4VhrsgBHmK6idVhTZHiUA7Tnevpd1svqcmrcb
         cmbIkKpRAslymqP/si93G1yZFG7OnQVfuGbjTLE/ws/JspiPT359VFuHpzOGMeO4zcpJ
         MTcg8IV5YOO/Xws06hKvyioqjbWCxuvJyCnxx26JUJ65rq4k9nY6JZV6gYHbEqTHTzcf
         M7FkEDjM1oPVgLIvMDdo4lknS6/NsBddf1V5V4aRlvvz+d8HWkd3lwtL/PlDP8SL/axS
         Rckg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=fpUvrYP64FN5NwOLadPNJrZi+hirqUYiz7DdK6pImqY=;
        b=lotMEi+MauqQQSkeJV3IDh2qIaFpfXz0Wxr6tJsYULMhSFQZFZNg/U0c9rLdam8+2c
         8BStPj6Q773n6/MMUnrxRlPLHghCsmZ8RBi4+SNFc3gQhLBsNQ3htXa/KdyUP6q9L7Dq
         jXI6gyXQZy09T80uuGNmLYtr/PUrzVsc8NVGvQSdymkSrv21NX+F7gWKku4QEBhRCW38
         GMfRcnbx9wa/i79vjQTuBtGWgFql6ksaGbK42HPKYxRid0uD4ic6P4ypkl9bZoIDIB+K
         gcf5/OVdLMAudCJFADrO3tkki4HGdeg/T2TxbkaTO3EH0/zJipyI43MrNt9FSQt+sOMF
         q+jQ==
X-Gm-Message-State: AJcUukdcg/i4//QOiNTjMd/PxXkjKfjUhzutKcTyTsBCT0T1Zj4vzhtt
        IvDuThKsflP3J3sXd05hLjd1RzOl
X-Google-Smtp-Source: ALg8bN72MvuSG73r3/kdu4VGxvGiDRDrJ02hT/7kAWFn4IVG6MvImj6kMys21OTTK9NaOAWl9IEiaQ==
X-Received: by 2002:a5d:448f:: with SMTP id j15mr20300880wrq.108.1547934373988;
        Sat, 19 Jan 2019 13:46:13 -0800 (PST)
Received: from mappy.world.mentorg.com (sjewanfw1-nat.mentorg.com. [139.181.7.34])
        by smtp.gmail.com with ESMTPSA id o5sm26432048wrw.46.2019.01.19.13.46.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 19 Jan 2019 13:46:13 -0800 (PST)
From:   Steve Longerbeam <slongerbeam@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Steve Longerbeam <slongerbeam@gmail.com>, stable@vger.kernel.org,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 2/4] media: imx: Clear fwnode link struct for each endpoint iteration
Date:   Sat, 19 Jan 2019 13:45:58 -0800
Message-Id: <20190119214600.30897-3-slongerbeam@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190119214600.30897-1-slongerbeam@gmail.com>
References: <20190119214600.30897-1-slongerbeam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

In imx_media_create_csi_of_links(), the 'struct v4l2_fwnode_link' must
be cleared for each endpoint iteration, otherwise if the remote port
has no "reg" property, link.remote_port will not be reset to zero.
This was discovered on the i.MX53 SMD board, since the OV5642 connects
directly to ipu1_csi0 and has a single source port with no "reg"
property.

Fixes: 621b08eabcddb ("media: staging/imx: remove static media link arrays")

Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
Cc: stable@vger.kernel.org
---
 drivers/staging/media/imx/imx-media-of.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/media/imx/imx-media-of.c b/drivers/staging/media/imx/imx-media-of.c
index a01327f6e045..2da81a5af274 100644
--- a/drivers/staging/media/imx/imx-media-of.c
+++ b/drivers/staging/media/imx/imx-media-of.c
@@ -143,15 +143,18 @@ int imx_media_create_csi_of_links(struct imx_media_dev *imxmd,
 				  struct v4l2_subdev *csi)
 {
 	struct device_node *csi_np = csi->dev->of_node;
-	struct fwnode_handle *fwnode, *csi_ep;
-	struct v4l2_fwnode_link link;
 	struct device_node *ep;
-	int ret;
-
-	link.local_node = of_fwnode_handle(csi_np);
-	link.local_port = CSI_SINK_PAD;
 
 	for_each_child_of_node(csi_np, ep) {
+		struct fwnode_handle *fwnode, *csi_ep;
+		struct v4l2_fwnode_link link;
+		int ret;
+
+		memset(&link, 0, sizeof(link));
+
+		link.local_node = of_fwnode_handle(csi_np);
+		link.local_port = CSI_SINK_PAD;
+
 		csi_ep = of_fwnode_handle(ep);
 
 		fwnode = fwnode_graph_get_remote_endpoint(csi_ep);
-- 
2.17.1

