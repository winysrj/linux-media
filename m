Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:34910 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753348Ab0GMOfB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Jul 2010 10:35:01 -0400
Date: Tue, 13 Jul 2010 16:35:14 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Add interlace support to sh_mobile_ceu_camera.c
In-Reply-To: <w3pd3uskwpw.wl%kuninori.morimoto.gx@renesas.com>
Message-ID: <Pine.LNX.4.64.1007131622010.26727@axis700.grange>
References: <uvdtrmtin.wl%morimoto.kuninori@renesas.com>
 <Pine.LNX.4.64.1007120900430.7130@axis700.grange>
 <w3pd3uskwpw.wl%kuninori.morimoto.gx@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 13 Jul 2010, Kuninori Morimoto wrote:

> 
> Dear Guennadi
> 
> > I've got a question to you, regarding your interlaced support 
> > implementation for the CEU: do I understand it right, that the kind of 
> > support you actually have implemented is, that if an interlaced format is 
> > now requested from the CEU, it will interpret incoming data as interlaced 
> > and deinterlace it internally? 
> 
> It is correct excluding "interlaced format is now requested from the CEU". 
> Now, the device which request interlace format is video device.
> If you use Ecovec, it is tw9910.

That's one part of the equation, yes.

> > If this is really the case, then, I think, 
> > it is a wrong way to implement this functionality. If a user requests 
> > interlaced data, it means, (s)he wants it interlaced in memory. Whereas 
> > deinterlacing should happen transparently - if the user requested 
> > progressive data and your source provides interlaced, you can decide to 
> > deinterlace it internally. Or am I misunderstanding your implementation?
> 
> Hmm...
> Now only "CEU + tw9910" pair use interlace mode in CEU.
> But it doesn't support interlace mode from "user space".
> (I don't know how to request it from user space)

The S_FMT ioctl() has a field "fmt.pix.field," which carries exactly this 
information. So, by executing this ioctl() with different field values you 
request progressive or one of interlaced formats. And returning 
"interlaced," when you actually supply progressive data to the user is not 
a good idea, and this is what's currently happening, I think. It's just 
our luck, that mplayer (and gstreamer?) ignore returned field value. But 
we'll have to fix this in sh_mobile_ceu_camera.

> Now interlace mode is used internally.
> This mean, it seems as "progressive mode" from user space.

Exactly, we return progressive data, but give "interlaced" back in reply 
to S_FMT. Or at least we do not differentiate between "user field setting" 
and "driver field setting," which we really should.

> > Regardless of theoretical correctness - does your patch still work? Have 
> > you been able back then to get CEU to deinterlace data, and when have you 
> > last tested it?
> 
> I tested CEU interlace mode by using Ecovec board.
> I can watch correct video image on at least v2.6.34.
> 
> I used this command.
> 
> VIDIX="-vo fbdev:vidix:sh_veu"
> SIZE="-tv width=1280:height=720"
> NTSC="-tv norm=NTSC"
> OUT="tv:// -tv outfmt=nv12"
> DEVICE="-tv device=/dev/video0"
> mplayer ${VIDIX} ${SIZE} ${NTSC} ${OUT} ${DEVICE}

Well, I think, 720p is a little too optimistic for tw9910;) tw9910 works 
on migor for me, but not on ecovec, although the chip can be detected. Are 
there any modifications necessary to the kernel or to the board to get it 
to work? Maybe a jumper or something? I plug in a video signal source in 
the "video in" connector, next to the "viceo out" one, using the same 
cable, so, cabling should work too. But I'm only getting select timeouts 
and no interrupts on the CEU.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
