Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6ECeHUd028533
	for <video4linux-list@redhat.com>; Mon, 14 Jul 2008 08:40:17 -0400
Received: from ciao.gmane.org (main.gmane.org [80.91.229.2])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6ECe5EB027659
	for <video4linux-list@redhat.com>; Mon, 14 Jul 2008 08:40:06 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1KINLW-0006lj-Bq
	for video4linux-list@redhat.com; Mon, 14 Jul 2008 12:40:02 +0000
Received: from 82-135-208-232.static.zebra.lt ([82.135.208.232])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Mon, 14 Jul 2008 12:40:02 +0000
Received: from paulius.zaleckas by 82-135-208-232.static.zebra.lt with local
	(Gmexim 0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Mon, 14 Jul 2008 12:40:02 +0000
To: video4linux-list@redhat.com
From: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
Date: Mon, 14 Jul 2008 15:36:58 +0300
Message-ID: <487B486A.7040403@teltonika.lt>
References: <20080714120204.4806.87287.sendpatchset@rx1.opensource.se>
	<20080714120213.4806.93867.sendpatchset@rx1.opensource.se>
	<Pine.LNX.4.64.0807141427140.11348@axis700.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <Pine.LNX.4.64.0807141427140.11348@axis700.grange>
Cc: video4linux-list@redhat.com, linux-sh@vger.kernel.org
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

Guennadi Liakhovetski wrote:
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
                                                        videobuf
                                                               ^

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
