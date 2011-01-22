Return-path: <mchehab@pedra>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:1515 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546Ab1AVRQr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Jan 2011 12:16:47 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Anca Emanuel <anca.emanuel@gmail.com>
Subject: Re: camera on Freescale i.MX51
Date: Sat, 22 Jan 2011 18:16:34 +0100
Cc: Claudiu Covaci <claudiu.covaci@gmail.com>,
	linux-media@vger.kernel.org,
	"Jean-Francois Moine" <moinejf@free.fr>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
References: <AANLkTi=5JiLiD+jcB-6X48aNOEhwWVoM+_1fEEzE7WR+@mail.gmail.com> <AANLkTikE3cNBu5QjdAxXhV9v7HhHziyyYBgfq-ZPohCj@mail.gmail.com>
In-Reply-To: <AANLkTikE3cNBu5QjdAxXhV9v7HhHziyyYBgfq-ZPohCj@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <201101221816.34464.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Saturday, January 22, 2011 11:28:33 Anca Emanuel wrote:
> On Tue, Jan 18, 2011 at 3:37 PM, Claudiu Covaci
> <claudiu.covaci@gmail.com> wrote:
> > Hi,
> >
> > I'm have trouble receiving a video stream on the Freescale i.MX51
> > processor. I've tried everything I could think, so I'm trying my luck
> > here.
> >
> > I'm using a 2.6.31 kernel with some modifications: the camera capture
> > driver [1] and the IPU (Image Processing Unit) driver [2] from the
> > Freescale BSP 2010.11.
> >
> > I'm at a point where I can open the /dev/video0 device and can (at
> > least try to) read frames, but it fails at dequeueing the video
> > buffers (VIDIOC_DQBUF) with the message:
> > <3>ERROR: v4l2 capture: mxc_v4l_dqueue timeout enc_counter 0
> > Unable to dequeue buffer (62).
> >
> > - I've double-checked the IPU registers and they seem properly
> > configured, but I don't get any interrupt (at end-of-frame).
> > - The relevant IOMUX pins are also configured.
> > - the video signal appears at the i.MX pins (so it gets there)
> > - I've also tried activating the internal picture generator, but still
> > nothing happens.
> >
> > Is there anything I overlooked? Is there a way to find out where the
> > problem is? Any hints will be greatly appreciated.
> >
> > Thanks!
> > Claudiu
> >
> > [1] http://opensource.freescale.com/git?p=imx/linux-2.6-imx.git;a=blob;f=drivers/media/video/mxc/capture/mxc_v4l2_capture.c;h=8133d202304eea22e94bbd8eaaa215002b2dc675;hb=0fae922f451a5bde63595a2e0c2cd7079f083440
> >
> > [2] http://opensource.freescale.com/git?p=imx/linux-2.6-imx.git;a=tree;f=drivers/mxc/ipu3;h=288c21f88aa650d16d843dccec2b04ba9f1462f7;hb=0fae922f451a5bde63595a2e0c2cd7079f083440
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> 
> Hi Hans, Jean, Mauro:
> No ideea to help Claudiu ?

Not me, no. But since no interrupt arrives that typically means that either
some pin assignments are wrong or some video format settings are wrong.

>From personal experience with other (non-freescale) boards in the past I
know that that can be hard to track down.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
