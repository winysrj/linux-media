Return-Path: <SRS0=EV+/=QI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 585D2C282D8
	for <linux-media@archiver.kernel.org>; Fri,  1 Feb 2019 10:04:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A8D221872
	for <linux-media@archiver.kernel.org>; Fri,  1 Feb 2019 10:04:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727366AbfBAKEH (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 1 Feb 2019 05:04:07 -0500
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:46649 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725765AbfBAKEH (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Feb 2019 05:04:07 -0500
X-Originating-IP: 91.183.179.147
Received: from uno.localdomain (unknown [91.183.179.147])
        (Authenticated sender: jacopo@jmondi.org)
        by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id 6BBF6C0013;
        Fri,  1 Feb 2019 10:04:01 +0000 (UTC)
Date:   Fri, 1 Feb 2019 11:04:18 +0100
From:   Jacopo Mondi <jacopo@jmondi.org>
To:     Tomasz Figa <tfiga@chromium.org>
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
Subject: Re: [PATCH v7 00/16] Intel IPU3 ImgU patchset
Message-ID: <20190201100418.r6x5djrk535gvc54@uno.localdomain>
References: <1540851790-1777-1-git-send-email-yong.zhi@intel.com>
 <4147983.Vfm2iTi9Nh@avalon>
 <c7578347-c1ac-664c-4407-40b968daf377@linux.intel.com>
 <1722114.CA3sO5gtlY@avalon>
 <20190102202652.s4xha4vqhmt7qwsh@mara.localdomain>
 <20190128100906.lkly33nz63gp7grr@uno.localdomain>
 <CAAFQd5C=kZOSz8ip5BFy64T-3AwyXER_ntcqyQR+vrtKtjNKxg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="6hxexlgl4nmo6gx3"
Content-Disposition: inline
In-Reply-To: <CAAFQd5C=kZOSz8ip5BFy64T-3AwyXER_ntcqyQR+vrtKtjNKxg@mail.gmail.com>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--6hxexlgl4nmo6gx3
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Tomasz,

On Tue, Jan 29, 2019 at 05:56:35PM +0900, Tomasz Figa wrote:
> On Mon, Jan 28, 2019 at 7:08 PM Jacopo Mondi <jacopo@jmondi.org> wrote:
> >
> > Hi Sakari, everyone..
> >
> > On Wed, Jan 02, 2019 at 10:26:56PM +0200, Sakari Ailus wrote:
> > > Hi Laurent,
> > >
> > > On Wed, Jan 02, 2019 at 10:20:13AM +0200, Laurent Pinchart wrote:
> > > > Hello Bingbu,
> > > >
> > > > On Wednesday, 2 January 2019 04:38:33 EET Bingbu Cao wrote:
> > > > > On 12/26/2018 07:03 PM, Laurent Pinchart wrote:
> > > > > > On Monday, 17 December 2018 05:14:44 EET Bingbu Cao wrote:
> > > > > >> On 12/14/2018 06:24 AM, Laurent Pinchart wrote:
> > > > > >>> On Wednesday, 12 December 2018 06:55:53 EET Bingbu Cao wrote:
> > > > > >>>> On 12/11/2018 09:43 PM, Laurent Pinchart wrote:
> > > > > >>>>> On Tuesday, 11 December 2018 15:34:49 EET Laurent Pinchart wrote:
> > > > > >>>>>> On Wednesday, 5 December 2018 02:30:46 EET Mani, Rajmohan wrote:
> > > > > >>>>>>
> > > > > >>>>>> [snip]
> > > > > >>>>>>
> > > > > >>>>>>> I can see a couple of steps missing in the script below.
> > > > > >>>>>>> (https://lists.libcamera.org/pipermail/libcamera-devel/2018-November
> > > > > >>>>>>> /000040.html)
> > > > > >>>>>>>
> > > > > >>>>>>>    From patch 02 of this v7 series "doc-rst: Add Intel IPU3
> > > > > >>>>>>>    documentation", under section "Configuring ImgU V4L2 subdev for
> > > > > >>>>>>>    image processing"...
> > > > > >>>>>>>
> > > > > >>>>>>> 1. The pipe mode needs to be configured for the V4L2 subdev.
> > > > > >>>>>>>
> > > > > >>>>>>> Also the pipe mode of the corresponding V4L2 subdev should be set as
> > > > > >>>>>>> desired (e.g 0 for video mode or 1 for still mode) through the
> > > > > >>>>>>> control id 0x009819a1 as below.
> > > > > >>>>>>>
> > > > > >>>>>>> e.g v4l2n -d /dev/v4l-subdev7 --ctrl=0x009819A1=1
> > > > > >>>>>>
> > > > > >>>>>> I assume the control takes a valid default value ? It's better to set
> > > > > >>>>>> it explicitly anyway, so I'll do so.
> > > > > >>>>
> > > > > >>>> The video mode is set by default. If you want to set to still mode or
> > > > > >>>> change mode, you need set the subdev control.
> > > > > >>>>
> > > > > >>>>>>> 2. ImgU pipeline needs to be configured for image processing as
> > > > > >>>>>>> below.
> > > > > >>>>>>>
> > > > > >>>>>>> RAW bayer frames go through the following ISP pipeline HW blocks to
> > > > > >>>>>>> have the processed image output to the DDR memory.
> > > > > >>>>>>>
> > > > > >>>>>>> RAW bayer frame -> Input Feeder -> Bayer Down Scaling (BDS) ->
> > > > > >>>>>>> Geometric Distortion Correction (GDC) -> DDR
> > > > > >>>>>>>
> > > > > >>>>>>> The ImgU V4L2 subdev has to be configured with the supported
> > > > > >>>>>>> resolutions in all the above HW blocks, for a given input
> > > > > >>>>>>> resolution.
> > > > > >>>>>>>
> > > > > >>>>>>> For a given supported resolution for an input frame, the Input
> > > > > >>>>>>> Feeder, Bayer Down Scaling and GDC blocks should be configured with
> > > > > >>>>>>> the supported resolutions. This information can be obtained by
> > > > > >>>>>>> looking at the following IPU3 ISP configuration table for ov5670
> > > > > >>>>>>> sensor.
> > > > > >>>>>>>
> > > > > >>>>>>> https://chromium.googlesource.com/chromiumos/overlays/board-overlays
> > > > > >>>>>>> /+/master/baseboard-poppy/media-libs/cros-camera-hal-configs-poppy/
> > > > > >>>>>>> files/gcss/graph_settings_ov5670.xml
> > > > > >>>>>>>
> > > > > >>>>>>> For the ov5670 example, for an input frame with a resolution of
> > > > > >>>>>>> 2592x1944 (which is input to the ImgU subdev pad 0), the
> > > > > >>>>>>> corresponding resolutions for input feeder, BDS and GDC are
> > > > > >>>>>>> 2592x1944, 2592x1944 and 2560x1920 respectively.
> > > > > >>>>>>
> > > > > >>>>>> How is the GDC output resolution computed from the input resolution ?
> > > > > >>>>>> Does the GDC always consume 32 columns and 22 lines ?
> > > > > >>>>
> > > > > >>>> All the intermediate resolutions in the pipeline are determined by the
> > > > > >>>> actual use case, in other word determined by the IMGU input
> > > > > >>>> resolution(sensor output) and the final output and viewfinder
> > > > > >>>> resolution. BDS mainly do Bayer downscaling, it has limitation that the
> > > > > >>>> downscaling factor must be a value a integer multiple of 1/32.
> > > > > >>>> GDC output depends on the input and width should be x8 and height x4
> > > > > >>>> alignment.
> > > > > >>>
> > > > > >>> Thank you for the information. This will need to be captured in the
> > > > > >>> documentation, along with information related to how each block in the
> > > > > >>> hardware pipeline interacts with the image size. It should be possible
> > > > > >>> for a developer to compute the output and viewfinder resolutions based
> > > > > >>> on the parameters of the image processing algorithms just with the
> > > > > >>> information contained in the driver documentation.
> > > > > >>>
> > > > > >>>>>>> The following steps prepare the ImgU ISP pipeline for the image
> > > > > >>>>>>> processing.
> > > > > >>>>>>>
> > > > > >>>>>>> 1. The ImgU V4L2 subdev data format should be set by using the
> > > > > >>>>>>> VIDIOC_SUBDEV_S_FMT on pad 0, using the GDC width and height
> > > > > >>>>>>> obtained
> > > > > >>>>>>> above.
> > > > > >>>>>>
> > > > > >>>>>> If I understand things correctly, the GDC resolution is the pipeline
> > > > > >>>>>> output resolution. Why is it configured on pad 0 ?
> > > > > >>>>
> > > > > >>>> We see the GDC output resolution as the input of output system, the
> > > > > >>>> sink pad format is used for output and viewfinder resolutions.
> > > > > >>>
> > > > > >>> The ImgU subdev is supposed to represent the ImgU. Pad 0 should thus be
> > > > > >>> the ImgU input, the format configured there should correspond to the
> > > > > >>> format on the connected video node, and should thus be the sensor
> > > > > >>> format. You can then use the crop and compose rectangles on pad 0, along
> > > > > >>> with the format, crop and compose rectangles on the output and
> > > > > >>> viewfinder pads, to configure the device. This should be fixed in the
> > > > > >>> driver, and the documentation should then be updated accordingly.
> > > > > >>
> > > > > >> Hi, Laurent,
> > > > > >>
> > > > > >> Thanks for your review.
> > > > > >>
> > > > > >> I think it make sense for me that using Pad 0 as the ImgU input(IF).
> > > > > >> However, I prefer using the 2 source pads for output and viewfinder.
> > > > > >> It makes more sense because the output and viewfinder are independent
> > > > > >> output.
> > > > > >>
> > > > > >> The whole pipeline in ImgU looks like:
> > > > > >> IF --> BDS --> GDC ---> OUTPUT
> > > > > >>                   |-----> VF
> > > > > >>
> > > > > >> The BDS is used to do Bayer downscaling and GDC can do cropping.
> > > > > >
> > > > > > Does this mean that the main output and the viewfinder output share the
> > > > > > same scaler, and that the only difference in size between the two outputs
> > > > > > is solely due to cropping ?
> > > > >
> > > > > Laurent,
> > > > > No, output only can do crop and viewfinder support crop and scaling, they
> > > > > share same input.
> > > >
> > > > Then you can't support this with a single subdev for the ImgU, you need at
> > > > least two subdevs. I can offer more guidance, but I'll need more information
> > > > about the GDC.
> > >
> > > While the current documentation only defines the functionality of the
> > > compose target for sink pads, there are a few sensor drivers supporting it
> > > on source pads already. Some drivers such as the OMAP3 ISP also use the
> > > format on source pads to configure scaling.
> > >
> > > The current API certainly allows exposing the compose rectangle also on the
> > > source pads, but to make that generic we'd need to amend the API to tell in
> > > which order these steps take place. In the meantime the behaviour remains
> > > device specific.
> > >
> >
> > My understanding is that what is currently missing is the support
> > for viewfinder's ability to scale, as the scaler should get
> > programmed by configuring a composing rectangle on a source pad which
> > is not supported by the V4L2 APIs at the moment. Is my understanding correct?
> >
> > As the composing rectangle is set for both 'output' and 'viewfinder'
> > through the image format sizes configured on the first sink pad (*),
> > the viewfinder output is obtained by cropping-only to the image format
> > sizes configured on source pad number 3 (though SUBDEV_S_FMT not through
> > SUBDEV_S_SELECTION, as SUBDEV_S_SELECTION is only allowed on sink pad
> > 0 in the driver: see "ipu3_subdev_set_selection()").
> >
> > As you mentioned "device specific behaviour", what is the intended one
> > for the ipu3? I assumed the viewfinder scaling/cropping was configured
> > on the 'viewfinder' video device node, through the VIDIOC_S_SELECTION
> > ioctl, but looking at the code, that doesn't seem to be listed as
> > supported in "ipu3_v4l2_ioctl_ops".
> >
> > How am I supposed to configure scaling on the viewfinder output? Would
> > adding support for crop/compose to the 'output' and 'viewfinder' video
> > devices be supported by the V4L2 APIs? That would work with the single
> > subdevice model that is currently implemented in this patches...
>
> Isn't this what the driver actually implements? My understanding was
> that the format on the VF video node determined the scaling settings,
> based on the source pad.
>

I might surely be wrong, but VIDIOC_S_SELECTION seems not to be
supported in the "ipu3_v4l2_ioctl_ops" list.

So we can just confiure cropping sizes on the source pad number 3 of
the 'imgu' entity, and set the same sizes on the video device node
that represents the VF output.

Inspecting the images, and reading again the long mail thread, it
seems to me that the imgu perform composing internally, based on the
GDC output dimensions and the required VF ones, to maintain the field
of view.

I cannot find any link to post here to Bing Bu's reply to Sakari on
this, but seems like this discussion happened already, and my
understanding is that composing on VF cannot be set from user, but
calculated by the imgu internally. Sakari, Bing Bu, is that the
current state?

Thanks
   j

------------------------------------------------------------------------------
Pasting down here the relevan bits from Bing Bu's and Sakari's
exchange from "Wed, 14 Nov 2018 15:02:37 +0800" which I cannot find a
suitable link to to paste here:

>>>>>>>> 	pad3: Source
>>>>>>>> 		[fmt:UYVY8_2X8/1920x1080 field:none colorspace:unknown]
>>>>>>>> 		-> "ipu3-imgu 0 viewfinder":0 []
>>>>>>> Are there other differences between output and viewfinder?
>>>>>> output and viewfinder are the main and secondary output of output system.
>>>>>> 'main' output is not allowed to be scaled, only support crop. secondary
>>>>>> output 'viewfinder'
>>>>>> can support both cropping and scaling. User can select different nodes
>>>>>> to use
>>>>>> as preview and capture flexibly based on the actual use cases.
>>>>> If there's scaling to be configured, I'd expect to see the COMPOSE target
>>>>> supported.
>>>> Actually the viewfinder is the result of scaling, that means you can not
>>>> do more scaling.
>>> How do you configure the scaling of the viewfinder currently?
>> We consider that the viewfinder as a secondary output, and set the format by
>> subdev set_fmt() directly and all pads formats will be used to find
>> binary and
>> build pipeline.
> Ok.
>
> Could you instead use the compose target to configure the scaling? Setting
> the format on the source pad would have no effect.
Hi, Sakari,

For the secondary output (viewfinder), it support both cropping and
scaling, in order
to keep the aspect ratio, system will do [crop --> compose], sounds like
it should
have 2 selection targets, but firmware/driver did not provide clear
interfaces to allow
user to configure the cropping, driver calculate the scaler and cropping
parameters
based on the output-system input and output resolution to keep aspect ratio
and field of view. I think it is more succinct to set the actual output
by set format
instead of using selection targets.
------------------------------------------------------------------------------

--6hxexlgl4nmo6gx3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEtcQ9SICaIIqPWDjAcjQGjxahVjwFAlxUGaIACgkQcjQGjxah
Vjxg1hAAlDIQ6AfDlbqyxQkyH/bdBgUCbJmY+flfWNx0RlU/gn5BYOZUhj8CsanA
4ZSSelZNmK7JrdJ67ih2x2/KdZ39sUygON+D3EGTNLv7tzqjZnV10ZGn9kfdsS+I
wMer1jTcHBs8NUFfz8CxZNnDzv2W01CtUwzunD0wkEeFJIHVHYxa4wAsyXHD6O5H
ZKYKk0BeVOiSCcmF8YfTRo5ssWy3mseLFh8kzRZTurrtqMst0XHT65o72N/Tdy31
kvGSYeDdmTddXBKiDqBVo66jH8v+LZu7x4gjH65TUCUnFNOv1Tkf3AIfUB1fKLWr
/wazIoKKH/rOS94aY7Hb42FWiDDxM8eSQgOrp7jziwdjNwqsppwfv6MmRmU0mzZi
CMrD46fiiBXPxK0lox/VJxFrDK61rL3ScUFhVhy8ftnICpgaxPB8n117++7EOhXK
Gv3k0ZIeswreHUMFnH3+nmjr8lq78t2P2Wg+IMUO1dzkTfrweY1+nsFopLA78OgP
sJcTQ/qAtRANEM+tm9ExXD1BYpwwzrno7FjU2w7te9hER7iqKfP6rW3+G+1qPiOm
44z/mIMHOS3ShVxjfFaJAAnnNmtL8DSwr/pw2ZWMm2Ag8M1sRWR0ErvuV6rFxxfO
K7OEqe1FJ31W6HzIXY8aRWmC8y5JUXXCanxa9MmY+kf3+MwuH/M=
=4QPe
-----END PGP SIGNATURE-----

--6hxexlgl4nmo6gx3--
