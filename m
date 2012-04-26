Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:10595 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755290Ab2DZLTu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Apr 2012 07:19:50 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Scott Jiang <scott.jiang.linux@gmail.com>
Subject: Re: How to implement i2c map device
Date: Thu, 26 Apr 2012 13:19:45 +0200
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	LMML <linux-media@vger.kernel.org>
References: <CAHG8p1D1EAO3hgYNvwZL6HgVw-995knuf62TdXh944SkAHoWKw@mail.gmail.com>
In-Reply-To: <CAHG8p1D1EAO3hgYNvwZL6HgVw-995knuf62TdXh944SkAHoWKw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201204261319.45401.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Scott,

On Thursday 26 April 2012 11:47:08 Scott Jiang wrote:
> Hi Laurent,
> 
> I'm writing a driver for adv7842 video decoder. This chip has 12 i2c
> register maps. IO map is fixed to 0x20 and others are configurable.
> I plan to use 0x20 as the subdevice addr to call
> v4l2_i2c_new_subdev_board, and call i2c_new_device and i2c_add_driver
> in i2c_probe to enumerate other i2c maps. Is it acceptable or any
> other suggestion?

You have to use i2c_new_dummy for all the non-fixed register maps.

But I can save you a lot more time: we (Cisco) have a adv7842 driver already 
that is working for the most part (at least the parts that we need).

I'll mail the driver to you separately. I intend to make it available in a 
public repository in the next few weeks.

> 
> By the way, HDMI support seems under discussion, is there any
> framework or guide now?

There are two parts to HDMI: the first is a better API for selecting timings. 
The latest RFC patch series was just posted this week:

http://www.spinics.net/lists/linux-media/msg46813.html

I'm hopeful that this will make kernel 3.5.

The second part is to add some missing HDMI-specific controls and two ioctls 
to set/get EDIDs. I'm preparing an RFC for that and I expect to post that next 
week.

There is one final part: CEC support. We have implemented it, but the API 
needs more discussions. How to present CEC support to userspace seems to be a 
controversial issue.

Regards,

	Hans

> 
> Thanks,
> Scott
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
