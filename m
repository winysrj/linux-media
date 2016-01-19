Return-path: <linux-media-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:28994 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754554AbcASOwR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jan 2016 09:52:17 -0500
Date: Tue, 19 Jan 2016 15:52:24 +0100
From: Ludovic Desroches <ludovic.desroches@atmel.com>
To: Josh Wu <rainyfeeling@gmail.com>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Nicolas Ferre <nicolas.ferre@atmel.com>,
	<linux-arm-kernel@lists.infradead.org>,
	Ludovic Desroches <ludovic.desroches@atmel.com>,
	Songjun Wu <songjun.wu@atmel.com>
Subject: Re: [PATCH 00/13] media: atmel-isi: extract the hw releated
 functions into structure
Message-ID: <20160119145224.GI10663@odux.rfo.atmel.com>
References: <1453119709-20940-1-git-send-email-rainyfeeling@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1453119709-20940-1-git-send-email-rainyfeeling@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Josh,

On Mon, Jan 18, 2016 at 08:21:36PM +0800, Josh Wu wrote:
> This series refactor the atmel-isi drvier. In the meantime, extract all
> the hardware related functions, and made it as function table. Also add
> some hardware data.
> 
> All those hardware functions, datas are defined with the compatible
> string.
> 
> In this way, it is easy to add another compatible string for new
> hardware support.

What is the goal of these patches? I mean is it to ease the support of
ISC?

Discussing with Songjun, I understand that he wanted to have one driver
for ISI and one for ISC but I have the feeling that your patches go in
the opposite direction. What is your mind about this?

Thanks

Regards

Ludovic

> 
> 
> Josh Wu (13):
>   atmel-isi: use try_or_set_fmt() for both set_fmt() and try_fmt()
>   atmel-isi: move the is_support() close to try/set format function
>   atmel-isi: add isi_hw_initialize() function to handle hw setup
>   atmel-isi: move the cfg1 initialize to isi_hw_initialize()
>   atmel-isi: add a function: isi_hw_wait_status() to check ISI_SR status
>   atmel-isi: check ISI_SR's flags by polling instead of interrupt
>   atmel-isi: move hw code into isi_hw_initialize()
>   atmel-isi: remove the function set_dma_ctrl() as it just use once
>   atmel-isi: add a function start_isi()
>   atmel-isi: reuse start_dma() function in isi interrupt handler
>   atmel-isi: add hw_uninitialize() in stop_streaming()
>   atmel-isi: use union for the fbd (frame buffer descriptor)
>   atmel-isi: use an hw_data structure according compatible string
> 
>  drivers/media/platform/soc_camera/atmel-isi.c | 529 ++++++++++++++------------
>  1 file changed, 277 insertions(+), 252 deletions(-)
> 
> -- 
> 1.9.1
> 
