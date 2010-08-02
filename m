Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:42017 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137Ab0HBRNY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Aug 2010 13:13:24 -0400
MIME-Version: 1.0
In-Reply-To: <BU4OxfMZjFB@christoph>
References: <AANLkTi=F4CQ2_pCDno1SNGS6w=7wERk1FwjezkwC=nS5@mail.gmail.com>
	<BU4OxfMZjFB@christoph>
Date: Mon, 2 Aug 2010 13:13:22 -0400
Message-ID: <AANLkTimXULCDLw6=kcFC2Kddbm4kuO4nqtXL6ozftMQj@mail.gmail.com>
Subject: Re: Remote that breaks current system
From: Jon Smirl <jonsmirl@gmail.com>
To: Christoph Bartelmus <lirc@bartelmus.de>,
	Jarod Wilson <jarod@wilsonet.com>
Cc: awalls@md.metrocast.net, jarod@redhat.com,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org,
	lirc-list@lists.sourceforge.net, mchehab@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Aug 2, 2010 at 12:42 PM, Christoph Bartelmus <lirc@bartelmus.de> wrote:
> Hi!
>
> Jon Smirl "jonsmirl@gmail.com" wrote:
> [...]
>>> Got one. The Streamzap PC Remote. Its 14-bit RC5. Can't get it to properly
>>> decode in-kernel for the life of me. I got lirc_streamzap 99% of the way
>>> ported over the weekend, but this remote just won't decode correctly w/the
>>> in-kernel RC5 decoder.
>
>> Manchester encoding may need a decoder that waits to get 2-3 edge
>> changes before deciding what the first bit. As you decode the output
>> is always a couple bits behind the current input data.
>>
>> You can build of a table of states
>> L0 S1 S0 L1  - emit a 1, move forward an edge
>> S0 S1 L0 L1 - emit a 0, move forward an edge
>>
>> By doing it that way you don't have to initially figure out the bit clock.
>>
>> The current decoder code may not be properly tracking the leading
>> zero. In Manchester encoding it is illegal for a bit to be 11 or 00.
>> They have to be 01 or 10. If you get a 11 or 00 bit, your decoding is
>> off by 1/2 a bit cycle.
>>
>> Did you note the comment that Extended RC-5 has only a single start
>> bit instead of two?
>
> It has nothing to do with start bits.
> The Streamzap remote just sends 14 (sic!) bits instead of 13.
> The decoder expects 13 bits.
> Yes, the Streamzap remote does _not_ use standard RC-5.
> Did I mention this already? Yes. ;-)

If the remote is sending a weird protocol then there are several choices:
  1) implement raw mode
  2) make a Stream-Zap protocol engine (it would be a 14b version of
RC-5). Standard RC5 engine will still reject the messages.
  3) throw away your Stream-Zap remotes

I'd vote for #3, but #2 will probably make people happier.


>
> Christoph
>



-- 
Jon Smirl
jonsmirl@gmail.com
