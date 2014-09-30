Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:14370 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467AbaI3OeM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Sep 2014 10:34:12 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NCP00B7HXXS5Q40@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 30 Sep 2014 15:37:04 +0100 (BST)
From: Kamil Debski <k.debski@samsung.com>
To: 'Hans Verkuil' <hverkuil@xs4all.nl>,
	'Philipp Zabel' <p.zabel@pengutronix.de>
Cc: 'Mauro Carvalho Chehab' <m.chehab@samsung.com>,
	'Hans Verkuil' <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org, kernel@pengutronix.de
References: <1412071031-32016-1-git-send-email-p.zabel@pengutronix.de>
 <542AB39B.9010006@xs4all.nl> <1412086849.3692.3.camel@pengutronix.de>
 <542ABD1F.9000701@xs4all.nl>
In-reply-to: <542ABD1F.9000701@xs4all.nl>
Subject: RE: [PATCH 00/10] CODA7 JPEG support
Date: Tue, 30 Sep 2014 16:34:08 +0200
Message-id: <0d2c01cfdcbb$98df2670$ca9d7350$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

> From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
> Sent: Tuesday, September 30, 2014 4:25 PM
> To: Philipp Zabel
> Cc: Kamil Debski; Mauro Carvalho Chehab; Hans Verkuil; linux-
> media@vger.kernel.org; kernel@pengutronix.de
> Subject: Re: [PATCH 00/10] CODA7 JPEG support
> 
> On 09/30/14 16:20, Philipp Zabel wrote:
> > Hi Hans,
> >
> > Am Dienstag, den 30.09.2014, 15:43 +0200 schrieb Hans Verkuil:
> >> On 09/30/14 11:57, Philipp Zabel wrote:
> >>> Hi,
> >>>
> >>> These patches add JPEG encoding and decoding support for CODA7541
> (i.MX5).
> >>> The encoder video device is split into one video device per codec,
> >>> so that each video device can register only the relevant controls.
> >>> The H.264/MPEG4 decoder is kept as one video device, but the JPEG
> >>> decoder video device is separate because it supports more
> >>> uncompressed formats (currently YUV422P, in the future grayscale or
> YUV 4:4:4 support could be added).
> >>
> >> Normally device nodes are linked to DMA engines, so the only reason
> >> why you would have e.g. two video nodes is if you can capture from
> >> both at the same time. Is that the case here as well? If not, then
> it
> >> really should be a single video node. That not all controls are
> >> relevant for the currently chosen codec is not important.
> >>
> >> Are there other reasons than the controls to split it up into
> >> multiple video devices?
> >
> > I had already split the encoder and decoder parts of this mem2mem
> > device into two video devices because of the issue of changing
> > available capture formats depending on the selected output format.
> > The motivation for splitting the JPEG codecs from the H264/MPEG4
> > codecs is the same: to avoid the appearing and disappearing of the
> > YUV422P format on the uncompressed side whenever the compressed
> format
> > changes between JPEG and H264/MPEG4. I could keep the H264 and MPEG4
> > encoders combined without running into this issue.
> >
> > Furthermore, I want to change the output queue for the currently
> > available decoders to use vb2-vmalloc eventually (because the CPU has
> > to copy incoming frames into the bitstream buffer), but have to keep
> > using vb2-dma-contig for the CODA960 JPEG decoder, which will have
> the
> > hardware read from the incoming buffers directly.
> 
> Based on this description I think it makes sense to split off the JPEG
> encoder, but I would keep H264/MPEG4 together. Kamil, what's your
> opinion on this?

I agree with you Hans. MFC has a single encoder node that supports multiple
codecs and I think this design works well.

JPEG should be separated into separate device.

Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland



