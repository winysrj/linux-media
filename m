Return-Path: <SRS0=tJec=Q3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94535C43381
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 13:34:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E9D12147C
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 13:34:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727844AbfBTNev (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Feb 2019 08:34:51 -0500
Received: from mga01.intel.com ([192.55.52.88]:43726 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726213AbfBTNev (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Feb 2019 08:34:51 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Feb 2019 05:34:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,391,1544515200"; 
   d="scan'208";a="117655726"
Received: from karrer-mobl1.ger.corp.intel.com (HELO kekkonen.fi.intel.com) ([10.252.61.234])
  by orsmga006.jf.intel.com with ESMTP; 20 Feb 2019 05:34:49 -0800
Received: by kekkonen.fi.intel.com (Postfix, from userid 1000)
        id 5C04C21F18; Wed, 20 Feb 2019 15:34:44 +0200 (EET)
Date:   Wed, 20 Feb 2019 15:34:44 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Hans Verkuil <hverkuil@xs4all.nl>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: Re: [RFCv2 PATCH] videodev2.h: introduce VIDIOC_DQ_EXT_EVENT
Message-ID: <20190220133443.hg2n6vjra4gppgno@kekkonen.localdomain>
References: <a28bda76-c8e5-7e93-43a0-0d07844cebf0@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a28bda76-c8e5-7e93-43a0-0d07844cebf0@xs4all.nl>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Hans,

On Tue, Feb 05, 2019 at 02:49:45PM +0100, Hans Verkuil wrote:
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
> I chose to name this DQ_EXT_EVENT since the struct it dequeues is now called
> v4l2_ext_event. This is also consistent with the names of the G/S/TRY_EXT_CTRLS
> ioctls. An alternative could be VIDIOC_DQEXT_EVENT as that would be consistent
> with the lack of _ between DQ and EVENT in the current ioctl. But somehow it
> doesn't look right.
> 
> Changes since v1:
> - rename ioctl from VIDIOC_DQEXTEVENT.
> - move the reserved array up to right after the union: this will allow us to
>   extend the union into the reserved array if we ever need more than 64 bytes
>   for the event payload (suggested by Sakari).
> ---
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index 9a920f071ff9..301e3678bdb0 100644
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
> +	__u32				reserved[8];
> +	__u64				timestamp;
> +	__u32				pending;
> +	__u32				sequence;
> +};

The size of the struct is at the moment 120 bytes. The allocation done by
the kernel is always 128 bytes anyway, and the ext control event above is
just 12 bytes short of the maximum. I'd therefore add two more reserved
fields. That's fine tuning though. The structs look very nice to me.

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

> +
>  #define V4L2_EVENT_SUB_FL_SEND_INITIAL		(1 << 0)
>  #define V4L2_EVENT_SUB_FL_ALLOW_FEEDBACK	(1 << 1)
> 
> @@ -2475,6 +2506,7 @@ struct v4l2_create_buffers {
>  #define VIDIOC_DBG_G_CHIP_INFO  _IOWR('V', 102, struct v4l2_dbg_chip_info)
> 
>  #define VIDIOC_QUERY_EXT_CTRL	_IOWR('V', 103, struct v4l2_query_ext_ctrl)
> +#define	VIDIOC_DQ_EXT_EVENT	 _IOR('V', 104, struct v4l2_ext_event)
> 
>  /* Reminder: when adding new ioctls please add support for them to
>     drivers/media/v4l2-core/v4l2-compat-ioctl32.c as well! */

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
