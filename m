Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:43844
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752061AbdBHOEQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 8 Feb 2017 09:04:16 -0500
Date: Wed, 8 Feb 2017 11:57:02 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Stefan =?UTF-8?B?QnLDvG5z?= <stefan.bruens@rwth-aachen.de>
Cc: <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>
Subject: Re: [PATCH 2/2] [media] dvb-usb-firmware: don't do DMA on stack
Message-ID: <20170208115702.79a987d0@vento.lan>
In-Reply-To: <cfae2a63a36641bcab2ec298b21b5b06@rwthex-w2-b.rwth-ad.de>
References: <20170205145800.3561-1-stefan.bruens@rwth-aachen.de>
        <cfae2a63a36641bcab2ec298b21b5b06@rwthex-w2-b.rwth-ad.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Stefan,

Em Sun, 5 Feb 2017 15:58:00 +0100
Stefan Brüns <stefan.bruens@rwth-aachen.de> escreveu:

The first patch in this series looked ok. Applied, thanks!

> The USB control messages require DMA to work. We cannot pass
> a stack-allocated buffer, as it is not warranted that the
> stack would be into a DMA enabled area.

I applied a similar patch to this one sometime ago at the linux media
tree:
	https://git.linuxtv.org/media_tree.git/

Could you please check if the issues you're noticing were already
fixed, and, if not, send me a patch rebased against it?

Thanks!
Mauro


> 
> Signed-off-by: Stefan Brüns <stefan.bruens@rwth-aachen.de>
> ---
>  drivers/media/usb/dvb-usb/dvb-usb-firmware.c | 30 ++++++++++++++++------------
>  1 file changed, 17 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/media/usb/dvb-usb/dvb-usb-firmware.c b/drivers/media/usb/dvb-usb/dvb-usb-firmware.c
> index dd048a7c461c..189b6725edd0 100644
> --- a/drivers/media/usb/dvb-usb/dvb-usb-firmware.c
> +++ b/drivers/media/usb/dvb-usb/dvb-usb-firmware.c
> @@ -35,41 +35,45 @@ static int usb_cypress_writemem(struct usb_device *udev,u16 addr,u8 *data, u8 le
>  
>  int usb_cypress_load_firmware(struct usb_device *udev, const struct firmware *fw, int type)
>  {
> -	struct hexline hx;
> -	u8 reset;
> -	int ret,pos=0;
> +	u8 *buf = kmalloc(sizeof(struct hexline), GFP_KERNEL);
> +	struct hexline *hx = (struct hexline *)buf;
> +	int ret, pos = 0;
> +	u16 cpu_cs_register = cypress[type].cpu_cs_register;
>  
>  	/* stop the CPU */
> -	reset = 1;
> -	if ((ret = usb_cypress_writemem(udev,cypress[type].cpu_cs_register,&reset,1)) != 1)
> +	buf[0] = 1;
> +	if (usb_cypress_writemem(udev, cpu_cs_register, buf, 1) != 1)
>  		err("could not stop the USB controller CPU.");
>  
> -	while ((ret = dvb_usb_get_hexline(fw,&hx,&pos)) > 0) {
> -		deb_fw("writing to address 0x%04x (buffer: 0x%02x %02x)\n",hx.addr,hx.len,hx.chk);
> -		ret = usb_cypress_writemem(udev,hx.addr,hx.data,hx.len);
> +	while ((ret = dvb_usb_get_hexline(fw, hx, &pos)) > 0) {
> +		deb_fw("writing to address 0x%04x (buffer: 0x%02x %02x)\n",
> +		       hx->addr, hx->len, hx->chk);
> +		ret = usb_cypress_writemem(udev, hx->addr, hx->data, hx->len);
>  
> -		if (ret != hx.len) {
> +		if (ret != hx->len) {
>  			err("error while transferring firmware "
>  				"(transferred size: %d, block size: %d)",
> -				ret,hx.len);
> +				ret, hx->len);
>  			ret = -EINVAL;
>  			break;
>  		}
>  	}
>  	if (ret < 0) {
> -		err("firmware download failed at %d with %d",pos,ret);
> +		err("firmware download failed at %d with %d", pos, ret);
> +		kfree(buf);
>  		return ret;
>  	}
>  
>  	if (ret == 0) {
>  		/* restart the CPU */
> -		reset = 0;
> -		if (ret || usb_cypress_writemem(udev,cypress[type].cpu_cs_register,&reset,1) != 1) {
> +		buf[0] = 0;
> +		if (usb_cypress_writemem(udev, cpu_cs_register, buf, 1) != 1) {
>  			err("could not restart the USB controller CPU.");
>  			ret = -EINVAL;
>  		}
>  	} else
>  		ret = -EIO;
> +	kfree(buf);
>  
>  	return ret;
>  }



Thanks,
Mauro
