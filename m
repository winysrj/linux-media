Return-path: <mchehab@pedra>
Received: from mail-out.m-online.net ([212.18.0.10]:54835 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778Ab1BENe1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 Feb 2011 08:34:27 -0500
Date: Sat, 5 Feb 2011 14:35:05 +0100
From: Anatolij Gustschin <agust@denx.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Dan Williams <dan.j.williams@intel.com>,
	Detlev Zundel <dzu@denx.de>,
	Markus Niebel <Markus.Niebel@tqs.de>
Subject: Re: [PATCH 2/2 v2] dma: ipu_idmac: do not lose valid received data
 in the irq handler
Message-ID: <20110205143505.0b300a3a@wker>
In-Reply-To: <Pine.LNX.4.64.1102031104090.21719@axis700.grange>
References: <1296031789-1721-3-git-send-email-agust@denx.de>
	<1296476549-10421-1-git-send-email-agust@denx.de>
	<Pine.LNX.4.64.1102031104090.21719@axis700.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Guennadi,

On Thu, 3 Feb 2011 11:09:54 +0100 (CET)
Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:

> Hi Anatolij
> 
> On Mon, 31 Jan 2011, Anatolij Gustschin wrote:
> 
> I'm afraid there seems to be a problem with your patch. I have no idea 
> what is causing it, but I'm just observing some wrong behaviour, that is 
> not there without it. Namely, I added a debug print to the IDMAC interrupt 
> handler
> 
>  	curbuf	= idmac_read_ipureg(&ipu_data, IPU_CHA_CUR_BUF);
>  	err	= idmac_read_ipureg(&ipu_data, IPU_INT_STAT_4);
>  
> +	printk(KERN_DEBUG "%s(): IDMAC irq %d, buf %d, current %d\n", __func__,
> +	       irq, ichan->active_buffer, (curbuf >> chan_id) & 1);
>  
>  	if (err & (1 << chan_id)) {
>  		idmac_write_ipureg(&ipu_data, 1 << chan_id, IPU_INT_STAT_4);
> 
> and without your patch I see buffer numbers correctly toggling all the 
> time like
> 
> idmac_interrupt(): IDMAC irq 177, buf 0, current 0
> idmac_interrupt(): IDMAC irq 177, buf 0, current 1
> idmac_interrupt(): IDMAC irq 177, buf 1, current 0
> idmac_interrupt(): IDMAC irq 177, buf 0, current 1
> idmac_interrupt(): IDMAC irq 177, buf 1, current 0
> idmac_interrupt(): IDMAC irq 177, buf 0, current 1
> ...
> 
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

Now I did some further testing with idmac patch applied and with
added debug print in the IDMAC interrupt handler. There is no problem.
Testing with capture.c (4 buffers used as default) shows that buffer
numbers toggle correctly for all 100 captured frames:
...
mx3-camera mx3-camera.0: MX3 Camera driver attached to camera 0
idmac_interrupt(): IDMAC irq 177, buf 0, current 0
idmac_interrupt(): IDMAC irq 177, buf 1, current 1
idmac_interrupt(): IDMAC irq 177, buf 0, current 0
idmac_interrupt(): IDMAC irq 177, buf 1, current 1
idmac_interrupt(): IDMAC irq 177, buf 0, current 0
idmac_interrupt(): IDMAC irq 177, buf 1, current 1
...
idmac_interrupt(): IDMAC irq 177, buf 0, current 0
idmac_interrupt(): IDMAC irq 177, buf 1, current 1
idmac_interrupt(): IDMAC irq 177, buf 0, current 0
idmac_interrupt(): IDMAC irq 177, buf 1, current 1
idmac_interrupt(): IDMAC irq 177, buf 0, current 0
idmac_interrupt(): IDMAC irq 177, buf 1, current 1
mx3-camera mx3-camera.0: MX3 Camera driver detached from camera 0

Also testing with my test application didn't show any problem.
When using more than 1 buffer (tested with 2, 3 and 4 queued
buffers) double buffering works as expected and frame numbers
toggle correctly. Capturing 30 frames produce:

mx3-camera mx3-camera.0: MX3 Camera driver attached to camera 0
idmac_interrupt(): IDMAC irq 177, buf 0, current 0
idmac_interrupt(): IDMAC irq 177, buf 1, current 1
idmac_interrupt(): IDMAC irq 177, buf 0, current 0
idmac_interrupt(): IDMAC irq 177, buf 1, current 1
idmac_interrupt(): IDMAC irq 177, buf 0, current 0
idmac_interrupt(): IDMAC irq 177, buf 1, current 1
idmac_interrupt(): IDMAC irq 177, buf 0, current 0
idmac_interrupt(): IDMAC irq 177, buf 1, current 1
idmac_interrupt(): IDMAC irq 177, buf 0, current 0
idmac_interrupt(): IDMAC irq 177, buf 1, current 1
idmac_interrupt(): IDMAC irq 177, buf 0, current 0
idmac_interrupt(): IDMAC irq 177, buf 1, current 1
idmac_interrupt(): IDMAC irq 177, buf 0, current 0
idmac_interrupt(): IDMAC irq 177, buf 1, current 1
idmac_interrupt(): IDMAC irq 177, buf 0, current 0
idmac_interrupt(): IDMAC irq 177, buf 1, current 1
idmac_interrupt(): IDMAC irq 177, buf 0, current 0
idmac_interrupt(): IDMAC irq 177, buf 1, current 1
idmac_interrupt(): IDMAC irq 177, buf 0, current 0
idmac_interrupt(): IDMAC irq 177, buf 1, current 1
idmac_interrupt(): IDMAC irq 177, buf 0, current 0
idmac_interrupt(): IDMAC irq 177, buf 1, current 1
idmac_interrupt(): IDMAC irq 177, buf 0, current 0
idmac_interrupt(): IDMAC irq 177, buf 1, current 1
idmac_interrupt(): IDMAC irq 177, buf 0, current 0
idmac_interrupt(): IDMAC irq 177, buf 1, current 1
idmac_interrupt(): IDMAC irq 177, buf 0, current 0
idmac_interrupt(): IDMAC irq 177, buf 1, current 1
idmac_interrupt(): IDMAC irq 177, buf 0, current 0
idmac_interrupt(): IDMAC irq 177, buf 1, current 1
mx3-camera mx3-camera.0: MX3 Camera driver detached from camera 0

Anatolij
