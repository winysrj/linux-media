Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:34711 "EHLO
	mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbcGOQbY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jul 2016 12:31:24 -0400
Date: Fri, 15 Jul 2016 09:31:19 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-input <linux-input@vger.kernel.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Pavel Machek <pavel@ucw.cz>, Vojtech Pavlik <vojtech@suse.com>
Subject: Re: [RFC PATCH] serio: add hangup support
Message-ID: <20160715163119.GA27847@dtor-ws>
References: <287a7f88-5d45-bb45-c98e-22a2313ab780@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <287a7f88-5d45-bb45-c98e-22a2313ab780@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Fri, Jul 15, 2016 at 01:27:21PM +0200, Hans Verkuil wrote:
> For the upcoming 4.8 kernel I made a driver for the Pulse-Eight USB CEC adapter.
> This is a usb device that shows up as a ttyACM0 device. It requires that you run
> inputattach in order to communicate with it via serio.
> 
> This all works well, but it would be nice to have a udev rule to automatically
> start inputattach. That too works OK, but the problem comes when the USB device
> is unplugged: the tty hangup is never handled by the serio framework so the
> inputattach utility never exits and you have to kill it manually.
> 
> By adding this hangup callback the inputattach utility now exists as soon as I
> unplug the USB device.
> 
> Is this the correct approach?
> 
> BTW, the new driver is found here:
> 
> https://git.linuxtv.org/media_tree.git/tree/drivers/staging/media/pulse8-cec
> 
> Regards,
> 
> 	Hans
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> ---
> diff --git a/drivers/input/serio/serport.c b/drivers/input/serio/serport.c
> index 9c927d3..a615846 100644
> --- a/drivers/input/serio/serport.c
> +++ b/drivers/input/serio/serport.c
> @@ -248,6 +248,14 @@ static long serport_ldisc_compat_ioctl(struct tty_struct *tty,
>  }
>  #endif
> 
> +static int serport_ldisc_hangup(struct tty_struct * tty)
> +{
> +	struct serport *serport = (struct serport *) tty->disc_data;
> +
> +	serport_serio_close(serport->serio);

I see what you mean, but this is not quite correct. I think we should
make serport_serio_close() only reset the SERPORT_ACTIVE flag and have
serport_ldisc_hangup() actually do:

	spin_lock_irqsave(&serport->lock, flags);
	set_bit(SERPORT_DEAD, &serport->flags);
	spin_unlock_irqrestore(&serport->lock, flags);

	wake_up_interruptible(&serport->wait);

i.e. if user (via device-driver - input core - evdev - userspace chain)
stops using serio port we should not kill inputattach instance right
then and there, but wait for the serial port device disconnect or
something else killing inputattach.

Vojtech, do you recall any of this code?

Thanks.

-- 
Dmitry
