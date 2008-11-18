Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAIJPwLV022920
	for <video4linux-list@redhat.com>; Tue, 18 Nov 2008 14:25:59 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mAIJPde7023905
	for <video4linux-list@redhat.com>; Tue, 18 Nov 2008 14:25:39 -0500
Date: Tue, 18 Nov 2008 20:25:41 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: video4linux-list@redhat.com
Message-ID: <Pine.LNX.4.64.0811181945410.8628@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: 
Subject: [PATCH 0/2 v3] soc-camera: pixel format negotiation
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

ok, v3 is rather symbolic, counting v1 my original version v2 the version 
from Robert, then this is approximately v3.

These two patches allow host and camera drivers to negoatiate supported 
pixel formats and provide a correct set of formats to the user.

I tried to follow what has been discussed during the previous two version 
rounds. But I had to test it, so, I implemented pxa-support too, sorry, 
Robert. sh_mobile_ceu_camera.c is unmodified so far, the fallback mode 
should provide backwards compatibility. camera drivers do not have to be 
modified either.

The complete stack (except these patches) until now I uploaded at

http://home.arcor.de/g.liakhovetski/v4l/20081118/

based on commit d3ac380b85fc3701c87580ee9ff934c65b8b779f of linux-next. I 
had to revert two ARM patches to get videobuf-dma-sg.c to compile, 
hopefully, it will get fixed some time...

Please, review, comment, test.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
