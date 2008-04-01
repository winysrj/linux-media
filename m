Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m31M91m1005623
	for <video4linux-list@redhat.com>; Tue, 1 Apr 2008 18:09:01 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m31M8mTx028555
	for <video4linux-list@redhat.com>; Tue, 1 Apr 2008 18:08:48 -0400
Date: Wed, 2 Apr 2008 00:08:45 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
To: Mike Rapoport <mike@compulab.co.il>
In-Reply-To: <47F21593.7080507@compulab.co.il>
Message-ID: <Pine.LNX.4.64.0804020005540.10163@axis700.grange>
References: <47F21593.7080507@compulab.co.il>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH] pxa_camera: Add support for YUV modes
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

On Tue, 1 Apr 2008, Mike Rapoport wrote:

> This patch adds support for YUV packed and planar capture for pxa_camera.

Great, thanks for the patch! I'll try to look at it this weekend... Have 
you been able to test both AUV and raw modes with your patch or only YUV? 
Are you also planning to submit the camera driver(s) and the platform code 
(for ARMCore I presume)?

Thanks
Guennadi
---
Guennadi Liakhovetski

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
