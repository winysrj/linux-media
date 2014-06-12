Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:37825 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752898AbaFLOic (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jun 2014 10:38:32 -0400
Message-ID: <5399BB60.4000308@iki.fi>
Date: Thu, 12 Jun 2014 17:38:24 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: linux-media@vger.kernel.org
Subject: Re: [media] dvb_usb_v2: use dev_* logging macros
References: <20140612143002.GC13103@mwanda>
In-Reply-To: <20140612143002.GC13103@mwanda>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moikka Dan,
Thank for the report. I will check that later... I am now back from 
traveling and there is a lot of stuff on my queue waiting for action.

regards
Antti



On 06/12/2014 05:30 PM, Dan Carpenter wrote:
> Hello Antti Palosaari,
>
> This is a semi-automatic email about new static checker warnings.
>
> The patch d10d1b9ac97b: "[media] dvb_usb_v2: use dev_* logging
> macros" from Jun 26, 2012, leads to the following Smatch complaint:
>
> drivers/media/usb/dvb-usb-v2/dvb_usb_urb.c:31 dvb_usb_v2_generic_io()
> 	 error: we previously assumed 'd' could be null (see line 29)
>
> drivers/media/usb/dvb-usb-v2/dvb_usb_urb.c
>      28	
>      29		if (!d || !wbuf || !wlen || !d->props->generic_bulk_ctrl_endpoint ||
>                      ^^
> Old check.
>
>      30				!d->props->generic_bulk_ctrl_endpoint_response) {
>      31			dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, -EINVAL);
>                                  ^^^^^^^^^^^^^
> New dereference.
>
>      32			return -EINVAL;
>      33		}
>
> regards,
> dan carpenter
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
http://palosaari.fi/
