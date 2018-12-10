Return-Path: <SRS0=Hr0N=OT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 178BCC5CFFE
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 16:35:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D1B472086D
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 16:34:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dEbkOjzX"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D1B472086D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727243AbeLJQe6 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 10 Dec 2018 11:34:58 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:46430 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726392AbeLJQe6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Dec 2018 11:34:58 -0500
Received: by mail-ed1-f66.google.com with SMTP id o10so9997931edt.13;
        Mon, 10 Dec 2018 08:34:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7QCbV7FTtynMbJ1N5CgZDG9CjfiMGjBfUjHz/Fc8YBU=;
        b=dEbkOjzXEPDu4ZDriSm4CV87Yu8owSs5l2VNPNn1u/D2fDtC0pifB7Wwm25+cvbitZ
         ZOcmJpWhJxoZiuHqFEVeLTfsTDWxZgj1NL5IueGlZRtDfbVhvVYxJ5NONsMdLHPqdxVC
         d0z7eG8oMKDOtlVgFX9LnKedDAOT/zHtaCOAOfkJBw9sGWxLqbMny/L9dewkNMVlgQHR
         Ou9PeV4fMVGy4hK6AbBtw2bsQjXjfJ3za3PQRwe82ndf6iOToGuEw9ee+m2CYgd7fsjT
         8BcWV+QYwK4eddnBNAylOrWZzs9Dst4+TXuRS4Ds5qLK5MX8bbU8Z5KqyDe85lw7ge4q
         wfew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7QCbV7FTtynMbJ1N5CgZDG9CjfiMGjBfUjHz/Fc8YBU=;
        b=iCA6mAB+nt8jtEHkEhGn2EEWaU4rROB2PgHlSVk3nPFG43raz1C/SIFfAAxNpI0uaR
         isIXFHRH8VJmfauPtB5GhYLYQPh9QykkO9Pg9lDy5KnN7Fp1lIyLH63GHOX5aruExkQt
         oGrzxbLeMakWE5wmc/fU1eo65FGg7djCGnks8RRKzHCWS9qeCuyhS4nqPzEKzfSPQu44
         GCVF3eq0zwvJL6LtR9O5TOodKFj0eqfs40hdfXiy8qF6c3G+dP/CANIcBy4UGTpAotV9
         Lgis/CPwOumMyetlBy9Q4NMIGEN9BHj9/1nTcNb46XkeJKXaTO9zNVe7Gm1RP/hgIJzH
         oXTg==
X-Gm-Message-State: AA+aEWZy8T9goHVXo0s8hVg1X+K1PrD7qBEoCV5CQ9fIcWzAP2oQ/BRb
        gQXrXN/es+c4sMyFRSYZ+98=
X-Google-Smtp-Source: AFSGD/UoVRab0te4fVTy8qAEle0z8+QG81KWM7SbxGSKH7aAtjWtJNSz/y4fIj9pRb+9IYcZCeLy4w==
X-Received: by 2002:a50:cf41:: with SMTP id d1mr12235239edk.242.1544459696800;
        Mon, 10 Dec 2018 08:34:56 -0800 (PST)
Received: from localhost (pD9E51040.dip0.t-ipconnect.de. [217.229.16.64])
        by smtp.gmail.com with ESMTPSA id n12-v6sm1838088ejl.13.2018.12.10.08.34.55
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 10 Dec 2018 08:34:56 -0800 (PST)
From:   Thierry Reding <thierry.reding@gmail.com>
To:     Thierry Reding <thierry.reding@gmail.com>
Cc:     Hans Verkuil <hans.verkuil@cisco.com>,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH] drm/tegra: Refactor CEC support
Date:   Mon, 10 Dec 2018 17:34:54 +0100
Message-Id: <20181210163455.13627-1-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

