Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:4464 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbaI3OZT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Sep 2014 10:25:19 -0400
Message-ID: <542ABD1F.9000701@xs4all.nl>
Date: Tue, 30 Sep 2014 16:24:31 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>
CC: Kamil Debski <k.debski@samsung.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH 00/10] CODA7 JPEG support
References: <1412071031-32016-1-git-send-email-p.zabel@pengutronix.de>	 <542AB39B.9010006@xs4all.nl> <1412086849.3692.3.camel@pengutronix.de>
In-Reply-To: <1412086849.3692.3.camel@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/30/14 16:20, Philipp Zabel wrote:
> Hi Hans,
> 
> Am Dienstag, den 30.09.2014, 15:43 +0200 schrieb Hans Verkuil:
>> On 09/30/14 11:57, Philipp Zabel wrote:
>>> Hi,
>>>
>>> These patches add JPEG encoding and decoding support for CODA7541 (i.MX5).
>>> The encoder video device is split into one video device per codec, so that
>>> each video device can register only the relevant controls. The H.264/MPEG4
>>> decoder is kept as one video device, but the JPEG decoder video device is
>>> separate because it supports more uncompressed formats (currently YUV422P,
>>> in the future grayscale or YUV 4:4:4 support could be added).
>>
>> Normally device nodes are linked to DMA engines, so the only reason why you
>> would have e.g. two video nodes is if you can capture from both at the same
>> time. Is that the case here as well? If not, then it really should be a
>> single video node. That not all controls are relevant for the currently
>> chosen codec is not important.
>>
>> Are there other reasons than the controls to split it up into multiple video
>> devices?
> 
> I had already split the encoder and decoder parts of this mem2mem device
> into two video devices because of the issue of changing available
> capture formats depending on the selected output format.
> The motivation for splitting the JPEG codecs from the H264/MPEG4 codecs
> is the same: to avoid the appearing and disappearing of the YUV422P
> format on the uncompressed side whenever the compressed format changes
> between JPEG and H264/MPEG4. I could keep the H264 and MPEG4 encoders
> combined without running into this issue.
> 
> Furthermore, I want to change the output queue for the currently
> available decoders to use vb2-vmalloc eventually (because the CPU has to
> copy incoming frames into the bitstream buffer), but have to keep using
> vb2-dma-contig for the CODA960 JPEG decoder, which will have the
> hardware read from the incoming buffers directly.

Based on this description I think it makes sense to split off the JPEG
encoder, but I would keep H264/MPEG4 together. Kamil, what's your opinion
on this?

Regards,

	Hans

