Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6238vOm010126
	for <video4linux-list@redhat.com>; Tue, 1 Jul 2008 23:08:57 -0400
Received: from yw-out-2324.google.com (yw-out-2324.google.com [74.125.46.31])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6238lZS006446
	for <video4linux-list@redhat.com>; Tue, 1 Jul 2008 23:08:47 -0400
Received: by yw-out-2324.google.com with SMTP id 5so83741ywb.81
	for <video4linux-list@redhat.com>; Tue, 01 Jul 2008 20:08:46 -0700 (PDT)
Message-ID: <aec7e5c30807012008y6d5a16f0h9c634d79f0de37ba@mail.gmail.com>
Date: Wed, 2 Jul 2008 12:08:46 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
In-Reply-To: <Pine.LNX.4.64.0807012205511.4203@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080701124638.30446.81449.sendpatchset@rx1.opensource.se>
	<20080701124745.30446.27603.sendpatchset@rx1.opensource.se>
	<Pine.LNX.4.64.0807012205511.4203@axis700.grange>
Cc: video4linux-list@redhat.com, lethal@linux-sh.org, akpm@linux-foundation.org,
	mchehab@infradead.org, linux-sh@vger.kernel.org
Subject: Re: [PATCH 07/07] sh_mobile_ceu_camera: Add SuperH Mobile CEU driver
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

On Wed, Jul 2, 2008 at 5:07 AM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> On Tue, 1 Jul 2008, Magnus Damm wrote:
>
>> This patch adds support for the SuperH Mobile CEU interface.
>>
>> The hardware is configured in a transparent data fetch mode,
>> and frames are captured from the attached camera and written
>> to physically contiguous memory buffers provided by the
>> videobuf-dma-contig queue.
>>
>> Signed-off-by: Magnus Damm <damm@igel.co.jp>
>
> Great to see new soc-camera host drivers! Just out of curiousity - can you
> tell us, with which camera drivers you tested / used it?

Uh, I knew that question would come up... =)

So far I've mainly tried the SuperH Mobile CEU driver on a MigoR QVGA
board, which means a sh7722 processor (which includes the CEU) and a
ov7725 camera. I also have a sh7723 board with a ncm03j camera (i
think, no docs), but that combination isn't up an running yet.

As for camera drivers, I'm sorry to say that I've been using hacked-up
out-of-tree drivers. I'd like to add upstream support for both camera
types, but I'm not sure if I have enough time before the merge window
closes for 2.6.27. So I've prioritized the CEU driver so far since
it's easy to reuse.

Regarding the ov7725 driver - there seem to be quite a few
half-fitting candidates out there already. I'm thinking about the
ovcamchip/ code and the ov7670.c driver. I need something for the
soc_camera framework though. What to do? Any recommendations?

Thanks,

/ magnus

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
