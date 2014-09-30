Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:4763 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728AbaI3Noq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Sep 2014 09:44:46 -0400
Message-ID: <542AB39B.9010006@xs4all.nl>
Date: Tue, 30 Sep 2014 15:43:55 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>,
	Kamil Debski <k.debski@samsung.com>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH 00/10] CODA7 JPEG support
References: <1412071031-32016-1-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1412071031-32016-1-git-send-email-p.zabel@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/30/14 11:57, Philipp Zabel wrote:
> Hi,
> 
> These patches add JPEG encoding and decoding support for CODA7541 (i.MX5).
> The encoder video device is split into one video device per codec, so that
> each video device can register only the relevant controls. The H.264/MPEG4
> decoder is kept as one video device, but the JPEG decoder video device is
> separate because it supports more uncompressed formats (currently YUV422P,
> in the future grayscale or YUV 4:4:4 support could be added).

Normally device nodes are linked to DMA engines, so the only reason why you
would have e.g. two video nodes is if you can capture from both at the same
time. Is that the case here as well? If not, then it really should be a
single video node. That not all controls are relevant for the currently
chosen codec is not important.

Are there other reasons than the controls to split it up into multiple video
devices?

Regards,

	Hans

> 
> regards
> Philipp
> 
> Philipp Zabel (10):
>   [media] coda: add support for planar YCbCr 4:2:2 (YUV422P) format
>   [media] coda: identify platform device earlier
>   [media] coda: add coda_video_device descriptors
>   [media] coda: split out encoder control setup to specify controls per
>     video device
>   [media] coda: add JPEG register definitions for CODA7541
>   [media] coda: add CODA7541 JPEG support
>   [media] coda: store bitstream buffer position with buffer metadata
>   [media] coda: pad input stream for JPEG decoder
>   [media] coda: try to only queue a single JPEG into the bitstream
>   [media] coda: allow userspace to set compressed buffer size in a
>     certain range
> 
>  drivers/media/platform/coda/Makefile      |   2 +-
>  drivers/media/platform/coda/coda-bit.c    | 204 +++++++---
>  drivers/media/platform/coda/coda-common.c | 608 +++++++++++++++++++-----------
>  drivers/media/platform/coda/coda-jpeg.c   | 225 +++++++++++
>  drivers/media/platform/coda/coda.h        |  21 +-
>  drivers/media/platform/coda/coda_regs.h   |   7 +
>  6 files changed, 785 insertions(+), 282 deletions(-)
>  create mode 100644 drivers/media/platform/coda/coda-jpeg.c
> 

