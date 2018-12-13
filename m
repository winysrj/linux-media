Return-Path: <SRS0=yFxv=OW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,T_MIXED_ES,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C080C65BAE
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 10:40:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D13620811
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 10:40:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="Cheby6Fu"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3D13620811
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ideasonboard.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727637AbeLMKkx (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 13 Dec 2018 05:40:53 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:44576 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727403AbeLMKkx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Dec 2018 05:40:53 -0500
Received: from avalon.localnet (dfj612ybrt5fhg77mgycy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:2e86:4862:ef6a:2804])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 25C45549;
        Thu, 13 Dec 2018 11:40:50 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1544697650;
        bh=hpPZif3gkmBip0KzcKRLsuu0aRB4SpiFAIkwYLs7dOM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cheby6FuQAVj5KAe9AdknIYbHMOzLafs7g8aAWKAFDNPOxE5CuVUdiLSd3AN+YS7j
         jWXj9wpiXkIcc39vpKn+nB3olTs2C5gMiYQew1XnYDqU08Fk1VI3dAL7jlkCSah17Q
         fBovReVWe9okW4jJ+Tk2w6IhBMa++cdXmv072HPc=
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Sakari Ailus <sakari.ailus@linux.intel.com>
Cc:     Yong Zhi <yong.zhi@intel.com>, linux-media@vger.kernel.org,
        tfiga@chromium.org, mchehab@kernel.org, hans.verkuil@cisco.com,
        rajmohan.mani@intel.com, jian.xu.zheng@intel.com,
        jerry.w.hu@intel.com, tuukka.toivonen@intel.com,
        tian.shu.qiu@intel.com, bingbu.cao@intel.com
Subject: Re: [PATCH v7 02/16] doc-rst: Add Intel IPU3 documentation
Date:   Thu, 13 Dec 2018 12:41:36 +0200
Message-ID: <9718384.tiSa6BznqW@avalon>
Organization: Ideas on Board Oy
In-Reply-To: <20181213093825.zgtybcr5q4hwvveg@paasikivi.fi.intel.com>
References: <1540851790-1777-1-git-send-email-yong.zhi@intel.com> <10308698.8BjB4BRxet@avalon> <20181213093825.zgtybcr5q4hwvveg@paasikivi.fi.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Sakari,

On Thursday, 13 December 2018 11:38:26 EET Sakari Ailus wrote:
> Hi Laurent,
> 
> I'm sending a separate patch to address the comments.
> 
> On Fri, Nov 30, 2018 at 12:50:36AM +0200, Laurent Pinchart wrote:
> > On Tuesday, 30 October 2018 00:22:56 EET Yong Zhi wrote:
> >> From: Rajmohan Mani <rajmohan.mani@intel.com>
> >> 
> >> This patch adds the details about the IPU3 Imaging Unit driver.
> > 
> > Strictly speaking this documents both the CIO2 and the IMGU. As they're
> > handled by two separate drivers, should they be split in two separate
> > files ? If you prefer keeping them together you should update the commit
> > message accordingly. I would in that case also split the documentation in
> > a CIO2 and a IMGU section in the file, instead of mixing them.
> 
> I'm keeping it in a single document for now. In practice these devices
> always come together as neither is really usable without the other.

But they're still two separate devices. Splitting the documentation would 
clarify which part is associated with each device. CIO2 and ImgU instructions 
are currently interleaved and that's very confusing. If you really want to 
keep everything in one file, the CIO2 and ImgU parts should be deinterleaved, 
and the CIO2 should come first.

> >> Change-Id: I560cecf673df2dcc3ec72767cf8077708d649656
> > 
> > The Change-Id: tag isn't suitable for mainline, you can drop it.
> 
> Fixed.
> 
> >> Signed-off-by: Rajmohan Mani <rajmohan.mani@intel.com>
> >> ---
> >> 
> >>  Documentation/media/v4l-drivers/index.rst |   1 +
> >>  Documentation/media/v4l-drivers/ipu3.rst  | 326 ++++++++++++++++++++++++
> >>  2 files changed, 327 insertions(+)
> >>  create mode 100644 Documentation/media/v4l-drivers/ipu3.rst

[snip]

> >> diff --git a/Documentation/media/v4l-drivers/ipu3.rst
> >> b/Documentation/media/v4l-drivers/ipu3.rst new file mode 100644
> >> index 0000000..045bf42
> >> --- /dev/null
> >> +++ b/Documentation/media/v4l-drivers/ipu3.rst

[snip]

