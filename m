Return-path: <linux-media-owner@vger.kernel.org>
Received: from hermes.aosc.io ([199.195.250.187]:43668 "EHLO hermes.aosc.io"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751012AbdE1PEE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 28 May 2017 11:04:04 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date: Sun, 28 May 2017 23:04:02 +0800
From: icenowy@aosc.io
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Lubomir Rintel <lkundrak@v3.sk>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND2] [media] usbtv: add a new usbid
In-Reply-To: <20170416065116.61662-1-icenowy@aosc.io>
References: <20170416065116.61662-1-icenowy@aosc.io>
Message-ID: <73197902b0e171553d0a048524110eaf@aosc.io>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

在 2017-04-16 14:51，Icenowy Zheng 写道：
> A new usbid of UTV007 is found in a newly bought device.
> 
> The usbid is 1f71:3301.
> 
> The ID on the chip is:
> UTV007
> A89029.1
> 1520L18K1
> 
> Both video and audio is tested with the modified usbtv driver.
> 
> Signed-off-by: Icenowy Zheng <icenowy@aosc.io>
> Acked-by: Lubomir Rintel <lkundrak@v3.sk>

Ping?

I found this patch in Superseded state in patchwork, however it's
not superseded at all -- I didn't send any new version, and I didn't
see this one get merged...

Could someone merge it?

> ---
> 
> Added Lubomir's ACK in the second time of resend.
> 
> The old patch may be lost because the old aosc.xyz mail is using 
> Yandex's
> service -- which is rejected by many mail providers. As part of AOSC 
> mailing
> system refactor, we got a new mailing system, so that the patch is now
> resent.
> 
>  drivers/media/usb/usbtv/usbtv-core.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/media/usb/usbtv/usbtv-core.c
> b/drivers/media/usb/usbtv/usbtv-core.c
> index ceb953be0770..cae637845876 100644
> --- a/drivers/media/usb/usbtv/usbtv-core.c
> +++ b/drivers/media/usb/usbtv/usbtv-core.c
> @@ -144,6 +144,7 @@ static void usbtv_disconnect(struct usb_interface 
> *intf)
> 
>  static struct usb_device_id usbtv_id_table[] = {
>  	{ USB_DEVICE(0x1b71, 0x3002) },
> +	{ USB_DEVICE(0x1f71, 0x3301) },
>  	{}
>  };
>  MODULE_DEVICE_TABLE(usb, usbtv_id_table);
