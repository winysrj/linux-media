Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.lang.hm ([64.81.33.126]:60564 "HELO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932680AbZLMBRP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Dec 2009 20:17:15 -0500
Date: Sat, 12 Dec 2009 14:04:16 -0800 (PST)
From: david@lang.hm
To: Krzysztof Halasa <khc@pm.waw.pl>
cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Christoph Bartelmus <lirc@bartelmus.de>,
	dmitry.torokhov@gmail.com, j@jannau.net, jarod@redhat.com,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, mchehab@redhat.com, superm1@ubuntu.com
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was:
  Re: [PATCH 1/3 v2] lirc core device driver infrastructure
In-Reply-To: <m36390rhzp.fsf@intrepid.localdomain>
Message-ID: <alpine.DEB.2.00.0912121401500.3370@asgard.lang.hm>
References: <BDRae8rZjFB@christoph> <m3einork1o.fsf@intrepid.localdomain> <829197380911231354y764e01b7hc0c5721b3ebf1f26@mail.gmail.com> <m36390rhzp.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 23 Nov 2009, Krzysztof Halasa wrote:

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
>
> Perhaps I'm wrong.

I could definantly see this happening. the computer receives the 'play' 
button from a dvd remote, issues commands to control the audio system, dim 
lights, and then sends the 'play' button to the DVD player inside a 
cabinet where it can't see the remote directly.

but in any case, it shouldn't be hard to share a table of mappings.

David Lang
