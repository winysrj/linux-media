Return-Path: <SRS0=+Qw+=RE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 067F0C43381
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 23:27:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA44B2083E
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 23:27:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X9uoAXRf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726502AbfCAX11 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 1 Mar 2019 18:27:27 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:35808 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbfCAX11 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Mar 2019 18:27:27 -0500
Received: by mail-pg1-f194.google.com with SMTP id e17so10093714pgd.2;
        Fri, 01 Mar 2019 15:27:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=CxMSec5AAtG8cchuHxOJ8OypYLZfqDq4LNUDOOaJjUA=;
        b=X9uoAXRfwenhnt8LTzzikS/SKYVE0drhKmZ7pka/+x2jl8s1SM2JZtrLEpdlpgJScn
         Sx3Rq2uDsJY3NyyMcQcjDicPPFsknNYothU0A8b+wasMh/acgO/mn20MYLcifvaXrG90
         v8/VQ/hJd9VwU8o54i8E51mBXyYRl3DQB11H+GmDc0hiKuBYpqTUQECLqj5ns+XiwhPV
         Pxl+yavAl/BRelnaHBS1cwzHkwvU0sDCfjTdhaHinGN2XP21IXULGr4Y57gmw2+DVo2B
         gaWX63qa9rL77FhoAlYOjKdFvdBp5pq38vAeNsG/rJThg1Poe+6ilTl7ugi8DVwG4lMl
         /lbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=CxMSec5AAtG8cchuHxOJ8OypYLZfqDq4LNUDOOaJjUA=;
        b=hWI7GFVglsj2fLqdtcTotjseb3ASLGBDVrXdQboOgjfVgnftpjCOn/fsooeQkKCzvU
         /vQGdbip7cVMSYDOgQbdevVuWXTnP16JVBu3Z7U6sWK89z1IeUZXgFf2DTrSFxfuZaBn
         pQLvOnZr6ejbXy//LP++oMaNRH0lRuvn4rYvwVL+TiIWdjUBHAYgAVugGFwko6hs4FGq
         py2Iq2qSYg72Gl7yd7vigLDen2fa9M7hRhdbp+ESfCqyk2wYvyr5o8qWLEu807GrswhI
         pMLHVae9+VjsONPAuNUA4aSp+I2K/R1LURSa1E7RLoWllO3+lntXEAOIWhh0Fv4l54mg
         KtQQ==
X-Gm-Message-State: AHQUAuaTmH73ONE0e8pcrsh8fjAgR6Gb/JK6adxP7CPfhneupFQgXAB4
        WnUFmzXiZfKRzFBNtrYNXaiyLC0e
X-Google-Smtp-Source: AHgI3IYnUExlCtfQo+7EuyNOsLopWhv9SZJpICuL6fJBoSM3Bh2DEo+aV9yh3Kk18iTZe8BDhOXI/Q==
X-Received: by 2002:a62:bd09:: with SMTP id a9mr8119475pff.61.1551482845824;
        Fri, 01 Mar 2019 15:27:25 -0800 (PST)
Received: from majic.sklembedded.com (c-73-202-231-77.hsd1.ca.comcast.net. [73.202.231.77])
        by smtp.googlemail.com with ESMTPSA id j197sm38618108pgc.76.2019.03.01.15.27.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 01 Mar 2019 15:27:24 -0800 (PST)
From:   Steve Longerbeam <slongerbeam@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Tim Harvey <tharvey@gateworks.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] media: imx: vdic: Fix wrong CSI group ID
Date:   Fri,  1 Mar 2019 15:27:17 -0800
Message-Id: <20190301232717.4125-1-slongerbeam@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The i.MX7 capture support forgot to change the group ID for the CSI
to the IPU CSI in VDIC sub-device, it was left at the i.MX7 CSI
group ID.

Fixes: 67673ed55084 ("media: staging/imx: rearrange group id to take in account IPU")

Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
---
 drivers/staging/media/imx/imx-media-vdic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/imx/imx-media-vdic.c b/drivers/staging/media/imx/imx-media-vdic.c
index 2808662e2597..d36f6936c365 100644
--- a/drivers/staging/media/imx/imx-media-vdic.c
+++ b/drivers/staging/media/imx/imx-media-vdic.c
@@ -744,7 +744,7 @@ static int vdic_link_setup(struct media_entity *entity,
 		remote_sd = media_entity_to_v4l2_subdev(remote->entity);
 
 		/* direct pad must connect to a CSI */
-		if (!(remote_sd->grp_id & IMX_MEDIA_GRP_ID_CSI) ||
+		if (!(remote_sd->grp_id & IMX_MEDIA_GRP_ID_IPU_CSI) ||
 		    remote->index != CSI_SRC_PAD_DIRECT) {
 			ret = -EINVAL;
 			goto out;
-- 
2.17.1

