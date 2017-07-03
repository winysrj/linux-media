Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:55051 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752247AbdGCMnK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 3 Jul 2017 08:43:10 -0400
Subject: Re: [PATCH v6] media: platform: Renesas IMR driver
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        devicetree@vger.kernel.org, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        Konstantin Kozhevnikov
        <Konstantin.Kozhevnikov@cogentembedded.com>
References: <20170623203456.503714406@cogentembedded.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <589c2ca4-d1e7-86c3-1ef5-8831a54856ed@xs4all.nl>
Date: Mon, 3 Jul 2017 14:43:04 +0200
MIME-Version: 1.0
In-Reply-To: <20170623203456.503714406@cogentembedded.com>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/23/2017 10:34 PM, Sergei Shtylyov wrote:
> Index: media_tree/Documentation/media/v4l-drivers/rcar_imr.rst
> ===================================================================
> --- /dev/null
> +++ media_tree/Documentation/media/v4l-drivers/rcar_imr.rst
> @@ -0,0 +1,86 @@
> +Renesas R-Car Image Rendeder (IMR) Driver

Rendeder -> Renderer

> +=========================================
> +
> +This file documents some driver-specific aspects of the IMR driver, such as
> +driver-specific ioctls.
> +
> +The ioctl reference
> +~~~~~~~~~~~~~~~~~~~
> +
> +VIDIOC_IMR_MESH - Set mapping data
> +^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> +
> +Argument: struct imr_map_desc
> +
> +**Description**:
> +
> +	This ioctl sets up the mesh using which the input frames will be

s/using/through/

> +	transformed into the output frames. The mesh can be strictly rectangular
> +	(when IMR_MAP_MESH bit is set in imr_map_desc::type) or arbitrary (when
> +	that bit is not set).
> +
> +	A rectangular mesh consists of the imr_mesh structure followed by M*N
> +	vertex objects (where M is imr_mesh::rows and N is imr_mesh::columns).
> +	In case either IMR_MAP_AUTOSG or IMR_MAP_AUTODG bits were set in
> +	imr_map_desc::type, imr_mesh::{x|y}0 specify the coordinates of the top
> +	left corner of the auto-generated mesh and imr_mesh::d{x|y} specify the
> +	mesh's X/Y steps.

What if any of the other types are used like IMR_MAP_LUCE?

Is this documented in a Renesas datasheet? If so, add a reference to that in this
documentation.

> +
> +	An arbitrary mesh consists of the imr_vbo structure followed by N
> +	triangle objects (where N is imr_vbo::num), consisting of 3 vertex
> +	objects each.
> +
> +	A vertex object has a complex structure:
> +
> +.. code-block:: none
> +
> +	__u16	v		vertical   \ source coordinates (only present
> +	__u16	u		horizontal / if IMR_MAP_AUTOSG isn't set)
> +	__u16	Y		vertical   \ destination coordinates (only here
> +	__u16	X		horizontal / if IMR_MAP_AUTODG isn't set)
> +	__s8	lofst		offset \  luminance correction parameters
> +	__u8	lscal		scale   > (only present if IMR_MAP_LUCE
> +	__u16	reserved	       /  is set)
> +	__s8	vrofs		V value offset \  hue correction parameters
> +	__u8	vrscl		V value scale   \ (only present if IMR_MAP_CLCE
> +	__s8	ubofs		U value offset  / is set)
> +	__u8	ubscl		U value scale  /

Is this the internal structure? Or something that userspace has to fill in?
It's not clear at all.

I recommend giving a few code examples of how this should be used.

> +
> +**Return value**:
> +
> +	On success 0 is returned. On error -1 is returned and errno is set
> +	appropriately.
> +
> +**Data types**:
> +
> +.. code-block:: none
> +
> +	* struct imr_map_desc
> +
> +	__u32	type		mapping types

This is a bitmask? If so, what combination of bits are allowed?

> +	__u32	size		total size of the mesh structure
> +	__u64	data		map-specific user-pointer
> +
> +	IMR_MAP_MESH		regular mesh specification
> +	IMR_MAP_AUTOSG		auto-generated source coordinates
> +	IMR_MAP_AUTODG		auto-generated destination coordinates
> +	IMR_MAP_LUCE		luminance correction flag
> +	IMR_MAP_CLCE		chromacity correction flag

You probably mean 'chroma'. 'chromacity' isn't a word.

> +	IMR_MAP_TCM		vertex clockwise-mode order
> +	IMR_MAP_UVDPOR(n)	source coordinate decimal point position
> +	IMR_MAP_DDP		destination coordinate sub-pixel mode
> +	IMR_MAP_YLDPO(n)	luminance correction offset decimal point
> +				position
> +	IMR_MAP_UBDPO(n)	chromacity (U) correction offset decimal point
> +				position
> +	IMR_MAP_VRDPO(n)	chromacity (V) correction offset decimal point
> +				position

There is no documentation what how these types relate to IMR_MAP_MESH and
IMR_MAP_AUTOS/DG.

> +
> +	* struct imr_mesh	regular mesh specification
> +
> +	__u16	rows, columns	rectangular mesh sizes
> +	__u16	x0, y0, dx, dy	auto-generated mesh parameters
> +
> +	* struct imr_vbo	vertex-buffer-object (VBO) descriptor
> +
> +	__u16	num		number of triangles

Sorry, this needs more work.

Regards,

	Hans
