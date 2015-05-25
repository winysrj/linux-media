Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:39452 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430AbbEYLU6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 May 2015 07:20:58 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Vaibhav Hiremath <vaibhav.hiremath@linaro.org>
Subject: Re: [PATCH v2] v4l: subdev: Add pad config allocator and init
Date: Mon, 25 May 2015 14:21:17 +0300
Message-ID: <1537709.Z57HprXWZ6@avalon>
In-Reply-To: <55624FE0.1040307@xs4all.nl>
References: <1432501800-3411-1-git-send-email-laurent.pinchart@ideasonboard.com> <55624FE0.1040307@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Monday 25 May 2015 00:25:36 Hans Verkuil wrote:
> On 05/24/2015 11:10 PM, Laurent Pinchart wrote:
> > From: Laurent Pinchart <laurent.pinchart@linaro.org>
> > 
> > Add a new subdev operation to initialize a subdev pad config array, and
> > a helper function to allocate and initialize the array. This can be used
> > by bridge drivers to implement try format based on subdev pad
> > operations.
> > 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@linaro.org>
> > Acked-by: Vaibhav Hiremath <vaibhav.hiremath@linaro.org>
> 
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Note that before this goes in there should be at least one subdev driver
> that implements init_cfg(). Perhaps adv7604?

I fully agree, this needs to be used by at least one subdev driver.

I'd go even further, I'd like to see v4l2_subdev_alloc_pad_config() used by a 
bridge driver, to implement VIDIOC_TRY_FMT. I've originally written the patch 
to implement VIDIOC_TRY_FMT (and VIDIOC_ENUM_FRAMESIZES) in a driver I'm 
developing, but it's not ready for submission to mainline yet.

Do you think a subdev driver is enough, or do we need a bridge too in order to 
merge this patch ?

> > ---
> > 
> >  drivers/media/v4l2-core/v4l2-subdev.c | 19 ++++++++++++++++++-
> >  include/media/v4l2-subdev.h           | 10 ++++++++++
> >  2 files changed, 28 insertions(+), 1 deletion(-)
> > 
> > Changes since v1:
> > 
> > - Added v4l2_subdev_free_pad_config

-- 
Regards,

Laurent Pinchart

