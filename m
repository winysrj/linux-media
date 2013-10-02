Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:38488 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753532Ab3JBMX7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Oct 2013 08:23:59 -0400
Message-id: <524C1058.2050500@samsung.com>
Date: Wed, 02 Oct 2013 14:23:52 +0200
From: Andrzej Hajda <a.hajda@samsung.com>
MIME-version: 1.0
To: Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Jesse Barnes <jesse.barnes@intel.com>,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	Tom Gall <tom.gall@linaro.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	linux-media@vger.kernel.org,
	Stephen Warren <swarren@wwwdotorg.org>,
	Mark Zhang <markz@nvidia.com>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Ragesh Radhakrishnan <Ragesh.R@linaro.org>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Sunil Joshi <joshi@samsung.com>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Vikas Sajjan <vikas.sajjan@linaro.org>,
	Marcus Lorentzon <marcus.lorentzon@huawei.com>
Subject: Re: [PATCH/RFC v3 00/19] Common Display Framework
References: <1376068510-30363-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <52498146.4050600@ti.com>
In-reply-to: <52498146.4050600@ti.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomi,

On 09/30/2013 03:48 PM, Tomi Valkeinen wrote:
> On 09/08/13 20:14, Laurent Pinchart wrote:
>> Hi everybody,
>>
>> Here's the third RFC of the Common Display Framework.
> 
> 
> Hi,
> 
> I've been trying to adapt the latest CDF RFC for OMAP. I'm trying to gather
> some notes here about what I've discovered or how I see things. Some of these I
> have mentioned earlier, but I'm trying to collect them here nevertheless.
> 
> I do have my branch with working DPI panel, TFP410 encoder, DVI-connector and
> DSI command mode panel drivers, and modifications to make omapdss work with
> CDF.  However, it's such a big hack, that I'm not going to post it. I hope I
> will have time to work on it to get something publishable to have something
> more concrete to present. But for the time being I have to move to other tasks
> for a while, so I thought I'd better post some comments when I still remember
> something about this.
> 
> Using Linux buses for DBI/DSI
> =============================
> 
> I still don't see how it would work. I've covered this multiple times in
> previous posts so I'm not going into more details now.
> 
> I implemented DSI (just command mode for now) as a video bus but with bunch of
> extra ops for sending the control messages.

Could you post the list of ops you have to create.

I have posted some time ago my implementation of DSI bus:
http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/69358/focus=69362

I needed three quite generic ops to make it working:
- set_power(on/off),
- set_stream(on/off),
- transfer(dsi_transaction_type, tx_buf, tx_len, rx_buf, rx_len)
I have recently replaced set_power by PM_RUNTIME callbacks,
but I had to add .initialize ops.

Regarding the discussion how and where to implement control bus I have
though about different alternatives:
1. Implement DSI-master as a parent dev which will create DSI-slave
platform dev in a similar way as for MFD devices (ssbi.c seems to me a
good example).
2. Create universal mipi-display-bus which will cover DSI, DBI and
possibly other buses - they have have few common things - for example
MIPI-DCS commands.

I am not really convinced to either solution all have some advantages
and disadvantages.


