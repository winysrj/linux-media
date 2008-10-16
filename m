Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9G6IMW2026238
	for <video4linux-list@redhat.com>; Thu, 16 Oct 2008 02:18:22 -0400
Received: from bear.ext.ti.com (bear.ext.ti.com [192.94.94.41])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9G6HZvO019105
	for <video4linux-list@redhat.com>; Thu, 16 Oct 2008 02:17:35 -0400
From: "R, Sivaraj" <sivaraj@ti.com>
To: Amol Borawake <borawake_amol@hotmail.com>, "video4linux-list@redhat.com"
	<video4linux-list@redhat.com>
Date: Thu, 16 Oct 2008 11:47:09 +0530
Message-ID: <EAF47CD23C76F840A9E7FCE10091EFAB028C86EC3D@dbde02.ent.ti.com>
References: <BLU149-W7855B29CEEB1B1B0CF9B2C99330@phx.gbl>
In-Reply-To: <BLU149-W7855B29CEEB1B1B0CF9B2C99330@phx.gbl>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: 
Subject: RE: Using V4L2 Drivers for Capturing Video Data in YUV420P data
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

Amol,

The TI Davinci DM6446 hardware supports only YUV 422 interleaved format. 
It doesn't support YUV422 or YUV420 planar formats.

This is the reason why the Davinci V4L2 driver doesn't the format you wanted.
Format conversion should be done in application only.

Regards,
Sivaraj R

Sivaraj R
Platform Support Products
Texas Instruments India - Bangalore
Desk     : +91-80-25099767     Cubicle : 1F-078
IP-Phone : 5099767             Extn    : 1767
Mobile   : +91-9980911151      E-mail  : sivaraj@ti.com


-----Original Message-----
From: video4linux-list-bounces@redhat.com [mailto:video4linux-list-bounces@redhat.com] On Behalf Of Amol Borawake
Sent: Thursday, October 16, 2008 11:35 AM
To: video4linux-list@redhat.com
Subject: Using V4L2 Drivers for Capturing Video Data in YUV420P data


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


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
