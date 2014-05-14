Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:43118 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbaENJGD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 May 2014 05:06:03 -0400
Message-id: <537331F1.6060405@samsung.com>
Date: Wed, 14 May 2014 11:05:53 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Arun Kumar K <arun.kk@samsung.com>
Cc: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	k.debski@samsung.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com, posciak@chromium.org,
	arunkk.samsung@gmail.com
Subject: Re: [PATCH v5 1/2] [media] v4l: Add source change event
References: <1400050783-2158-1-git-send-email-arun.kk@samsung.com>
 <1400050783-2158-2-git-send-email-arun.kk@samsung.com>
In-reply-to: <1400050783-2158-2-git-send-email-arun.kk@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arun,

On 14/05/14 08:59, Arun Kumar K wrote:
> This event indicates that the video device has encountered
> a source parameter change during runtime. This can typically be a
> resolution change detected by a video decoder OR a format change
> detected by an input connector.
> 
> This needs to be nofified to the userspace and the application may
> be expected to reallocate buffers before proceeding. The application
> can subscribe to events on a specific pad or input port which
> it is interested in.
> 
> Signed-off-by: Arun Kumar K <arun.kk@samsung.com>

This looks like a nice API enhancement.

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

> ---
>  Documentation/DocBook/media/v4l/vidioc-dqevent.xml |   33 ++++++++++++++++++
>  .../DocBook/media/v4l/vidioc-subscribe-event.xml   |   20 +++++++++++
>  drivers/media/v4l2-core/v4l2-event.c               |   36 ++++++++++++++++++++
>  include/media/v4l2-event.h                         |    4 +++
>  include/uapi/linux/videodev2.h                     |    8 +++++
>  5 files changed, 101 insertions(+)
> 
> diff --git a/Documentation/DocBook/media/v4l/vidioc-dqevent.xml b/Documentation/DocBook/media/v4l/vidioc-dqevent.xml
> index 89891ad..820f86e 100644
> --- a/Documentation/DocBook/media/v4l/vidioc-dqevent.xml
> +++ b/Documentation/DocBook/media/v4l/vidioc-dqevent.xml
> @@ -242,6 +242,22 @@
>        </tgroup>
>      </table>
>  
> +    <table frame="none" pgwide="1" id="v4l2-event-src-change">
> +      <title>struct <structname>v4l2_event_src_change</structname></title>
> +      <tgroup cols="3">
> +	&cs-str;
> +	<tbody valign="top">
> +	  <row>
> +	    <entry>__u32</entry>
> +	    <entry><structfield>changes</structfield></entry>
> +	    <entry>
> +	      A bitmask that tells what has changed. See <xref linkend="src-changes-flags" />.
> +	    </entry>
> +	  </row>
> +	</tbody>
> +      </tgroup>
> +    </table>
> +
>      <table pgwide="1" frame="none" id="changes-flags">
>        <title>Changes</title>
>        <tgroup cols="3">
> @@ -270,6 +286,23 @@
>  	</tbody>
>        </tgroup>
>      </table>
> +
> +    <table pgwide="1" frame="none" id="src-changes-flags">
> +      <title>Source Changes</title>
> +      <tgroup cols="3">
> +	&cs-def;
> +	<tbody valign="top">
> +	  <row>
> +	    <entry><constant>V4L2_EVENT_SRC_CH_RESOLUTION</constant></entry>
> +	    <entry>0x0001</entry>
> +	    <entry>This event gets triggered when a resolution change is
> +	    detected at an input. This can come from an input connector or
> +	    from a video decoder.
> +	    </entry>
> +	  </row>
> +	</tbody>
> +      </tgroup>
> +    </table>
>    </refsect1>
>    <refsect1>
>      &return-value;
> diff --git a/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml b/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml
> index 5c70b61..f016254 100644
> --- a/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml
> +++ b/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml
> @@ -155,6 +155,26 @@
>  	    </entry>
>  	  </row>
>  	  <row>
> +	    <entry><constant>V4L2_EVENT_SOURCE_CHANGE</constant></entry>
> +	    <entry>5</entry>
> +	    <entry>
> +	      <para>This event is triggered when a source parameter change is
> +	       detected during runtime by the video device. It can be a
> +	       runtime resolution change triggered by a video decoder or the
> +	       format change happening on an input connector.
> +	       This event requires that the <structfield>id</structfield>
> +	       matches the input index (when used with a video device node)
> +	       or the pad index (when used with a subdevice node) from which
> +	       you want to receive events.</para>
> +
> +              <para>This event has a &v4l2-event-source-change; associated
> +	      with it. The <structfield>changes</structfield> bitfield denotes
> +	      what has changed for the subscribed pad. If multiple events
> +	      occurred before application could dequeue them, then the changes
> +	      will have the ORed value of all the events generated.</para>
> +	    </entry>
> +	  </row>
> +	  <row>
>  	    <entry><constant>V4L2_EVENT_PRIVATE_START</constant></entry>
>  	    <entry>0x08000000</entry>
>  	    <entry>Base event number for driver-private events.</entry>
> diff --git a/drivers/media/v4l2-core/v4l2-event.c b/drivers/media/v4l2-core/v4l2-event.c
> index 86dcb54..8761aab 100644
> --- a/drivers/media/v4l2-core/v4l2-event.c
> +++ b/drivers/media/v4l2-core/v4l2-event.c
> @@ -318,3 +318,39 @@ int v4l2_event_subdev_unsubscribe(struct v4l2_subdev *sd, struct v4l2_fh *fh,
>  	return v4l2_event_unsubscribe(fh, sub);
>  }
>  EXPORT_SYMBOL_GPL(v4l2_event_subdev_unsubscribe);
> +
> +static void v4l2_event_src_replace(struct v4l2_event *old,
> +				const struct v4l2_event *new)
> +{
> +	u32 old_changes = old->u.src_change.changes;
> +
> +	old->u.src_change = new->u.src_change;
> +	old->u.src_change.changes |= old_changes;
> +}
> +
> +static void v4l2_event_src_merge(const struct v4l2_event *old,
> +				struct v4l2_event *new)
> +{
> +	new->u.src_change.changes |= old->u.src_change.changes;
> +}
> +
> +static const struct v4l2_subscribed_event_ops v4l2_event_src_ch_ops = {
> +	.replace = v4l2_event_src_replace,
> +	.merge = v4l2_event_src_merge,
> +};
> +
> +int v4l2_src_change_event_subscribe(struct v4l2_fh *fh,
> +				const struct v4l2_event_subscription *sub)
> +{
> +	if (sub->type == V4L2_EVENT_SOURCE_CHANGE)
> +		return v4l2_event_subscribe(fh, sub, 0, &v4l2_event_src_ch_ops);
> +	return -EINVAL;
> +}
> +EXPORT_SYMBOL_GPL(v4l2_src_change_event_subscribe);
> +
> +int v4l2_src_change_event_subdev_subscribe(struct v4l2_subdev *sd,
> +		struct v4l2_fh *fh, struct v4l2_event_subscription *sub)
> +{
> +	return v4l2_src_change_event_subscribe(fh, sub);
> +}
> +EXPORT_SYMBOL_GPL(v4l2_src_change_event_subdev_subscribe);
> diff --git a/include/media/v4l2-event.h b/include/media/v4l2-event.h
> index be05d01..1ab9045 100644
> --- a/include/media/v4l2-event.h
> +++ b/include/media/v4l2-event.h
> @@ -132,4 +132,8 @@ int v4l2_event_unsubscribe(struct v4l2_fh *fh,
>  void v4l2_event_unsubscribe_all(struct v4l2_fh *fh);
>  int v4l2_event_subdev_unsubscribe(struct v4l2_subdev *sd, struct v4l2_fh *fh,
>  				  struct v4l2_event_subscription *sub);
> +int v4l2_src_change_event_subscribe(struct v4l2_fh *fh,
> +				const struct v4l2_event_subscription *sub);
> +int v4l2_src_change_event_subdev_subscribe(struct v4l2_subdev *sd,
> +		struct v4l2_fh *fh, struct v4l2_event_subscription *sub);
>  #endif /* V4L2_EVENT_H */
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index ea468ee..b923d91 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -1765,6 +1765,7 @@ struct v4l2_streamparm {
>  #define V4L2_EVENT_EOS				2
>  #define V4L2_EVENT_CTRL				3
>  #define V4L2_EVENT_FRAME_SYNC			4
> +#define V4L2_EVENT_SOURCE_CHANGE		5
>  #define V4L2_EVENT_PRIVATE_START		0x08000000
>  
>  /* Payload for V4L2_EVENT_VSYNC */
> @@ -1796,12 +1797,19 @@ struct v4l2_event_frame_sync {
>  	__u32 frame_sequence;
>  };
>  
> +#define V4L2_EVENT_SRC_CH_RESOLUTION		(1 << 0)
> +
> +struct v4l2_event_src_change {
> +	__u32 changes;
> +};
> +
>  struct v4l2_event {
>  	__u32				type;
>  	union {
>  		struct v4l2_event_vsync		vsync;
>  		struct v4l2_event_ctrl		ctrl;
>  		struct v4l2_event_frame_sync	frame_sync;
> +		struct v4l2_event_src_change	src_change;
>  		__u8				data[64];
>  	} u;
>  	__u32				pending;
> 


-- 
Sylwester Nawrocki
Samsung R&D Institute Poland
