Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m13IH8ki003979
	for <video4linux-list@redhat.com>; Sun, 3 Feb 2008 13:17:08 -0500
Received: from anchor-post-31.mail.demon.net (anchor-post-31.mail.demon.net
	[194.217.242.89])
	by mx3.redhat.com (8.13.1/8.13.1) with ESMTP id m13IGcHN017727
	for <video4linux-list@redhat.com>; Sun, 3 Feb 2008 13:16:38 -0500
Received: from youmustbejoking.demon.co.uk ([80.176.152.238]
	helo=pentagram.youmustbejoking.demon.co.uk)
	by anchor-post-31.mail.demon.net with esmtp (Exim 4.67)
	id 1JLjOP-000PVV-5t
	for video4linux-list@redhat.com; Sun, 03 Feb 2008 18:16:37 +0000
Received: from [192.168.0.5] (helo=flibble.youmustbejoking.demon.co.uk)
	by pentagram.youmustbejoking.demon.co.uk with esmtp (Exim 4.63)
	(envelope-from <linux@youmustbejoking.demon.co.uk>)
	id 1JLjOL-00065g-Gr
	for video4linux-list@redhat.com; Sun, 03 Feb 2008 18:16:37 +0000
Date: Sun, 03 Feb 2008 18:06:42 +0000
From: Darren Salt <linux@youmustbejoking.demon.co.uk>
To: video4linux-list@redhat.com
Message-ID: <4F70E0B1F8%linux@youmustbejoking.demon.co.uk>
In-Reply-To: <200802031035.20278.tobias.lorenz@gmx.net>
References: <200802021620.15038.tobias.lorenz@gmx.net>
	<200802021657.35685.tobias.lorenz@gmx.net>
	<4F7055831C%linux@youmustbejoking.demon.co.uk>
	<200802031035.20278.tobias.lorenz@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Subject: Re: [PATCH] Trivial printf warning fix (radio-si470)
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

I demand that Tobias Lorenz may or may not have written...

>> If that's right, can you explain why the warning which I saw mentioned
>> "long unsigned int"...?

[snip]
> Is guess your amd64 is a ia64 architecture.

No, it's amd64 (a.k.a. x86_64).

> Therefore ssize_t should be a long int on your machine.

ssize_t, yes (actually, signed long int, not that there's any difference).
But sizeof() returns size_t.

[snip]
-- 
| Darren Salt    | linux or ds at              | nr. Ashington, | Toon
| RISC OS, Linux | youmustbejoking,demon,co,uk | Northumberland | Army
| + At least 4000 million too many people. POPULATION LEVEL IS UNSUSTAINABLE.

A project not worth doing at all is not worth doing well.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
