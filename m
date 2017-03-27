Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:35394
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751564AbdC0SKO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Mar 2017 14:10:14 -0400
Date: Mon, 27 Mar 2017 15:09:18 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Helen Koike <helen.koike@collabora.co.uk>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        Helen Koike <helen.koike@collabora.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        jgebben@codeaurora.org,
        Helen Fornazier <helen.fornazier@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH v7] [media] vimc: Virtual Media Controller core, capture
 and sensor
Message-ID: <20170327150918.6843e285@vento.lan>
In-Reply-To: <ef7c1d62-0553-2c5b-004f-527d82e380b3@collabora.co.uk>
References: <6c85eaf4-1f91-7964-1cf9-602005b62a94@collabora.co.uk>
        <1490461896-19221-1-git-send-email-helen.koike@collabora.com>
        <f8466f7a-0f33-a610-10fc-2515d5f6b499@iki.fi>
        <ef7c1d62-0553-2c5b-004f-527d82e380b3@collabora.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 27 Mar 2017 12:19:51 -0300
Helen Koike <helen.koike@collabora.co.uk> escreveu:

> Hi Sakari,
> 
> On 2017-03-26 10:31 AM, Sakari Ailus wrote:
> > Hi Helen,
> >
> > ...  
> >> +static int vimc_cap_enum_input(struct file *file, void *priv,
> >> +			       struct v4l2_input *i)
> >> +{
> >> +	/* We only have one input */
> >> +	if (i->index > 0)
> >> +		return -EINVAL;
> >> +
> >> +	i->type = V4L2_INPUT_TYPE_CAMERA;
> >> +	strlcpy(i->name, "VIMC capture", sizeof(i->name));
> >> +
> >> +	return 0;
> >> +}
> >> +
> >> +static int vimc_cap_g_input(struct file *file, void *priv, unsigned int *i)
> >> +{
> >> +	/* We only have one input */
> >> +	*i = 0;
> >> +	return 0;
> >> +}
> >> +
> >> +static int vimc_cap_s_input(struct file *file, void *priv, unsigned int i)
> >> +{
> >> +	/* We only have one input */
> >> +	return i ? -EINVAL : 0;
> >> +}  
> >
> > You can drop the input IOCTLs altogether here. If you had e.g. a TV
> > tuner, it'd be the TV tuner driver's responsibility to implement them.
> >  
> 
> input IOCTLs seems to be mandatory from v4l2-compliance when capability 
> V4L2_CAP_VIDEO_CAPTURE is set (which is the case):
> 
> https://git.linuxtv.org/v4l-utils.git/tree/utils/v4l2-compliance/v4l2-test-input-output.cpp#n418
> 
> https://git.linuxtv.org/v4l-utils.git/tree/utils/v4l2-compliance/v4l2-compliance.cpp#n989

The V4L2 spec doesn't actually define what's mandatory and what's
optional. The idea that was agreed on one of the media summits
were to define a set of profiles for different device types,
matching the features required by existing applications to work,
but this was never materialized.

So, my understanding is that any driver can implement
any V4L2 ioctl.

Yet, some applications require enum/get/set inputs, or otherwise
they wouldn't work. It is too late to change this behavior. 
So, either the driver or the core should implement those
ioctls, in order to avoid breaking backward-compatibility.

Regards,

Thanks,
Mauro
