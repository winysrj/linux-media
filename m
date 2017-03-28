Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:38425
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932072AbdC1Lik (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Mar 2017 07:38:40 -0400
Date: Tue, 28 Mar 2017 08:38:26 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Helen Koike <helen.koike@collabora.co.uk>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Helen Koike <helen.koike@collabora.com>,
        linux-media@vger.kernel.org, jgebben@codeaurora.org,
        Helen Fornazier <helen.fornazier@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH v7] [media] vimc: Virtual Media Controller core, capture
 and sensor
Message-ID: <20170328083826.6cf003ff@vento.lan>
In-Reply-To: <f668b12f-0da8-98da-63b0-c5064cc87da9@xs4all.nl>
References: <6c85eaf4-1f91-7964-1cf9-602005b62a94@collabora.co.uk>
        <1490461896-19221-1-git-send-email-helen.koike@collabora.com>
        <f8466f7a-0f33-a610-10fc-2515d5f6b499@iki.fi>
        <ef7c1d62-0553-2c5b-004f-527d82e380b3@collabora.co.uk>
        <20170327150918.6843e285@vento.lan>
        <f668b12f-0da8-98da-63b0-c5064cc87da9@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 28 Mar 2017 12:00:36 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 27/03/17 20:09, Mauro Carvalho Chehab wrote:
> > Em Mon, 27 Mar 2017 12:19:51 -0300
> > Helen Koike <helen.koike@collabora.co.uk> escreveu:
> >   
> >> Hi Sakari,
> >>
> >> On 2017-03-26 10:31 AM, Sakari Ailus wrote:  
> >>> Hi Helen,
> >>>
> >>> ...    
> >>>> +static int vimc_cap_enum_input(struct file *file, void *priv,
> >>>> +			       struct v4l2_input *i)
> >>>> +{
> >>>> +	/* We only have one input */
> >>>> +	if (i->index > 0)
> >>>> +		return -EINVAL;
> >>>> +
> >>>> +	i->type = V4L2_INPUT_TYPE_CAMERA;
> >>>> +	strlcpy(i->name, "VIMC capture", sizeof(i->name));
> >>>> +
> >>>> +	return 0;
> >>>> +}
> >>>> +
> >>>> +static int vimc_cap_g_input(struct file *file, void *priv, unsigned int *i)
> >>>> +{
> >>>> +	/* We only have one input */
> >>>> +	*i = 0;
> >>>> +	return 0;
> >>>> +}
> >>>> +
> >>>> +static int vimc_cap_s_input(struct file *file, void *priv, unsigned int i)
> >>>> +{
> >>>> +	/* We only have one input */
> >>>> +	return i ? -EINVAL : 0;
> >>>> +}    
> >>>
> >>> You can drop the input IOCTLs altogether here. If you had e.g. a TV
> >>> tuner, it'd be the TV tuner driver's responsibility to implement them.
> >>>    
> >>
> >> input IOCTLs seems to be mandatory from v4l2-compliance when capability 
> >> V4L2_CAP_VIDEO_CAPTURE is set (which is the case):
> >>
> >> https://git.linuxtv.org/v4l-utils.git/tree/utils/v4l2-compliance/v4l2-test-input-output.cpp#n418
> >>
> >> https://git.linuxtv.org/v4l-utils.git/tree/utils/v4l2-compliance/v4l2-compliance.cpp#n989  
> > 
> > The V4L2 spec doesn't actually define what's mandatory and what's
> > optional. The idea that was agreed on one of the media summits
> > were to define a set of profiles for different device types,
> > matching the features required by existing applications to work,
> > but this was never materialized.
> > 
> > So, my understanding is that any driver can implement
> > any V4L2 ioctl.
> > 
> > Yet, some applications require enum/get/set inputs, or otherwise
> > they wouldn't work. It is too late to change this behavior. 
> > So, either the driver or the core should implement those
> > ioctls, in order to avoid breaking backward-compatibility.  
> 
> The closest we have to determining which ioctls are mandatory or not is
> v4l2-compliance.

Yes, but we should explicitly document what's mandatory at the V4L2
API spec and mention the v4l2-compliance tool there.

> That said, v4l2-compliance is actually a bit more strict
> in some cases than the spec since some ioctls are optional in the spec, but
> required in v4l2-compliance for the simple reason that there is no reason
> for drivers NOT to implement those ioctls.
> 
> However, the v4l2-compliance test was never written for MC devices. It turns
> out that it works reasonably well as long as a working pipeline is configured
> first, but these input ioctls are a bit iffy.

The way I see, v4l2-compliance V4L2 API check[1] should not be modified to
explicitly support devices with MC and/or subdev API.

Provided that a valid pipeline is set (either via MC or via some pipeline
loaded by DT, as Russell proposed), v4l2-compliance should be checking
if what the device driver provides is enough for a generic V4L2 application
to work with such pipeline.

As v4l2-compliance also supports libv4l, if are there any plugin
for that device, it should use such plugin automatically.

So, from my side, if the driver doesn't pass at v4l2-compliance, it is
not ready for upstream.

[1] Still, it would make sense to add support at v4l2-compliance
(or to have some other tool) that would check if the MC and subdev 
APIs are properly implemented - but this is another matter.

> There are really two options: don't implement them, or implement it as a single
> input. Multiple inputs make no sense for MC devices: the video node is the
> endpoint of a video pipeline, you never switch 'inputs' there.
> 
> The way the input ioctls are implemented here would fit nicely for an MC
> device IMHO.
> 
> So should we define these ioctls or not?

We should. All ioctls that generic application require should be there
on all drivers, as nobody will modify those applications to work with
"capped" drivers. Even if someone would be willing to do that, it would
take years for those apps to be reflected at the distros.

What we could do is to provide a default handler for "trivial" handling
of ioctls like G_INPUT/S_INPUT at the V4L2 core. This way, drivers that
don't have multiple inputs (like most webcam drivers) won't need to
explicitly implement it.

> I am inclined to define them for the following reasons:
> 
> - Some applications expect them, so adding them to the driver costs little but
>   allows these applications to work, provided the correct pipeline is configured
>   first.
> 
> - If a plugin is needed, then that plugin can always override these ioctls and
>   for different 'inputs' reconfigure the pipeline.
> 
> I really don't see implementing this as a problem. Reporting that an MC video node
> has a "VIMC capture" input seems perfectly reasonable to me.

Agreed.

Thanks,
Mauro
