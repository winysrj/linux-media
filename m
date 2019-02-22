Return-Path: <SRS0=hjs2=Q5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50A60C43381
	for <linux-media@archiver.kernel.org>; Fri, 22 Feb 2019 12:24:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F499207E0
	for <linux-media@archiver.kernel.org>; Fri, 22 Feb 2019 12:24:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="I+kjfe3x"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbfBVMYb (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 22 Feb 2019 07:24:31 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:34258 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725942AbfBVMYb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Feb 2019 07:24:31 -0500
Received: from pendragon.ideasonboard.com (81-175-216-236.bb.dnainternet.fi [81.175.216.236])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 73F712D2;
        Fri, 22 Feb 2019 13:24:28 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1550838268;
        bh=FzP0R5UgZyksObntHPayXpO3iFUbhARwDav3DynTCEQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=I+kjfe3xeE6icn0sQxdBuvFd673DjJFkIKXmMQWzi8Nb4DSw5BuAQ+T4jpt1XNSAC
         h+T4Nz9oeeO5BLut/PxAlbilOOTUvdmhyGOMYQ2K8wBnWlaWSiI4TgaQ3JR1zcUW8g
         A9zNlZC5pEKpOxkLMHcql8YGzEUZkZ0xZt+j32Y0=
Date:   Fri, 22 Feb 2019 14:24:23 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Sakari Ailus <sakari.ailus@linux.intel.com>
Cc:     Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: Re: [RFCv2 PATCH] videodev2.h: introduce VIDIOC_DQ_EXT_EVENT
Message-ID: <20190222122423.GV3522@pendragon.ideasonboard.com>
References: <a28bda76-c8e5-7e93-43a0-0d07844cebf0@xs4all.nl>
 <20190220133443.hg2n6vjra4gppgno@kekkonen.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190220133443.hg2n6vjra4gppgno@kekkonen.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hello,

On Wed, Feb 20, 2019 at 03:34:44PM +0200, Sakari Ailus wrote:
> On Tue, Feb 05, 2019 at 02:49:45PM +0100, Hans Verkuil wrote:
> > This patch adds an extended version of VIDIOC_DQEVENT that:
> > 
> > 1) is Y2038 safe by using a __u64 for the timestamp
> > 2) needs no compat32 conversion code
> > 3) is able to handle control events from 64-bit control types
> >    by changing the type of the minimum, maximum, step and default_value
> >    field to __u64
> > 
> > All drivers and frameworks will be using this, and v4l2-ioctl.c would be the
> > only place where the old event ioctl and structs are used.
> > 
> > Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> > ---
> > I chose to name this DQ_EXT_EVENT since the struct it dequeues is now called
> > v4l2_ext_event. This is also consistent with the names of the G/S/TRY_EXT_CTRLS
> > ioctls. An alternative could be VIDIOC_DQEXT_EVENT as that would be consistent
> > with the lack of _ between DQ and EVENT in the current ioctl. But somehow it
> > doesn't look right.
> > 
> > Changes since v1:
> > - rename ioctl from VIDIOC_DQEXTEVENT.
> > - move the reserved array up to right after the union: this will allow us to
> >   extend the union into the reserved array if we ever need more than 64 bytes
> >   for the event payload (suggested by Sakari).
> > ---
> > diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> > index 9a920f071ff9..301e3678bdb0 100644
> > --- a/include/uapi/linux/videodev2.h
> > +++ b/include/uapi/linux/videodev2.h
> > @@ -2303,6 +2303,37 @@ struct v4l2_event {
> >  	__u32				reserved[8];
> >  };
> > 
> > +struct v4l2_event_ext_ctrl {
> > +	__u32 changes;
> > +	__u32 type;
> > +	union {
> > +		__s32 value;
> > +		__s64 value64;
> > +	};
> > +	__s64 minimum;
> > +	__s64 maximum;
> > +	__s64 step;
> > +	__s64 default_value;
> > +	__u32 flags;
> > +};
> > +
> > +struct v4l2_ext_event {
> > +	__u32				type;
> > +	__u32				id;
> > +	union {
> > +		struct v4l2_event_vsync		vsync;
> > +		struct v4l2_event_ext_ctrl	ctrl;
> > +		struct v4l2_event_frame_sync	frame_sync;
> > +		struct v4l2_event_src_change	src_change;
> > +		struct v4l2_event_motion_det	motion_det;
> > +		__u8				data[64];
> > +	} u;
> > +	__u32				reserved[8];
> > +	__u64				timestamp;
> > +	__u32				pending;
> > +	__u32				sequence;
> > +};
> 
> The size of the struct is at the moment 120 bytes. The allocation done by
> the kernel is always 128 bytes anyway, and the ext control event above is
> just 12 bytes short of the maximum. I'd therefore add two more reserved
> fields. That's fine tuning though. The structs look very nice to me.
> 
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

This looks fine to me too.

> > +
> >  #define V4L2_EVENT_SUB_FL_SEND_INITIAL		(1 << 0)
> >  #define V4L2_EVENT_SUB_FL_ALLOW_FEEDBACK	(1 << 1)
> > 
> > @@ -2475,6 +2506,7 @@ struct v4l2_create_buffers {
> >  #define VIDIOC_DBG_G_CHIP_INFO  _IOWR('V', 102, struct v4l2_dbg_chip_info)
> > 
> >  #define VIDIOC_QUERY_EXT_CTRL	_IOWR('V', 103, struct v4l2_query_ext_ctrl)
> > +#define	VIDIOC_DQ_EXT_EVENT	 _IOR('V', 104, struct v4l2_ext_event)
> > 
> >  /* Reminder: when adding new ioctls please add support for them to
> >     drivers/media/v4l2-core/v4l2-compat-ioctl32.c as well! */

-- 
Regards,

Laurent Pinchart