Most of the CEC support code already lives in the "output" library code.
Move registration and unregistration to the library code as well to make
use of the same code with HDMI on Tegra210 and later via the SOR.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/gpu/drm/tegra/drm.h    |  2 +-
 drivers/gpu/drm/tegra/hdmi.c   |  9 ---------
 drivers/gpu/drm/tegra/output.c | 11 +++++++++--
 3 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/tegra/drm.h b/drivers/gpu/drm/tegra/drm.h
index 019862a41cb4..dbc9e11b0aec 100644
--- a/drivers/gpu/drm/tegra/drm.h
+++ b/drivers/gpu/drm/tegra/drm.h
@@ -132,7 +132,7 @@ struct tegra_output {
 	struct drm_panel *panel;
 	struct i2c_adapter *ddc;
 	const struct edid *edid;
-	struct cec_notifier *notifier;
+	struct cec_notifier *cec;
 	unsigned int hpd_irq;
 	int hpd_gpio;
 	enum of_gpio_flags hpd_gpio_flags;
diff --git a/drivers/gpu/drm/tegra/hdmi.c b/drivers/gpu/drm/tegra/hdmi.c
index 0082468f703c..d19973945614 100644
--- a/drivers/gpu/drm/tegra/hdmi.c
+++ b/drivers/gpu/drm/tegra/hdmi.c
@@ -22,8 +22,6 @@
 
 #include <sound/hda_verbs.h>
 
-#include <media/cec-notifier.h>
-
 #include "hdmi.h"
 #include "drm.h"
 #include "dc.h"
@@ -1709,10 +1707,6 @@ static int tegra_hdmi_probe(struct platform_device *pdev)
 		return PTR_ERR(hdmi->vdd);
 	}
 
-	hdmi->output.notifier = cec_notifier_get(&pdev->dev);
-	if (hdmi->output.notifier == NULL)
-		return -ENOMEM;
-
 	hdmi->output.dev = &pdev->dev;
 
 	err = tegra_output_probe(&hdmi->output);
@@ -1771,9 +1765,6 @@ static int tegra_hdmi_remove(struct platform_device *pdev)
 
 	tegra_output_remove(&hdmi->output);
 
-	if (hdmi->output.notifier)
-		cec_notifier_put(hdmi->output.notifier);
-
 	return 0;
 }
 
diff --git a/drivers/gpu/drm/tegra/output.c b/drivers/gpu/drm/tegra/output.c
index c662efc7e413..9c2b9dad55c3 100644
--- a/drivers/gpu/drm/tegra/output.c
+++ b/drivers/gpu/drm/tegra/output.c
@@ -36,7 +36,7 @@ int tegra_output_connector_get_modes(struct drm_connector *connector)
 	else if (output->ddc)
 		edid = drm_get_edid(connector, output->ddc);
 
-	cec_notifier_set_phys_addr_from_edid(output->notifier, edid);
+	cec_notifier_set_phys_addr_from_edid(output->cec, edid);
 	drm_connector_update_edid_property(connector, edid);
 
 	if (edid) {
@@ -73,7 +73,7 @@ tegra_output_connector_detect(struct drm_connector *connector, bool force)
 	}
 
 	if (status != connector_status_connected)
-		cec_notifier_phys_addr_invalidate(output->notifier);
+		cec_notifier_phys_addr_invalidate(output->cec);
 
 	return status;
 }
@@ -174,11 +174,18 @@ int tegra_output_probe(struct tegra_output *output)
 		disable_irq(output->hpd_irq);
 	}
 
+	output->cec = cec_notifier_get(output->dev);
+	if (!output->cec)
+		return -ENOMEM;
+
 	return 0;
 }
 
 void tegra_output_remove(struct tegra_output *output)
 {
+	if (output->cec)
+		cec_notifier_put(output->cec);
+
 	if (gpio_is_valid(output->hpd_gpio)) {
 		free_irq(output->hpd_irq, output);
 		gpio_free(output->hpd_gpio);
-- 
2.19.1

