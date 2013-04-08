Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f44.google.com ([74.125.83.44]:36260 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762742Ab3DHQ74 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Apr 2013 12:59:56 -0400
Received: by mail-ee0-f44.google.com with SMTP id c41so1551828eek.3
        for <linux-media@vger.kernel.org>; Mon, 08 Apr 2013 09:59:55 -0700 (PDT)
Message-ID: <5162F7CC.6010904@googlemail.com>
Date: Mon, 08 Apr 2013 19:01:00 +0200
From: =?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: em28xx: kernel oops in em28xx_tuner_callback() when watching
 digital TV
References: <515EF7CF.4060107@googlemail.com> <201304060838.42052.hverkuil@xs4all.nl> <5161ECE7.1060808@googlemail.com> <201304081038.54531.hverkuil@xs4all.nl>
In-Reply-To: <201304081038.54531.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 08.04.2013 10:38, schrieb Hans Verkuil:
> On Mon April 8 2013 00:02:15 Frank Schäfer wrote:
>>
>> In em28xx_start_streaming() and also em28xx_stop_streaming() we do
>>
>>      struct em28xx *dev = dvb->adapter.priv;
>>
>> which I would say should be the culprit.
>> Are you sure that dvb->adapter.priv needs to be assigned to i2c_bus
>> instead of dev ?
>> Anyway, I modified both functions to obtain the right pointer to dev,
>> but this caused another oops.
>> I also tested without changing dvb->adapter.priv: oops :-/
> Can you try this patch? I did miss the adapter.priv change, so I've added that.
> I also noticed that I converted fe->dvb->priv as well, which is not correct.
>
> So I'm hoping that this will do the trick.
>
> Regards,
>
> 	Hans
>
> diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
> index 42a6a26..1f1f56f 100644
> --- a/drivers/media/usb/em28xx/em28xx-dvb.c
> +++ b/drivers/media/usb/em28xx/em28xx-dvb.c
> @@ -178,7 +178,8 @@ static inline int em28xx_dvb_urb_data_copy(struct em28xx *dev, struct urb *urb)
>  static int em28xx_start_streaming(struct em28xx_dvb *dvb)
>  {
>  	int rc;
> -	struct em28xx *dev = dvb->adapter.priv;
> +	struct em28xx_i2c_bus *i2c_bus = dvb->adapter.priv;
> +	struct em28xx *dev = i2c_bus->dev;
>  	int dvb_max_packet_size, packet_multiplier, dvb_alt;
>  
>  	if (dev->dvb_xfer_bulk) {
> @@ -217,7 +218,8 @@ static int em28xx_start_streaming(struct em28xx_dvb *dvb)
>  
>  static int em28xx_stop_streaming(struct em28xx_dvb *dvb)
>  {
> -	struct em28xx *dev = dvb->adapter.priv;
> +	struct em28xx_i2c_bus *i2c_bus = dvb->adapter.priv;
> +	struct em28xx *dev = i2c_bus->dev;
>  
>  	em28xx_stop_urbs(dev);
>  
> @@ -839,7 +841,7 @@ static int em28xx_register_dvb(struct em28xx_dvb *dvb, struct module *module,
>  	if (dvb->fe[1])
>  		dvb->fe[1]->ops.ts_bus_ctrl = em28xx_dvb_bus_ctrl;
>  
> -	dvb->adapter.priv = dev;
> +	dvb->adapter.priv = &dev->i2c_bus[dev->def_i2c_bus];
>  
>  	/* register frontend */
>  	result = dvb_register_frontend(&dvb->adapter, dvb->fe[0]);

This one does the trick, thanks !

Tested-by: Frank Schäfer <fschaefer.oss@googlemail.com>

Regards,
Frank

