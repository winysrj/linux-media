Return-path: <linux-media-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:50992 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751437AbdEEMrs (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 5 May 2017 08:47:48 -0400
Date: Fri, 5 May 2017 13:47:45 +0100
From: Liviu Dudau <liviu.dudau@arm.com>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: Brian Starkey <brian.starkey@arm.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/6] drm: Add writeback connector type
Message-ID: <20170505124745.GQ28653@e110455-lin.cambridge.arm.com>
References: <1480092544-1725-1-git-send-email-brian.starkey@arm.com>
 <1480092544-1725-2-git-send-email-brian.starkey@arm.com>
 <20170505102219.0ed543d2@bbrezillon>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170505102219.0ed543d2@bbrezillon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, May 05, 2017 at 10:22:19AM +0200, Boris Brezillon wrote:
> On Fri, 25 Nov 2016 16:48:59 +0000
> Brian Starkey <brian.starkey@arm.com> wrote:
> 
> > +/**
> > + * drm_writeback_connector_init - Initialize a writeback connector and its properties
> > + * @dev: DRM device
> > + * @wb_connector: Writeback connector to initialize
> > + * @funcs: Connector funcs vtable
> > + * @formats: Array of supported pixel formats for the writeback engine
> > + * @n_formats: Length of the formats array
> > + *
> > + * This function creates the writeback-connector-specific properties if they
> > + * have not been already created, initializes the connector as
> > + * type DRM_MODE_CONNECTOR_WRITEBACK, and correctly initializes the property
> > + * values.
> > + *
> > + * Drivers should always use this function instead of drm_connector_init() to
> > + * set up writeback connectors.
> > + *
> > + * Returns: 0 on success, or a negative error code
> > + */
> > +int drm_writeback_connector_init(struct drm_device *dev,
> > +				 struct drm_writeback_connector *wb_connector,
> > +				 const struct drm_connector_funcs *funcs,
> > +				 u32 *formats, int n_formats)
> 
> This should probably be 'const u32 *formats', since developers are
> likely to define a this array with a 'static const' specifier in their
> driver.

Fixed in the v4.

Thanks,
Liviu

-- 
====================
| I would like to |
| fix the world,  |
| but they're not |
| giving me the   |
 \ source code!  /
  ---------------
    ¯\_(ツ)_/¯
