Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f66.google.com ([209.85.220.66]:35860 "EHLO
	mail-pa0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237AbcHCP02 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Aug 2016 11:26:28 -0400
Date: Wed, 3 Aug 2016 08:26:02 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-input <linux-input@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCHv2] serio: add hangup support
Message-ID: <20160803152602.GB29702@dtor-ws>
References: <0d959a01-e698-0178-af89-5925469f95ab@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0d959a01-e698-0178-af89-5925469f95ab@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Aug 03, 2016 at 01:00:44PM +0200, Hans Verkuil wrote:
> The Pulse-Eight USB CEC adapter is a usb device that shows up as a ttyACM0 device.
> It requires that you run inputattach in order to communicate with it via serio.
> 
> This all works well, but it would be nice to have a udev rule to automatically
> start inputattach. That too works OK, but the problem comes when the USB device
> is unplugged: the tty hangup is never handled by the serio framework so the
> inputattach utility never exits and you have to kill it manually.
> 
> By adding this hangup callback the inputattach utility now properly exits as
> soon as the USB device is unplugged.
> 
> The udev rule I used on my Debian sid system is:
> 
> SUBSYSTEM=="tty", KERNEL=="ttyACM[0-9]*", ATTRS{idVendor}=="2548", ATTRS{idProduct}=="1002", ACTION=="add", TAG+="systemd", ENV{SYSTEMD_WANTS}+="pulse8-cec-inputattach@%k.service"
> 
> And pulse8-cec-inputattach@%k.service is as follows:
> 
> ===============================================================
> [Unit]
> Description=inputattach for pulse8-cec device on %I
> 
> [Service]
> Type=simple
> ExecStart=/usr/local/bin/inputattach --pulse8-cec /dev/%I
> KillMode=process
> ===============================================================
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Tested-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
> Change since the original RFC patch: don't call close() from the hangup() function,
> instead only set the DEAD flag in hangup() instead of in close().
> ---
> diff --git a/drivers/input/serio/serport.c b/drivers/input/serio/serport.c
> index 9c927d3..4045e95 100644
> --- a/drivers/input/serio/serport.c
> +++ b/drivers/input/serio/serport.c
> @@ -71,7 +71,6 @@ static void serport_serio_close(struct serio *serio)
> 
>  	spin_lock_irqsave(&serport->lock, flags);
>  	clear_bit(SERPORT_ACTIVE, &serport->flags);
> -	set_bit(SERPORT_DEAD, &serport->flags);
>  	spin_unlock_irqrestore(&serport->lock, flags);
> 
>  	wake_up_interruptible(&serport->wait);

I think we should remove this line as well - the waiter is waiting on
SERPORT_DEAD bit, if we are not setting it we do not need to wake up the
waiter either.

I can fix it up on my side.

> @@ -248,6 +247,19 @@ static long serport_ldisc_compat_ioctl(struct tty_struct *tty,
>  }
>  #endif
> 
> +static int serport_ldisc_hangup(struct tty_struct * tty)
> +{
> +	struct serport *serport = (struct serport *) tty->disc_data;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&serport->lock, flags);
> +	set_bit(SERPORT_DEAD, &serport->flags);
> +	spin_unlock_irqrestore(&serport->lock, flags);
> +
> +	wake_up_interruptible(&serport->wait);
> +	return 0;
> +}
> +
>  static void serport_ldisc_write_wakeup(struct tty_struct * tty)
>  {
>  	struct serport *serport = (struct serport *) tty->disc_data;
> @@ -274,6 +286,7 @@ static struct tty_ldisc_ops serport_ldisc = {
>  	.compat_ioctl =	serport_ldisc_compat_ioctl,
>  #endif
>  	.receive_buf =	serport_ldisc_receive,
> +	.hangup =	serport_ldisc_hangup,
>  	.write_wakeup =	serport_ldisc_write_wakeup
>  };
> 

Thanks.

-- 
Dmitry
