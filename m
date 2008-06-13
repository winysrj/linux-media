Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5D9XGnL026204
	for <video4linux-list@redhat.com>; Fri, 13 Jun 2008 05:33:16 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m5D9X2bH010528
	for <video4linux-list@redhat.com>; Fri, 13 Jun 2008 05:33:03 -0400
Date: Fri, 13 Jun 2008 11:33:11 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: video4linux-list@redhat.com
Message-ID: <Pine.LNX.4.64.0806131131250.27615@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PULL] soc-camera bug-fixes
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

Mauro,

Please pull from http://linuxtv.org/hg/~gliakhovetski/v4l-dvb

for the following 2 changesets:

01/02: pxa-camera: fix platform_get_irq() error handling.
http://linuxtv.org/hg/~gliakhovetski/v4l-dvb?cmd=changeset;node=2d2b7431aaf2

02/02: soc-camera: remove soc_camera_host_class class
http://linuxtv.org/hg/~gliakhovetski/v4l-dvb?cmd=changeset;node=ab0c1a4f7cf1


 pxa_camera.c |    4 ++--
 soc_camera.c |   16 ----------------
 2 files changed, 2 insertions(+), 18 deletions(-)

Thanks,
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
