Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:42398 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751725AbdG1OUI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Jul 2017 10:20:08 -0400
Subject: Re: [RFCv2 PATCH 0/2] add VIDIOC_SUBDEV_QUERYCAP ioctl
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, Sakari Ailus <sakari.ailus@iki.fi>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
References: <20170728110529.4057-1-hverkuil@xs4all.nl>
 <1925879.q3PoFGT7lz@avalon> <625cbe4e-7ebd-c995-b4f3-4e1bf892aac9@xs4all.nl>
Message-ID: <b2b355dd-8e29-9a02-ca8e-a18ce4bfa954@xs4all.nl>
Date: Fri, 28 Jul 2017 16:20:03 +0200
MIME-Version: 1.0
In-Reply-To: <625cbe4e-7ebd-c995-b4f3-4e1bf892aac9@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/28/2017 04:04 PM, Hans Verkuil wrote:
> On 07/28/2017 03:25 PM, Laurent Pinchart wrote:
>> To solve this, if you really want to identify the type of device node at 
>> runtime, we should have a single ioctl supported by the two device nodes. 
>> Given that we"re running out of capabilities bits for VIDIOC_QUERYCAP, this 
>> could be a good occasion to introduce a new ioctl to query capabilities.
> 
> This makes more sense :-)

Here is a quick proposal:

struct v4l2_ext_capability {
        char    driver[16];
        char    name[32];
        char    bus_info[32];
        __u64   device_caps;
        __u32   version;
        __u32   entity_id;
        /* Corresponding media controller device node specifications */
        __u32   media_node_major;
        __u32   media_node_minor;
        __u32   reserved[16];
};

#define V4L2_CAP_SUBDEV                 0x00000008  /* This is a v4l-subdev device */
#define V4L2_CAP_ENTITY                 0x08000000  /* MC entity */

#define VIDIOC_EXT_QUERYCAP             _IOR('V', 104, struct v4l2_ext_capability)

We keep the existing caps, but double the size of the device_caps field.

Add a CAP_SUBDEV to indicate that it is a subdev, and a CAP_ENTITY to indicate
that it is part of the media controller.

I dropped the old 'capabilities' field. In V4L2 that is meant to give the sum
of all the capabilities of all the video/vbi/radio/swradio device nodes, but
it never worked and is inconsistently implemented.

It's really historical so I decided to drop it. I also replaced __u8 by char
for the string fields (__u8 was very, very annoying!).

No driver changes needed for this, it can all be handled in the core.

Regards,

	Hans
