Return-path: <linux-media-owner@vger.kernel.org>
Received: from xenotime.net ([72.52.64.118]:40576 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755162Ab0BVXk7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2010 18:40:59 -0500
Received: from chimera.site ([71.245.98.113]) by xenotime.net for <linux-media@vger.kernel.org>; Mon, 22 Feb 2010 15:40:55 -0800
Message-ID: <4B831607.1010902@xenotime.net>
Date: Mon, 22 Feb 2010 15:40:55 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
CC: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com, david.cohen@nokia.com
Subject: Re: [PATCH v7 6/6] V4L: Events: Add documentation
References: <4B830CCA.8030909@maxwell.research.nokia.com> <1266879701-9814-6-git-send-email-sakari.ailus@maxwell.research.nokia.com>
In-Reply-To: <1266879701-9814-6-git-send-email-sakari.ailus@maxwell.research.nokia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/22/10 15:01, Sakari Ailus wrote:
> Add documentation on how to use V4L2 events, both for V4L2 drivers and for
> V4L2 applications.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
> ---
>  Documentation/DocBook/media-entities.tmpl          |    9 ++
>  Documentation/DocBook/v4l/dev-event.xml            |   33 +++++
>  Documentation/DocBook/v4l/v4l2.xml                 |    3 +
>  Documentation/DocBook/v4l/vidioc-dqevent.xml       |  124 ++++++++++++++++++++
>  .../DocBook/v4l/vidioc-subscribe-event.xml         |  104 ++++++++++++++++
>  Documentation/video4linux/v4l2-framework.txt       |   57 +++++++++
>  6 files changed, 330 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/DocBook/v4l/dev-event.xml
>  create mode 100644 Documentation/DocBook/v4l/vidioc-dqevent.xml
>  create mode 100644 Documentation/DocBook/v4l/vidioc-subscribe-event.xml
> 

> diff --git a/Documentation/DocBook/v4l/dev-event.xml b/Documentation/DocBook/v4l/dev-event.xml
> new file mode 100644
> index 0000000..ecee64d
> --- /dev/null
> +++ b/Documentation/DocBook/v4l/dev-event.xml
> @@ -0,0 +1,33 @@
> +  <title>Event Interface</title>
> +
> +  <para>The V4L2 event interface provides means for user to get
> +  immediately notified on certain conditions taking place on a device.
> +  This might include start of frame or loss of signal events, for
> +  example.
> +  </para>
> +
> +  <para>To receive events, the events the user is interested first must be

                                                  is interested in

> +  subscribed using the &VIDIOC-SUBSCRIBE-EVENT; ioctl. Once an event is
> +  subscribed, the events of subscribed types are dequeueable using the
> +  &VIDIOC-DQEVENT; ioctl. Events may be unsubscribed using
> +  VIDIOC_UNSUBSCRIBE_EVENT ioctl. The special event type V4L2_EVENT_ALL may
> +  be used to unsubscribe all the events the driver supports.</para>
> +
> +  <para>The event subscriptions and event queues are specific to file
> +  handles. Subscribing an event on one file handle does not affect
> +  other file handles.
> +  </para>
> +
> +  <para>The information on dequeueable events are obtained by using

                                                 is obtained

> +  select or poll system calls on video devices. The V4L2 events use
> +  POLLPRI events on poll system call and exceptions on select system
> +  call.
> +  </para>
> +
> +  <!--
> +Local Variables:
> +mode: sgml
> +sgml-parent-document: "v4l2.sgml"
> +indent-tabs-mode: nil
> +End:
> +  -->

> diff --git a/Documentation/video4linux/v4l2-framework.txt b/Documentation/video4linux/v4l2-framework.txt
> index bfaf0c5..d6deb35 100644
> --- a/Documentation/video4linux/v4l2-framework.txt
> +++ b/Documentation/video4linux/v4l2-framework.txt
> @@ -732,3 +732,60 @@ Useful functions:
>  The users of v4l2_fh know whether a driver uses v4l2_fh as its
>  file->private_data pointer by testing the V4L2_FL_USES_V4L2_FH bit in
>  video_device->flags.
> +
> +V4L2 events
> +-----------
> +
> +The V4L2 events provide a generic way to pass events to user space.
> +The driver must use v4l2_fh to be able to support V4L2 events.
> +
> +Useful functions:
> +
> +- v4l2_event_alloc()
> +
> +  To use events, the driver must allocate events for the file handle. By
> +  calling the function more than once, the driver may assure that at least n
> +  events in total has been allocated. The function may not be called in

                     have been

> +  atomic context.
> +
> +- v4l2_event_queue()
> +
> +  Queue events to video device. The driver's only responsibility is to fill
> +  in the type and the data fields. The other fields will be filled in by
> +  V4L2.
> +
> +- v4l2_event_subscribe()
> +
> +  The video_device->ioctl_ops->vidioc_subscribe_event must check the driver
> +  is able to produce events with specified event id. Then it calls
> +  v4l2_event_subscribe() to subscribe the event.
> +
> +- v4l2_event_unsubscribe()
> +
> +  vidioc_unsubscribe_event in struct v4l2_ioctl_ops. A driver may use
> +  v4l2_event_unsubscribe() directly unless it wants to be involved in
> +  unsubscription process.
> +
> +  The special type V4L2_EVENT_ALL may be used to unsubscribe all events. The
> +  drivers may want to handle this in a special way.
> +
> +- v4l2_event_pending()
> +
> +  Returns the number of pending events. Useful when implementing poll.
> +
> +Drivers do not initialise events directly. The events are initialised
> +through v4l2_fh_init() if video_device->ioctl_ops->vidioc_subscribe_event is
> +non-NULL. This *MUST* be performed in the driver's
> +v4l2_file_operations->open() handler.
> +
> +Events are delivered to user space through the poll system call. The driver
> +can use v4l2_fh->events->wait wait_queue_head_t as the argument for
> +poll_wait().
> +
> +There are standard and private events. New standard events must use the
> +smallest available event type. The drivers must allocate their events
> +starting from base (V4L2_EVENT_PRIVATE_START + n * 1024) + 1.
> +
> +An example on how the V4L2 events may be used can be found in the OMAP
> +3 ISP driver available at <URL:http://gitorious.org/omap3camera> as of
> +writing this.


-- 
~Randy
