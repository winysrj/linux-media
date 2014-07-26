Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:63837 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349AbaGZPhE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Jul 2014 11:37:04 -0400
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N9B00LM5SPQTE50@mailout2.w2.samsung.com> for
 linux-media@vger.kernel.org; Sat, 26 Jul 2014 11:37:02 -0400 (EDT)
Date: Sat, 26 Jul 2014 12:36:58 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Raymond Jender <rayj00@yahoo.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 1/4] [media] cx23885 now needs to select dib0070
Message-id: <20140726123658.69fbfc54.m.chehab@samsung.com>
In-reply-to: <1406387220.80907.YahooMailNeo@web162402.mail.bf1.yahoo.com>
References: <1406386748-8874-1-git-send-email-m.chehab@samsung.com>
 <1406387220.80907.YahooMailNeo@web162402.mail.bf1.yahoo.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 26 Jul 2014 08:07:00 -0700
Raymond Jender <rayj00@yahoo.com> escreveu:

> Get me off this mailing list!!!

Only you can do it. You should send an email to mailman at vger.kernel.org,
asking the daemon to unsubscribe your user.

See the "unsubscribe" link at http://vger.kernel.org/vger-lists.html#linux-media

Regards,
Mauro

> 
> 
> 
> On Saturday, July 26, 2014 8:00 AM, Mauro Carvalho Chehab <m.chehab@samsung.com> wrote:
>  
> 
> 
> Due to DViCO FusionHDTV DVB-T Dual Express2, we also need to
> autoselect this tuner.
> 
> Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> ---
> drivers/media/pci/cx23885/Kconfig | 1 +
> 1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/media/pci/cx23885/Kconfig b/drivers/media/pci/cx23885/Kconfig
> index d1dcb1d2e087..5158133c6535 100644
> --- a/drivers/media/pci/cx23885/Kconfig
> +++ b/drivers/media/pci/cx23885/Kconfig
> @@ -37,6 +37,7 @@ config VIDEO_CX23885
>     select MEDIA_TUNER_TDA8290 if MEDIA_SUBDRV_AUTOSELECT
>     select MEDIA_TUNER_TDA18271 if MEDIA_SUBDRV_AUTOSELECT
>     select MEDIA_TUNER_XC5000 if MEDIA_SUBDRV_AUTOSELECT
> +    select DVB_TUNER_DIB0070 if MEDIA_SUBDRV_AUTOSELECT
>     ---help---
>       This is a video4linux driver for Conexant 23885 based
>       TV cards.
