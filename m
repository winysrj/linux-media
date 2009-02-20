Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n1KFImAp019619
	for <video4linux-list@redhat.com>; Fri, 20 Feb 2009 10:18:48 -0500
Received: from mta1.srv.hcvlny.cv.net (mta1.srv.hcvlny.cv.net [167.206.4.196])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n1KFIcY5028352
	for <video4linux-list@redhat.com>; Fri, 20 Feb 2009 10:18:38 -0500
Received: from steven-toths-macbook-pro.local
	(ool-45721e5a.dyn.optonline.net [69.114.30.90]) by
	mta1.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0KFD002DDEJ1TC21@mta1.srv.hcvlny.cv.net> for
	video4linux-list@redhat.com; Fri, 20 Feb 2009 10:18:37 -0500 (EST)
Date: Fri, 20 Feb 2009 10:18:36 -0500
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <412bdbff0902200317h26f4d42fh4327b3ff08c79d5c@mail.gmail.com>
To: Devin Heitmueller <devin.heitmueller@gmail.com>
Message-id: <499EC9CC.3040703@linuxtv.org>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <412bdbff0902200317h26f4d42fh4327b3ff08c79d5c@mail.gmail.com>
Cc: V4L <video4linux-list@redhat.com>
Subject: Re: HVR-950q analog support - testers wanted
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

Devin Heitmueller wrote:
> Hello,
> 
> There is now a test repository that provides analog support for the HVR-950q:
> 
> http://linuxtv.org/hg/~dheitmueller/hvr950q-analog
> 
> I welcome people interested in analog support for the 950q to download
> the tree and provide feedback.

I only have time today for a small amount of testing but QAM and ATSC are still 
working reliably. No obvious issues. No obvious regressions.

I'll load this up on my myth box this weekend and ensure it's still reliable 
over the long term.

I'll be in touch.

- Steve

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
