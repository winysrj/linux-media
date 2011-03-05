Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39490 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664Ab1CENEX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 Mar 2011 08:04:23 -0500
Received: by wyg36 with SMTP id 36so2970858wyg.19
        for <linux-media@vger.kernel.org>; Sat, 05 Mar 2011 05:04:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201103051252.12342.hverkuil@xs4all.nl>
References: <201102171606.58540.laurent.pinchart@ideasonboard.com>
	<201103031125.06419.laurent.pinchart@ideasonboard.com>
	<4D71471D.6060808@redhat.com>
	<201103051252.12342.hverkuil@xs4all.nl>
Date: Sat, 5 Mar 2011 15:04:21 +0200
Message-ID: <AANLkTi=SS3CBkKUdovU33SQi=s9gNprZszKaMrkRGqGy@mail.gmail.com>
Subject: Re: [GIT PULL FOR 2.6.39] Media controller and OMAP3 ISP driver
From: David Cohen <dacohen@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	alsa-devel@alsa-project.org,
	Sakari Ailus <sakari.ailus@retiisi.org.uk>,
	Pawel Osciak <pawel@osciak.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hans,

On Sat, Mar 5, 2011 at 1:52 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On Friday, March 04, 2011 21:10:05 Mauro Carvalho Chehab wrote:
>> Em 03-03-2011 07:25, Laurent Pinchart escreveu:
>> > Hi Mauro,
>> >
>> > The following changes since commit 88a763df226facb74fdb254563e30e9efb64275c:
>> >
>> >   [media] dw2102: prof 1100 corrected (2011-03-02 16:56:54 -0300)
>> >
>> > are available in the git repository at:
>> >   git://linuxtv.org/pinchartl/media.git media-2.6.39-0005-omap3isp
>> >
>> > The branch has been rebased on top of the latest for_v2.6.39 branch, with the
>> > v4l2-ioctl.c conflict resolved.
>> >
>> > Antti Koskipaa (1):
>> >       v4l: v4l2_subdev userspace crop API
>> >
>> > David Cohen (1):
>> >       omap3isp: Statistics
>> >
>> > Laurent Pinchart (36):
>> >       v4l: Share code between video_usercopy and video_ioctl2
>> >       v4l: subdev: Don't require core operations
>> >       v4l: subdev: Add device node support
>> >       v4l: subdev: Uninline the v4l2_subdev_init function
>> >       v4l: subdev: Control ioctls support
>> >       media: Media device node support
>> >       media: Media device
>> >       media: Entities, pads and links
>> >       media: Entity use count
>> >       media: Media device information query
>> >       media: Entities, pads and links enumeration
>> >       media: Links setup
>> >       media: Pipelines and media streams
>> >       v4l: Add a media_device pointer to the v4l2_device structure
>> >       v4l: Make video_device inherit from media_entity
>> >       v4l: Make v4l2_subdev inherit from media_entity
>> >       v4l: Move the media/v4l2-mediabus.h header to include/linux
>> >       v4l: Replace enums with fixed-sized fields in public structure
>> >       v4l: Rename V4L2_MBUS_FMT_GREY8_1X8 to V4L2_MBUS_FMT_Y8_1X8
>> >       v4l: Group media bus pixel codes by types and sort them alphabetically
>>
>> The presence of those mediabus names against the traditional fourcc codes
>> at the API adds some mess to the media controller. Not sure how to solve,
>> but maybe the best way is to add a table at the V4L2 API associating each
>> media bus format to the corresponding V4L2 fourcc codes.
>
> You can't do that in general. Only for specific hardware platforms. If you
> could do it, then we would have never bothered creating these mediabus fourccs.
>
> How a mediabus fourcc translates to a pixelcode (== memory format) depends
> entirely on the hardware capabilities (mostly that of the DMA engine).

May I ask you one question here? (not entirely related to this patch set).
Why pixelcode != mediabus fourcc?
e.g. OMAP2 camera driver talks to sensor through subdev interface and
sets its own output pixelformat depending on sensor's mediabus fourcc.
So it needs a translation table mbus_pixelcode -> pixelformat. Why
can't it be pixelformat -> pixelformat ?

Regards,

David

>
> A generic V4L2 application will never use mediabus fourcc codes. It's only used
> by drivers and applications written specifically for that hardware and using
> /dev/v4l-subdevX devices.
>
> Regards,
>
>        Hans
>
> --
> Hans Verkuil - video4linux developer - sponsored by Cisco
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
