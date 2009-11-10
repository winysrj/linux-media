Return-path: <linux-media-owner@vger.kernel.org>
Received: from acorn.exetel.com.au ([220.233.0.21]:49387 "EHLO
	acorn.exetel.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898AbZKJAPX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Nov 2009 19:15:23 -0500
Message-ID: <34578.64.213.30.2.1257812125.squirrel@webmail.exetel.com.au>
In-Reply-To: <829197380911091611m5d534cffvde5334c81fc2515c@mail.gmail.com>
References: <ad6681df0911090313t17652362v2e92c465b60a92e4@mail.gmail.com>
    <20091109144647.2f876934@pedra.chehab.org>
    <13029.64.213.30.2.1257810088.squirrel@webmail.exetel.com.au>
    <829197380911091611m5d534cffvde5334c81fc2515c@mail.gmail.com>
Date: Tue, 10 Nov 2009 11:15:25 +1100 (EST)
Subject: Re: [XC3028] Terretec Cinergy T XS wrong firmware xc3028-v27.fw
From: "Robert Lowery" <rglowery@exemail.com.au>
To: "Devin Heitmueller" <dheitmueller@kernellabs.com>
Cc: "Mauro Carvalho Chehab" <mchehab@infradead.org>,
	linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> On Mon, Nov 9, 2009 at 6:41 PM, Robert Lowery <rglowery@exemail.com.au>
> wrote:
>> Although the xc3028-v27.fw generated from
>> HVR-12x0-14x0-17x0_1_25_25271_WHQL.zip using the above process works
>> fine
>> for me, the firmware is a couple of years old now and I can't help
>> wondering if there might be a newer version in the latest Windows
>> drivers
>> out there containing performance or stability fixes it in.
>>
>> Do you think it would be worthwhile extracting a newer version of
>> firmware?
>
> That is the latest version of the firmware for that chip.  Xceive has
> not updated it since then, given that they are focusing on newer
> products like the xc5000 and xc3028L.
>
> Your problem has nothing to do with the firmware.  The issue is the
> driver support for your particular device was only added recently
> (after Ubuntu did their kernel freeze for Karmic).  The work
> associated with adding support for devices is nontrivial, and I
> typically only do it when people report that their device needs
> support.
>
> Devin
Sorry Devin,

I shoudn't have hijacked this thread.  My question was general in nature
and not related to the issues being discussed in this thread.

If v2.7 is the latest firmware released by Xceive for the xc3028 then that
answers my question

Thanks

-Rob

