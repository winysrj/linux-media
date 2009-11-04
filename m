Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:46865 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755295AbZKDTYk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Nov 2009 14:24:40 -0500
Received: by bwz27 with SMTP id 27so9239090bwz.21
        for <linux-media@vger.kernel.org>; Wed, 04 Nov 2009 11:24:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <A69FA2915331DC488A831521EAE36FE40155833B30@dlee06.ent.ti.com>
References: <3d7d5c150911040913i5486bd07r3a465a2f7d2d5a3e@mail.gmail.com>
	 <A69FA2915331DC488A831521EAE36FE40155833B30@dlee06.ent.ti.com>
Date: Wed, 4 Nov 2009 12:24:44 -0700
Message-ID: <3d7d5c150911041124r4b952303hf9c0a9e11897621d@mail.gmail.com>
Subject: Re: still image capture with video preview
From: Neil Johnson <realdealneil@gmail.com>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Murali,

On Wed, Nov 4, 2009 at 11:31 AM, Karicheri, Muralidharan
<m-karicheri2@ti.com> wrote:
> Hi Neil,
>
> Interesting use case. I am thinking of doing the same for
> vpfe capture drive and here is what I am thinking of doing.
I started my testing with the DaVinci 6446 (using the DVEVM from TI),
using the LeopardImaging add-on board, but we made a hardware switch
to the OMAP3530 because of its size and low-heat characteristics.
I've been trying to leverage existing code on the DaVinci when
possible, but the drivers have diverged a bit.  (especially in the
VPFE vs Camera ISP)

>
> 1) sensor driver MT9P031 configures either full capture(2592x1944)
> (No skipping or binning) and video mode (VGA or 480p or any other
> resolution through skipping & binning) through S_FMT. MT9T031
> driver in kernel is doing this already (except for supporting
> a specific frame rate) and MT9P031 driver may do the same.
At this point I have hard-coded the kernel to either do full capture
or VGA/480P-sized capture.  I've been able to take full-sized still
images when the kernel is configured that way (camera isp and sensor
must both be configured).  I can also compile the kernel such that I
capture 30 fps VGA or 480P (both isp and sensor configured again).
However, when I configure the kernel to capture full-sized images
(2592x1944), the isp gets configured upon the call to open(), so the
previewer/resizer buffers are huge.  Then, I can configure the sensor
to capture at a smaller resolution, but the frame rate gets reduced to
about 5 fps.

Ideally, I wouldn't allocate such large buffers if I were just
capturing video.  I may be doing something wrong with the sensor
configuration, so I'm exploring that.

>
> 2) Application switch the video node between these two modes (video
> vs still capture)
>
> For video (may use 3 or more VGA buffers)
>
> using S_FMT, REQBUF, QUERYBUF (optional), mmap (optional)
> QBUF, STREAMON...
>
> When ready for still capture, application do switching to still capture
> by doing STREAMOFF, S_FMT, REQBUF (use USERPTR),
> QBUF (one 5M buffer) and STREAMON. When finished, switch back to video
> again. Here the switching time is critical and to be optimized.
I'm considering this, too.  However, up to this point, all my attempts
to use USERPTR have failed.  I need to revisit that and see where
exactly it's failing and why.  I'm not sure that my driver fully
supports it, and the documentation on USERPTR has been a bit scarce,
so I may not be doing it properly.

>
> BTW, are you planning to send the mt9p031 driver for review? I was looking
> to see if I can re-use the same in vpfe capture.
My kernel source tree is a bit of an amalgamation from a variety of
sources.  So, it doesn't lend itself well to creating a patch and
sending it upstream for review.  What base should I work off of so
that I can submit a good patch?


> Also Are you configuring video mode in sensor driver at a specific frame rate? and finally are > you using Snapshot mode in sensor for still capture?
I have tuned the vertical and horizontal blanking to output 720x480 at
30 fps.  I am using the OMAP-generated cam_clk at 36 MHz.  I have done
some experimentation using snapshot mode, but only to test that a
mechanical shutter opens and closes based on strobe pulses, not
actually capturing mechanically-shuttered images yet...hopefully I'll
be doing that soon.

>
> Thanks.
>
> Murali Karicheri
> Software Design Engineer
> Texas Instruments Inc.
> Germantown, MD 20874
> email: m-karicheri2@ti.com
>
>>-----Original Message-----
>>From: linux-media-owner@vger.kernel.org [mailto:linux-media-
>>owner@vger.kernel.org] On Behalf Of Neil Johnson
>>Sent: Wednesday, November 04, 2009 12:13 PM
>>To: linux-media@vger.kernel.org
>>Subject: still image capture with video preview
>>
>>linux-media,
>>
>>I previously posted this on the video4linux-list, but linux-media
>>seems a more appropriate place.
>>
>>I am developing on the OMAP3 system using a micron/aptina mt9p031
>>5-megapixel imager.  This CMOs imager supports full image capture
>>(2592x1944 pixels) or you can capture subregions using skipping and
>>binning.  We have proven both capabilities, but would like to be able
>>to capture both VGA sized video and still images without using
>>separate drivers.
>>
>>So far, I have not found any support for capturing large images and
>>video through a single driver interface.  Does such a capability exist
>>within v4l2?  One possible way to solve the problem is to allocate N
>>buffers of the full 5-megapixel size (they end up being 10-MB for each
>>buffer since I'm using 16-bits per pixel), and then using a small
>>portion of that for video.  This is less desirable since when I'm
>>capturing video, I only need 640x480 size buffers, and I should only
>>need one snapshot buffer at a time (I'm not streaming them in, just
>>take a snapshot and go back to live video capture).  Is there a way to
>>allocate a side-buffer for the 5-megapixel image and also allocate
>>"normal" sized buffers for video within the same driver?  Any
>>recommendations on how to accomplish such a thing?  I would think that
>>camera-phones using linux would have run up against this.  Thanks,
>>
>>Neil Johnson
>>--
>>To unsubscribe from this list: send the line "unsubscribe linux-media" in
>>the body of a message to majordomo@vger.kernel.org
>>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>



-- 
Neil Johnson
Systems Engineer
Procerus Technologies
http://www.procerus.com
801-437-0805 (work)
