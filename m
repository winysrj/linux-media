Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f169.google.com ([209.85.223.169]:36598 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096Ab3KKKBC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Nov 2013 05:01:02 -0500
Received: by mail-ie0-f169.google.com with SMTP id tp5so1037902ieb.14
        for <linux-media@vger.kernel.org>; Mon, 11 Nov 2013 02:01:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <2118858.3GAjxvYvyO@avalon>
References: <1377829038-4726-1-git-send-email-posciak@chromium.org>
 <CAPueXH7+tU7L2dU_CoLJ5gx3phKRUuRsXWW=ztDNrAZ2TjaSbg@mail.gmail.com> <2118858.3GAjxvYvyO@avalon>
From: Paulo Assis <pj.assis@gmail.com>
Date: Mon, 11 Nov 2013 10:00:40 +0000
Message-ID: <CAPueXH7qjXtnQj7a4kWqiRVSNQYtRXaUZ1zHXui=DUwV4veYRA@mail.gmail.com>
Subject: Re: [PATCH v1 00/19] UVC 1.5 VP8 support for uvcvideo
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Pawel Osciak <posciak@chromium.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

2013/11/11 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
> Hi Paulo,
>
> On Thursday 10 October 2013 11:27:37 Paulo Assis wrote:
>> Hi,
>> just want t know the current state on this series.
>>
>> I'm currently adding h264 stream preview support to guvcview.
>> It's already working fine on uvc 1.1 cameras like the BCC950
>
> Great ! Is the code already available ?

Yes, the latest git version is working very well, even for the c930,
although for this one, h264, can only be muxed in the MJPG container.
>From what I understand Logitech had to remove direct H264 stream
support (no H264 descriptor) due to some issues with a very well known
OS vendor.

>
>> but for uvc 1.5 devices like the c930e it could really use some driver
>> support.
>
> I'm nearly done reviewing the patches (although 19/19 is a huge beast that
> will take a bit of time to tame :-)). Getting the code to mainline will still
> need some time, but it seems to be going in the right direction. We'll get
> hardware compression support for UVC 1.5 in the driver one way or another, it
> won't be left to userspace to implement (you will of course have to adapt
> existing applications to use the new features, but it should hopefully not be
> too complex).

