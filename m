Return-Path: <SRS0=iic/=PR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19ED0C43387
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 12:29:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E670F20665
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 12:29:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730107AbfAIM3p (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 9 Jan 2019 07:29:45 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:47434 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728186AbfAIM3o (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 9 Jan 2019 07:29:44 -0500
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id 4B9EE634C7F;
        Wed,  9 Jan 2019 14:28:25 +0200 (EET)
Received: from sailus by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1ghCy8-0002Z9-KI; Wed, 09 Jan 2019 14:28:24 +0200
Date:   Wed, 9 Jan 2019 14:28:24 +0200
From:   Sakari Ailus <sakari.ailus@iki.fi>
To:     Maxime Ripard <maxime.ripard@bootlin.com>
Cc:     Kishon Vijay Abraham I <kishon@ti.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org,
        Archit Taneja <architt@codeaurora.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Chen-Yu Tsai <wens@csie.org>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org,
        Krzysztof Witos <kwitos@cadence.com>,
        Rafal Ciepiela <rafalc@cadence.com>
Subject: Re: [PATCH v4 0/9] phy: Add configuration interface for MIPI D-PHY
 devices
Message-ID: <20190109122824.vcxpcmiunball5rq@valkosipuli.retiisi.org.uk>
References: <cover.5d91ef683e3f432342f536e0f2fe239dbcebcb3e.1547026369.git-series.maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.5d91ef683e3f432342f536e0f2fe239dbcebcb3e.1547026369.git-series.maxime.ripard@bootlin.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Wed, Jan 09, 2019 at 10:33:17AM +0100, Maxime Ripard wrote:
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
> 
> Let me know what you think,
> Maxime
> 
> Changes from v3
>   - Rebased on 5.0-rc1
>   - Added the fixes suggested by Sakari

Thanks!

For patches 1--3:

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
