Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9G65fOM021218
	for <video4linux-list@redhat.com>; Thu, 16 Oct 2008 02:05:41 -0400
Received: from blu0-omc3-s18.blu0.hotmail.com (blu0-omc3-s18.blu0.hotmail.com
	[65.55.116.93])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9G65Cft013744
	for <video4linux-list@redhat.com>; Thu, 16 Oct 2008 02:05:24 -0400
Message-ID: <BLU149-W7855B29CEEB1B1B0CF9B2C99330@phx.gbl>
From: Amol Borawake <borawake_amol@hotmail.com>
To: <video4linux-list@redhat.com>
Date: Thu, 16 Oct 2008 11:35:12 +0530
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Using V4L2 Drivers for Capturing Video Data in YUV420P data
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


Hello All,

I am using TI DaVinci DM6446 EVM Board. The sample program provided with Board allow me capture the  YUV 422 Interleved data. The Pixel format in V4L2 drivers for this is set like V4L2_PIX_FMT_YUYV.

I need YUV420 Planer Data using V4L2. I tried setting the pixel format in V4L2 for YUV420 Planer data as V4L2_PIX_FMT_YUV420.
But, the data I am getting from V4L2 is bit shifted by some offset.

Any solution to resolve this problem ?
Since, converting YUV422 Interleved to YUV420 Planer on board takes CPU as well as FPS . So getting YUV420 Planer data directly from the V4L2 would be much better .

Waiting for reply.

Thanks,
Amol Borawake
_________________________________________________________________
Search for videos of Bollywood, Hollywood, Mollywood and every other wood, only on Live.com 
http://www.live.com/?scope=video&form=MICOAL

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
