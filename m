Return-Path: <SRS0=ymVG=QE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DDD5C282C8
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 09:21:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA2CB21736
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 09:21:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbfA1JVc (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 28 Jan 2019 04:21:32 -0500
Received: from mga14.intel.com ([192.55.52.115]:58642 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726611AbfA1JVc (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Jan 2019 04:21:32 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Jan 2019 01:21:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,533,1539673200"; 
   d="scan'208";a="139361125"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by fmsmga004.fm.intel.com with ESMTP; 28 Jan 2019 01:21:30 -0800
Received: by paasikivi.fi.intel.com (Postfix, from userid 1000)
        id CFE8820609; Mon, 28 Jan 2019 11:21:29 +0200 (EET)
Date:   Mon, 28 Jan 2019 11:21:29 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Hans Verkuil <hverkuil@xs4all.nl>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFC PATCH] videodev2.h: introduce VIDIOC_DQEXTEVENT
Message-ID: <20190128092128.3ir4pp66wb3aujf5@paasikivi.fi.intel.com>
References: <700eff44-b903-24d0-ef41-e634e643a200@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <700eff44-b903-24d0-ef41-e634e643a200@xs4all.nl>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Hans,

Thanks for the patch.

On Sat, Jan 26, 2019 at 12:06:19PM +0100, Hans Verkuil wrote:
> This patch adds an extended version of VIDIOC_DQEVENT that:
> 
> 1) is Y2038 safe by using a __u64 for the timestamp
> 2) needs no compat32 conversion code
> 3) is able to handle control events from 64-bit control types
>    by changing the type of the minimum, maximum, step and default_value
>    field to __u64
> 
> All drivers and frameworks will be using this, and v4l2-ioctl.c would be the
> only place where the old event ioctl and structs are used.
> 
> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> ---
> Please let me know if there are additional requests for such a new ioctl.
> 
> Note that I am using number 104 for the ioctl, but perhaps it would be better to
> use an unused ioctl number like 1 or 3. There are quite a few holes in the
> ioctl numbers. We currently have only 82 ioctls, yet are up to ioctl number 103.
> ---
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index 9a920f071ff9..969e775b8c25 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -2303,6 +2303,37 @@ struct v4l2_event {
>  	__u32				reserved[8];
>  };
> 
> +struct v4l2_event_ext_ctrl {
> +	__u32 changes;
> +	__u32 type;
> +	union {
> +		__s32 value;
> +		__s64 value64;
> +	};
> +	__s64 minimum;
> +	__s64 maximum;
> +	__s64 step;
> +	__s64 default_value;
> +	__u32 flags;
> +};
> +
> +struct v4l2_ext_event {
> +	__u32				type;
> +	__u32				id;
> +	union {
> +		struct v4l2_event_vsync		vsync;
> +		struct v4l2_event_ext_ctrl	ctrl;
> +		struct v4l2_event_frame_sync	frame_sync;
> +		struct v4l2_event_src_change	src_change;
> +		struct v4l2_event_motion_det	motion_det;
> +		__u8				data[64];
> +	} u;

If I'd change something in the event IOCTL, I'd probably put the reserved
fields here. That'd allow later taking some for the use of the event data
if needed.

I might also increase the size of the event data. 64 bytes is not that
much. But you indeed end up copying it around all the time... So it's a
trade-off.

> +	__u64				timestamp;
> +	__u32				pending;
> +	__u32				sequence;
> +	__u32				reserved[8];
> +};
> +
>  #define V4L2_EVENT_SUB_FL_SEND_INITIAL		(1 << 0)
>  #define V4L2_EVENT_SUB_FL_ALLOW_FEEDBACK	(1 << 1)
> 
> @@ -2475,6 +2506,7 @@ struct v4l2_create_buffers {
>  #define VIDIOC_DBG_G_CHIP_INFO  _IOWR('V', 102, struct v4l2_dbg_chip_info)
> 
>  #define VIDIOC_QUERY_EXT_CTRL	_IOWR('V', 103, struct v4l2_query_ext_ctrl)
> +#define	VIDIOC_DQEXTEVENT	 _IOR('V', 104, struct v4l2_ext_event)

How do you plan to name the new buffer handling IOCTLs? I.e. with or
without underscores around "EXT"?

> 
>  /* Reminder: when adding new ioctls please add support for them to
>     drivers/media/v4l2-core/v4l2-compat-ioctl32.c as well! */

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
