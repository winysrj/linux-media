Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:51756 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753306AbdC2Iq7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Mar 2017 04:46:59 -0400
Date: Wed, 29 Mar 2017 11:46:48 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Helen Koike <helen.koike@collabora.co.uk>,
        Helen Koike <helen.koike@collabora.com>,
        linux-media@vger.kernel.org, jgebben@codeaurora.org,
        Helen Fornazier <helen.fornazier@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH v7] [media] vimc: Virtual Media Controller core, capture
 and sensor
Message-ID: <20170329084647.GG16657@valkosipuli.retiisi.org.uk>
References: <6c85eaf4-1f91-7964-1cf9-602005b62a94@collabora.co.uk>
 <1490461896-19221-1-git-send-email-helen.koike@collabora.com>
 <f8466f7a-0f33-a610-10fc-2515d5f6b499@iki.fi>
 <ef7c1d62-0553-2c5b-004f-527d82e380b3@collabora.co.uk>
 <20170327150918.6843e285@vento.lan>
 <f668b12f-0da8-98da-63b0-c5064cc87da9@xs4all.nl>
 <20170328083826.6cf003ff@vento.lan>
 <20170328203711.GE16657@valkosipuli.retiisi.org.uk>
 <7f8469f3-8c7b-0a05-be18-d573940543e0@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7f8469f3-8c7b-0a05-be18-d573940543e0@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Wed, Mar 29, 2017 at 09:49:05AM +0200, Hans Verkuil wrote:
> On 28/03/17 22:37, Sakari Ailus wrote:
> > Hi Mauro,
> > 
> > On Tue, Mar 28, 2017 at 08:38:26AM -0300, Mauro Carvalho Chehab wrote:
> >> Em Tue, 28 Mar 2017 12:00:36 +0200
> >> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> >>
> >>> On 27/03/17 20:09, Mauro Carvalho Chehab wrote:
> >>>> Em Mon, 27 Mar 2017 12:19:51 -0300
> >>>> Helen Koike <helen.koike@collabora.co.uk> escreveu:
> >>>>   
> >>>>> Hi Sakari,
> >>>>>
> >>>>> On 2017-03-26 10:31 AM, Sakari Ailus wrote:  
> >>>>>> Hi Helen,
> >>>>>>
> >>>>>> ...    
> >>>>>>> +static int vimc_cap_enum_input(struct file *file, void *priv,
> >>>>>>> +			       struct v4l2_input *i)
> >>>>>>> +{
> >>>>>>> +	/* We only have one input */
> >>>>>>> +	if (i->index > 0)
> >>>>>>> +		return -EINVAL;
> >>>>>>> +
> >>>>>>> +	i->type = V4L2_INPUT_TYPE_CAMERA;
> >>>>>>> +	strlcpy(i->name, "VIMC capture", sizeof(i->name));
> >>>>>>> +
> >>>>>>> +	return 0;
> >>>>>>> +}
> >>>>>>> +
> >>>>>>> +static int vimc_cap_g_input(struct file *file, void *priv, unsigned int *i)
> >>>>>>> +{
> >>>>>>> +	/* We only have one input */
> >>>>>>> +	*i = 0;
> >>>>>>> +	return 0;
> >>>>>>> +}
> >>>>>>> +
> >>>>>>> +static int vimc_cap_s_input(struct file *file, void *priv, unsigned int i)
> >>>>>>> +{
> >>>>>>> +	/* We only have one input */
> >>>>>>> +	return i ? -EINVAL : 0;
> >>>>>>> +}    
> >>>>>>
> >>>>>> You can drop the input IOCTLs altogether here. If you had e.g. a TV
> >>>>>> tuner, it'd be the TV tuner driver's responsibility to implement them.
> >>>>>>    
> >>>>>
> >>>>> input IOCTLs seems to be mandatory from v4l2-compliance when capability 
> >>>>> V4L2_CAP_VIDEO_CAPTURE is set (which is the case):
> >>>>>
> >>>>> https://git.linuxtv.org/v4l-utils.git/tree/utils/v4l2-compliance/v4l2-test-input-output.cpp#n418
> >>>>>
> >>>>> https://git.linuxtv.org/v4l-utils.git/tree/utils/v4l2-compliance/v4l2-compliance.cpp#n989  
> >>>>
> >>>> The V4L2 spec doesn't actually define what's mandatory and what's
> >>>> optional. The idea that was agreed on one of the media summits
> >>>> were to define a set of profiles for different device types,
> >>>> matching the features required by existing applications to work,
> >>>> but this was never materialized.
> >>>>
> >>>> So, my understanding is that any driver can implement
> >>>> any V4L2 ioctl.
> >>>>
> >>>> Yet, some applications require enum/get/set inputs, or otherwise
> >>>> they wouldn't work. It is too late to change this behavior. 
> >>>> So, either the driver or the core should implement those
> >>>> ioctls, in order to avoid breaking backward-compatibility.  
> >>>
> >>> The closest we have to determining which ioctls are mandatory or not is
> >>> v4l2-compliance.
> >>
> >> Yes, but we should explicitly document what's mandatory at the V4L2
> >> API spec and mention the v4l2-compliance tool there.
> >>
> >>> That said, v4l2-compliance is actually a bit more strict
> >>> in some cases than the spec since some ioctls are optional in the spec, but
> >>> required in v4l2-compliance for the simple reason that there is no reason
> >>> for drivers NOT to implement those ioctls.
> >>>
> >>> However, the v4l2-compliance test was never written for MC devices. It turns
> >>> out that it works reasonably well as long as a working pipeline is configured
> >>> first, but these input ioctls are a bit iffy.
> >>
> >> The way I see, v4l2-compliance V4L2 API check[1] should not be modified to
> >> explicitly support devices with MC and/or subdev API.
> > 
> > The V4L2 API documentation states that
> > 
> > 	Video inputs and outputs are physical connectors of a device. ...
> > 	Drivers must implement all the input ioctls when the device has one
> > 	or more inputs, all the output ioctls when the device has one or
> > 	more outputs.
> > 
> > "Inputs" and "outputs", as the spec defines them, mean physical connectors
> > to the device.
> > 
> > Does e.g. a camera have a physical connector? I don't think one could
> > imagine it does, meaning also there is no need to implement these IOCTLs.
> > 
> > That said, I looked at a few drivers and even the omap3isp driver implements
> > the input IOCTLs. It provides no useful information whatsoever through them,
> > just like most drivers whose hardware has no physical connectors.
> > 
> > Still the bottom line is that the spec does not require them.
> 
> The spec isn't gospel. The reality is that all non-MC drivers have these ioctls
> and a sensor is considered to be an input.
> 
> Section 4.1.2 says: "The video input and video standard ioctls must be supported
> by all video capture devices.". Which actually is also wrong since the video
> standard ioctls do not make sense for DV inputs or sensors.
> 
> I'll make a patch correcting these issues.

I'm far from certain that providing an additional interface that provides no
useful information or a way to control something is beneficial. However, if
you choose to do that, then please follow Mauro's suggestion to add helper
functions for drivers to do this.

I wonder whether calling the input just e.g. "default input" or such would
do the job.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
