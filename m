Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:38639 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932351Ab2CYXmY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Mar 2012 19:42:24 -0400
Received: by wibhj6 with SMTP id hj6so3740836wib.1
        for <linux-media@vger.kernel.org>; Sun, 25 Mar 2012 16:42:23 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 25 Mar 2012 17:42:23 -0600
Message-ID: <CAGD8Z76xfCUO8Ho9m2jEmEYMajR=e1MXuDLqriPbRNs_zD621w@mail.gmail.com>
Subject: Re: reading config parameters of omap3-isp subdevs
From: Joshua Hintze <joshua.hintze@gmail.com>
To: laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I was just wondering the same thing as far as reading the current
settings. The reason why I would want to read the settings (could be
different than Michael's) is that there are a lot of settings that I
am still unfamiliar with yet. I don't know the default values. So by
being able to read the entire settings and adjust only the white
balance gain or such would make the learning process considerably less
sharp. I would love to have the read option.

Josh


Hi Michael,

On Friday 16 March 2012 15:06:15 Michael Jones wrote:
> Hi all,
>
> I am playing around with some parameters in the previewer on the ISP. With
> ioctl VIDIOC_OMAP3ISP_PRV_CFG I am able to write the various parameters but
> what I'm missing is a way to read them. For example, I have no way to adjust
> only coef2 in 'struct omap3isp_prev_wbal' while leaving the others
> unchanged. If I could first read the whole omap3isp_prev_wbal structure,
> then I could change just the things I want to change. This seems like it
> would be common functionality for such ioctls. I didn't find any previous
> discussion related to this.
>
> I could imagine either adding a r/w flag to 'struct
> omap3isp_prev_update_config' or adding a new ioctl entirely. I think I
> would prefer the r/w flag.  Feedback?
>
> I noticed that other ISP subdevs have similar ioctls.  Perhaps a similar
> thing would be useful there, but right now I'm only looking at the
> previewer.

Adding a R/W bit to the flag argument should indeed work. However, I'm
wondering what your use case for reading parameters back is. The preview
engine parameter structures seem pretty-much self-contained to me, I'm not
sure it would make sense to only modify one of the parameters.

-- 
Regards,

Laurent Pinchart
