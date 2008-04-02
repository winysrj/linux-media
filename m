Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m325XoJZ021501
	for <video4linux-list@redhat.com>; Wed, 2 Apr 2008 01:33:50 -0400
Received: from mxout10.netvision.net.il (mxout10.netvision.net.il
	[194.90.6.38])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m325XcF3020955
	for <video4linux-list@redhat.com>; Wed, 2 Apr 2008 01:33:38 -0400
Received: from mail.linux-boards.com ([62.90.235.247])
	by mxout10.netvision.net.il
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0JYO00416NJI0840@mxout10.netvision.net.il> for
	video4linux-list@redhat.com; Wed, 02 Apr 2008 08:35:42 +0300 (IDT)
Date: Wed, 02 Apr 2008 08:33:31 +0300
From: Mike Rapoport <mike@compulab.co.il>
In-reply-to: <Pine.LNX.4.64.0804020005540.10163@axis700.grange>
To: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
Message-id: <47F31AAB.9030300@compulab.co.il>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
References: <47F21593.7080507@compulab.co.il>
	<Pine.LNX.4.64.0804020005540.10163@axis700.grange>
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


Guennadi Liakhovetski wrote:
> On Tue, 1 Apr 2008, Mike Rapoport wrote:
> 
>> This patch adds support for YUV packed and planar capture for pxa_camera.
> 
> Great, thanks for the patch! I'll try to look at it this weekend... Have 
> you been able to test both AUV and raw modes with your patch or only YUV? 

Only YUV.

> Are you also planning to submit the camera driver(s) and the platform code 
> (for ARMCore I presume)?

The camera driver is currently not in the state it can be submitted. It'll take
some time to make it generic enough.

> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski
> 

-- 
Sincerely yours,
Mike.


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
