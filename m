Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f172.google.com ([209.85.216.172]:44459 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696AbaBJTpb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Feb 2014 14:45:31 -0500
Received: by mail-qc0-f172.google.com with SMTP id c9so11447238qcz.3
        for <linux-media@vger.kernel.org>; Mon, 10 Feb 2014 11:45:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52F8A2AD.8040403@imgtec.com>
References: <1391716763-2689-1-git-send-email-james.hogan@imgtec.com>
	<CAKv9HNYxY0isLt+uZvDZJJ=PX0SF93RsFeS6PsRMMk5gqtu8kQ@mail.gmail.com>
	<52F8A2AD.8040403@imgtec.com>
Date: Mon, 10 Feb 2014 21:45:30 +0200
Message-ID: <CAKv9HNYobfHS=BhxR6Wya=jB3fAR3bvRFfmkQJt9R7hB0PSwPg@mail.gmail.com>
Subject: Re: [RFC 0/4] rc: ir-raw: Add encode, implement NEC encode
From: =?ISO-8859-1?Q?Antti_Sepp=E4l=E4?= <a.seppala@gmail.com>
To: James Hogan <james.hogan@imgtec.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10 February 2014 11:58, James Hogan <james.hogan@imgtec.com> wrote:
> Hi Antti,
>
> On 08/02/14 11:30, Antti Seppälä wrote:
>>> The first patch adds an encode callback to the existing raw ir handler
>>> struct and a helper function to encode a scancode for a given protocol.
>>>
>>
>> The mechanism used here to encode works fine as long as there is only
>> one protocol selected. If there are several which all support encoding
>> then there's no easy way to tell which one will be used to do the
>> actual encoding.
>
> True, I suppose it needs a wakeup_protocol sysfs file for that really (I
> can't imagine a need or method to wake on multiple protocols, a
> demodulating hardware decoder like img-ir can only have one set of
> timings at a time, and a raw hardware decoder like nuvoton would seem
> unlikely to have multiple wake match buffers - and if it did the sysfs
> interface would probably need extending to take multiple
> single-protocol/filter sets anyway).
>
> This should probably be done prior to the new sysfs interface reaching
> mainline, so that userland can always be expected to write the protocol
> prior to the wakeup filter (rather than userland expecting the wake
> protocol to follow the current protocol).
>

I agree. I think the new sysfs file could pretty much use the existing
show/store_protocols() with the modification that only one protocol
can be active at a time.

>>> Finally for debug purposes patch 4 modifies img-ir-raw to loop back the
>>> encoded data when a filter is altered. Should be pretty easy to apply
>>> similarly to any raw ir driver to try it out.
>>>
>>
>> I believe we have rc-loopback driver for exactly this purpose. Could
>> you use it instead? Also adding the scancode filter to it would
>> demonstrate its usage.
>
> True I could have done, I used img-ir simply out of convenience and
> familiarity :). Would it make sense to generate an input event when
> setting the filter though, or perhaps since the whole point of the
> loopback driver is presumably debug it doesn't matter?
>

Well the purpose of rc-loopback is to provide means to write scripts
for debugging and the driver already loops tx back to rx. I just
thought that it would fit nicely to loop the encoded filter back as
well. It doesn't really matter though. Maybe some printk of the ir
samples will also suffice.

> To actually add filtering support to loopback would require either:
> * raw-decoder/rc-core level scancode filtering for raw ir drivers
> * OR loopback driver to encode like nuvoton and fuzzy match the IR signals.
>

Rc-core level scancode filtering shouldn't be too hard to do right? If
such would exist then it would provide a software fallback to other rc
devices where hardware filtering isn't available. I'd love to see the
sysfs filter and filter_mask files to have an effect on my nuvoton too
:)

But maybe we'll first need to try to get the wakeup finished.

-Antti
