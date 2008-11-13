Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mADAPcBU000358
	for <video4linux-list@redhat.com>; Thu, 13 Nov 2008 05:25:38 -0500
Received: from oceanus.site5.com (oceanus.site5.com [67.43.13.2])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mADANpcT019726
	for <video4linux-list@redhat.com>; Thu, 13 Nov 2008 05:24:13 -0500
Message-ID: <491C002F.4070804@compulab.co.il>
Date: Thu, 13 Nov 2008 12:23:43 +0200
From: Mike Rapoport <mike@compulab.co.il>
MIME-Version: 1.0
To: Robert Jarzmik <robert.jarzmik@free.fr>
References: <87prl4x28e.fsf@free.fr>
In-Reply-To: <87prl4x28e.fsf@free.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: pxa_camera: DMA alignment requirement
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



Robert Jarzmik wrote:
> Hello,
> 
> In the pxa camera driver, the 3 DMA channels used are MMU page aligned. Does
> somebody remember where that constraint comes from ?
> 
> I'm wondering because the planar YUV format generated is something like this for
> a 640 * 480 image :
>  - Y plane => 640 * 480 bytes = 307200 (and this happens to be a multiple of
>  pagesize : 307200 = 4096 * 75)
>  - U plane => 640 * 480 / 2 bytes = 153600 (and this is not a multiple of 4096)
>  - padding to reach next page : 2048 bytes
>  - V plane => 153600 bytes
>  - padding to reach next page : 2048 bytes
> 
> This means a user space library should be kernel pagesize aware to transform the
> output image. I don't really understand the necessity of page aligned DMA
> channels. Would someone tell me please ?

As far as I remember, the buffers should be page aligned to allow overlaying of
captured data.

> --
> Robert
> 
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
> 

-- 
Sincerely yours,
Mike.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
