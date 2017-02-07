Return-path: <linux-media-owner@vger.kernel.org>
Received: from shell.v3.sk ([92.60.52.57]:35221 "EHLO shell.v3.sk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751886AbdBGTb1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 7 Feb 2017 14:31:27 -0500
Message-ID: <1486495879.22785.9.camel@v3.sk>
Subject: Re: [PATCH RESEND] [media] usbtv: add a new usbid
From: Lubomir Rintel <lkundrak@v3.sk>
To: Icenowy Zheng <icenowy@aosc.xyz>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 07 Feb 2017 20:31:19 +0100
In-Reply-To: <20170207184356.64001-1-icenowy@aosc.xyz>
References: <20170207184356.64001-1-icenowy@aosc.xyz>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2017-02-08 at 02:43 +0800, Icenowy Zheng wrote:
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
> Signed-off-by: Icenowy Zheng <icenowy@aosc.xyz>

Acked-by: Lubomir Rintel <lkundrak@v3.sk>

Thanks for resending this. I can't seem to find the original posting in
the patchwork and don't see how could it have slipped through the
cracks. But then my understanding of how does the media tree
maintenance might not be too good.

Also, I think new USB IDs are usually okay for stable trees too, if you
care about that then feel free to Cc stable@ too.

Lubo

> ---
>  drivers/media/usb/usbtv/usbtv-core.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/media/usb/usbtv/usbtv-core.c
> b/drivers/media/usb/usbtv/usbtv-core.c
> index ceb953be0770..cae637845876 100644
> --- a/drivers/media/usb/usbtv/usbtv-core.c
> +++ b/drivers/media/usb/usbtv/usbtv-core.c
> @@ -144,6 +144,7 @@ static void usbtv_disconnect(struct usb_interface
> *intf)
>  
>  static struct usb_device_id usbtv_id_table[] = {
>  	{ USB_DEVICE(0x1b71, 0x3002) },
> +	{ USB_DEVICE(0x1f71, 0x3301) },
>  	{}
>  };
>  MODULE_DEVICE_TABLE(usb, usbtv_id_table);
