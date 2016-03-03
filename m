Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:46604 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402AbcCCHbV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Mar 2016 02:31:21 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH/RFC 1/9] clk: shmobile: r8a7795: Add FCP clocks
Date: Thu, 03 Mar 2016 09:31:19 +0200
Message-ID: <1535853.p3kynkDehl@avalon>
In-Reply-To: <87a8mgav88.wl%kuninori.morimoto.gx@renesas.com>
References: <1455242450-24493-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <14286375.foEiTHNJ63@avalon> <87a8mgav88.wl%kuninori.morimoto.gx@renesas.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Morimoto-sa,

On Thursday 03 March 2016 07:19:20 Kuninori Morimoto wrote:
> Hi Laurent
> 
> >> It seems FCP clock is based on each SoC
> >> In H3 ES1 case, it is using
> >> 
> >>  - s2d2 (for 200MHz)
> >>  - s2d1 (for 400MHz)
> > 
> > Thank you for the information. Do you mean that different FCP instances
> > use different clocks ? If so, could you tell us which clock is used by
> > each instance in th H3 ES1 ?
> 
> Sorry for my confusable mail.
> All FCP on H3 ES1 is using above,
> but, M3 or E3 will use different clock.
> 
> Is this more clear ?

Does it mean that every FCP instance uses both the S2D2 and the S2D1 clocks as 
functional clocks on H3 ES1 ?

-- 
Regards,

Laurent Pinchart

