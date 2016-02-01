Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:39245 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753864AbcBAMfe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Feb 2016 07:35:34 -0500
Date: Mon, 1 Feb 2016 10:35:28 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Roland Zitzke <zitzke@gmx.de>
Cc: linux-media@vger.kernel.org, Roland Zitzke <zitzke@telos.de>
Subject: Re: [Patch] Support AVerMedia DVD EZMaker 7 (C039)
Message-ID: <20160201103528.4f375dc5@recife.lan>
In-Reply-To: <0214E8CF-724D-47C8-B621-CD7D434CD1AE@gmx.de>
References: <0214E8CF-724D-47C8-B621-CD7D434CD1AE@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 20 Jan 2016 11:55:42 +0100
Roland Zitzke <zitzke@gmx.de> escreveu:

> Hello,
> this is an USB grabber card based on the CX231XX chip.
> 
> The Linux TV wiki has some rather contradicting information on this card. However I can confirm that the latest Conexant  driver works just fine once it is compiled with the additional product and vendor id of this card.
> https://www.linuxtv.org/wiki/index.php/AVerMedia_DVD_EZMaker_7_(C039)
> 
> The following simple patch does the job on the recent v4l tree.
> Is there a way to get it included without setting up a git infrastructure?

Well, your patches need to be signed. Also, if you're using the media-build
tree, the best would be to produce the patch under the /linux directory,
as the patch would be in the right place.

Finally, your e-mailer is mangling whitespaces, causing it to not
apply.

Regards,
Mauro

> Thanks and best regards
> Roland
> --- v4l/cx231xx-cards_old.c	2016-01-20 08:42:06.391203025 +0100
> +++ v4l/cx231xx-cards.c	2016-01-20 10:37:41.862148030 +0100
> @@ -908,6 +908,8 @@ struct usb_device_id cx231xx_id_table[]
>  	 .driver_info = CX231XX_BOARD_OTG102},
>  	{USB_DEVICE(USB_VID_TERRATEC, 0x00a6),
>  	 .driver_info = CX231XX_BOARD_TERRATEC_GRABBY},
> +    {USB_DEVICE(0x07ca, 0xc039),
> +     .driver_info = CX231XX_BOARD_CNXT_VIDEO_GRABBER},
>  	{},
>  };
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
