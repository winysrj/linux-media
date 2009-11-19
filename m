Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:37583 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203AbZKSVCm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Nov 2009 16:02:42 -0500
Received: by bwz27 with SMTP id 27so2822579bwz.21
        for <linux-media@vger.kernel.org>; Thu, 19 Nov 2009 13:02:46 -0800 (PST)
Message-ID: <4B05B271.5070707@googlemail.com>
Date: Thu, 19 Nov 2009 22:02:41 +0100
From: e9hack <e9hack@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org
Subject: Re: bug in changeset 13239:54535665f94b ?
References: <4AEDB05E.1090704@googlemail.com> <20091107104113.0df4593b@pedra.chehab.org>
In-Reply-To: <20091107104113.0df4593b@pedra.chehab.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab schrieb:
> Could you please test if the enclosed patch fixes the issue?
> 
> saa7146: stop DMA before de-allocating DMA scatter/gather page buffers
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> diff --git a/linux/drivers/media/common/saa7146_video.c b/linux/drivers/media/common/saa7146_video.c
> --- a/linux/drivers/media/common/saa7146_video.c
> +++ b/linux/drivers/media/common/saa7146_video.c
> @@ -1334,9 +1334,9 @@ static void buffer_release(struct videob
>  
>  	DEB_CAP(("vbuf:%p\n",vb));
>  
> +	saa7146_dma_free(dev,q,buf);
> +
>  	release_all_pagetables(dev, buf);
> -
> -	saa7146_dma_free(dev,q,buf);
>  }
>  
>  static struct videobuf_queue_ops video_qops = {

Hi Mauro,

can you please commit this patch? It's perfect just I wrote here
(http://news.gmane.org/gmane.linux.drivers.video-input-infrastructure).

Regards,
Hartmut


