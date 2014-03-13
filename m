Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:55518 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260AbaCMO3s (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Mar 2014 10:29:48 -0400
From: Kamil Debski <k.debski@samsung.com>
To: 'Archit Taneja' <archit@ti.com>, hverkuil@xs4all.nl
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org
References: <1393922965-15967-1-git-send-email-archit@ti.com>
 <1394526833-24805-1-git-send-email-archit@ti.com>
 <1394526833-24805-3-git-send-email-archit@ti.com>
 <000001cf3eb2$39817540$ac845fc0$%debski@samsung.com> <53219FE0.8010604@ti.com>
In-reply-to: <53219FE0.8010604@ti.com>
Subject: RE: [PATCH v3 02/14] v4l: ti-vpe: register video device only when
 firmware is loaded
Date: Thu, 13 Mar 2014 15:29:44 +0100
Message-id: <000901cf3ec8$aea34270$0be9c750$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

> From: Archit Taneja [mailto:archit@ti.com]
> Sent: Thursday, March 13, 2014 1:09 PM
> 
> Hi Kamil,
> 
> On Thursday 13 March 2014 05:18 PM, Kamil Debski wrote:
> > Hi Archit,
> >
> >> From: Archit Taneja [mailto:archit@ti.com]
> >> Sent: Tuesday, March 11, 2014 9:34 AM
> >>
> >> vpe fops(vpe_open in particular) should be called only when VPDMA
> >> firmware is loaded. File operations on the video device are possible
> >> the moment it is registered.
> >>
> >> Currently, we register the video device for VPE at driver probe,
> >> after calling a vpdma helper to initialize VPDMA and load firmware.
> >> This function is non-blocking(it calls request_firmware_nowait()),
> >> and doesn't ensure that the firmware is actually loaded when it
> returns.
> >>
> >> We remove the device registration from vpe probe, and move it to a
> >> callback provided by the vpe driver to the vpdma library, through
> >> vpdma_create().
> >>
> >> The ready field in vpdma_data is no longer needed since we always
> >> have firmware loaded before the device is registered.
> >>
> >> A minor problem with this approach is that if the
> >> video_register_device fails(which doesn't really happen), the vpe
> >> platform device would be registered.
> >> however, there won't be any v4l2 device corresponding to it.
> >
> > Could you explain to me one thing. request_firmware cannot be used in
> > probe, thus you are using request_firmware_nowait. Why cannot the
> > firmware be loaded on open with a regular request_firmware that is
> > waiting?
> 
> I totally agree with you here. Placing the firmware in open() would
> probably make more sense.
> 
> The reason I didn't place it in open() is because I didn't want to
> release firmware in a corresponding close(), and be in a situation
> where the firmware is loaded multiple times in the driver's lifetime.

Would it be possible to load firmware in open and release it in remove?
I know that this would disturb the symmetry between open-release and
probe-remove. But this could work.
 
> There are some reasons for doing this. First, it will require more
> testing with respect to whether the firmware is loaded correctly
> successive times :), the second is that loading firmware might probably
> take a bit of time, and we don't want to make applications too slow(I
> haven't measured the time taken, so I don't have a strong case for this
> either)
> 
> >
> > This patch seems to swap one problem for another. The possibility
> that
> > open fails (because firmware is not yet loaded) is swapped for a
> vague
> > possibility that video_register_device.
> 
> The driver will work fine in most cases even without this patch(apart
> from the possibility mentioned as above).
> 
> We could discard this patch from this series, and I can work on a patch
> which moves firmware loading to the vpe_open() call, and hence solving
> the issue in the right manner. Does that sound fine?

I agree, this should be a good solution.

> 
> Thanks,
> Archit

Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland

