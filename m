Return-path: <linux-media-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:39440 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933093AbcJZMmr (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Oct 2016 08:42:47 -0400
Date: Wed, 26 Oct 2016 13:42:42 +0100
From: Brian Starkey <brian.starkey@arm.com>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [RFC PATCH v2 1/9] drm: Add writeback connector type
Message-ID: <20161026124242.GB30071@e106950-lin.cambridge.arm.com>
References: <1477472108-27222-1-git-send-email-brian.starkey@arm.com>
 <1477472108-27222-2-git-send-email-brian.starkey@arm.com>
 <20161026110021.bgy4xsfbtiqflqe3@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20161026110021.bgy4xsfbtiqflqe3@phenom.ffwll.local>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Oct 26, 2016 at 01:00:21PM +0200, Daniel Vetter wrote:
>On Wed, Oct 26, 2016 at 09:55:00AM +0100, Brian Starkey wrote:
>> Writeback connectors represent writeback engines which can write the
>> CRTC output to a memory framebuffer. Add a writeback connector type and
>> related support functions.
>>
>> Drivers should initialize a writeback connector with
>> drm_writeback_connector_init() which takes care of setting up all the
>> writeback-specific details on top of the normal functionality of
>> drm_connector_init().
>>
>> Writeback connectors have a WRITEBACK_FB_ID property, used to set the
>> output framebuffer, PIXEL_FORMATS and PIXEL_FORMATS_SIZE used to expose
>> the supported writeback formats to userspace.
>>
>> The drm_atomic core takes care of enforcing fairly strict semantics on
>> the use of writeback connectors. In short, a writeback connector can
>> only be included in a commit if it has both a framebuffer and a CRTC.
>> Conversely, you may not attach a framebuffer if the connector is not
>> attached to a CRTC, or if the CRTC is disabled.
>>
>> When a framebuffer is attached to a writeback connector with the
>> WRITEBACK_FB_ID property, it is used only once (for the commit in which
>> it was included), and userspace can never read back the value of
>> WRITEBACK_FB_ID.
>>
>> Changes since v1:
>>  - Added drm_writeback.c + documentation
>>  - Added helper to initialize writeback connector in one go
>>  - Added core checks
>>  - Squashed into a single commit
>>  - Dropped the client cap
>>  - Writeback framebuffers are no longer persistent
>>
>> Signed-off-by: Brian Starkey <brian.starkey@arm.com>
>
>I think this is looking pretty good. Bunch of nitpicks below, but
>otherwise I think we just need the userspace for this, plus an ack from
>other people interested in this, and it's good to get merged.
>-Daniel
>

Thanks for having another look,

>> ---
>>  Documentation/gpu/drm-kms.rst       |    9 ++
>>  drivers/gpu/drm/Makefile            |    2 +-
>>  drivers/gpu/drm/drm_atomic.c        |   95 +++++++++++++++++++++
>>  drivers/gpu/drm/drm_atomic_helper.c |    5 ++
>>  drivers/gpu/drm/drm_connector.c     |    4 +-
>>  drivers/gpu/drm/drm_writeback.c     |  157 +++++++++++++++++++++++++++++++++++
>>  include/drm/drm_atomic.h            |    3 +
>>  include/drm/drm_connector.h         |   12 +++
>>  include/drm/drm_crtc.h              |   20 +++++
>>  include/drm/drm_writeback.h         |   19 +++++
>>  include/uapi/drm/drm_mode.h         |    1 +
>>  11 files changed, 325 insertions(+), 2 deletions(-)
>>  create mode 100644 drivers/gpu/drm/drm_writeback.c
>>  create mode 100644 include/drm/drm_writeback.h
>>
>> diff --git a/Documentation/gpu/drm-kms.rst b/Documentation/gpu/drm-kms.rst
>> index 53b872c..c3d0370 100644
>> --- a/Documentation/gpu/drm-kms.rst
>> +++ b/Documentation/gpu/drm-kms.rst
>> @@ -149,6 +149,15 @@ Connector Functions Reference
>>  .. kernel-doc:: drivers/gpu/drm/drm_connector.c
>>     :export:
>>
>> +Writeback Connectors
>> +--------------------
>> +
>> +.. kernel-doc:: drivers/gpu/drm/drm_writeback.c
>> +  :doc: overview
>> +
>> +.. kernel-doc:: drivers/gpu/drm/drm_writeback.c
>> +  :export:
>> +
>>  Encoder Abstraction
>>  ===================
>>
>> diff --git a/drivers/gpu/drm/Makefile b/drivers/gpu/drm/Makefile
>> index 25c7204..2dc4a48 100644
>> --- a/drivers/gpu/drm/Makefile
>> +++ b/drivers/gpu/drm/Makefile
>> @@ -15,7 +15,7 @@ drm-y       :=	drm_auth.o drm_bufs.o drm_cache.o \
>>  		drm_modeset_lock.o drm_atomic.o drm_bridge.o \
>>  		drm_framebuffer.o drm_connector.o drm_blend.o \
>>  		drm_encoder.o drm_mode_object.o drm_property.o \
>> -		drm_plane.o drm_color_mgmt.o
>> +		drm_plane.o drm_color_mgmt.o drm_writeback.o
>>
>>  drm-$(CONFIG_COMPAT) += drm_ioc32.o
>>  drm-$(CONFIG_DRM_GEM_CMA_HELPER) += drm_gem_cma_helper.o
>> diff --git a/drivers/gpu/drm/drm_atomic.c b/drivers/gpu/drm/drm_atomic.c
>> index fe37987..f434f34 100644
>> --- a/drivers/gpu/drm/drm_atomic.c
>> +++ b/drivers/gpu/drm/drm_atomic.c
>> @@ -612,6 +612,44 @@ static int drm_atomic_crtc_check(struct drm_crtc *crtc,
>>  }
>>
>>  /**
>> + * drm_atomic_connector_check - check connector state
>> + * @connector: connector to check
>> + * @state: connector state to check
>> + *
>> + * Provides core sanity checks for connector state.
>> + *
>> + * RETURNS:
>> + * Zero on success, error code on failure
>> + */
>> +static int drm_atomic_connector_check(struct drm_connector *connector,
>> +		struct drm_connector_state *state)
>> +{
>> +	struct drm_crtc_state *crtc_state;
>> +
>> +	if (connector->connector_type != DRM_MODE_CONNECTOR_WRITEBACK)
>> +		return 0;
>> +
>> +	if (!state->fb != !state->crtc) {
>> +		DRM_DEBUG_ATOMIC("[CONNECTOR:%d:%s] framebuffer/CRTC mismatch\n",
>> +				 connector->base.id, connector->name);
>> +		return -EINVAL;
>> +	}
>> +
>> +	if (state->crtc)
>> +		crtc_state = drm_atomic_get_existing_crtc_state(state->state,
>> +								state->crtc);
>> +
>> +	if (state->fb && !crtc_state->active) {
>> +		DRM_DEBUG_ATOMIC("[CONNECTOR:%d:%s] has framebuffer, but [CRTC:%d] is off\n",
>> +				 connector->base.id, connector->name,
>> +				 state->crtc->base.id);
>> +		return -EINVAL;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +/**
>>   * drm_atomic_get_plane_state - get plane state
>>   * @state: global atomic state object
>>   * @plane: plane to get state object for
>> @@ -1004,12 +1042,19 @@ int drm_atomic_connector_set_property(struct drm_connector *connector,
>>  		 * now?) atomic writes to DPMS property:
>>  		 */
>>  		return -EINVAL;
>> +	} else if (property == config->writeback_fb_id_property) {
>> +		struct drm_framebuffer *fb = drm_framebuffer_lookup(dev, val);
>> +		drm_atomic_set_fb_for_connector(state, fb);
>> +		if (fb)
>> +			drm_framebuffer_unreference(fb);
>>  	} else if (connector->funcs->atomic_set_property) {
>>  		return connector->funcs->atomic_set_property(connector,
>>  				state, property, val);
>>  	} else {
>>  		return -EINVAL;
>>  	}
>> +
>> +	return 0;
>>  }
>>  EXPORT_SYMBOL(drm_atomic_connector_set_property);
>>
>> @@ -1040,6 +1085,9 @@ drm_atomic_connector_get_property(struct drm_connector *connector,
>>  		*val = (state->crtc) ? state->crtc->base.id : 0;
>>  	} else if (property == config->dpms_property) {
>>  		*val = connector->dpms;
>> +	} else if (property == config->writeback_fb_id_property) {
>> +		/* Writeback framebuffer is one-shot, write and forget */
>> +		*val = 0;
>>  	} else if (connector->funcs->atomic_get_property) {
>>  		return connector->funcs->atomic_get_property(connector,
>>  				state, property, val);
>> @@ -1223,6 +1271,42 @@ drm_atomic_set_crtc_for_connector(struct drm_connector_state *conn_state,
>>  EXPORT_SYMBOL(drm_atomic_set_crtc_for_connector);
>>
>>  /**
>> + * drm_atomic_set_fb_for_connector - set framebuffer for (writeback) connector
>
>Hm, I'd call this set_writeback_fb_for_connector, for even more
>obviousness.
>

Sure.

>> + * @conn_state: atomic state object for the connector
>> + * @fb: fb to use for the connector
>> + *
>> + * This is used to set the framebuffer for a writeback connector, which outputs
>> + * to a buffer instead of an actual physical connector.
>> + * Changing the assigned framebuffer requires us to grab a reference to the new
>> + * fb and drop the reference to the old fb, if there is one. This function
>> + * takes care of all these details besides updating the pointer in the
>> + * state object itself.
>> + *
>> + * Note: The only way conn_state can already have an fb set is if the commit
>> + * sets the property more than once.
>> + *
>> + * See also DOC: overview in drm_writeback.c
>> + */
>> +void
>> +drm_atomic_set_fb_for_connector(struct drm_connector_state *conn_state,
>> +				struct drm_framebuffer *fb)
>> +{
>
>Should we have a WARN_ON(conn_state->connector->type != WRITEBACK here)?
>Just for safety.
>

Yeah OK, certainly won't do any harm.

>> +	if (conn_state->fb)
>> +		drm_framebuffer_unreference(conn_state->fb);
>> +	if (fb)
>> +		drm_framebuffer_reference(fb);
>> +	conn_state->fb = fb;
>> +
>> +	if (fb)
>> +		DRM_DEBUG_ATOMIC("Set [FB:%d] for connector state %p\n",
>> +				 fb->base.id, conn_state);
>> +	else
>> +		DRM_DEBUG_ATOMIC("Set [NOFB] for connector state %p\n",
>> +				 conn_state);
>> +}
>> +EXPORT_SYMBOL(drm_atomic_set_fb_for_connector);
>> +
>> +/**
>>   * drm_atomic_add_affected_connectors - add connectors for crtc
>>   * @state: atomic state
>>   * @crtc: DRM crtc
>> @@ -1376,6 +1460,8 @@ int drm_atomic_check_only(struct drm_atomic_state *state)
>>  	struct drm_plane_state *plane_state;
>>  	struct drm_crtc *crtc;
>>  	struct drm_crtc_state *crtc_state;
>> +	struct drm_connector *conn;
>> +	struct drm_connector_state *conn_state;
>>  	int i, ret = 0;
>>
>>  	DRM_DEBUG_ATOMIC("checking %p\n", state);
>> @@ -1398,6 +1484,15 @@ int drm_atomic_check_only(struct drm_atomic_state *state)
>>  		}
>>  	}
>>
>> +	for_each_connector_in_state(state, conn, conn_state, i) {
>> +		ret = drm_atomic_connector_check(conn, conn_state);
>> +		if (ret) {
>> +			DRM_DEBUG_ATOMIC("[CONNECTOR:%d:%s] atomic core check failed\n",
>> +					 conn->base.id, conn->name);
>> +			return ret;
>> +		}
>> +	}
>> +
>>  	if (config->funcs->atomic_check)
>>  		ret = config->funcs->atomic_check(state->dev, state);
>>
>> diff --git a/drivers/gpu/drm/drm_atomic_helper.c b/drivers/gpu/drm/drm_atomic_helper.c
>> index 2c44de3..bba8672 100644
>> --- a/drivers/gpu/drm/drm_atomic_helper.c
>> +++ b/drivers/gpu/drm/drm_atomic_helper.c
>> @@ -3233,6 +3233,9 @@ __drm_atomic_helper_connector_duplicate_state(struct drm_connector *connector,
>>  	memcpy(state, connector->state, sizeof(*state));
>>  	if (state->crtc)
>>  		drm_connector_reference(connector);
>> +
>> +	/* Don't copy over framebuffers, they are used only once */
>> +	state->fb = NULL;
>>  }
>>  EXPORT_SYMBOL(__drm_atomic_helper_connector_duplicate_state);
>>
>> @@ -3360,6 +3363,8 @@ __drm_atomic_helper_connector_destroy_state(struct drm_connector_state *state)
>>  	 */
>>  	if (state->crtc)
>>  		drm_connector_unreference(state->connector);
>> +	if (state->fb)
>> +		drm_framebuffer_unreference(state->fb);
>>  }
>>  EXPORT_SYMBOL(__drm_atomic_helper_connector_destroy_state);
>>
>> diff --git a/drivers/gpu/drm/drm_connector.c b/drivers/gpu/drm/drm_connector.c
>> index 2db7fb5..e67084d 100644
>> --- a/drivers/gpu/drm/drm_connector.c
>> +++ b/drivers/gpu/drm/drm_connector.c
>> @@ -86,6 +86,7 @@ static struct drm_conn_prop_enum_list drm_connector_enum_list[] = {
>>  	{ DRM_MODE_CONNECTOR_VIRTUAL, "Virtual" },
>>  	{ DRM_MODE_CONNECTOR_DSI, "DSI" },
>>  	{ DRM_MODE_CONNECTOR_DPI, "DPI" },
>> +	{ DRM_MODE_CONNECTOR_WRITEBACK, "Writeback" },
>>  };
>>
>>  void drm_connector_ida_init(void)
>> @@ -235,7 +236,8 @@ int drm_connector_init(struct drm_device *dev,
>>  	list_add_tail(&connector->head, &config->connector_list);
>>  	config->num_connector++;
>>
>> -	if (connector_type != DRM_MODE_CONNECTOR_VIRTUAL)
>> +	if ((connector_type != DRM_MODE_CONNECTOR_VIRTUAL) &&
>> +	    (connector_type != DRM_MODE_CONNECTOR_WRITEBACK))
>>  		drm_object_attach_property(&connector->base,
>>  					      config->edid_property,
>>  					      0);
>> diff --git a/drivers/gpu/drm/drm_writeback.c b/drivers/gpu/drm/drm_writeback.c
>> new file mode 100644
>> index 0000000..5a6e0ad
>> --- /dev/null
>> +++ b/drivers/gpu/drm/drm_writeback.c
>> @@ -0,0 +1,157 @@
>> +/*
>> + * (C) COPYRIGHT 2016 ARM Limited. All rights reserved.
>> + * Author: Brian Starkey <brian.starkey@arm.com>
>> + *
>> + * This program is free software and is provided to you under the terms of the
>> + * GNU General Public License version 2 as published by the Free Software
>> + * Foundation, and any use by you of this program is subject to the terms
>> + * of such GNU licence.
>> + */
>> +
>> +#include <drm/drm_crtc.h>
>> +#include <drm/drm_property.h>
>> +#include <drm/drmP.h>
>> +
>> +/**
>> + * DOC: overview
>> + *
>> + * Writeback connectors are used to expose hardware which can write the output
>> + * from a CRTC to a memory buffer. They are used and act similarly to other
>> + * types of connectors, with some important differences:
>> + *  - Writeback connectors don't provide a way to output visually to the user.
>> + *  - Writeback connectors should always report as "disconnected" (so that
>> + *    clients which don't understand them will ignore them).
>> + *  - Writeback connectors don't have EDID.
>> + *
>> + * Writeback connectors may only be attached to a CRTC when they have a
>> + * framebuffer attached, and may only have a framebuffer attached when they are
>> + * attached to a CRTC. The WRITEBACK_FB_ID property which sets the framebuffer
>> + * applies only to a single commit (see below), which means that each and every
>> + * commit which makes use of a writeback connector must set both its CRTC_ID and
>> + * WRITEBACK_FB_ID. It also means that the connector's CRTC_ID must be
>> + * explicitly cleared in order to make a subsequent commit which doesn't use
>> + * writeback.
>
>Hm, this is a bit an ugly fallout from our safety checks, but I guess it's
>a reasonable requirement for userspace. Writeback is kinda special. Or
>should we make the ->crtc pointer one-shot too? Of course only for
>writeback pointers. I think that would make is simpler to use in libraries
>like igt.
>

I sort-of agree on the ugly fallout sentiment, it took me a bit by
surprise when some of my commits started failing :-). On the userspace
side it isn't really any additional effort once you understand the
requirements though (which you learn quickly by way of -EINVAL).

I'm actually leaning towards leaving it as-is for two reasons:
  1) On hardware that actually *does* need a full-modeset for writeback
     routing changes, a one-shot CRTC would cause problems (need a
     full-modeset every frame).
  2) If there's no explicit commit to disable, we have no way to
     communicate to the driver that it should disable - no-one will
     ever add the connector_state to the next commit.

Both of the above *could* be handled with some special casing, but my
gut feeling is it would be tricky and a bit of a mess.

The current implementation is reasonably clean, and does seem to have
removed a few corner cases which would be likely sources of driver
bugs.

>> + *
>> + * Writeback connectors have several additional properties, which userspace
>> + * can use to query and control them:
>> + *
>> + *  "WRITEBACK_FB_ID":
>> + *	Write-only object property storing a DRM_MODE_OBJECT_FB: it stores the
>> + *	framebuffer to be written by the writeback connector. This property is
>> + *	similar to the FB_ID property on planes, but will always read as zero
>> + *	and is not preserved across commits.
>> + *	Userspace must set this property to an output buffer every time it
>> + *	wishes the buffer to get filled.
>> + *
>> + *  "PIXEL_FORMATS":
>> + *	Immutable blob property to store the supported pixel formats table. The
>> + *	data is an array of u32 DRM_FORMAT_* fourcc values.
>> + *	Userspace can use this blob to find out what pixel formats are supported
>> + *	by the connector's writeback engine.
>> + *
>> + *  "PIXEL_FORMATS_SIZE":
>> + *	Immutable unsigned range property storing the number of entries in the
>> + *	PIXEL_FORMATS array.
>
>Blob properties already have a size, you don't need to specify it.
>Gamma tables have a size since they start out with a default of NULL, so
>userspace has no idea what the size should be.
>

OK, that makes sense. I'll drop it.

>Docs are missing to clarify when the writeout is complete. Should we wait
>with merging this until out fences are supported, or should we add a bit
>of placeholder text here that the writeback will be completed 1 vblank
>after this atomic commit was committed? I'm leaning towards including the
>writeout out fences from the start.
>

Docs are missing because without fences I don't think it can be
defined ;-)

You think I should squash fences into this commit then? It's getting
somewhat large, but I'm not spotting any obvious places to split it
up anymore.

>> + */
>> +
>> +/**
>> + * create_writeback_properties - Create writeback connector-specific properties
>> + * @dev: DRM device
>> + *
>> + * Create the properties specific to writeback connectors. These will be
>> + * attached to the connector and initialised by drm_writeback_connector_init.
>> + *
>> + * Returns: true on success, or false if any property creation fails.
>> + */
>
>We don't do kernel-doc for non-EXPORT_SYMBOL functions, since the intended
>audience is driver authors. And I think this function here is clear enough
>that we don't need even a normal comment for it.
>

Right, I must have copied and blindly modified without thinking.

>> +static bool create_writeback_properties(struct drm_device *dev)
>> +{
>> +	struct drm_property *prop;
>> +
>> +	if (!dev->mode_config.writeback_fb_id_property) {
>> +		prop = drm_property_create_object(dev, DRM_MODE_PROP_ATOMIC,
>> +						  "WRITEBACK_FB_ID",
>> +						  DRM_MODE_OBJECT_FB);
>> +		if (!prop)
>> +			return false;
>> +		dev->mode_config.writeback_fb_id_property = prop;
>> +	}
>> +
>> +	if (!dev->mode_config.pixel_formats_property) {
>> +		prop = drm_property_create(dev, DRM_MODE_PROP_BLOB | DRM_MODE_PROP_IMMUTABLE,
>> +					   "PIXEL_FORMATS", 0);
>> +		if (!prop)
>> +			return false;
>> +		dev->mode_config.pixel_formats_property = prop;
>> +	}
>> +
>> +	if (!dev->mode_config.pixel_formats_size_property) {
>> +		prop = drm_property_create_range(dev, DRM_MODE_PROP_IMMUTABLE,
>> +						 "PIXEL_FORMATS_SIZE", 0,
>> +						 UINT_MAX);
>> +		if (!prop)
>> +			return false;
>> +		dev->mode_config.pixel_formats_size_property = prop;
>> +	}
>> +
>> +	return true;
>> +}
>> +
>> +/**
>> + * drm_writeback_connector_init - Initialize a writeback connector and its properties
>> + * @dev: DRM device
>> + * @connector: Connector to initialize
>> + * @funcs: Connector funcs vtable
>> + * @formats: Array of supported pixel formats for the writeback engine
>> + * @n_formats: Length of the formats array
>> + *
>> + * This function creates the writeback-connector-specific properties if they
>> + * have not been already created, initializes the connector as
>> + * type DRM_MODE_CONNECTOR_WRITEBACK, and correctly initializes the property
>> + * values.
>> + *
>> + * Drivers should always use this function instead of drm_connector_init() to
>> + * set up writeback connectors.
>> + *
>> + * Returns: 0 on success, or a negative error code
>> + */
>> +int drm_writeback_connector_init(struct drm_device *dev,
>> +				 struct drm_connector *connector,
>> +				 const struct drm_connector_funcs *funcs,
>> +				 u32 *formats, int n_formats)
>> +{
>> +	int ret;
>> +	struct drm_property_blob *blob;
>> +	struct drm_mode_config *config = &dev->mode_config;
>> +
>> +	if (!create_writeback_properties(dev))
>> +		return -EINVAL;
>> +
>> +	blob = drm_property_create_blob(dev, n_formats * sizeof(*formats),
>> +					formats);
>> +	if (IS_ERR(blob))
>> +		return PTR_ERR(blob);
>> +
>> +	ret = drm_connector_init(dev, connector, funcs,
>> +				 DRM_MODE_CONNECTOR_WRITEBACK);
>> +	if (ret)
>> +		goto fail;
>> +
>> +	drm_object_attach_property(&connector->base,
>> +				   config->writeback_fb_id_property, 0);
>> +
>> +	drm_object_attach_property(&connector->base,
>> +				   config->pixel_formats_property,
>> +				   blob->base.id);
>> +	connector->pixel_formats_blob_ptr = blob;
>> +
>> +	drm_object_attach_property(&connector->base,
>> +				   config->pixel_formats_size_property,
>> +				   n_formats);
>> +
>> +	return 0;
>> +
>> +fail:
>> +	drm_property_unreference_blob(blob);
>> +	return ret;
>> +}
>> +EXPORT_SYMBOL(drm_writeback_connector_init);
>> diff --git a/include/drm/drm_atomic.h b/include/drm/drm_atomic.h
>> index 9701f2d..d9aff06 100644
>> --- a/include/drm/drm_atomic.h
>> +++ b/include/drm/drm_atomic.h
>> @@ -319,6 +319,9 @@ void drm_atomic_set_fb_for_plane(struct drm_plane_state *plane_state,
>>  int __must_check
>>  drm_atomic_set_crtc_for_connector(struct drm_connector_state *conn_state,
>>  				  struct drm_crtc *crtc);
>> +void
>> +drm_atomic_set_fb_for_connector(struct drm_connector_state *conn_state,
>> +				struct drm_framebuffer *fb);
>>  int __must_check
>>  drm_atomic_add_affected_connectors(struct drm_atomic_state *state,
>>  				   struct drm_crtc *crtc);
>> diff --git a/include/drm/drm_connector.h b/include/drm/drm_connector.h
>> index ac9d7d8..a5e3778 100644
>> --- a/include/drm/drm_connector.h
>> +++ b/include/drm/drm_connector.h
>> @@ -198,6 +198,7 @@ int drm_display_info_set_bus_formats(struct drm_display_info *info,
>>   * @connector: backpointer to the connector
>>   * @best_encoder: can be used by helpers and drivers to select the encoder
>>   * @state: backpointer to global drm_atomic_state
>> + * @fb: Writeback framebuffer, for DRM_MODE_CONNECTOR_WRITEBACK
>>   */
>>  struct drm_connector_state {
>>  	struct drm_connector *connector;
>> @@ -213,6 +214,8 @@ struct drm_connector_state {
>>  	struct drm_encoder *best_encoder;
>>
>>  	struct drm_atomic_state *state;
>> +
>> +	struct drm_framebuffer *fb;  /* do not write directly, use drm_atomic_set_fb_for_connector() */
>>  };
>>
>>  /**
>> @@ -612,6 +615,15 @@ struct drm_connector {
>>  	 */
>>  	struct drm_property_blob *tile_blob_ptr;
>>
>> +	/**
>> +	 * @pixel_formats_blob_ptr:
>> +	 *
>> +	 * DRM blob property data for the pixel formats list on writeback
>> +	 * connectors
>> +	 * See also DOC: overview in drm_writeback.c
>
>Ah, here's the link you wanted. Imo just use
>drm_writeback_connector_init() instead, that's a link close enough to your
>target.
>

OK.

>> +	 */
>> +	struct drm_property_blob *pixel_formats_blob_ptr;
>
>I'g go with a writeout prefix.

OK.

>> +
>>  /* should we poll this connector for connects and disconnects */
>>  /* hot plug detectable */
>>  #define DRM_CONNECTOR_POLL_HPD (1 << 0)
>> diff --git a/include/drm/drm_crtc.h b/include/drm/drm_crtc.h
>> index fe20d8f..378baee2 100644
>> --- a/include/drm/drm_crtc.h
>> +++ b/include/drm/drm_crtc.h
>> @@ -1345,6 +1345,26 @@ struct drm_mode_config {
>>  	 */
>>  	struct drm_property *suggested_y_property;
>>
>> +	/**
>> +	 * @writeback_fb_id_property: Property for writeback connectors, storing
>> +	 * the ID of the output framebuffer.
>> +	 * See also DOC: overview in drm_writeback.c
>
>Same here and all of the below.
>
>> +	 */
>> +	struct drm_property *writeback_fb_id_property;
>> +	/**
>> +	 * @pixel_formats_property: Property for writeback connectors, storing
>> +	 * an array of the supported pixel formats for the writeback engine
>> +	 * (read-only).
>> +	 * See also DOC: overview in drm_writeback.c
>> +	 */
>> +	struct drm_property *pixel_formats_property;
>> +	/**
>> +	 * @pixel_formats_size_property: Property for writeback connectors,
>> +	 * stating the size of the pixel formats array (read-only).
>> +	 * See also DOC: overview in drm_writeback.c
>> +	 */
>> +	struct drm_property *pixel_formats_size_property;
>> +
>>  	/* dumb ioctl parameters */
>>  	uint32_t preferred_depth, prefer_shadow;
>>
>> diff --git a/include/drm/drm_writeback.h b/include/drm/drm_writeback.h
>> new file mode 100644
>> index 0000000..afdc2742
>> --- /dev/null
>> +++ b/include/drm/drm_writeback.h
>> @@ -0,0 +1,19 @@
>> +/*
>> + * (C) COPYRIGHT 2016 ARM Limited. All rights reserved.
>> + * Author: Brian Starkey <brian.starkey@arm.com>
>> + *
>> + * This program is free software and is provided to you under the terms of the
>> + * GNU General Public License version 2 as published by the Free Software
>> + * Foundation, and any use by you of this program is subject to the terms
>> + * of such GNU licence.
>> + */
>> +
>> +#ifndef __DRM_WRITEBACK_H__
>> +#define __DRM_WRITEBACK_H__
>> +
>> +int drm_writeback_connector_init(struct drm_device *dev,
>> +				 struct drm_connector *connector,
>> +				 const struct drm_connector_funcs *funcs,
>> +				 u32 *formats, int n_formats);
>> +
>> +#endif
>> diff --git a/include/uapi/drm/drm_mode.h b/include/uapi/drm/drm_mode.h
>> index df0e350..e9cb4fe 100644
>> --- a/include/uapi/drm/drm_mode.h
>> +++ b/include/uapi/drm/drm_mode.h
>> @@ -247,6 +247,7 @@ struct drm_mode_get_encoder {
>>  #define DRM_MODE_CONNECTOR_VIRTUAL      15
>>  #define DRM_MODE_CONNECTOR_DSI		16
>>  #define DRM_MODE_CONNECTOR_DPI		17
>> +#define DRM_MODE_CONNECTOR_WRITEBACK	18
>>
>>  struct drm_mode_get_connector {
>>
>> --
>> 1.7.9.5
>>
>> _______________________________________________
>> dri-devel mailing list
>> dri-devel@lists.freedesktop.org
>> https://lists.freedesktop.org/mailman/listinfo/dri-devel
>
>-- 
>Daniel Vetter
>Software Engineer, Intel Corporation
>http://blog.ffwll.ch
>
