Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:51132 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753515AbZCKLsD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Mar 2009 07:48:03 -0400
Date: Wed, 11 Mar 2009 12:48:03 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: morimoto.kuninori@renesas.com
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Magnus <magnus.damm@gmail.com>, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH] ov772x: Add extra setting method
In-Reply-To: <uwsb6kjnl.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.0903111232340.4818@axis700.grange>
References: <u63irl9dx.wl%morimoto.kuninori@renesas.com>
 <Pine.LNX.4.64.0903030843090.5059@axis700.grange> <uwsb6kjnl.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 3 Mar 2009, morimoto.kuninori@renesas.com wrote:

> > can be. For instance, maybe there are only two variants like 
> > lens-configuration-A and lens-configuration-B? Then I would just add 
> > respective flags to platform data. If there are really many variants, 
> > maybe we can let user-space configure them using VIDIOC_DBG_S_REGISTER? 
> > Can you maybe explain to me at least approximately what those lens 
> > settings are doing?
> 
> well...  useing VIDIOC_DBG_S_REGISTER is not good idea for me.
> Because we have to add CONFIG_VIDEO_ADY_DEBUG option which is for debug.
> 
> ap325 lens setting have
> 
> o a lot of common control register setting
> o AGC/AEC/BLC/DSP/AWB setting
> o Banding filter
> o Y/G channel average value
> o color value
> 
> a lot of register will be set.
> like this
> 
> +static const struct regval_list ov7725_lens [] = {
> +	{ 0x09, 0x00 }, { 0x0D, 0x61 }, { 0x0E, 0xD5 }, { 0x0F, 0xC5 },
> +	{ 0x10, 0x25 }, { 0x11, 0x01 }, { 0x13, 0xEF }, { 0x14, 0x41 },
> +	{ 0x22, 0x7F }, { 0x23, 0x03 }, { 0x24, 0x40 }, { 0x25, 0x30 },
> +	{ 0x26, 0x82 }, { 0x2F, 0x35 }, { 0x37, 0x81 }, { 0x39, 0x6C },
> +	{ 0x3A, 0x8C }, { 0x3B, 0xBC }, { 0x3C, 0xC0 }, { 0x3D, 0x03 },
> +	{ 0x40, 0xE8 }, { 0x41, 0x00 }, { 0x42, 0x7F }, { 0x49, 0x00 },
> +	{ 0x4A, 0x00 }, { 0x4B, 0x00 }, { 0x4C, 0x00 }, { 0x4D, 0x09 },
> +	{ 0x60, 0x00 }, { 0x61, 0x05 }, { 0x63, 0xE0 }, { 0x64, 0xFF },
> +	{ 0x65, 0x20 }, { 0x66, 0x00 }, { 0x69, 0x9E }, { 0x6B, 0x2D },
> +	{ 0x6C, 0x09 }, { 0x6E, 0x72 }, { 0x6F, 0x4D }, { 0x70, 0x12 },
> +	{ 0x71, 0xBF }, { 0x72, 0x0D }, { 0x73, 0x12 }, { 0x74, 0x12 },
> +	{ 0x76, 0x00 }, { 0x77, 0x3A }, { 0x78, 0x23 }, { 0x79, 0x22 },
> +	{ 0x7A, 0x41 }, { 0x7E, 0x04 }, { 0x7F, 0x0E }, { 0x80, 0x20 },
> +	{ 0x81, 0x43 }, { 0x82, 0x53 }, { 0x83, 0x61 }, { 0x84, 0x6D },
> +	{ 0x85, 0x76 }, { 0x86, 0x7E }, { 0x87, 0x86 }, { 0x88, 0x94 },
> +	{ 0x89, 0xA1 }, { 0x8A, 0xC5 }, { 0x8E, 0x03 }, { 0x8F, 0x02 },
> +	{ 0x90, 0x05 }, { 0x91, 0x01 }, { 0x92, 0x03 }, { 0x93, 0x00 },
> +	{ 0x94, 0x7A }, { 0x95, 0x75 }, { 0x96, 0x05 }, { 0x97, 0x22 },
> +	{ 0x98, 0x63 }, { 0x99, 0x85 }, { 0x9A, 0x1E }, { 0x9B, 0x08 },
> +	{ 0x9C, 0x20 }, { 0x9E, 0x00 }, { 0x9F, 0xF8 }, { 0xA0, 0x02 },
> +	{ 0xA1, 0x50 }, { 0xA6, 0x04 }, { 0xA7, 0x30 }, { 0xA8, 0x30 },
> +	{ 0xAA, 0x00 }, ENDMARKER,
> +};

Ok, this is indeed a lot, still, we should do this properly. After a 
discussion with Hans on IRC the general conclusion was "noone outside of 
the device driver shall even know device registers." I think, we shall 
split this huge array in at least 3 groups:

1. default, that's also valid for other setups with this chip. as you 
describe this, this set might be empty...

2. settings, for which controls exist, or can be meaningfully added. For 
example, there are controls for gain, exposure, auto white balance,...

3. a configuration struct with meaningfully named _and_ documented fields. 
I.e., plese, do not name fields like "r17" or similar:-) This becomes even 
more important in the absence of a publicly available datasheet. Also, the 
struct field -- register relationship doesn't have to be one-to-one. I.e., 
might well be that one field affects several registers, or several fields 
affect one register.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
