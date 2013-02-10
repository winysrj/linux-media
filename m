Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f170.google.com ([209.85.215.170]:60614 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761126Ab3BJToI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Feb 2013 14:44:08 -0500
Received: by mail-ea0-f170.google.com with SMTP id a11so2351856eaa.15
        for <linux-media@vger.kernel.org>; Sun, 10 Feb 2013 11:44:04 -0800 (PST)
Message-ID: <5117F880.6010609@gmail.com>
Date: Sun, 10 Feb 2013 20:44:00 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Andrzej Hajda <a.hajda@samsung.com>,
	linux-media@vger.kernel.org
Subject: Re: RFC: add parameters to V4L controls
References: <50EAA78E.4090904@samsung.com> <201301071310.54428.hverkuil@xs4all.nl> <510AA736.5060803@samsung.com> <1409971.Bs77k1Sp6U@avalon> <510EB23E.6070100@gmail.com> <20130206202632.GA22278@valkosipuli.retiisi.org.uk>
In-Reply-To: <20130206202632.GA22278@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the feedback!

On 02/06/2013 09:26 PM, Sakari Ailus wrote:
> Selections are essentially controls but for rectangles.

The selection API was originally designed as a replacement for the cropping,
"insertion" and scaling API (VIDIOC_*_CROP* ioctls), in order to improve
it. So now we have Image Cropping, Composing and Scaling API on /dev/video*
interfaces and for the subdevs the selections definition appears more 
generic,
with current supported feature set exactly same as for /dev/video*.

The selection API wasn't meant as a generic interface to configure whatever
rectangles at the beginning. After use cases popped up, we've said - maybe
we can reuse it for camera auto focus or exposure metering ROI selection,
etc.

Hence I disagree the selection API _is_ as generic as the controls API.
We might wish it to be, but it currently is not. It now consistently
covers image cropping, composing and scaling.

I'm not sure it is a good idea to try to design "primitive sub-APIs" and
then have something useful by combining a few of them. IMHO it is going
to be painful for the user and the kernel space.

> The original use case was to support configuring scaling, cropping etc. on
> subdevs but they're not really bound to image processing configuration.

We had first support for the selection API on video nodes and only after
that on subdevs, where the meaning of the selection API was made a bit more
generic.

> Controls have been more generic to begin with.

Agreed.

>> I have quickly added support for rectangle controls type [1] to see how
>> big changes it would require and what would be missing without significant
>> changes in the controls API.
>>
>> So the main issues there are: the min/max/step/default value cannot
>> be queried (VIDIOC_QUERYCTRL) and it is troublesome to handle them in
>> the kernel, the control value change events wouldn't really work.
>>
>> I learnt VIDIOC_QUERYCTRL is not supported for V4L2_CTRL_TYPE_INTEGER64
>> control type, then maybe we could have similarly some features not
>> available for V4L2_CTRL_TYPE_RECTANGLE ? Until there are further
>> extensions that address this;)
>>
>> [1] http://git.linuxtv.org/snawrocki/media.git/ov965x-2-rect-type-ctrl
>
> Hmm. Had you proposed this two years ago, selections could well look
> entirely different.
>
> We still have them now. There would be use cases for pad specific controls,
> too; pixel rate for instance should be one. For this reason I don't see
> selections really much different from controls.
>
> The selections are the same on subdevs and video nodes. Unifying them (with
> some compat code for either of the current interfaces) and providing a new
> IOCTL to access both was what I thought could be one solution to the
> problem.

Subdevs are not supposed to be accessed by generic applications, are they ?
Then what would we need a compat ioctl for ?

Should /dev/video drivers just pass-through selection ioctls with selection
targets they don't support to their respective subdevs ?

> Or --- we could add "selection controls" which would be just like selections
> but with the control interface. What's relevant in struct v4l2_ext_control
> would be the ID field, while the "value" field in struct v4l2_ext_control
> would be a pointer to a struct describing the selection control. Half of the
> reserved field could be used for the pad (they're 16-bit ints). No control
> ID clashes with the selection IDs, so this could even work with the existing
> selection targets.
>
> Either solution would avoid creating another rectangle type with an ID that
> would be separate from selections.
>
> Thoughts, comments?

I would rather have clear separation of what the VIDIOC_*_SELECTION are
intended for and what can be done with the controls API. Let's not emulate
the existing selection API through the controls API.

--

Regards,
Sylwester
