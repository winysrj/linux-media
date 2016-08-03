Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f66.google.com ([209.85.220.66]:34396 "EHLO
	mail-pa0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753622AbcHCGdJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Aug 2016 02:33:09 -0400
Date: Tue, 2 Aug 2016 23:32:30 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-input <linux-input@vger.kernel.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Pavel Machek <pavel@ucw.cz>, Vojtech Pavlik <vojtech@suse.com>
Subject: Re: [RFC PATCH] serio: add hangup support
Message-ID: <20160803063230.GB32559@dtor-ws>
References: <287a7f88-5d45-bb45-c98e-22a2313ab780@xs4all.nl>
 <20160715163119.GA27847@dtor-ws>
 <fcdd38a6-52f3-3c01-d99f-3a978bfac512@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fcdd38a6-52f3-3c01-d99f-3a978bfac512@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Aug 01, 2016 at 03:43:32PM +0200, Hans Verkuil wrote:
> 
> 
> On 07/15/2016 06:31 PM, Dmitry Torokhov wrote:
> > Hi Hans,
> > 
> > On Fri, Jul 15, 2016 at 01:27:21PM +0200, Hans Verkuil wrote:
> >> For the upcoming 4.8 kernel I made a driver for the Pulse-Eight USB CEC adapter.
> >> This is a usb device that shows up as a ttyACM0 device. It requires that you run
> >> inputattach in order to communicate with it via serio.
> >>
> >> This all works well, but it would be nice to have a udev rule to automatically
> >> start inputattach. That too works OK, but the problem comes when the USB device
> >> is unplugged: the tty hangup is never handled by the serio framework so the
> >> inputattach utility never exits and you have to kill it manually.
> >>
> >> By adding this hangup callback the inputattach utility now exists as soon as I
> >> unplug the USB device.
> >>
> >> Is this the correct approach?
> >>
> >> BTW, the new driver is found here:
> >>
> >> https://git.linuxtv.org/media_tree.git/tree/drivers/staging/media/pulse8-cec
> >>
> >> Regards,
> >>
> >> 	Hans
> >>
> >> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> >>
> >> ---
> >> diff --git a/drivers/input/serio/serport.c b/drivers/input/serio/serport.c
> >> index 9c927d3..a615846 100644
> >> --- a/drivers/input/serio/serport.c
> >> +++ b/drivers/input/serio/serport.c
> >> @@ -248,6 +248,14 @@ static long serport_ldisc_compat_ioctl(struct tty_struct *tty,
> >>  }
> >>  #endif
> >>
> >> +static int serport_ldisc_hangup(struct tty_struct * tty)
> >> +{
> >> +	struct serport *serport = (struct serport *) tty->disc_data;
> >> +
> >> +	serport_serio_close(serport->serio);
> > 
> > I see what you mean, but this is not quite correct. I think we should
> > make serport_serio_close() only reset the SERPORT_ACTIVE flag and have
> > serport_ldisc_hangup() actually do:
> > 
> > 	spin_lock_irqsave(&serport->lock, flags);
> > 	set_bit(SERPORT_DEAD, &serport->flags);
> > 	spin_unlock_irqrestore(&serport->lock, flags);
> > 
> > 	wake_up_interruptible(&serport->wait);
> 
> I'm preparing a v2 of this patch, but I wonder if in this hangup code
> I also need to clear the SERPORT_ACTIVE flag. Or is it guaranteed that
> close() always precedes hangup()? In which case close() always clears that
> flag.

No, we could get hangup and that would wake up the reader which will
cause de-registration of serio port. As part of that process
serport_serio_close() will be called (if serio port has been opened by
someone).

You should not need to clear "active" flag in hangup code.

Thanks.

-- 
Dmitry
