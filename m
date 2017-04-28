Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:36444
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1424931AbdD1L0H (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Apr 2017 07:26:07 -0400
Date: Fri, 28 Apr 2017 08:26:00 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Niklas =?UTF-8?B?U8O2ZGVybHVuZA==?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 0/2] media: entity: add operation to help map DT node to
 media pad
Message-ID: <20170428082600.0193f26f@vento.lan>
In-Reply-To: <20170427223323.13861-1-niklas.soderlund+renesas@ragnatech.se>
References: <20170427223323.13861-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Em Fri, 28 Apr 2017 00:33:21 +0200
Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se> escreveu:

> Hi,
> 
> This small series add a new entity operation which will aid capture 
> drivers to map a port/endpoint in DT to a media graph pad. I looked 
> around and in my experience most drivers assume the DT port number is 
> the same as the media pad number.
> 
> This might be true for most devices but there are cases where this 
> mapping do not hold true. This series is implemented support to the 
> ongoing ADV748x work by Kieran Bingham, [1]. In his work he have a 
> driver which registers more then one subdevice. So when a driver finds 
> this subdevice it must be able to ask the subdevice itself which pad 
> number correspond to the DT endpoint the driver used to bind subdevice 
> in the first place.
> 
> I have updated my R-Car CSI-2 patch series to use this new function to 
> ask it's subdevice to resolve the media pad.

The problem of finding a PAD is not specific for DT-based devices.
So, what we need is a generic way to find a pad.

The non-DT based drivers usually don't implement subdev API. So, they
need to build the pipelines themselves. On such devices, there are
hundreds of different combinations of devices, and the main driver
needs to seek the hardware connected into it. Based on such
runtime knowledge, setup the pipelines.

One such example is em28xx with can use a wide range of different 
tuners, analog TV decoders and digital TV frontends.

The I2C devices like tuners and decoders have pads with different
signals:
	- RF 
	- digital video (encoded with ITU-R BT.656 or similar)
	- audio IF signal
	- chroma IF signal
	- baseband signal
	- luminance IF signal
	- digital audio (using I2S)
	- composite video
	- ...

Right now, this is "solved" by using enums at include/media/v4l2-mc.h,
like this one:

enum tuner_pad_index {
	TUNER_PAD_RF_INPUT,
	TUNER_PAD_OUTPUT,
	TUNER_PAD_AUD_OUT,
	TUNER_NUM_PADS
};

That's not optimal, as even tuners that don't provide, for example,
an audio output pad need to have an unconnected TUNER_PAD_AUD_OUT
pad [1].

[1] With the current model, we're using TUNER_PAD_AUD_OUT for both
IF and digital audio - as currently - drivers don't need to distinguish
and we didn't want to have an excessive number of unconnected PADs.

So, what we really need is a way to represent a set of properties
associated with pads, and a function that would seek for a PAD that
matches a property set.

There is a proposal from Sakari to have a properties API that would
allow such kind of association (among others) and would even let
export such properties to userspace, but he never had time to send
us patches adding such functionality.

- 

IMHO, what we should do, instead of the approach you took, would be
to create a list of properties associated with each PAD (or, actually,
to any graph object, as we may want later to have properties also for
entities, interfaces and links). Something like:

enum media_property_type {
	MEDIA_PROP_PAD_DT_PORT_REG,	// not sure if this is the best name
	MEDIA_PROP_PAD_DT_REG,	// not sure if this is the best name
	MEDIA_PROP_PAD_SIGNAL_TYPE,	// that's for the above example of identifying a pad based on the signal it carries: I2S, RF, IF, ...
	...
};

struct media_properties {
	enum media_property_type type;
	int value;

	struct list_head *list;
};

struct media_graph {
	struct {
		struct media_entity *entity;
		struct list_head *link;
	} stack[MEDIA_ENTITY_ENUM_MAX_DEPTH];

	struct media_entity_enum ent_enum;
	int top;

	struct list_head *props; /* head for struct media_properties */
};

and a generic media_find_property() function that would allow a
driver to seek for an specific set of properties, e. g.:

int find_find_property(struct media_properties *props, struct media_graph *gobj);

This way, if someone would need to seek for an specific set of
properties (like on your DT case), he could use a helper function like
(untested):

find_dt_reg(int _port_reg, int _reg, struct media_graph *gobj)
{
	struct media_properties port_reg, reg;

	port_reg.type =	MEDIA_PROP_DT_PORT_REG;
	port_reg.value = _port_reg;

	reg.type = MEDIA_PROP_DT_REG;
	reg.value = _reg;

	INIT_LIST_HEAD(&port_reg->list);
	list_add_tail(&port->list, &reg);

	find_find_property(&port_reg, gobj);
}


Thanks,
Mauro
