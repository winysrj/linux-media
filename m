Return-Path: <SRS0=FbF1=QN=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDDA1C169C4
	for <linux-media@archiver.kernel.org>; Wed,  6 Feb 2019 12:14:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B7EA2073D
	for <linux-media@archiver.kernel.org>; Wed,  6 Feb 2019 12:14:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="fMFqb9qP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727590AbfBFMOA (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 6 Feb 2019 07:14:00 -0500
Received: from fllv0016.ext.ti.com ([198.47.19.142]:34564 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726957AbfBFMOA (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Feb 2019 07:14:00 -0500
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id x16CDlGg099473;
        Wed, 6 Feb 2019 06:13:47 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1549455227;
        bh=OkmxFCqvSMN/H6H9Jc2o7POV727/QGELQx/IqXK1Qyg=;
        h=Subject:To:References:From:Date:In-Reply-To;
        b=fMFqb9qPFoxtYdfmVAvwgSRxLH+VcCWmCrvLgxfwabPaOJxBM/c5VNSZ2UQjlAQKP
         or7BjxkXWs8QNrYE2KRvMD6LCKbLxAuNHJdqoco1RGPfZ7w+JKz/5SNKGIaXAilNTn
         jHoVVUz9XpPMaJdzj8k9TMusLi5kLAhd0OAuPKsM=
Received: from DLEE100.ent.ti.com (dlee100.ent.ti.com [157.170.170.30])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x16CDkmf038845
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 6 Feb 2019 06:13:47 -0600
Received: from DLEE107.ent.ti.com (157.170.170.37) by DLEE100.ent.ti.com
 (157.170.170.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1591.10; Wed, 6
 Feb 2019 06:13:46 -0600
Received: from dflp32.itg.ti.com (10.64.6.15) by DLEE107.ent.ti.com
 (157.170.170.37) with Microsoft SMTP Server (version=TLS1_0,
 cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.1.1591.10 via Frontend Transport;
 Wed, 6 Feb 2019 06:13:46 -0600
Received: from [172.24.190.233] (ileax41-snat.itg.ti.com [10.172.224.153])
        by dflp32.itg.ti.com (8.14.3/8.13.8) with ESMTP id x16CDgdo027632;
        Wed, 6 Feb 2019 06:13:43 -0600
Subject: Re: [PATCH v5 0/9] phy: Add configuration interface for MIPI D-PHY
 devices
To:     Maxime Ripard <maxime.ripard@bootlin.com>,
        Rafal Ciepiela <rafalc@cadence.com>,
        Krzysztof Witos <kwitos@cadence.com>,
        <linux-kernel@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Sean Paul <seanpaul@chromium.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-media@vger.kernel.org>
References: <cover.fbf0776c70c0cfb7b7fd88ce6a96b4597d620cac.1548085432.git-series.maxime.ripard@bootlin.com>
 <fc5427d3-674e-cebc-99b9-11493f976a20@ti.com>
 <20190205084620.GW3271@phenom.ffwll.local>
From:   Kishon Vijay Abraham I <kishon@ti.com>
Message-ID: <4177fba5-279d-3283-88f0-c681f72e5951@ti.com>
Date:   Wed, 6 Feb 2019 17:43:12 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190205084620.GW3271@phenom.ffwll.local>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi,

On 05/02/19 2:16 PM, Daniel Vetter wrote:
> On Mon, Feb 04, 2019 at 03:33:31PM +0530, Kishon Vijay Abraham I wrote:
>>
>>
>> On 21/01/19 9:15 PM, Maxime Ripard wrote:
>>> Hi,
>>>
>>> Here is a set of patches to allow the phy framework consumers to test and
>>> apply runtime configurations.
>>>
>>> This is needed to support more phy classes that require tuning based on
>>> parameters depending on the current use case of the device, in addition to
>>> the power state management already provided by the current functions.
>>>
>>> A first test bed for that API are the MIPI D-PHY devices. There's a number
>>> of solutions that have been used so far to support these phy, most of the
>>> time being an ad-hoc driver in the consumer.
>>>
>>> That approach has a big shortcoming though, which is that this is quite
>>> difficult to deal with consumers integrated with multiple variants of phy,
>>> of multiple consumers integrated with the same phy.
>>>
>>> The latter case can be found in the Cadence DSI bridge, and the CSI
>>> transceiver and receivers. All of them are integrated with the same phy, or
>>> can be integrated with different phy, depending on the implementation.
>>>
>>> I've looked at all the MIPI DSI drivers I could find, and gathered all the
>>> parameters I could find. The interface should be complete, and most of the
>>> drivers can be converted in the future. The current set converts two of
>>> them: the above mentionned Cadence DSI driver so that the v4l2 drivers can
>>> use them, and the Allwinner MIPI-DSI driver.
>>
>> Can the PHY changes go independently of the consumer drivers? or else I'll need
>> ACKs from the GPU MAINTAINER.
> 
> Maxime is a gpu maintainer, so you're all good :-)

cool.. I've merged all the patches except drm/bridge.

Please see if everything looks okay once it shows up in phy -next (give a day)

Thanks
Kishon
> -Daniel
> 
>>
>> Thanks
>> Kishon
>>
>>>
>>> Let me know what you think,
>>> Maxime
>>>
>>> Changes from v4:
>>>   - Removed regression on the variable calculation
>>>   - Fixed the wakeup unit
>>>   - Collected Sean Acked-by on the last patch
>>>   - Collected Sakari Reviewed-by on the first patch
>>>
>>> Changes from v3
>>>   - Rebased on 5.0-rc1
>>>   - Added the fixes suggested by Sakari
>>>
>>> Changes from v2:
>>>   - Rebased on next
>>>   - Changed the interface to accomodate for the new submodes
>>>   - Changed the timings units from nanoseconds to picoseconds
>>>   - Added minimum and maximum boundaries to the documentation
>>>   - Moved the clock enabling to phy_power_on in the Cadence DPHY driver
>>>   - Exported the phy_configure and phy_validate symbols
>>>   - Rework the phy pll divider computation in the cadence dphy driver
>>>
>>> Changes from v1:
>>>   - Rebased on top of 4.20-rc1
>>>   - Removed the bus mode and timings parameters from the MIPI D-PHY
>>>     parameters, since that shouldn't have any impact on the PHY itself.
>>>   - Reworked the Cadence DSI and D-PHY drivers to take this into account.
>>>   - Remove the mode parameter from phy_configure
>>>   - Added phy_configure and phy_validate stubs
>>>   - Return -EOPNOTSUPP in phy_configure and phy_validate when the operation
>>>     is not implemented
>>>
>>> Maxime Ripard (9):
>>>   phy: dphy: Remove unused header
>>>   phy: dphy: Change units of wakeup and init parameters
>>>   phy: dphy: Clarify lanes parameter documentation
>>>   sun6i: dsi: Convert to generic phy handling
>>>   phy: Move Allwinner A31 D-PHY driver to drivers/phy/
>>>   drm/bridge: cdns: Separate DSI and D-PHY configuration
>>>   dt-bindings: phy: Move the Cadence D-PHY bindings
>>>   phy: Add Cadence D-PHY support
>>>   drm/bridge: cdns: Convert to phy framework
>>>
>>>  Documentation/devicetree/bindings/display/bridge/cdns,dsi.txt |  21 +-
>>>  Documentation/devicetree/bindings/phy/cdns,dphy.txt           |  20 +-
>>>  drivers/gpu/drm/bridge/Kconfig                                |   1 +-
>>>  drivers/gpu/drm/bridge/cdns-dsi.c                             | 538 +------
>>>  drivers/gpu/drm/sun4i/Kconfig                                 |   3 +-
>>>  drivers/gpu/drm/sun4i/Makefile                                |   5 +-
>>>  drivers/gpu/drm/sun4i/sun6i_mipi_dphy.c                       | 292 +----
>>>  drivers/gpu/drm/sun4i/sun6i_mipi_dsi.c                        |  31 +-
>>>  drivers/gpu/drm/sun4i/sun6i_mipi_dsi.h                        |  17 +-
>>>  drivers/phy/allwinner/Kconfig                                 |  12 +-
>>>  drivers/phy/allwinner/Makefile                                |   1 +-
>>>  drivers/phy/allwinner/phy-sun6i-mipi-dphy.c                   | 318 ++++-
>>>  drivers/phy/cadence/Kconfig                                   |  13 +-
>>>  drivers/phy/cadence/Makefile                                  |   1 +-
>>>  drivers/phy/cadence/cdns-dphy.c                               | 389 +++++-
>>>  drivers/phy/phy-core-mipi-dphy.c                              |   8 +-
>>>  include/linux/phy/phy-mipi-dphy.h                             |  13 +-
>>>  17 files changed, 894 insertions(+), 789 deletions(-)
>>>  create mode 100644 Documentation/devicetree/bindings/phy/cdns,dphy.txt
>>>  delete mode 100644 drivers/gpu/drm/sun4i/sun6i_mipi_dphy.c
>>>  create mode 100644 drivers/phy/allwinner/phy-sun6i-mipi-dphy.c
>>>  create mode 100644 drivers/phy/cadence/cdns-dphy.c
>>>
>>> base-commit: bfeffd155283772bbe78c6a05dec7c0128ee500c
>>>
>> _______________________________________________
>> dri-devel mailing list
>> dri-devel@lists.freedesktop.org
>> https://lists.freedesktop.org/mailman/listinfo/dri-devel
> 
