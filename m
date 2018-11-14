Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:60307 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728686AbeKOBDH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Nov 2018 20:03:07 -0500
Message-ID: <1542207571.4095.12.camel@pengutronix.de>
Subject: Re: [PATCH 04/15] media: coda: limit queueing into internal
 bitstream buffer
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de
Date: Wed, 14 Nov 2018 15:59:31 +0100
In-Reply-To: <20181105152513.26345-4-p.zabel@pengutronix.de>
References: <20181105152513.26345-1-p.zabel@pengutronix.de>
         <20181105152513.26345-4-p.zabel@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I forgot to add the proper SoB tag:

On Mon, 2018-11-05 at 16:25 +0100, Philipp Zabel wrote:
> From: Lucas Stach <l.stach@pengutronix.de>
> 
> The ringbuffer used to hold the bitstream is very conservatively sized,
> as keyframes can get very large and still need to fit into this buffer.
> This means that the buffer is way oversized for the average stream to
> the extend that it will hold a few hundred frames when the video data
> is compressing well.
> 
> The current strategy of queueing as much bitstream data as possible
> leads to large delays when draining the decoder. In order to keep the
> drain latency to a reasonable bound, try to only queue a full reorder
> window of buffers. We can't always hit this low target for very well
> compressible video data, as we might end up with less than the minimum
> amount of data that needs to be available to the bitstream prefetcher,
> so we must take this into account and allow more buffers to be queued
> in this case.
> 
> Signed-off-by: Lucas Stach <l.stach@pengutronix.de>

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>

regards
Philipp
