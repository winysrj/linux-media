Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:36235 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750765AbbDBLh7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Apr 2015 07:37:59 -0400
Date: Thu, 2 Apr 2015 13:37:26 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Sean Young <sean@mess.org>, linux-media@vger.kernel.org
Subject: Re: [RFC PATCH 0/6] Send and receive decoded IR using lirc interface
Message-ID: <20150402113726.GA8662@hardeman.nu>
References: <cover.1426801061.git.sean@mess.org>
 <20150330211819.GA18426@hardeman.nu>
 <20150331204716.6795177d@concha.lan>
 <20150401221941.GC4721@hardeman.nu>
 <20150401201016.616fca34@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20150401201016.616fca34@recife.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Apr 01, 2015 at 08:10:16PM -0300, Mauro Carvalho Chehab wrote:
>Em Thu, 02 Apr 2015 00:19:41 +0200
>David Härdeman <david@hardeman.nu> escreveu:
>> On Tue, Mar 31, 2015 at 08:47:16PM -0300, Mauro Carvalho Chehab wrote:
>> >Em Mon, 30 Mar 2015 23:18:19 +0200
>> >David Härdeman <david@hardeman.nu> escreveu:
>> >> On Thu, Mar 19, 2015 at 09:50:11PM +0000, Sean Young wrote:
>> >> Second, if we expose protocol type (which we should, not doing so is
>> >> throwing away valuable information) we should tackle the NEC scancode
>> >> question. I've already explained my firm conviction that always
>> >> reporting NEC as a 32 bit scancode is the only sane thing to do. Mauro
>> >> is of the opinion that NEC16/24/32 should be essentially different
>> >> protocols.
>> >
>> >Changing NEC would break userspace, as existing tables won't work.
>> >So, no matter what I think, changing it won't happen as we're not
>> >allowed to break userspace.
>> 
>> I have no idea what breakage you're talking about. Sean's patches would
>> introduce new API, so they can't break anything. 
>
>Sure, but changing RX would break, and using 32 bits just for TX,
>while keeping 16/24/32 for RX would be too messy.

Well...why would RX "break"?

I'm still not sure what you're referring to when you mention RX, the
only thing I can think of is keytables...

>> My patch series also
>> introduced a new API for setting/getting keytable entries (with
>> heuristics for the old ways to convert NEC scancodes on the fly) so it
>> should (hopefully) not break anything.
>
>I sent a review of your patch series a long time ago. Didn't receive
>any answer to my review from you yet. Yet, let's not mix the subjects.
>If you want to discuss that, please reply to the old thread and submit
>your work on small chunks, after the approach is agreed.

The old thread suggested I should start an RFC round for the new rc
device. The new API for setting/getting keytable entries with explicit
protocol information is orthogonal to that. I'll re-post those two
patches shortly so we have something tangible to discuss.

>> >(and yes, I think NEC16 is *the* NEC protocol; the other are just
>> >variants made by some vendors to fill their needs)

Oh, and I forgot to add. I've used NEC branded remote controls which
were not using NEC16 (IIRC, they used NEC24).

>> We are talking about the protocol used to communicate what has been
>> received/should be sent between userspace and the kernel. Simply passing
>> the 32 bits that have been sent/received is the simplest, most
>> straightfoward way to go.
>
>Yes, it would be simpler. That doesn't mean that it is technically
>correct. Yet, you could argue that passing 48 bits would be even
>simpler, due to NEC/48 (or 64 bits, if one would ever propose a
>nec-64 variant).

That's a strawman...a different transmission length calls for a separate
protocol id, otherwise you don't know what has been received (was it
0x0004, 0x000004, 0x00000004, etc...)

>Ok, NEC/16/24/32 always send 32 bits at the same way, while other
>"longer" variants would actually change the payload size, while
>16/24/32 is just a change of the bytes meaning at the payload.
>Yet, they're different.

In much the same way as private or public IP addresses are "different",
yet any sane API just reports the 32 bit address and lets the userspace
application worry about how it should be presented.

>> >> Third, we should still have a way to represent the protocol in the
>> >> keymap as well.
>> >
>> >Not sure about that, but this is a different matter. 
>> 
>> Yes, it's a different matter. And what is there to be unsure about? Not
>> having the protocol as part of the keymap means throwing away
>> information...
>
>The internal representation at kernelspace can always be changed.
>
>If you're instead referring to some specific problem with the userspace
>to kernelspace TX API, then please point to the specific patch for the
>actual implementation, instead of discussing it in an abstract way.

I'll post two patches. Let's discuss them.


-- 
David Härdeman
