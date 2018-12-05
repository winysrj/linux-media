Return-Path: <SRS0=NzSx=OO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,URIBL_RHS_DOB autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B44DC04EBF
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 10:01:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DE73F20989
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 10:01:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DE73F20989
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=csie.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727515AbeLEJst (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 5 Dec 2018 04:48:49 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:45778 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727337AbeLEJss (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 5 Dec 2018 04:48:48 -0500
Received: by mail-ed1-f67.google.com with SMTP id d39so16405511edb.12;
        Wed, 05 Dec 2018 01:48:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Gurne33gwhpLkCvGi9a1PbXR8R7tVqXsE2HVurD45GM=;
        b=Na035VTCTuXT7icNUSqvxHSL4xKvtb1abfdCaIfMNtM8H1Xtg9JvIRsnX0Uz1OAHQK
         cAOMrQV3Gko8B3hViuwC/QJBtpDgJuk+fIZzsxd8cZm3UCBXe08WcasAkF/26xbYLZe4
         N9meVlYg7wC/d55TQTkGXf/BE0+wePYl47ubr3sHubrpnL+SR3CKUG38aeTfHkFUK7kW
         X6WBSndpzTLHetKUpCJuJYturMEvsJXblK+tVi0sergAZdgO3cM7cd4IiTy2RXVXNhtH
         MQ65+f0GoLx+XWttf2BSP/3AwcQeBDSq6hgoIPuJygT7cQ9uv6+mKZj8NOw/+XqNSlAz
         /+yA==
X-Gm-Message-State: AA+aEWbSeOiwvQk7T1DwmM+ZwhbayB/Dtgeg7BI0OjIiY35fTXXwK4Vh
        qNlcFumcL0n4V2F58PJgHmHn9q5vJ1I=
X-Google-Smtp-Source: AFSGD/UzCIprbESrXCuNMPzFM50lFepDT/WWfMqyHvk9pAK9tyLqeAEX4tIO1ETQbpTgocq/D5EApg==
X-Received: by 2002:a50:f5af:: with SMTP id u44mr21771124edm.172.1544003326234;
        Wed, 05 Dec 2018 01:48:46 -0800 (PST)
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com. [209.85.128.46])
        by smtp.gmail.com with ESMTPSA id v11sm5460680edy.49.2018.12.05.01.48.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Dec 2018 01:48:45 -0800 (PST)
Received: by mail-wm1-f46.google.com with SMTP id z18so12538815wmc.4;
        Wed, 05 Dec 2018 01:48:45 -0800 (PST)
X-Received: by 2002:a1c:f605:: with SMTP id w5mr15965019wmc.116.1544003325382;
 Wed, 05 Dec 2018 01:48:45 -0800 (PST)
MIME-Version: 1.0
References: <20181205092444.29497-1-paul.kocialkowski@bootlin.com>
In-Reply-To: <20181205092444.29497-1-paul.kocialkowski@bootlin.com>
From:   Chen-Yu Tsai <wens@csie.org>
Date:   Wed, 5 Dec 2018 17:48:34 +0800
X-Gmail-Original-Message-ID: <CAGb2v64fjKbxET61S7NzTaPGJc7-XUG=Zb87_BOah9xWr5zpvg@mail.gmail.com>
Message-ID: <CAGb2v64fjKbxET61S7NzTaPGJc7-XUG=Zb87_BOah9xWr5zpvg@mail.gmail.com>
Subject: Re: [PATCH v2 00/15] Cedrus H5 and A64 support with A33 and H3 updates
To:     Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        devel@driverdev.osuosl.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        linux-sunxi <linux-sunxi@googlegroups.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Wed, Dec 5, 2018 at 5:25 PM Paul Kocialkowski
<paul.kocialkowski@bootlin.com> wrote:
>
> This series adds support for the Allwinner H5 and A64 platforms to the
> cedrus stateless video codec driver, with minor updates to the A33 and
> H3 platforms.
>
> It requires changes to the SRAM driver bindings and driver, to properly
> support the H5 and the A64 C1 SRAM section. Because a H5-specific
> system-control node is introduced, the dummy syscon node that was shared
> between the H3 and H5 is removed in favor of each platform-specific node.
> A few fixes are included to ensure that the EMAC clock configuration
> register is still accessible through the sunxi SRAM driver (instead of the
> dummy syscon node, that was there for this purpose) on the H3 and H5.
>
> The reserved memory nodes for the A33 and H3 are also removed in this
> series, since they are not actually necessary.
>
> Changes since v1:
> * Removed the reserved-memory nodes for the A64 and H5;
> * Removed the reserved-memory nodes for the A33 and H3;
> * Corrected the SRAM bases and sizes to the best of our knowledge;
> * Dropped cosmetic dt changes already included in the sunxi tree.
>
> Paul Kocialkowski (15):
>   ARM: dts: sun8i: h3: Fix the system-control register range
>   ARM: dts: sun8i: a33: Remove unnecessary reserved memory node
>   ARM: dts: sun8i: h3: Remove unnecessary reserved memory node
>   soc: sunxi: sram: Enable EMAC clock access for H3 variant
>   dt-bindings: sram: sunxi: Add bindings for the H5 with SRAM C1
>   soc: sunxi: sram: Add support for the H5 SoC system control
>   arm64: dts: allwinner: h5: Add system-control node with SRAM C1
>   ARM/arm64: sunxi: Move H3/H5 syscon label over to soc-specific nodes
>   dt-bindings: sram: sunxi: Add compatible for the A64 SRAM C1
>   arm64: dts: allwinner: a64: Add support for the SRAM C1 section
>   dt-bindings: media: cedrus: Add compatibles for the A64 and H5
>   media: cedrus: Add device-tree compatible and variant for H5 support
>   media: cedrus: Add device-tree compatible and variant for A64 support
>   arm64: dts: allwinner: h5: Add Video Engine node
>   arm64: dts: allwinner: a64: Add Video Engine node

Other than the error in patch 7,

Acked-by: Chen-Yu Tsai <wens@csie.org>
