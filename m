Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37734 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759880Ab2CTMSN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Mar 2012 08:18:13 -0400
Message-ID: <4F687572.1030109@redhat.com>
Date: Tue, 20 Mar 2012 09:17:54 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	LMML <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 1/2] [media] dib0700: Drop useless check when remote key
 is pressed
References: <20120313185037.4059a869@endymion.delvare> <CAGoCfixvanxKT4h1k+FkaYkQ-zHjR-rYBWxHHiDygOScPCeZPA@mail.gmail.com> <4F67B283.4050308@redhat.com> <20120320082002.6551466a@endymion.delvare>
In-Reply-To: <20120320082002.6551466a@endymion.delvare>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 20-03-2012 04:20, Jean Delvare escreveu:
> Hi Mauro,
> 
> On Mon, 19 Mar 2012 19:26:11 -0300, Mauro Carvalho Chehab wrote:
>>  On Tue, Mar 13, 2012 at 1:50 PM, Jean Delvare <khali@linux-fr.org> wrote:
>>> --- linux-3.3-rc7.orig/drivers/media/dvb/dvb-usb/dib0700_core.c	2012-03-13 11:09:13.000000000 +0100
>>> +++ linux-3.3-rc7/drivers/media/dvb/dvb-usb/dib0700_core.c	2012-03-13 18:37:05.785953845 +0100
>>> @@ -677,9 +677,6 @@ static void dib0700_rc_urb_completion(st
>>>  	u8 toggle;
>>>  
>>>  	deb_info("%s()\n", __func__);
>>> -	if (d == NULL)
>>> -		return;
>>> -
>>
>> Well, usb_free_urb() is not called when d == NULL, so, if this condition
>> ever happens, it will keep URB's allocated.
>>
>> Anyway, if struct dvb_usb_device *d is NULL, the driver has something very
>> wrong happening on it, and nothing will work on it.
>>
>> I agree with Jean: it is better to just remove this code there.
>>
>> Yet, I'd be more happy if Jean's patch could check first if the status is
>> below 0, in order to prevent a possible race condition at device disconnect.
> 
> I'm not sure I see the race condition you're seeing. Do you believe
> purb->context would be NULL (or point to already-freed memory) when
> dib0700_rc_urb_completion is called as part of device disconnect? Or is
> it something else? I'll be happy to resubmit my patch series with a fix
> if you explain where you think there is a race condition.
> 

What I'm saying is that the only potential chance of having a NULL value
for d is at the device disconnect/removal, if is there any bug when waiting
for the URB's to be killed.

So, it would be better to invert the error test logic to:

static void dib0700_rc_urb_completion(struct urb *purb)
{
	struct dvb_usb_device *d = purb->context;
	struct dib0700_rc_response *poll_reply;
	u32 uninitialized_var(keycode);
	u8 toggle;

	poll_reply = purb->transfer_buffer;
	if (purb->status < 0) {
		deb_info("discontinuing polling\n");
		kfree(purb->transfer_buffer);
		usb_free_urb(purb);
		return;
	}

	deb_info("%s()\n", __func__);
	if (d->rc_dev == NULL) {
		/* This will occur if disable_rc_polling=1 */
		kfree(purb->transfer_buffer);
		usb_free_urb(purb);
		return;
	}

As, at device disconnect/completion, the status will indicate an error, and
the function will return before trying to de-referenciate rc_dev.

Regards,
Mauro
