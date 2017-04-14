Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:43095 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751568AbdDNKIm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Apr 2017 06:08:42 -0400
Date: Fri, 14 Apr 2017 12:08:23 +0200
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Brian Starkey <brian.starkey@arm.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        liviu.dudau@arm.com, laurent.pinchart@ideasonboard.com,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 1/6] drm: Add writeback connector type
Message-ID: <20170414120823.2cafc748@bbrezillon>
In-Reply-To: <1480092544-1725-2-git-send-email-brian.starkey@arm.com>
References: <1480092544-1725-1-git-send-email-brian.starkey@arm.com>
        <1480092544-1725-2-git-send-email-brian.starkey@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 25 Nov 2016 16:48:59 +0000
Brian Starkey <brian.starkey@arm.com> wrote:


>  
> diff --git a/drivers/gpu/drm/drm_connector.c b/drivers/gpu/drm/drm_connector.c
> index b5c6a8e..6bbd93f 100644
> --- a/drivers/gpu/drm/drm_connector.c
> +++ b/drivers/gpu/drm/drm_connector.c
> @@ -86,6 +86,7 @@ struct drm_conn_prop_enum_list {
>  	{ DRM_MODE_CONNECTOR_VIRTUAL, "Virtual" },
>  	{ DRM_MODE_CONNECTOR_DSI, "DSI" },
>  	{ DRM_MODE_CONNECTOR_DPI, "DPI" },
> +	{ DRM_MODE_CONNECTOR_WRITEBACK, "Writeback" },

Is there a reason we have a Writeback connector, but keep using a
Virtual encoder to connect it to the CRTC? Wouldn't it make more sense
to also add a Writeback encoder?

>  };
>  
>  void drm_connector_ida_init(void)
> @@ -235,7 +236,8 @@ int drm_connector_init(struct drm_device *dev,
>  	list_add_tail(&connector->head, &config->connector_list);
>  	config->num_connector++;
>  
> -	if (connector_type != DRM_MODE_CONNECTOR_VIRTUAL)
> +	if ((connector_type != DRM_MODE_CONNECTOR_VIRTUAL) &&
> +	    (connector_type != DRM_MODE_CONNECTOR_WRITEBACK))

Nitpick: you don't need the extra parenthesis:

	if (connector_type != DRM_MODE_CONNECTOR_VIRTUAL &&
	    connector_type != DRM_MODE_CONNECTOR_WRITEBACK)

>  		drm_object_attach_property(&connector->base,
>  					      config->edid_property,
>  					      0);



> diff --git a/include/drm/drm_connector.h b/include/drm/drm_connector.h
> index 34f9741..dc4910d6 100644
> --- a/include/drm/drm_connector.h
> +++ b/include/drm/drm_connector.h
> @@ -214,6 +214,19 @@ struct drm_connector_state {
>  	struct drm_encoder *best_encoder;
>  
>  	struct drm_atomic_state *state;
> +
> +	/**
> +	 * @writeback_job: Writeback job for writeback connectors
> +	 *
> +	 * Holds the framebuffer for a writeback connector. As the writeback
> +	 * completion may be asynchronous to the normal commit cycle, the
> +	 * writeback job lifetime is managed separately from the normal atomic
> +	 * state by this object.
> +	 *
> +	 * See also: drm_writeback_queue_job() and
> +	 * drm_writeback_signal_completion()
> +	 */
> +	struct drm_writeback_job *writeback_job;

Maybe I'm wrong, but is feels weird to have the writeback_job field
directly embedded in drm_connector_state, while drm_writeback_connector
inherits from drm_connector.

IMO, either you decide to directly put the drm_writeback_connector's
job_xxx fields in drm_connector and keep the drm_connector_state as is,
or you create a drm_writeback_connector_state which inherits from
drm_connector_state and embeds the writeback_job field.

Anyway, wait for Daniel's feedback before doing this change.

>  };
>  
>  /**
> diff --git a/include/drm/drm_mode_config.h b/include/drm/drm_mode_config.h
> index bf9991b2..3d3d07f 100644
> --- a/include/drm/drm_mode_config.h
> +++ b/include/drm/drm_mode_config.h
> @@ -634,6 +634,20 @@ struct drm_mode_config {
>  	 */
>  	struct drm_property *suggested_y_property;
>  
> +	/**
> +	 * @writeback_fb_id_property: Property for writeback connectors, storing
> +	 * the ID of the output framebuffer.
> +	 * See also: drm_writeback_connector_init()
> +	 */
> +	struct drm_property *writeback_fb_id_property;
> +	/**
> +	 * @writeback_pixel_formats_property: Property for writeback connectors,
> +	 * storing an array of the supported pixel formats for the writeback
> +	 * engine (read-only).
> +	 * See also: drm_writeback_connector_init()
> +	 */
> +	struct drm_property *writeback_pixel_formats_property;
> +
>  	/* dumb ioctl parameters */
>  	uint32_t preferred_depth, prefer_shadow;
>  
> diff --git a/include/drm/drm_writeback.h b/include/drm/drm_writeback.h
> new file mode 100644
> index 0000000..6b2ac45
> --- /dev/null
> +++ b/include/drm/drm_writeback.h
> @@ -0,0 +1,78 @@
> +/*
> + * (C) COPYRIGHT 2016 ARM Limited. All rights reserved.
> + * Author: Brian Starkey <brian.starkey@arm.com>
> + *
> + * This program is free software and is provided to you under the terms of the
> + * GNU General Public License version 2 as published by the Free Software
> + * Foundation, and any use by you of this program is subject to the terms
> + * of such GNU licence.
> + */
> +
> +#ifndef __DRM_WRITEBACK_H__
> +#define __DRM_WRITEBACK_H__
> +#include <drm/drm_connector.h>
> +#include <linux/workqueue.h>
> +
> +struct drm_writeback_connector {
> +	struct drm_connector base;

AFAIU, a writeback connector will always require an 'dummy' encoder to
make the DRM framework happy (AFAIK, a connector is always connected to
a CRTC through an encoder).

Wouldn't it make more sense to have a drm_encoder object embedded in
drm_writeback_connector so that people don't have to declare an extra
structure containing both the drm_writeback_connector connector and a
drm_encoder? Is there a good reason to keep them separate?

> +
> +	/**
> +	 * @pixel_formats_blob_ptr:
> +	 *
> +	 * DRM blob property data for the pixel formats list on writeback
> +	 * connectors
> +	 * See also drm_writeback_connector_init()
> +	 */
> +	struct drm_property_blob *pixel_formats_blob_ptr;
> +
> +	/** @job_lock: Protects job_queue */
> +	spinlock_t job_lock;
> +	/**
> +	 * @job_queue:
> +	 *
> +	 * Holds a list of a connector's writeback jobs; the last item is the
> +	 * most recent. The first item may be either waiting for the hardware
> +	 * to begin writing, or currently being written.
> +	 *
> +	 * See also: drm_writeback_queue_job() and
> +	 * drm_writeback_signal_completion()
> +	 */
> +	struct list_head job_queue;
> +};
