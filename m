Return-Path: <SRS0=tJec=Q3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9E23C43381
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 23:53:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 76D5920657
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 23:53:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N4ODwXTA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726412AbfBTXxp (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Feb 2019 18:53:45 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:33137 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726282AbfBTXxn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Feb 2019 18:53:43 -0500
Received: by mail-pf1-f195.google.com with SMTP id c123so12760032pfb.0;
        Wed, 20 Feb 2019 15:53:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Z2X4Y/BmuGKn49aohchku7mm3X+nWciJE2mI8ws/RbQ=;
        b=N4ODwXTA3L+nUzOkH4NKslgcYSL1z1qV9elk/1jdDTmq/P0qbQpw1RysS/AGIHoZ6m
         S5rXdSZ7qWlbzFGYU3pntzzVm34uE44t2jmyuqux52w+oQ2/JPilHZnQONaF3iG39D33
         hpiM8V4QGLyraJkp2L6ah6kj9VoFEp5IKlU1J+hwAbYsbdILzSXoI8fBumupl4YIT3aR
         aXogZYUBg2kfk/PemCWTrlAybehobrE9LcmOcD+6/wLveFTRA8JRVzOi8DOqumKZ6JE5
         d3DM8IfBL151M59vCg6XbLcVKmHMmXsUG8SU3ydFUoJqH6MXtWFyIznM/Q5O8gW9/wVw
         Y9wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Z2X4Y/BmuGKn49aohchku7mm3X+nWciJE2mI8ws/RbQ=;
        b=okrz+5I0xZlB8zSVEEawQFtBvGqtG/EU+FnxRFlfINNRrYtdtaxsLHxKHXxI/C36d8
         a+4f8l8Zsy/rbAzmBYw+qQtFMRs4CTldVGs3Upjf7bq44fVtVBlMBkhCwq2/QZH7rjmM
         RsKTiYJ2ut6vasn52f4+7byuaz6YttGIn8ObbmAmffFV5DQxqDYr/im9B/svewtJNW9z
         IkNHqREwPzMAcDySOO4CFKKCTqdMzx7tbELD9uFXln89chRt1spQ6a2341DIeeBpISb2
         Jdvg8rPSPYtXGUXnjf9BHnV24yYAlpNP7DkBIFww6cLFItYqf0hmBDaZ04P3YUsuBONP
         QVpg==
X-Gm-Message-State: AHQUAuaaLdEc1kFhNtB1oGPLMIBDH+8vDUa1hY4Tgdj/W8D6wk5ktv52
        O3N2KiFoQ8NLmQiLYn2PQjQnPHKY
X-Google-Smtp-Source: AHgI3IanX296S54WcYhjb3mndB9odqjViqxJlSR7jaepQhh6xs5IJCKenFq1AdALbEKbKw8EucHW6A==
X-Received: by 2002:a65:6654:: with SMTP id z20mr22806069pgv.390.1550706821773;
        Wed, 20 Feb 2019 15:53:41 -0800 (PST)
Received: from majic.sklembedded.com (c-73-202-231-77.hsd1.ca.comcast.net. [73.202.231.77])
        by smtp.googlemail.com with ESMTPSA id v15sm25530158pgf.75.2019.02.20.15.53.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 Feb 2019 15:53:41 -0800 (PST)
From:   Steve Longerbeam <slongerbeam@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Steve Longerbeam <slongerbeam@gmail.com>, stable@vger.kernel.org,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 2/4] media: imx: Clear fwnode link struct for each endpoint iteration
Date:   Wed, 20 Feb 2019 15:53:30 -0800
Message-Id: <20190220235332.15984-3-slongerbeam@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190220235332.15984-1-slongerbeam@gmail.com>
References: <20190220235332.15984-1-slongerbeam@gmail.com>
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
index 03446335ac03..a26bdeb1af34 100644
--- a/drivers/staging/media/imx/imx-media-of.c
+++ b/drivers/staging/media/imx/imx-media-of.c
@@ -145,15 +145,18 @@ int imx_media_create_csi_of_links(struct imx_media_dev *imxmd,
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

