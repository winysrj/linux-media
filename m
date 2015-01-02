Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:40768 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423AbbABVUf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Jan 2015 16:20:35 -0500
Received: by mail-lb0-f178.google.com with SMTP id f15so17360226lbj.37
        for <linux-media@vger.kernel.org>; Fri, 02 Jan 2015 13:20:33 -0800 (PST)
Date: Fri, 2 Jan 2015 23:20:27 +0200 (EET)
From: Olli Salonen <olli.salonen@iki.fi>
To: Jonathan McDowell <noodles@earth.li>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] Fix Mygica T230 support
In-Reply-To: <20150102175517.GE5209@earth.li>
Message-ID: <alpine.DEB.2.10.1501022317590.23112@dl160.lan>
References: <20150102175517.GE5209@earth.li>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Indeed, good catch. Mauro, this should go into 3.19.

Reviewed-by: Olli Salonen <olli.salonen@iki.fi>

On Fri, 2 Jan 2015, Jonathan McDowell wrote:

> Commit 2adb177e57417cf8409e86bda2c516e5f99a2099 removed 2 devices
> from the cxusb device table but failed to fix up the T230 properties
> that follow, meaning that this device no longer gets detected properly.
> Adjust the cxusb_table index appropriate so detection works.
>
> Signed-Off-By: Jonathan McDowell <noodles@earth.li>
>
> -----
> diff --git a/drivers/media/usb/dvb-usb/cxusb.c b/drivers/media/usb/dvb-usb/cxusb.c
> index 0f345b1..f327c49 100644
> --- a/drivers/media/usb/dvb-usb/cxusb.c
> +++ b/drivers/media/usb/dvb-usb/cxusb.c
> @@ -2232,7 +2232,7 @@ static struct dvb_usb_device_properties cxusb_mygica_t230_properties = {
> 		{
> 			"Mygica T230 DVB-T/T2/C",
> 			{ NULL },
> -			{ &cxusb_table[22], NULL },
> +			{ &cxusb_table[20], NULL },
> 		},
> 	}
> };
