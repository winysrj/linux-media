Return-Path: <SRS0=gjtM=PQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0544C43387
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 23:32:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A958F2146F
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 23:32:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="qs/xxutk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729473AbfAHXcy (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 8 Jan 2019 18:32:54 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:41466 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729331AbfAHXcy (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2019 18:32:54 -0500
Received: from avalon.localnet (dfj612ybrt5fhg77mgycy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:2e86:4862:ef6a:2804])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 07136586;
        Wed,  9 Jan 2019 00:32:50 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1546990371;
        bh=+iy93gXIJtVkGy22KR9A7LYmpK5C3/oIUe9SCgEpYOU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qs/xxutkKYZmP7P6QFqC3wIlcmXhvnmxB6pAMg87YTwx2KbeowqoBUZG2aF65Pnbj
         oyEPmcTQeYg0+YsLlOYC7cuoB9wcwSbeUDJalqIK2Ewtz/8iwLtzOGoVDW2t1w5glf
         08FhAatlYXVsP3wVstraRDiYVbvPh25kioc2sZD4=
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     "Mani, Rajmohan" <rajmohan.mani@intel.com>
Cc:     Tomasz Figa <tfiga@chromium.org>, "Zhi, Yong" <yong.zhi@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "'Zheng, Jian Xu'" <jian.xu.zheng@intel.com>,
        "Hu, Jerry W" <jerry.w.hu@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>,
        "Qiu, Tian Shu" <tian.shu.qiu@intel.com>,
        "Cao, Bingbu" <bingbu.cao@intel.com>,
        Jacopo Mondi <jacopo@jmondi.org>
Subject: Re: [PATCH v7 00/16] Intel IPU3 ImgU patchset
Date:   Wed, 09 Jan 2019 01:34:00 +0200
Message-ID: <4929983.L9RZQDNQcv@avalon>
Organization: Ideas on Board Oy
In-Reply-To: <6F87890CF0F5204F892DEA1EF0D77A599B31FAF4@fmsmsx122.amr.corp.intel.com>
References: <1540851790-1777-1-git-send-email-yong.zhi@intel.com> <1819843.KIqgResAvh@avalon> <6F87890CF0F5204F892DEA1EF0D77A599B31FAF4@fmsmsx122.amr.corp.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Raj,

