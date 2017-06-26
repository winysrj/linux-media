Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:46757 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751382AbdFZJfw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Jun 2017 05:35:52 -0400
Subject: Re: [PATCH 1/1] docs-rst: Document EBUSY for VIDIOC_S_FMT
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
References: <1498469184-13280-1-git-send-email-sakari.ailus@linux.intel.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <58556bf7-ee79-a431-73d5-225d9252da02@xs4all.nl>
Date: Mon, 26 Jun 2017 11:35:39 +0200
MIME-Version: 1.0
In-Reply-To: <1498469184-13280-1-git-send-email-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 26/06/17 11:26, Sakari Ailus wrote:
> VIDIOC_S_FMT may return EBUSY if the device is streaming or there are
> buffers allocated. Document this.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Can you also add this to S_STD, S_INPUT, S_OUTPUT and S_CROP?

And update the EBUSY description for S_DV_TIMINGS and S_SELECTION
since this new description is much better than what is currently
there.

Thanks,

	Hans

> ---
>  Documentation/media/uapi/v4l/vidioc-g-fmt.rst | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/Documentation/media/uapi/v4l/vidioc-g-fmt.rst b/Documentation/media/uapi/v4l/vidioc-g-fmt.rst
> index b853e48..d082f9a 100644
> --- a/Documentation/media/uapi/v4l/vidioc-g-fmt.rst
> +++ b/Documentation/media/uapi/v4l/vidioc-g-fmt.rst
> @@ -147,3 +147,9 @@ appropriately. The generic error codes are described at the
>  EINVAL
>      The struct :c:type:`v4l2_format` ``type`` field is
>      invalid or the requested buffer type not supported.
> +
> +EBUSY
> +    The device is busy and cannot change the format. This could be
> +    because or the device is streaming or buffers are allocated or
> +    queued to the driver. Relevant for :ref:`VIDIOC_S_FMT
> +    <VIDIOC_G_FMT>` only.
> 
