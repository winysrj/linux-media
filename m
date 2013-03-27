Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:42831 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754843Ab3C0XRf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Mar 2013 19:17:35 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: RFC: VIDIOC_DBG_G_CHIP_NAME improvements
Date: Thu, 28 Mar 2013 00:18:23 +0100
Message-ID: <4037755.IHUjzgIeDl@avalon>
In-Reply-To: <201303271154.34620.hverkuil@xs4all.nl>
References: <201303271154.34620.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Wednesday 27 March 2013 11:54:34 Hans Verkuil wrote:
> Now that the VIDIOC_DBG_G_CHIP_NAME ioctl has been added to the v4l2 API I
> started work on removing the VIDIOC_DBG_G_CHIP_IDENT support in existing
> drivers. Based on that effort I realized that there are a few things that
> could be improved.
> 
> One thing that Laurent pointed out is that this ioctl should be available
> only if CONFIG_VIDEO_ADV_DEBUG is set to prevent abuse by either userspace
> or kernelspace. I agree with that, especially since g_chip_ident is being
> abused today by some bridge drivers. That should be avoided in the future.
> 
> I am also unhappy with the name. G_CHIP_INFO would certainly be more
> descriptive, but perhaps we should move a bit more into the direction of
> the Media Controller and call it G_ENTITY_INFO. Opinions are welcome.

We need such an ioctl to retrieve extended informations about entities (it's 
been on my to-do list for too long), but I'd like to see it on the media 
device node.

> What surprised me when digging into the existing uses of G_CHIP_IDENT was
> that there are more devices than expected that have multiple register
> blocks. I.e. rather than a single set of registers they have multiple
> blocks of registers, say one block at address 0x1000, another at 0x2000,
> etc.
> 
> Usually such register blocks represent IP blocks inside the chip, each doing
> a specific task. In other cases (adv7604) each block corresponds to an i2c
> address, each again representing an IP block inside the chip.
> 
> In the case of adv7604 it has been implementing by mapping register offsets
> to specific i2c addresses, in the case of the cx231xx it has been
> implemented by exposing different bridge chips, unfortunately that's done
> in such a way that it can't be enumerated.
> 
> The existing debug API has no support for discovering such ranges, but
> having worked with such a chip I think that having support for this is very
> desirable.

As this is really a debug API, and applications (and users) need to know what 
they're doing, do we really need to make the ranges discoverable ? If you 
don't know what ranges a device supports you probably won't know enough to 
poke its registers directly anyway.

> Since we added a new ioctl anyway, I thought that this is a good time to
> extend it a bit and allow range discovery to be implemented:
> 
> /**
>  * struct v4l2_dbg_chip_name - VIDIOC_DBG_G_CHIP_NAME argument
>  * @match:      which chip to match
>  * @flags:      flags that tell whether this range is readable/writable
>  * @name:       unique name of the chip
>  * @range_name: name of the register range
>  * @range_min:  minimum register of the register range
>  * @range_max:  maximum register of the register range
>  * @reserved:   future extensions
>  */
> struct v4l2_dbg_chip_name {
>         struct v4l2_dbg_match match;
> 	__u32 range;
>         __u32 flags;
>         char name[32];
>         char range_name[32];
>         __u64 range_start;
>         __u64 range_size;
>         __u32 reserved[8];
> } __attribute__ ((packed));
> 
> range is the range index, range_name describes the purpose of the register
> range, range_start and size are the start register address and the size of
> this register range.
> 
> This extension allows you to enumerate the available register ranges for
> each device. If there is only one range, then range_size may be 0. This is
> mostly for backwards compatibility as otherwise I would have to modify all
> existing drivers for this, and also because this is not really necessary
> for simple devices with just one range. These are mostly i2c devices with
> start address 0 and a size of 256 bytes at most.

-- 
Regards,

Laurent Pinchart

