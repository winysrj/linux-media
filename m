Return-path: <linux-media-owner@vger.kernel.org>
Received: from static-72-93-233-3.bstnma.fios.verizon.net ([72.93.233.3]:46790
	"EHLO mail.wilsonet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155AbZKOGzc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Nov 2009 01:55:32 -0500
Subject: Re: [PATCH 2/3 v2] lirc driver for Windows MCE IR transceivers
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
From: Jarod Wilson <jarod@wilsonet.com>
In-Reply-To: <200911132143.59064.s.L-H@gmx.de>
Date: Sun, 15 Nov 2009 01:55:31 -0500
Cc: Jarod Wilson <jarod@redhat.com>, linux-kernel@vger.kernel.org,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org,
	Janne Grunau <j@jannau.net>,
	Christoph Bartelmus <lirc@bartelmus.de>
Content-Transfer-Encoding: 8BIT
Message-Id: <B103AC62-9068-437A-94B8-5B4BDBB4D38D@wilsonet.com>
References: <200910200956.33391.jarod@redhat.com> <200910201000.00372.jarod@redhat.com> <200911132143.59064.s.L-H@gmx.de>
To: Stefan Lippers-Hollmann <s.L-H@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Nov 13, 2009, at 3:43 PM, Stefan Lippers-Hollmann wrote:

> Hi
> 
> Thank you for trying to get lirc mainline. Hoping that no real complaints 
> against it arise, what about submitting the tree to linux-next, so it gets 
> more testing exposure before the merge window opens for 2.6.33?

At the point, I'd be happy with getting into linux-next or even the staging tree.

> On Friday 13 November 2009, Jarod Wilson wrote:
>> lirc driver for Windows Media Center Ed. IR transceivers
> [...]
>> Index: b/drivers/input/lirc/Kconfig
>> ===================================================================
>> --- a/drivers/input/lirc/Kconfig
>> +++ b/drivers/input/lirc/Kconfig
>> @@ -11,6 +11,10 @@ menuconfig INPUT_LIRC
>> 
>> if INPUT_LIRC
>> 
>> -# Device-specific drivers go here
>> +config LIRC_MCEUSB
>> +	tristate "Windows Media Center Ed. USB IR Transceiver"
>> +	depends on LIRC_DEV && USB
> 
> You have obviously renamed LIRC_DEV to INPUT_LIRC just before the 
> submission, but missed to do so for the individual drivers which still 
> depend on LIRC_DEV and are therefore not selectable; the same applies to
> [PATCH 3/3 v2] lirc driver for SoundGraph iMON IR receivers and displays.

D'oh. Yeah, I sure did. Didn't notice the fubar, because I was building and testing the stuff on an existing kernel that already had LIRC_DEV defined. Earlier versions actually had both INPUT_LIRC and LIRC_DEV, which are essentially one in the same. I'll fix that shortly.

-- 
Jarod Wilson
jarod@wilsonet.com



