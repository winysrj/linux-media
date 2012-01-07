Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:34096 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397Ab2AGPxt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Jan 2012 10:53:49 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: [RFC 04/17] v4l: VIDIOC_SUBDEV_S_SELECTION and VIDIOC_SUBDEV_G_SELECTION IOCTLs
Date: Sat, 7 Jan 2012 16:54:09 +0100
Cc: linux-media@vger.kernel.org, dacohen@gmail.com, snjw23@gmail.com
References: <4EF0EFC9.6080501@maxwell.research.nokia.com> <4F080BAF.1010800@maxwell.research.nokia.com> <4F0827E9.1070303@maxwell.research.nokia.com>
In-Reply-To: <4F0827E9.1070303@maxwell.research.nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201071654.09645.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Saturday 07 January 2012 12:09:29 Sakari Ailus wrote:
> Sakari Ailus wrote:
> ...
> 
> > On second thought, I think I'll combine them into a new anonymous struct
> > the field name of which I call "pad", unless that requires too intrusive
> > changes in other drivers. How about that?
> 
> And the answer to that is "no". The smia++ driver does store the format,
> crop and compose values in arrays indexed by pad numbers which I think
> is a natural thing for the driver to do. In many functiona the driver
> uses internally it's trivial to choose the array either from driver's
> internal data structure (V4L2_SUBDEV_FORMAT_ACTIVE) or the file handle
> (V4L2_SUBDEV_FORMAT_TRY).
> 
> Alternatively a named struct could be created for the same, but the
> drivers might not need all the fields at all, or choose to store them in
> a different form.

Drivers should use the v4l2_subdev_get_try_format(), 
v4l2_subdev_get_try_crop() and v4l2_subdev_get_try_compose() functions to 
access TRY formats and selection rectangles on file handles, so they shouldn't 
care about the allocation details.

-- 
Regards,

Laurent Pinchart
