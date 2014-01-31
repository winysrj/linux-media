Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:53780 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932278AbaAaPvu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Jan 2014 10:51:50 -0500
Message-ID: <52EBC693.6040709@linux.intel.com>
Date: Fri, 31 Jan 2014 17:51:47 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] v4l: subdev: Allow 32-bit compat IOCTLs
References: <1391182129-5234-1-git-send-email-sakari.ailus@linux.intel.com> <52EBC33C.6050902@xs4all.nl>
In-Reply-To: <52EBC33C.6050902@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the comments.

Hans Verkuil wrote:
> Hi Sakari,
>
> Sorry, this isn't right.
>
> It should go through v4l2_compat_ioctl32, otherwise ioctls for e.g. extended controls
> won't be converted correctly.

Now that you mention it, indeed the state back when I thought this was 
already implemented, the IOCTLs were exactly the same. Now that struct 
v4l2_subdev_edid is used on VIDIOC_SUBDEV_G_EDID and 
VIDIOC_SUBDEV_S_EDID32, this no longer holds.

The two IOCTLs are already handled by v4l2_compat_ioctl32 explicitly. 
Perhaps that's what you remember? :-)

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
