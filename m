Return-Path: <SRS0=1NWX=OQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8550FC64EB1
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 05:01:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4EF0F2082D
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 05:01:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4EF0F2082D
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=ti.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725963AbeLGFBm (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 7 Dec 2018 00:01:42 -0500
Received: from fllv0016.ext.ti.com ([198.47.19.142]:43312 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725939AbeLGFBl (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Dec 2018 00:01:41 -0500
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id wB751AjC077225;
        Thu, 6 Dec 2018 23:01:10 -0600
Received: from DLEE102.ent.ti.com (dlee102.ent.ti.com [157.170.170.32])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id wB75195i107015
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 6 Dec 2018 23:01:09 -0600
Received: from DLEE108.ent.ti.com (157.170.170.38) by DLEE102.ent.ti.com
 (157.170.170.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1591.10; Thu, 6
 Dec 2018 23:01:09 -0600
Received: from dflp32.itg.ti.com (10.64.6.15) by DLEE108.ent.ti.com
 (157.170.170.38) with Microsoft SMTP Server (version=TLS1_0,
 cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.1.1591.10 via Frontend Transport;
 Thu, 6 Dec 2018 23:01:09 -0600
Received: from [172.24.190.233] (ileax41-snat.itg.ti.com [10.172.224.153])
        by dflp32.itg.ti.com (8.14.3/8.13.8) with ESMTP id wB7515Jw020376;
        Thu, 6 Dec 2018 23:01:05 -0600
Subject: Re: [PATCH v2 0/9] phy: Add configuration interface for MIPI D-PHY
 devices
To:     Maxime Ripard <maxime.ripard@bootlin.com>,
        Boris Brezillon <boris.brezillon@bootlin.com>
CC:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        <linux-media@vger.kernel.org>,
        Archit Taneja <architt@codeaurora.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Chen-Yu Tsai <wens@csie.org>, <linux-kernel@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Krzysztof Witos <kwitos@cadence.com>,
        Rafal Ciepiela <rafalc@cadence.com>
References: <cover.c2c2ae47383b9dbbdee6b69cafdd7391c06dde4f.1541516029.git-series.maxime.ripard@bootlin.com>
From:   Kishon Vijay Abraham I <kishon@ti.com>
Message-ID: <f149ff50-b158-ef35-bf86-26d6b38c8068@ti.com>
Date:   Fri, 7 Dec 2018 10:30:55 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <cover.c2c2ae47383b9dbbdee6b69cafdd7391c06dde4f.1541516029.git-series.maxime.ripard@bootlin.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Maxime,

On 06/11/18 8:24 PM, Maxime Ripard wrote:
> Hi,
> 
> Here is a set of patches to allow the phy framework consumers to test and
> apply runtime configurations.
> 
> This is needed to support more phy classes that require tuning based on
> parameters depending on the current use case of the device, in addition to
> the power state management already provided by the current functions.
> 
> A first test bed for that API are the MIPI D-PHY devices. There's a number
> of solutions that have been used so far to support these phy, most of the
> time being an ad-hoc driver in the consumer.
> 
> That approach has a big shortcoming though, which is that this is quite
> difficult to deal with consumers integrated with multiple variants of phy,
> of multiple consumers integrated with the same phy.
> 
> The latter case can be found in the Cadence DSI bridge, and the CSI
> transceiver and receivers. All of them are integrated with the same phy, or
> can be integrated with different phy, depending on the implementation.
> 
> I've looked at all the MIPI DSI drivers I could find, and gathered all the
> parameters I could find. The interface should be complete, and most of the
> drivers can be converted in the future. The current set converts two of
> them: the above mentionned Cadence DSI driver so that the v4l2 drivers can
> use them, and the Allwinner MIPI-DSI driver.

Are you planning to send one more revision of this series after fixing the
comments?

Thanks
Kishon
> 
> Let me know what you think,
> Maxime
> 
> Changes from v1:
>   - Rebased on top of 4.20-rc1
>   - Removed the bus mode and timings parameters from the MIPI D-PHY
>     parameters, since that shouldn't have any impact on the PHY itself.
>   - Reworked the Cadence DSI and D-PHY drivers to take this into account.
>   - Remove the mode parameter from phy_configure
>   - Added phy_configure and phy_validate stubs
>   - Return -EOPNOTSUPP in phy_configure and phy_validate when the operation
>     is not implemented
> 
> Maxime Ripard (9):
>   phy: Add MIPI D-PHY mode
>   phy: Add configuration interface
>   phy: Add MIPI D-PHY configuration options
>   phy: dphy: Add configuration helpers
>   sun6i: dsi: Convert to generic phy handling
>   phy: Move Allwinner A31 D-PHY driver to drivers/phy/
>   drm/bridge: cdns: Separate DSI and D-PHY configuration
>   phy: Add Cadence D-PHY support
>   drm/bridge: cdns: Convert to phy framework
> 
>  Documentation/devicetree/bindings/display/bridge/cdns,dsi.txt |  21 +-
>  Documentation/devicetree/bindings/phy/cdns,dphy.txt           |  20 +-
>  drivers/gpu/drm/bridge/cdns-dsi.c                             | 535 +------
>  drivers/gpu/drm/sun4i/Kconfig                                 |   3 +-
>  drivers/gpu/drm/sun4i/Makefile                                |   5 +-
>  drivers/gpu/drm/sun4i/sun6i_mipi_dphy.c                       | 292 +----
>  drivers/gpu/drm/sun4i/sun6i_mipi_dsi.c                        |  31 +-
>  drivers/gpu/drm/sun4i/sun6i_mipi_dsi.h                        |  17 +-
>  drivers/phy/Kconfig                                           |   8 +-
>  drivers/phy/Makefile                                          |   1 +-
>  drivers/phy/allwinner/Kconfig                                 |  12 +-
>  drivers/phy/allwinner/Makefile                                |   1 +-
>  drivers/phy/allwinner/phy-sun6i-mipi-dphy.c                   | 318 ++++-
>  drivers/phy/cadence/Kconfig                                   |  13 +-
>  drivers/phy/cadence/Makefile                                  |   1 +-
>  drivers/phy/cadence/cdns-dphy.c                               | 459 ++++++-
>  drivers/phy/phy-core-mipi-dphy.c                              | 160 ++-
>  drivers/phy/phy-core.c                                        |  61 +-
>  include/linux/phy/phy-mipi-dphy.h                             | 238 +++-
>  include/linux/phy/phy.h                                       |  65 +-
>  20 files changed, 1482 insertions(+), 779 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/phy/cdns,dphy.txt
>  delete mode 100644 drivers/gpu/drm/sun4i/sun6i_mipi_dphy.c
>  create mode 100644 drivers/phy/allwinner/phy-sun6i-mipi-dphy.c
>  create mode 100644 drivers/phy/cadence/cdns-dphy.c
>  create mode 100644 drivers/phy/phy-core-mipi-dphy.c
>  create mode 100644 include/linux/phy/phy-mipi-dphy.h
> 
> base-commit: 651022382c7f8da46cb4872a545ee1da6d097d2a
> 
