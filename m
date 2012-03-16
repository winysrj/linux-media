Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:48581 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756528Ab2CPN5h (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Mar 2012 09:57:37 -0400
Received: from epcpsbgm1.samsung.com (mailout2.samsung.com [203.254.224.25])
 by mailout2.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0M0Z000CRDFZ50K0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 16 Mar 2012 22:57:35 +0900 (KST)
Received: from AMDN157 ([106.116.48.215])
 by mmp2.samsung.com (Oracle Communications Messaging Exchange Server 7u4-19.01
 64bit (built Sep  7 2010)) with ESMTPA id <0M0Z004C4DG454A0@mmp2.samsung.com>
 for linux-media@vger.kernel.org; Fri, 16 Mar 2012 22:57:43 +0900 (KST)
From: Kamil Debski <k.debski@samsung.com>
To: 'javier Martin' <javier.martin@vista-silicon.com>,
	jtp.park@samsung.com
Cc: 'Sakari Ailus' <sakari.ailus@iki.fi>, linux-media@vger.kernel.org
References: <CACKLOr3T-w1JdaGgnL+ZEXFX4v_oVd0HY8mqrm5ZzxEziH32jw@mail.gmail.com>
 <20120315110336.GH4220@valkosipuli.localdomain>
 <006d01cd02ae$457fc960$d07f5c20$%debski@samsung.com>
 <CACKLOr1igHtcfMBHTdncSzHiBixt03WDJ-QSNvUn3sRe171e+A@mail.gmail.com>
In-reply-to: <CACKLOr1igHtcfMBHTdncSzHiBixt03WDJ-QSNvUn3sRe171e+A@mail.gmail.com>
Subject: RE: [Q] media: V4L2 compressed frames and s_fmt.
Date: Fri, 16 Mar 2012 14:57:30 +0100
Message-id: <003c01cd037c$bd3900b0$37ab0210$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: en-gb
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier, hi Jeongtae,

Please see my comments below.

> -----Original Message-----
> From: javier Martin [mailto:javier.martin@vista-silicon.com]
> Sent: 15 March 2012 15:31
> To: Kamil Debski
> Cc: Sakari Ailus; linux-media@vger.kernel.org
> Subject: Re: [Q] media: V4L2 compressed frames and s_fmt.
> 
> Hi Kamil, Sakari,
> thank you for your replies.
> 
> On 15 March 2012 14:19, Kamil Debski <k.debski@samsung.com> wrote:
> > Hi Javier, Sakari,
> >
> >> From: Sakari Ailus [mailto:sakari.ailus@iki.fi]
> >> Sent: 15 March 2012 12:04
> >>
> >> Hi Javier,
> >>
> >> (Cc Kamil.)
> >>
> >> On Wed, Mar 14, 2012 at 12:22:43PM +0100, javier Martin wrote:
> >> > Hi,
> >> > I'm developing a V4L2 mem2mem driver for the codadx6 IP video codec
> >> > which is included in the i.MX27 chip.
> >> >
> >> > The capture interface of this driver can therefore return h.264 or
> >> > mpeg4 video frames.
> >> >
> >> > Provided that the size of each frame varies and is unknown to the
> >> > user, how is the driver supposed to react to a S_FMT when it comes
> to
> >> > parameters such as the following?
> >> >
> >> > pix->width
> >> > pix->height
> >> > pix->bytesperline
> >> > pix->sizeimage
> >> >
> >> > According to the documentation [1] I understand that the driver can
> >> > just ignore 'bytesperline' and should return in 'sizeimage' the
> >> > maximum buffer size to store a compressed frame. However, it does
> not
> >> > mention anything special about width and height. Does it make sense
> >> > setting width and height for h.264/mpeg4 formats?
> >>
> >
> > Yes, in case of the compressed side (capture) the width, height and
> > bytesperline
> > is ignored. The MFC driver sets bytesperline to 0 and leaves width and
> height
> > intact
> > during S_FMT. I suggest you do the same or set all of them (width,
> height,
> > bytesperline)
> > to 0.
> 
> I'm not sure about that, according to the code in here [1] it ignores
> width and height, as you stated, but it fills bytesperline with the
> value in imagesize. This applies to TRY_FMT and S_FMT.
> On the other hand, in G_FMT [2], it sets width and height to 0, but
> bytesperline and sizeimage are set to ctx->enc_dst_buf_size, which I
> deduce it's the encoder buffer size.
> 
> If this is the agreed way of doing things I can just implement this
> behavior in my driver as well.
> 

The code was changing a lot during development. I think this is a mistake
to keep it that way - I see no need to set bytesperline and
sizeimage to the same value. There should be a fix sent that sets
bytesperline to 0.

Jeongtae, as you have done the encoding part, could you please prepare the
fix?

> Regards.
>
> [1] http://lxr.linux.no/#linux+v3.2.11/drivers/media/video/s5p-
> mfc/s5p_mfc_enc.c#L880
> [2] http://lxr.linux.no/#linux+v3.2.11/drivers/media/video/s5p-
> mfc/s5p_mfc_enc.c#L844
> --
> Javier Martin
> Vista Silicon S.L.
> CDTUC - FASE C - Oficina S-345
> Avda de los Castros s/n
> 39005- Santander. Cantabria. Spain
> +34 942 25 32 60
> www.vista-silicon.com

Best wishes,
--
Kamil Debski
Linux Platform Group
Samsung Poland R&D Center