(CC'ing Jacopo Mondi)

On Saturday, 5 January 2019 04:26:16 EET Mani, Rajmohan wrote:
> >> On Tuesday, 11 December 2018 15:43:53 EET Laurent Pinchart wrote:
> >>> On Tuesday, 11 December 2018 15:34:49 EET Laurent Pinchart wrote:
> >>>> On Wednesday, 5 December 2018 02:30:46 EET Mani, Rajmohan wrote:
> >>>> 
> >>>> [snip]
> >>>> 
> >>>>> I can see a couple of steps missing in the script below.
> >>>>> (https://lists.libcamera.org/pipermail/libcamera-devel/2018-Nove
> >>>>> mber/000040.html)
> >>>>> 
> >>>>> From patch 02 of this v7 series "doc-rst: Add Intel IPU3
> >>>>> documentation", under section "Configuring ImgU V4L2 subdev for
> >>>>> image processing"...
> >>>>> 
> >>>>> 1. The pipe mode needs to be configured for the V4L2 subdev.
> >>>>> 
> >>>>> Also the pipe mode of the corresponding V4L2 subdev should be
> >>>>> set as desired (e.g 0 for video mode or 1 for still mode)
> >>>>> through the control id 0x009819a1 as below.
> >>>>> 
> >>>>> e.g v4l2n -d /dev/v4l-subdev7 --ctrl=0x009819A1=1
> >>>> 
> >>>> I assume the control takes a valid default value ? It's better to
> >>>> set it explicitly anyway, so I'll do so.
> >>>> 
> >>>>> 2. ImgU pipeline needs to be configured for image processing as
> >>>>> below.
> >>>>> 
> >>>>> RAW bayer frames go through the following ISP pipeline HW blocks
> >>>>> to have the processed image output to the DDR memory.
> >>>>> 
> >>>>> RAW bayer frame -> Input Feeder -> Bayer Down Scaling (BDS) ->
> >>>>> Geometric Distortion Correction (GDC) -> DDR
> >>>>> 
> >>>>> The ImgU V4L2 subdev has to be configured with the supported
> >>>>> resolutions in all the above HW blocks, for a given input
> >>>>> resolution.
> >>>>> 
> >>>>> For a given supported resolution for an input frame, the Input
> >>>>> Feeder, Bayer Down Scaling and GDC blocks should be configured
> >>>>> with the supported resolutions. This information can be obtained
> >>>>> by looking at the following IPU3 ISP configuration table for
> >>>>> ov5670 sensor.
> >>>>> 
> >>>>> https://chromium.googlesource.com/chromiumos/overlays/board-over
> >>>>> lays/+/master/baseboard-poppy/media-libs/cros-camera-hal-configs-
> >>>>> poppy/files/gcss/graph_settings_ov5670.xml
> >>>>> 
> >>>>> For the ov5670 example, for an input frame with a resolution of
> >>>>> 2592x1944 (which is input to the ImgU subdev pad 0), the
> >>>>> corresponding resolutions for input feeder, BDS and GDC are
> >>>>> 2592x1944, 2592x1944 and
> >>>>> 2560x1920 respectively.
> >>>> 
> >>>> How is the GDC output resolution computed from the input
> >>>> resolution ? Does the GDC always consume 32 columns and 22 lines ?
> >>>> 
> >>>>> The following steps prepare the ImgU ISP pipeline for the image
> >>>>> processing.
> >>>>> 
> >>>>> 1. The ImgU V4L2 subdev data format should be set by using the
> >>>>> VIDIOC_SUBDEV_S_FMT on pad 0, using the GDC width and height
> >>>>> obtained above.
> >>>> 
> >>>> If I understand things correctly, the GDC resolution is the
> >>>> pipeline output resolution. Why is it configured on pad 0 ?
> >>>> 
> >>>>> 2. The ImgU V4L2 subdev cropping should be set by using the
> >>>>> VIDIOC_SUBDEV_S_SELECTION on pad 0, with V4L2_SEL_TGT_CROP as
> >>>>> the target, using the input feeder height and width.
> >>>>> 
> >>>>> 3. The ImgU V4L2 subdev composing should be set by using the
> >>>>> VIDIOC_SUBDEV_S_SELECTION on pad 0, with
> >>>>> V4L2_SEL_TGT_COMPOSE as the target, using the BDS height and width.
> >>>>> 
> >>>>> Once these 2 steps are done, the raw bayer frames can be input
> >>>>> to the ImgU V4L2 subdev for processing.
> >>>> 
> >>>> Do I need to capture from both the output and viewfinder nodes ?
> >>>> How are they related to the IF -> BDS -> GDC pipeline, are they
> >>>> both fed from the GDC output ? If so, how does the viewfinder
> >>>> scaler fit in that picture ?
> >>>> 
> >>>> I have tried the above configuration with the IPU3 v8 driver, and
> >>>> while the kernel doesn't crash, no images get processed. The
> >>>> userspace processes wait forever for buffers to be ready. I then
> >>>> configured pad 2 to 2560x1920 and pad 3 to 1920x1080, and managed
> >>>> to capture images \o/
> >>>> 
> >>>> There's one problem though: during capture, or very soon after it,
> >>>> the machine locks up completely. I suspect a memory corruption, as
> >>>> when it doesn't log immediately commands such as dmesg will not
> >>>> produce any output and just block, until the system freezes soon
> >>>> after (especially when moving the mouse).
> >>>> 
> >>>> I would still call this an improvement to some extent, but there's
> >>>> definitely room for more improvements :-)
> >>>> 
> >>>> To reproduce the issue, you can run the ipu3-process.sh script
> >>>> (attached to this e-mail) with the following arguments:
> >>>> 
> >>>> $ ipu3-process.sh --out 2560x1920 frame-2592x1944.cio2
> >> 
> >> This should have read
> >> 
> >> $ ipu3-process.sh --out 2560x1920 --vf 1920x1080 frame-2592x1944.cio2
> >> 
> >> Without the --vf argument no images are processed.
> >> 
> >> It seems that the Intel mail server blocked the mail that contained the
> >> script. You can find a copy at http://paste.debian.net/hidden/fd5bb8df/.
> 
> Here's what I have so far.
> 
> I made the following two changes to get image capture and processing
> working with the above script. I can see the output and vf ppm files to come
> out well.
> 
> 1. Remove the "# Set formats" inside the configure_pipeline() from the
> above script and used a simple application (which I invoked from your
> script) to set pad 0 of the "ipu3-imgu 0" V4L2 subdev with these 3 sub
> steps.
> 
> a. Set the data format using VIDIOC_SUBDEV_S_FMT on pad 0
> GDC width and height (2560x1920)
> 
> b. Set cropping using VIDIOC_SUBDEV_S_SELECTION on pad 0
> with V4L2_SEL_TGT_CROP as target, using the input feeder width
> and height (2592x1944)
> 
> c. Set composing using VIDIOC_SUBDEV_S_SELECTION on pad 0
> with V4L2_SEL_TGT_COMPOSE as the target, using
> BDS width and height (2592x1944)

This is exactly what the first media-ctl -V call just below the "Set formats" 
comment does.

> 2. Modify yavta app to ignore the error (on "3A stat" node) from
> cap_get_buf_type(), so all 4 nodes can be running at the same time.

I don't get that error with the latest yavta version.

> Can you advise why the " # Set formats" part of configure_pipeline()
> in your script is not achieving the same results as the above 3 sub steps?

I tried removing the three media-ctl -V lines that configure format on pads 2, 
3 and 4. The crash then didn't occur when running the script. However, after 
rebooting the system and retrying the exact same sequence of operation, the 
driver crashed again, and I haven't been able to process images without 
crashing since then.

The driver is clearly very sensitive to how formats and selection rectangles 
are configured, and crashes when userspace doesn't operate exactly as 
expected. This should all be fixed, likely by rewriting the format and 
selection rectangle configuration code, especially given that it doesn't 
comply with how V4L2 configures scaling on subdevs.

We can discuss this issue with Sakari to decide on how the code should be 
architectured. How long do you think it would then take to implement the 
solution ?

> Per Bingbu, the driver might be lacking some implementation around this.
> 
> >>>>> 1. The ImgU V4L2 subdev data format should be set by using the
> >>>>> VIDIOC_SUBDEV_S_FMT on pad 0, using the GDC width and height
> >>>>> obtained above.
> >>>>> 2. The ImgU V4L2 subdev cropping should be set by using the
> >>>>> VIDIOC_SUBDEV_S_SELECTION on pad 0, with V4L2_SEL_TGT_CROP as
> >>>>> the target, using the input feeder height and width.
> >>>>> 3. The ImgU V4L2 subdev composing should be set by using the
> >>>>> VIDIOC_SUBDEV_S_SELECTION on pad 0, with V4L2_SEL_TGT_COMPOSE
> >>>>> as the target, using the BDS height and width.
> > 
> > Sorry for the delay. I got interrupted with some other work.
> > I will have a look at this and get back soon.

-- 
Regards,

Laurent Pinchart



