Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:54064 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750864AbdEEIWX (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 5 May 2017 04:22:23 -0400
Date: Fri, 5 May 2017 10:22:19 +0200
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Brian Starkey <brian.starkey@arm.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        liviu.dudau@arm.com, laurent.pinchart@ideasonboard.com,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 1/6] drm: Add writeback connector type
Message-ID: <20170505102219.0ed543d2@bbrezillon>
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

> +/**
> + * drm_writeback_connector_init - Initialize a writeback connector and its properties
> + * @dev: DRM device
> + * @wb_connector: Writeback connector to initialize
> + * @funcs: Connector funcs vtable
> + * @formats: Array of supported pixel formats for the writeback engine
> + * @n_formats: Length of the formats array
> + *
> + * This function creates the writeback-connector-specific properties if they
> + * have not been already created, initializes the connector as
> + * type DRM_MODE_CONNECTOR_WRITEBACK, and correctly initializes the property
> + * values.
> + *
> + * Drivers should always use this function instead of drm_connector_init() to
> + * set up writeback connectors.
> + *
> + * Returns: 0 on success, or a negative error code
> + */
> +int drm_writeback_connector_init(struct drm_device *dev,
> +				 struct drm_writeback_connector *wb_connector,
> +				 const struct drm_connector_funcs *funcs,
> +				 u32 *formats, int n_formats)

This should probably be 'const u32 *formats', since developers are
likely to define a this array with a 'static const' specifier in their
driver.
