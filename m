Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.mnsspb.ru ([84.204.75.2]:60372 "EHLO mail.mnsspb.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755219Ab1G1Lnm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jul 2011 07:43:42 -0400
Date: Thu, 28 Jul 2011 15:42:36 +0400
From: Kirill Smelkov <kirr@mns.spb.ru>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Subject: Re: [git:v4l-dvb/for_v3.1] [media] uvcvideo: Add FIX_BANDWIDTH
	quirk to HP Webcam on HP Mini 5103 netbook
Message-ID: <20110728114236.GA5391@tugrik.mns.mnsspb.ru>
References: <E1QmAuS-0002S0-Pd@www.linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1QmAuS-0002S0-Pd@www.linuxtv.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jul 27, 2011 at 09:42:08PM +0200, Mauro Carvalho Chehab wrote:
> This is an automatic generated email to let you know that the following patch were queued at the 
> http://git.linuxtv.org/media_tree.git tree:
> 
> Subject: [media] uvcvideo: Add FIX_BANDWIDTH quirk to HP Webcam on HP Mini 5103 netbook
> Author:  Kirill Smelkov <kirr@mns.spb.ru>
> Date:    Fri Jul 22 11:47:22 2011 -0300

Thanks


> The camera there identifies itself as being manufactured by Cheng Uei
> Precision Industry Co., Ltd (Foxlink), and product is titled as "HP
> Webcam [2 MP Fixed]".
> 
> I was trying to get 2 USB video capture devices to work simultaneously,
> and noticed that the above mentioned webcam always requires packet size
> = 3072 bytes per micro frame (~= 23.4 MB/s isoc bandwidth), which is far
> more than enough to get standard NTSC 640x480x2x30 = ~17.6 MB/s isoc
> bandwidth.
> 
> As there are alt interfaces with smaller MxPS
> 
>     T:  Bus=01 Lev=01 Prnt=01 Port=03 Cnt=01 Dev#=  2 Spd=480  MxCh= 0
>     D:  Ver= 2.00 Cls=ef(misc ) Sub=02 Prot=01 MxPS=64 #Cfgs=  1
>     P:  Vendor=05c8 ProdID=0403 Rev= 1.06
>     S:  Manufacturer=Foxlink
>     S:  Product=HP Webcam [2 MP Fixed]
>     S:  SerialNumber=200909240102
>     C:* #Ifs= 2 Cfg#= 1 Atr=80 MxPwr=500mA
>     A:  FirstIf#= 0 IfCount= 2 Cls=0e(video) Sub=03 Prot=00
>     I:* If#= 0 Alt= 0 #EPs= 1 Cls=0e(video) Sub=01 Prot=00 Driver=uvcvideo
>     E:  Ad=83(I) Atr=03(Int.) MxPS=  16 Ivl=4ms
>     I:* If#= 1 Alt= 0 #EPs= 0 Cls=0e(video) Sub=02 Prot=00 Driver=uvcvideo
>     I:  If#= 1 Alt= 1 #EPs= 1 Cls=0e(video) Sub=02 Prot=00 Driver=uvcvideo
>     E:  Ad=81(I) Atr=05(Isoc) MxPS= 128 Ivl=125us
>     I:  If#= 1 Alt= 2 #EPs= 1 Cls=0e(video) Sub=02 Prot=00 Driver=uvcvideo
>     E:  Ad=81(I) Atr=05(Isoc) MxPS= 512 Ivl=125us
>     I:  If#= 1 Alt= 3 #EPs= 1 Cls=0e(video) Sub=02 Prot=00 Driver=uvcvideo
>     E:  Ad=81(I) Atr=05(Isoc) MxPS=1024 Ivl=125us
>     I:  If#= 1 Alt= 4 #EPs= 1 Cls=0e(video) Sub=02 Prot=00 Driver=uvcvideo
>     E:  Ad=81(I) Atr=05(Isoc) MxPS=1536 Ivl=125us
>     I:  If#= 1 Alt= 5 #EPs= 1 Cls=0e(video) Sub=02 Prot=00 Driver=uvcvideo
>     E:  Ad=81(I) Atr=05(Isoc) MxPS=2048 Ivl=125us
>     I:  If#= 1 Alt= 6 #EPs= 1 Cls=0e(video) Sub=02 Prot=00 Driver=uvcvideo
>     E:  Ad=81(I) Atr=05(Isoc) MxPS=2688 Ivl=125us
>     I:  If#= 1 Alt= 7 #EPs= 1 Cls=0e(video) Sub=02 Prot=00 Driver=uvcvideo
>     E:  Ad=81(I) Atr=05(Isoc) MxPS=3072 Ivl=125us
> 
> UVC_QUIRK_FIX_BANDWIDTH helps here and NTSC video can be served with
> MxPS=2688 i.e. 20.5 MB/s isoc bandwidth.
> 
> In terms of microframe time allocation, before the quirk NTSC video
> required 60 usecs / microframe and 53 usecs / microframe after.
> 
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Signed-off-by: Kirill Smelkov <kirr@mns.spb.ru>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>


May I ask, why you removed the reference to cc62a7eb? Original patch
description contained the following paragraph just before sob

    Now with tweaked ehci-hcd to allow up to 90% isoc bandwidth (cc62a7eb
    "USB: EHCI: Allow users to override 80% max periodic bandwidth") I can
    capture two video sources -- PAL 720x576 YUV422 @25fps + NTSC 640x480
    YUV422 @30fps simultaneously.  Hooray!


which was removed on applying.



Thanks beforehand for answering,
Kirill
