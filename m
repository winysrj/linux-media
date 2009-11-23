Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:16276 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844AbZKWWgz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Nov 2009 17:36:55 -0500
MIME-Version: 1.0
In-Reply-To: <m36390rhzp.fsf@intrepid.localdomain>
References: <BDRae8rZjFB@christoph> <m3einork1o.fsf@intrepid.localdomain>
	 <829197380911231354y764e01b7hc0c5721b3ebf1f26@mail.gmail.com>
	 <m36390rhzp.fsf@intrepid.localdomain>
Date: Mon, 23 Nov 2009 17:37:00 -0500
Message-ID: <829197380911231437v909a111rcc2967af3e4fffa2@mail.gmail.com>
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

On Mon, Nov 23, 2009 at 5:31 PM, Krzysztof Halasa <khc@pm.waw.pl> wrote:
> Devin Heitmueller <dheitmueller@kernellabs.com> writes:
>
>> There is an argument to be made that since it may be desirable for
>> both IR receivers and transmitters to share the same table of remote
>> control definitions, it might make sense to at least *consider* how
>> the IR transmitter interface is going to work, even if it is decided
>> to not implement such a design in the first revision.
>>
>> Personally, I would hate to see a situation where we find out that we
>> took a bad approach because nobody considered what would be required
>> for IR transmitters to reuse the same remote control definition data.
>
> I briefly though about such possibility, but dismissed it with
> assumption that we won't transmit the same codes (including "key" codes)
> that we receive.

I'm not specifically suggesting that you would want to transmit the
same codes that you receive, but you probably want the database of
remote control definitions to be shared.

For example, you might want the IR receiver to be listening for codes
using the "Universal Remote Control XYZ" profile and the IR
transmitter pretending to be "Cable Company Remote Control ABC" when
blasting IR codes to the cable box.  Ideally, there would be a single
shared database of the definitions of the remote controls, regardless
of whether you are IR receiving or transmitting.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
