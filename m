Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f168.google.com ([209.85.220.168]:53102 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050AbZEWKjP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 May 2009 06:39:15 -0400
Received: by fxm12 with SMTP id 12so320549fxm.37
        for <linux-media@vger.kernel.org>; Sat, 23 May 2009 03:39:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A17C9F7.8050800@gmail.com>
References: <53876.82.95.219.165.1243013567.squirrel@webmail.xs4all.nl>
	 <1a297b360905221048p5a7c548anbdef992b5a1a697d@mail.gmail.com>
	 <20090522234201.4ee5cf47@bk.ru>
	 <1a297b360905221325r46432d02g8a97b1361e7958ac@mail.gmail.com>
	 <4A171985.3090205@gmail.com>
	 <1a297b360905221438n7dfb55a9uec1f1ce119bd8d74@mail.gmail.com>
	 <4A178ED3.5050806@gmail.com>
	 <1a297b360905222337r1b65bbe7n65578d1991348b9@mail.gmail.com>
	 <4A17C9F7.8050800@gmail.com>
Date: Sat, 23 May 2009 14:39:09 +0400
Message-ID: <1a297b360905230339g38b420cax4dde38aeb123f2e3@mail.gmail.com>
Subject: Re: [linux-dvb] Most stable DVB-S2 PCI Card?
From: Manu Abraham <abraham.manu@gmail.com>
To: David Lister <foceni@gmail.com>
Cc: Goga777 <goga777@bk.ru>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, May 23, 2009 at 2:03 PM, David Lister <foceni@gmail.com> wrote:
> Manu Abraham wrote:
>> On Sat, May 23, 2009 at 9:51 AM, David Lister <foceni@gmail.com> wrote:
>>
>>> This point is moot in the first place, mate. Especially in USA (original
>>> poster), where it'll take twice the time to reach those rates on DVB-S2.
>>> All current 45 MS/s transponders are QPSK, at least as far as I can
>>> tell. Even if that "technology preview" 8PSK transponder of yours
>>> existed (somewhere above Asia), it's hardly a reason to buy
>>> Linux-unstable cards in EU or USA.
>>>
>> Have you tried the card, to state that it is unstable ? I would like
>> to know the basis
>> for your comments to state that it is unstable.
>>
>
> I was not talking specifically about TT-1600, but with your drivers
> being relatively young, not in wide use, and you being the only
> developer (right?), it's common sense to assume that they are not as
> stable as e.g. cx88.


LOL, As stable as CX88, you must be joking. As far as the number of
developers on the card, if you are as capable of reading what you claim,
you can see that from the changelogs, in the main tree itself.

You mean the SAA7146 driver is young ? Hmm.. pretty ignorant comments,
you seem to make. The 7146 is one of the oldest driver that exists.
Exception is bttv which is still older.



> Also considering the fact that none of these
> drivers even report signal stats properly. Then, of course, there's my
> recent experience with your SkyStar HD2 driver. :)


Which card are you talking about ? Your experience with the Skystar HD
driver == USER Error, that's what some people would think.

The mantis driver is a driver which is very much in development. You
should've read it on the ML's itself. It's really sad that you are pretty much
ignorant. A driver which is in development, you expect all sorts of issues.
That's why it is in an external tree.

Now, you managed to get hold of the wrong tree, burned your demodulator,
inspite of me warning users on the ML's many times. So you are still
ignorant on that. You decided to do, what it pleased you. Not my fault.

I guess, you don't understand the term "Development", "Stable" etc either.


The TT S2-1600 support is much different, support for it exist in the mainline
tree, which is verified. The SAA7146 bridge which the S2-1600 is based on,
is the most mature PCI multimedia bridge that exists under Linux.

Also you seem completely ignorant about how Linux development goes on.


> You have to
> understand that me, in this case just a common user, do not wish to
> invest into a product with an unfinished driver. If it was for me, I
> wouldn't really care, but with the whole family using the HTPC...
>
> I didn't want to write a long mail, but here goes:
>
> The TechnoTrend company, as of Februay 2009, doesn't exists any more.
> *It is bankrupt*. First, its owner Novabase sold as many of its shares
> as it could in 2007, in hope that the proceeds would allow TechnoTrend
> to get back on track. No such luck. A few months back this year, the
> company was finally dumped and sold as a whole to some German telco
> company in the Kathrein Group for liquidation, because of the tremendous
> drop in it's market value and forthcoming bankruptcy. This might also be
> of some interest to prospective buyers of it's former products. :) I
> don't want to search for all the press releases, but you can verify this
> claim here:
> http://www.euronext.com/fic/000/044/480/444806.pdf



I don't work for Technotrend, neither have i till now. My opinions are my own.
I don't care about your completely non-technical or trolling posts. Whether
Technotrend is having a new ownership/management is as well nothing of
concern to me.

There seems to be people buying the"dead product" that you claim and hence the
support for it is in.

> Nevertheless, I tried to get the data-sheet for this dead product from
> their closed down & discontinued sites. Google cache is a great thing, I
> managed to find TechnoTrend's S2-1600 data-sheet PDF:
> http://www.pt.technotrend.com/Dokumente/87/Manuals_PC/specs_eng/TechSpec_S2-1600_engl.pdf
>
> As much as I'd like to believe your "S2-1600 supports 63 MS/s", I cannot
> ignore the fact that the manufacturer disagrees with you:
> DVB-S: 2 - 45 MS/s
> DVB-S2: 10 - 30 MS/s



It's not a card manufacturer that do make the chip specifications.
You can look at the STV0903 specification, or the announcement that i
made earlier on the list about the same.

>From the Cut 2.0 chips onwards, The STV0900/903 demodulators do support
45 MSPS officially and unofficially 60 MSPS with 8PSK modulation. Anything
predating Cut 2.0 you don't find on any PC related products.

http://linuxtv.org/hg/v4l-dvb/rev/4882c97b0540


> Pretty standard specs, if you ask me. Obviously, you must have proven
> the *manufacturer* wrong by verifying your claim in practice. I just
> wonder how you did it, when no existing DVB-S2 transponder uses rates
> over 30 MS/s. Wasn't it perhaps just some "dry" testing without any
> signal, like gradually raising the HW parameters and sniffing for smoke? :)


I don't claim manufacturer wrong. In fact you do. You can look at the
official specs
and the support for it.


> That's all I had to say. I know that the TT bankruptcy thing is
> irrelevant in a technical discussion, but it is important nonetheless. I
> wouldn't recommend TT products, nor SkyStar HD2, which is kinda infamous
> on some EU sat forums (not only in connection with Linux).

When you are ignorant about technical aspects, you don't do a
technical discussion.
You seem to be an ignorant troll.

Cya !