> 
> Call model
> ==========
> 
> It may be that I just don't get how things are supposed to work with the RFC's
> ops, but I couldn't figure out how to use it in practice. I tried it for a few
> days, but got nowhere, and I then went with the proven model that's used in
> omapdss, where display entities handle calling the ops of the upstream
> entities.
> 
> That's not to say the RFC's model doesn't work. I just didn't figure it out.
> And I guess it was more difficult to understand how to use it as the controller
> stuff is not implemented yet.
> 
> It would be good to have a bit more complex cases in the RFC, like changing and
> verifying videomodes, fetching them via EDID, etc.
> 
> Multiple inputs/outputs
> =======================
> 
> I think changing the model from single-input & single output to multiple inputs
> and outputs increases the difficulty of the implementation considerably. That's
> not a complaint as such, just an observation. I do think multiple inputs &
> outputs is a good feature. Then again, all the use cases I have only have
> single input/output, so I've been wondering if there's some middle road, in
> which we somehow allow multiple inputs & outputs, but only implement the
> support for single input & output.
> 
> I've cut the corners in my tests by just looking at a single enabled input or
> output from an entity, and ignoring the rest (which I don't have in my use
> cases).
> 
> Internal connections
> ====================
> 
> The model currently only represents connections between entities. With multiple
> inputs & outputs I think it's important to maintain also connections inside the
> entity. Say, we have an entity with two inputs and two outputs. If one output
> is enabled, which one of the inputs needs to be enabled and configured also?
> The current model doesn't give any solution to that.
> 
> I haven't implemented this, as in my use cases I have just single inputs and
> outputs, so I can follow the pipeline trivially.
> 
> Central entity
> ==============
> 
> If I understand the RFC correctly, there's a "central" entity that manages all
> other entities connected to it. This central entity would normally be the
> display controller. I don't like this model, as it makes it difficult or
> impossible to manage situations where an entity is connected to two display
> controllers (even if only one of the display controllers would be connected at
> a time). It also makes this one display entity fundamentally different from the
> others, which I don't like.
> 
> I think all the display entities should be similar. They would all register
> themselves to the CDF framework, which in turn would be used by somebody. This
> somebody could be the display controller driver, which is more or less how I've
> implemented it.
> 
> Media entity/pads
> =================
> 
> Using media_entity and media_pad fits quite well for CDF, but... It is quite
> cumbersome to use. The constant switching between media_entity and
> display_entity needs quite a lot of code in total, as it has to be done almost
> everywhere.
> 
> And somehow I'd really like to combine the entity and port into one struct so
> that it would be possible to just do:
> 
> src->ops->foo(src, ...);
> 
> instead of
> 
> src->ops->foo(src, srcport, ...);
> 
> One reason is that the latter is more verbose (not only the call, you also need
> to get srcport from somewhere), but also that as far as the caller is
> concerned, there's no reason to manage the entity and the port as separate
> things. You just want a particular video source/sink to do something, and
> whether that source/sink is port 5 of entity foo is irrelevant.
> 
> The callee, of course, needs to check which port is being operated. However,
> if, say, 90% of the display entities have just one input and one output port,
> the port parameter can be ignored for those entities, simplifying the code.
> 
> And while media_entity can be embedded into display_entity, media_pad and
> media_link cannot be embedded into anything. This is somewhat vague as I don't
> quite remember what my reason for needing the feature was, but I had some need
> for display_link or display_pad, to add some CDF related entries, which can't
> be done except by modifying the media_link or media_pad themselves.
> 
> DT data & platform data
> =======================
> 
> I think the V4L2 style port/endpoint description in DT data should work well. I
> don't see a need for specifying the remote-endpoint in the upstream entity, but
> then again, it doesn't hurt either.
> 
> The description does get pretty verbose, though, but I guess that can't be
> avoided.
> 
> Describing similar things in the platform data works fine too. The RFC,
> however, contained somewhat lacking platform data examples which had to be
> extended to work with, for example, multiple instances of the same display
> entity. Also, the RFC relied on the central entity to parse the platform data,
> and in my model each display entity has its own platform data.
> 
> Final thoughts
> ==============
> 
> So many of the comments above are somewhat gut-feelings. I don't have concrete
> evidence that my ideas are better, as I haven't been able to finalize the code
> (well, and the RFC is missing important things like the controller).
> 
> I think there are areas where my model and the RFC are similar. I think one
> step would be to identify those parts, and perhaps have those parts as separate
> pieces of code. Say, the DT and platform data parts might be such that we could
> have display-of.c and display-pdata.c, having support code which works for the
> RFC and my model.
> 
> This would make it easier to maintain and improve both versions, to see how
> they evolve and what are the pros and cons with both models. But this is just a
> thought, I'm not sure how much such code there would actually be.
> 
>  Tomi
> 
> 
> 
> 
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
> 

