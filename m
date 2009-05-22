Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f174.google.com ([209.85.218.174]:34248 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013AbZEVSRd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 May 2009 14:17:33 -0400
Received: by bwz22 with SMTP id 22so1787803bwz.37
        for <linux-media@vger.kernel.org>; Fri, 22 May 2009 11:17:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <54918.82.95.219.165.1243015328.squirrel@webmail.xs4all.nl>
References: <54918.82.95.219.165.1243015328.squirrel@webmail.xs4all.nl>
Date: Fri, 22 May 2009 22:12:07 +0400
Message-ID: <1a297b360905221112h107f80ceu585bfb7495ffb0e7@mail.gmail.com>
Subject: Re: [linux-dvb] Most stable DVB-S2 PCI Card?
From: Manu Abraham <abraham.manu@gmail.com>
To: n.wagenaar@xs4all.nl
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, May 22, 2009 at 10:02 PM, Niels Wagenaar <n.wagenaar@xs4all.nl> wrote:
> Op Vr, 22 mei, 2009 19:48, schreef Manu Abraham:
>> On Fri, May 22, 2009 at 9:32 PM, Niels Wagenaar <n.wagenaar@xs4all.nl>
>> wrote:
>>> Op Vr, 22 mei, 2009 19:23, schreef Bob Ingraham:
>>>> Hello,
>>>>
>>>> What is the most stable DVB-S2 PCI card?
>>>>
>>>> -- SNIP --
>>>
>>> In short, the Hauppauge NOVA-HD-S2 is the one to buy. Yes, it's somewhat
>>> more expensive but it's the best DVB-S2 based PCI card concerning
>>> stability and usability with for example VDR.
>>
>>
>> Unfortunately, the Nova HD-S2 won't support any DVB-S2 stream with
>> symbol rates > 30 MSPS, also it supports only DVB-S2 NBC mode
>> of operation, being based on an older generation demodulator.
>>
>
> Well, I was talking about my experience. And currently I haven't found any
> channels which have problems which I can receive (Hotbird 13.0, Astra
> 19.2, Astra 23.5 and Astra 28.2).
>
> But perhaps other sats may have problems with the items your described.


Some people have been asking on those items earlier on the lists. I don't
remember the exact transponders nor the sats, but you can easily find those
mails on the list itself. The DVB-S2 specification is very much a big
specification
indeed. There aren't many demodulators that do comply. And those 2nd
generation demodulators are on PCIe cards alone, rather than PCI cards.

The TT S2-1600 is the only  "PCI" card that i am aware of currently, which
complies to all of those later additions.
