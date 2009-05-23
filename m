Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f174.google.com ([209.85.218.174]:40800 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509AbZEWKEM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 May 2009 06:04:12 -0400
Received: by bwz22 with SMTP id 22so2075525bwz.37
        for <linux-media@vger.kernel.org>; Sat, 23 May 2009 03:04:11 -0700 (PDT)
Message-ID: <4A17C9F7.8050800@gmail.com>
Date: Sat, 23 May 2009 12:03:35 +0200
From: David Lister <foceni@gmail.com>
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
CC: Goga777 <goga777@bk.ru>, linux-media@vger.kernel.org
Subject: Re: [linux-dvb] Most stable DVB-S2 PCI Card?
References: <53876.82.95.219.165.1243013567.squirrel@webmail.xs4all.nl>	 <1a297b360905221048p5a7c548anbdef992b5a1a697d@mail.gmail.com>	 <20090522234201.4ee5cf47@bk.ru>	 <1a297b360905221325r46432d02g8a97b1361e7958ac@mail.gmail.com>	 <4A171985.3090205@gmail.com>	 <1a297b360905221438n7dfb55a9uec1f1ce119bd8d74@mail.gmail.com>	 <4A178ED3.5050806@gmail.com> <1a297b360905222337r1b65bbe7n65578d1991348b9@mail.gmail.com>
In-Reply-To: <1a297b360905222337r1b65bbe7n65578d1991348b9@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Manu Abraham wrote:
> On Sat, May 23, 2009 at 9:51 AM, David Lister <foceni@gmail.com> wrote:
>   
>> This point is moot in the first place, mate. Especially in USA (original
>> poster), where it'll take twice the time to reach those rates on DVB-S2.
>> All current 45 MS/s transponders are QPSK, at least as far as I can
>> tell. Even if that "technology preview" 8PSK transponder of yours
>> existed (somewhere above Asia), it's hardly a reason to buy
>> Linux-unstable cards in EU or USA.
>>     
> Have you tried the card, to state that it is unstable ? I would like
> to know the basis
> for your comments to state that it is unstable.
>   

I was not talking specifically about TT-1600, but with your drivers
being relatively young, not in wide use, and you being the only
developer (right?), it's common sense to assume that they are not as
stable as e.g. cx88. Also considering the fact that none of these
drivers even report signal stats properly. Then, of course, there's my
recent experience with your SkyStar HD2 driver. :) You have to
understand that me, in this case just a common user, do not wish to
invest into a product with an unfinished driver. If it was for me, I
wouldn't really care, but with the whole family using the HTPC...

I didn't want to write a long mail, but here goes:

The TechnoTrend company, as of Februay 2009, doesn't exists any more.
*It is bankrupt*. First, its owner Novabase sold as many of its shares
as it could in 2007, in hope that the proceeds would allow TechnoTrend
to get back on track. No such luck. A few months back this year, the
company was finally dumped and sold as a whole to some German telco
company in the Kathrein Group for liquidation, because of the tremendous
drop in it's market value and forthcoming bankruptcy. This might also be
of some interest to prospective buyers of it's former products. :) I
don't want to search for all the press releases, but you can verify this
claim here:
http://www.euronext.com/fic/000/044/480/444806.pdf

Nevertheless, I tried to get the data-sheet for this dead product from
their closed down & discontinued sites. Google cache is a great thing, I
managed to find TechnoTrend's S2-1600 data-sheet PDF:
http://www.pt.technotrend.com/Dokumente/87/Manuals_PC/specs_eng/TechSpec_S2-1600_engl.pdf

As much as I'd like to believe your "S2-1600 supports 63 MS/s", I cannot
ignore the fact that the manufacturer disagrees with you:
DVB-S: 2 - 45 MS/s
DVB-S2: 10 - 30 MS/s

Pretty standard specs, if you ask me. Obviously, you must have proven
the *manufacturer* wrong by verifying your claim in practice. I just
wonder how you did it, when no existing DVB-S2 transponder uses rates
over 30 MS/s. Wasn't it perhaps just some "dry" testing without any
signal, like gradually raising the HW parameters and sniffing for smoke? :)

That's all I had to say. I know that the TT bankruptcy thing is
irrelevant in a technical discussion, but it is important nonetheless. I
wouldn't recommend TT products, nor SkyStar HD2, which is kinda infamous
on some EU sat forums (not only in connection with Linux).


See you around,
-- 
Dave
