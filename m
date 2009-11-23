Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:24630 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758AbZKWVyj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Nov 2009 16:54:39 -0500
MIME-Version: 1.0
In-Reply-To: <m3einork1o.fsf@intrepid.localdomain>
References: <BDRae8rZjFB@christoph> <m3einork1o.fsf@intrepid.localdomain>
Date: Mon, 23 Nov 2009 16:54:44 -0500
Message-ID: <829197380911231354y764e01b7hc0c5721b3ebf1f26@mail.gmail.com>
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was:
	Re: [PATCH 1/3 v2] lirc core device driver infrastructure
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Christoph Bartelmus <lirc@bartelmus.de>, dmitry.torokhov@gmail.com,
	j@jannau.net, jarod@redhat.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	mchehab@redhat.com, superm1@ubuntu.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Nov 23, 2009 at 4:46 PM, Krzysztof Halasa <khc@pm.waw.pl> wrote:
> lirc@bartelmus.de (Christoph Bartelmus) writes:
>
>>> I think we shouldn't at this time worry about IR transmitters.
>>
>> Sorry, but I have to disagree strongly.
>> Any interface without transmitter support would be absolutely unacceptable
>> for many LIRC users, including myself.
>
> I don't say don't use a transmitter.
> I say the transmitter is not an input device, they are completely
> independent functions. I can't see any reason to try and fit both in the
> same interface - can you?

There is an argument to be made that since it may be desirable for
both IR receivers and transmitters to share the same table of remote
control definitions, it might make sense to at least *consider* how
the IR transmitter interface is going to work, even if it is decided
to not implement such a design in the first revision.

Personally, I would hate to see a situation where we find out that we
took a bad approach because nobody considered what would be required
for IR transmitters to reuse the same remote control definition data.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
