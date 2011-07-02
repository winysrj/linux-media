Return-path: <mchehab@pedra>
Received: from tex.lwn.net ([70.33.254.29]:36615 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868Ab1GBNvb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 2 Jul 2011 09:51:31 -0400
Date: Sat, 2 Jul 2011 07:51:30 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: "linux-media" <linux-media@vger.kernel.org>
Subject: Re: Missing 'select VIDEOBUF2_DMA_CONTIG'
Message-ID: <20110702075130.3d3abeb8@bike.lwn.net>
In-Reply-To: <201107021116.44556.hverkuil@xs4all.nl>
References: <201107021116.44556.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sat, 2 Jul 2011 11:16:44 +0200
Hans Verkuil <hverkuil@xs4all.nl> wrote:

> I think this is missing:
> 
> diff --git a/drivers/media/video/marvell-ccic/Kconfig b/drivers/media/video/marvell-ccic/Kconfig
> index 22314a0..68ff5d6 100644
> --- a/drivers/media/video/marvell-ccic/Kconfig
> +++ b/drivers/media/video/marvell-ccic/Kconfig
> @@ -3,6 +3,7 @@ config VIDEO_CAFE_CCIC
>  	depends on PCI && I2C && VIDEO_V4L2
>  	select VIDEO_OV7670
>  	select VIDEOBUF2_VMALLOC
> +	select VIDEOBUF2_DMA_CONTIG
>  	---help---
>  	  This is a video4linux2 driver for the Marvell 88ALP01 integrated
>  	  CMOS camera controller.  This is the controller found on first-
> 
> Can you confirm this?

Yes - the follow-on series I posted the other day fixes this.

Sorry for the trouble,

jon
