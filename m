Return-Path: <SRS0=1NWX=OQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	T_DKIMWL_WL_HIGH,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED7C3C64EB1
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 11:43:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B2BDE2083D
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 11:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1544182990;
	bh=k5qrp/jhxY89QKAg9lrGGmxCnyvm0iti0svS3gNamJE=;
	h=From:Cc:Subject:Date:To:List-ID:From;
	b=1C1MQok0eUl7iFnmaUtQi/mB1xnSnLWi5hp38xwwglEefdjtZ2d3eIPJIwWQ2TVqE
	 2FG9WGgwDbjNgrdEBAs7btEB5vd94L8wnzPt2tnJkJi5/BKe7e67JkIRDBkO0fBWYX
	 WYBqPPMdcWUU/Pq+qNn7JOBiNDAOd3IDhr6uVQMs=
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B2BDE2083D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726008AbeLGLnK (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 7 Dec 2018 06:43:10 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:44094 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725987AbeLGLnK (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Dec 2018 06:43:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=MH5A1FWUcd7VNWiJrj/6EX2o88rjxpjcC/AyR8kA3Dk=; b=nH6q4hK8sStKseG2vOAFU/0nU
        skNEsbjcSXjTk7sftKYORzi7zXjbpxrQr5rpVB4ocVuDiaHIp/w3MX0pOdyw6guMPlEcTIuLCe7B2
        g/x1sFUUuFpNVpHzoCcx9DiM2v4Tyg73xfQ5zRzuFNN+DDHriJaXctKbgLiHhj6Dwo+teWLEHopRX
        hVQ8t65awldLjhfbDcovJ9TOrCFdRmc2HZdkx2utjvl4IpYMpO5nA4x/8aPrVeAz+OeoYaPgnYMi3
        aYSaQjb28/WYgr+lUGN3zJ1RLI+UzmxsUKIjaCmlbCUulDAzDvbI28IVRYWp4zy84pmK6FBHAd6Bp
        D5r1YR1wA==;
Received: from 201.86.173.17.dynamic.adsl.gvt.net.br ([201.86.173.17] helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gVEXF-0003gN-4i; Fri, 07 Dec 2018 11:43:09 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.91)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1gVEXD-0007i4-11; Fri, 07 Dec 2018 06:43:07 -0500
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH] media: imx214: don't de-reference a NULL pointer
Date:   Fri,  7 Dec 2018 06:43:03 -0500
Message-Id: <4800f277368eb6cc6099eb622988588e5a5de9ae.1544182979.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

As warned by smatch:
	drivers/media/i2c/imx214.c:591 imx214_set_format() warn: variable dereferenced before check 'format' (see line 589)

It turns that the code at imx214_set_format() has support for being
called with the format being NULL. I've no idea why, as it is only
called internally with the pointer set, and via subdev API (with
should also set it).

Also, the entire logic there depends on having format != NULL, so
just remove the bogus broken support for a null format.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/i2c/imx214.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/media/i2c/imx214.c b/drivers/media/i2c/imx214.c
index ec3d1b855f62..b046a26219a4 100644
--- a/drivers/media/i2c/imx214.c
+++ b/drivers/media/i2c/imx214.c
@@ -588,12 +588,10 @@ static int imx214_set_format(struct v4l2_subdev *sd,
 
 	__crop = __imx214_get_pad_crop(imx214, cfg, format->pad, format->which);
 
-	if (format)
-		mode = v4l2_find_nearest_size(imx214_modes,
-				ARRAY_SIZE(imx214_modes), width, height,
-				format->format.width, format->format.height);
-	else
-		mode = &imx214_modes[0];
+	mode = v4l2_find_nearest_size(imx214_modes,
+				      ARRAY_SIZE(imx214_modes), width, height,
+				      format->format.width,
+				      format->format.height);
 
 	__crop->width = mode->width;
 	__crop->height = mode->height;
-- 
2.19.2

