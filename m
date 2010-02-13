Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2646 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420Ab0BMOP7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Feb 2010 09:15:59 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: [PATCH v4 5/7] V4L: Events: Count event queue length
Date: Sat, 13 Feb 2010 15:18:02 +0100
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	iivanov@mm-sol.com, gururaj.nagendra@intel.com,
	david.cohen@nokia.com
References: <4B72C965.7040204@maxwell.research.nokia.com> <1265813889-17847-4-git-send-email-sakari.ailus@maxwell.research.nokia.com> <1265813889-17847-5-git-send-email-sakari.ailus@maxwell.research.nokia.com>
In-Reply-To: <1265813889-17847-5-git-send-email-sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201002131518.02336.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 10 February 2010 15:58:07 Sakari Ailus wrote:
> Update the count field properly by setting it to exactly to number of
> further available events.

After working with this for a bit I realized that the max_alloc thing is not
going to work. The idea behind it was that you can increase the event queue
up to max_alloc if there is no more free room left in the event queue for a
particular file handle. Nice idea, but the only place you can do that is in
v4l2_event_queue and doing it there will produce a locking nightmare.

The right place is when you subscribe to an event. Basically you just want
two functions: v4l2_event_alloc and v4l2_event_free. The latter replaces
v4l2_event_exit, the first replaces v4l2_event_init and the current
v4l2_event_alloc.

The new v4l2_event_alloc just specifies the size of the event queue that you
want. If it is the first time this function is called, then the fh->events
struct is allocated first. Next it just checks if the total number of allocated
events is less than the specified amount and if so it allocates events until
the required number is reached.

So typically you would only call v4l2_event_alloc when the user subscribes
to a particular event. And based on the event type you can call this function
with the desired queue size. For example in the case of ivtv the EOS event
would need just a single event while the VSYNC event might need 60.

So as long as the user does not subscribe to an event there is no memory
wasted. Once he does you will only allocate as much memory as is needed
for that particular event.

> 
> Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
> ---
>  drivers/media/video/v4l2-event.c |   29 +++++++++++++++++------------
>  include/media/v4l2-event.h       |    6 +++++-
>  2 files changed, 22 insertions(+), 13 deletions(-)
> 

<cut>

> diff --git a/include/media/v4l2-event.h b/include/media/v4l2-event.h
> index 580c9d4..671c8f7 100644
> --- a/include/media/v4l2-event.h
> +++ b/include/media/v4l2-event.h
> @@ -28,6 +28,8 @@
>  #include <linux/types.h>
>  #include <linux/videodev2.h>
>  
> +#include <asm/atomic.h>

This header is not needed.

Regards,

	Hans

> +
>  struct v4l2_fh;
>  struct video_device;
>  
> @@ -45,11 +47,13 @@ struct v4l2_events {
>  	wait_queue_head_t	wait;
>  	struct list_head	subscribed; /* Subscribed events */
>  	struct list_head	available; /* Dequeueable event */
> +	unsigned int		navailable;
> +	unsigned int		max_alloc; /* Never allocate more. */
>  	struct list_head	free; /* Events ready for use */
>  };
>  
>  int v4l2_event_alloc(struct v4l2_fh *fh, unsigned int n);
> -int v4l2_event_init(struct v4l2_fh *fh, unsigned int n);
> +int v4l2_event_init(struct v4l2_fh *fh, unsigned int n, unsigned int max_alloc);
>  void v4l2_event_exit(struct v4l2_fh *fh);
>  int v4l2_event_dequeue(struct v4l2_fh *fh, struct v4l2_event *event);
>  struct v4l2_subscribed_event *v4l2_event_subscribed(
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
