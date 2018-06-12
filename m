Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:39781 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933921AbeFLATR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Jun 2018 20:19:17 -0400
Received: by mail-lf0-f67.google.com with SMTP id t134-v6so33269123lff.6
        for <linux-media@vger.kernel.org>; Mon, 11 Jun 2018 17:19:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1528691962-31010-1-git-send-email-jiazhouyang09@gmail.com>
References: <1528691962-31010-1-git-send-email-jiazhouyang09@gmail.com>
From: =?UTF-8?Q?Alexandre=2DXavier_Labont=C3=A9=2DLamoureux?=
        <axdoomer@gmail.com>
Date: Mon, 11 Jun 2018 20:19:15 -0400
Message-ID: <CAKTMqxt0_3ZgqChxCOFR6OpB7b=EzwWTZ5Cz83DPBYBXdko99g@mail.gmail.com>
Subject: Re: [PATCH] media: tm6000: add error handling for dvb_register_adapter
To: Zhouyang Jia <jiazhouyang09@gmail.com>,
        "3 linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

"adater" should be "adapter".

Have a nice day,
Alexandre-Xavier

On Mon, Jun 11, 2018 at 12:39 AM, Zhouyang Jia <jiazhouyang09@gmail.com> wrote:
> When dvb_register_adapter fails, the lack of error-handling code may
> cause unexpected results.
>
> This patch adds error-handling code after calling dvb_register_adapter.
>
> Signed-off-by: Zhouyang Jia <jiazhouyang09@gmail.com>
> ---
>  drivers/media/usb/tm6000/tm6000-dvb.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/drivers/media/usb/tm6000/tm6000-dvb.c b/drivers/media/usb/tm6000/tm6000-dvb.c
> index c811fc6..ff35d4b 100644
> --- a/drivers/media/usb/tm6000/tm6000-dvb.c
> +++ b/drivers/media/usb/tm6000/tm6000-dvb.c
> @@ -266,6 +266,11 @@ static int register_dvb(struct tm6000_core *dev)
>
>         ret = dvb_register_adapter(&dvb->adapter, "Trident TVMaster 6000 DVB-T",
>                                         THIS_MODULE, &dev->udev->dev, adapter_nr);
> +       if (ret < 0) {
> +               printk(KERN_ERR "tm6000: couldn't register the adater!\n");
> +               goto err;
> +       }
> +
>         dvb->adapter.priv = dev;
>
>         if (dvb->frontend) {
> --
> 2.7.4
>
