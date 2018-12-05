Return-Path: <SRS0=NzSx=OO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FD70C04EB9
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 19:52:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 46BBD20850
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 19:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1544039540;
	bh=ZPK7ykcKTB3XYMFI6ryEK5KIQ9kgYzfLHFhzXTHrs14=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=YBLi2LI9gCjmmrozNIV5UqeRayWvWNKOc0p8+VGQPBmGg90tVxcGsEtaq+4gKexNv
	 JokqGWIgi7wXDPSMQBi16gm+Jj6x8u/ceLqMtyFMHn6jO03cFO+SfprrkA6gXwNMrO
	 k1dRb8354LTGe1nMgg+llnK/cRI7Fmcu0WMBA8Jw=
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 46BBD20850
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728957AbeLETwO (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 5 Dec 2018 14:52:14 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:44291 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728827AbeLETvV (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 5 Dec 2018 14:51:21 -0500
Received: by mail-ot1-f66.google.com with SMTP id f18so19782086otl.11;
        Wed, 05 Dec 2018 11:51:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MMVAItaPQNomVIDd3mLLrLoJgcsDQny2bzxp0CMIwjk=;
        b=RlNZoPd3/BFVl6EvI5SKMpjCp+oW5YXMbFyjQ3hmWEQKEp6oqQjwTVevQbZvUSGmhB
         C4c7OHH8MwklUOlFtCAhtf+crhCIw3zVhfs/ycIBr3PBouqckbA2mUShYmjIT086HC+r
         S/qGsoXPWquRlHiB2ujunk3sjUzxByJ3GcnViDBmxm6tbML9jxDtVEk9nzw9QPUQU2/e
         17iLeDmuhTfkTSvsWCrnqY1ql7a1K1QnZxkMjV+0YV3WLTq2gZfSLJiVYYd5uW0L986h
         t9B448RBDNYD+QBV4eHY0l/3V3UPNrMsBGfHMWpTeflwg0dw81LqITbvKOzPaokPv4Dq
         NLzw==
X-Gm-Message-State: AA+aEWbYuS9n9BchE1LF8Zt8zvKkysAdhKFnKjBvkXhZIQWeVsZqrh65
        QtV9fDlt8OBEr7NxkWz5XoKx6/qdTA==
X-Google-Smtp-Source: AFSGD/Wkks8ZlwhzX1ZfK3GNF5iT8KhLbG4sAVBmHIc7IP2OU35nIP1Xaq9y2dQJ4CCi0iE0IalSkw==
X-Received: by 2002:a9d:7b42:: with SMTP id f2mr14871732oto.184.1544039480615;
        Wed, 05 Dec 2018 11:51:20 -0800 (PST)
Received: from xps15.herring.priv (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.googlemail.com with ESMTPSA id k13sm25759879otj.19.2018.12.05.11.51.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Dec 2018 11:51:20 -0800 (PST)
From:   Rob Herring <robh@kernel.org>
To:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH] staging: media: imx: Use of_node_name_eq for node name comparisons
Date:   Wed,  5 Dec 2018 13:50:42 -0600
Message-Id: <20181205195050.4759-26-robh@kernel.org>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Convert string compares of DT node names to use of_node_name_eq helper
instead. This removes direct access to the node name pointer.

For instances using of_node_cmp, this has the side effect of now using
case sensitive comparisons. This should not matter for any FDT based
system which this is.

Cc: Steve Longerbeam <slongerbeam@gmail.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-media@vger.kernel.org
Cc: devel@driverdev.osuosl.org
Signed-off-by: Rob Herring <robh@kernel.org>
---
 drivers/staging/media/imx/imx-media-of.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/imx/imx-media-of.c b/drivers/staging/media/imx/imx-media-of.c
index b2e840f96c50..a01327f6e045 100644
--- a/drivers/staging/media/imx/imx-media-of.c
+++ b/drivers/staging/media/imx/imx-media-of.c
@@ -162,7 +162,7 @@ int imx_media_create_csi_of_links(struct imx_media_dev *imxmd,
 		fwnode_property_read_u32(fwnode, "reg", &link.remote_port);
 		fwnode = fwnode_get_next_parent(fwnode);
 		if (is_of_node(fwnode) &&
-		    of_node_cmp(to_of_node(fwnode)->name, "ports") == 0)
+		    of_node_name_eq(to_of_node(fwnode), "ports"))
 			fwnode = fwnode_get_next_parent(fwnode);
 		link.remote_node = fwnode;
 
-- 
2.19.1

