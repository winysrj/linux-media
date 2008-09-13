Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8DKe1RD025260
	for <video4linux-list@redhat.com>; Sat, 13 Sep 2008 16:40:02 -0400
Received: from mta5.srv.hcvlny.cv.net (mta5.srv.hcvlny.cv.net [167.206.4.200])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8DKdnv4019997
	for <video4linux-list@redhat.com>; Sat, 13 Sep 2008 16:39:50 -0400
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta5.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K7500E43IQAK7H0@mta5.srv.hcvlny.cv.net> for
	video4linux-list@redhat.com; Sat, 13 Sep 2008 16:39:49 -0400 (EDT)
Date: Sat, 13 Sep 2008 16:39:46 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <200809131623.10155.liplianin@tut.by>
To: "Igor M. Liplianin" <liplianin@tut.by>
Message-id: <48CC2512.2020502@linuxtv.org>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <E1KdnPr-0002YP-SF@www.linuxtv.org>
	<200809131623.10155.liplianin@tut.by>
Cc: video4linux-list@redhat.com, linux-dvb@linuxtv.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [linux-dvb]  [PATCH] Add support for SDMC DM1105 PCI chip
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

Igor M. Liplianin wrote:
> The patch adds support for SDMC DM1105 PCI chip. There is a lot of
> cards based on it, like DvbWorld 2002 DVB-S , 2004 DVB-S2
> Source code prepaired to and already tested with cards, which have si2109, 
> stv0288, cx24116 demods.  Currently enabled only stv0299, as other demods are 
> not in a v4l-dvb main tree, but I will submit corresponded patches (si2109, 
> stv0288) next time.

Igor,

Cool.

Master repo does not have cx24116 support so it probably cannot be 
merged. Do you need me to merge this into the s2api tree?

- Steve




--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
