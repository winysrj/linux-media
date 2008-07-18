Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6I7iBFc009323
	for <video4linux-list@redhat.com>; Fri, 18 Jul 2008 03:44:11 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m6I7hxRf027350
	for <video4linux-list@redhat.com>; Fri, 18 Jul 2008 03:44:00 -0400
Date: Fri, 18 Jul 2008 09:44:05 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
In-Reply-To: <4862128B.9050706@teltonika.lt>
Message-ID: <Pine.LNX.4.64.0807180943400.13569@axis700.grange>
References: <4862128B.9050706@teltonika.lt>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH] soc_camera: make videobuf independent
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

On Wed, 25 Jun 2008, Paulius Zaleckas wrote:

> Makes SoC camera videobuf independent. Includes all necessary changes for
> PXA camera driver (currently the only driver using soc_camera in the mainline).
> These changes are important for the future soc_camera based drivers.
> 
> Signed-off-by: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
> Cc: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>

Thanks, applied to soc-camera.

Guennadi
---
Guennadi Liakhovetski

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
