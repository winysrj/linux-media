Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24023 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752089Ab2CHLVi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 8 Mar 2012 06:21:38 -0500
Message-ID: <4F589630.5020008@redhat.com>
Date: Thu, 08 Mar 2012 08:21:20 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: LMML <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: [PATCH] [media] dib0700: Fix memory leak during initialization
References: <20120212111911.32f4c390@endymion.delvare>
In-Reply-To: <20120212111911.32f4c390@endymion.delvare>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jean,

Em 12-02-2012 08:19, Jean Delvare escreveu:
> Reported by kmemleak.
> 
> Signed-off-by: Jean Delvare <khali@linux-fr.org>
> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
> Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
> ---
> I am not familiar with the usb API, are we also supposed to call
> usb_kill_urb() in the error case maybe?
> 
>  drivers/media/dvb/dvb-usb/dib0700_core.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> --- linux-3.3-rc3.orig/drivers/media/dvb/dvb-usb/dib0700_core.c	2012-01-20 14:06:38.000000000 +0100
> +++ linux-3.3-rc3/drivers/media/dvb/dvb-usb/dib0700_core.c	2012-02-12 00:32:19.005334036 +0100
> @@ -787,6 +787,8 @@ int dib0700_rc_setup(struct dvb_usb_devi
>  	if (ret)
>  		err("rc submit urb failed\n");
>  
> +	usb_free_urb(purb);
> +
>  	return ret;
>  }
>  
> 

This patch doesn't sound right on my eyes, as you're freeing
an URB that you've just submitted _before_ having it handled
by the dib0700_rc_urb_completion() callback.

Btw, it seems that there's a bug at the fist if there:

static void dib0700_rc_urb_completion(struct urb *purb)
{
	struct dvb_usb_device *d = purb->context;
	struct dib0700_rc_response *poll_reply;
	u32 uninitialized_var(keycode);
	u8 toggle;

	deb_info("%s()\n", __func__);
	if (d == NULL)
		return;

	if (d->rc_dev == NULL) {
		/* This will occur if disable_rc_polling=1 */
		usb_free_urb(purb);
		return;
	}

...

it should be, instead:

	if (!d || !d->rc_dev) {
		/* This will occur if disable_rc_polling=1 */
		usb_free_urb(purb);
		return;
	}	


That's said, clearly there's no condition to stop the DVB IR
handling.

Probably, the right thing to do there is to add a function like:

int dib0700_disconnect(...) 
{
	usb_unlink_urb(urb);
	usb_free_urb(urb);

	dvb_usb_device_exit(...);
}

and use such function for the usb_driver disconnect handling: 

static struct usb_driver dib0700_driver = {
	.name       = "dvb_usb_dib0700",
	.probe      = dib0700_probe,
	.disconnect = dib0700_disconnect,
	.id_table   = dib0700_usb_id_table,
};

Regards,
Mauro
