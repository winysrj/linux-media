Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m79L4Y7W021046
	for <video4linux-list@redhat.com>; Sat, 9 Aug 2008 17:04:34 -0400
Received: from lxorguk.ukuu.org.uk (earthlight.etchedpixels.co.uk
	[81.2.110.250])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m79L4O7V000511
	for <video4linux-list@redhat.com>; Sat, 9 Aug 2008 17:04:24 -0400
Date: Sat, 9 Aug 2008 21:46:57 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Rene Herman <rene.herman@keyaccess.nl>
Message-ID: <20080809214657.3b5318d1@lxorguk.ukuu.org.uk>
In-Reply-To: <489DE890.1090103@keyaccess.nl>
References: <489DE890.1090103@keyaccess.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
	video4linux-list@redhat.com, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] V4L1: make PMS not auto-grab port 0x250
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

I have a PMS card. It was the hot technology of 199x about the same time
as doom came out. I'm probably the only person who still has one ;)

I'm going to NAK this however because passing in a port is a really dumb
interface. The PMS card can only be at port 0x250 so if you load it there
is no doubt and confusion involved.

The code is fine, the behaviour is correct. Ingo should fix his config
stuff.

Just apply a tiny bit of rational thought here. There is exactly ONE
Ingo. He's a smart cookie and can add exception lists to his tester.
There are millions of users some of whom are brilliant, others are not
computer wizards. The code should be optimised for them not for Ingo -
Ingo is an optimisation for the special case not the normal workload!

Alan

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
