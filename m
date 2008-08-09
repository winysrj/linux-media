Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m79MCbmL006790
	for <video4linux-list@redhat.com>; Sat, 9 Aug 2008 18:12:37 -0400
Received: from lxorguk.ukuu.org.uk (earthlight.etchedpixels.co.uk
	[81.2.110.250])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m79MCQdJ026985
	for <video4linux-list@redhat.com>; Sat, 9 Aug 2008 18:12:27 -0400
Date: Sat, 9 Aug 2008 22:55:02 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Rene Herman <rene.herman@keyaccess.nl>
Message-ID: <20080809225502.27b38a9d@lxorguk.ukuu.org.uk>
In-Reply-To: <489E13C0.4010807@keyaccess.nl>
References: <489DE890.1090103@keyaccess.nl>
	<20080809214657.3b5318d1@lxorguk.ukuu.org.uk>
	<489E13C0.4010807@keyaccess.nl>
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

> > Just apply a tiny bit of rational thought here. There is exactly ONE 
> > Ingo.
> 
> And as you say yourself -- close to exactly 1 person who still has this 
> hardware and closer still to 0 who use it. Really, you contradict yourself:

Consider the posibility that I might be talking about the general case
here. And if there are two people with the PMS card thats the general
case 8)

> We know this driver breaks the boot during useful kernel work. We know 
> that changing it has about a 0.0001% percent change of mattering to 
> anyone and then only as long as all those person can't be bothered to 
> setup a value in his modprobe.conf.

It never breaks anything for anyone as a module, only compiled in. Which
despite your moans about 'factual' things is a fact.

Can I suggest a rather more elegant solution would be to add a
"CONFIG_UNSAFE_PROBES" tristate (so you can decide if you want no unsafe
probing devices, unsafe probing devices only as modules, or anything goes)

Alan

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
