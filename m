Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:39400 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754152AbdC1Uhz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Mar 2017 16:37:55 -0400
Date: Tue, 28 Mar 2017 23:37:11 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Helen Koike <helen.koike@collabora.co.uk>,
        Helen Koike <helen.koike@collabora.com>,
        linux-media@vger.kernel.org, jgebben@codeaurora.org,
        Helen Fornazier <helen.fornazier@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH v7] [media] vimc: Virtual Media Controller core, capture
 and sensor
Message-ID: <20170328203711.GE16657@valkosipuli.retiisi.org.uk>
References: <6c85eaf4-1f91-7964-1cf9-602005b62a94@collabora.co.uk>
 <1490461896-19221-1-git-send-email-helen.koike@collabora.com>
 <f8466f7a-0f33-a610-10fc-2515d5f6b499@iki.fi>
 <ef7c1d62-0553-2c5b-004f-527d82e380b3@collabora.co.uk>
 <20170327150918.6843e285@vento.lan>
 <f668b12f-0da8-98da-63b0-c5064cc87da9@xs4all.nl>
 <20170328083826.6cf003ff@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170328083826.6cf003ff@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Tue, Mar 28, 2017 at 08:38:26AM -0300, Mauro Carvalho Chehab wrote:
> Em Tue, 28 Mar 2017 12:00:36 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
> > On 27/03/17 20:09, Mauro Carvalho Chehab wrote:
> > > Em Mon, 27 Mar 2017 12:19:51 -0300
> > > Helen Koike <helen.koike@collabora.co.uk> escreveu:
> > >   
> > >> Hi Sakari,
> > >>
> > >> On 2017-03-26 10:31 AM, Sakari Ailus wrote:  
> > >>> Hi Helen,
> > >>>
> > >>> ...    
> > >>>> +static int vimc_cap_enum_input(struct file *file, void *priv,
> > >>>> +			       struct v4l2_input *i)
> > >>>> +{
> > >>>> +	/* We only have one input */
> > >>>> +	if (i->index > 0)
> > >>>> +		return -EINVAL;
> > >>>> +
> > >>>> +	i->type = V4L2_INPUT_TYPE_CAMERA;
> > >>>> +	strlcpy(i->name, "VIMC capture", sizeof(i->name));
> > >>>> +
> > >>>> +	return 0;
> > >>>> +}
> > >>>> +
> > >>>> +static int vimc_cap_g_input(struct file *file, void *priv, unsigned int *i)
> > >>>> +{
> > >>>> +	/* We only have one input */
> > >>>> +	*i = 0;
> > >>>> +	return 0;
> > >>>> +}
> > >>>> +
> > >>>> +static int vimc_cap_s_input(struct file *file, void *priv, unsigned int i)
> > >>>> +{
> > >>>> +	/* We only have one input */
> > >>>> +	return i ? -EINVAL : 0;
> > >>>> +}    
> > >>>
> > >>> You can drop the input IOCTLs altogether here. If you had e.g. a TV
> > >>> tuner, it'd be the TV tuner driver's responsibility to implement them.
> > >>>    
> > >>
> > >> input IOCTLs seems to be mandatory from v4l2-compliance when capability 
> > >> V4L2_CAP_VIDEO_CAPTURE is set (which is the case):
> > >>
> > >> https://git.linuxtv.org/v4l-utils.git/tree/utils/v4l2-compliance/v4l2-test-input-output.cpp#n418
> > >>
> > >> https://git.linuxtv.org/v4l-utils.git/tree/utils/v4l2-compliance/v4l2-compliance.cpp#n989  
> > > 
> > > The V4L2 spec doesn't actually define what's mandatory and what's
> > > optional. The idea that was agreed on one of the media summits
> > > were to define a set of profiles for different device types,
> > > matching the features required by existing applications to work,
> > > but this was never materialized.
> > > 
> > > So, my understanding is that any driver can implement
> > > any V4L2 ioctl.
> > > 
> > > Yet, some applications require enum/get/set inputs, or otherwise
> > > they wouldn't work. It is too late to change this behavior. 
> > > So, either the driver or the core should implement those
> > > ioctls, in order to avoid breaking backward-compatibility.  
> > 
> > The closest we have to determining which ioctls are mandatory or not is
> > v4l2-compliance.
> 
> Yes, but we should explicitly document what's mandatory at the V4L2
> API spec and mention the v4l2-compliance tool there.
> 
> > That said, v4l2-compliance is actually a bit more strict
> > in some cases than the spec since some ioctls are optional in the spec, but
> > required in v4l2-compliance for the simple reason that there is no reason
> > for drivers NOT to implement those ioctls.
> > 
> > However, the v4l2-compliance test was never written for MC devices. It turns
> > out that it works reasonably well as long as a working pipeline is configured
> > first, but these input ioctls are a bit iffy.
> 
> The way I see, v4l2-compliance V4L2 API check[1] should not be modified to
> explicitly support devices with MC and/or subdev API.

The V4L2 API documentation states that

	Video inputs and outputs are physical connectors of a device. ...
	Drivers must implement all the input ioctls when the device has one
	or more inputs, all the output ioctls when the device has one or
	more outputs.

"Inputs" and "outputs", as the spec defines them, mean physical connectors
to the device.

Does e.g. a camera have a physical connector? I don't think one could
imagine it does, meaning also there is no need to implement these IOCTLs.

That said, I looked at a few drivers and even the omap3isp driver implements
the input IOCTLs. It provides no useful information whatsoever through them,
just like most drivers whose hardware has no physical connectors.

Still the bottom line is that the spec does not require them.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
