Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f174.google.com ([209.85.218.174]:59610 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919AbZEWNaf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 May 2009 09:30:35 -0400
Received: by bwz22 with SMTP id 22so2144281bwz.37
        for <linux-media@vger.kernel.org>; Sat, 23 May 2009 06:30:35 -0700 (PDT)
Message-ID: <4A17FA58.6050900@gmail.com>
Date: Sat, 23 May 2009 15:30:00 +0200
From: David Lister <foceni@gmail.com>
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
CC: Goga777 <goga777@bk.ru>, linux-media@vger.kernel.org
Subject: Re: [linux-dvb] Most stable DVB-S2 PCI Card?
References: <53876.82.95.219.165.1243013567.squirrel@webmail.xs4all.nl>	 <1a297b360905221048p5a7c548anbdef992b5a1a697d@mail.gmail.com>	 <20090522234201.4ee5cf47@bk.ru>	 <1a297b360905221325r46432d02g8a97b1361e7958ac@mail.gmail.com>	 <4A171985.3090205@gmail.com>	 <1a297b360905221438n7dfb55a9uec1f1ce119bd8d74@mail.gmail.com>	 <4A178ED3.5050806@gmail.com>	 <1a297b360905222337r1b65bbe7n65578d1991348b9@mail.gmail.com>	 <4A17C9F7.8050800@gmail.com> <1a297b360905230339g38b420cax4dde38aeb123f2e3@mail.gmail.com>
In-Reply-To: <1a297b360905230339g38b420cax4dde38aeb123f2e3@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Manu Abraham wrote:
> LOL, As stable as CX88, you must be joking. As far as the number of
> developers on the card, if you are as capable of reading what you claim,
> you can see that from the changelogs, in the main tree itself.
>
> You mean the SAA7146 driver is young ? Hmm.. pretty ignorant comments,
> you seem to make. The 7146 is one of the oldest driver that exists.
> Exception is bttv which is still older.
>   
Indeed "LOL", as you say. I do not wish to torment you any longer. :) It
is always sad to see people switch to personal insults, when they run
out of arguments. This wasn't my intention and therefore I'm withdrawing
from this thread with my apologies for making you angry.

Some last replies: I wasn't talking about the number of developers on
cx88, was I? I was talking about your driver and you being its sole
developer; cx88 has the advantage of being proven by time as stable (in
contrast to your *new* TT-1600 support, where things like number of
developers has objective informational value). You also seem to confuse
chips (i.e. the building blocks) and complete products. Is it not true
that your first attempt at S2-1600 support was submited on April 23rd,
2009? You see for me, this is *new*.

>> Also considering the fact that none of these
>> drivers even report signal stats properly. Then, of course, there's my
>> recent experience with your SkyStar HD2 driver. :)
>>     
> Which card are you talking about ? Your experience with the Skystar HD
> driver == USER Error, that's what some people would think.
>
>   
Well, that is what *you* think, because you weren't able to explain why
it didn't work properly. There were some driver difficulties, but what
did you expect when there are at least three different branches of the
driver, all devel:

http://jusst.de/hg/mantis
http://mercurial.intuxication.org//hg//s2-liplianin
http://jusst.de/hg/mantis-v4l

I used the last driver a few hours after it was uploaded (and suggested
on the list), so don't make this a USER issue.

> The mantis driver is a driver which is very much in development. You
> should've read it on the ML's itself. It's really sad that you are pretty much
> ignorant. A driver which is in development, you expect all sorts of issues.
> That's why it is in an external tree.
>   
Oh, but I've read the list before buying the card, just like I've done
for over 10 years for all HW for my Linux setups. Plus the reference
information on the linuxtv.org says the driver is in development for
over 3 years. When you see people discussing just lame & minor details
on the lists and when there's a 3yr old driver, you usually expect no
problems (not many anyway). But this is not my issue - please understand
that I'm not complaining at all, this is just a reply to your previous
statement. It is OT in this argument.

> Now, you managed to get hold of the wrong tree, burned your demodulator,
> inspite of me warning users on the ML's many times. So you are still
> ignorant on that. You decided to do, what it pleased you. Not my fault.
>   
As I wrote above, s2-liplianin was the latest tree available for general
public at the time. My only other option was multiproto. I used
mantis-v4l tree even before it was completely uploaded.

