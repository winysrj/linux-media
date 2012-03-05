Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47551 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756053Ab2CELrP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Mar 2012 06:47:15 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@samsung.com, riverful@gmail.com,
	hverkuil@xs4all.nl, teturtia@gmail.com
Subject: Re: [PATCH v4 09/34] v4l: Add subdev selections documentation
Date: Mon, 05 Mar 2012 12:47:26 +0100
Message-ID: <6164314.lBIqd5p9kY@avalon>
In-Reply-To: <1330709442-16654-9-git-send-email-sakari.ailus@iki.fi>
References: <20120302173219.GA15695@valkosipuli.localdomain> <1330709442-16654-9-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the patch.

On Friday 02 March 2012 19:30:17 Sakari Ailus wrote:
> Add documentation for V4L2 subdev selection API. This changes also
> experimental V4L2 subdev API so that scaling now works through selection API
> only.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>

[snip]

> diff --git a/Documentation/DocBook/media/v4l/dev-subdev.xml
> b/Documentation/DocBook/media/v4l/dev-subdev.xml index 0916a73..ef99da1
> 100644
> --- a/Documentation/DocBook/media/v4l/dev-subdev.xml
> +++ b/Documentation/DocBook/media/v4l/dev-subdev.xml

[snip]

> +      <para>The scaling operation changes the size of the image by
> +      scaling it to new dimensions. The scaling ratio isn't specified
> +      explicitly, but is implied from the original and scaled image
> +      sizes. Both sizes are represented by &v4l2-rect;.</para>
> +
> +      <para>Scaling support is optional. When supported by a subdev,
> +      the crop rectangle on the subdev's sink pad is scaled to the
> +      size configured using &sub-subdev-g-selection; and
> +      <constant>V4L2_SUBDEV_SEL_COMPOSE_ACTIVE</constant> selection
> +      target on the same pad. If the subdev supports scaling but no

s/no/not/ (my bad, typo in my previous review)

> +      composing, the top and left values are not used and must always
> +      be set to zero."</para>

s/"// (don't copy the text blindly ;-))

[snip]

> +    <section>
> +      <title>Order of configuration and format propagation</title>
> +
> +      <para>Inside subdevs, the order of image processing steps will
> +      always be from the sink pad towards the source pad. This is also
> +      reflected in the order in which the configuration must be
> +      performed by the user: the changes made will be propagated to
> +      any subsequent stages. If this behaviour is not desired, the
> +      user must set
> +      <constant>V4L2_SUBDEV_SEL_FLAG_KEEP_CONFIG</constant> flag. This
> +      flag causes that no propagation of the changes are allowed in
> +      any circumstances. This may also cause the accessed rectangle to
> +      be adjusted by the driver, depending on the properties of the
> +      underlying hardware. Some drivers may not support this
> +      flag.</para>

Haven't we agreed that supporting the flag should be mandatory ?

> +      <para>The coordinates to a step always refer to the active size
> +      of the previous step. The exception to this rule is the source
> +      compose rectangle, which refers to the sink compose bounds
> +      rectangle --- if it is supported by the hardware.</para>

[snip]

> diff --git a/Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml
> b/Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml new file
> mode 100644
> index 0000000..da1cc4f
> --- /dev/null
> +++ b/Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml

[snip]

> +    <section>
> +      <title>Types of selection targets</title>
> +
> +      <para>The are two types of selection targets: active and bounds.

s/The/There/

> +      The ACTIVE targets are the targets which configure the hardware.
> +      The BOUNDS target will return a rectangle that contain all
> +      possible ACTIVE rectangles.</para>
> +    </section>

-- 
Regards,

Laurent Pinchart

