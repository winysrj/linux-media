Return-Path: <SRS0=JQ9q=P6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C407C282C3
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 21:22:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 52D8B20870
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 21:22:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="j/ZQrQxx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726772AbfAVVWd (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 22 Jan 2019 16:22:33 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:56952 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726832AbfAVVWb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Jan 2019 16:22:31 -0500
Received: from pendragon.ideasonboard.com (dfj612yhrgyx302h3jwwy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:ce28:277f:58d7:3ca4])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 31272575;
        Tue, 22 Jan 2019 22:22:29 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1548192149;
        bh=APQjRUOX9EQjSfz+Uli1IyPwRaqCPZjFvDv0TnUeRfk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=j/ZQrQxxjAQYSVKc1hDzkh4Txy7OnIGZ4sEpn4fhwXXlAv0igXMVwi01nRu97RN4r
         ix2vikG87OVF3Okf6DpRpbaAnUWjs4Zgt5mXDzdIBElcqKGgNo9yBI4iMLuGoGCLhS
         dGLGYIkennba1zVGIfiqZD0m154HHwyLPhS5p1+s=
Date:   Tue, 22 Jan 2019 23:22:28 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     "Zhi, Yong" <yong.zhi@intel.com>
Cc:     "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        "tfiga@chromium.org" <tfiga@chromium.org>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>,
        "Hu, Jerry W" <jerry.w.hu@intel.com>,
        "Qiu, Tian Shu" <tian.shu.qiu@intel.com>,
        "hans.verkuil@cisco.com" <hans.verkuil@cisco.com>,
        "mchehab@kernel.org" <mchehab@kernel.org>,
        "Cao, Bingbu" <bingbu.cao@intel.com>
Subject: Re: [PATCH v8 15/17] media: v4l: Add Intel IPU3 meta buffer formats
Message-ID: <20190122212228.GM3264@pendragon.ideasonboard.com>
References: <1544144622-29791-1-git-send-email-yong.zhi@intel.com>
 <1544144622-29791-16-git-send-email-yong.zhi@intel.com>
 <2743727.5LazzqFdDF@avalon>
 <C193D76D23A22742993887E6D207B54D3DB52FDB@ORSMSX106.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <C193D76D23A22742993887E6D207B54D3DB52FDB@ORSMSX106.amr.corp.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Yong,

On Thu, Jan 10, 2019 at 06:35:11PM +0000, Zhi, Yong wrote:
> On Tuesday, December 11, 2018 6:59 AM, Laurent Pinchart wrote:
> > On Friday, 7 December 2018 03:03:40 EET Yong Zhi wrote:
> >> Add IPU3-specific meta formats for processing parameters and 3A
> >> statistics.
> >>
> >>   V4L2_META_FMT_IPU3_PARAMS
> >>   V4L2_META_FMT_IPU3_STAT_3A
> >>
> >> Signed-off-by: Yong Zhi <yong.zhi@intel.com>
> >> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > 
> > My Reviewed-by tag was related to the format part only (v4l2-ioctl.c and
> > videodev2.h) :-) Please see below for more comments about the
> > documentation.
> > 
> >> ---
> >>  Documentation/media/uapi/v4l/meta-formats.rst      |   1 +
> >>  .../media/uapi/v4l/pixfmt-meta-intel-ipu3.rst      | 178 ++++++++++++++++++
> >>  drivers/media/v4l2-core/v4l2-ioctl.c               |   2 +
> >>  include/uapi/linux/videodev2.h                     |   4 +
> >>  4 files changed, 185 insertions(+)
> >>  create mode 100644
> >> Documentation/media/uapi/v4l/pixfmt-meta-intel-ipu3.rst

[snip]

> >> diff --git a/Documentation/media/uapi/v4l/pixfmt-meta-intel-ipu3.rst
> >> b/Documentation/media/uapi/v4l/pixfmt-meta-intel-ipu3.rst new file
> >> mode
> >> 100644
> >> index 000000000000..8cd30ffbf8b8
> >> --- /dev/null
> >> +++ b/Documentation/media/uapi/v4l/pixfmt-meta-intel-ipu3.rst

[snip]

> >> +struct :c:type:`ipu3_uapi_4a_config` saves configurable parameters
> >> +for all
> >> above.
> > 
> > I would write it as "The
> > 
> > By the way why "4a" when the documentation talks about 3A ? Shouldn't the
> > structure be called ipu3_uapi_3a_config ?
> > 
> 
> The 4th "a" refers to the AWB filter response config.

But the automatic algorithms are still automatic white balance,
automatic exposure and automatic focus, right, with
ipu3_uapi_awb_fr_raw_buffer being part of AWB, right ?

> >> +
> >> +.. code-block:: c
> >> +
> >> +	struct ipu3_uapi_stats_3a {
> >> +		struct ipu3_uapi_awb_raw_buffer awb_raw_buffer;
> >> +		struct ipu3_uapi_ae_raw_buffer_aligned
> >> ae_raw_buffer[IPU3_UAPI_MAX_STRIPES];
> >> +		struct ipu3_uapi_af_raw_buffer
> >> af_raw_buffer;
> >> +		struct ipu3_uapi_awb_fr_raw_buffer awb_fr_raw_buffer;
> >> +		struct ipu3_uapi_4a_config stats_4a_config;
> >> +		__u32 ae_join_buffers;
> >> +		__u8 padding[28];
> >> +		struct ipu3_uapi_stats_3a_bubble_info_per_stripe
> >> stats_3a_bubble_per_stripe;
> >> +		struct ipu3_uapi_ff_status stats_3a_status;
> >> +	};
> >>
> >> +.. c:type:: ipu3_uapi_params

[snip]

-- 
Regards,

Laurent Pinchart
