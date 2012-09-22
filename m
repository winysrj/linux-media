Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:33393 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494Ab2IVSyn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Sep 2012 14:54:43 -0400
Received: by bkcjk13 with SMTP id jk13so252808bkc.19
        for <linux-media@vger.kernel.org>; Sat, 22 Sep 2012 11:54:42 -0700 (PDT)
Message-ID: <505E0970.9030405@gmail.com>
Date: Sat, 22 Sep 2012 20:54:40 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: RFC: single+multiplanar API in one driver: possible or not?
References: <201209211307.45495.hverkuil@xs4all.nl>
In-Reply-To: <201209211307.45495.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans,

On 09/21/2012 01:07 PM, Hans Verkuil wrote:
> Hi all,
> 
> I've been looking into multiplanar support recently, and I ran into some API
> ambiguities.
> 
> In the examples below I stick to the capture case, but the same applies to
> output and m2m.
> 
> There are two capabilities: V4L2_CAP_VIDEO_CAPTURE and V4L2_CAP_VIDEO_CAPTURE_MPLANE.
> These caps tell the application whether the single and/or multiplanar API is
> implemented by the driver.
> 
> If the hardware only supports single planar formats, then only V4L2_CAP_VIDEO_CAPTURE
> is present. If the hardware only supports multiplanar formats, then only
> V4L2_CAP_VIDEO_CAPTURE_MPLANE is present. The problems occurs when the hardware
> supports both single and multiplanar formats.
> 
> The first question is if we want to allow drivers to implement both. The
> advantages of that are:
> 
> - easy to implement: if the hardware supports one or more multiplanar formats,
>    then the driver must implement only the multiplanar API. Applications will
>    only see V4L2_CAP_VIDEO_CAPTURE or V4L2_CAP_VIDEO_CAPTURE_MPLANE and never
>    both.
> - no confusion: what should be done if a multiplanar format is set up
>    and an application asks for the current single planar format? Return a
>    fake format? Some error? This is currently undefined.
> 
> The disadvantages are:
> 
> - it won't work with most/all existing applications since they only understand
>    single planar at the moment. However, all multiplanar drivers are for Samsung
>    embedded SoCs, so is this a real problem?

Probably not a big deal. To support standard applications the conversions can 
be done in libv4l2. But I must admit that the original idea was to have the
conversion done in kernel and this problem would not exist. Sounds like we need
to get the related libv4l2 work done to solve this issue.

> If we would want to allow mixing the two, then we need to solve two problems:
> 
> - Determine the behavior when calling G_FMT for a single planar buffer type
>    when the current format is a multiplanar format.
> - We probably want to make a bunch of helper functions that do the job of
>    handling the single planar case without requiring the driver to actually
>    implement both.
> 
> The first is actually a major problem. Returning an error here is completely
> unexpected behavior. The only reasonable solution I see is to remember the last
> single planar format and return that. But then G_FMT for a single or a multiplanar
> format will return different things.
> 
> The second problem is also difficult, in particular when dealing with the
> streaming I/O ioctls. It's doable, but a fair amount of work.

This has been done in the past, the single/multi-plane conversion code is 
included in that patch for instance:
http://www.mail-archive.com/linux-media@vger.kernel.org/msg25994.html
But it was decided to do the conversion only in libv4l2.

> A conversion from multiplanar to singleplanar might be something that can be
> done in libv4l2. But that too is a substantial amount of work.

Some works on that were started already
http://www.mail-archive.com/linux-media@vger.kernel.org/msg34078.html

> I am inclined to disallow mixing of single and multiplanar APIs in a driver.
> Let's keep things simple.

Mixing those APIs in single driver doesn't make much sense. Multi-planar was
supposed to be a superset of single-planar. I'm just not sure about all these
in tree drivers that were added before multi-planar API existed and which 
could take an advantage of it as well.

--

Regards,
Sylwester

