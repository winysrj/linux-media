Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:61856 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbaETKEn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 May 2014 06:04:43 -0400
Received: by mail-wi0-f182.google.com with SMTP id r20so624126wiv.3
        for <linux-media@vger.kernel.org>; Tue, 20 May 2014 03:04:42 -0700 (PDT)
Date: Tue, 20 May 2014 12:04:38 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: "Lin, Mengdong" <mengdong.lin@intel.com>
Cc: "Vetter, Daniel" <daniel.vetter@intel.com>,
	"Takashi Iwai (tiwai@suse.de)" <tiwai@suse.de>,
	"alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
	"intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
	"Yang, Libin" <libin.yang@intel.com>,
	"Nikkanen, Kimmo" <kimmo.nikkanen@intel.com>,
	"Koul, Vinod" <vinod.koul@intel.com>,
	"Babu, Ramesh" <ramesh.babu@intel.com>,
	"Shankar, Uma" <uma.shankar@intel.com>,
	"Girdwood, Liam R" <liam.r.girdwood@intel.com>,
	Greg KH <greg@kroah.com>,
	DRI Development <dri-devel@lists.freedesktop.org>,
	linux-media@vger.kernel.org
Subject: Re: [Intel-gfx] [RFC] set up an sync channel between audio and
 display driver (i.e. ALSA and DRM)
Message-ID: <20140520100438.GN8790@phenom.ffwll.local>
References: <F46914AEC2663F4A9BB62374E5EEF8F82B447059@SHSMSX101.ccr.corp.intel.com>
 <20140520100204.GM8790@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140520100204.GM8790@phenom.ffwll.local>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Also adding dri-devel and linux-media. Please don't forget these lists for
the next round.
-Daniel

