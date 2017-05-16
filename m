Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:56830 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750765AbdEPLzH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 16 May 2017 07:55:07 -0400
Date: Tue, 16 May 2017 14:54:31 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: kieran.bingham@ideasonboard.com
Cc: Kieran Bingham <kbingham@kernel.org>,
        laurent.pinchart@ideasonboard.com, niklas.soderlund@ragnatech.se,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [RFC PATCH v2 1/4] media: i2c: adv748x: add adv748x driver
Message-ID: <20170516115430.GN3227@valkosipuli.retiisi.org.uk>
References: <cover.5d2526b759f71c06d51df279c3d5885aca476fb6.1494523203.git-series.kieran.bingham+renesas@ideasonboard.com>
 <6aba7dbe2cdecc1afe6efc25fd0cea3f26508b1d.1494523203.git-series.kieran.bingham+renesas@ideasonboard.com>
 <20170512164633.GL3227@valkosipuli.retiisi.org.uk>
 <399f5310-1270-40a0-843a-3a07ebf47f38@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <399f5310-1270-40a0-843a-3a07ebf47f38@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

On Mon, May 15, 2017 at 01:32:41PM +0100, Kieran Bingham wrote:
> Hi Sakari
> 
> On 12/05/17 17:46, Sakari Ailus wrote:
> > Hi Kieran,
> > 
> > Thanks for the patches!
> 
> Thankyou for the review!

You're welcome! :-)

> 
> > Would you have a media-ctl -p && media-ctl --print-dot (or the PS file) to
> > see how this looks like in practice?
> 
> The file I linked to on Friday showed the immutable links version (I have that
> in as a temporary workaround until the links are correctly ignored by rvin /
> handled by core correctly)
> 
> So again, here is the posted 'immutable' version, which represents this patch
> version:
> 
>     http://janet.linuxembedded.co.uk/adv748x-immutable.png
> 
> But the end goal of this patchset will be the following configuration:
> 
>     http://janet.linuxembedded.co.uk/adv748x-non-immutable.png

What does media-ctl -p say?

...

> >> +static int adv748x_afe_g_input_status(struct v4l2_subdev *sd, u32 *status)
> >> +{
> >> +	struct adv748x_state *state = adv748x_afe_to_state(sd);
> >> +	int ret;
> >> +
> >> +	ret = mutex_lock_interruptible(&state->mutex);
> > 
> > I wonder if this is necessary. Do you expect the mutex to be taken for
> > extended periods of time?
> 
> It looks like the only other adv* driver to take a lock here is the 7180.
> Perhaps that is where the heritage of this code derived from.
> 
> I don't think the locking should be held for a long time anywhere, but I will
> try to go through and consider all the locking throughout the code base.
> 
> At the moment I think anything that calls adv748x_afe_status() should be locked
> to ensure serialisation through adv748x_afe_read_ro_map().

I meant whether you need the "_interruptible" part. It's quite a bit of
repeating error handling that looks mostly unnecessary.

> 
> 
> >> +	if (ret)
> >> +		return ret;
> >> +
> >> +	ret = adv748x_afe_status(state, status, NULL);
> >> +
> >> +	mutex_unlock(&state->mutex);
> >> +	return ret;
> >> +}

...

