Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.matrix-vision.com ([78.47.19.71]:51035 "EHLO
	mail1.matrix-vision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286Ab2CGI7e (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Mar 2012 03:59:34 -0500
Message-ID: <4F572216.50307@matrix-vision.de>
Date: Wed, 07 Mar 2012 09:53:42 +0100
From: Michael Jones <michael.jones@matrix-vision.de>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@samsung.com, riverful@gmail.com,
	hverkuil@xs4all.nl, teturtia@gmail.com, pradeep.sawlani@gmail.com
Subject: Re: [PATCH v5 09/35] v4l: Add subdev selections documentation
References: <20120306163239.GN1075@valkosipuli.localdomain> <1331051596-8261-9-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1331051596-8261-9-git-send-email-sakari.ailus@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Hopefully it's not too late to make a few minor suggestions.

On 03/06/2012 05:32 PM, Sakari Ailus wrote:
> Add documentation for V4L2 subdev selection API. This changes also
> experimental V4L2 subdev API so that scaling now works through selection API
> only.
>
> Signed-off-by: Sakari Ailus<sakari.ailus@iki.fi>
[snip]
> +
> +<para>On sink pads, cropping is applied relatively to the

s/relatively/relative/

> +      current pad format. The pad format represents the image size as
> +      received by the sub-device from the previous block in the
> +      pipeline, and the crop rectangle represents the sub-image that
> +      will be transmitted further inside the sub-device for
> +      processing.</para>
[snip]
> +<para>On source pads, cropping is similar to sink pads, with the
> +      exception that the source size from which the cropping is
> +      performed, is the COMPOSE rectangle on the sink pad. In both
> +      sink and source pads, the crop rectangle must be entirely
> +      containted inside the source image size for the crop

s/containted/contained/

> +      operation.</para>
> +
> +<para>The drivers should always use the closest possible
> +      rectangle the user requests on all selection targets, unless
> +      specificly told otherwise.

s/specificly/specifically/

> +<constant>V4L2_SUBDEV_SEL_FLAG_SIZE_GE</constant>  and
> +<constant>V4L2_SUBDEV_SEL_FLAG_SIZE_LE</constant>  flags may be
> +      used to round the image size either up or down.<xref
> +      linkend="v4l2-subdev-selection-flags"></xref></para>
> +</section>

[snip]

> +<constant>V4L2_SUBDEV_SEL_FLAG_KEEP_CONFIG</constant>  flag. This
> +      flag causes that no propagation of the changes are allowed in
> +      any circumstances. This may also cause the accessed rectangle to

"This flag causes that" sounds ungrammatical.  I suggest: "This flag 
causes no propagation of the changes to be allowed under any circumstances."

[snip]

Michael

MATRIX VISION GmbH, Talstrasse 16, DE-71570 Oppenweiler
Registergericht: Amtsgericht Stuttgart, HRB 271090
Geschaeftsfuehrer: Gerhard Thullner, Werner Armingeon, Uwe Furtner, Erhard Meier
