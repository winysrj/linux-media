Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m72D2HsF019531
	for <video4linux-list@redhat.com>; Sat, 2 Aug 2008 09:02:17 -0400
Received: from smtp6-g19.free.fr (smtp6-g19.free.fr [212.27.42.36])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m72D25Pq009934
	for <video4linux-list@redhat.com>; Sat, 2 Aug 2008 09:02:05 -0400
To: video4linux-list@redhat.com
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Sat, 02 Aug 2008 15:02:03 +0200
Message-ID: <87myjv1sfo.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Allocation of micron MT9M111 chip v42l ident ID
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

Hello,

I will submit within the next few hours/days a driver for a Micron mt9m111
camera chip. I know only one flavor of the MT9M111 chip, there are no
distinctions like monochrome/color models.

Would that be possible to have a chip ID assigned in
v4l2-chip-ident.h, eg. something like :
+	V4L2_IDENT_MT9M111		= ???,
Is there a procedure for such things ?

I'll wait for an answer before submitting the mt9m111 driver.

Regards.

--
Robert

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
