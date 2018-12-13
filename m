Return-Path: <SRS0=yFxv=OW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47BB6C67839
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 15:39:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0B72E20989
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 15:39:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bM2hKayk"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0B72E20989
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729176AbeLMPjL (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 13 Dec 2018 10:39:11 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:32993 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728983AbeLMPjL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Dec 2018 10:39:11 -0500
Received: by mail-lf1-f67.google.com with SMTP id i26so1918438lfc.0
        for <linux-media@vger.kernel.org>; Thu, 13 Dec 2018 07:39:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3wkzbLKZKvq7/HlvPnKJHkLMUGF0b+s/ftVH520rwWk=;
        b=bM2hKaykaK84XGcHNSeCIUq+M2d+rbGxI8sqr83Uvy2eNnzwoqu6mTt/dpI+Do3pvs
         Ez1WNSbEdg+Hyjv0TeG4FZfnJJeZD6ixJsMF+H1lE9SbdaHuFdFgNjZgFXt42YHMNXdA
         H6ojwPktMEtQfGWUr2IndTaMFSAUfJksrwa1/KmNnc3N46sDAsL0jJ7YodlaZBYSiXUu
         6EEWYb6KkdB03N+huCy8PUl0FyY427GcdSgyshGBdQK0HOcpLyaDTO3uP/GBWEUsQtzE
         ai0Qy/KJVKpjsRyYOjxOBLoOTQjGhQrF1+DV89Au0N+PCR3ISFgW67Cb2F51D4yJdynf
         RFCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3wkzbLKZKvq7/HlvPnKJHkLMUGF0b+s/ftVH520rwWk=;
        b=a+wy7OqM1EENusZQaTe/jVFmEEHGDi+cMCbakghSrs1/m1EwlpQFuBho+DYVy60ZgI
         tIT/DtbuFVsknmOsSMtgmSRDRrcNwcWwtiYd0McXVPVvAfrkmY9UChweXFdqb7hGOJM+
         Uc2axz1sJPkoQoEbAQCQqGNyUahJXCa+ZRb2bRyfrE7mSVrnKR9xZ605Jee4t43kimKK
         GgZ8UzbTzBM7ZoE7ScWRHOiktESaD9ySYXQub0s68Zqh+YWLDZ5HUrVkFgZVbIqn6D9r
         7qgwkdZhLeHng66FKKkYVQl9sToB96hWxbfLXG9lbFSfnT9Lrb0NovsUPeGBneZC597y
         fQ/Q==
X-Gm-Message-State: AA+aEWZYJuXy+G9grOvHxZfjs9trtEdTkn566LhP0gNmGmtOKpgVuTKA
        897h4FrFBXcu/tC5pubF24znGl7b
X-Google-Smtp-Source: AFSGD/W16RsS4HF+nei/m/6SL9DZ8dMo2S/2B7Uxe5cfg8L0vEwdqCTEtgLN3HTXfzWbmbO2yh5DHw==
X-Received: by 2002:a19:1019:: with SMTP id f25mr14130801lfi.54.1544715548532;
        Thu, 13 Dec 2018 07:39:08 -0800 (PST)
Received: from kontron.lan (2001-1ae9-0ff1-f191-41f2-812a-df1c-0485.ip6.tmcz.cz. [2001:1ae9:ff1:f191:41f2:812a:df1c:485])
        by smtp.gmail.com with ESMTPSA id q67sm412869lfe.19.2018.12.13.07.39.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Dec 2018 07:39:08 -0800 (PST)
From:   petrcvekcz@gmail.com
X-Google-Original-From: petrcvekcz.gmail.com
To:     hans.verkuil@cisco.com, jacopo@jmondi.org, mchehab@kernel.org,
        marek.vasut@gmail.com
Cc:     Petr Cvek <petrcvekcz@gmail.com>, linux-media@vger.kernel.org,
        robert.jarzmik@free.fr, slapin@ossfans.org,
        philipp.zabel@gmail.com, sakari.ailus@iki.fi
Subject: [PATCH v3 3/8] MAINTAINERS: add Petr Cvek as a maintainer for the ov9640 driver
Date:   Thu, 13 Dec 2018 16:39:14 +0100
Message-Id: <9cb6b4ff772f4b8e464e4ab8e96314a16fe1380a.1544713575.git.petrcvekcz@gmail.com>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <cover.1544713575.git.petrcvekcz@gmail.com>
References: <cover.1544713575.git.petrcvekcz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Petr Cvek <petrcvekcz@gmail.com>

The soc_camera drivers are marked as orphaned. Add Petr Cvek as a new
maintainer for ov9640 driver after its switch from the soc_camera.

Signed-off-by: Petr Cvek <petrcvekcz@gmail.com>
---
 MAINTAINERS | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index a2e686819ef8..eda47064ed55 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11146,6 +11146,12 @@ S:	Maintained
 F:	drivers/media/i2c/ov7740.c
 F:	Documentation/devicetree/bindings/media/i2c/ov7740.txt
 
+OMNIVISION OV9640 SENSOR DRIVER
+M:	Petr Cvek <petrcvekcz@gmail.com>
+L:	linux-media@vger.kernel.org
+S:	Maintained
+F:	drivers/media/i2c/ov9640.*
+
 OMNIVISION OV9650 SENSOR DRIVER
 M:	Sakari Ailus <sakari.ailus@linux.intel.com>
 R:	Akinobu Mita <akinobu.mita@gmail.com>
-- 
2.20.0

