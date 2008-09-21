Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8LChUKX007819
	for <video4linux-list@redhat.com>; Sun, 21 Sep 2008 08:43:31 -0400
Received: from anchor-post-37.mail.demon.net (anchor-post-37.mail.demon.net
	[194.217.242.87])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8LChGre023105
	for <video4linux-list@redhat.com>; Sun, 21 Sep 2008 08:43:17 -0400
Received: from youmustbejoking.demon.co.uk ([80.176.152.238]
	helo=pentagram.youmustbejoking.demon.co.uk)
	by anchor-post-37.mail.demon.net with esmtp (Exim 4.69)
	id 1KhOHU-0002ek-ND
	for video4linux-list@redhat.com; Sun, 21 Sep 2008 12:43:16 +0000
Received: from [192.168.0.5] (helo=flibble.youmustbejoking.demon.co.uk)
	by pentagram.youmustbejoking.demon.co.uk with esmtp (Exim 4.63)
	(envelope-from <linux@youmustbejoking.demon.co.uk>)
	id 1KhOHN-0005EE-B1
	for video4linux-list@redhat.com; Sun, 21 Sep 2008 13:43:14 +0100
Date: Sun, 21 Sep 2008 13:39:25 +0100
From: Darren Salt <linux@youmustbejoking.demon.co.uk>
To: video4linux-list@redhat.com
Message-ID: <4FE7B8D544%linux@youmustbejoking.demon.co.uk>
In-Reply-To: <48D58708.9040808@curtronics.com>
References: <48D32F0E.1000903@curtronics.com>
	<200809190435.17646.vanessaezekowitz@gmail.com>
	<48D3B730.9060204@curtronics.com> <48D58708.9040808@curtronics.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Subject: Re: Kworld PlusTV HD PCI 120 (ATSC 120)
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

I demand that Curt Blank may or may not have written...

[snip]
> When I run kaffeine I get a pop up window with this:

> No plugin found to handle this resource (/dev/video)

You need to prefix that with "v4l:/".

[snip]
-- 
| Darren Salt    | linux or ds at              | nr. Ashington, | Toon
| RISC OS, Linux | youmustbejoking,demon,co,uk | Northumberland | Army
| + Output less CO2 => avoid massive flooding.    TIME IS RUNNING OUT *FAST*.

"I just criticise other people's patches." - Linus Torvalds, lkml

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
