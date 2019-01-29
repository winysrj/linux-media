Return-Path: <SRS0=OvUS=QF=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB52EC169C4
	for <linux-media@archiver.kernel.org>; Tue, 29 Jan 2019 08:56:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 61833214DA
	for <linux-media@archiver.kernel.org>; Tue, 29 Jan 2019 08:56:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="oNJVR9ER"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727698AbfA2I4u (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 29 Jan 2019 03:56:50 -0500
Received: from mail-oi1-f174.google.com ([209.85.167.174]:40550 "EHLO
        mail-oi1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726948AbfA2I4u (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Jan 2019 03:56:50 -0500
Received: by mail-oi1-f174.google.com with SMTP id t204so15495191oie.7
        for <linux-media@vger.kernel.org>; Tue, 29 Jan 2019 00:56:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UXVuRZzXof3t2PjZRWm1tumDNLbUQVocJztd8ofhaQs=;
        b=oNJVR9ERlrZhWOqnTgq3q4ZfSFPpaz3VrmGnECwg0957NAMIKqjYFlJjK6/LibIPLm
         OPnHDiRu76WgfnEaekly7iCj1RoO0fUL4zhm1/w25cpMz1OIcJruKh2D22BYLycAVn+0
         gqLajQ22gEAmF8N0Rvgxqeyx7K8CbigkuNPmA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UXVuRZzXof3t2PjZRWm1tumDNLbUQVocJztd8ofhaQs=;
        b=b1zGsf7iW/5nlZNTLB83LDt2fi02Hvxki+9A6nNQHA0gvaVe8nipccHJf0BHqUMZYZ
         Bo2HAxoMKgFEjOca1R5s2Txno6nQBklnOLdBCaMXUneqZPqoAECUluxmuMAHsQ5jkUKs
         qNZ0cPF9VErZXbmSvOVsZShKKHMg1ZcwqaHKBiBY3DTTGuRsVVydX17no+fYtA7WZMsx
         1mKwxGALmT2QBowuqFUQoAUAoFtezmT2QVa33fmor9Vp2A5M6syYKVITh2dhLRwg468J
         QmOjtxqsNoFjb+1x4Dl23GFhR7NWCTnRlVegO8BL/cGtZ0Ljtsr+eG7Mso/HI/G3ItE7
         KPiw==
X-Gm-Message-State: AJcUukdZo3iMgUqJZ1Vj4kmke7xSiQUHW6CoDq7Vsb+c9erzy3tshW8u
        hYQKdVMfUtjqioiQMcflaFiDd+yx5SE=
X-Google-Smtp-Source: AHgI3IYikDVOjjijcHGHVkhi3PTWF3Rizt1GPKNnCXqWR30gfpZvCUnKV32AacaEVmUIcmna6E6vYA==
X-Received: by 2002:aca:c501:: with SMTP id v1mr8267745oif.48.1548752209099;
        Tue, 29 Jan 2019 00:56:49 -0800 (PST)
Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com. [209.85.210.52])
        by smtp.gmail.com with ESMTPSA id z15sm5828875oib.23.2019.01.29.00.56.47
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 29 Jan 2019 00:56:48 -0800 (PST)
Received: by mail-ot1-f52.google.com with SMTP id i20so17253224otl.0
        for <linux-media@vger.kernel.org>; Tue, 29 Jan 2019 00:56:47 -0800 (PST)
X-Received: by 2002:a9d:1d65:: with SMTP id m92mr19309082otm.65.1548752207194;
 Tue, 29 Jan 2019 00:56:47 -0800 (PST)
MIME-Version: 1.0
References: <1540851790-1777-1-git-send-email-yong.zhi@intel.com>
 <4147983.Vfm2iTi9Nh@avalon> <c7578347-c1ac-664c-4407-40b968daf377@linux.intel.com>
 <1722114.CA3sO5gtlY@avalon> <20190102202652.s4xha4vqhmt7qwsh@mara.localdomain>
 <20190128100906.lkly33nz63gp7grr@uno.localdomain>
In-Reply-To: <20190128100906.lkly33nz63gp7grr@uno.localdomain>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Tue, 29 Jan 2019 17:56:35 +0900
X-Gmail-Original-Message-ID: <CAAFQd5C=kZOSz8ip5BFy64T-3AwyXER_ntcqyQR+vrtKtjNKxg@mail.gmail.com>
Message-ID: <CAAFQd5C=kZOSz8ip5BFy64T-3AwyXER_ntcqyQR+vrtKtjNKxg@mail.gmail.com>
Subject: Re: [PATCH v7 00/16] Intel IPU3 ImgU patchset
To:     Jacopo Mondi <jacopo@jmondi.org>
Cc:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Bingbu Cao <bingbu.cao@linux.intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Zhi, Yong" <yong.zhi@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Hu, Jerry W" <jerry.w.hu@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>,
        "Qiu, Tian Shu" <tian.shu.qiu@intel.com>,
        "Cao, Bingbu" <bingbu.cao@intel.com>,
        libcamera-devel@lists.libcamera.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Mon, Jan 28, 2019 at 7:08 PM Jacopo Mondi <jacopo@jmondi.org> wrote:
>
> Hi Sakari, everyone..
>
> On Wed, Jan 02, 2019 at 10:26:56PM +0200, Sakari Ailus wrote:
> > Hi Laurent,
> >
> > On Wed, Jan 02, 2019 at 10:20:13AM +0200, Laurent Pinchart wrote:
> > > Hello Bingbu,
> > >
> > > On Wednesday, 2 January 2019 04:38:33 EET Bingbu Cao wrote:
> > > > On 12/26/2018 07:03 PM, Laurent Pinchart wrote:
> > > > > On Monday, 17 December 2018 05:14:44 EET Bingbu Cao wrote:
> > > > >> On 12/14/2018 06:24 AM, Laurent Pinchart wrote:
> > > > >>> On Wednesday, 12 December 2018 06:55:53 EET Bingbu Cao wrote:
> > > > >>>> On 12/11/2018 09:43 PM, Laurent Pinchart wrote:
> > > > >>>>> On Tuesday, 11 December 2018 15:34:49 EET Laurent Pinchart wrote:
> > > > >>>>>> On Wednesday, 5 December 2018 02:30:46 EET Mani, Rajmohan wrote:
> > > > >>>>>>
> > > > >>>>>> [snip]
> > > > >>>>>>
> > > > >>>>>>> I can see a couple of steps missing in the script below.
> > > > >>>>>>> (https://lists.libcamera.org/pipermail/libcamera-devel/2018-November
> > > > >>>>>>> /000040.html)
> > > > >>>>>>>
> > > > >>>>>>>    From patch 02 of this v7 series "doc-rst: Add Intel IPU3
> > > > >>>>>>>    documentation", under section "Configuring ImgU V4L2 subdev for
> > > > >>>>>>>    image processing"...
> > > > >>>>>>>
> > > > >>>>>>> 1. The pipe mode needs to be configured for the V4L2 subdev.
> > > > >>>>>>>
> > > > >>>>>>> Also the pipe mode of the corresponding V4L2 subdev should be set as
> > > > >>>>>>> desired (e.g 0 for video mode or 1 for still mode) through the
> > > > >>>>>>> control id 0x009819a1 as below.
> > > > >>>>>>>
> > > > >>>>>>> e.g v4l2n -d /dev/v4l-subdev7 --ctrl=0x009819A1=1
> > > > >>>>>>
> > > > >>>>>> I assume the control takes a valid default value ? It's better to set
> > > > >>>>>> it explicitly anyway, so I'll do so.
> > > > >>>>
> > > > >>>> The video mode is set by default. If you want to set to still mode or
> > > > >>>> change mode, you need set the subdev control.
> > > > >>>>
> > > > >>>>>>> 2. ImgU pipeline needs to be configured for image processing as
> > > > >>>>>>> below.
> > > > >>>>>>>
> > > > >>>>>>> RAW bayer frames go through the following ISP pipeline HW blocks to
> > > > >>>>>>> have the processed image output to the DDR memory.
> > > > >>>>>>>
> > > > >>>>>>> RAW bayer frame -> Input Feeder -> Bayer Down Scaling (BDS) ->
> > > > >>>>>>> Geometric Distortion Correction (GDC) -> DDR
> > > > >>>>>>>
> > > > >>>>>>> The ImgU V4L2 subdev has to be configured with the supported
> > > > >>>>>>> resolutions in all the above HW blocks, for a given input
> > > > >>>>>>> resolution.
> > > > >>>>>>>
> > > > >>>>>>> For a given supported resolution for an input frame, the Input
> > > > >>>>>>> Feeder, Bayer Down Scaling and GDC blocks should be configured with
> > > > >>>>>>> the supported resolutions. This information can be obtained by
> > > > >>>>>>> looking at the following IPU3 ISP configuration table for ov5670
> > > > >>>>>>> sensor.
> > > > >>>>>>>
> > > > >>>>>>> https://chromium.googlesource.com/chromiumos/overlays/board-overlays
> > > > >>>>>>> /+/master/baseboard-poppy/media-libs/cros-camera-hal-configs-poppy/
> > > > >>>>>>> files/gcss/graph_settings_ov5670.xml
> > > > >>>>>>>
> > > > >>>>>>> For the ov5670 example, for an input frame with a resolution of
> > > > >>>>>>> 2592x1944 (which is input to the ImgU subdev pad 0), the
> > > > >>>>>>> corresponding resolutions for input feeder, BDS and GDC are
> > > > >>>>>>> 2592x1944, 2592x1944 and 2560x1920 respectively.
> > > > >>>>>>
> > > > >>>>>> How is the GDC output resolution computed from the input resolution ?
> > > > >>>>>> Does the GDC always consume 32 columns and 22 lines ?
> > > > >>>>
> > > > >>>> All the intermediate resolutions in the pipeline are determined by the
> > > > >>>> actual use case, in other word determined by the IMGU input
> > > > >>>> resolution(sensor output) and the final output and viewfinder
> > > > >>>> resolution. BDS mainly do Bayer downscaling, it has limitation that the
> > > > >>>> downscaling factor must be a value a integer multiple of 1/32.
> > > > >>>> GDC output depends on the input and width should be x8 and height x4
> > > > >>>> alignment.
> > > > >>>
> > > > >>> Thank you for the information. This will need to be captured in the
> > > > >>> documentation, along with information related to how each block in the
> > > > >>> hardware pipeline interacts with the image size. It should be possible
> > > > >>> for a developer to compute the output and viewfinder resolutions based
> > > > >>> on the parameters of the image processing algorithms just with the
> > > > >>> information contained in the driver documentation.
> > > > >>>
> > > > >>>>>>> The following steps prepare the ImgU ISP pipeline for the image
> > > > >>>>>>> processing.
> > > > >>>>>>>
> > > > >>>>>>> 1. The ImgU V4L2 subdev data format should be set by using the
> > > > >>>>>>> VIDIOC_SUBDEV_S_FMT on pad 0, using the GDC width and height
> > > > >>>>>>> obtained
> > > > >>>>>>> above.
> > > > >>>>>>
> > > > >>>>>> If I understand things correctly, the GDC resolution is the pipeline
> > > > >>>>>> output resolution. Why is it configured on pad 0 ?
> > > > >>>>
> > > > >>>> We see the GDC output resolution as the input of output system, the
> > > > >>>> sink pad format is used for output and viewfinder resolutions.
> > > > >>>
> > > > >>> The ImgU subdev is supposed to represent the ImgU. Pad 0 should thus be
> > > > >>> the ImgU input, the format configured there should correspond to the
> > > > >>> format on the connected video node, and should thus be the sensor
> > > > >>> format. You can then use the crop and compose rectangles on pad 0, along
> > > > >>> with the format, crop and compose rectangles on the output and
> > > > >>> viewfinder pads, to configure the device. This should be fixed in the
> > > > >>> driver, and the documentation should then be updated accordingly.
> > > > >>
> > > > >> Hi, Laurent,
> > > > >>
> > > > >> Thanks for your review.
> > > > >>
> > > > >> I think it make sense for me that using Pad 0 as the ImgU input(IF).
> > > > >> However, I prefer using the 2 source pads for output and viewfinder.
> > > > >> It makes more sense because the output and viewfinder are independent
> > > > >> output.
> > > > >>
> > > > >> The whole pipeline in ImgU looks like:
> > > > >> IF --> BDS --> GDC ---> OUTPUT
> > > > >>                   |-----> VF
> > > > >>
> > > > >> The BDS is used to do Bayer downscaling and GDC can do cropping.
> > > > >
> > > > > Does this mean that the main output and the viewfinder output share the
> > > > > same scaler, and that the only difference in size between the two outputs
> > > > > is solely due to cropping ?
> > > >
> > > > Laurent,
> > > > No, output only can do crop and viewfinder support crop and scaling, they
> > > > share same input.
> > >
> > > Then you can't support this with a single subdev for the ImgU, you need at
> > > least two subdevs. I can offer more guidance, but I'll need more information
> > > about the GDC.
> >
> > While the current documentation only defines the functionality of the
> > compose target for sink pads, there are a few sensor drivers supporting it
> > on source pads already. Some drivers such as the OMAP3 ISP also use the
> > format on source pads to configure scaling.
> >
> > The current API certainly allows exposing the compose rectangle also on the
> > source pads, but to make that generic we'd need to amend the API to tell in
> > which order these steps take place. In the meantime the behaviour remains
> > device specific.
> >
>
> My understanding is that what is currently missing is the support
> for viewfinder's ability to scale, as the scaler should get
> programmed by configuring a composing rectangle on a source pad which
> is not supported by the V4L2 APIs at the moment. Is my understanding correct?
>
> As the composing rectangle is set for both 'output' and 'viewfinder'
> through the image format sizes configured on the first sink pad (*),
> the viewfinder output is obtained by cropping-only to the image format
> sizes configured on source pad number 3 (though SUBDEV_S_FMT not through
> SUBDEV_S_SELECTION, as SUBDEV_S_SELECTION is only allowed on sink pad
> 0 in the driver: see "ipu3_subdev_set_selection()").
>
> As you mentioned "device specific behaviour", what is the intended one
> for the ipu3? I assumed the viewfinder scaling/cropping was configured
> on the 'viewfinder' video device node, through the VIDIOC_S_SELECTION
> ioctl, but looking at the code, that doesn't seem to be listed as
> supported in "ipu3_v4l2_ioctl_ops".
>
> How am I supposed to configure scaling on the viewfinder output? Would
> adding support for crop/compose to the 'output' and 'viewfinder' video
> devices be supported by the V4L2 APIs? That would work with the single
> subdevice model that is currently implemented in this patches...

Isn't this what the driver actually implements? My understanding was
that the format on the VF video node determined the scaling settings,
based on the source pad.

That was my understanding on how we should make things work, i.e. try
to put as much as possible into core V4L2 interfaces and only defer to
subdevices or media controller if that's impossible. Laurent didn't
seem to agree with that when we talked last time, though, and I can
see some reasons why actually moving simplifying the video devices as
much as possible and moving as much as possible into subdevices could
make sense (simpler interfaces of endpoints, finer granularity for
feature description, less redundance - only subdevices do processing,
video nodes are only DMAs, etc.).

Best regards,
Tomasz
