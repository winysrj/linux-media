Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5295 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757913Ab2CSW0c (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Mar 2012 18:26:32 -0400
Message-ID: <4F67B283.4050308@redhat.com>
Date: Mon, 19 Mar 2012 19:26:11 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Jean Delvare <khali@linux-fr.org>,
	LMML <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 1/2] [media] dib0700: Drop useless check when remote key
 is pressed
References: <20120313185037.4059a869@endymion.delvare> <CAGoCfixvanxKT4h1k+FkaYkQ-zHjR-rYBWxHHiDygOScPCeZPA@mail.gmail.com>
In-Reply-To: <CAGoCfixvanxKT4h1k+FkaYkQ-zHjR-rYBWxHHiDygOScPCeZPA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 13-03-2012 14:57, Devin Heitmueller escreveu:
> On Tue, Mar 13, 2012 at 1:50 PM, Jean Delvare <khali@linux-fr.org> wrote:
>> struct dvb_usb_device *d can never be NULL so don't waste time
>> checking for this.
>>
>> Rationale: the urb's context is set when usb_fill_bulk_urb() is called
>> in dib0700_rc_setup(), and never changes after that. d is dereferenced
>> unconditionally in dib0700_rc_setup() so it can't be NULL or the
>> driver would crash right away.
>>
>> Signed-off-by: Jean Delvare <khali@linux-fr.org>
>> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
>> Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
>> ---
>> Devin, am I missing something?
> 
> I think this was just a case of defensive coding where I didn't want
> to dereference something without validating the pointer first (out of
> fear that it got called through some other code path that I didn't
> consider).

>> --- linux-3.3-rc7.orig/drivers/media/dvb/dvb-usb/dib0700_core.c	2012-03-13 11:09:13.000000000 +0100
>> +++ linux-3.3-rc7/drivers/media/dvb/dvb-usb/dib0700_core.c	2012-03-13 18:37:05.785953845 +0100
>> @@ -677,9 +677,6 @@ static void dib0700_rc_urb_completion(st
>>  	u8 toggle;
>>  
>>  	deb_info("%s()\n", __func__);
>> -	if (d == NULL)
>> -		return;
>> -

Well, usb_free_urb() is not called when d == NULL, so, if this condition
ever happens, it will keep URB's allocated.

Anyway, if struct dvb_usb_device *d is NULL, the driver has something very
wrong happening on it, and nothing will work on it.

I agree with Jean: it is better to just remove this code there.

Yet, I'd be more happy if Jean's patch could check first if the status is
below 0, in order to prevent a possible race condition at device disconnect.

Regards,
Mauro
