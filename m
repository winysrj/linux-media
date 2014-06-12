Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:40950 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752749AbaFLLvN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jun 2014 07:51:13 -0400
To: Niels Laukens <niels@dest-unreach.be>
Subject: Re: [BUG & PATCH] media/rc/ir-nec-decode : phantom keypress
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date: Thu, 12 Jun 2014 13:51:11 +0200
From: =?UTF-8?Q?David_H=C3=A4rdeman?= <david@hardeman.nu>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org, James Hogan <james.hogan@imgtec.com>,
	=?UTF-8?Q?Antti_Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>
In-Reply-To: <53998D69.60901@dest-unreach.be>
References: <538994CB.6020205@dest-unreach.be>
 <53980DF8.5040206@dest-unreach.be>
 <330c58e7d7849824b812db007c03b08d@hardeman.nu>
 <53998D69.60901@dest-unreach.be>
Message-ID: <754858effccb1d52ebec59f91f860c26@hardeman.nu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2014-06-12 13:22, Niels Laukens wrote:
> On 2014-06-12 12:42, David Härdeman wrote:
>> Hi,
> 
> Hi, thanks for the response
> 
> 
>> the problem with triggering a keypress as soon as 32 bits have been
>> received (i.e. before the trailing silence is detected)
> 
> Just for clarity: this patch does wait for the trailing silence. It 
> does
> NOT wait for the trailing silence to have (at least) a specific length.
> (The pulse event is only fired after the pulse has ended, because the
> length of the pulse needs to be known)

True.

Interpret "trailing silence" above as "silence long enough to indicate 
end of message" :)

>> is that it would
>> cause phantom keypresses on some other protocols (I'm thinking of 
>> NEC48,
>> which does exist in the wild).
> 
> I don't think the current code is able to decode NEC48.

No, but it would still be nice not to interpret a NEC48 signal as NEC32.

> Is NEC48 recognizable in some other way than just being longer?

IIRC, no.

> In that case, the alternative would be to start a timer when the
> TRAILING_SPACE is entered, and trigger the key-event after, say 2 
> bit-times.

Another alternative is fix the driver to implement a timeout so that 
"unreasonable" values are not generated (I saw a 240550us space in your 
log).

That's basically what the filtering version of the raw interface does 
(cf. the use of dev->timeout in ir_raw_event_store_with_filter()).

And it's what most of the popular hardware does. For instance, the 
mceusb hardware will send a USB packet with timings including that 
trailing silence. And the decoder can only do their work once a packet 
has arrived (which will contain a number of samples). That also 
demonstrates a potential problem with your suggested approach (i.e. 
timings can be buffered so calls to the decoders are not necessarily 
"real-time").

>> Now, the question is why the trailing silence isn't generated within a
>> reasonable time. Which hardware decoder do you use?
> 
> I use the IR receiver built in to the TBS6281 DVB-T tuner card. I also
> have a TBS6982 DVB-S card, but I guess it's the same hardware.

Which driver?

> It also depends on what "reasonable" means. I've found 300+ms, which is
> unusable long.

Agreed...

//David

