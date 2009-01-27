Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:39274 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751799AbZA0A7y (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Jan 2009 19:59:54 -0500
Subject: Re: [linux-dvb] How to use scan-s2?
From: Andy Walls <awalls@radix.net>
To: linux-media@vger.kernel.org
Cc: Darron Broad <darron@kewl.org>, linux-dvb@linuxtv.org
In-Reply-To: <c74595dc0901261231l4448f6cepfcb570557c54f60a@mail.gmail.com>
References: <497C3F0F.1040107@makhutov.org>
	 <497C359C.5090308@okg-computer.de>
	 <c74595dc0901250525y3771df4fhb03939c9c9c02c1f@mail.gmail.com>
	 <Pine.LNX.4.64.0901260109400.12123@shogun.pilppa.org>
	 <c74595dc0901260135x32f7c2bm59506de420dab978@mail.gmail.com>
	 <Pine.LNX.4.64.0901261729280.19881@shogun.pilppa.org>
	 <c74595dc0901260753x8b9185fu33f2a96ffbe13016@mail.gmail.com>
	 <16900.1232991151@kewl.org>
	 <c74595dc0901261130k6bdb6882lfb18c650cbca4abf@mail.gmail.com>
	 <18268.1233001231@kewl.org>
	 <c74595dc0901261231l4448f6cepfcb570557c54f60a@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 26 Jan 2009 19:59:38 -0500
Message-Id: <1233017978.3061.2.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2009-01-26 at 22:31 +0200, Alex Betis wrote:
> 
> On Mon, Jan 26, 2009 at 10:20 PM, Darron Broad <darron@kewl.org>
> wrote:
>         In message
>         <c74595dc0901261130k6bdb6882lfb18c650cbca4abf@mail.gmail.com>,
>         Alex
>         Betis wrote:
>         >
>         >On Mon, Jan 26, 2009 at 7:32 PM, Darron Broad
>         <darron@kewl.org> wrote:
>         >
>         >> In message
>         <c74595dc0901260753x8b9185fu33f2a96ffbe13016@mail.gmail.com>,
>         >> Alex Betis wrote:
>         >>
>         >> lo
>         >>
>         >> <snip>
>         >> >
>         >> >The bug is in S2API that doesn't return ANY error message
>         at all :)

Aside from Darron's observation, doesn't the result field of any
particular S2API property return with a non-0 value on failure?

(Sorry, I missed the original thread on the S2API return values.)

Regards,
Andy


