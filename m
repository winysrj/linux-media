Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:11355 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755396AbZHFNTJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Aug 2009 09:19:09 -0400
Received: by ey-out-2122.google.com with SMTP id 9so342184eyd.37
        for <linux-media@vger.kernel.org>; Thu, 06 Aug 2009 06:19:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A7AD57B.8020906@netscape.net>
References: <4A7AC430.4070505@netscape.net>
	 <37219a840908060553g452266fdq5ea3814b4ce725bc@mail.gmail.com>
	 <4A7AD57B.8020906@netscape.net>
Date: Thu, 6 Aug 2009 09:19:07 -0400
Message-ID: <37219a840908060619q7e41b024nf4e73b21843942c5@mail.gmail.com>
Subject: Re: Hauppauge WinTV HVR-900HD support?
From: Michael Krufky <mkrufky@kernellabs.com>
To: Kaya Saman <SamanKaya@netscape.net>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Aug 6, 2009 at 9:07 AM, Kaya Saman<SamanKaya@netscape.net> wrote:
> Michael Krufky wrote:
>>
>> Kaya,
>>
>> On Thu, Aug 6, 2009 at 7:53 AM, Kaya Saman<SamanKaya@netscape.net> wrote:
>>
>>>
>>>
>>
>> I don't think that's true -- I didn't see your earlier post, but I can
>> only assume that your WinTV USB 1 Tuner uses the NT003 / NT004
>> chipsets, supported by the usbvision driver -- did you try that?
>>
>>
>> Better off getting a new one anyway, since analog TV will disappear
>> eventually and DTV is all that will be around.
>>  The HVR-900H is currently *not* supported under Linux, and it does not
>> seem that it will get such support anytime in the near future,
>> unfortunately.  Please note, I am only speaking for the HVR-900H ...
>> other flavors of the HVR900 are fully functional and supported, just
>> not the "H" version.
>>
>> If you're looking for a well-supported USB hybrid device, I would
>> recommend one of the standard "HVR-900" sticks, or even better, the
>> HVR-1900 .  The HVR1900 is a usb device that does Digital DVB-T and
>> analog (PAL / NTSC) both.  The analog side has a hardware mpeg encoder
>> -- this is perfect if you intend to use the device for recordings.
>> HVR1900 is fully supported under Linux.
>>
>> I hope this helps.
>>
>> Regards,
>>
>> Mike
>>
>
> Thanks for the response Mike!
>
> You claim there is a Hauppauge HVR-1900... I am looking on the
> www.hauppauge.co.uk website and all I see is a 1400 which is SMC slot??


HVR1400 is expresscard.

HVR1900 is usb2.  HVR1950 is the NTSC/ATSC/QAM version of the HVR1900.
 (HVR1900 is PAL/DVB-T, but can also do NTSC, and other analog
standards)

HVR1900 is the one I am recommending for you.  Maybe the website
you're looking at needs updating -- the HVR1900 has been available
already for quite some time.

Regards,

Mike
