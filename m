Return-path: <mchehab@gaivota>
Received: from saarni.dnainternet.net ([83.102.40.136]:33698 "EHLO
	saarni.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758709Ab1ELX6F (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 May 2011 19:58:05 -0400
Message-ID: <4DCC71B5.8080306@iki.fi>
Date: Fri, 13 May 2011 02:48:05 +0300
From: Anssi Hannula <anssi.hannula@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Peter Hutterer <peter.hutterer@who-t.net>,
	linux-media@vger.kernel.org,
	"linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
	xorg-devel@lists.freedesktop.org
Subject: Re: IR remote control autorepeat / evdev
References: <4DC61E28.4090301@iki.fi> <20110510041107.GA32552@barra.redhat.com> <4DC8C9B6.5000501@iki.fi> <20110510053038.GA5808@barra.redhat.com> <4DC940E5.2070902@iki.fi> <4DCA1496.20304@redhat.com> <4DCABA42.30505@iki.fi> <4DCABEAE.4080607@redhat.com> <4DCACE74.6050601@iki.fi> <4DCB213A.8040306@redhat.com> <4DCB2BD9.6090105@iki.fi> <4DCB336B.2090303@redhat.com> <4DCB39AF.2000807@redhat.com>
In-Reply-To: <4DCB39AF.2000807@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On 12.05.2011 04:36, Mauro Carvalho Chehab wrote:
> Em 12-05-2011 03:10, Mauro Carvalho Chehab escreveu:
>> Em 12-05-2011 02:37, Anssi Hannula escreveu:
> 
>>> I don't see any other places:
>>> $ git grep 'REP_PERIOD' .
>>> dvb/dvb-usb/dvb-usb-remote.c:   input_dev->rep[REP_PERIOD] =
>>> d->props.rc.legacy.rc_interval;
>>
>> Indeed, the REP_PERIOD is not adjusted on other drivers. I agree that we
>> should change it to something like 125ms, for example, as 33ms is too 
>> short, as it takes up to 114ms for a repeat event to arrive.
>>
> IMO, the enclosed patch should do a better job with repeat events, without
> needing to change rc-core/input/event logic.

It will indeed reduce the amount of ghost events so it brings us in the
right direction.

I'd still like to get rid of the ghost repeats entirely, or at least
some way for users to do it if we don't do it by default.

Maybe we could replace the kernel softrepeat with native repeats (for
those protocols/drivers that have them), while making sure that repeat
events before REP_DELAY are ignored and repeat events less than
REP_PERIOD since the previous event are ignored, so the users can still
configure them as they like?

Or maybe just a module option that causes rc-core to use native repeat
events, for those of us that want accurate repeat events without ghosting?


> -
> 
> Subject: Use a more consistent value for RC repeat period
> From: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> The default REP_PERIOD is 33 ms. This doesn't make sense for IR's,
> as, in general, an IR repeat scancode is provided at every 110/115ms,
> depending on the RC protocol. So, increase its default, to do a
> better job avoiding ghost repeat events.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
> index f53f9c6..ee67169 100644
> --- a/drivers/media/rc/rc-main.c
> +++ b/drivers/media/rc/rc-main.c
> @@ -1044,6 +1044,13 @@ int rc_register_device(struct rc_dev *dev)
>  	 */
>  	dev->input_dev->rep[REP_DELAY] = 500;
>  
> +	/*
> +	 * As a repeat event on protocols like RC-5 and NEC take as long as
> +	 * 110/114ms, using 33ms as a repeat period is not the right thing
> +	 * to do.
> +	 */
> +	dev->input_dev->rep[REP_PERIOD] = 125;
> +
>  	path = kobject_get_path(&dev->dev.kobj, GFP_KERNEL);
>  	printk(KERN_INFO "%s: %s as %s\n",
>  		dev_name(&dev->dev),
> 


-- 
Anssi Hannula
