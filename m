Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:1903 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361Ab0CWHLs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Mar 2010 03:11:48 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: omap2 camera
Date: Tue, 23 Mar 2010 08:12:03 +0100
Cc: Viral Mehta <Viral.Mehta@lntinfotech.com>,
	"Aguirre, Sergio" <saaguirre@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <70376CA23424B34D86F1C7DE6B997343017F5D5BD5@VSHINMSMBX01.vshodc.lntinfotech.com> <70376CA23424B34D86F1C7DE6B997343017F5D5BD8@VSHINMSMBX01.vshodc.lntinfotech.com> <4BA85699.1070308@maxwell.research.nokia.com>
In-Reply-To: <4BA85699.1070308@maxwell.research.nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003230812.03198.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 23 March 2010 06:50:17 Sakari Ailus wrote:
> Viral Mehta wrote:
> > Hi Sakari,
> 
> Hi Viral,
> 
> > ________________________________________
> > From: Sakari Ailus [sakari.ailus@maxwell.research.nokia.com]
> > Sent: Monday, March 22, 2010 10:51 PM
> > To: Aguirre, Sergio
> > Cc: Viral Mehta; linux-media@vger.kernel.org
> > Subject: Re: omap2 camera
> > 
> > Aguirre, Sergio wrote:
> >> Hi Viral,
> >>
> >>> -----Original Message-----
> >>> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> >>> owner@vger.kernel.org] On Behalf Of Viral Mehta
> >>> Sent: Monday, March 22, 2010 5:20 AM
> >>> To: linux-media@vger.kernel.org
> >>> Subject: omap2 camera
> >>>
> >>> Hi list,
> >>>
> >>> I am using OMAP2430 board and I wanted to test camera module on that
> >>> board.
> >>> I am using latest 2.6.33 kernel. However, it looks like camera module is
> >>> not supported with latest kernel.
> >>>
> >>> Anyone is having any idea? Also, do we require to have ex3691 sensor
> >>> driver in mainline kernel in order to get omap24xxcam working ?
> >>>
> >>> These are the steps I followed,
> >>> 1. make omap2430_sdp_defconfig
> >>> 2. Enable omap2 camera option which is under drivers/media/video
> >>> 3. make uImage
> >>>
> >>> And with this uImage, camera is not working. I would appreciate any help.
> >>
> >> I'm adding Sakari Ailus to the CC list, which is the owner of the driver.
> > 
> >> Thanks, Sergio!
> > 
> > Thanks for your response. Thanks Sergio.
> > 
> >> I've only aware of the tcm825x sensor driver that works with the OMAP
> >> 2420 camera controller (omap24xxcam) driver.
> > 
> > Does this also mean that omap24xxcam.ko will *only* work with OMAP2420?
> > Or the same driver can be used for OMAP2430 board as well ?  As name suggests, omap24xxcam....
> 
> I'm not fully aware of the differences in the camera controllers in 2420
> and 2430 --- never had a 2430. If they are the same then the driver
> should work as it is. Sergio, do you know whether there are differences
> between the two?
> 
> >> So likely you'd need the driver for the sensor you have on that board.
> > Okie, I am trying to get that done. I took linux-2.6.14-V5 kernel from linux.omap.com and
> > that supports camera on OMAP2430 and it has functional driver for ex3691 sensor.
> > I am trying to know if I can forward port that.
> 
> That one very likely isn't using even the v4l2-int-device. But as soon
> as you do, it is very easy to convert it to v4l2_subdev. The interface
> is different but the ops are almost the same.
> 
> >> The omap24xxcam and tcm825x drivers should be moved to use v4l2_subdev
> >> but I'm not quite sure what will be the schedule of that. Then we could
> >> get rid of the v4l2-int-device interface that those drives still use.
> > 
> > They are still using v4l2-int-device as of 2.6.33.
> 
> That's true. AFAIK no work has been done to get rid of this yet.

And if anyone is going to work on this, then *please* convert it to subdev!
It shouldn't be that much work. omap24xxcam and tcm825x are the only ones
still using this and it would be great if they are converted. Then omap24xxcam
can use other sensors and the tcm825x can be used with other video hardware.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
