Return-path: <linux-media-owner@vger.kernel.org>
Received: from hardeman.nu ([95.142.160.32]:38324 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751956AbaC2QOa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Mar 2014 12:14:30 -0400
Date: Sat, 29 Mar 2014 17:14:28 +0100
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: James Hogan <james.hogan@imgtec.com>
Cc: linux-media@vger.kernel.org, m.chehab@samsung.com
Subject: Re: [PATCH] rc-core: do not change 32bit NEC scancode format for now
Message-ID: <20140329161428.GA13387@hardeman.nu>
References: <20140327210037.20406.93136.stgit@zeus.muc.hardeman.nu>
 <7983411.lVWEDlBWc6@radagast>
 <20140328000856.GB22491@hardeman.nu>
 <22162617.bKffkdqYH7@radagast>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <22162617.bKffkdqYH7@radagast>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 28, 2014 at 11:17:09PM +0000, James Hogan wrote:
>On Friday 28 March 2014 01:08:56 David Härdeman wrote:
>> drivers/media/usb/dvb-usb-v2/az6007.c
>> drivers/media/usb/dvb-usb-v2/af9035.c
>> drivers/media/usb/dvb-usb-v2/rtl28xxu.c
>> drivers/media/usb/dvb-usb-v2/af9015.c
>> drivers/media/usb/em28xx/em28xx-input.c
>
>Note, it appears none of these do any bit reversing for the 32bit case 
>compared to 16/24 bit, so they're already different to the NEC32 scancode 
>encoding that the raw nec decoder and tivo keymap were using, which used a 
>different bitorder (!!) between the 32-bit and the 24/16-bit cases.

I know, and none of those drivers have an in-kernel NEC32 keymap, so if
anyone is using them in that manner...it's with a homebrew keymap.

>> I'd rather show you my complete proposal first before doing something
>> radical with your driver. But it was a good reminder that I need to keep
>> the NEC32 parsing in your driver in mind as well.
>
>Okay no problem. I had assumed you were aiming for a short term fix to prevent 
>the encoding change hitting mainline or an actual release (v3.15).

I am aiming for a fix within that time frame...but I hope that it can be
more than a short term one :)

Patches are on their way right now...

Regards,
David

