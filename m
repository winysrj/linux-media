Return-path: <linux-media-owner@vger.kernel.org>
Received: from hardeman.nu ([95.142.160.32]:39534 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750946AbaCaTnk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Mar 2014 15:43:40 -0400
Date: Mon, 31 Mar 2014 21:43:39 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: James Hogan <james.hogan@imgtec.com>
Cc: linux-media@vger.kernel.org, m.chehab@samsung.com
Subject: Re: [PATCH] rc-core: do not change 32bit NEC scancode format for now
Message-ID: <20140331194339.GE9610@hardeman.nu>
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
>> On Thu, Mar 27, 2014 at 11:21:23PM +0000, James Hogan wrote:
>>>On Thursday 27 March 2014 22:00:37 David Härdeman wrote:
>>>> This reverts 18bc17448147e93f31cc9b1a83be49f1224657b2
>>>> 
>>>> The patch ignores the fact that NEC32 scancodes are generated not only in
>>>> the NEC raw decoder but also directly in some drivers. Whichever approach
>>>> is chosen it should be consistent across drivers and this patch needs
>>>> more
>>>> discussion.
>>>
>>>Fair enough. For reference which drivers are you referring to?
>> 
>> The ones I'm aware of right now are:
>
>Thanks, I hadn't looked properly outside of drivers/media/rc/ :(
>
>> drivers/media/usb/dvb-usb/dib0700_core.c
>
>AFAICT this only seems to support 16bit and 24bit NEC, so NEC-32 doesn't affect 
>it. I may have missed something subtle.

Nah. You're right, it can be converted to NEC32 by simply removing one
check, but it isn't NEC32 capable yet.

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

I think that might also be a reason to generate the NEC32 scancode in
the order that I've proposed (i.e. it only requires change to the sw NEC
decoder).

On the other hand I'm still dithering on whether your proposed NEC32
scancode (which is what the sw decoder uses) or my proposal (which is
what the other hw decoders use) should be canonical... :)

-- 
David Härdeman
