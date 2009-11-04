Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:35294 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751732AbZKDSbf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Nov 2009 13:31:35 -0500
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Neil Johnson <realdealneil@gmail.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Wed, 4 Nov 2009 12:31:39 -0600
Subject: RE: still image capture with video preview
Message-ID: <A69FA2915331DC488A831521EAE36FE40155833B30@dlee06.ent.ti.com>
References: <3d7d5c150911040913i5486bd07r3a465a2f7d2d5a3e@mail.gmail.com>
In-Reply-To: <3d7d5c150911040913i5486bd07r3a465a2f7d2d5a3e@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Neil,

Interesting use case. I am thinking of doing the same for
vpfe capture drive and here is what I am thinking of doing.

1) sensor driver MT9P031 configures either full capture(2592x1944)
(No skipping or binning) and video mode (VGA or 480p or any other
resolution through skipping & binning) through S_FMT. MT9T031
driver in kernel is doing this already (except for supporting
a specific frame rate) and MT9P031 driver may do the same.

2) Application switch the video node between these two modes (video
vs still capture)

For video (may use 3 or more VGA buffers)

using S_FMT, REQBUF, QUERYBUF (optional), mmap (optional)
QBUF, STREAMON...

When ready for still capture, application do switching to still capture
by doing STREAMOFF, S_FMT, REQBUF (use USERPTR), 
QBUF (one 5M buffer) and STREAMON. When finished, switch back to video
again. Here the switching time is critical and to be optimized.

BTW, are you planning to send the mt9p031 driver for review? I was looking
to see if I can re-use the same in vpfe capture. Also Are you configuring video mode in sensor driver at a specific frame rate? and finally are you using Snapshot mode in sensor for still capture? 

Thanks.

Murali Karicheri
Software Design Engineer
Texas Instruments Inc.
Germantown, MD 20874
email: m-karicheri2@ti.com

>-----Original Message-----
>From: linux-media-owner@vger.kernel.org [mailto:linux-media-
>owner@vger.kernel.org] On Behalf Of Neil Johnson
>Sent: Wednesday, November 04, 2009 12:13 PM
>To: linux-media@vger.kernel.org
>Subject: still image capture with video preview
>
>linux-media,
>
>I previously posted this on the video4linux-list, but linux-media
>seems a more appropriate place.
>
>I am developing on the OMAP3 system using a micron/aptina mt9p031
>5-megapixel imager.  This CMOs imager supports full image capture
>(2592x1944 pixels) or you can capture subregions using skipping and
>binning.  We have proven both capabilities, but would like to be able
>to capture both VGA sized video and still images without using
>separate drivers.
>
>So far, I have not found any support for capturing large images and
>video through a single driver interface.  Does such a capability exist
>within v4l2?  One possible way to solve the problem is to allocate N
>buffers of the full 5-megapixel size (they end up being 10-MB for each
>buffer since I'm using 16-bits per pixel), and then using a small
>portion of that for video.  This is less desirable since when I'm
>capturing video, I only need 640x480 size buffers, and I should only
>need one snapshot buffer at a time (I'm not streaming them in, just
>take a snapshot and go back to live video capture).  Is there a way to
>allocate a side-buffer for the 5-megapixel image and also allocate
>"normal" sized buffers for video within the same driver?  Any
>recommendations on how to accomplish such a thing?  I would think that
>camera-phones using linux would have run up against this.  Thanks,
>
>Neil Johnson
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

