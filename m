Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54800 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750907AbdKBHTv (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Nov 2017 03:19:51 -0400
Date: Thu, 2 Nov 2017 00:19:42 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: Jernej Skrabec <jernej.skrabec@siol.net>
Cc: maxime.ripard@free-electrons.com, wens@csie.org,
        Laurent.pinchart@ideasonboard.com, hans.verkuil@cisco.com,
        narmstrong@baylibre.com, dri-devel@lists.freedesktop.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org,
        icenowy@aosc.io, linux-sunxi@googlegroups.com,
        linux-media@vger.kernel.org
Subject: Re: [RESEND RFC PATCH 3/7] clk: sunxi: Add CLK_SET_RATE_PARENT flag
 for H3 HDMI clock
Message-ID: <20171102071942.GN30645@codeaurora.org>
References: <20170920200124.20457-1-jernej.skrabec@siol.net>
 <20170920200124.20457-4-jernej.skrabec@siol.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170920200124.20457-4-jernej.skrabec@siol.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/20, Jernej Skrabec wrote:
> When setting the HDMI clock of H3, the PLL_VIDEO clock needs to be set.
> 
> Add CLK_SET_RATE_PARENT flag for H3 HDMI clock.
> 
> Signed-off-by: Jernej Skrabec <jernej.skrabec@siol.net>
> Signed-off-by: Icenowy Zheng <icenowy@aosc.io>
> ---

Acked-by: Stephen Boyd <sboyd@codeaurora.org>

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
