Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f178.google.com ([209.85.192.178]:46727 "EHLO
        mail-pf0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752381AbeGCMHX (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 3 Jul 2018 08:07:23 -0400
Subject: Re: media: dvb-usb-v2/gl861: ensure USB message buffers DMA'able
To: Colin Ian King <colin.king@canonical.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        linux-media@vger.kernel.org, Antti Palosaari <crope@iki.fi>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <8308d9f0-2257-101c-69e3-8fe165de9348@canonical.com>
From: Akihiro TSUKADA <tskd08@gmail.com>
Message-ID: <d2465376-4b3e-7d3d-86d2-0cd8d7543520@gmail.com>
Date: Tue, 3 Jul 2018 21:07:07 +0900
MIME-Version: 1.0
In-Reply-To: <8308d9f0-2257-101c-69e3-8fe165de9348@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
thanks for the report.

>  47        buf = NULL;
> 
> Condition rlen > 0, taking false branch.
> 
>  48        if (rlen > 0) {
>  49                buf = kmalloc(rlen, GFP_KERNEL);
>  50                if (!buf)
>  51                        return -ENOMEM;
>  52        }
> 
>  53        usleep_range(1000, 2000); /* avoid I2C errors */
>  54
>    CID 1470241 (#1 of 1): Explicit null dereferenced (FORWARD_NULL).
> var_deref_model: Passing null pointer buf to usb_control_msg, which
> dereferences it.
> 
>  55        ret = usb_control_msg(d->udev, usb_rcvctrlpipe(d->udev, 0),
> req, type,
>  56                              value, index, buf, rlen, 2000);
> 
> 
> The assignment of buf = NULL means a null buffer is passed down the usb
> control message stack until it eventually gets dereferenced. This only
> occurs when rlen <= 0.   I was unsure how to fix this for the case when
> rlen <= 0, so I am flagging this up as an issue that needs fixing.
> 

Since rlen is an u16, null pointer is passed only when rlen == 0,
so I think it is not a problem,
but I am OK to add a guard in order to make scan result clean.

regards,
Akihiro
