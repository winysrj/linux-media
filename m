Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5U8DJsA009368
	for <video4linux-list@redhat.com>; Mon, 30 Jun 2008 04:13:19 -0400
Received: from ciao.gmane.org (main.gmane.org [80.91.229.2])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5U8CZML003897
	for <video4linux-list@redhat.com>; Mon, 30 Jun 2008 04:12:36 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1KDEUy-0001Q7-OF
	for video4linux-list@redhat.com; Mon, 30 Jun 2008 08:12:32 +0000
Received: from 82-135-208-232.static.zebra.lt ([82.135.208.232])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Mon, 30 Jun 2008 08:12:32 +0000
Received: from paulius.zaleckas by 82-135-208-232.static.zebra.lt with local
	(Gmexim 0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Mon, 30 Jun 2008 08:12:32 +0000
To: video4linux-list@redhat.com
From: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
Date: Mon, 30 Jun 2008 11:12:23 +0300
Message-ID: <48689567.9060204@teltonika.lt>
References: <8AA5EFF14ED6C44DB31DA963D1E78F0DAF6DCCD1@dlee02.ent.ti.com>	<5d5443650806270316u252564e2v8258ddb57c850760@mail.gmail.com>	<20080627215753.GA2090@daniel.bse>	<1214604521.2640.27.camel@pc10.localdom.local>
	<8AA5EFF14ED6C44DB31DA963D1E78F0DAF73F494@dlee02.ent.ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <8AA5EFF14ED6C44DB31DA963D1E78F0DAF73F494@dlee02.ent.ti.com>
Subject: Re: omap3 camera driver
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

Have you considered using soc_camera framework?
That would make thing a little bit easier and more generic.

BR,
Paulius Zaleckas

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