As soon as the new S2API mantis tree was mentioned on the list, I used
it. But most importantly, your only explanation that it still doesn't
work, because I burned my demodulator using the current s2-liplianin
tree is *absolutely* ridiculous. You might work it out with Liplianin
himself, but if you had read my followup, you would know that I
exchanged the card for new samples, had those samples *verified* by
TechniSat (your second and last explanation was that my HW is fake, LOL)
and I used *only* your latest driver. Of course it demonstrated the same
exact issues as previous "burned" (haha) cards.


> I guess, you don't understand the term "Development", "Stable" etc either.
>   
I did not expect everything rosy, I have my share of Linux HW
experiences. I've also written a complete Linux driver for a device I
had, which wasn't supported - that driver is now part of the kernel. So
believe me, not only I know how open source development works, I even
know how kernel driver development works. What I did not expect was
almost total ignorance of my issues by the driver author himself. One
would expect at least some cooperation, I know how hard it is to find
testers of one's code. You offered two explanations why your devel
driver didn't work: the HW is broken or fake. Nice!

In the end, I didn't return the cards because of the driver. I could
live without PWR, SNR monitoring and unstable locks. I gave up, because
even when everything worked, there were two major HW problems (caused by
driver):
1) Card's HW emitted high pitched noise (like old TV's, but louder) as
soon as I got DVB-S2 lock (mantis-v4l)
2) All DVB-S/S2 channels were corrupted, the picture looked as if there
was a weak signal (STB reports 95%!). Intolerable.

Yet, cx88 card on the exact same setup works with no issues rock solid.
The issues were not HW-related after all, when I returned the cards, the
shop had them tested (on Windows I guess) and they worked perfectly. If
you asked me to help you debug or test it, you might fix a big fuck up
in your driver. Could be a newer card revision or whatever.

Well, what do I care, my HTPC is finished and flawless. :)


> The TT S2-1600 support is much different, support for it exist in the mainline
> tree, which is verified. The SAA7146 bridge which the S2-1600 is based on,
> is the most mature PCI multimedia bridge that exists under Linux.
>   
Again the chipset & complete product mixup. Your initial S2-1600 patch
from April 23rd, 2009:
http://www.mail-archive.com/linuxtv-commits@linuxtv.org/msg03924.html

Don't forget we are still talking about recommendation for the most
stable card requested by the OP. This whole discussion happened, because
you were unable to accept that one cannot compare support this young
with what cx88 offers.

> I don't work for Technotrend, neither have i till now. My opinions are my own.
> I don't care about your completely non-technical or trolling posts. Whether
> Technotrend is having a new ownership/management is as well nothing of
> concern to me.
>   
1) I honestly don't know who you work for and I promise I do not care
2) We are not talking about a change of ownership like in the past, but
a complete company liquidation
3) The first trolling in this thread was your latest email. If we are
talking about technical discussions, don't forget that it was you who
brought up personal stuff. All my contributions were directly related to
OP's question, S2-1600 technical specs and driver stability issues.

> There seems to be people buying the"dead product" that you claim and hence the
> support for it is in.
> It's not a card manufacturer that do make the chip specifications.
> You can look at the STV0903 specification, or the announcement that i
> made earlier on the list about the same.
>   
Of course people buy stuff that is on the market; however, that doesn't
mean it is being actively developed or manufactured. In this case, it
isn't and it's presence on the market is limited to the number of cards
produced before the collapse of TechnoTrend.

> From the Cut 2.0 chips onwards, The STV0900/903 demodulators do support
> 45 MSPS officially and unofficially 60 MSPS with 8PSK modulation. Anything
> predating Cut 2.0 you don't find on any PC related products.
>
> http://linuxtv.org/hg/v4l-dvb/rev/4882c97b0540
>   
This is true, but do you know how the chips are integrated in TT-1600.
Final consumer product using certain chipsets usually does miss some
features or parameter ranges of the integrated chips (especially SoC
chips). Have you ever seen a PC motherboard? Well, now that you know how
I meant what I said, it is perhaps time to acknowledge that the *card*
manufacturer usually knows what their product is capable of. You know,
they being the people who actually design all the circuitry on the
PCB... I doubt TT would specify worse parameters that its product is
capable of. Especially if, as you say, they are the result of a new
technology, which would give them the edge over all the competitors. So,
TT-1600 was apparently designed to support 30 MS/s 8PSK without
stability issues or damage to the HW.


Regards,

-- 
Dave
