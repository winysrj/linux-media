Return-Path: <SRS0=k2dg=RL=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65C21C43381
	for <linux-media@archiver.kernel.org>; Fri,  8 Mar 2019 23:49:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C95B20851
	for <linux-media@archiver.kernel.org>; Fri,  8 Mar 2019 23:49:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726111AbfCHXtk (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Mar 2019 18:49:40 -0500
Received: from bin-mail-out-06.binero.net ([195.74.38.229]:18081 "EHLO
        bin-mail-out-06.binero.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726307AbfCHXtj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Mar 2019 18:49:39 -0500
X-Halon-ID: d19b4c24-41fc-11e9-846a-005056917a89
Authorized-sender: niklas@soderlund.pp.se
Received: from bismarck.berto.se (unknown [89.233.230.99])
        by bin-vsp-out-01.atm.binero.net (Halon) with ESMTPA
        id d19b4c24-41fc-11e9-846a-005056917a89;
        Sat, 09 Mar 2019 00:49:34 +0100 (CET)
From:   =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc:     linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH v2 1/2] dt-bindings: rcar-csi2: List resets as a mandatory property
Date:   Sat,  9 Mar 2019 00:47:21 +0100
Message-Id: <20190308234722.25775-2-niklas.soderlund+renesas@ragnatech.se>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190308234722.25775-1-niklas.soderlund+renesas@ragnatech.se>
References: <20190308234722.25775-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The resets property will become mandatory to operate the device, list it
as such. All device tree source files have always included the reset
property so making it mandatory will not introduce any regressions.

While at it improve the description for the clocks property.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 Documentation/devicetree/bindings/media/renesas,rcar-csi2.txt | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/media/renesas,rcar-csi2.txt b/Documentation/devicetree/bindings/media/renesas,rcar-csi2.txt
index d63275e17afdd180..9a0d0531c67df48c 100644
--- a/Documentation/devicetree/bindings/media/renesas,rcar-csi2.txt
+++ b/Documentation/devicetree/bindings/media/renesas,rcar-csi2.txt
@@ -18,7 +18,8 @@ Mandatory properties
 
  - reg: the register base and size for the device registers
  - interrupts: the interrupt for the device
- - clocks: reference to the parent clock
+ - clocks: A phandle + clock specifier for the module clock
+ - resets: A phandle + reset specifier for the module reset
 
 The device node shall contain two 'port' child nodes according to the
 bindings defined in Documentation/devicetree/bindings/media/
-- 
2.21.0