> >> +static int adv748x_afe_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
> >> +{
> >> +	struct adv748x_state *state =
> >> +		container_of(ctrl->handler, struct adv748x_state, afe.ctrl_hdl);
> >> +	unsigned int width, height, fps;
> >> +	v4l2_std_id std;
> >> +
> >> +	switch (ctrl->id) {
> >> +	case V4L2_CID_PIXEL_RATE:
> > 
> > I presume you will know when PIXEL_RATE changes? 
> 
> No interrupt handling in here yet to handle input changes - but I'm working on
> that. At the least it could be set on format configurations.

Ack. Then I guess this is good.

> 
> 
> > You can use
> > v4l2_ctrl_s_ctrl_int64() to change it. That way control events will be
> > emitted correctly, too.
> 
> Thanks - I didn't know about those helpers. I'll try to add where applicable.
> 
> These controls are indirectly read through the CSI2 'pass-through' entity.
> 
> Do I need to add some event handling in there to update it's control value to
> propagate the events?

As long as you allow subscribing the control event I guess nothing special
is needed.

..

> >> +int adv748x_afe_probe(struct adv748x_state *state, struct device_node *ep)
> >> +{
> >> +	int ret;
> >> +	unsigned int i;
> >> +
> >> +	state->afe.streaming = false;
> >> +	state->afe.curr_norm = V4L2_STD_ALL;
> >> +
> >> +	adv748x_subdev_init(&state->afe.sd, state, &adv748x_afe_ops, "afe");
> >> +
> >> +	/* Ensure that matching is based upon the endpoint fwnodes */
> >> +	state->afe.sd.fwnode = &ep->fwnode;
> > 
> > I wonder if you really need to convert all users of async matching to use
> > endpoints --- could you opportunistically peek if the device node matches,
> > just in case? You can't have an accidental positive match anyway.
> > 
> > So, the match is now for plain fwnode pointers, and it would be:
> > 
> > return async->fwnode == fwnode ||
> > 	port_parent(parent(async->fwnode)) == fwnode ||
> > 	async->fwnode == port_parent(parent(fwnode));
> 
> 
> If we adapt the core to match against endpoint comparisons and device node
> comparisons then yes we wouldn't have to adapt everything, I.e. we wouldn't have
> to change all the async devices - but we would have to adapt all the bus/bridge
> drivers (those who perform the v4l2_async_notifier_register() call) as they must
> register their notifier against an endpoint if they are to ever be able to
> connect to an ADV748x or other device which will rely upon multiple endpoints.

If there really is a need to, we can add a new framework helper function for
that --- as I think Niklas proposed. I'm not really sure it should be really
needed though; e.g. the omap3isp driver does without that.

...

> >> +void adv748x_subdev_init(struct v4l2_subdev *sd, struct adv748x_state *state,
> >> +		const struct v4l2_subdev_ops *ops, const char *ident)
> >> +{
> >> +	v4l2_subdev_init(sd, ops);
> >> +	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
> >> +
> >> +	/* the owner is the same as the i2c_client's driver owner */
> >> +	sd->owner = state->dev->driver->owner;
> >> +	sd->dev = state->dev;
> >> +
> >> +	v4l2_set_subdevdata(sd, state);
> > 
> > A lot of this would be done by v4l2_i2c_subdev_init(). You'd have to
> > relinquish your use of v4l2_set_subdevdata() --- it always points to the I²C
> > client in that case. You'll just need to dig your device state in a bit
> > different manner in that case.
> 
> I don't believe I can use v4l2_i2c_subdev_init, as it tries to unregister the
> i2c clients automatically.

Good point. That's there mostly for sub-devices that have been created by
drivers.

> 
> My use case here breaks the one subdevice -> one i2c client assumption held by
> the v4l2_i2c_subdev_init() and v4l2_device_unregister() code paths.

Ack. Feel free to ignore the comment then.

> 
> 
> > 
> >> +
> >> +	/* initialize name */
> >> +	snprintf(sd->name, sizeof(sd->name), "%s %d-%04x %s",
> >> +		state->dev->driver->name,
> >> +		i2c_adapter_id(state->client->adapter),
> >> +		state->client->addr, ident);
> >> +
> >> +	sd->entity.function = MEDIA_ENT_F_ATV_DECODER;
> >> +	sd->entity.ops = &adv748x_media_ops;
> >> +}
> >> +
> >> +static int adv748x_parse_dt(struct adv748x_state *state)
> >> +{
> >> +	struct device_node *ep_np = NULL;
> >> +	struct of_endpoint ep;
> >> +	unsigned int found = 0;
> >> +	int ret;
> >> +
> > 
> > Would of_graph_get_remote_node() do this more simple? Not necessarily, just
> > wondering.
> 
> I'm not certain I understand, but I don't think so.
> 
> Up to 12 ports could potentially be mapped in the DT. I want to enumerate all of
> them:
> 
> enum adv748x_ports {
> 	ADV748X_PORT_HDMI = 0,
> 	ADV748X_PORT_AIN1 = 1,
> 	ADV748X_PORT_AIN2 = 2,
> 	ADV748X_PORT_AIN3 = 3,
> 	ADV748X_PORT_AIN4 = 4,
> 	ADV748X_PORT_AIN5 = 5,
> 	ADV748X_PORT_AIN6 = 6,
> 	ADV748X_PORT_AIN7 = 7,
> 	ADV748X_PORT_AIN8 = 8,
> 	ADV748X_PORT_TTL = 9,
> 	ADV748X_PORT_TXA = 10,
> 	ADV748X_PORT_TXB = 11,
> 	ADV748X_PORT_MAX = 12,
> };
> 
> Whilst currently we are hardwired to input from AIN8 on the AFE (a Todo to
> adapt), I would envisage that there might be entities described in the DT to
> state which ports have connections on them.

Indeed. I was thinking of this code would look like if one was using
of_graph_get_remote_node().

> 
> I'd almost like to see the end video node being able to select from those
> (available) inputs as well - but that's out of scope for now - and we don't have
> a way to forward the 'inputs' through to the master driver.
> 
> >> +	for_each_endpoint_of_node(state->dev->of_node, ep_np) {
> >> +		ret = of_graph_parse_endpoint(ep_np, &ep);

of_graph_parse_endpoint() always succeeds.

Do you call it for other purposes than to print information on the endpoint?

> >> +		if (!ret) {
> >> +			adv_info(state, "Endpoint %s on port %d",
> >> +					of_node_full_name(ep.local_node),
> >> +					ep.port);
> >> +
> >> +			if (ep.port > ADV748X_PORT_MAX) {
> >> +				adv_err(state, "Invalid endpoint %s on port %d",
> >> +					of_node_full_name(ep.local_node),
> >> +					ep.port);
> >> +
> >> +				continue;
> >> +			}
> >> +
> >> +			state->endpoints[ep.port] = ep_np;
> >> +			found++;
> >> +		}
> >> +	}
> >> +
> >> +	return found ? 0 : -ENODEV;
> >> +}
> >> +

...

> >> diff --git a/drivers/media/i2c/adv748x/adv748x-csi2.c b/drivers/media/i2c/adv748x/adv748x-csi2.c
> >> new file mode 100644
> >> index 000000000000..d0a0fcfeae2e
> >> --- /dev/null
> >> +++ b/drivers/media/i2c/adv748x/adv748x-csi2.c

...

> >> +}
> >> +
> >> +static struct v4l2_subdev *adv748x_csi2_get_remote_sd(struct media_pad *local)
> >> +{
> >> +	struct media_pad *pad;
> >> +
> >> +	pad = media_entity_remote_pad(local);
> >> +	if (!pad) {
> >> +		return NULL;
> > 
> > if (...)
> > 	return NULL;
> > 
> >> +	}
> >> +
> >> +	return media_entity_to_v4l2_subdev(pad->entity);
> > 
> > Or:
> > 
> > return pad ? media...(pad->entity) : NULL;
> 
> Less lines - I like this better :)

How about making media_entity_to_v4l2_subdev() tolerate NULL argument? Then
it does just what you need here while others benefit from that, too.

> 
> > 
> >> +}
> >> +
> >> +/* -----------------------------------------------------------------------------
> >> + * v4l2_subdev_internal_ops
> >> + *
> >> + * We use the internal registered operation to be able to ensure that our
> >> + * incremental subdevices (not connected in the forward path) can be registered
> >> + * against the resulting video path and media device.
> >> + */
> >> +
> >> +static int adv748x_csi2_notify_complete(struct v4l2_async_notifier *notifier)
> >> +{
> >> +	struct adv748x_csi2 *tx = notifier_to_csi2(notifier);
> >> +	struct adv748x_state *state = tx->state;
> >> +	int ret;
> >> +
> >> +	ret = v4l2_device_register_subdev_nodes(tx->sd.v4l2_dev);
> >> +	if (ret) {
> >> +		adv_err(state, "Failed to register subdev nodes\n");
> >> +		return ret;
> >> +	}
> >> +
> >> +	/* Return early until we register TXB */
> >> +	if (is_txa(tx))
> >> +		return ret;
> >> +
> >> +	ret = adv748x_setup_links(state);
> > 
> > Could you set up links first? It'd be really annoying to clean up the mess
> > after the sub-device nodes have been registered. Actually --- it's not even
> > doable at the moment.
> 
> No - I don't think I can set up links until the devices are registered so that I
> have access to the media-dev.
> 
> I think I've already tried that :)

You still don't need to register the sub-device nodes, do you? The
sub-devices are already registered before
v4l2_device_register_subdev_nodes(), right?

> 
> > 
> >> +	if (ret) {
> >> +		adv_err(state, "Failed to setup entity links");
> >> +		return ret;
> >> +	}
> >> +
> >> +	return ret;
> >> +}
> >> +
> >> +static int adv748x_csi2_notify_bound(struct v4l2_async_notifier *notifier,
> >> +				   struct v4l2_subdev *subdev,
> >> +				   struct v4l2_async_subdev *asd)
> >> +{
> >> +	struct adv748x_csi2 *tx = notifier_to_csi2(notifier);
> >> +	struct adv748x_state *state = tx->state;
> >> +
> >> +	v4l2_set_subdev_hostdata(subdev, tx);
> >> +
> >> +	adv_info(state, "Bind %s -> %s", is_txa(tx)? "TXA":"TXB", subdev->name);
> >> +
> >> +	return 0;
> >> +}
> >> +static void adv748x_csi2_notify_unbind(struct v4l2_async_notifier *notifier,
> >> +				     struct v4l2_subdev *subdev,
> >> +				     struct v4l2_async_subdev *asd)
> >> +{
> >> +	struct adv748x_csi2 *tx = notifier_to_csi2(notifier);
> >> +	struct adv748x_state *state = tx->state;
> >> +
> >> +	adv_info(state, "Unbind %s -> %s", is_txa(tx)? "TXA":"TXB",
> >> +			subdev->name);
> >> +}
> >> +
> >> +static int adv748x_csi2_registered(struct v4l2_subdev *sd)
> >> +{
> >> +	struct adv748x_csi2 *tx = adv748x_sd_to_csi2(sd);
> >> +	struct adv748x_state *state = tx->state;
> >> +	int ret;
> >> +
> >> +	adv_info(state, "Registered %s (%s)", is_txa(tx)? "TXA":"TXB",
> >> +			sd->name);
> >> +
> >> +	/*
> >> +	 * Register HDMI on TXA, and AFE on TXB.
> >> +	 */
> >> +	if (is_txa(tx)) {
> >> +		tx->subdevs[0].match_type = V4L2_ASYNC_MATCH_FWNODE;
> >> +		tx->subdevs[0].match.fwnode.fwnode =
> >> +			of_fwnode_handle(state->endpoints[ADV748X_PORT_HDMI]);
> >> +	} else {
> >> +		/* TODO: This isn't right - Hardwiring to AIN8 ... ???? */
> >> +		tx->subdevs[0].match_type = V4L2_ASYNC_MATCH_FWNODE;
> >> +		tx->subdevs[0].match.fwnode.fwnode =
> >> +			of_fwnode_handle(state->endpoints[ADV748X_PORT_AIN8]);
> >> +	}
> >> +
> >> +	tx->subdev_p[0] = &tx->subdevs[0];
> >> +
> >> +	tx->notifier.num_subdevs = 1;
> >> +	tx->notifier.subdevs = tx->subdev_p;
> >> +
> >> +	tx->notifier.bound = adv748x_csi2_notify_bound;
> >> +	tx->notifier.unbind = adv748x_csi2_notify_unbind;
> >> +	tx->notifier.complete = adv748x_csi2_notify_complete;
> >> +
> >> +	ret = v4l2_async_subnotifier_register(&tx->sd, &tx->notifier);
> > 
> > How do things work out if there's a failure here? Any idea?
> 
> It would invoke the error path in v4l2_device_register_subdev() and start
> calling media_device_unregister_entity()
> 
> Do you envisage that we will need to handle something extra here?

Not necessarily. I was just wondering. We do have object lifetime issues
elsewhere...

> 
> > 
> >> +	if (ret < 0) {
> >> +		adv_err(state, "Notifier registration failed\n");
> >> +		return ret;
> >> +	}
> >> +
> >> +	return 0;
> >> +}
> >> +
> >> +static void adv748x_csi2_unregistered(struct v4l2_subdev *sd)
> >> +{
> >> +	struct adv748x_csi2 *tx = container_of(sd, struct adv748x_csi2, sd);
> >> +
> >> +	v4l2_async_subnotifier_unregister(&tx->notifier);
> >> +}
> >> +
> >> +static const struct v4l2_subdev_internal_ops adv748x_csi2_internal_ops = {
> >> +	.registered = adv748x_csi2_registered,
> >> +	.unregistered = adv748x_csi2_unregistered,
> >> +};
> >> +
> >> +/* -----------------------------------------------------------------------------
> >> + * v4l2_subdev_pad_ops
> >> + */
> >> +
> >> +static int adv748x_csi2_s_stream(struct v4l2_subdev *sd, int enable)
> >> +{
> >> +	struct adv748x_csi2 *tx = adv748x_sd_to_csi2(sd);
> >> +	struct v4l2_subdev *src;
> >> +	int ret;
> >> +
> >> +	src = adv748x_csi2_get_remote_sd(&tx->pads[ADV748X_CSI2_SINK]);
> >> +	if (!src)
> >> +		return -ENODEV;
> >> +
> >> +	ret = v4l2_subdev_call(src, video, s_stream, enable);
> > 
> > return v4l2_subdev_call();
> 
> Ack.
> 
> > 
> >> +
> >> +	return ret;
> >> +}
> >> +
> >> +static const struct v4l2_subdev_video_ops adv748x_csi2_video_ops = {
> >> +	.s_stream = adv748x_csi2_s_stream,
> >> +};
> >> +
> >> +/* -----------------------------------------------------------------------------
> >> + * v4l2_subdev_pad_ops
> >> + *
> >> + * The CSI2 bus pads, are ignorant to the data sizes or formats.
> >> + * But we must support setting the pad formats for format propagation.
> >> + */
> >> +
> >> +static struct v4l2_mbus_framefmt *
> >> +adv748x_csi2_get_pad_format(struct v4l2_subdev *sd,
> >> +			    struct v4l2_subdev_pad_config *cfg,
> >> +			    unsigned int pad, u32 which)
> >> +{
> >> +	struct adv748x_csi2 *tx = adv748x_sd_to_csi2(sd);
> >> +
> >> +	switch (which) {
> >> +	case V4L2_SUBDEV_FORMAT_TRY:
> >> +		return v4l2_subdev_get_try_format(sd, cfg, pad);
> >> +	case V4L2_SUBDEV_FORMAT_ACTIVE:
> >> +		return &tx->format;
> >> +	default:
> > 
> > This won't happen. I think a lot of drivers assume that.
> > 
> 
> Do you mean just remove the default case ? Won't this cause false positives on
> static analysers etc?

Not if you just do

if (which == V4L2_SUBDEV_FORMAT_ACTIVE)
	...;
else
	...;

Up to you.

> >> diff --git a/drivers/media/i2c/adv748x/adv748x-hdmi.c b/drivers/media/i2c/adv748x/adv748x-hdmi.c
> >> new file mode 100644
> >> index 000000000000..19c1bd41cc6c
> >> --- /dev/null
> >> +++ b/drivers/media/i2c/adv748x/adv748x-hdmi.c
> >> @@ -0,0 +1,671 @@

...

> >> +static const struct v4l2_dv_timings_cap adv748x_hdmi_timings_cap = {
> >> +	.type = V4L2_DV_BT_656_1120,
> >> +	/* keep this initialization for compatibility with GCC < 4.4.6 */
> >> +	.reserved = { 0 },
> > 
> > Is this necessary? Aren't the uninitialised fields zeroed if any field in a
> > struct is initialised, also on those versions of GCC? (Of course there have
> > been bugs, but nothing rings a bell.)
> 
> Looks like it is necessary:
>  https://patchwork.kernel.org/patch/2851851/

This is related to the anonymous union. What I'm saying appears unrelated
--- if any struct field is initialised, then the rest of the fields of the
struct are initialised to zero by the compiler (unless explicitly
initialised to something else).

I.e. you can drop ".reserved = { 0 }," line.

> 
> 
> > 
> >> +	/* Min pixelclock value is unknown */
> >> +	V4L2_INIT_BT_TIMINGS(ADV748X_HDMI_MIN_WIDTH, ADV748X_HDMI_MAX_WIDTH,
> >> +			     ADV748X_HDMI_MIN_HEIGHT, ADV748X_HDMI_MAX_HEIGHT,
> >> +			     ADV748X_HDMI_MIN_PIXELCLOCK,
> >> +			     ADV748X_HDMI_MAX_PIXELCLOCK,
> >> +			     V4L2_DV_BT_STD_CEA861 | V4L2_DV_BT_STD_DMT,
> >> +			     V4L2_DV_BT_CAP_INTERLACED |
> >> +			     V4L2_DV_BT_CAP_PROGRESSIVE)
> >> +};

... 


> >> +static int adv748x_hdmi_s_ctrl(struct v4l2_ctrl *ctrl)
> >> +{
> >> +	struct adv748x_state *state = container_of(ctrl->handler,
> >> +					struct adv748x_state, hdmi.ctrl_hdl);
> >> +	int ret;
> >> +
> >> +	ret = mutex_lock_interruptible(&state->mutex);
> > 
> > Could you use the same mutex for the control handler? It'd make things
> > simpler...
> 
> I believe the lock is about keeping the i2c accesses to the hardware serialised.
> 
> Isn't the lock for the control handler already taken by core? Or are you
> implying that I can register state->mutex as the lock for cotnrol handler ...
> 
> Interesting - I see in v4l2-ctrls.h that I can indeed do that!
> 
>  * @lock:	Lock to control access to this handler and its controls.
>  *		May be replaced by the user right after init.
> 
> I'll think this over... as I review all the locking.
> 
> Maybe it's not so bad keeping a single lock for the whole of the ADV748x

Ack.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
