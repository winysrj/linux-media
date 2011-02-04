Return-path: <mchehab@pedra>
Received: from mail-out.m-online.net ([212.18.0.10]:57231 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185Ab1BDJeg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Feb 2011 04:34:36 -0500
Date: Fri, 4 Feb 2011 10:35:09 +0100
From: Anatolij Gustschin <agust@denx.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Dan Williams <dan.j.williams@intel.com>,
	Detlev Zundel <dzu@denx.de>,
	Markus Niebel <Markus.Niebel@tqs.de>
Subject: Re: [PATCH 2/2 v2] dma: ipu_idmac: do not lose valid received data
 in the irq handler
Message-ID: <20110204103509.4465f23e@wker>
In-Reply-To: <Pine.LNX.4.64.1102031104090.21719@axis700.grange>
References: <1296031789-1721-3-git-send-email-agust@denx.de>
	<1296476549-10421-1-git-send-email-agust@denx.de>
	<Pine.LNX.4.64.1102031104090.21719@axis700.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi all,

On Thu, 3 Feb 2011 11:09:54 +0100 (CET)
Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
...
> Yes, the first interrupt is different, that's where I'm dropping / 
> postponing it. With your patch only N (equal to the number of buffers 
> used, I think) first interrupts toggle, then always only one buffer is 
> used:
> 
> idmac_interrupt(): IDMAC irq 177, buf 0, current 0
> idmac_interrupt(): IDMAC irq 177, buf 1, current 1
> idmac_interrupt(): IDMAC irq 177, buf 0, current 0
> idmac_interrupt(): IDMAC irq 177, buf 1, current 1
> idmac_interrupt(): IDMAC irq 177, buf 0, current 0
> idmac_interrupt(): IDMAC irq 177, buf 1, current 1
> idmac_interrupt(): IDMAC irq 177, buf 0, current 0
> idmac_interrupt(): IDMAC irq 177, buf 0, current 0
> idmac_interrupt(): IDMAC irq 177, buf 0, current 0
> ...
> 
> Verified with both capture.c and mplayer. Could you, please, verify 
> whether you get the same behaviour and what the problem could be?

Currently I'm quite busy, but I'll look at it this week end.

Thanks,
Anatolij
