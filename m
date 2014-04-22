Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:2957 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924AbaDVMwo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Apr 2014 08:52:44 -0400
Message-ID: <53566601.2080801@xs4all.nl>
Date: Tue, 22 Apr 2014 14:52:17 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Arun Kumar K <arun.kk@samsung.com>, linux-media@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org
CC: k.debski@samsung.com, s.nawrocki@samsung.com,
	laurent.pinchart@ideasonboard.com, posciak@chromium.org,
	arunkk.samsung@gmail.com
Subject: Re: [PATCH v2 1/2] v4l: Add resolution change event.
References: <1398072362-24962-1-git-send-email-arun.kk@samsung.com> <1398072362-24962-2-git-send-email-arun.kk@samsung.com>
In-Reply-To: <1398072362-24962-2-git-send-email-arun.kk@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/21/2014 11:26 AM, Arun Kumar K wrote:
> From: Pawel Osciak <posciak@chromium.org>
> 
> This event indicates that the decoder has reached a point in the stream,
> at which the resolution changes. The userspace is expected to provide a new
> set of CAPTURE buffers for the new format before decoding can continue.
> The event can also be used for more generic events involving resolution
> or format changes at runtime for all kinds of video devices.
> 
> Signed-off-by: Pawel Osciak <posciak@chromium.org>
> Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
> ---
>  .../DocBook/media/v4l/vidioc-subscribe-event.xml   |   16 ++++++++++++++++
>  include/uapi/linux/videodev2.h                     |    6 ++++++
>  2 files changed, 22 insertions(+)
> 
> diff --git a/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml b/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml
> index 5c70b61..0aec831 100644
> --- a/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml
> +++ b/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml
> @@ -155,6 +155,22 @@
>  	    </entry>
>  	  </row>
>  	  <row>
> +	    <entry><constant>V4L2_EVENT_SOURCE_CHANGE</constant></entry>
> +	    <entry>5</entry>
> +	    <entry>
> +	      <para>This event is triggered when a resolution or format change
> +	       is detected during runtime by the video device. It can be a
> +	       runtime resolution change triggered by a video decoder or the
> +	       format change happening on an HDMI connector. Application may
> +	       need to reinitialize buffers before proceeding further.</para>
> +
> +              <para>This event has a &v4l2-event-source-change; associated
> +	      with it. This has significance only for v4l2 subdevs where the
> +	      <structfield>pad_num</structfield> field will be updated with
> +	      the pad number on which the event is triggered.</para>
> +	    </entry>
> +	  </row>
> +	  <row>
>  	    <entry><constant>V4L2_EVENT_PRIVATE_START</constant></entry>
>  	    <entry>0x08000000</entry>
>  	    <entry>Base event number for driver-private events.</entry>
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index 6ae7bbe..12e0614 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -1733,6 +1733,7 @@ struct v4l2_streamparm {
>  #define V4L2_EVENT_EOS				2
>  #define V4L2_EVENT_CTRL				3
>  #define V4L2_EVENT_FRAME_SYNC			4
> +#define V4L2_EVENT_SOURCE_CHANGE		5
>  #define V4L2_EVENT_PRIVATE_START		0x08000000
>  
>  /* Payload for V4L2_EVENT_VSYNC */
> @@ -1764,12 +1765,17 @@ struct v4l2_event_frame_sync {
>  	__u32 frame_sequence;
>  };
>  
> +struct v4l2_event_source_change {
> +	__u32 pad_num;
> +};
> +
>  struct v4l2_event {
>  	__u32				type;
>  	union {
>  		struct v4l2_event_vsync		vsync;
>  		struct v4l2_event_ctrl		ctrl;
>  		struct v4l2_event_frame_sync	frame_sync;
> +		struct v4l2_event_source_change source_change;
>  		__u8				data[64];
>  	} u;
>  	__u32				pending;
> 

This needs to be done differently. The problem is that you really have multiple
events that you want to subscribe to: one for each pad (or input: see the way
VIDIOC_G/S_EDID maps pad to an input or output index when used with a video node,
we have to support that for this event as well).

What you want to do is similar to what is done for control events: there you can
subscribe for a specific control and get notified when that control changes.

The way that works in the event code is that the 'id' field in the v4l2_event
struct contains that control ID, or, in this case, the pad/input/output index.

In the application you will subscribe to the SOURCE_CHANGE event for a specific
pad/input/output index.

In other words, the pad_num field should be dropped and the id field used
instead.

Assuming we will also add a 'changes' field (see my reply to the other post
on that topic), then you should also provide replace and merge ops (see
v4l2-ctrls.c). That way it is sufficient to use just one element when calling
v4l2_event_subscribe(): you will never loose information since if multiple
events arrive before the application can dequeue them, the 'changes' information
will be the ORed value of all those intermediate events.

It's all more work, but it is critical to ensure that the application never
misses events.

Regards,

	Hans
