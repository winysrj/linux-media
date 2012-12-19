Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f172.google.com ([209.85.216.172]:42541 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303Ab2LSUNe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Dec 2012 15:13:34 -0500
MIME-Version: 1.0
In-Reply-To: <CAF6AEGsLdLasS4=j1PsX_P8miG8NcTXMUP9VYj+4gdU8Qhm2YQ@mail.gmail.com>
References: <1353620736-6517-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <CAPM=9txFJzJ0haTyBnr8hEmmqNb+gSAyBno+Zs0Z-qvVMTwz9A@mail.gmail.com> <CAF6AEGsLdLasS4=j1PsX_P8miG8NcTXMUP9VYj+4gdU8Qhm2YQ@mail.gmail.com>
From: =?ISO-8859-1?Q?St=E9phane_Marchesin?=
	<stephane.marchesin@gmail.com>
Date: Wed, 19 Dec 2012 12:05:04 -0800
Message-ID: <CACP_E+JSjwsaUnbuB7wazKZkQKt-pOU_aNKhPNyfW6j610WyjA@mail.gmail.com>
Subject: Re: [RFC v2 0/5] Common Display Framework
To: Rob Clark <rob.clark@linaro.org>
Cc: Dave Airlie <airlied@gmail.com>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	Tom Gall <tom.gall@linaro.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	Ragesh Radhakrishnan <ragesh.r@linaro.org>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Bryan Wu <bryan.wu@canonical.com>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Vikas Sajjan <vikas.sajjan@linaro.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Sebastien Guiriec <s-guiriec@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Dec 17, 2012 at 10:21 PM, Rob Clark <rob.clark@linaro.org> wrote:
> On Mon, Dec 17, 2012 at 11:04 PM, Dave Airlie <airlied@gmail.com> wrote:
>>>
>>> Many developers showed interest in the first RFC, and I've had the opportunity
>>> to discuss it with most of them. I would like to thank (in no particular
>>> order) Tomi Valkeinen for all the time he spend helping me to draft v2, Marcus
>>> Lorentzon for his useful input during Linaro Connect Q4 2012, and Linaro for
>>> inviting me to Connect and providing a venue to discuss this topic.
>>>
>>
>> So this might be a bit off topic but this whole CDF triggered me
>> looking at stuff I generally avoid:
>>
>> The biggest problem I'm having currently with the whole ARM graphics
>> and output world is the proliferation of platform drivers for every
>> little thing. The whole ordering of operations with respect to things
>> like suspend/resume or dynamic power management is going to be a real
>> nightmare if there are dependencies between the drivers. How do you
>> enforce ordering of s/r operations between all the various components?
>
> I tend to think that sub-devices are useful just to have a way to
> probe hw which may or may not be there, since on ARM we often don't
> have any alternative..

You can probe the device tree from a normal DRM driver. For example in
nouveau for PPC we probe the OF device tree looking for connectors. I
don't see how sub-devices or extra platform drivers help with that, as
long as the device tree is populated upfront somehow...

Stéphane

> but beyond that, suspend/resume, and other
> life-cycle aspects, they should really be treated as all one device.
> Especially to avoid undefined suspend/resume ordering.
>
> CDF or some sort of mechanism to share panel drivers between drivers
> is useful.  Keeping it within drm, is probably a good idea, if nothing
> else to simplify re-use of helper fxns (like avi-infoframe stuff, for
> example) and avoid dealing with merging changes across multiple trees.
>   Treating them more like shared libraries and less like sub-devices
> which can be dynamically loaded/unloaded (ie. they should be not built
> as separate modules or suspend/resumed or probed/removed independently
> of the master driver) is a really good idea to avoid uncovering nasty
> synchronization issues later (remove vs modeset or pageflip) or
> surprising userspace in bad ways.
>
>> The other thing I'd like you guys to do is kill the idea of fbdev and
>> v4l drivers that are "shared" with the drm codebase, really just
>> implement fbdev and v4l on top of the drm layer, some people might
>> think this is some sort of maintainer thing, but really nothing else
>> makes sense, and having these shared display frameworks just to avoid
>> having using drm/kms drivers seems totally pointless. Fix the drm
>> fbdev emulation if an fbdev interface is needed. But creating a fourth
>> framework because our previous 3 frameworks didn't work out doesn't
>> seem like a situation I want to get behind too much.
>
> yeah, let's not have multiple frameworks to do the same thing.. For
> fbdev, it is pretty clear that it is a dead end.  For v4l2
> (subdev+mcf), it is perhaps bit more flexible when it comes to random
> arbitrary hw pipelines than kms.  But to take advantage of that, your
> userspace isn't going to be portable anyways, so you might as well use
> driver specific properties/ioctls.  But I tend to think that is more
> useful for cameras.  And from userspace perspective, kms planes are
> less painful to use for output than v4l2, so lets stick to drm/kms for
> output (and not try to add camera/capture support to kms).. k, thx
>
> BR,
> -R
>
>> Dave.
>> _______________________________________________
>> dri-devel mailing list
>> dri-devel@lists.freedesktop.org
>> http://lists.freedesktop.org/mailman/listinfo/dri-devel
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
