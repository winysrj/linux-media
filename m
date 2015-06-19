Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:54621 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754112AbbFSJQi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Jun 2015 05:16:38 -0400
Date: Fri, 19 Jun 2015 06:16:33 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH for v4.2] cobalt: set Kconfig default to n
Message-ID: <20150619061633.710d4600@recife.lan>
In-Reply-To: <5583B729.30601@xs4all.nl>
References: <5583B729.30601@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 19 Jun 2015 08:31:05 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> Since this board is a Cisco-internal board there is no point in having it compiled
> by default. So set the Kconfig default to n.

This should not change anything. The default for all options that aren't
specified are already 'n'.

> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> diff --git a/drivers/media/pci/cobalt/Kconfig b/drivers/media/pci/cobalt/Kconfig
> index 3be1b2c..4d0777a 100644
> --- a/drivers/media/pci/cobalt/Kconfig
> +++ b/drivers/media/pci/cobalt/Kconfig
> @@ -7,6 +7,7 @@ config VIDEO_COBALT
>  	select VIDEO_ADV7511
>  	select VIDEO_ADV7842
>  	select VIDEOBUF2_DMA_SG
> +	default n
>  	---help---
>  	  This is a video4linux driver for the Cisco PCIe Cobalt card.
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
