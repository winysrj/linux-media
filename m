Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:55322 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751156AbcHANnj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Aug 2016 09:43:39 -0400
Subject: Re: [RFC PATCH] serio: add hangup support
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
References: <287a7f88-5d45-bb45-c98e-22a2313ab780@xs4all.nl>
 <20160715163119.GA27847@dtor-ws>
Cc: linux-input <linux-input@vger.kernel.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Pavel Machek <pavel@ucw.cz>, Vojtech Pavlik <vojtech@suse.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <fcdd38a6-52f3-3c01-d99f-3a978bfac512@xs4all.nl>
Date: Mon, 1 Aug 2016 15:43:32 +0200
MIME-Version: 1.0
In-Reply-To: <20160715163119.GA27847@dtor-ws>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 07/15/2016 06:31 PM, Dmitry Torokhov wrote:
> Hi Hans,
> 
> On Fri, Jul 15, 2016 at 01:27:21PM +0200, Hans Verkuil wrote:
>> For the upcoming 4.8 kernel I made a driver for the Pulse-Eight USB CEC adapter.
>> This is a usb device that shows up as a ttyACM0 device. It requires that you run
>> inputattach in order to communicate with it via serio.
>>
>> This all works well, but it would be nice to have a udev rule to automatically
>> start inputattach. That too works OK, but the problem comes when the USB device
>> is unplugged: the tty hangup is never handled by the serio framework so the
>> inputattach utility never exits and you have to kill it manually.
>>
>> By adding this hangup callback the inputattach utility now exists as soon as I
>> unplug the USB device.
>>
>> Is this the correct approach?
>>
>> BTW, the new driver is found here:
>>
>> https://git.linuxtv.org/media_tree.git/tree/drivers/staging/media/pulse8-cec
>>
>> Regards,
>>
>> 	Hans
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> ---
>> diff --git a/drivers/input/serio/serport.c b/drivers/input/serio/serport.c
>> index 9c927d3..a615846 100644
>> --- a/drivers/input/serio/serport.c
>> +++ b/drivers/input/serio/serport.c
>> @@ -248,6 +248,14 @@ static long serport_ldisc_compat_ioctl(struct tty_struct *tty,
>>  }
>>  #endif
>>
>> +static int serport_ldisc_hangup(struct tty_struct * tty)
>> +{
>> +	struct serport *serport = (struct serport *) tty->disc_data;
>> +
>> +	serport_serio_close(serport->serio);
> 
> I see what you mean, but this is not quite correct. I think we should
> make serport_serio_close() only reset the SERPORT_ACTIVE flag and have
> serport_ldisc_hangup() actually do:
> 
> 	spin_lock_irqsave(&serport->lock, flags);
> 	set_bit(SERPORT_DEAD, &serport->flags);
> 	spin_unlock_irqrestore(&serport->lock, flags);
> 
> 	wake_up_interruptible(&serport->wait);

I'm preparing a v2 of this patch, but I wonder if in this hangup code
I also need to clear the SERPORT_ACTIVE flag. Or is it guaranteed that
close() always precedes hangup()? In which case close() always clears that
flag.

Regards,

	Hans

> 
> i.e. if user (via device-driver - input core - evdev - userspace chain)
> stops using serio port we should not kill inputattach instance right
> then and there, but wait for the serial port device disconnect or
> something else killing inputattach.
> 
> Vojtech, do you recall any of this code?
> 
> Thanks.
> 
