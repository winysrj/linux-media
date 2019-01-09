Return-Path: <SRS0=iic/=PR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8EDDC43387
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 18:35:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7AEAF21738
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 18:35:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BEqCInHd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727433AbfAISe4 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 9 Jan 2019 13:34:56 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:37635 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726558AbfAISe4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Jan 2019 13:34:56 -0500
Received: by mail-pf1-f195.google.com with SMTP id y126so4062870pfb.4;
        Wed, 09 Jan 2019 10:34:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=osjPUqdHWEFd7eA1Ha/N7D3OMldZEtzxeHaCf4+juWM=;
        b=BEqCInHdIZo76mGuneelfkJJZwhnljPSDRMnAqn0AtRFMDvcJV87srdOBCmGkow4TW
         3pkMd57GY4KeITIjFO0xNze0kTk0gUNrs7SGGYzo2IpJbSwq50jLaJhXMSXUXl0Zai3z
         UpMsgIn6xg/UeQpmVTgSTHFmVpxguyyhpj0rchRh9IxZRxTwRJ0HyoXRFru1kodFrL2p
         ehZL0kfFz45GED12Rnqx2lLbXoBV0MSr3GLo0io6WSRKgeMqA/RpAO7Yn08k+aTKUxLE
         dWBkW2rFheRmrJ5GAaUzH2k2gtWqYO8VoVXH40VpSa7iuQRqzgJ+1ESsmkyYTgWyl/7T
         2+5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=osjPUqdHWEFd7eA1Ha/N7D3OMldZEtzxeHaCf4+juWM=;
        b=e10OqV2TUncPDp/5wh+WksAS0ew2TYJng99GIEx1yso2cuKizU44W9V0BhPeoZ3n87
         Flu6DcMG0NI2hFcu1fDaat4QjJStjrqylfPj/jUEqaJRVTuxNJgkRnxazEkN9ExFwtAp
         GkTULdT8Tgj5oA81UXn+PPNmmcMDeLcI01C+zB9P5sn8IQWpzblw1ytIv1QJ4jEKEJea
         BMyjiqEgO8lPajZBr0gEe4iKeqFDAIPe4d2KNmgg+UT+AmLzuTDkUxdJgaiz6MEfWrJU
         vfXwbKWsC5Yr3frse2wrvYmRYPJhMor8MNlsuCvB4pITHAOXhapjuA7NK6zvZJt4ZN4g
         nYYQ==
X-Gm-Message-State: AJcUukfNfWbDCfx+jdigsO/p7YnNrDcJ6adGWFoK9G9vEwF34c22RASZ
        iHOmrqLJsY4pMoLLy7AOs2SRMuUz
X-Google-Smtp-Source: ALg8bN7zKOA/eZKoF3UmCYb/W4mSJey46OsRjbOthYheoqMJVswwoaXxFSic5Vo+knoy+sAWelyLQQ==
X-Received: by 2002:a63:d547:: with SMTP id v7mr6312414pgi.339.1547058895230;
        Wed, 09 Jan 2019 10:34:55 -0800 (PST)
Received: from majic.sklembedded.com (c-98-210-181-167.hsd1.ca.comcast.net. [98.210.181.167])
        by smtp.googlemail.com with ESMTPSA id b26sm166138437pfe.91.2019.01.09.10.34.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 09 Jan 2019 10:34:54 -0800 (PST)
From:   Steve Longerbeam <slongerbeam@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] media: imx-csi: Input connections to CSI should be optional
Date:   Wed,  9 Jan 2019 10:34:48 -0800
Message-Id: <20190109183448.20923-1-slongerbeam@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Some imx platforms do not have fwnode connections to all CSI input
ports, and should not be treated as an error. This includes the
imx6q SabreAuto, which has no connections to ipu1_csi1 and ipu2_csi0.
Return -ENOTCONN in imx_csi_parse_endpoint() so that v4l2-fwnode
endpoint parsing will not treat an unconnected CSI input port as
an error.

Fixes: c893500a16baf ("media: imx: csi: Register a subdev notifier")

Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
---
 drivers/staging/media/imx/imx-media-csi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
index 4223f8d418ae..30b1717982ae 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -1787,7 +1787,7 @@ static int imx_csi_parse_endpoint(struct device *dev,
 				  struct v4l2_fwnode_endpoint *vep,
 				  struct v4l2_async_subdev *asd)
 {
-	return fwnode_device_is_available(asd->match.fwnode) ? 0 : -EINVAL;
+	return fwnode_device_is_available(asd->match.fwnode) ? 0 : -ENOTCONN;
 }
 
 static int imx_csi_async_register(struct csi_priv *priv)
-- 
2.17.1

