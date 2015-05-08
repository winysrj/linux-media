Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:58164 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753013AbbEHOIf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 8 May 2015 10:08:35 -0400
Date: Fri, 8 May 2015 11:08:26 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Matthias Schwarzott <zzam@gentoo.org>,
	Antti Palosaari <crope@iki.fi>,
	Olli Salonen <olli.salonen@iki.fi>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-doc@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: [PATCH 07/18] media controller: rename the tuner entity
Message-ID: <20150508110826.00e4e954@recife.lan>
In-Reply-To: <554CB863.1040006@xs4all.nl>
References: <cover.1431046915.git.mchehab@osg.samsung.com>
	<6d88ece22cbbbaa72bbddb8b152b0d62728d6129.1431046915.git.mchehab@osg.samsung.com>
	<554CA862.8070407@xs4all.nl>
	<20150508095754.1c39a276@recife.lan>
	<554CB863.1040006@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 08 May 2015 15:21:39 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 05/08/2015 02:57 PM, Mauro Carvalho Chehab wrote:
> > Em Fri, 08 May 2015 14:13:22 +0200
> > Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> > 
> >> On 05/08/2015 03:12 AM, Mauro Carvalho Chehab wrote:
> >>> Finally, let's rename the tuner entity. inside the media subsystem,
> >>> a tuner can be used by AM/FM radio, SDR radio, analog TV and digital TV.
> >>> It could even be used on other subsystems, like network, for wireless
> >>> devices.
> >>>
> >>> So, it is not constricted to V4L2 API, or to a subdev.
> >>>
> >>> Let's then rename it as:
> >>> 	MEDIA_ENT_T_V4L2_SUBDEV_TUNER -> MEDIA_ENT_T_TUNER
> >>
> >> See patch 04/18.
> > 
> > Mapping the tuner as a V4L2_SUBDEV is plain wrong. We can't assume
> > that a tuner will always be mapped via V4L2 subdev API.
> 
> True. Today we have subdevs that have no device node to control them, so
> in that case it would just be a SUBDEV entity. There are subdevs that make
> a v4l-subdev device node, so those can be V4L(2)_SUBDEV entities.
> 
> The question is: what are your ideas for e.g. DVB-only tuners? Would they
> get a DVB-like device node? (so DTV_SUBDEV)

I guess we may need DVB subdevs in the future. For now, I don't see
much usage.

> Would hybrid tuners have two
> device nodes? One v4l-subdev, one dvb/dtv-subdev?

No. A tuner is a tuner. The very same device can be used for analog or
digital TV. Ok, there are tuners that only work for digital TV (satellite
tuners, typically), because satellite requires a different tuning range,
and require an extra hardware to power up the satellite antena. So, on
most devices, the tuner is integrated with SEC.

In any case, I don't see any reason why artificially one piece of hardware
component (tuner) into one subdevice entity per API.

What it might make sense in the future is to have some DVB-specific ioctls
for a hybrid tuner,  in order to allow adjusting its internal filters to
an specific digital TV standard.

> Just curious what your thoughts are.
> 
> Brainstorming:
> 
> It might be better to map each device node to an entity and each hardware
> component (tuner, DMA engine) to an entity, and avoid this mixing of
> hw entity vs device node entity.

Ok, but then we need to properly define the namespaces for HW and for
Linux API components.

So, we would have a namespace like:
 
	- ENT_T_DEVNODE_DVB_(FE|CA|NET|DEMUX|DVR) for the DVB API device nodes;
	- ENT_T_DEVNODE_V4L for the radio/swradio/video/vbi devnodes, or,
alternatively, use ENT_T_DEVNODE_V4L_(RADIO|SWRADIO|VIDEO|VBI);
	- ENT_T_HW_(TUNER|CAM_SENSOR|ATV_DEMOD|DTV_DEMOD|...) for the
hardware components.

In other words, the namespace would actually define two subtypes:
	- devnodes;
	- hardware components

There's one advantage on this strategy: it is easier to keep backward
compatibility, IMHO, as we'll be preserving 1 << 16 for device nodes
and 2 << 16 for hardware components.

Yet, we'll need to add an entity for the V4L2 hardware DMA (with makes
sense to me), and this might break backward compatibility if not done
well.

It should be said that, in such case, hardware components will then
mean not only V4L2-specific hardware (V4L2_SUBDEV_foo), but also DVB,
ALSA, ... components.

So, we'll still need a way to identify what of those components are
V4L2 subdevs, probably using the properties API.

If you all agree with that, I'll respin the patch series to map the
entities like that.

Regards,
Mauro


> 
> Hmm, we need a another brainstorm meeting...
> 
> Regards,
> 
> 	Hans
