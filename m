Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f174.google.com ([209.85.218.174]:44325 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239AbZEWFvs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 May 2009 01:51:48 -0400
Received: by bwz22 with SMTP id 22so2000509bwz.37
        for <linux-media@vger.kernel.org>; Fri, 22 May 2009 22:51:48 -0700 (PDT)
Message-ID: <4A178ED3.5050806@gmail.com>
Date: Sat, 23 May 2009 07:51:15 +0200
From: David Lister <foceni@gmail.com>
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
CC: Goga777 <goga777@bk.ru>, linux-media@vger.kernel.org
Subject: Re: [linux-dvb] Most stable DVB-S2 PCI Card?
References: <53876.82.95.219.165.1243013567.squirrel@webmail.xs4all.nl>	 <1a297b360905221048p5a7c548anbdef992b5a1a697d@mail.gmail.com>	 <20090522234201.4ee5cf47@bk.ru>	 <1a297b360905221325r46432d02g8a97b1361e7958ac@mail.gmail.com>	 <4A171985.3090205@gmail.com> <1a297b360905221438n7dfb55a9uec1f1ce119bd8d74@mail.gmail.com>
In-Reply-To: <1a297b360905221438n7dfb55a9uec1f1ce119bd8d74@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Manu Abraham wrote:
> On Sat, May 23, 2009 at 1:30 AM, David Lister <foceni@gmail.com> wrote:
>   
>> Actually, there are many DVB-S2 cards supporting 45 MS/s, even TeVii S460
>> can do 2-45 MS/s. I spoke with a fellow TeVii owner, who confirmed the card
>> is working with a 45 MS/s transponder on Express AM2 without *any* issues.
>> All this aside, there aren't any transponders with higher rates than this
>> and there won't be for many years. Who knows how stable would TT even be
>> with such rates? For now, it's irrelevant anyway. I have no problem
>> upgrading to a new card in 3-4 years, providing there will be a stable,
>> fully supported card for Linux with as many satisfied owners as e.g. Nova S2
>> HD has.
>>     
>
> You are talking about a 45 MSPS DVB-S stream on a DVB-S2 demodulator,
> while i was talking about a 45 MSPS DVB-S2 stream on a DVB-S2 demodulator.
>
> Big difference !
>   

This point is moot in the first place, mate. Especially in USA (original
poster), where it'll take twice the time to reach those rates on DVB-S2.
All current 45 MS/s transponders are QPSK, at least as far as I can
tell. Even if that "technology preview" 8PSK transponder of yours
existed (somewhere above Asia), it's hardly a reason to buy
Linux-unstable cards in EU or USA. Especially considering OP's quest for
super-stable HW. HD is pretty much beginning and none of it goes over 30
MS/p. Why hurry, I ask? In 2-3 years time, when your driver is finished
and stable, we'll all happily switch to "generation 2" HW (your term),
if need be. Don't get me wrong, I have nothing against TT, it's just
more sensible to go with proven HW.

On a different note, I'm quite grateful for your development efforts and
wish you success & best of luck. If only there were more people
dedicated as you are. Seriously. Keep it up!

-- 
Dave
