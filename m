Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAG1EYeH002793
	for <video4linux-list@redhat.com>; Sat, 15 Nov 2008 20:14:34 -0500
Received: from smtp3-g19.free.fr (smtp3-g19.free.fr [212.27.42.29])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAG1EM5e016916
	for <video4linux-list@redhat.com>; Sat, 15 Nov 2008 20:14:22 -0500
To: Mike Rapoport <mike@compulab.co.il>
References: <87prl4x28e.fsf@free.fr> <491C002F.4070804@compulab.co.il>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Sun, 16 Nov 2008 02:14:20 +0100
In-Reply-To: <491C002F.4070804@compulab.co.il> (Mike Rapoport's message of
	"Thu\, 13 Nov 2008 12\:23\:43 +0200")
Message-ID: <87ljvktqtv.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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

Mike Rapoport <mike@compulab.co.il> writes:

> Robert Jarzmik wrote:
>> Hello,
>> 
>> In the pxa camera driver, the 3 DMA channels used are MMU page aligned. Does
>> somebody remember where that constraint comes from ?
>> 
>
> As far as I remember, the buffers should be page aligned to allow overlaying of
> captured data.
Ah, so that's it, thanks.

>From what I read on the PXA manual, the only constraint is 16bytes
alignement. Would you also remember who wrote the code, so that I can ask him
where he read about page alignement constraint please ?

Cheers.

--
Robert

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
