Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m622ofiK003094
	for <video4linux-list@redhat.com>; Tue, 1 Jul 2008 22:50:41 -0400
Received: from yw-out-2324.google.com (yw-out-2324.google.com [74.125.46.28])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m622oSCI031662
	for <video4linux-list@redhat.com>; Tue, 1 Jul 2008 22:50:28 -0400
Received: by yw-out-2324.google.com with SMTP id 5so80420ywb.81
	for <video4linux-list@redhat.com>; Tue, 01 Jul 2008 19:50:28 -0700 (PDT)
Message-ID: <aec7e5c30807011950u1ae2cf63u9ac03cdcd50fb755@mail.gmail.com>
Date: Wed, 2 Jul 2008 11:50:28 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
In-Reply-To: <Pine.LNX.4.64.0807012158510.4203@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080701124638.30446.81449.sendpatchset@rx1.opensource.se>
	<20080701124657.30446.28078.sendpatchset@rx1.opensource.se>
	<Pine.LNX.4.64.0807012158510.4203@axis700.grange>
Cc: video4linux-list@redhat.com, linux-sh@vger.kernel.org, lethal@linux-sh.org,
	mchehab@infradead.org, paulius.zaleckas@teltonika.lt,
	akpm@linux-foundation.org
Subject: Re: [PATCH 02/07] soc_camera: Let the host select videobuf_queue
	type
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

[CC Paulius]

On Wed, Jul 2, 2008 at 5:02 AM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> On Tue, 1 Jul 2008, Magnus Damm wrote:
>
>> This patch makes it possible for hosts (soc_camera drivers for the soc)
>> to select a different videobuf queue than VIDEOBUF_DMA_SG. This is needed
>> by the SuperH Mobile CEU hardware which requires physically contiguous
>> buffers. While at it, rename the spinlock callbacks to file callbacks.
>>
>> Signed-off-by: Magnus Damm <damm@igel.co.jp>
>
> I'm afraid, this patch conflicts with an earlier one by Paulius Zaleckas:
> http://marc.info/?l=linux-video&m=121438688924771&w=2, which I've already
> acked, and which, I think, makes videobuf handling more generic than
> yours. Could you please have a look if you can use it, if yes - rebase
> your patch-set on it (I think, some other your patches will have to be
> changed then too). If there's anything that you cannot use there, we'll
> have to see how we can satisfy all the requirements.

My patches are similar to Paulius change above, but I also clean up
the spinlock handling - since the videobuf queue stuff is moved into
the host driver there is no longer any point to keep the spinlock
callbacks and the icf->lock pointer inside soc_camera.c.

If you're interested in cleaning up the spinlock stuff then it's a tad
difficult to do that on top of Paulius code IMO. I'd say my patches
01-04 does the same as Paulis patch, but also removes redundant
spinlock code.

Let me know what you think. I'm more than happy to build on top of
Paulius patch, but I wonder if we really should keep the redundant
spinlock code...

Thanks!

/ magnus

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
