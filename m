Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8MN6a1b012917
	for <video4linux-list@redhat.com>; Mon, 22 Sep 2008 19:06:37 -0400
Received: from anchor-post-31.mail.demon.net (anchor-post-31.mail.demon.net
	[194.217.242.89])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8MN6O2j006490
	for <video4linux-list@redhat.com>; Mon, 22 Sep 2008 19:06:24 -0400
Received: from youmustbejoking.demon.co.uk ([80.176.152.238]
	helo=pentagram.youmustbejoking.demon.co.uk)
	by anchor-post-31.mail.demon.net with esmtp (Exim 4.67)
	id 1KhuU3-000Jzi-6F
	for video4linux-list@redhat.com; Mon, 22 Sep 2008 23:06:24 +0000
Received: from [192.168.0.5] (helo=flibble.youmustbejoking.demon.co.uk)
	by pentagram.youmustbejoking.demon.co.uk with esmtp (Exim 4.63)
	(envelope-from <linux@youmustbejoking.demon.co.uk>)
	id 1KhuTy-00084b-Jw
	for video4linux-list@redhat.com; Tue, 23 Sep 2008 00:06:23 +0100
Date: Tue, 23 Sep 2008 00:03:58 +0100
From: Darren Salt <linux@youmustbejoking.demon.co.uk>
To: video4linux-list@redhat.com
Message-ID: <4FE875D928%linux@youmustbejoking.demon.co.uk>
In-Reply-To: <48D7331F.60305@curtronics.com>
References: <48D32F0E.1000903@curtronics.com>
	<200809190435.17646.vanessaezekowitz@gmail.com>
	<48D3B730.9060204@curtronics.com> <48D58708.9040808@curtronics.com>
	<4FE7B8D544%linux@youmustbejoking.demon.co.uk>
	<48D7331F.60305@curtronics.com>
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

> Darren Salt wrote:
>> I demand that Curt Blank may or may not have written...
>> [snip]
>>> When I run kaffeine I get a pop up window with this:
>>> No plugin found to handle this resource (/dev/video)
>> You need to prefix that with "v4l:/".
>> [snip]

> That doesn't seen to help, still get a pop up window with "No plugin found
> to handle this resource (v4l:/dev/video)"
[snip]

More information needed. Run it from an X terminal and in verbose mode (might
be -v, might be --verbose, might be something else; check the docs) and see
what output it produces.

-- 
| Darren Salt    | linux or ds at              | nr. Ashington, | Toon
| RISC OS, Linux | youmustbejoking,demon,co,uk | Northumberland | Army
| + Use more efficient products. Use less.          BE MORE ENERGY EFFICIENT.

Don't stop now, we might just as well lock the door and throw away the key.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
