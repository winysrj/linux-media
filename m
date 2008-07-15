Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6F8NPNE022333
	for <video4linux-list@redhat.com>; Tue, 15 Jul 2008 04:23:25 -0400
Received: from py-out-1112.google.com (py-out-1112.google.com [64.233.166.179])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6F8NFEB024773
	for <video4linux-list@redhat.com>; Tue, 15 Jul 2008 04:23:15 -0400
Received: by py-out-1112.google.com with SMTP id a29so2819476pyi.0
	for <video4linux-list@redhat.com>; Tue, 15 Jul 2008 01:23:15 -0700 (PDT)
Message-ID: <aec7e5c30807150123x32774aadvfd2685c981c5e8dc@mail.gmail.com>
Date: Tue, 15 Jul 2008 17:23:14 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
In-Reply-To: <Pine.LNX.4.64.0807141427140.11348@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080714120204.4806.87287.sendpatchset@rx1.opensource.se>
	<20080714120213.4806.93867.sendpatchset@rx1.opensource.se>
	<Pine.LNX.4.64.0807141427140.11348@axis700.grange>
Cc: video4linux-list@redhat.com, paulius.zaleckas@teltonika.lt,
	linux-sh@vger.kernel.org, Mauro Carvalho Chehab <mchehab@infradead.org>,
	lethal@linux-sh.org, akpm@linux-foundation.org
Subject: Re: [PATCH 01/06] soc_camera: Move spinlocks
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

On Mon, Jul 14, 2008 at 9:31 PM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> On Mon, 14 Jul 2008, Magnus Damm wrote:
>
>> This patch moves the spinlock handling from soc_camera.c to the actual
>> camera host driver. The spinlock alloc/free callbacks are replaced with
>> code in init_videobuf().
>
> As merits of this move were not quite obvious to me (you lose the
> possibility to use default lock allocation / freeing in soc_camera.c), I
> extended your comment as follows:
>
> This patch moves the spinlock handling from soc_camera.c to the actual
> camera host driver. The spinlock_alloc/free callbacks are replaced with
> code in init_videobuf(). So far all camera host drivers implement their
> own spinlock_alloc/free methods anyway, and videobuf_queue_core_init()
> BUGs on a NULL spinlock argument, so, new camera host drivers will not
> forget to provide a spinlock when initialising their videobug queues.
>
> Do you agree with it? This is how I'm going to pull it into my soc-camera
> tree.

Yes, I agree. Thanks for extending the comment.

Speaking about pulling in patches, are all 6 patches ok with you guys?
Or do you expect me to fix up and resend something?

/ magnus

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
