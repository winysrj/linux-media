Return-Path: <SRS0=yFxv=OW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,T_MIXED_ES,
	URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45B0EC65BAE
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 10:50:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 01DCB2086D
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 10:50:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 01DCB2086D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728537AbeLMKuZ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 13 Dec 2018 05:50:25 -0500
Received: from mga02.intel.com ([134.134.136.20]:49734 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727403AbeLMKuZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Dec 2018 05:50:25 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Dec 2018 02:50:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,348,1539673200"; 
   d="scan'208";a="301847477"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by fmsmga006.fm.intel.com with ESMTP; 13 Dec 2018 02:50:19 -0800
Received: by paasikivi.fi.intel.com (Postfix, from userid 1000)
        id 2BB7B204CC; Thu, 13 Dec 2018 12:50:19 +0200 (EET)
Date:   Thu, 13 Dec 2018 12:50:19 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     Yong Zhi <yong.zhi@intel.com>, linux-media@vger.kernel.org,
        tfiga@chromium.org, mchehab@kernel.org, hans.verkuil@cisco.com,
        rajmohan.mani@intel.com, jian.xu.zheng@intel.com,
        jerry.w.hu@intel.com, tuukka.toivonen@intel.com,
        tian.shu.qiu@intel.com, bingbu.cao@intel.com
Subject: Re: [PATCH v7 02/16] doc-rst: Add Intel IPU3 documentation
Message-ID: <20181213105018.6u7xev7z5h72kwuc@paasikivi.fi.intel.com>
References: <1540851790-1777-1-git-send-email-yong.zhi@intel.com>
 <10308698.8BjB4BRxet@avalon>
 <20181213093825.zgtybcr5q4hwvveg@paasikivi.fi.intel.com>
 <9718384.tiSa6BznqW@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9718384.tiSa6BznqW@avalon>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Laurent,

Thanks for the review.

On Thu, Dec 13, 2018 at 12:41:36PM +0200, Laurent Pinchart wrote:
> Hi Sakari,
> 
> On Thursday, 13 December 2018 11:38:26 EET Sakari Ailus wrote:
> > Hi Laurent,
> > 
> > I'm sending a separate patch to address the comments.
> > 
> > On Fri, Nov 30, 2018 at 12:50:36AM +0200, Laurent Pinchart wrote:
> > > On Tuesday, 30 October 2018 00:22:56 EET Yong Zhi wrote:
> > >> From: Rajmohan Mani <rajmohan.mani@intel.com>
> > >> 
> > >> This patch adds the details about the IPU3 Imaging Unit driver.
> > > 
> > > Strictly speaking this documents both the CIO2 and the IMGU. As they're
> > > handled by two separate drivers, should they be split in two separate
> > > files ? If you prefer keeping them together you should update the commit
> > > message accordingly. I would in that case also split the documentation in
> > > a CIO2 and a IMGU section in the file, instead of mixing them.
> > 
> > I'm keeping it in a single document for now. In practice these devices
> > always come together as neither is really usable without the other.
> 
> But they're still two separate devices. Splitting the documentation would 
> clarify which part is associated with each device. CIO2 and ImgU instructions 
> are currently interleaved and that's very confusing. If you really want to 
> keep everything in one file, the CIO2 and ImgU parts should be deinterleaved, 
> and the CIO2 should come first.

That's implemented in the patch I submitted.

> 
> > >> Change-Id: I560cecf673df2dcc3ec72767cf8077708d649656
> > > 
> > > The Change-Id: tag isn't suitable for mainline, you can drop it.
> > 
> > Fixed.
> > 
> > >> Signed-off-by: Rajmohan Mani <rajmohan.mani@intel.com>
> > >> ---
> > >> 
> > >>  Documentation/media/v4l-drivers/index.rst |   1 +
> > >>  Documentation/media/v4l-drivers/ipu3.rst  | 326 ++++++++++++++++++++++++
> > >>  2 files changed, 327 insertions(+)
> > >>  create mode 100644 Documentation/media/v4l-drivers/ipu3.rst
> 
> [snip]
> 
> > >> diff --git a/Documentation/media/v4l-drivers/ipu3.rst
> > >> b/Documentation/media/v4l-drivers/ipu3.rst new file mode 100644
> > >> index 0000000..045bf42
> > >> --- /dev/null
> > >> +++ b/Documentation/media/v4l-drivers/ipu3.rst
> 
> [snip]
> 
> > >> +Media controller
> > >> +----------------
> > >> +
> > >> +The media device interface allows to configure the ImgU links, which
> > >> defines +the behavior of the IPU3 firmware.
> > > 
> > > s/defines/define/ or possibly better s/defines/control/
> > 
> > I'm removing the section as the binary is selected using a control in the
> > current version. I'm adding this instead:
> > 
> > Firmware binary selection
> > -------------------------
> > 
> > The firmware binary is selected using the V4L2_CID_INTEL_IPU3_MODE,
> > currently defined in drivers/staging/media/ipu3/include/intel-ipu3.h .
> > "VIDEO" and "STILL" modes are available.
> 
> Do we need to expose the fact that they use different firmwares ? Or should we 
> instead document the two modes of operation, and explain that they need to be 
> selected before anything else ? In any case modes need to be documented. 

I agree. I'll add this to the TODO file.

> Interestingly enough, the driver code includes
> 
> enum ipu3_css_pipe_id {
>         IPU3_CSS_PIPE_ID_PREVIEW,
>         IPU3_CSS_PIPE_ID_COPY,
>         IPU3_CSS_PIPE_ID_VIDEO,
>         IPU3_CSS_PIPE_ID_CAPTURE,
>         IPU3_CSS_PIPE_ID_YUVPP,
>         IPU3_CSS_PIPE_ID_ACC,
>         IPU3_CSS_PIPE_ID_NUM
> };
> 
> but seems to only support the video and capture modes.

I wonder if the others exist in the firmware binary. Other devices with
e.g. integrated CSI-2 receivers have been supported using the same source
code base I presume.

> 
> > >> +
> > >> +Device operation
> > >> +----------------
> > >> +
> > >> +With IPU3, once the input video node ("ipu3-imgu 0/1":0,
> > >> +in <entity>:<pad-number> format) is queued with buffer (in packed raw
> > >> bayer
> > > 
> > > s/bayer/Bayer/
> > 
> > Fixed in the entire file.
> > 
> > >> +format), IPU3 ISP starts processing the buffer and produces the video
> > > 
> > > s/IPU3 ISP/the IPU3 ISP/
> > > 
> > > This is the first time you mention an ISP. Should the term ISP be replaced
> > > by ImgU here and below ? I'm fine keeping it, but it should then be
> > > defined in the introduction, in particular with an explanation of the
> > > difference between ImgU and ISP.
> > 
> > I replaced IPU3 with ImgU in this section.
> > 
> > >> output +in YUV format and statistics output on respective output nodes.
> > >> The driver +is expected to have buffers ready for all of parameter,
> > >> output and +statistics nodes, when input video node is queued with
> > >> buffer.
> > > 
> > > Why is that, shouldn't the driver wait for all necessary buffers to be
> > > ready before processing ?
> > 
> > Not all are mandatory.
> 
> Which ones are mandatory, and which ones are not ? V4L2 doesn't enforce buffer 
> queuing order for M2M devices, it's a very bad idea to do so here. It would 
> make usage of the driver impossible with separate unsynchronized processes for 
> different queues (which is typically the case when using command line test 
> tools).

How about this:

- Document different operation modes, and which buffer queues are relevant
  in each mode. To process an image, which queues require a buffer an in
  which ones is it optional?

> 
> > >> +At a minimum, all of input, main output, 3A statistics and viewfinder
> > >> +video nodes should be enabled for IPU3 to start image processing.
> > > 
> > > If they all need to be enabled, shouldn't the respective links be ENABLED
> > > and IMMUTABLE ?
> > 
> > Yes.
> 
> Could you please capture this in the TODO file ?
> 
> [snip]
> 
> > >> +Configuring the Intel IPU3
> > >> +==========================
> > >> +
> > >> +The Intel IPU3 ImgU driver supports V4L2 interface. Using V4L2 ioctl
> > >> calls, +the ISP can be configured and enabled.
> > >> +
> > >> +The IPU3 ImgU pipelines can be configured using media controller APIs,
> > >> +defined at :ref:`media_controller`.
> > >> +
> > >> +Capturing frames in raw bayer format
> > >> +------------------------------------
> > >> +
> > >> +IPU3 MIPI CSI2 receiver is used to capture frames (in packed raw bayer
> > >> +format) from the raw sensors connected to the CSI2 ports. The captured
> > >> +frames are used as input to the ImgU driver.
> > >> +
> > >> +Image processing using IPU3 ImgU requires tools such as v4l2n [#f1]_,
> > > 
> > > I would drop v4l2n from the documentation as it's not maintained and is
> > > not functional (in particular it doesn't implement MPLANE support which
> > > the driver requires).
> > 
> > Ack. I'm leaving the command plus the reference to v4l2n, this might
> > contain information useful still.
> 
> Who will address this TODO item ? :-)

I don't think we need to name anyone at this point. Presumably someone from
Intel.

> 
> > >> +raw2pnm [#f1]_, and yavta [#f2]_ due to the following unique
> > >> requirements
> > >> +and / or features specific to IPU3.
> 
> [snip]
> 
> > >> +Processing the image in raw bayer format
> > >> +----------------------------------------
> > >> +
> > >> +Configuring ImgU V4L2 subdev for image processing
> > >> +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> [snip]
> 
> > >> +RAW bayer frames go through the following ISP pipeline HW blocks to
> > >> +have the processed image output to the DDR memory.
> > >> +
> > >> +RAW bayer frame -> Input Feeder -> Bayer Down Scaling (BDS) ->
> > >> Geometric +Distortion Correction (GDC) -> DDR
> > > 
> > > A more detailed block diagram, with the other blocks included, should be
> > > added to the ImgU description above. Each block should have a short
> > > description of its purpose.
> > 
> > I think we have one in conjunction with the parameter format description.
> 
> You're right. As mentioned in my review for that patch, I think it should be 
> moved to this document.

Fair enough. Let's polish this more later.

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
