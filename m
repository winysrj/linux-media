Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:52788 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751271AbaGHDpP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Jul 2014 23:45:15 -0400
Message-ID: <53BB6947.2090409@iki.fi>
Date: Tue, 08 Jul 2014 06:45:11 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: shuah.kh@samsung.com,
	"Mauro Carvalho Chehab (m.chehab@samsung.com)" <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: fix PCTV 461e tuner I2C binding
References: <53BB2E7D.30300@samsung.com>
In-Reply-To: <53BB2E7D.30300@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moikka Shuah

On 07/08/2014 02:34 AM, Shuah Khan wrote:
> Mauro/Antti,
>
> I have been looking at the following commit to
>
> drivers/media/usb/em28xx/em28xx-dvb.c
>
> a83b93a7480441a47856dc9104bea970e84cda87
>
> +++ b/drivers/media/usb/em28xx/em28xx-dvb.c
> @@ -1630,6 +1630,7 @@ static int em28xx_dvb_resume(struct em28xx *dev)
>          em28xx_info("Resuming DVB extension");
>          if (dev->dvb) {
>                  struct em28xx_dvb *dvb = dev->dvb;
> +               struct i2c_client *client = dvb->i2c_client_tuner;
>
>                  if (dvb->fe[0]) {
>                          ret = dvb_frontend_resume(dvb->fe[0]);
> @@ -1640,6 +1641,15 @@ static int em28xx_dvb_resume(struct em28xx *dev)
>                          ret = dvb_frontend_resume(dvb->fe[1]);
>                          em28xx_info("fe1 resume %d", ret);
>                  }
> +               /* remove I2C tuner */
> +               if (client) {
> +                       module_put(client->dev.driver->owner);
> +                       i2c_unregister_device(client);
> +               }
> +
> +               em28xx_unregister_dvb(dvb);
> +               kfree(dvb);
> +               dev->dvb = NULL;
>          }
>
> Why are we unregistering i2c devices and dvb in this resume path?
> Looks incorrect to me.

I don't know. Original patch I send was a bit different and tuner was 
removed only during em28xx_dvb_fini()

https://patchwork.linuxtv.org/patch/22275/

regards
Antti

-- 
http://palosaari.fi/
