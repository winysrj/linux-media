Return-path: <linux-media-owner@vger.kernel.org>
Received: from seiner.com ([66.178.130.209]:33927 "EHLO www.seiner.lan"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932314Ab1LEP2q (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Dec 2011 10:28:46 -0500
Message-ID: <c0667c34eccf470314966c2426b00af4.squirrel@mail.seiner.com>
In-Reply-To: <1098bb19-5241-4be4-a916-657c0b599efd@email.android.com>
References: <4EDC25F1.4000909@seiner.com>
    <1323058527.12343.3.camel@palomino.walls.org>
    <4EDC4C84.2030904@seiner.com> <4EDC4E9B.40301@seiner.com>
    <4EDCB6D1.1060508@seiner.com>
    <1098bb19-5241-4be4-a916-657c0b599efd@email.android.com>
Date: Mon, 5 Dec 2011 07:28:46 -0800 (PST)
Subject: Re: cx231xx kernel oops
From: "Yan Seiner" <yan@seiner.com>
To: "Andy Walls" <awalls@md.metrocast.net>
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On Mon, December 5, 2011 7:18 am, Andy Walls wrote:
> Yan Seiner <yan@seiner.com> wrote:

>>ehci_hcd 0000:00:02.2: fatal error
>>ehci_hcd 0000:00:02.2: HC died; cleaning up
>>ehci_hcd 0000:00:02.2: force halt; handshake c0350024 00004000 00004000

>
> Well, you probably have figured out you have a USB stack problem.  I'm not
> sure why a Host Controller would die and (hopefully) clean up properly,
> but that needs investigation.
>
> Looking at the oops probably won't yield useful results in terms of
> finding cx231xx bugs as it happens after the first host controller has
> bombed out.
>
> You should consider having /boot/System.map and the real klogd installed
> on your system, so the oops backtrace has meaningful symbol names as
> opposed to addresses (which are meaningless to anyone without a copy of
> your built kernel).
>
> Regards,
> Andy

At a guess, I'm going to say that it's the hardware.  This is an old
(2006?) vintage access point with limited CPU horsepower.  I'm not sure
that any further investigations would change the result.

I suspect that the hardware is not capable of USB2 speeds although it
claims it can and thus the problem.  It is rock solid with USB 1.1 devices
and barfs at USB 2.0 speeds.

-- 
Pain is temporary. It may last a minute, or an hour, or a day, or a year,
but eventually it will subside and something else will take its place. If
I quit, however, it lasts forever.

