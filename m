Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:57982 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727615AbeJEBqJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 4 Oct 2018 21:46:09 -0400
Date: Thu, 4 Oct 2018 15:51:32 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>
Subject: Re: [GIT PULL FOR v4.20] Various fixes
Message-ID: <20181004155132.40bb0405@coco.lan>
In-Reply-To: <616ee393-6487-5830-08ee-2d916912be37@xs4all.nl>
References: <616ee393-6487-5830-08ee-2d916912be37@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 1 Oct 2018 11:56:22 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> The following changes since commit 4158757395b300b6eb308fc20b96d1d231484413:
> 
>   media: davinci: Fix implicit enum conversion warning (2018-09-24 09:43:13 -0400)
> 
> are available in the Git repository at:
> 
>   git://linuxtv.org/hverkuil/media_tree.git tags/tag-v4.20d
> 
> for you to fetch changes up to f7a1170fcc19617647c78262a79abdec7b0a08cd:
> 
>   media: i2c: adv748x: fix typo in comment for TXB CSI-2 transmitter power down (2018-10-01 11:09:09 +0200)
> 
> ----------------------------------------------------------------
> Tag branch
> 
> ----------------------------------------------------------------
> Arnd Bergmann (1):
>       media: imx-pxp: include linux/interrupt.h
> 
> Benjamin Gaignard (1):
>       MAINTAINERS: fix reference to STI CEC driver
> 
> Colin Ian King (1):
>       media: zoran: fix spelling mistake "queing" -> "queuing"
> 
> Dan Carpenter (1):
>       VPU: mediatek: don't pass an unused parameter
> 
> Hans Verkuil (1):
>       vidioc-dqevent.rst: clarify V4L2_EVENT_SRC_CH_RESOLUTION
> 
> Hugues Fruchet (1):
>       media: stm32-dcmi: only enable IT frame on JPEG capture
> 
> Jacopo Mondi (4):
>       media: i2c: adv748x: Support probing a single output
>       media: i2c: adv748x: Handle TX[A|B] power management
>       media: i2c: adv748x: Conditionally enable only CSI-2 outputs
>       media: i2c: adv748x: Register only enabled inputs
> 
> Laurent Pinchart (1):
>       MAINTAINERS: Remove stale file entry for the Atmel ISI driver

Dropped this patch, as it is not right: the file was just moved to
a different place. Posted a replacement patch for it at the ML.

Applied the remaining ones.

Regards,
Mauro
