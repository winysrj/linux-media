Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:35407 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751319AbdJEITk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Oct 2017 04:19:40 -0400
Message-ID: <1507191578.8473.1.camel@pengutronix.de>
Subject: Re: platform: coda: how to use firmware-imx binary releases?
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Martin Kepplinger <martink@posteo.de>
Cc: mchehab@kernel.org, linux-media@vger.kernel.org
Date: Thu, 05 Oct 2017 10:19:38 +0200
In-Reply-To: <7dd05afd338e81d293d0424e0b8e6b6a@posteo.de>
References: <ef7cc5b91829f383842a1e4692af5b07@posteo.de>
         <1507108964.11691.6.camel@pengutronix.de>
         <7dd05afd338e81d293d0424e0b8e6b6a@posteo.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Martin,

On Thu, 2017-10-05 at 09:43 +0200, Martin Kepplinger wrote:
> I'm running a little off-topic here, but with the newest firmware too, 
> my
> coda driver says "Video Data Order Adapter: Disabled" when started
> by video playback via v4l2.

This message is most likely just a result of the VDOA not supporting the
selected capture format. In vdoa_context_configure, you can see that the
VDOA only writes YUYV or NV12.

> (imx6, running linux 4.14-rc3, imx-vdoa is probed and never removed,
> a dev_info "probed" would maybe be useful for others too?)
> 
> It supsequently fails with
> 
> cma: cma_alloc: alloc failed, req-size: 178 pages, ret: -12

That is -ENOMEM. Is CMA enabled and sufficiently large? For example,

CONFIG_CMA=y
CONFIG_CMA_DEBUGFS=y
CONFIG_DMA_CMA=y
CONFIG_CMA_SIZE_MBYTES=256
CONFIG_CMA_SIZE_SEL_MBYTES=y

> which may or may not be related to having the vdoa (is it?), but 
> shouldn't the VDOA module be active by default?
> 
> # cat /sys/module/coda/parameters/disable_vdoa
> 0

I think it is not related to VDOA at all. Yes, by default the VDOA
should be activated automatically for any supported format.

regards
Philipp
