Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6I7DYpe030083
	for <video4linux-list@redhat.com>; Fri, 18 Jul 2008 03:13:34 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m6I7DKcj014621
	for <video4linux-list@redhat.com>; Fri, 18 Jul 2008 03:13:20 -0400
Date: Fri, 18 Jul 2008 09:13:25 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: video4linux-list@redhat.com
Message-ID: <Pine.LNX.4.64.0807180845560.13569@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PULL] soc-camera: new SuperH camera host, contiguous videobuf,
 platform camera driver
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

please pull from http://linuxtv.org/hg/~gliakhovetski/v4l-dvb to get a 
trivial fix for checkpatch errors, introduced by earilier soc-camera 
patches.

Thanks for pulling previously discussed on the list patches from Magnus 
Damm (SuperH camera-host driver, contiguous videobuf, platform camera 
driver, 16-bit bus width support in soc-camera, spinlock reorganisation) 
and Paulius Zaleckas (videobug dependency fix).

Thanks
Guennadi
---
Guennadi Liakhovetski

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
