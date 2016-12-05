Return-path: <linux-media-owner@vger.kernel.org>
Received: from shell.v3.sk ([92.60.52.57]:35753 "EHLO shell.v3.sk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751161AbcLELpN (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Dec 2016 06:45:13 -0500
Message-ID: <1480938303.16064.1.camel@v3.sk>
Subject: Re: [PATCH] [media] usbtv: add a new usbid
From: Lubomir Rintel <lkundrak@v3.sk>
To: Icenowy Zheng <icenowy@aosc.xyz>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Federico Simoncelli <fsimonce@redhat.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 05 Dec 2016 12:45:03 +0100
In-Reply-To: <20161204135943.34465-1-icenowy@aosc.xyz>
References: <20161204135943.34465-1-icenowy@aosc.xyz>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2016-12-04 at 21:59 +0800, Icenowy Zheng wrote:
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

Thank you.

Acked-by: Lubomir Rintel <lkundrak@v3.sk>

Also, it may make sense to add

Tested-by: Icenowy Zheng <icenowy@aosc.xyz>

> 
> Signed-off-by: Icenowy Zheng <icenowy@aosc.xyz>
> ---
>  drivers/media/usb/usbtv/usbtv-core.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/media/usb/usbtv/usbtv-core.c
> b/drivers/media/usb/usbtv/usbtv-core.c
> index dc76fd4..0324633 100644
> --- a/drivers/media/usb/usbtv/usbtv-core.c
> +++ b/drivers/media/usb/usbtv/usbtv-core.c
> @@ -141,6 +141,7 @@ static void usbtv_disconnect(struct usb_interface
> *intf)
>  
>  static struct usb_device_id usbtv_id_table[] = {
>  	{ USB_DEVICE(0x1b71, 0x3002) },
> +	{ USB_DEVICE(0x1f71, 0x3301) },
>  	{}
>  };
>  MODULE_DEVICE_TABLE(usb, usbtv_id_table);
