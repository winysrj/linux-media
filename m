Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:50088 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796AbZKHBox convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Nov 2009 20:44:53 -0500
Received: by bwz27 with SMTP id 27so2380700bwz.21
        for <linux-media@vger.kernel.org>; Sat, 07 Nov 2009 17:44:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1257644240.6895.5.camel@palomino.walls.org>
References: <1257630476.15927.400.camel@localhost>
	 <1257644240.6895.5.camel@palomino.walls.org>
Date: Sat, 7 Nov 2009 20:44:57 -0500
Message-ID: <829197380911071744q50fc6e18o527322e1120b9689@mail.gmail.com>
Subject: Re: [PATCH 10/75] V4L/DVB: declare MODULE_FIRMWARE for modules using
	XC2028 and XC3028L tuners
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Andy Walls <awalls@radix.net>
Cc: Ben Hutchings <ben@decadent.org.uk>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Nov 7, 2009 at 8:37 PM, Andy Walls <awalls@radix.net> wrote:
> On Sat, 2009-11-07 at 21:47 +0000, Ben Hutchings wrote:
>> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
>> ---
>> I'm not really sure whether it's better to do this in the drivers which
>> specify which firmware file to use, or just once in the xc2028 tuner
>> driver.  Your call.
>>
>> Ben.
>
> Ben,
>
> I would suspect it's better left in the xc2028 tuner driver module.
>
> Rationale:
>
> a. it will be consistent with other modules like the cx25840 module.
> ivtv and cx23885 load the cx25840 module yet the MODULE_FIRMWARE
> advertisement for the CX2584[0123] or CX2388[578] A/V core firmware is
> in the cx25840 module.
>
> b. not every ivtv or cx18 supported TV card, for example, needs the
> XCeive tuner chip firmware, so it's not a strict requirement for those
> modules.  It is a strict(-er) requirement for the xc2028 module.
>
> My $0.02
>
> Regards,
> Andy

It's not clear to me what this MODULE_FIRMWARE is going to be used
for, but if it's for some sort of module dependency system, then it
definitely should *not* be a dependency for em28xx.  There are lots of
em28xx based devices that do not use the xc3028, and those users
should not be expected to go out and find/extract the firmware for
some tuner they don't have.

Also, how does this approach handle the situation where there are two
different possible firmwares depending on the card using the firmware.
 As in the example above, you the xc3028 can require either the xc3028
or xc3028L firmware depending on the board they have.  Does this
change now result in both firmware images being required?

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
