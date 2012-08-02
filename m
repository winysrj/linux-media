Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:64572 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904Ab2HBSVH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Aug 2012 14:21:07 -0400
Received: by ghrr11 with SMTP id r11so2586297ghr.19
        for <linux-media@vger.kernel.org>; Thu, 02 Aug 2012 11:21:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <7381e4d38b045460f0ff32e0905f079e.squirrel@lockie.ca>
References: <50186040.1050908@lockie.ca>
	<c5ac2603-cc98-4688-b50c-b9166cada8f0@email.android.com>
	<5019EE10.1000207@lockie.ca>
	<bdafbcab-4074-4557-b108-a76f00ab8b3e@email.android.com>
	<CAGoCfiwN=h708e65DmZi7m6gcRMmcRbRZGJvpJ6ZzUk9Cm22dQ@mail.gmail.com>
	<7381e4d38b045460f0ff32e0905f079e.squirrel@lockie.ca>
Date: Thu, 2 Aug 2012 14:21:06 -0400
Message-ID: <CAGoCfiyo_1e5iA4jZ=44=DqQFcPf3+pUFrQ1h=LHg=O-r_nPQA@mail.gmail.com>
Subject: Re: 3.5 kernel options for Hauppauge_WinTV-HVR-1250
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: bjlockie@lockie.ca
Cc: Andy Walls <awalls@md.metrocast.net>,
	linux-media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Aug 2, 2012 at 12:34 PM,  <bjlockie@lockie.ca> wrote:
> It should have been easier, select the card and it builds all the drivers
> it needs. :-)
> Is there a script somewhere that lets me select a card and automatically
> modifies the kernel config?

Yeah, that isn't really practical.  There are *hundreds* of boards,
and having one config option isn't practical given the number of
different bridge/demod/tuner combinations there are.

Heck, even for the 1250 there are eight or ten different versions, so
most users wouldn't even know the right one to choose.

The reality is that the kernel config isn't optimized for this use
case, and given the overhead in administration combined with the
*EXTREME* unlikelihood that any real users would use it, it just isn't
worth the effort.

If you're hacking the kernel config to include support for a single
board as opposed to the whole media subsystem, you're 0.001% of the
user base, and your use case isn't worth the developer effort that
would be required.

In short, we barely have the manpower to make this stuff work at all.
Wasted effort to optimize for really obscure use cases is better spent
on expanding the set of supported products.

>> Also, the 1250 is broken for analog until very recently (patches went
>> upstream for 3.5/3.6 a few days ago).
>
> North American OTA is all digital so I have no way to test it.

That's fine.  I was just trying to make clear that if you wanted
analog functionality then you need the latest code.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