On Tue, May 20, 2014 at 12:02:04PM +0200, Daniel Vetter wrote:
> Adding Greg just as an fyi since we've chatted briefly about the avsink
> bus. Comments below.
> -Daniel
> 
> On Tue, May 20, 2014 at 02:52:19AM +0000, Lin, Mengdong wrote:
> > This RFC is based on previous discussion to set up a generic communication channel between display and audio driver and
> > an internal design of Intel MCG/VPG HDMI audio driver. It's still an initial draft and your advice would be appreciated
> > to improve the design.
> > 
> > The basic idea is to create a new avsink module and let both drm and alsa depend on it.
> > This new module provides a framework and APIs for synchronization between the display and audio driver.
> > 
> > 1. Display/Audio Client
> > 
> > The avsink core provides APIs to create, register and lookup a display/audio client.
> > A specific display driver (eg. i915) or audio driver (eg. HD-Audio driver) can create a client, add some resources
> > objects (shared power wells, display outputs, and audio inputs, register ops) to the client, and then register this
> > client to avisink core. The peer driver can look up a registered client by a name or type, or both. If a client gives
> > a valid peer client name on registration, avsink core will bind the two clients as peer for each other. And we
> > expect a display client and an audio client to be peers for each other in a system.
> > 
> > int avsink_new_client ( const char *name,
> >                             int type,   /* client type, display or audio */
> >                             struct module *module,
> >                             void *context,
> >                             const char *peer_name,
> >                             struct avsink_client **client_ret);
> > 
> > int avsink_free_client (struct avsink_client *client);
> 
> 
> Hm, my idea was to create a new avsink bus and let vga drivers register
> devices on that thing and audio drivers register as drivers. There's a bit
> more work involved in creating a full-blown bus, but it has a lot of
> upsides:
> - Established infrastructure for matching drivers (i.e. audio drivers)
>   against devices (i.e. avsinks exported by gfx drivers).
> - Module refcounting.
> - power domain handling and well-integrated into runtime pm.
> - Allows integration into componentized device framework since we're
>   dealing with a real struct device.
> - Better decoupling between gfx and audio side since registration is done
>   at runtime.
> - We can attach drv private date which the audio driver needs.
> 
> > int avsink_register_client(struct avsink_client *client);
> > int avisink_unregister_client(int client_handle);
> > 
> > struct avsink_client *avsink_lookup_client(const char *name, int type);
> > 
> > struct avsink_client {
> >          const char *name;  /* client name */
> >          int type; /* client type*/
> >          void *context;
> >          struct module *module;  /* top-level module for locking */
> > 
> >          struct avsink_client *peer;      /* peer client */
> > 
> >          /* shared power wells */
> >          struct avsink_power_well *power_well;
> 
> We need to have an struct power_domain here so that we can do proper
> runtime pm. But like I've said above I think we actually want a full blown
> struct device.
> 
> >          int num_power_wells;
> > 
> >          /* endpoints, display outputs or audio inputs */
> >          struct avsink_endpoint * endpoint;
> >          int num_endpints;
> > 
> >          struct avsink_registers_ops *reg_ops; /* ops to access registers of a client */
> >          void *private_data;
> >          ...
> > };
> 
> I think you're indeed implementing a full blown bus here ;-)
> 
> avsink->client = bus devices/childern
> avsink->peer = driver for all this stuff
> avsink->power_well = runtime pm support for the avsink bus
> avsink->reg_ops = driver bind/unbind support
> 
> > On system boots, the avsink module is loaded before the display and audio driver module. And the display and audio
> > driver may be loaded on parallel.
> > * If a specific display driver (eg. i915) supports avsink, it can create a display client, add power wells and display
> >   outputs to the client, and then register the display client to the avsink core. Then it may look up if there is any
> >   audio client registered, by name or type, and may find an audio client registered by some audio driver.
> > 
> > * If an audio driver supports avsink, it usually should look up a registered display client by name or type at first,
> >   because it may need the shared power well in GPU and check the display outputs' name to bind the audio inputs. If
> >   the display client is not registered yet, the audio driver can choose to wait (maybe in a work queue) or return
> >   -EAGAIN for a deferred probe. After the display client is found, the audio driver can register an audio client with
> >   the display client's name as the peer name, the avsink core will bind the display and audio clients to each other.
> > 
> > Open question:
> > If the display or audio driver is disabled by the black list, shall we introduce a time out to avoid waiting for the
> > other client registered endlessly?
> 
> If the hdmi/dp side is a separate audio instance then we can just defer
> forever I think. If that's not the case (i.e. other audio outputs are also
> in the same alsa instance) then we need to be able to handle runtime
> loading of the gfx driver.
> 
> Both cases would work easier I think if we have a real bus and
> driver<->device matching.
> 
> > 2. Shared power wells (optional)
> > 
> > The audio and display devices, maybe only part of them, may share a common power well (e.g. for Intel Haswell and
> > Broadwell). If so, the driver that controls the power well should define a power well object, implement the get/put ops,
> > and add it to its avsink client before registering the client to avsink core. Then the peer client can look up this
> > power well by its name, and get/put this power well as a user.
> > 
> > A client can have multiple power well objects.
> > 
> > struct avsink_power_well {
> >          const char *name; /* name of the power well */
> >          void *context;   /* parameter of get/put ops, maybe device pointer for this power well */
> >          struct avsink_power_well_ops *ops
> > };
> > 
> > struct avsink_power_well_ops {
> >          int (*get)(void *context);
> >          int (*put)(void *context);
> > };
> > 
> > API:
> > int avsink_new_power(struct avsink_client *client,
> >                    const char *power_name,
> >                    void * power_context,
> >                    struct avsink_power_well_ops *ops,
> >                    struct avsink_power_well **power_ret);
> > 
> > struct avsink_power_well *avisnk_lookup_power(const char *name);
> > 
> > int avsink_get_power(struct avsink_power_well *power);  /* Reqesut the power */
> > int avsink_put_power(struct avsink_power_well *power);    /* Release the power */
> > 
> > For example, the i915 display driver can create a device for the shared power well in Haswell GPU, implement its PM
> > functions, and use the device pointer as the context when creating the power well object, like below
> > 
> > struct avsink_power_well_ops i915_power_well_ops = {
> >          .get = pm_runtime_get_sync;
> >          .put = pm_runtime_put_sync;
> > };
> > ...
> > avsink_new_power ( display_client,
> >                    "i915_display_power_well",
> >                    pdev,  /* pointer of the power well device */
> >                    &i915_power_well_ops,
> >                    ...)
> > 
> > Power domain is not used here since a single device seems enough to represent a power well.
> 
> Imo the point of the avsink stuff is _not_ to reinvent the wheel again. A
> real struct device per endpoint + runtime pm should be able to do
> everything we want.
> 
> > 3. Display output and audio input endpoints
> > 
> > A display client should register the display output endpoints and its audio peer client should register the audio input
> > endpoints. A client can have multiple endpoints. The avsink core will bind an audio input and a display output as peer
> > to each other. This is to allow the audio and display driver to synchronize with each other for each display pipeline.
> > 
> > All endpoints should be added to a client before the client is registered to avsink core. Dynamic endpoints are not
> > supported now.
> > 
> > A display out here represents a physical HDMI/DP output port. And as long as it's usable in the system (i.e. physically
> > connected to the HDMP/DP port on the machine board), the display output should be registered not matter the port is
> > connected to an external display device or not. And if HW and display driver can support DP1.2 daisy chain (multiple DP
> > display devices can be connected to a single port), multiple static displays outputs should be defined for the DP port
> > according to the HW capability. The port & display device number can be indicated by the name (e.g. "i915_DDI_B",
> > "i915_DDI_B_DEV0", "i915_DDI_B_DEV1", or "i915_DDI_B_DEV2"), defined by the display driver.
> > 
> > The audio driver can check the endpoints of its peer display client and use an display endpoint's name, or a presumed
> > display endpoint name, as peer name when registering an audio endpoint, thus the avsink core will bind the two display
> > and audio endpoints as peers.
> > 
> > struct avsink_endpoint {
> >          const char *name;  /*name of the endpoint */
> >          int type;            /* DISPLAY_OUTPUT or AUDIO_INPUT */
> >          void *context;           /* private data, used as parameter of the ops */
> >          struct avsink_endpoint_ops *ops;
> > 
> >          struct avsink_endpoint *peer; /* peer endpoint */
> > };
> > 
> > struct avsink_endpoint_ops {
> >          int (*get_caps) (enum had_caps_list query_element,
> >                             void *capabilities,
> >                             void *context);
> >          int (*set_caps) (enum had_caps_list set_element,
> >                             void *capabilities,
> >                             void *context);
> >          int (*event_handler) (enum avsink_event_type event_type, void *context);
> > };
> 
> Ok, this is confusing since get/set_caps are implemented by the gfx side.
> The event handler otoh is implemented by the audio side. This needs to be
> split up.
> 
> With a full device model the set/get stuff would be attached to the device
> while the event handler would be part of the driver.
> 
> > API:
> > int avsink_new_endpoint (struct avsink_client *client,
> >                             const char *name,
> >                             int type, /* DISPLAY_OUTPUT or AUDIO_INPUT*/
> >                             void *context,
> >                             const char *peer_name, /* can be NULL if no clue */
> >                             avsink_endpoint_ops *ops,
> >                             struct avsink_endpoint **endpoint_ret);
> > 
> > int avsink_endpoint_get_caps(struct avsink_endpoint *endpoint,
> >                             enum avsink_caps_list t get_element,
> >                             void *capabilities);
> > int avsink_endpoint_set_caps(struct avsink_endpoint *endpoint,
> >                             enum had_caps_list set_element,
> >                             void *capabilities);
> > 
> > int avsink_endpoint_post_event(struct avsink_endpoint *endpoint,
> >                             enum avsink_event_type event_type);
> > 
> > 4. Get/Set caps on an endpoint
> > 
> > The display or audio driver can get or set capabilities on an endpoint. Depending on the capability ID, the avsink core
> > will call get_caps/set_caps ops of this endpoint, or call get_caps/set_caps ops of its peer endpoint and return the
> > result to the caller.
> > 
> > enum avsink_caps_list {
> >          /* capabilities for display output endpoints */
> >          AVSINK_GET_DISPLAY_ELD = 1,
> >          AVSINK_GET_DISPLAY_TYPE, /* HDMI or DisplayPort */
> >          AVSINK_GET_DISPLAY_NAME, /* Hope to use display device name under /sys/class/drm, like "card0-DP-1", for user
> >                                      * space to figure out which HDMI/DP output on the drm side corresponds to which audio
> >                                        * stream device on the alsa side */
> >          AVSINK_GET_DISPLAY_SAMPLING_FREQ,      /* HDMI TMDS clock or DP link symbol clock, for audio driver to
> >                                                          * program N value
> >                                                         */
> >          AVSINK_GET_DISPLAY_HDCP_STATUS,
> >          AVSINK_GET_DISPLAY_AUDIO_STATUS, /* Whether audio is enabled */
> >          AVSINK_SET_DISPLAY_ENABLE_AUDIO, /* Enable audio */
> >          AVSINK_SET_DISPLAY_DISABLE_AUDIO,         /* Disable audio */
> >          AVSINK_SET_DISPLAY_ENABLE_AUDIO_INT, /* Enable audio interrupt */
> >          AVSINK_SET_DISPLAY_DISABLE_AUDIO_INT,         /* Disable audio interrupt */
> > 
> >          /* capabilities for audio input endpoints */
> >          AVSINK_GET_AUDIO_IS_BUSY,  /* Whether there is an active audio streaming */
> >          OTHERS_TBD,
> > };
> 
> I really don't like caps based apis. It's imo much better to have specific
> set/get functions. Also a lot of this could be passed to more specific
> event handlers directly (like the eld or the sampling freq).
> 
> If you have a void* somewhere in your interface you're throwing out an
> awful lot of safety checks gcc provides. Which is not good.
> 
> > For example, the audio driver can query ELD info on an audio input endpoint by using caps AVSINK_GET_DISPLAY_ELD, and
> > avsink core will call get_caps() on the peer display output endpoint and return the ELD info to the audio driver.
> > 
> > Some audio driver may only use part of these caps. E.g. HD-Audio driver can use bus commands instead of the ops to
> > control the audio on gfx side, so it doesn't use caps like ENABLE/DISABLE_AUDIO or ENABLE/DISABLE_AUDIO.
> > 
> > When the display driver want to disable a display pipeline for hot-plug, mode change or power saving, it can use caps
> > AVSINK_GET_AUDIO_IS_BUSY to check if the audio input is busy (active streaming) on this display pipeline. And if audio
> > is busy, the display driver can choose to wait or go ahead to disable display pipeline anyway. For the latter case, the
> > audio input endpoint will be notified by an event and should abort audio streaming.
> > 
> > 5. Event handling of endpoints
> > 
> > A driver can post events on an endpoint. Depending on the event type, the avsink core will call the endpoint's event
> > handler or pass the event to its peer endpoint and trigger the peer's event handler function if defined.
> > 
> > int avsink_endpoint_post_event(struct avsink_endpoint *endpoint,
> >                                      enum avsink_event_type event_type);
> > 
> > Now we only defined event types which should be handled by the audio input endpoints. The event types can be extended
> > in the future.
> > 
> > enum avsink_event_type {
> >         AVSINK_EVENT_DISPLAY_DISABLE = 1,  /* The display pipeline is disabled for hot-plug, mode change or
> >                                                          * suspend. Audio driver should stop any active streaming.
> >                                                         */
> >         AVSINK_EVENT_DISPLAY_ENABLE,                   /* The display pipeline is enabled after hot-plug, mode change or
> >                                                          * resume. Audio driver can restore previously interrupted streaming
> >                                                          */
> >         AVSINK_EVENT_DISPLAY_MODE_CHANGE,   /* Display mode change event. At this time, the new display mode is
> >                                                          * configured but the display pipeline is not enabled yet. Audio driver
> >                                                         * can do some configurations such as programing N value */
> >         AVSINK_EVENT_DISPLAY_AUDIO_BUFFER_DONE,         /* Audio Buffer done interrupts. Only for audio drivers if DMA and
> >                                                          * interrupt are handled by GPU
> >                                                         */
> >         AVSINK_EVENT_DISPLAY_AUDIO_BUFFER_UNDERRUN,       /* Audio Buffer under run interrupts. Only for audio drivers if
> >                                                                   * DMA and interrupt are handled by GPU
> >                                                                  */
> > };
> > 
> > So for a display driver, it can post an event on a display output endpoint and get processed by the peer audio input
> > endpoint. Or it can also directly post an event on a peer audio input endpoint, by using the 'peer' pointer on a
> > display output endpoint.
> 
> Again I don't like the enumeration, much better to have a bunch of
> specific callbacks. They can also supply interesting information to the
> driver directly if instead of audio driver needing to jump through a few
> get/set hooks.
> 
> > 6. Display register operation (optional)
> > 
> > Some audio driver needs to access GPU audio registers. The register ops are provided by the peer display client.
> > 
> > struct avsink_registers_ops {
> >          int (*read_register) (uint32_t reg_addr, uint32_t *data, void *context);
> >          int (*write_register) (uint32_t reg_addr, uint32_t data, void *context);
> >          int (*read_modify_register) (uint32_t reg_addr, uint32_t data, uint32_t mask, void *context);
> > 
> > int avsink_define_reg_ops (struct avsink_client *client, struct avsink_registers_ops *ops);
> > 
> > And avsink core provides API for the audio driver to access the display registers:
> > 
> > int avsink_read_display_register(struct avsink_client *client , uint32_t offset, uint32_t *data);
> > int avsink_write_display_register(struct avsink_client *client , uint32_t offset, uint32_t data);
> > int avsink_read_modify_display_register(struct avsink_client *client, uint32_t offset, uint32_t data, uint32_t mask);
> > 
> > If the client is an audio client, the avsink core will find it peer display client and call its register ops;
> > and if the client is a display client, the avsink core will just call its own register ops.
> 
> Oh dear. Where do we need this? Imo this is really horrible, but if we
> indeed need this then a struct device is better - we can attach mmio
> resources to devices and let the audio side remap them as best as they see
> fit.
> -Daniel
> -- 
> Daniel Vetter
> Software Engineer, Intel Corporation
> +41 (0) 79 365 57 48 - http://blog.ffwll.ch

-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
