Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f161.google.com ([209.85.218.161]:46552 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794AbZBSOko convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Feb 2009 09:40:44 -0500
Received: by bwz5 with SMTP id 5so1214599bwz.13
        for <linux-media@vger.kernel.org>; Thu, 19 Feb 2009 06:40:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1235040908.5940.0@manu-laptop>
References: <20090218092217.232120@gmx.net> <20090218103353.64bf6400@free.fr>
	 <1234961317.5755.0@manu-laptop> <20090218204455.19b867a0@free.fr>
	 <1234999838.7508.0@manu-laptop> <20090219095109.7cbe2c49@free.fr>
	 <1235040908.5940.0@manu-laptop>
Date: Thu, 19 Feb 2009 15:40:42 +0100
Message-ID: <854d46170902190640u3b39b5efw774be7b01e2044c6@mail.gmail.com>
Subject: Re: Re : Re : Re : TT 3650
From: Faruk A <fa@elwak.com>
To: Manu <eallaud@gmail.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Feb 19, 2009 at 11:55 AM, Manu <eallaud@gmail.com> wrote:
> Le 19.02.2009 04:51:09, Jean-Francois Moine a �crit :
>> On Wed, 18 Feb 2009 19:30:37 -0400
>> Manu <eallaud@gmail.com> wrote:
>>
>> > Le 18.02.2009 15:44:55, Jean-Francois Moine a �crit :
>> > > Yes. I use it to look at FTA channels on AB3 5�W:
>> > >
>> > > - France 24 (12674.00 H - DVB-S2 - QPSK) is good.
>> > >
>> > > - I can also get the transponder 11636.00 V (DVB Newtec - QPSK),
>> but
>> > > not
>> > >   the transponder 11139.00 V (DVB Newtec - 8PSK turbo)
>> > >
>> > > - For some time, there were clear channels (M6 and W9) in the
>> > >   transponder 11471.00 V (DVB-S2 - 8PSK). Both were fine.
>> >
>> > Just to make things clear, can you prodvide symbol rate and FEC for
>> > all these transponders.
>>
>> I don't understand the question!
>>
>> I think the symbol rate is mandatory, but the FEC may found
>> automatically. For example, I use vlc for the 2 different
>> transponders:
>>
>> #EXTINF:0,orange
>> #EXTVLCOPT:dvb-frequency=11512000
>> #EXTVLCOPT:dvb-srate=29947000
>> #EXTVLCOPT:dvb-voltage=13
>> dvb://
>> #EXTINF:0,france
>> #EXTVLCOPT:dvb-frequency=11590000
>> #EXTVLCOPT:dvb-srate=20000000
>> #EXTVLCOPT:dvb-voltage=13
>> dvb://
>>
>> The first transponder is FEC 7/8, and the second 2/3.
>>
>> For the other transponders (DVB-S2 / 8PSK), if use szap-s2 +
>> dvbstream.
>
> OK great thx, that's what I was asking for! Indeed I have some troubles
> locking on S2 transponders which all have 30 MS/s rate. I see that
> yours are lower, well with one very close to that.
> Bye
> Emmanuel

Hi Manu!

I use to own this card until it broke and replaced with TeVii S650.
It used to lock just fine on this Transponders. Although i can't
receive from this satellite
anymore my dish has been realigned to 16E instead.

Thor 1W
12015 H 30000-3/4
12130 H 30000-3/4

Faruk