I've test the patches in it's current form and for the c930, at least,
there is a regression that prevents the camera from functioning (it
doesn't create the video node).
The problem happens with patch 3 : "uvcvideo: Add support for multiple
chains with common roots", in function uvc_scan_device there is the
following check:

if (UVC_ENTITY_TYPE(entity) != UVC_VC_EXTENSION_UNIT
   || entity->bNrInPins != 1
   || uvc_entity_by_reference(dev, entity->id, NULL)) {
        uvc_printk(KERN_INFO, "Found an invalid branch "
                             "starting at entity id %d.\n", entity->id);
        return -1;
 }

for unit 12 (the h264 extension control), 'uvc_entity_by_reference'
check fails and this causes the camera initialization to also fail, so
no video node is created.
My very simple fix was to comment the 'uvc_entity_by_reference' check,
this allows the init process to carry on and the video node is
created. The camera will work fine in that case.

I could propose a more appropriate patch, but since this is still
under review I'm not sure if that's OK or if it's better to wait on
other comments.

Regards,
Paulo



>
>> 2013/8/30 Pawel Osciak <posciak@chromium.org>:
>> > Hello everyone,
>> >
>> > This series adds support for UVC 1.5 and VP8 encoding cameras to the
>> > uvcvideo driver. The official specification for the new standard can be
>> > found here: http://www.usb.org/developers/devclass_docs.
>> >
>> > The main change in 1.5 is support for encoding cameras. Those cameras
>> > contain additional UVC entities, called Encoding Units, with their own
>> > set of controls governing encode parameters. Typical encoding cameras
>> > (see examples in class spec) expose two USB Video Streaming Interfaces
>> > (VSIs): one for raw stream formats and one for encoded streams.
>> > Typically, both get their source stream from a single sensor, producing
>> > raw and encoded versions of the video feed simultaneously.
>> > Encoding Units may also support the so-called "simulcast" formats, which
>> > allow additional sub-streams, or layers, used to achieve temporal
>> > scalability. The spec allows up to 4 simulcast layers. Those layers are
>> > encoded in the same format, but encoding parameters, such as resolution,
>> > bitrate, etc., may, depending on the camera capabilities, be changed
>> > independently for each layer, and their streaming state may also be
>> > controlled independently as well. The layers are streamed from the same
>> > USB VSI, and the information which layer a frame belongs to is contained
>> > in its payload header.
>> >
>> > In V4L2 API, a separate video node is created for each VSI: one for raw
>> > formats VSI and another for the encoded formats VSI. Both can operate
>> > completely independently from each other. In addition, if the Encoding
>> > Unit supports simulcast, one V4L2 node is created for each stream layer
>> > instead, and each can be controlled independently, including
>> > streamon/streamoff state, setting resolution and controls. Once a
>> > simulcast format is successfully set for one of the simulcast video nodes
>> > however, it cannot be changed, unless all connected nodes are idle, i.e.
>> > they are not streaming and their buffers are freed.
>> >
>> > The userspace can discover if a set of nodes belongs to one encoding unit
>> > by traversing media controller topology of the camera.
>> >
>> >
>> > I will be gradually posting documentation changes for new features after
>> > initial rounds of reviews. This is a relatively major change to the UVC
>> > driver and although I tried to keep the existing logic for UVC <1.5
>> > cameras intact as much as possible, I would very much appreciate it if
>> > these patches could get some testing from you as well, on your own
>> > devices/systems.
>> >
>> > Thanks,
>> > Pawel Osciak
>> >
>> > Pawel Osciak (19):
>> >       uvcvideo: Add UVC query tracing.
>> >       uvcvideo: Return 0 when setting probe control succeeds.
>> >       uvcvideo: Add support for multiple chains with common roots.
>> >       uvcvideo: Create separate debugfs entries for each streaming
>> >       interface.
>> >       uvcvideo: Add support for UVC1.5 P&C control.
>> >       uvcvideo: Recognize UVC 1.5 encoding units.
>> >       uvcvideo: Unify error reporting during format descriptor parsing.
>> >       uvcvideo: Add UVC1.5 VP8 format support.
>> >       uvcvideo: Reorganize uvc_{get,set}_le_value.
>> >       uvcvideo: Support UVC 1.5 runtime control property.
>> >       uvcvideo: Support V4L2_CTRL_TYPE_BITMASK controls.
>> >       uvcvideo: Reorganize next buffer handling.
>> >       uvcvideo: Unify UVC payload header parsing.
>> >       v4l: Add v4l2_buffer flags for VP8-specific special frames.
>> >       uvcvideo: Add support for VP8 special frame flags.
>> >       v4l: Add encoding camera controls.
>> >       uvcvideo: Add UVC 1.5 Encoding Unit controls.
>> >       v4l: Add V4L2_PIX_FMT_VP8_SIMULCAST format.
>> >       uvcvideo: Add support for UVC 1.5 VP8 simulcast.
>> >
>> >  drivers/media/usb/uvc/uvc_ctrl.c     | 960 +++++++++++++++++++++++++++---
>> >  drivers/media/usb/uvc/uvc_debugfs.c  |   3 +-
>> >  drivers/media/usb/uvc/uvc_driver.c   | 604 ++++++++++++++--------
>> >  drivers/media/usb/uvc/uvc_entity.c   | 129 ++++-
>> >  drivers/media/usb/uvc/uvc_isight.c   |  12 +-
>> >  drivers/media/usb/uvc/uvc_queue.c    |  25 +-
>> >  drivers/media/usb/uvc/uvc_v4l2.c     | 284 +++++++++--
>> >  drivers/media/usb/uvc/uvc_video.c    | 704 ++++++++++++++++---------
>> >  drivers/media/usb/uvc/uvcvideo.h     | 214 +++++++-
>> >  drivers/media/v4l2-core/v4l2-ctrls.c |  29 ++
>> >  include/uapi/linux/usb/video.h       |  45 ++
>> >  include/uapi/linux/v4l2-controls.h   |  31 ++
>> >  include/uapi/linux/videodev2.h       |   8 +
>> >  13 files changed, 2421 insertions(+), 627 deletions(-)
>
> --
> Regards,
>
> Laurent Pinchart
>
