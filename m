Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:35554 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751198AbZBBHnn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Feb 2009 02:43:43 -0500
Date: Mon, 2 Feb 2009 08:43:48 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: morimoto.kuninori@renesas.com
cc: Linux Media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] tw9910: color format check is added on set_fmt
In-Reply-To: <upri1zo3w.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.0902020836490.4218@axis700.grange>
References: <uwscdm9t7.wl%morimoto.kuninori@renesas.com>
 <Pine.LNX.4.64.0902011907020.17985@axis700.grange> <upri1zo3w.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2 Feb 2009, morimoto.kuninori@renesas.com wrote:

> > > Signed-off-by: Kuninori Morimoto <morimoto.kuninori@renesas.com>
> > 
> > Why is this needed? Do you see any possibility for tw9910 to be called 
> > with an unsupported format?
> 
> for example,
> capture_example -f use V4L2_PIX_FMT_YUYV.
> but tw9910 support only V4L2_PIX_FMT_VYUY now.

But are you actually getting this set_fmt(V4L2_PIX_FMT_YUYV) in your 
tw9910 driver? If yes, then this is a bug elsewhere. It shouldn't get this 
far. It should be caught earlier along the path

soc_camera_s_fmt_vid_cap()
	soc_camera_try_fmt_vid_cap()
		sh_mobile_ceu_try_fmt()
			soc_camera_xlate_by_fourcc()
				<error>

> If you think this patch is unnecessary,
> please ignore it.

Could you please test whether you indeed can get an unsupported format in 
your driver. If so, this is a bug at a higher level and we'll have to fix 
it there. I'll drop this patch for now.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
