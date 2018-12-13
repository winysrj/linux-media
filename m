Return-Path: <SRS0=yFxv=OW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60724C67839
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 20:27:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 351A720870
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 20:27:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 351A720870
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=bp.renesas.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727499AbeLMU1K (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 13 Dec 2018 15:27:10 -0500
Received: from relmlor2.renesas.com ([210.160.252.172]:19026 "EHLO
        relmlie6.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726457AbeLMU1K (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Dec 2018 15:27:10 -0500
X-IronPort-AV: E=Sophos;i="5.56,349,1539615600"; 
   d="scan'208";a="2555724"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie6.idc.renesas.com with ESMTP; 14 Dec 2018 05:22:05 +0900
Received: from fabrizio-dev.ree.adwin.renesas.com (unknown [10.226.37.69])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id CC9B94072C54;
        Fri, 14 Dec 2018 05:22:02 +0900 (JST)
From:   Fabrizio Castro <fabrizio.castro@bp.renesas.com>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Cc:     Fabrizio Castro <fabrizio.castro@bp.renesas.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Simon Horman <horms@verge.net.au>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
Subject: [PATCH] media: dt-bindings: rcar-vin: Add R8A774C0 support
Date:   Thu, 13 Dec 2018 20:21:59 +0000
Message-Id: <1544732519-6956-1-git-send-email-fabrizio.castro@bp.renesas.com>
X-Mailer: git-send-email 2.7.4
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add the compatible string for RZ/G2E (a.k.a. R8A774C0) to the list
of SoCs supported by rcar-vin driver.

Signed-off-by: Fabrizio Castro <fabrizio.castro@bp.renesas.com>
---
 Documentation/devicetree/bindings/media/rcar_vin.txt | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/rcar_vin.txt b/Documentation/devicetree/bindings/media/rcar_vin.txt
index 7c878ca..34dcd28 100644
--- a/Documentation/devicetree/bindings/media/rcar_vin.txt
+++ b/Documentation/devicetree/bindings/media/rcar_vin.txt
@@ -7,12 +7,13 @@ family of devices.
 Each VIN instance has a single parallel input that supports RGB and YUV video,
 with both external synchronization and BT.656 synchronization for the latter.
 Depending on the instance the VIN input is connected to external SoC pins, or
-on Gen3 platforms to a CSI-2 receiver.
+on Gen3 and RZ/G2 platforms to a CSI-2 receiver.
 
  - compatible: Must be one or more of the following
    - "renesas,vin-r8a7743" for the R8A7743 device
    - "renesas,vin-r8a7744" for the R8A7744 device
    - "renesas,vin-r8a7745" for the R8A7745 device
+   - "renesas,vin-r8a774c0" for the R8A774C0 device
    - "renesas,vin-r8a7778" for the R8A7778 device
    - "renesas,vin-r8a7779" for the R8A7779 device
    - "renesas,vin-r8a7790" for the R8A7790 device
@@ -60,10 +61,10 @@ The per-board settings Gen2 platforms:
     - data-enable-active: polarity of CLKENB signal, see [1] for
       description. Default is active high.
 
-The per-board settings Gen3 platforms:
+The per-board settings Gen3 and RZ/G2 platforms:
 
-Gen3 platforms can support both a single connected parallel input source
-from external SoC pins (port@0) and/or multiple parallel input sources
+Gen3 and RZ/G2 platforms can support both a single connected parallel input
+source from external SoC pins (port@0) and/or multiple parallel input sources
 from local SoC CSI-2 receivers (port@1) depending on SoC.
 
 - renesas,id - ID number of the VIN, VINx in the documentation.
-- 
2.7.4

