Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:41102 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750812AbdEPW01 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 16 May 2017 18:26:27 -0400
Date: Wed, 17 May 2017 01:26:23 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc: Kieran Bingham <kbingham@kernel.org>,
        laurent.pinchart@ideasonboard.com, niklas.soderlund@ragnatech.se,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        gennarone@gmail.com
Subject: Re: [RFC PATCH v2 1/4] media: i2c: adv748x: add adv748x driver
Message-ID: <20170516222622.GQ3227@valkosipuli.retiisi.org.uk>
References: <cover.5d2526b759f71c06d51df279c3d5885aca476fb6.1494523203.git-series.kieran.bingham+renesas@ideasonboard.com>
 <6aba7dbe2cdecc1afe6efc25fd0cea3f26508b1d.1494523203.git-series.kieran.bingham+renesas@ideasonboard.com>
 <20170512164633.GL3227@valkosipuli.retiisi.org.uk>
 <399f5310-1270-40a0-843a-3a07ebf47f38@ideasonboard.com>
 <20170516115430.GN3227@valkosipuli.retiisi.org.uk>
 <76dee3f6-0187-1b9d-06ea-d49d85741d14@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <76dee3f6-0187-1b9d-06ea-d49d85741d14@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

On Tue, May 16, 2017 at 01:56:05PM +0100, Kieran Bingham wrote:
...
> >>>> +static int adv748x_afe_g_input_status(struct v4l2_subdev *sd, u32 *status)
> >>>> +{
> >>>> +	struct adv748x_state *state = adv748x_afe_to_state(sd);
> >>>> +	int ret;
> >>>> +
> >>>> +	ret = mutex_lock_interruptible(&state->mutex);
> >>>
> >>> I wonder if this is necessary. Do you expect the mutex to be taken for
> >>> extended periods of time?
> >>
> >> It looks like the only other adv* driver to take a lock here is the 7180.
> >> Perhaps that is where the heritage of this code derived from.
> >>
> >> I don't think the locking should be held for a long time anywhere, but I will
> >> try to go through and consider all the locking throughout the code base.
> >>
> >> At the moment I think anything that calls adv748x_afe_status() should be locked
> >> to ensure serialisation through adv748x_afe_read_ro_map().
> > 
> > I meant whether you need the "_interruptible" part. It's quite a bit of
> > repeating error handling that looks mostly unnecessary.
> > 
> 
> Aha - I see what you mean now...
> 
> Most of these use I2C transactions though, so that would be our source of any delay.
> 
> If it's acceptable to expect an I2C bus to never hang, or if the I2C subsystem
> can handle that, then we can chop the interruptible ... but I'm not sure I2C bus
> transactions are guaranteed like that ? Don't things like clock stretching, and
> unreliable hardware leave us vulnerable there...

$ git grep mutex_lock_interruptible -- drivers/media/i2c/
drivers/media/i2c/adv7180.c:    int err = mutex_lock_interruptible(&state->mutex);
drivers/media/i2c/adv7180.c:    int ret = mutex_lock_interruptible(&state->mutex);
drivers/media/i2c/adv7180.c:    int ret = mutex_lock_interruptible(&state->mutex);
drivers/media/i2c/adv7180.c:    int ret = mutex_lock_interruptible(&state->mutex);
drivers/media/i2c/adv7180.c:    ret = mutex_lock_interruptible(&state->mutex);
drivers/media/i2c/adv7180.c:    int ret = mutex_lock_interruptible(&state->mutex);
drivers/media/i2c/adv7180.c:    ret = mutex_lock_interruptible(&state->mutex);

That's all.

...

> >>>> +int adv748x_afe_probe(struct adv748x_state *state, struct device_node *ep)
> >>>> +{
> >>>> +	int ret;
> >>>> +	unsigned int i;
> >>>> +
> >>>> +	state->afe.streaming = false;
> >>>> +	state->afe.curr_norm = V4L2_STD_ALL;
> >>>> +
> >>>> +	adv748x_subdev_init(&state->afe.sd, state, &adv748x_afe_ops, "afe");
> >>>> +
> >>>> +	/* Ensure that matching is based upon the endpoint fwnodes */
> >>>> +	state->afe.sd.fwnode = &ep->fwnode;
> >>>
> >>> I wonder if you really need to convert all users of async matching to use
> >>> endpoints --- could you opportunistically peek if the device node matches,
> >>> just in case? You can't have an accidental positive match anyway.
> >>>
> >>> So, the match is now for plain fwnode pointers, and it would be:
> >>>
> >>> return async->fwnode == fwnode ||
> >>> 	port_parent(parent(async->fwnode)) == fwnode ||
> >>> 	async->fwnode == port_parent(parent(fwnode));
> >>
> >>
> >> If we adapt the core to match against endpoint comparisons and device node
> >> comparisons then yes we wouldn't have to adapt everything, I.e. we wouldn't have
> >> to change all the async devices - but we would have to adapt all the bus/bridge
> >> drivers (those who perform the v4l2_async_notifier_register() call) as they must
> >> register their notifier against an endpoint if they are to ever be able to
> >> connect to an ADV748x or other device which will rely upon multiple endpoints.
> > 
> > If there really is a need to, we can add a new framework helper function for
> > that --- as I think Niklas proposed. I'm not really sure it should be really
> > needed though; e.g. the omap3isp driver does without that.
> > 
> 
> I'm afraid I don't understand what you mean by omap3isp doing without ...

Sorry. I think I lost you somewhere --- I meant matching in the few drivers
that compare fwnodes. That'd break as a result unless the matching was
updated accordingly.

It'd be nice to remove that matching as well though but I think it'd be
safer not to.

> 
> In omap3isp/isp.c: isp_fwnodes_parse() the async notifier is registered looking
> at the endpoints parent fwnode:
> 
> 		isd->asd.match.fwnode.fwnode =
> 			fwnode_graph_get_remote_port_parent(fwnode);
> 
> This would therefore not support ADV748x ... (it wouldn't know which TX/CSI
> entity to match against)
> 
> So the way I see it is that all devices which currently register an async
> notifier should now register the match against the endpoint instead of the
> parent device:
> 
>  - isd->asd.match.fwnode.fwnode = fwnode_graph_get_remote_port_parent(fwnode);
>  + isd->asd.match.fwnode.fwnode = fwnode;
> 
> And then if we adapt the match to check against:
>    fwnode == fwnode || fwnode == fwnode_graph_get_remote_port_parent(fwnode);

That's not enough as a master driver may use device node whereas the
sub-device driver uses endpoint node. You need to do it both ways.

It's port parent, not endpoint's. There is / will be
fwnode_get_port_parent(), too.

> 
> This would then support existing sensor/remote devices which still store their
> (default) device fwnode, but also match specifically against devices which store
> their endpoint fwnode...
> 
> So this looks like the following drivers would need to be updated:
> 
> (users of fwnode.fwnode:)
>  drivers/media/platform/am437x/am437x-vpfe
>  drivers/media/platform/atmel/atmel-isc.c
>  drivers/media/platform/exynos4-is/media-dev.c
>  drivers/media/platform/omap3isp/isp.c
>  drivers/media/platform/pxa_camera.c
>  drivers/media/platform/rcar-vin
>  drivers/media/platform/soc_camera/soc_camera.c
>  drivers/media/platform/ti-vpe/cal.c
>  drivers/media/platform/xilinx/xilinx-vipp.c

Sounds good to me.

...

> >>>> +static int adv748x_parse_dt(struct adv748x_state *state)
> >>>> +{
> >>>> +	struct device_node *ep_np = NULL;
> >>>> +	struct of_endpoint ep;
> >>>> +	unsigned int found = 0;
> >>>> +	int ret;
> >>>> +
> >>>
> >>> Would of_graph_get_remote_node() do this more simple? Not necessarily, just
> >>> wondering.
> >>
> >> I'm not certain I understand, but I don't think so.
> >>
> >> Up to 12 ports could potentially be mapped in the DT. I want to enumerate all of
> >> them:
> >>
> >> enum adv748x_ports {
> >> 	ADV748X_PORT_HDMI = 0,
> >> 	ADV748X_PORT_AIN1 = 1,
> >> 	ADV748X_PORT_AIN2 = 2,
> >> 	ADV748X_PORT_AIN3 = 3,
> >> 	ADV748X_PORT_AIN4 = 4,
> >> 	ADV748X_PORT_AIN5 = 5,
> >> 	ADV748X_PORT_AIN6 = 6,
> >> 	ADV748X_PORT_AIN7 = 7,
> >> 	ADV748X_PORT_AIN8 = 8,
> >> 	ADV748X_PORT_TTL = 9,
> >> 	ADV748X_PORT_TXA = 10,
> >> 	ADV748X_PORT_TXB = 11,
> >> 	ADV748X_PORT_MAX = 12,
> >> };
> >>
> >> Whilst currently we are hardwired to input from AIN8 on the AFE (a Todo to
> >> adapt), I would envisage that there might be entities described in the DT to
> >> state which ports have connections on them.
> > 
> > Indeed. I was thinking of this code would look like if one was using
> > of_graph_get_remote_node().
> > 
> >>

Rob was pushing for that and I argued against. ;-) But please use it if it
works better. As an interface it is more simple, but there's a number of
ports to check.

It made a bunch of drivers cleaner but then again V4L2 fwnode parses a lot
of this already.

> >> (available) inputs as well - but that's out of scope for now - and we don't have
> >> a way to forward the 'inputs' through to the master driver.
> >>
> >>>> +	for_each_endpoint_of_node(state->dev->of_node, ep_np) {
> >>>> +		ret = of_graph_parse_endpoint(ep_np, &ep);
> > 
> > of_graph_parse_endpoint() always succeeds.
> > 
> > Do you call it for other purposes than to print information on the endpoint?
> 
> To get the port and verify it.
> 
> Now I think I see where you were going with of_graph_get_remote_node().
> This could just loop through 'known port' values instead... removing the need to
> parse_endpoint, and have other error checks...
> 
> > 
> >>>> +		if (!ret) {
> >>>> +			adv_info(state, "Endpoint %s on port %d",
> >>>> +					of_node_full_name(ep.local_node),
> >>>> +					ep.port);
> >>>> +
> >>>> +			if (ep.port > ADV748X_PORT_MAX) {
> >>>> +				adv_err(state, "Invalid endpoint %s on port %d",
> >>>> +					of_node_full_name(ep.local_node),
> >>>> +					ep.port);
> >>>> +
> >>>> +				continue;
> >>>> +			}
> >>>> +
> >>>> +			state->endpoints[ep.port] = ep_np;
> >>>> +			found++;
> >>>> +		}
> >>>> +	}
> >>>> +
> >>>> +	return found ? 0 : -ENODEV;
> >>>> +}
> >>>> +
> > 
> > ...
> > 
> >>>> diff --git a/drivers/media/i2c/adv748x/adv748x-csi2.c b/drivers/media/i2c/adv748x/adv748x-csi2.c
> >>>> new file mode 100644
> >>>> index 000000000000..d0a0fcfeae2e
> >>>> --- /dev/null
> >>>> +++ b/drivers/media/i2c/adv748x/adv748x-csi2.c

...

> >>>> +/* -----------------------------------------------------------------------------
> >>>> + * v4l2_subdev_internal_ops
> >>>> + *
> >>>> + * We use the internal registered operation to be able to ensure that our
> >>>> + * incremental subdevices (not connected in the forward path) can be registered
> >>>> + * against the resulting video path and media device.
> >>>> + */
> >>>> +
> >>>> +static int adv748x_csi2_notify_complete(struct v4l2_async_notifier *notifier)
> >>>> +{
> >>>> +	struct adv748x_csi2 *tx = notifier_to_csi2(notifier);
> >>>> +	struct adv748x_state *state = tx->state;
> >>>> +	int ret;
> >>>> +
> >>>> +	ret = v4l2_device_register_subdev_nodes(tx->sd.v4l2_dev);
> >>>> +	if (ret) {
> >>>> +		adv_err(state, "Failed to register subdev nodes\n");
> >>>> +		return ret;
> >>>> +	}
> >>>> +
> >>>> +	/* Return early until we register TXB */
> >>>> +	if (is_txa(tx))
> >>>> +		return ret;
> >>>> +
> >>>> +	ret = adv748x_setup_links(state);
> >>>
> >>> Could you set up links first? It'd be really annoying to clean up the mess
> >>> after the sub-device nodes have been registered. Actually --- it's not even
> >>> doable at the moment.
> >>
> >> No - I don't think I can set up links until the devices are registered so that I
> >> have access to the media-dev.
> >>
> >> I think I've already tried that :)
> > 
> > You still don't need to register the sub-device nodes, do you? The
> > sub-devices are already registered before
> > v4l2_device_register_subdev_nodes(), right?
> > 
> 
> Don't worry about the code above - It's all been deleted.
> 
> I realised I was using the async notifiers to register the AFE/HDMI entities but
> it was completely overkill.

Ack. Good. Sometimes you figure out how best do something while explaining
it to others... :-) (I was happy to listen.)

...

> >>>> diff --git a/drivers/media/i2c/adv748x/adv748x-hdmi.c b/drivers/media/i2c/adv748x/adv748x-hdmi.c
> >>>> new file mode 100644
> >>>> index 000000000000..19c1bd41cc6c
> >>>> --- /dev/null
> >>>> +++ b/drivers/media/i2c/adv748x/adv748x-hdmi.c
> >>>> @@ -0,0 +1,671 @@
> > 
> > ...
> > 
> >>>> +static const struct v4l2_dv_timings_cap adv748x_hdmi_timings_cap = {
> >>>> +	.type = V4L2_DV_BT_656_1120,
> >>>> +	/* keep this initialization for compatibility with GCC < 4.4.6 */
> >>>> +	.reserved = { 0 },
> >>>
> >>> Is this necessary? Aren't the uninitialised fields zeroed if any field in a
> >>> struct is initialised, also on those versions of GCC? (Of course there have
> >>> been bugs, but nothing rings a bell.)
> >>
> >> Looks like it is necessary:
> >>  https://patchwork.kernel.org/patch/2851851/
> > 
> > This is related to the anonymous union. What I'm saying appears unrelated
> > --- if any struct field is initialised, then the rest of the fields of the
> > struct are initialised to zero by the compiler (unless explicitly
> > initialised to something else).
> > 
> > I.e. you can drop ".reserved = { 0 }," line.
> 
> In that patch I referenced, (several of the drivers were all updated in a
> similar fashion) Gianluca mentioned the following:
> 
> > 
> > Please note that I have also to init the reserved space as otherwise GCC fails with this error:
> > 
> >  CC [M]  adv7842.o
> >  adv7842.c:549: error: field name not in record or union initializer
> >  adv7842.c:549: error: (near initialization for  'adv7842_timings_cap_analog.reserved')
> >  adv7842.c:549: warning: braces around  scalar initializer
> >  adv7842.c:549: warning: (near initialization for  'adv7842_timings_cap_analog.reserved[0]')

I had to test that here. :-) Ouch. And I'm left wondering how does the
initialisation of the reserved field get things working again...

Anyway, please ignore the original comment.

> 
> Therefore my understanding was that it was necessary.
> 
> If not - then we can remove from the following drivers too:
> 
> git grep ".reserved = { 0 }"
> drivers/media/i2c/ad9389b.c:    .reserved = { 0 },
> drivers/media/i2c/adv7511.c:    .reserved = { 0 },
> drivers/media/i2c/adv7604.c:    .reserved = { 0 },
> drivers/media/i2c/adv7604.c:    .reserved = { 0 },
> drivers/media/i2c/adv7842.c:    .reserved = { 0 },
> drivers/media/i2c/adv7842.c:    .reserved = { 0 },
> drivers/media/i2c/tc358743.c:   .reserved = { 0 },
> drivers/media/i2c/ths8200.c:    .reserved = { 0 },
> drivers/media/platform/vivid/vivid-vid-common.c:        .reserved = { 0 },
> drivers/media/spi/gs1662.c:     .reserved = { 0 },
> samples/v4l/v4l2-pci-skeleton.c:        .reserved = { 0 },
> 
> But maybe we should test with an older compiler to verify this...
> 
> Is there a cut-off point where we would stop supporting older compilers?

I guess when people stop submitting patches to support them? :-)

Documentation/admin-guide/README.rst says that at least GCC 3.2 should be
used. That's very, very old. I wonder if anyone has recently used such an
old version...

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
