Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:46823 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658AbcCCKt4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Mar 2016 05:49:56 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	Geert Uytterhoeven <geert+renesas@glider.be>
Subject: Re: [PATCH/RFC 1/9] clk: shmobile: r8a7795: Add FCP clocks
Date: Thu, 03 Mar 2016 12:49:55 +0200
Message-ID: <3162705.iiHBb2SECU@avalon>
In-Reply-To: <8737s8armo.wl%kuninori.morimoto.gx@renesas.com>
References: <1455242450-24493-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <1535853.p3kynkDehl@avalon> <8737s8armo.wl%kuninori.morimoto.gx@renesas.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Morimoto-san,

On Thursday 03 March 2016 08:37:02 Kuninori Morimoto wrote:
> Hi Laurent
> 
> >>>>  - s2d2 (for 200MHz)
> >>>>  - s2d1 (for 400MHz)
> >>>
> >>> Thank you for the information. Do you mean that different FCP instances
> >>> use different clocks ? If so, could you tell us which clock is used by
> >>> each instance in th H3 ES1 ?
> >> 
> >> Sorry for my confusable mail.
> >> All FCP on H3 ES1 is using above,
> >> but, M3 or E3 will use different clock.
> >> 
> >> Is this more clear ?
> > 
> > Does it mean that every FCP instance uses both the S2D2 and the S2D1
> > clocks as functional clocks on H3 ES1 ?
> 
>  - s2d2 (200MHz) is for APB-IF,
>  - s2d1 (400MHz) is for AXI-IF, and internal
> 
> Is this clear answer ?

It is, thank you very much for putting up with my slow mind ;-)

Geert, deciding what clock to use as a parent for the MSTP clock becomes 
interesting, As S2D2 clocks the control interface I propose picking it. This 
shows the limits of the MSTP clock model though, MSTP is really a module stop 
bit, not a clock.

-- 
Regards,

Laurent Pinchart

