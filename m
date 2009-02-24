Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:59031 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754433AbZBXNRr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Feb 2009 08:17:47 -0500
Date: Tue, 24 Feb 2009 14:17:55 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: morimoto.kuninori@renesas.com
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: About the specific setting for lens
In-Reply-To: <ur61pd8h5.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.0902241416080.4494@axis700.grange>
References: <ur61pd8h5.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 23 Feb 2009, morimoto.kuninori@renesas.com wrote:

> 
> Dear Guennadi.
> 
> Now MigoR and AP325 board have ov772x camera.
> However, the lens used is different.
> 
> And I have a specific good setting value
> for the lens of AP325.
> 
> So, I would like to add new function for
> specific lens value.
> meybe like this.
> Can I add it ?
> 
> -- board-ap325 ---------------
> static const struct regval_list ov772x_lens[] = {
>        { 0xAA, 0xBB }, { 0xCC, 0xDD }, { 0xEE, 0xFF },
>        ...
>        ENDMARKER,
> }
> 
> static struct ov772x_camera_info ov772x_info = {
>        ...
>        .lenssetting = ov772x_lens,
> }

Hm, lenses can be replaced in principle, right? Does it really make sense 
to hard-code them in platform code? Maybe better as module parameter? Or 
are these parameters really board-specific?

Thanks
Guennadi

> -----------------
> --- ov772x.c ----
> static int ov772x_start_capture(xxx)
> {
>         ...
>         if (priv->info->lenssetting) {
>            ret = ov772x_write_array(priv->client,
>                                     priv->info->lenssetting);
>            if (ret < 0)
>                goto error;
>         }
>         ...           
> }
> -----------------
> 
> Best regards
> --
> Kuninori Morimoto
>  
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
