Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:55340
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752955AbdDJMFZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Apr 2017 08:05:25 -0400
Date: Mon, 10 Apr 2017 09:05:19 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2.3] v4l: Clearly document interactions between
 formats, controls and buffers
Message-ID: <20170410090519.5c38e219@vento.lan>
In-Reply-To: <20170306141441.13497-1-laurent.pinchart+renesas@ideasonboard.com>
References: <20170305213610.3893-1-laurent.pinchart+renesas@ideasonboard.com>
        <20170306141441.13497-1-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon,  6 Mar 2017 16:14:41 +0200
Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com> escreveu:

> V4L2 exposes parameters that influence buffers sizes through the format
> ioctls (VIDIOC_G_FMT, VIDIOC_TRY_FMT, VIDIOC_S_FMT, and possibly
> VIDIOC_G_SELECTION and VIDIOC_S_SELECTION). Other parameters not part of
> the format structure may also influence buffer sizes or buffer layout in
> general. One existing such parameter is rotation, which is implemented
> by the V4L2_CID_ROTATE control and thus exposed through the V4L2 control
> ioctls.
> 
> The interaction between those parameters and buffers is currently only
> partially specified by the V4L2 API. In particular interactions between
> controls and buffers isn't specified at all. The behaviour of the
> VIDIOC_S_FMT and VIDIOC_S_SELECTION ioctls when buffers are allocated is
> also not fully specified.
> 
> This patch clearly defines and documents the interactions between
> formats, selections, controls and buffers.
> 
> The preparatory discussions for the documentation change considered
> completely disallowing controls that change the buffer size or layout,
> in favour of extending the format API with a new ioctl that would bundle
> those controls with format information. The idea has been rejected, as
> this would essentially be a restricted version of the upcoming request
> API that wouldn't bring any additional value.
> 
> Another option we have considered was to mandate the use of the request
> API to modify controls that influence buffer size or layout. This has
> also been rejected on the grounds that requiring the request API to
> change rotation even when streaming is stopped would significantly
> complicate implementation of drivers and usage of the V4L2 API for
> applications.
> 
> Applications will however be required to use the upcoming request API to
> change at runtime formats or controls that influence the buffer size or
> layout, because of the need to synchronize buffers with the formats and
> controls. Otherwise there would be no way to interpret the content of a
> buffer correctly.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
> Changes since v2.2:
> 
> - Describe the simple option first
> - Fix error codes
> 
> Changes since v2.1:
> 
> - Fixed small issues in commit message
> - Simplified wording of one sentence in the documentation
> 
> Changes since v2:
> 
> - Document the interaction with ioctls that can affect formats
>   (VIDIOC_S_SELECTION, VIDIOC_S_INPUT, VIDIOC_S_OUTPUT, VIDIOC_S_STD and
>   VIDIOC_S_DV_TIMINGS)
> - Clarify the format/control change order
> ---
>  Documentation/media/uapi/v4l/buffer.rst | 110 ++++++++++++++++++++++++++++++++
>  1 file changed, 110 insertions(+)
> 
> diff --git a/Documentation/media/uapi/v4l/buffer.rst b/Documentation/media/uapi/v4l/buffer.rst
> index ac58966ccb9b..d1e0d55dc219 100644
> --- a/Documentation/media/uapi/v4l/buffer.rst
> +++ b/Documentation/media/uapi/v4l/buffer.rst

...

> +.. note::
> +
> +   The API doesn't mandate the above order for control (3.) and format (4.)
> +   changes. Format and controls can be set in a different order, or even
> +   interleaved, depending on the device and use case. For instance some
> +   controls might behave differently for different pixel formats, in which
> +   case the format might need to be set first.
> +
> +When reallocation is required, any attempt to modify format or controls that
> +influences the buffer size while buffers are allocated shall cause the format
> +or control set ioctl to return the ``EBUSY`` error. Any attempt to queue a
> +buffer too small for the current format or controls shall cause the
> +:c:func:`VIDIOC_QBUF` ioctl to return a ``EINVAL`` error.

This can be problematic. As I just implemented support for controls
this weekend at Zbar, I'm now talking as an userspace app developer's
hat.

The real problem here is that applications must be aware of what
controls change the buffer layout. Blindly changing controls without
such check would cause the stream to fail with -EINVAL errors at
QBUF.

So, applications will need to to have a "black list" of controls that may
influence the buffer size  (like V4L2_CID_ROTATE), in order to know
if, for such particular control, the stream should be stopped, in
order to reallocate buffers.

If such "black list" is not updated as newer controls are added, the
final result is that, if the user changes such control, the 
application will receive EINVAL, causing it to fail streaming.

Instead of that, the best is to add control flag to be returned via
VIDIOC_QUERY_CTRL/VIDIOC_QUERY_EXT_CTRL indicating when a control modifies 
the buffer layout, e. g., something like:

#define V4L2_CTRL_FLAG_MODIFY_BUF_LAYOUT	0x0400

Such flag shall be set for V4L2_CID_ROTATE (and other controls) if,
for a particular driver, the buffer layout is modified.

This way, userspace can recognize such controls in runtime and
reallocate the buffers if required by such controls.


Regards

Thanks,
Mauro
