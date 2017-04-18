Return-path: <linux-media-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:59258 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752817AbdDRRew (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Apr 2017 13:34:52 -0400
Date: Tue, 18 Apr 2017 18:34:43 +0100
From: Brian Starkey <brian.starkey@arm.com>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        liviu.dudau@arm.com, laurent.pinchart@ideasonboard.com,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 1/6] drm: Add writeback connector type
Message-ID: <20170418173443.GA325@e106950-lin.cambridge.arm.com>
References: <1480092544-1725-1-git-send-email-brian.starkey@arm.com>
 <1480092544-1725-2-git-send-email-brian.starkey@arm.com>
 <20170414120823.2cafc748@bbrezillon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20170414120823.2cafc748@bbrezillon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Boris,

On Fri, Apr 14, 2017 at 12:08:23PM +0200, Boris Brezillon wrote:
>On Fri, 25 Nov 2016 16:48:59 +0000
>Brian Starkey <brian.starkey@arm.com> wrote:
>
>
>>
>> diff --git a/drivers/gpu/drm/drm_connector.c b/drivers/gpu/drm/drm_connector.c
>> index b5c6a8e..6bbd93f 100644
>> --- a/drivers/gpu/drm/drm_connector.c
>> +++ b/drivers/gpu/drm/drm_connector.c
>> @@ -86,6 +86,7 @@ struct drm_conn_prop_enum_list {
>>  	{ DRM_MODE_CONNECTOR_VIRTUAL, "Virtual" },
>>  	{ DRM_MODE_CONNECTOR_DSI, "DSI" },
>>  	{ DRM_MODE_CONNECTOR_DPI, "DPI" },
>> +	{ DRM_MODE_CONNECTOR_WRITEBACK, "Writeback" },
>
>Is there a reason we have a Writeback connector, but keep using a
>Virtual encoder to connect it to the CRTC? Wouldn't it make more sense
>to also add a Writeback encoder?
>

Only that a writeback connector is functionally and conceptually quite
different from the existing connector types, whereas the "encoder"
(which realistically only exists because the framework forces it to)
acts pretty much like any other.

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
>
>Nitpick: you don't need the extra parenthesis:
>
>	if (connector_type != DRM_MODE_CONNECTOR_VIRTUAL &&
>	    connector_type != DRM_MODE_CONNECTOR_WRITEBACK)
>

Yeah fair enough, I can drop them.

>>  		drm_object_attach_property(&connector->base,
>>  					      config->edid_property,
>>  					      0);
>
>
>
>> diff --git a/include/drm/drm_connector.h b/include/drm/drm_connector.h
>> index 34f9741..dc4910d6 100644
>> --- a/include/drm/drm_connector.h
>> +++ b/include/drm/drm_connector.h
>> @@ -214,6 +214,19 @@ struct drm_connector_state {
>>  	struct drm_encoder *best_encoder;
>>
>>  	struct drm_atomic_state *state;
>> +
>> +	/**
>> +	 * @writeback_job: Writeback job for writeback connectors
>> +	 *
>> +	 * Holds the framebuffer for a writeback connector. As the writeback
>> +	 * completion may be asynchronous to the normal commit cycle, the
>> +	 * writeback job lifetime is managed separately from the normal atomic
>> +	 * state by this object.
>> +	 *
>> +	 * See also: drm_writeback_queue_job() and
>> +	 * drm_writeback_signal_completion()
>> +	 */
>> +	struct drm_writeback_job *writeback_job;
>
>Maybe I'm wrong, but is feels weird to have the writeback_job field
>directly embedded in drm_connector_state, while drm_writeback_connector
>inherits from drm_connector.
>
>IMO, either you decide to directly put the drm_writeback_connector's
>job_xxx fields in drm_connector and keep the drm_connector_state as is,
>or you create a drm_writeback_connector_state which inherits from
>drm_connector_state and embeds the writeback_job field.

I did spend a decent amount of time looking at tracking the writeback
state along with the normal connector state. I couldn't come up with
anything I liked.

As the comment mentions, one of the problems is that you have to make
sure the relevant parts of the connector_state stay around until the
writeback is finished. That means you've got to block before
"swap_state()" until the previous writeback is done, and that
effectively limits your frame rate to refresh/2.

The Mali-DP HW doesn't have that limitation - we can queue up a new
commit while the current writeback is ongoing. For that reason I
didn't want to impose such a limitation in the framework.

In v1 I allowed that by making the Mali-DP driver hold its own
references to the relevant bits of the state for as long as it needed
them. In v3 I moved most of that code back to the core (in part
because Gustavo didn't like me signalling the DRM-"owned" fence from
my driver code directly). I think the new approach of "queue_job()"
and "signal_job()" reduces the amount of tricky code in drivers, and
is generally more clear (also familiar, when compared to vsync
events).

I'm certain there's other ways to do it (refcount atomic states?), but
it seemed like a biggish overhaul to achieve what would basically be
the same thing.

I was expecting each driver supporting writeback to have its own
different requirements around writeback lifetime/duration. For example
I think VC4 specifically came up, in that its writeback could take
several frames, whereas on Mali-DP we either finish within the frame
or we fail.

Letting the driver manage its writeback_job lifetime seemed like a
reasonable way to handle all that, with the documentation stating the
only behaviour which is guaranteed to work on all drivers:

   *     Userspace should wait for this fence to signal before making another
   *     commit affecting any of the same CRTCs, Planes or Connectors.
   *     **Failure to do so will result in undefined behaviour.**
   *     For this reason it is strongly recommended that all userspace
   *     applications making use of writeback connectors *always* retrieve an
   *     out-fence for the commit and use it appropriately.



... so all of that is why the _job fields don't live in a *_state
structure directly, and instead have to live in the separately-managed
structure pointed to by ->writeback_job.

Now, I did look at creating drm_writeback_connector_state, but as it
would only be holding the job pointer (see above) it didn't seem worth
scattering around the

    if (conn_state->connector->connector_type ==
        DRM_MODE_CONNECTOR_WRITEBACK)

checks everywhere before up-casting - {clear,reset,duplicate}_state(),
prepare_signalling(), complete_signalling(), etc. It just touched a
lot of code for the sake of an extra pointer field in each connector
state.

I can easily revisit that part if you like.

>
>Anyway, wait for Daniel's feedback before doing this change.
>

Am I expecting some more feedback from Daniel?

>>  };
>>
>>  /**
>> diff --git a/include/drm/drm_mode_config.h b/include/drm/drm_mode_config.h
>> index bf9991b2..3d3d07f 100644
>> --- a/include/drm/drm_mode_config.h
>> +++ b/include/drm/drm_mode_config.h
>> @@ -634,6 +634,20 @@ struct drm_mode_config {
>>  	 */
>>  	struct drm_property *suggested_y_property;
>>
>> +	/**
>> +	 * @writeback_fb_id_property: Property for writeback connectors, storing
>> +	 * the ID of the output framebuffer.
>> +	 * See also: drm_writeback_connector_init()
>> +	 */
>> +	struct drm_property *writeback_fb_id_property;
>> +	/**
>> +	 * @writeback_pixel_formats_property: Property for writeback connectors,
>> +	 * storing an array of the supported pixel formats for the writeback
>> +	 * engine (read-only).
>> +	 * See also: drm_writeback_connector_init()
>> +	 */
>> +	struct drm_property *writeback_pixel_formats_property;
>> +
>>  	/* dumb ioctl parameters */
>>  	uint32_t preferred_depth, prefer_shadow;
>>
>> diff --git a/include/drm/drm_writeback.h b/include/drm/drm_writeback.h
>> new file mode 100644
>> index 0000000..6b2ac45
>> --- /dev/null
>> +++ b/include/drm/drm_writeback.h
>> @@ -0,0 +1,78 @@
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
>> +#include <drm/drm_connector.h>
>> +#include <linux/workqueue.h>
>> +
>> +struct drm_writeback_connector {
>> +	struct drm_connector base;
>
>AFAIU, a writeback connector will always require an 'dummy' encoder to
>make the DRM framework happy (AFAIK, a connector is always connected to
>a CRTC through an encoder).
>
>Wouldn't it make more sense to have a drm_encoder object embedded in
>drm_writeback_connector so that people don't have to declare an extra
>structure containing both the drm_writeback_connector connector and a
>drm_encoder? Is there a good reason to keep them separate?
>

Yeah that's not a bad idea. The encoder funcs could be passed in to
drm_writeback_connector_init() (in which case adding a writeback
encoder type would also make sense).

Thanks for the review,

-Brian

>> +
>> +	/**
>> +	 * @pixel_formats_blob_ptr:
>> +	 *
>> +	 * DRM blob property data for the pixel formats list on writeback
>> +	 * connectors
>> +	 * See also drm_writeback_connector_init()
>> +	 */
>> +	struct drm_property_blob *pixel_formats_blob_ptr;
>> +
>> +	/** @job_lock: Protects job_queue */
>> +	spinlock_t job_lock;
>> +	/**
>> +	 * @job_queue:
>> +	 *
>> +	 * Holds a list of a connector's writeback jobs; the last item is the
>> +	 * most recent. The first item may be either waiting for the hardware
>> +	 * to begin writing, or currently being written.
>> +	 *
>> +	 * See also: drm_writeback_queue_job() and
>> +	 * drm_writeback_signal_completion()
>> +	 */
>> +	struct list_head job_queue;
>> +};
