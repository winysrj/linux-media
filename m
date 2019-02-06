Return-Path: <SRS0=FbF1=QN=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CBC7C169C4
	for <linux-media@archiver.kernel.org>; Wed,  6 Feb 2019 15:14:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A9DC2080D
	for <linux-media@archiver.kernel.org>; Wed,  6 Feb 2019 15:14:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="O9lfY2Cm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731210AbfBFPOK (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 6 Feb 2019 10:14:10 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37309 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730384AbfBFPOJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Feb 2019 10:14:09 -0500
Received: by mail-wr1-f68.google.com with SMTP id c8so1154181wrs.4
        for <linux-media@vger.kernel.org>; Wed, 06 Feb 2019 07:14:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=b9uMMPdkJCtwwiAQ2DAjUCT6O07s1f5ZO4Mq8oQ/Fa8=;
        b=O9lfY2CmB03HgAWOP7VGmQmmgz7WnnzMHCEKzfWCA5imPhiM+zm+7asIlojsUD4ya+
         DzGpIftqliC6qqtBrqJGNMANuZK1VIejNM1A66stw3SKRTu0w+8/G/rBYecbLuzmB0P9
         vieQMfIUQGv12QpELSy5gK3yavFVaox2I7g2xjoH/yl/lDp/B+aUtN91/l2VqaQo4S9p
         8updjckQwLKl+z1gapkm2+VtwNbJ9or5+CQnaEQVkny5tCsMF1S157VmMVYOGtjC0AmX
         vfy1xcwjZDKP3416TYy31ppMv6g+Zjtuo5gTMpx1W7AiB3E+3dbwQV1oRPLrQ7EH/8EK
         HXjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=b9uMMPdkJCtwwiAQ2DAjUCT6O07s1f5ZO4Mq8oQ/Fa8=;
        b=fmSSu0kS6rjrPvTQFhiRrCRK5IdGjdKHh9cbroMG2OVzIvU/jja61bNTHmZCzfDcfL
         NAjqeFaNCoRIKA2ht/pXpqCqFsgSGLCzZefkqZMZV9iEyWb+cyFtueY/U4QgsceqEvD6
         AGZRqjA6RCITUy5T9P74tIYXsc8X101RnSbakFbidwlcyjcBlt3Sh+miQ5+ehnxgoeU1
         g2H2WTx5/3ySN+N2WmPotVRLUKRfrrolhuoeAbQrNBd652oJqOrWiMczhARkNzD73UG5
         NbpUqI5VDOWin/sgtHsOb+cNe8q7py+WbPgoQAQuiLYzGeyab57a6xbzLxb/z5eth48g
         64Cw==
X-Gm-Message-State: AHQUAuZYo92nt95nehlj2Q1P6xyDT9E4UNwngvTapruXvFCJ3Kl00IHn
        YqweXiBOuY0je//HR5VPkEAZkA==
X-Google-Smtp-Source: AHgI3IarCmTMLjN3jZ/9yqaMJ2vXjoOM0+bNcwwW718YQfvKLk/rwHNJwpU7EEl3RDszhxIvpKC8cA==
X-Received: by 2002:a5d:550f:: with SMTP id b15mr8629992wrv.330.1549466047664;
        Wed, 06 Feb 2019 07:14:07 -0800 (PST)
Received: from arch-late.local (a109-49-46-234.cpe.netcabo.pt. [109.49.46.234])
        by smtp.gmail.com with ESMTPSA id f22sm11207836wmj.26.2019.02.06.07.14.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Feb 2019 07:14:07 -0800 (PST)
From:   Rui Miguel Silva <rui.silva@linaro.org>
To:     sakari.ailus@linux.intel.com,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rui Miguel Silva <rui.silva@linaro.org>
Subject: [PATCH v14 13/13] media: MAINTAINERS: add entry for Freescale i.MX7 media driver
Date:   Wed,  6 Feb 2019 15:13:28 +0000
Message-Id: <20190206151328.21629-14-rui.silva@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190206151328.21629-1-rui.silva@linaro.org>
References: <20190206151328.21629-1-rui.silva@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add maintainer entry for the imx7 media csi, mipi csis driver,
dt-bindings and documentation.

Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 MAINTAINERS | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3e211916d2bc..d8e0c9040736 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9348,6 +9348,17 @@ T:	git git://linuxtv.org/media_tree.git
 S:	Maintained
 F:	drivers/media/platform/imx-pxp.[ch]
 
+MEDIA DRIVERS FOR FREESCALE IMX7
+M:	Rui Miguel Silva <rmfrfs@gmail.com>
+L:	linux-media@vger.kernel.org
+T:	git git://linuxtv.org/media_tree.git
+S:	Maintained
+F:	Documentation/devicetree/bindings/media/imx7-csi.txt
+F:	Documentation/devicetree/bindings/media/imx7-mipi-csi2.txt
+F:	Documentation/media/v4l-drivers/imx7.rst
+F:	drivers/staging/media/imx/imx7-media-csi.c
+F:	drivers/staging/media/imx/imx7-mipi-csis.c
+
 MEDIA DRIVERS FOR HELENE
 M:	Abylay Ospan <aospan@netup.ru>
 L:	linux-media@vger.kernel.org
-- 
2.20.1

