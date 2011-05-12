Return-path: <mchehab@gaivota>
Received: from leo.clearchain.com ([199.73.29.74]:15885 "EHLO
	mail.clearchain.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198Ab1ELGFv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 May 2011 02:05:51 -0400
Date: Thu, 12 May 2011 16:05:29 +1000
From: Peter Hutterer <peter.hutterer@who-t.net>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Anssi Hannula <anssi.hannula@iki.fi>, linux-media@vger.kernel.org,
	"linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
	xorg-devel@lists.freedesktop.org
Subject: Re: IR remote control autorepeat / evdev
Message-ID: <20110512060529.GA14710@barra.bne.redhat.com>
References: <20110510053038.GA5808@barra.redhat.com>
 <4DC940E5.2070902@iki.fi>
 <4DCA1496.20304@redhat.com>
 <4DCABA42.30505@iki.fi>
 <4DCABEAE.4080607@redhat.com>
 <4DCACE74.6050601@iki.fi>
 <4DCB213A.8040306@redhat.com>
 <4DCB2BD9.6090105@iki.fi>
 <4DCB336B.2090303@redhat.com>
 <4DCB39AF.2000807@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DCB39AF.2000807@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Thu, May 12, 2011 at 03:36:47AM +0200, Mauro Carvalho Chehab wrote:
> Em 12-05-2011 03:10, Mauro Carvalho Chehab escreveu:
> > Em 12-05-2011 02:37, Anssi Hannula escreveu:
> 
> >> I don't see any other places:
> >> $ git grep 'REP_PERIOD' .
> >> dvb/dvb-usb/dvb-usb-remote.c:   input_dev->rep[REP_PERIOD] =
> >> d->props.rc.legacy.rc_interval;
> > 
> > Indeed, the REP_PERIOD is not adjusted on other drivers. I agree that we
> > should change it to something like 125ms, for example, as 33ms is too 
> > short, as it takes up to 114ms for a repeat event to arrive.
> > 
> IMO, the enclosed patch should do a better job with repeat events, without
> needing to change rc-core/input/event logic.
> 
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

so if I get this right, a XkbSetControls(.. XkbRepeatKeysMask ...) by a
client to set the repeat rate would provide the same solution - for those
clients/devices affected. 

The interesting question is how clients would identify the devices that are
affected by this (other than trial and error).

Cheers,
  Peter
