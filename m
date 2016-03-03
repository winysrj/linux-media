Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:46592 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbcCCGwU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Mar 2016 01:52:20 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH/RFC 1/9] clk: shmobile: r8a7795: Add FCP clocks
Date: Thu, 03 Mar 2016 08:52:18 +0200
Message-ID: <14286375.foEiTHNJ63@avalon>
In-Reply-To: <87io14beqj.wl%kuninori.morimoto.gx@renesas.com>
References: <1455242450-24493-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <87d1rfj9n3.wl%kuninori.morimoto.gx@renesas.com> <87io14beqj.wl%kuninori.morimoto.gx@renesas.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Morimoto-san,

On Thursday 03 March 2016 00:17:54 Kuninori Morimoto wrote:
> Hi Laurent
> 
> >>> The parent clock isn't documented in the datasheet, use S2D1 as a best
> >>> guess for now.
> >> 
> >> Would you be able to find out what the parent clock is for the FCP and
> >> LVDS (patch 2/9) clocks ?
> 
> It seems FCP clock is based on each SoC
> In H3 ES1 case, it is using
>  - s2d2 (for 200MHz)
>  - s2d1 (for 400MHz)

Thank you for the information. Do you mean that different FCP instances use 
different clocks ? If so, could you tell us which clock is used by each 
instance in th H3 ES1 ?

-- 
Regards,

Laurent Pinchart

