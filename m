Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:51350 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353AbZIRQCl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Sep 2009 12:02:41 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [RFC] Video events
Date: Fri, 18 Sep 2009 18:03:44 +0200
Cc: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Cohen David Abraham <david.cohen@nokia.com>,
	"Zutshi Vimarsh (Nokia-D-MSW/Helsinki)" <vimarsh.zutshi@nokia.com>,
	=?iso-8859-1?q?Koskip=E4=E4_Antti_Jussi_Petteri?=
	<antti.koskipaa@nokia.com>, Stefan.Kost@nokia.com,
	Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200909181803.44291.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everybody,

yet another RFC, probably the last one before the Linux Plumbers Conference.

This RFC describes a way to pass generic events from video drivers to 
userspace applications. Even though I've developed the first prototype for a 
V4L2 driver, it should be applicable to DVB devices as well with minor 
modifications if any. If someone familiar with DVB notices any serious 
problem, please let me know.

Purpose
=======

Many video devices need to notify userspace applications of various events. 
This includes, but is not limited to,

- button press events

- control change events, when the device changes the value of a control 
automatically and wants to notify the user

- motor-related events, when the device reaches the end stop (this could be 
handled using control change notifications on the motor controls)

- signal detection/loss on inputs

- image-related events, such as vertical sync, frame size or frame rate 
change, ...

- stream-related events, such as stream start/end, when a Linux system acting 
as a video device to some host (for instance a USB video gadget) receives 
control requests from the host

Some of those events can be easily handled by the input subsystem, such as the 
button events. Other events could hack their way into some kind of input 
device, but that would be abusing the input device API and would probably 
confuse some userspace applications.

A dedicated event interface is thus needed for video devices.

Current implementations
=======================

DVB video events
----------------

The ivtv and av7110 drivers use an existing event notification API implemented 
for DVB devices. include/linux/dvb/video.h defines the following structure and 
ioctl.

struct video_event {
        __s32 type;
#define VIDEO_EVENT_SIZE_CHANGED        1
#define VIDEO_EVENT_FRAME_RATE_CHANGED  2
#define VIDEO_EVENT_DECODER_STOPPED     3
#define VIDEO_EVENT_VSYNC               4
        __kernel_time_t timestamp;
        union {
                video_size_t size;
                unsigned int frame_rate;
                unsigned char vsync_field;
        } u;
};

#define VIDEO_GET_EVENT            _IOR('o', 28, struct video_event)

An application waits for events using the select() function by setting the 
file descriptor in the exception file descriptors set. When an event is 
available the poll handler sets POLLPRI which wakes up select().

The userspace application then calls ioctl(VIDIO_GET_EVENT) which fills the 
struct video_event with an event type, a timestamp and event type specific 
data.

UVC gadget events
-----------------

The UVC gadget driver (posted today on the linux-media and linux-usb mailing 
lists) uses an independently developed but very similar method.

enum uvc_event_type
{
        UVC_EVENT_CONNECT,
        UVC_EVENT_DISCONNECT,
        UVC_EVENT_STREAMON,
        UVC_EVENT_STREAMOFF,
        UVC_EVENT_SETUP,
        UVC_EVENT_DATA,
};

struct uvc_event_data
{
        int length;
        __u8 data[64];
};

struct uvc_event
{
        enum uvc_event_type type;
        union {
                enum usb_device_speed speed;
                struct usb_ctrlrequest req;
                struct uvc_event_data data;
        };
};

#define UVCIOC_EVENT_READ                       _IOR('U', 1, struct uvc_event)

The user is notified through select() and the exception file descriptors set 
exactly the same way as for the DVB video events.

ACPI events
-----------

ACPI reports button events through the input subsystem, and generic events 
through netlink. For those not familiar with netlink, it's basically a kernel 
<-> userspace message passing interface using sockets.

There are probably other event notification APIs in the Linux kernel, feel 
free to mention the ones you know about.

Implementation proposal
=======================

My proposal is to unify the DVB video and UVC gadget event APIs into a single 
video event API.

The following structure lists fields common to all event types. Some of them 
(such as the sequence number) might not be required, but I've listed all the 
ones I thought of.

struct video_event {
        __u32 type;
        __u32 sequence;
        __u32 entity;
        struct timeval timestamp;
        __u8 data[64];
};

#define VIDEO_GET_EVENT            _IOR('o', 28, struct video_event)

Applications wait for events using the select() function by setting the file 
descriptor in the exception file descriptors set. When an event is available 
the poll handler sets POLLPRI which wakes up select().

The userspace application then calls ioctl(VIDIO_GET_EVENT) which fills the 
struct video_event. Note that the ioctl definition comes from the DVB video.h 
header and can be changed to a V4L2 or media controller ioctl.

type: Similarly to V4L2 controls, event types should be defined in the 
V4L2/DVB specification. Drivers could also implement private events.

sequence: Event sequence number. This field is incremented by the driver for 
every event. It can be used by the application to detect lost events, caused 
by buffer overruns for instance.

entity: The entity ID, when the ioctl is used with media controller nodes. 
This allows a single media controller to deliver events for multiple sub-
devices and video nodes. When used directly on a video node, the entity field 
is not used.

timestamp: Time at which the event was generated by the hardware. If that 
information isn't available, use the time at which the event was received by 
the driver. When events are related to video frames, the timestamp should be 
equal (or at least as close as possible to) the related v4l2_buffer timestamp.

data: Event type-specific data. 64 bytes is completely arbitrary. A "good" 
size could be chosen to have the whole structure size a multiple of cache 
lines on common architectures.


As usual, comments are welcome. This will probably be discussed during the LPC 
(if we can make the topic fit into the schedule).

-- 
Regards,

Laurent Pinchart
