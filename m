Return-path: <linux-media-owner@vger.kernel.org>
Received: from joan.kewl.org ([212.161.35.248]:45111 "EHLO joan.kewl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753061AbZA0OL3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Jan 2009 09:11:29 -0500
From: Darron Broad <darron@kewl.org>
To: Andy Walls <awalls@radix.net>
cc: linux-media@vger.kernel.org, Darron Broad <darron@kewl.org>,
	linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] How to use scan-s2? 
In-reply-to: <1233017978.3061.2.camel@palomino.walls.org> 
References: <497C3F0F.1040107@makhutov.org> <497C359C.5090308@okg-computer.de> <c74595dc0901250525y3771df4fhb03939c9c9c02c1f@mail.gmail.com> <Pine.LNX.4.64.0901260109400.12123@shogun.pilppa.org> <c74595dc0901260135x32f7c2bm59506de420dab978@mail.gmail.com> <Pine.LNX.4.64.0901261729280.19881@shogun.pilppa.org> <c74595dc0901260753x8b9185fu33f2a96ffbe13016@mail.gmail.com> <16900.1232991151@kewl.org> <c74595dc0901261130k6bdb6882lfb18c650cbca4abf@mail.gmail.com> <18268.1233001231@kewl.org> <c74595dc0901261231l4448f6cepfcb570557c54f60a@mail.gmail.com> <1233017978.3061.2.camel@palomino.walls.org>
Date: Tue, 27 Jan 2009 14:11:27 +0000
Message-ID: <7377.1233065487@kewl.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In message <1233017978.3061.2.camel@palomino.walls.org>, Andy Walls wrote:

LO

>On Mon, 2009-01-26 at 22:31 +0200, Alex Betis wrote:
>> 
>> On Mon, Jan 26, 2009 at 10:20 PM, Darron Broad <darron@kewl.org>
>> wrote:
>>         In message
>>         <c74595dc0901261130k6bdb6882lfb18c650cbca4abf@mail.gmail.com>,
>>         Alex
>>         Betis wrote:
>>         >
>>         >On Mon, Jan 26, 2009 at 7:32 PM, Darron Broad
>>         <darron@kewl.org> wrote:
>>         >
>>         >> In message
>>         <c74595dc0901260753x8b9185fu33f2a96ffbe13016@mail.gmail.com>,
>>         >> Alex Betis wrote:
>>         >>
>>         >> lo
>>         >>
>>         >> <snip>
>>         >> >
>>         >> >The bug is in S2API that doesn't return ANY error message
>>         at all :)
>
>Aside from Darron's observation, doesn't the result field of any
>particular S2API property return with a non-0 value on failure?
>
>(Sorry, I missed the original thread on the S2API return values.)

The actual tuning occurs within a thread and not when issuing
the tuning IOCTL. The only means to determine whether tuning
worked or not is inspection of the frontend events generated
within that thread. So, if the params are wrong, the IOCTL
can fail, but that's not the problem Alex is experiencing
where the params are correctly formed yet not supported in
the driver.

I did look at a means to expose supported params a while ago
but it's ugly so I haven't gone forward with it.

Bye


--

 // /
{:)==={ Darron Broad <darron@kewl.org>
 \\ \ 

