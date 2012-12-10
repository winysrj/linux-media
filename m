Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:40726 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716Ab2LJTDP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Dec 2012 14:03:15 -0500
Received: by mail-bk0-f46.google.com with SMTP id q16so1246098bkw.19
        for <linux-media@vger.kernel.org>; Mon, 10 Dec 2012 11:03:14 -0800 (PST)
Message-ID: <1355166143.4229.2.camel@canaries64>
Subject: Re: [PATCH RFC 08/11] it913x: remove unused define and increase
 module version
From: Malcolm Priestley <tvboxspy@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org
In-Reply-To: <1355100335-2123-8-git-send-email-crope@iki.fi>
References: <1355100335-2123-1-git-send-email-crope@iki.fi>
	 <1355100335-2123-8-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 Dec 2012 19:02:23 +0000
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2012-12-10 at 02:45 +0200, Antti Palosaari wrote:
> Cc: Malcolm Priestley <tvboxspy@gmail.com>
> Signed-off-by: Antti Palosaari <crope@iki.fi>
> ---
Acked-by: Malcolm Priestley <tvboxspy@gmail.com>

>  drivers/media/usb/dvb-usb-v2/it913x.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/media/usb/dvb-usb-v2/it913x.c b/drivers/media/usb/dvb-usb-v2/it913x.c
> index 5dc352b..3d20e38 100644
> --- a/drivers/media/usb/dvb-usb-v2/it913x.c
> +++ b/drivers/media/usb/dvb-usb-v2/it913x.c
> @@ -309,7 +309,6 @@ static struct i2c_algorithm it913x_i2c_algo = {
>  
>  /* Callbacks for DVB USB */
>  #if defined(CONFIG_RC_CORE) || defined(CONFIG_RC_CORE_MODULE)
> -#define IT913X_POLL 250
>  static int it913x_rc_query(struct dvb_usb_device *d)
>  {
>  	u8 ibuf[4];
> @@ -801,7 +800,7 @@ module_usb_driver(it913x_driver);
>  
>  MODULE_AUTHOR("Malcolm Priestley <tvboxspy@gmail.com>");
>  MODULE_DESCRIPTION("it913x USB 2 Driver");
> -MODULE_VERSION("1.32");
> +MODULE_VERSION("1.33");
>  MODULE_LICENSE("GPL");
>  MODULE_FIRMWARE(FW_IT9135_V1);
>  MODULE_FIRMWARE(FW_IT9135_V2);


