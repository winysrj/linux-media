Return-path: <linux-media-owner@vger.kernel.org>
Received: from sender153-mail.zoho.com ([74.201.84.153]:25468 "EHLO
        sender153-mail.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750964AbdAQIl2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Jan 2017 03:41:28 -0500
Message-ID: <587DD8B6.6090806@zoho.com>
Date: Tue, 17 Jan 2017 09:41:26 +0100
From: em28xx PCTV 520e <em28xx_520e@zoho.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: em28xx failed with kernel 3.14.79
References: <587CCB8B.4000106@zoho.com>
In-Reply-To: <587CCB8B.4000106@zoho.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I played a little around with it and i think, the "submit of audio urb 
failed" message is not the main reason.

Any ideas, why I do not get a /dev/dvb/... ?

greetings


Am 16.01.2017 um 14:32 schrieb em28xx PCTV 520e:
> Hi,
>
> I'm using a PCTV 520e usb dvb-c device at an ODROID-C2, running ubuntu 
> with kernel 3.14.79. I'd like to use the lates media build drivers. 
> However, if I do so, I get the following output with dmesg:
>
> [  132.288365] usb 1-1.1: new high-speed USB device number 4 using 
> dwc_otg
...snip..
> [ 133.918431] em28xx 1-1.1:1.0: submit of audio urb failed (error=-90)
...snip..
> [ 133.948866] em28xx: Registered (Em28xx Input Extension) extension
>
> Finally, there is no /dev/dvb/... created. I guess because of the
>
>   [  133.918431] em28xx 1-1.1:1.0: submit of audio urb failed (error=-90)
>
> message.
>
> Can any1 help me with this?
>
> regards
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


