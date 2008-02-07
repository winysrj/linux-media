Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m17FL38d004922
	for <video4linux-list@redhat.com>; Thu, 7 Feb 2008 10:21:03 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.1/8.13.1) with SMTP id m17FKU76031735
	for <video4linux-list@redhat.com>; Thu, 7 Feb 2008 10:20:30 -0500
Date: Thu, 7 Feb 2008 16:20:38 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Message-ID: <Pine.LNX.4.64.0802071617420.5383@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com
Subject: Two more patches required for soc_camera
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

Hi Mauro,

thanks for pulling the soc_camera patches, what I am not sure about, have 
you also pulled these two:

http://marc.info/?l=linux-video&m=120179057030853&w=2
http://marc.info/?l=linux-video&m=120179045830566&w=2

? They are required by the pxa-camera driver to use sg-dma and by both 
Micron cameras respectively.

Thanks
Guennadi
---
Guennadi Liakhovetski

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
