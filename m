Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAG7USY4006121
	for <video4linux-list@redhat.com>; Sun, 16 Nov 2008 02:30:28 -0500
Received: from oceanus.site5.com (oceanus.site5.com [67.43.13.2])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAG7UAmc017607
	for <video4linux-list@redhat.com>; Sun, 16 Nov 2008 02:30:10 -0500
Message-ID: <491FCBFF.9060208@compulab.co.il>
Date: Sun, 16 Nov 2008 09:30:07 +0200
From: Mike Rapoport <mike@compulab.co.il>
MIME-Version: 1.0
To: Robert Jarzmik <robert.jarzmik@free.fr>
References: <87prl4x28e.fsf@free.fr> <491C002F.4070804@compulab.co.il>
	<87ljvktqtv.fsf@free.fr>
In-Reply-To: <87ljvktqtv.fsf@free.fr>
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
> Mike Rapoport <mike@compulab.co.il> writes:
> 
>> Robert Jarzmik wrote:
>>> Hello,
>>>
>>> In the pxa camera driver, the 3 DMA channels used are MMU page aligned. Does
>>> somebody remember where that constraint comes from ?
>>>
>> As far as I remember, the buffers should be page aligned to allow overlaying of
>> captured data.
> Ah, so that's it, thanks.
> 
>>From what I read on the PXA manual, the only constraint is 16bytes
> alignement. Would you also remember who wrote the code, so that I can ask him
> where he read about page alignement constraint please ?

Just by coincidence it was me :)
I used pxafb_overlay from [1], and my (mis)understanding of what it does added
the page alignment constrain. Now looking at the overlay code once more, I'm not
sure if it's necessary.


---
[1] http://www.rpsys.net/openzaurus/patches/archive/pxa27x_overlay-r8.patch

> Cheers.
> 
> --
> Robert
> 

-- 
Sincerely yours,
Mike.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
