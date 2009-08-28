Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.26]:50294 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571AbZH1Koa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Aug 2009 06:44:30 -0400
Received: by qw-out-2122.google.com with SMTP id 8so461335qwh.37
        for <linux-media@vger.kernel.org>; Fri, 28 Aug 2009 03:44:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A977BB6.5040101@redhat.com>
References: <4A977BB6.5040101@redhat.com>
From: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
Date: Fri, 28 Aug 2009 19:44:12 +0900
Message-ID: <5e9665e10908280344x2f030658j7cd9f09bbf5f6ccd@mail.gmail.com>
Subject: Re: RFC: video device (stream) sharing
To: Hans de Goede <hdegoede@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Brandon Philips <brandon@ifup.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Aug 28, 2009 at 3:39 PM, Hans de Goede<hdegoede@redhat.com> wrote:
> Hi All,
>
> This has been discussed before and this is something Brandon and I would
> like
> to discuss further at plumbers, so here is a first braindump, note that this
> braindump is purely mine and not Brandon's in any way.
>
> The basic idea is to have some sort of userspace proxy process which allows
> sharing for example a webcam between 2 devices. For me there are 2 major
> criteria which need to be matched to be able to do this:
>
> 1) No (as in 0) functionality regressions for the single use case, iow when
>   only one app opens the device everything should work as before
>
> 2) No significant performance regressions for the single use case. Sure this
>   may be a bit slower, but not much!
>
> 2) Will require some trickery with shared memory, etc. But the real hard
> problem
> here is 1), so I will purely focus on 1) now.
>
>
> My initial idea to solve 1) is that as soon as an application does anything
> remotely stream (capture) related even something such as enum_fmt, it
> becomes the
> stream owner. The stream owner is allowed to do everything. Any second
> application
> which also wants to capture will only be shown the resolution and format
> currently
> selected by the stream owner.
>
> And here we immediately hit a problem. Imagine the following:
> 1) The user starts cheese at 640x480
> 2) The user starts application foo, which only sees 640x480 to and thus
>   starts capturing at 640x480
> 3) The user changes the resolution in cheese to 320x240
>
> Now we've got a problem, because cheese is allowed to do this, but we need
> 640x480
> for application foo -> fail. And I'm not even talking about possible races
> when
> cheese has become the stream owner, but has not yet choosen its format to
> stream in,
> etc.
>
>
> So the whole stream owner concept does not work. Instead, what would
> probably work, is
> the following:
> -limit the amount of reported supported formats (enum fmt) to formats which
> we can create
>  by conversion from native formats
> -report the full list of supported resolutions to all applications
> -capture at the highest resolution requested by any of the applications
> -downsample for applications which want a lower resolution
>

Using the highest resolution as a representative resolution might be a
great obstacle in case of using a high resolution camera like 8mega
pixel or over. the highest resolution of 8 mega pixel camera is
literally 8mega pixel which is 4096x1664 in common. And also should be
a great burden for users to downsample the image of  8mega pixel.

In embedded devices, I may suggest in this way.
Considering whether there is any resizer like codec device or not,
there might be a couple of cases like:
(Please note that I'm not aware of the way of how to handle codec
device properly in v4l2 sense. therefor just describing in abstract
way)

1) With codec device
If there is any kind of codec device embedded in the SoC platform
which can be used in global, the codec device might being assigned a
camera device as an input. And making codec device available for
multiple open, user could be using the same camera as an image source
and use different destination image resolution for each instance. And
this case, the codec device driver should arrange each instance for
different resolutions.

2) Without codec device
This case might be more neat and simpler.
The process which opens the camera device first should be the "stream
owner" but if there is any other process opening the device *again*,
any of those process should have EBUSY for return of s_fmt, s_parm and
any kind of setting ioctls. Then the device which is opened by
multiple processes, will stay in the exact setting of resolution, fps
state until it gets closed.

I know that there is no rules for codec device, but in my opinion if
the framework wants to provide a feature of single image source and
multiple destination format(resolution), codec device must be
involved.
Cheers,

Nate

>
> So this is how I suggest to handle this.
>
> Regards,
>
> Hans
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
=
DongSoo, Nathaniel Kim
Engineer
Mobile S/W Platform Lab.
Digital Media & Communications R&D Centre
Samsung Electronics CO., LTD.
e-mail : dongsoo.kim@gmail.com
          dongsoo45.kim@samsung.com
