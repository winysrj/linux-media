Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m616FVZe021863
	for <video4linux-list@redhat.com>; Tue, 1 Jul 2008 02:15:31 -0400
Received: from smtp105-mob.biz.mail.mud.yahoo.com
	(smtp105-mob.biz.mail.mud.yahoo.com [68.142.198.105])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m616ErrI009650
	for <video4linux-list@redhat.com>; Tue, 1 Jul 2008 02:14:53 -0400
Message-ID: <564172403-1214892885-cardhu_decombobulator_blackberry.rim.net-584370868-@bxe169.bisx.prod.on.blackberry>
To: "Hans Verkuil" <hverkuil@xs4all.nl>, "v4l" <video4linux-list@redhat.com>
From: dwainegarden@rogers.com
Date: Tue, 1 Jul 2008 06:14:27 +0000
Content-Type: text/plain
MIME-Version: 1.0
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: Can we remove saa711x.c?
Reply-To: dwainegarden@rogers.com
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

Sounds good to me.  What about the other saa711().c modules?   Have all the drivers moved over to the saa7115.c?

------Original Message------
From: Hans Verkuil
Sender: 
To: v4l
Cc: Mauro Carvalho Chehab
Subject: Can we remove saa711x.c?
Sent: Jun 30, 2008 4:51 PM

Hi all,

It looks like the saa711x module is unused right now. Unless I'm missing 
something I propose we remove it before the 2.6.27 window opens.

Regards,

	Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list


Sent from my BlackBerry device on the Rogers Wireless Network

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
