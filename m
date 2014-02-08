Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f53.google.com ([209.85.216.53]:63889 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312AbaBHLaC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Feb 2014 06:30:02 -0500
Received: by mail-qa0-f53.google.com with SMTP id cm18so6865917qab.40
        for <linux-media@vger.kernel.org>; Sat, 08 Feb 2014 03:30:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1391716763-2689-1-git-send-email-james.hogan@imgtec.com>
References: <1391716763-2689-1-git-send-email-james.hogan@imgtec.com>
Date: Sat, 8 Feb 2014 13:30:01 +0200
Message-ID: <CAKv9HNYxY0isLt+uZvDZJJ=PX0SF93RsFeS6PsRMMk5gqtu8kQ@mail.gmail.com>
Subject: Re: [RFC 0/4] rc: ir-raw: Add encode, implement NEC encode
From: =?ISO-8859-1?Q?Antti_Sepp=E4l=E4?= <a.seppala@gmail.com>
To: James Hogan <james.hogan@imgtec.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 6 February 2014 21:59, James Hogan <james.hogan@imgtec.com> wrote:
> A recent discussion about proposed interfaces for setting up the
> hardware wakeup filter lead to the conclusion that it could help to have
> the generic capability to encode and modulate scancodes into raw IR
> events so that drivers for hardware with a low level wake filter (on the
> level of pulse/space durations) can still easily implement the higher
> level scancode interface that is proposed.
>
> This patchset is just a quick experiment to suggest how it might work.
> I'm not familiar with the hardware that could use it so it could well be
> a bit misdesigned in places (e.g. what sort of buffer length would the
> hardware have, do we need to support any kind of partial encoding, can
> the hardware/driver easily take care of allowing for a margin of
> error?).
>

Hi James.

Thank you for your patchset. I think it is a good start towards an
interface for encoding scancodes back to ir pulses.

First some elaboration to what support is needed regarding nuvoton:

The buffer length is 67 pulses or spaces. At current sampling rate
maximum length of each individual pulse/space is 6350usec. However if
longer consecutive pulses occur they can be split to multiple smaller
values to represent the original long value. Ir-core can just leave
splitting values to the driver.

Due to the 67 pulse/space limitation I'd say that support for partial
encoding would be needed. Now it is difficult for driver to allocate
enough memory for some of the chattier protocols.

The nuvoton hardware has a special register for setting accepted
margin of error (cmp_tolerance). This is the delta within which each
pulse/space length is still considered a match. So for nuvoton the
margin of error does not need to be worried about.

>
> The first patch adds an encode callback to the existing raw ir handler
> struct and a helper function to encode a scancode for a given protocol.
>

The mechanism used here to encode works fine as long as there is only
one protocol selected. If there are several which all support encoding
then there's no easy way to tell which one will be used to do the
actual encoding.

> The third patch implements encode for NEC. The modulation is abstracted
> to use functions in patch 2 (pulse-distance is used by multiple
> protocols).
>
> Finally for debug purposes patch 4 modifies img-ir-raw to loop back the
> encoded data when a filter is altered. Should be pretty easy to apply
> similarly to any raw ir driver to try it out.
>

I believe we have rc-loopback driver for exactly this purpose. Could
you use it instead? Also adding the scancode filter to it would
demonstrate its usage.

One other thing I noticed while reviewing your patches was that
currently the dev->s_filter callback return value is ignored by
store_filter. It would be useful to return an error to userspace if
scancode storage was not possible for whatever reason.


Nevertheless I decided to use this patchset as a basis and write a
generic rc-5 encoder and use it to support streamzap protocol in
nuvoton. I'll post my patchset shortly for review / discussion.

-Antti
