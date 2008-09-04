Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m84FNYm0016161
	for <video4linux-list@redhat.com>; Thu, 4 Sep 2008 11:23:35 -0400
Received: from mta5.srv.hcvlny.cv.net (mta5.srv.hcvlny.cv.net [167.206.4.200])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m84FMfMR020756
	for <video4linux-list@redhat.com>; Thu, 4 Sep 2008 11:22:41 -0400
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta5.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K6O00M46G1SU4B0@mta5.srv.hcvlny.cv.net> for
	video4linux-list@redhat.com; Thu, 04 Sep 2008 11:22:40 -0400 (EDT)
Date: Thu, 04 Sep 2008 11:22:40 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <f4fceb150809040812j5be9b4a8pc2456254e3fbefa1@mail.gmail.com>
To: Yair Weinberger <yairwein@gmail.com>
Message-id: <48BFFD40.4060202@linuxtv.org>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <f4fceb150809011152n2a0adf2aqffb67a4cf87449c3@mail.gmail.com>
	<f4fceb150809011155pa06831eoff1ef993d3eb17c9@mail.gmail.com>
	<48BFEAF2.9060805@linuxtv.org>
	<f4fceb150809040812j5be9b4a8pc2456254e3fbefa1@mail.gmail.com>
Cc: video4linux-list <video4linux-list@redhat.com>
Subject: Re: Hauppauge WinTV USB2-Stick with Hardy
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

Yair Weinberger wrote:
> Hi,
> Thanks for your help.
> My hardware's ID doesn't appear also on the tm6010 tree. (grep -r
> "0x2040, 0x6610" * returns nothing).
> It appears that it is actually HVR 900H.
> 
> Anything else I should try?

No, Mauro's tm6010 tree's will eventually include 900H support.... If 
they don't contain 900H support then you'll have to wait, or help Mauro 
add support.

- Steve

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
