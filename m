Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:54365 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756390AbZCWIPe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Mar 2009 04:15:34 -0400
Date: Mon, 23 Mar 2009 09:15:38 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: morimoto.kuninori@renesas.com
cc: Linux Media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] ov772x: add edge contrl support
In-Reply-To: <u8wmw1x4c.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.0903230911130.4527@axis700.grange>
References: <uab7c249a.wl%morimoto.kuninori@renesas.com>
 <Pine.LNX.4.64.0903230829510.4476@axis700.grange> <u8wmw1x4c.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 23 Mar 2009, morimoto.kuninori@renesas.com wrote:

> Dear Guennadi
> 
> Thank you for checking
> 
> > Wouldn't it be easier to use
> > 
> > 	unsigned char	edge_strength;
> > 	unsigned char	edge_threshold;
> > 	unsigned char	edge_low;
> > 	unsigned char	edge_high;
> > 
> > and thus avoid all that shifting?
> 
> Yes. it is easier to use.
> But, driver should judge whether to use this setting or not.
> Because this setting is optional.
> 
> Because user setting might be 0,
> we can not judge it like this.
>   if (edge_xxx)
>        ov772x_mask_set( xxxx )
> 
> So, we can use un-used bit to judge whether to use it.
> and edge_strength and edge_threshold have un-used bit.
> But edge_low and edge_high doesn't have un-used bit.
> 
> Another way to judge it is to use pointer or to add another variable.
> But I don't like these style.
> What do you think about this ?

Is edge_strength == 0 a useful edge configuration? Cannot you use it as a 
test whether to set all edge parameters or not? If you cannot, well, just 
do the same as what you have done with 32-bits - use one bit in strength 
as "edge enable" - just exactly in the same way as in your patch. Like

	if (edge_strength & EDGE_ENABLE) {
		set_strength;
		set_threshold;
		set_low;
		set_high;
	}

Thanks
Guennadi
---
Guennadi Liakhovetski
