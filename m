Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751755Ab1EUNOk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 21 May 2011 09:14:40 -0400
Message-ID: <4DD7BABC.602@redhat.com>
Date: Sat, 21 May 2011 10:14:36 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Malcolm Priestley <tvboxspy@gmail.com>
CC: linux-media@vger.kernel.org,
	Patrick Boettcher <pboettcher@kernellabs.com>
Subject: Re: [PATCH ] dvb-usb provide exit for any structure inside priv.
References: <1305583637.2481.3.camel@localhost>
In-Reply-To: <1305583637.2481.3.camel@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 16-05-2011 19:07, Malcolm Priestley escreveu:
> Currently priv is freed from memory by dvb-usb on any error or exit.
>  If any buffer has been allocated in the priv structure,
>  freeing it is tricky.  While freeing it on device disconnect
>  is fairly easy, on error it is almost impossible because it
>  has been removed from memory by dvb-usb.
> 
> This patch provides an exit from the priv.
> 
> Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
> ---
>  drivers/media/dvb/dvb-usb/dvb-usb-init.c |    2 ++
>  drivers/media/dvb/dvb-usb/dvb-usb.h      |    1 +
>  2 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-init.c b/drivers/media/dvb/dvb-usb/dvb-usb-init.c
> index 2e3ea0f..217b948 100644
> --- a/drivers/media/dvb/dvb-usb/dvb-usb-init.c
> +++ b/drivers/media/dvb/dvb-usb/dvb-usb-init.c
> @@ -118,6 +118,8 @@ static int dvb_usb_exit(struct dvb_usb_device *d)
>  	dvb_usb_i2c_exit(d);
>  	deb_info("state should be zero now: %x\n", d->state);
>  	d->state = DVB_USB_STATE_INIT;
> +	if (d->props.priv_exit)
> +		d->props.priv_exit(d);
>  	kfree(d->priv);
>  	kfree(d);
>  	return 0;

Hi Malcolm,

I had to read this patch a few times in order to better understand what "priv_exit"
actually means, and to look into your next changeset. IMO, it is bad named. 

It is even more confused if we take a look on your next patch, where you're adding a
"priv_exit" callback like:

static int lme2510_priv_exit(struct dvb_usb_device *d)
+{
+	struct lme2510_state *st = d->priv;
+
+	if (st->usb_buffer != NULL) {
+		st->i2c_talk_onoff = 1;
+		st->signal_lock = 0;
+		st->signal_level = 0;
+		st->signal_sn = 0;
+		kfree(st->usb_buffer);
+	}
+
+	if (st->lme_urb != NULL) {
+		usb_kill_urb(st->lme_urb);
+		usb_free_coherent(d->udev, 5000, st->buffer,
+				  st->lme_urb->transfer_dma);
+		info("Interrupt Service Stopped");
+		rc_unregister_device(d->rc_dev);
+		info("Remote Stopped");
+	}
+
+	return 0;
+}

At the above code, you're not doing anything to release the "priv", but, instead,
all you're doing is to stop the pending USB operations and un-registering the
remote controller.

The complete dvb_usb_exit() is:

static int dvb_usb_exit(struct dvb_usb_device *d)
{
	deb_info("state before exiting everything: %x\n", d->state);
	dvb_usb_remote_exit(d);
	dvb_usb_adapter_exit(d);
	dvb_usb_i2c_exit(d);
	deb_info("state should be zero now: %x\n", d->state);
	d->state = DVB_USB_STATE_INIT;
	kfree(d->priv);
	kfree(d);
	return 0;
}

The remote controller is already unregistered at dvb_usb_remote_exit():

int dvb_usb_remote_exit(struct dvb_usb_device *d)
{
	if (d->state & DVB_USB_STATE_REMOTE) {
		cancel_delayed_work_sync(&d->rc_query_work);
		if (d->props.rc.mode == DVB_RC_LEGACY)
			input_unregister_device(d->input_dev);
		else
			rc_unregister_device(d->rc_dev);
	}
	d->state &= ~DVB_USB_STATE_REMOTE;
	return 0;
}

So, the rc_unregister_device() above is wrong.

I agree that stopping the current undergoing transfers is needed. Yet, as there is a
"usb_urb_kill" function defined, I suspect that other dvb-usb drivers use a different
logic to stop URB transfers. If not, then the same bug is present also on the other
drivers ;)

Patrick,

Any comments?

Thanks,
Mauro

