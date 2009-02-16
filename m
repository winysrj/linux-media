Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp113.rog.mail.re2.yahoo.com ([68.142.225.229]:48301 "HELO
	smtp113.rog.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751064AbZBPSSc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Feb 2009 13:18:32 -0500
Message-ID: <4999ADF6.4070604@rogers.com>
Date: Mon, 16 Feb 2009 13:18:30 -0500
From: CityK <cityk@rogers.com>
MIME-Version: 1.0
To: Chris Wilson <info@coolcatpc.com>,
	Linux-media <linux-media@vger.kernel.org>
Subject: Re: [Bulk] RE: New Card - BT878
References: <000301c98983$d0d1c7e0$727557a0$@com> <499894F2.7050703@rogers.com> <001f01c98fea$2823e4d0$786bae70$@com>
In-Reply-To: <001f01c98fea$2823e4d0$786bae70$@com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Chris Wilson wrote:
> Howdy, thanks for all the info! :) its greatly appreciated. Thanks for all
> the background information as well. 
>
>
> This is the output from lspci -s 01:05.0 -vnn for my BT878 Card:
>
> 01:05.0 0400: 109e:036c (rev 11)
>         Flags: medium devsel, IRQ 10
>         Memory at fd800000 (32-bit, prefetchable) [disabled] [size=4K]
>         Capabilities: [44] Vital Product Data
>         Capabilities: [4c] Power Management version 0
>
> I've had this card working before, the ol' noggin does'nt want to fire on
> all eight and remind me how I did it ;). 
>
> Thanks a bunch once again!

Hi Chris,

Please don't drop the mailing lists from the discussion (use your email
client's "reply all" feature) ... I have cc'ed the Linux-media list back
in. Also, in future, please don't top post.

Regarding this card, the absence of a device subsystem ID in your output
for the above command leads me to think that your card likely lacks an
EEPROM. Do you know the name of the device or is it just a generic bttv
card? (i was hoping we could have ascertained its identity from the
above command, but obviously no luck on that route).

Given that you've been able to run it under Linux before (as per your
above and previous message's statements), that is certainly encouraging.
Can you please provide the output from dmesg.

