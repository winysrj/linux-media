Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m616TDhF026507
	for <video4linux-list@redhat.com>; Tue, 1 Jul 2008 02:29:13 -0400
Received: from smtp-vbr5.xs4all.nl (smtp-vbr5.xs4all.nl [194.109.24.25])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m616SSge015250
	for <video4linux-list@redhat.com>; Tue, 1 Jul 2008 02:28:28 -0400
Message-ID: <14576.62.70.2.252.1214893706.squirrel@webmail.xs4all.nl>
Date: Tue, 1 Jul 2008 08:28:26 +0200 (CEST)
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: dwainegarden@rogers.com
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: v4l <video4linux-list@redhat.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: Can we remove saa711x.c?
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

> Sounds good to me.  What about the other saa711().c modules?   Have all
> the drivers moved over to the saa7115.c?

saa7111 is still used by zoran and mxb.
saa7114 is still used by zoran as well.

I can test the zoran with the saa7111 (I'm fairly certain my iomega Buz
has a saa7111), and I've contacted the mxb maintainer in the hope that he
has one (it's been unmaintained for two years or so, so it might be
difficult to find someone with that hardware).

I'm hoping someone might have a zoran device with a saa7114, but if not
then I wonder whether we shouldn't just replace it and cross our fingers.

Regards,

        Hans

>
> ------Original Message------
> From: Hans Verkuil
> Sender:
> To: v4l
> Cc: Mauro Carvalho Chehab
> Subject: Can we remove saa711x.c?
> Sent: Jun 30, 2008 4:51 PM
>
> Hi all,
>
> It looks like the saa711x module is unused right now. Unless I'm missing
> something I propose we remove it before the 2.6.27 window opens.
>
> Regards,
>
> 	Hans
>
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
>
>
> Sent from my BlackBerry device on the Rogers Wireless Network
>
>


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
