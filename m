Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:52961 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753169AbbEUMaU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 May 2015 08:30:20 -0400
To: =?UTF-8?Q?Antti_Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>
Subject: Re: [PATCH v3 1/7] rc: rc-ir-raw: Add scancode encoder callback
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date: Thu, 21 May 2015 14:30:18 +0200
From: =?UTF-8?Q?David_H=C3=A4rdeman?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	James Hogan <james@albanarts.com>
In-Reply-To: <CAKv9HNZ_JjCutG-V+77vu2xMEihbRrYJSr4QR+LESSdrM71+yQ@mail.gmail.com>
References: <1427824092-23163-1-git-send-email-a.seppala@gmail.com>
 <1427824092-23163-2-git-send-email-a.seppala@gmail.com>
 <20150519203851.GC18036@hardeman.nu>
 <CAKv9HNb=qK18mGj9dOdyqEPvABU8b8aAEmGa1s2NULC4g0KX-Q@mail.gmail.com>
 <20150520182901.GB13624@hardeman.nu>
 <CAKv9HNZdsse=ETkKpZWPN8Z+kLA_aNxpvEtr_WFGp5ZpaZ36dg@mail.gmail.com>
 <20150520204557.GB15223@hardeman.nu>
 <CAKv9HNZEQJkCE3b0OcOGg_o59aYiTwLhQ0f=ji1obcJcG7ePwA@mail.gmail.com>
 <32cae92aa099067315d1a13c7302957f@hardeman.nu>
 <CAKv9HNZ_JjCutG-V+77vu2xMEihbRrYJSr4QR+LESSdrM71+yQ@mail.gmail.com>
Message-ID: <db6f383689a45d2d9b5346c41e48d535@hardeman.nu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2015-05-21 13:51, Antti Seppälä wrote:
> On 21 May 2015 at 12:14, David Härdeman <david@hardeman.nu> wrote:
>> I'm talking about ir_raw_encode_scancode() which is entirely broken in 
>> its
>> current state. It will, given more than one enabled protocol, encode a
>> scancode to pulse/space events according to the rules of a randomly 
>> chosen
>> protocol. That random selection will be influenced by things like 
>> *module
>> load order* (independent of the separate fact that passing multiple
>> protocols to it is completely bogus in the first place).
>> 
>> To be clear: the same scancode may be encoded differently depending on 
>> if
>> you've load the nec decoder before or after the rc5 decoder! That kind 
>> of
>> behavior can't go into a release kernel (Mauro...).
>> 
> 
> So... if the ir_raw_handler_list is sorted to eliminate the randomness
> caused by module load ordering you will be happy (or happier)?

No, cause it's a horrible hack. And the caller of ir_raw_handler_list() 
still has no idea of knowing (given more than one protocol) which 
protocol a given scancode will be encoded according to.

> That is something that could be useful even for the ir-decoding
> functionality and might be worth a separate patch.

Useful how?
