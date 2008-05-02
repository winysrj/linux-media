Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m42FNDsb032204
	for <video4linux-list@redhat.com>; Fri, 2 May 2008 11:23:13 -0400
Received: from mta1.srv.hcvlny.cv.net (mta1.srv.hcvlny.cv.net [167.206.4.196])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m42FN270015667
	for <video4linux-list@redhat.com>; Fri, 2 May 2008 11:23:02 -0400
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta1.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K080080BYQ4PG01@mta1.srv.hcvlny.cv.net> for
	video4linux-list@redhat.com; Fri, 02 May 2008 11:22:53 -0400 (EDT)
Date: Fri, 02 May 2008 11:22:52 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <1209736068.3475.66.camel@palomino.walls.org>
To: Andy Walls <awalls@radix.net>
Message-id: <481B31CC.6090606@linuxtv.org>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <481B1027.1040002@linuxtv.org>
	<1209736068.3475.66.camel@palomino.walls.org>
Cc: Steven Toth <stoth@hauppauge.com>, Michael Krufky <mkrufky@linuxtv.org>,
	Linux and Kernel Video <video4linux-list@redhat.com>
Subject: Re: cx18-0: ioremap failed, perhaps increasing __VMALLOC_RESERVE in
 page.h
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

>         if (cx->dev)
>                 cx18_iounmap(cx);

This doesn't feel right.

- Steve

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
