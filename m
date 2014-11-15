Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:51578 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675AbaKOHdc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Nov 2014 02:33:32 -0500
Received: by mail-pd0-f179.google.com with SMTP id g10so18168095pdj.38
        for <linux-media@vger.kernel.org>; Fri, 14 Nov 2014 23:33:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <m3wq6xpivf.fsf@t19.piap.pl>
References: <m3lhneez9h.fsf@t19.piap.pl>
	<CANZNk82C9SmBXx4T=CxRjLGOZPuRdahwF4mXYUk8pJ427vdCPQ@mail.gmail.com>
	<m3wq6xpivf.fsf@t19.piap.pl>
Date: Sat, 15 Nov 2014 11:33:31 +0400
Message-ID: <CANZNk82OVwQP3aZO3uherp3jcL1LYyF8z9Lx2hzZr-FccODhdQ@mail.gmail.com>
Subject: Re: SOLO6x10: fix a race in IRQ handler.
From: Andrey Utkin <andrey.krieger.utkin@gmail.com>
To: =?ISO-8859-2?Q?Krzysztof_Ha=B3asa?= <khalasa@piap.pl>
Cc: Linux Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2014-11-15 1:33 GMT+04:00 Krzysztof Hałasa <khalasa@piap.pl>:
> The SOLO IRQ controller does the common thing, all drivers (for chips
> using the relatively modern "write 1 to clear") have to follow this
> sequence: first ACK the interrupts sources (so they are deasserted,
> though they can be asserted again if new events arrive), and only then
> service the chip.

Thanks for explanation.

> I think my patch does exactly this, merges both writes.

Ah right, sorry.

-- 
Andrey Utkin