> >> +Media controller
> >> +----------------
> >> +
> >> +The media device interface allows to configure the ImgU links, which
> >> defines +the behavior of the IPU3 firmware.
> > 
> > s/defines/define/ or possibly better s/defines/control/
> 
> I'm removing the section as the binary is selected using a control in the
> current version. I'm adding this instead:
> 
> Firmware binary selection
> -------------------------
> 
> The firmware binary is selected using the V4L2_CID_INTEL_IPU3_MODE,
> currently defined in drivers/staging/media/ipu3/include/intel-ipu3.h .
> "VIDEO" and "STILL" modes are available.

Do we need to expose the fact that they use different firmwares ? Or should we 
instead document the two modes of operation, and explain that they need to be 
selected before anything else ? In any case modes need to be documented. 
Interestingly enough, the driver code includes

enum ipu3_css_pipe_id {
        IPU3_CSS_PIPE_ID_PREVIEW,
        IPU3_CSS_PIPE_ID_COPY,
        IPU3_CSS_PIPE_ID_VIDEO,
        IPU3_CSS_PIPE_ID_CAPTURE,
        IPU3_CSS_PIPE_ID_YUVPP,
        IPU3_CSS_PIPE_ID_ACC,
        IPU3_CSS_PIPE_ID_NUM
};

but seems to only support the video and capture modes.

> >> +
> >> +Device operation
> >> +----------------
> >> +
> >> +With IPU3, once the input video node ("ipu3-imgu 0/1":0,
> >> +in <entity>:<pad-number> format) is queued with buffer (in packed raw
> >> bayer
> > 
> > s/bayer/Bayer/
> 
> Fixed in the entire file.
> 
> >> +format), IPU3 ISP starts processing the buffer and produces the video
> > 
> > s/IPU3 ISP/the IPU3 ISP/
> > 
> > This is the first time you mention an ISP. Should the term ISP be replaced
> > by ImgU here and below ? I'm fine keeping it, but it should then be
> > defined in the introduction, in particular with an explanation of the
> > difference between ImgU and ISP.
> 
> I replaced IPU3 with ImgU in this section.
> 
> >> output +in YUV format and statistics output on respective output nodes.
> >> The driver +is expected to have buffers ready for all of parameter,
> >> output and +statistics nodes, when input video node is queued with
> >> buffer.
> > 
> > Why is that, shouldn't the driver wait for all necessary buffers to be
> > ready before processing ?
> 
> Not all are mandatory.

Which ones are mandatory, and which ones are not ? V4L2 doesn't enforce buffer 
queuing order for M2M devices, it's a very bad idea to do so here. It would 
make usage of the driver impossible with separate unsynchronized processes for 
different queues (which is typically the case when using command line test 
tools).

> >> +At a minimum, all of input, main output, 3A statistics and viewfinder
> >> +video nodes should be enabled for IPU3 to start image processing.
> > 
> > If they all need to be enabled, shouldn't the respective links be ENABLED
> > and IMMUTABLE ?
> 
> Yes.

Could you please capture this in the TODO file ?

[snip]

> >> +Configuring the Intel IPU3
> >> +==========================
> >> +
> >> +The Intel IPU3 ImgU driver supports V4L2 interface. Using V4L2 ioctl
> >> calls, +the ISP can be configured and enabled.
> >> +
> >> +The IPU3 ImgU pipelines can be configured using media controller APIs,
> >> +defined at :ref:`media_controller`.
> >> +
> >> +Capturing frames in raw bayer format
> >> +------------------------------------
> >> +
> >> +IPU3 MIPI CSI2 receiver is used to capture frames (in packed raw bayer
> >> +format) from the raw sensors connected to the CSI2 ports. The captured
> >> +frames are used as input to the ImgU driver.
> >> +
> >> +Image processing using IPU3 ImgU requires tools such as v4l2n [#f1]_,
> > 
> > I would drop v4l2n from the documentation as it's not maintained and is
> > not functional (in particular it doesn't implement MPLANE support which
> > the driver requires).
> 
> Ack. I'm leaving the command plus the reference to v4l2n, this might
> contain information useful still.

Who will address this TODO item ? :-)

