Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:49630 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730412AbeKVTqm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Nov 2018 14:46:42 -0500
Subject: Re: [PATCH 1/1] v4l: uAPI doc: Changing frame interval won't change
 format
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
References: <20181121173344.4055-1-sakari.ailus@linux.intel.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <0e159a5b-e43a-78a0-64d5-0efc8613fcac@xs4all.nl>
Date: Thu, 22 Nov 2018 10:08:05 +0100
MIME-Version: 1.0
In-Reply-To: <20181121173344.4055-1-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/21/2018 06:33 PM, Sakari Ailus wrote:
> Document that changing the frame interval has no effect on frame size.
> While this was the assumption in the API, it was not documented as such.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks!

	Hans

> ---
>  Documentation/media/uapi/v4l/vidioc-g-parm.rst                  | 3 +++
>  Documentation/media/uapi/v4l/vidioc-subdev-g-frame-interval.rst | 3 +++
>  2 files changed, 6 insertions(+)
> 
> diff --git a/Documentation/media/uapi/v4l/vidioc-g-parm.rst b/Documentation/media/uapi/v4l/vidioc-g-parm.rst
> index e831fa5512f0..c31585a7701b 100644
> --- a/Documentation/media/uapi/v4l/vidioc-g-parm.rst
> +++ b/Documentation/media/uapi/v4l/vidioc-g-parm.rst
> @@ -42,6 +42,9 @@ side. This is especially useful when using the :ref:`read() <func-read>` or
>  :ref:`write() <func-write>`, which are not augmented by timestamps or sequence
>  counters, and to avoid unnecessary data copying.
>  
> +Changing the frame interval shall never change the format. Changing the
> +format, on the other hand, may change the frame interval.
> +
>  Further these ioctls can be used to determine the number of buffers used
>  internally by a driver in read/write mode. For implications see the
>  section discussing the :ref:`read() <func-read>` function.
> diff --git a/Documentation/media/uapi/v4l/vidioc-subdev-g-frame-interval.rst b/Documentation/media/uapi/v4l/vidioc-subdev-g-frame-interval.rst
> index 5af0a7179941..f889c20f231c 100644
> --- a/Documentation/media/uapi/v4l/vidioc-subdev-g-frame-interval.rst
> +++ b/Documentation/media/uapi/v4l/vidioc-subdev-g-frame-interval.rst
> @@ -63,6 +63,9 @@ doesn't match the device capabilities. They must instead modify the
>  interval to match what the hardware can provide. The modified interval
>  should be as close as possible to the original request.
>  
> +Changing the frame interval shall never change the format. Changing the
> +format, on the other hand, may change the frame interval.
> +
>  Sub-devices that support the frame interval ioctls should implement them
>  on a single pad only. Their behaviour when supported on multiple pads of
>  the same sub-device is not defined.
> 
