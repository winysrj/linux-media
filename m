Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9KFKxBB009446
	for <video4linux-list@redhat.com>; Mon, 20 Oct 2008 11:20:59 -0400
Received: from mta1.srv.hcvlny.cv.net (mta1.srv.hcvlny.cv.net [167.206.4.196])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9KFKCCk005577
	for <video4linux-list@redhat.com>; Mon, 20 Oct 2008 11:20:12 -0400
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta1.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K91005BFMLI7QY0@mta1.srv.hcvlny.cv.net> for
	video4linux-list@redhat.com; Mon, 20 Oct 2008 11:20:06 -0400 (EDT)
Date: Mon, 20 Oct 2008 11:20:05 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <1224481594.4265.8.camel@skoll>
To: video4linux-list@redhat.com
Message-id: <48FCA1A5.4000906@linuxtv.org>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7BIT
References: <48F90ED4.8030907@b4net.dk>
	<alpine.DEB.1.10.0810181408370.18626@vegas> <48FA41C1.3030501@b4net.dk>
	<1224481594.4265.8.camel@skoll>
Subject: Re: Hauppauge PVR-150 MCE vs HVR-1300
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

> Well, the HW encoder is sort of working. The problem is that I cannot
> change channel (tuning) when reading the mpeg stream. I also have a
> problem with the audio being interupted about every 5 seconds with a
> loud static noice and then resuming to normal. 

Pull the latest master repro, test again. Report back. A number of audio 
related fixes were just merged.

Thanks,

- Steve

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