> >> +raw2pnm [#f1]_, and yavta [#f2]_ due to the following unique
> >> requirements
> >> +and / or features specific to IPU3.

[snip]

> >> +Processing the image in raw bayer format
> >> +----------------------------------------
> >> +
> >> +Configuring ImgU V4L2 subdev for image processing
> >> +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

[snip]

> >> +RAW bayer frames go through the following ISP pipeline HW blocks to
> >> +have the processed image output to the DDR memory.
> >> +
> >> +RAW bayer frame -> Input Feeder -> Bayer Down Scaling (BDS) ->
> >> Geometric +Distortion Correction (GDC) -> DDR
> > 
> > A more detailed block diagram, with the other blocks included, should be
> > added to the ImgU description above. Each block should have a short
> > description of its purpose.
> 
> I think we have one in conjunction with the parameter format description.

You're right. As mentioned in my review for that patch, I think it should be 
moved to this document.

> >> +The ImgU V4L2 subdev has to be configured with the supported
> >> resolutions +in all the above HW blocks, for a given input resolution.
> >> +
> >> +For a given supported resolution for an input frame, the Input Feeder,
> >> +Bayer Down Scaling and GDC blocks should be configured with the
> >> supported +resolutions. This information can be obtained by looking at
> >> the following +IPU3 ISP configuration table.
> > 
> > Does this mean that the ImgU will not operate properly when exercised
> > through the MC and V4L2 only without configuration of the internal blocks
> > through the processing parameters device node ?
> 
> I need to let Raj and Yong to answer that. My understanding is the default
> parameters should be usable. If they're not, that needs to be addressed.

That's my assumption too :-)

> >> +https://chromium.googlesource.com/chromiumos/overlays/board-overlays/+/
> >> master
> >> +
> >> +Under
> >> baseboard-poppy/media-libs/arc-camera3-hal-configs-poppy/files/gcss
> >> +directory, graph_settings_ov5670.xml can be used as an example.
> > 
> > The directory name is incorrect.
> 
> Fixed.
> 
> >> +The following steps prepare the ImgU ISP pipeline for the image
> >> processing.
> >> +
> >> +1. The ImgU V4L2 subdev data format should be set by using the
> >> +VIDIOC_SUBDEV_S_FMT on pad 0, using the GDC width and height obtained
> >> above.
> >> +
> >> +2. The ImgU V4L2 subdev cropping should be set by using the
> >> +VIDIOC_SUBDEV_S_SELECTION on pad 0, with V4L2_SEL_TGT_CROP as the
> >> target,
> >> +using the input feeder height and width.
> >> +
> >> +3. The ImgU V4L2 subdev composing should be set by using the
> >> +VIDIOC_SUBDEV_S_SELECTION on pad 0, with V4L2_SEL_TGT_COMPOSE as the
> >> target, +using the BDS height and width.
> > 
> > How the format and selection rectangles related to the internal processing
> > blocks should also be explained in more details.
> 
> To be added later.

As it will likely require changes in the driver, I'm OK with that.

> >> +For the ov5670 example, for an input frame with a resolution of
> >> 2592x1944
> >> +(which is input to the ImgU subdev pad 0), the corresponding
> >> resolutions
> >> +for input feeder, BDS and GDC are 2592x1944, 2592x1944 and 2560x1920
> >> +respectively.
> > 
> > Why ? How is that computed ? If my input resolution was different, how
> > would I compute the other resolutions ?
> 
> Ditto.
> 
> >> +Once this is done, the received raw bayer frames can be input to the
> >> ImgU
> >> +V4L2 subdev as below, using the open source application v4l2n.
> >> +
> >> +For an image captured with 2592x1944 [#f4]_ resolution, with desired
> >> output +resolution as 2560x1920 and viewfinder resolution as 2560x1920,
> >> the following +v4l2n command can be used. This helps process the raw
> >> bayer frames and +produces the desired results for the main output
> >> image and the viewfinder +output, in NV12 format.
> >> +
> >> +v4l2n --pipe=4 --load=/tmp/frame-#.bin --open=/dev/video4
> >> +--fmt=type:VIDEO_OUTPUT_MPLANE,width=2592,height=1944,pixelformat=0X473
> >> 3706 9 +--reqbufs=type:VIDEO_OUTPUT_MPLANE,count:1 --pipe=1
> >> --output=/tmp/frames.out +--open=/dev/video5
> >> +--fmt=type:VIDEO_CAPTURE_MPLANE,width=2560,height=1920,pixelformat=NV12
> >> +--reqbufs=type:VIDEO_CAPTURE_MPLANE,count:1 --pipe=2
> >> --output=/tmp/frames.vf +--open=/dev/video6
> >> +--fmt=type:VIDEO_CAPTURE_MPLANE,width=2560,height=1920,pixelformat=NV12
> >> +--reqbufs=type:VIDEO_CAPTURE_MPLANE,count:1 --pipe=3 --open=/dev/video7
> >> +--output=/tmp/frames.3A --fmt=type:META_CAPTURE,?
> >> +--reqbufs=count:1,type:META_CAPTURE --pipe=1,2,3,4 --stream=5
> > 
> > You can replace this with four yavta commands.
> 
> Ditto.

[snip]

-- 
Regards,

Laurent Pinchart



