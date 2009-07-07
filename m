Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:50162 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751824AbZGGLAa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Jul 2009 07:00:30 -0400
Message-ID: <4A532ACA.1070607@iki.fi>
Date: Tue, 07 Jul 2009 14:00:26 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Nils Kassube <kassube@gmx.net>
CC: linux-media@vger.kernel.org
Subject: Re: Fix for crash in dvb-usb-af9015
References: <200907071232.00459.kassube@gmx.net>
In-Reply-To: <200907071232.00459.kassube@gmx.net>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moi Nils,

Nils Kassube wrote:
> I found out that the crash happens when the device should boot after 
> downloading the firmware because there seems to be no sufficiently big 
> buffer for the boot message (or whatever it is) returned from the 
> device. As this message is ignored by the calling function anyway, this 
> patch fixes the problem:
> 
> --- orig/linux-2.6.31/drivers/media/dvb/dvb-usb/af9015.c	2009-06-30 
> 11:34:45.000000000 +0200
> +++ linux-2.6.31/drivers/media/dvb/dvb-usb/af9015.c	2009-07-06 
> 21:42:50.000000000 +0200
> @@ -158,7 +158,7 @@
>  	}
>  
>  	/* read request, copy returned data to return buf */
> -	if (!write)
> +	if (!write && req->cmd != BOOT)
>  		memcpy(req->data, &buf[2], req->data_len);
>  
>  error_unlock:
> 
> However, it would certainly be better to provide an appropriate buffer 
> when calling this function from af9015_download_firmware because I think 
> it is called very often here and the extra check for the BOOT command is 
> needed only once (after firmware download). As I'm not familiar with the 
> hardware, I can't say what buffer size would be appropriate but I can 
> say that for my device the parameter "req->data_len" was 32 in the 
> memcpy command above when I tried to find the fix.

I see the problem but your fix is not ideally correct for my eyes. I 
don't have currently access to sniffs to ensure that but I think BOOT 
should be write command. Now it is defined as read. I think moving BOOT 
from read to write fixes problem.

regards
Antti
-- 
http://palosaari.fi/
