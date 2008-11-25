Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAQ0D42V018561
	for <video4linux-list@redhat.com>; Tue, 25 Nov 2008 19:13:04 -0500
Received: from smtp6-g19.free.fr (smtp6-g19.free.fr [212.27.42.36])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAQ0CoEX006993
	for <video4linux-list@redhat.com>; Tue, 25 Nov 2008 19:12:50 -0500
To: Mike Rapoport <mike@compulab.co.il>
References: <87prl4x28e.fsf@free.fr> <491C002F.4070804@compulab.co.il>
	<87ljvktqtv.fsf@free.fr> <491FCBFF.9060208@compulab.co.il>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Tue, 25 Nov 2008 22:18:46 +0100
In-Reply-To: <491FCBFF.9060208@compulab.co.il> (Mike Rapoport's message of
	"Sun\, 16 Nov 2008 09\:30\:07 +0200")
Message-ID: <87ljv7a4i1.fsf@free.fr>
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

>>>From what I read on the PXA manual, the only constraint is 16bytes
>> alignement. Would you also remember who wrote the code, so that I can ask him
>> where he read about page alignement constraint please ?
>
> Just by coincidence it was me :)
> I used pxafb_overlay from [1], and my (mis)understanding of what it does added
> the page alignment constrain. Now looking at the overlay code once more, I'm not
> sure if it's necessary.
>
> ---
> [1] http://www.rpsys.net/openzaurus/patches/archive/pxa27x_overlay-r8.patch

Just for the record, I made a try or two, changing the alignment from page (4096
bytes) into 16 bytes (PAGE_ALIGN -> ALIGN(x,16)). And surprise, I get a lot of
DMA bus errors ...

I'm still investigating, there's something weird in there ...

Cheers.

--
Robert

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
