Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:56553 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722Ab0HBQnP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Aug 2010 12:43:15 -0400
Date: 02 Aug 2010 18:42:00 +0200
From: lirc@bartelmus.de (Christoph Bartelmus)
To: jonsmirl@gmail.com
Cc: awalls@md.metrocast.net
Cc: jarod@redhat.com
Cc: linux-input@vger.kernel.org
Cc: linux-media@vger.kernel.org
Cc: lirc-list@lists.sourceforge.net
Cc: mchehab@redhat.com
Message-ID: <BU4OxfMZjFB@christoph>
References: <AANLkTi=F4CQ2_pCDno1SNGS6w=7wERk1FwjezkwC=nS5@mail.gmail.com>
Subject: Re: Remote that breaks current system
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

Jon Smirl "jonsmirl@gmail.com" wrote:
[...]
>> Got one. The Streamzap PC Remote. Its 14-bit RC5. Can't get it to properly
>> decode in-kernel for the life of me. I got lirc_streamzap 99% of the way
>> ported over the weekend, but this remote just won't decode correctly w/the
>> in-kernel RC5 decoder.

> Manchester encoding may need a decoder that waits to get 2-3 edge
> changes before deciding what the first bit. As you decode the output
> is always a couple bits behind the current input data.
>
> You can build of a table of states
> L0 S1 S0 L1  - emit a 1, move forward an edge
> S0 S1 L0 L1 - emit a 0, move forward an edge
>
> By doing it that way you don't have to initially figure out the bit clock.
>
> The current decoder code may not be properly tracking the leading
> zero. In Manchester encoding it is illegal for a bit to be 11 or 00.
> They have to be 01 or 10. If you get a 11 or 00 bit, your decoding is
> off by 1/2 a bit cycle.
>
> Did you note the comment that Extended RC-5 has only a single start
> bit instead of two?

It has nothing to do with start bits.
The Streamzap remote just sends 14 (sic!) bits instead of 13.
The decoder expects 13 bits.
Yes, the Streamzap remote does _not_ use standard RC-5.
Did I mention this already? Yes. ;-)

Christoph
