Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:34187 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab1F2J4r (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2011 05:56:47 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [RFC PATCH] Add support for V4L2_EVENT_SUB_FL_NO_FEEDBACK
Date: Wed, 29 Jun 2011 11:57:02 +0200
Cc: "linux-media" <linux-media@vger.kernel.org>
References: <201106281718.07158.hverkuil@xs4all.nl>
In-Reply-To: <201106281718.07158.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106291157.02631.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hans,

On Tuesday 28 June 2011 17:18:07 Hans Verkuil wrote:
> Originally no control events would go to the filehandle that called the
> VIDIOC_S_CTRL/VIDIOC_S_EXT_CTRLS ioctls. This was to prevent a feedback
> loop.
> 
> This is now only done if the new V4L2_EVENT_SUB_FL_NO_FEEDBACK flag is
> set.

What about doing it the other way around ? Most applications won't want that 
feedback, you could disable it by default.

> Based on a suggestion from Mauro Carvalho Chehab <mchehab@redhat.com>.
> 
> This goes on top of the patch series I posted today titled:
> "Allocate events per-event-type, v4l2-ctrls cleanup"
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  .../DocBook/media/v4l/vidioc-subscribe-event.xml   |   31
> ++++++++++++++------ drivers/media/video/v4l2-ctrls.c                   | 
>   3 +-
>  include/linux/videodev2.h                          |    3 +-
>  3 files changed, 26 insertions(+), 11 deletions(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml
> b/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml index
> 039a969..0d4465f 100644
> --- a/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml
> +++ b/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml
> @@ -114,25 +114,20 @@
>  	  <row>
>  	    <entry><constant>V4L2_EVENT_CTRL</constant></entry>
>  	    <entry>3</entry>
> -	    <entry>This event requires that the <structfield>id</structfield>
> +	    <entry><para>This event requires that the
> <structfield>id</structfield> matches the control ID from which you want
> to receive events.
>  		This event is triggered if the control's value changes, if a
>  		button control is pressed or if the control's flags change.
>  	    	This event has a &v4l2-event-ctrl; associated with it. This struct
>  		contains much of the same information as &v4l2-queryctrl; and
> -		&v4l2-control;.
> +		&v4l2-control;.</para>
> 
> -		If the event is generated due to a call to &VIDIOC-S-CTRL; or
> -		&VIDIOC-S-EXT-CTRLS;, then the event will not be sent to
> -		the file handle that called the ioctl function. This prevents
> -		nasty feedback loops.
> -
> -		This event type will ensure that no information is lost when
> +		<para>This event type will ensure that no information is lost when
>  		more events are raised than there is room internally. In that
>  		case the &v4l2-event-ctrl; of the second-oldest event is kept,
>  		but the <structfield>changes</structfield> field of the
>  		second-oldest event is ORed with the <structfield>changes</structfield>
> -		field of the oldest event.
> +		field of the oldest event.</para>
>  	    </entry>
>  	  </row>
>  	  <row>
> @@ -157,6 +152,24 @@
>  		that are triggered by a status change such as
> <constant>V4L2_EVENT_CTRL</constant>. Other events will ignore this
> flag.</entry>
>  	  </row>
> +	  <row>
> +	    <entry><constant>V4L2_EVENT_SUB_FL_NO_FEEDBACK</constant></entry>
> +	    <entry>0x0002</entry>
> +	    <entry><para>If set, then events directly caused by an ioctl will not
> be sent to +		the filehandle that called that ioctl. For example, 
changing
> a control using +		&VIDIOC-S-CTRL; will not cause a V4L2_EVENT_CTRL to be
> sent back to that +		same filehandle. All other filehandles that are
> subscribed to that event +		will still receive it. This prevents feedback
> loops where an application +		changes a control to a one value and then
> another, and then receives an +		event telling it that that control has
> changed to the first value.</para> +
> +		<para>Since it can't tell whether that event was caused by another
> application +		or by the first value change it is hard to decide whether
> to set the +		control to the value in the event, or ignore it.</para>
> +
> +		<para>This flag will prevent this situation from happening.</para>
> +	    </entry>
> +	  </row>
>  	</tbody>
>        </tgroup>
>      </table>
> diff --git a/drivers/media/video/v4l2-ctrls.c
> b/drivers/media/video/v4l2-ctrls.c index bc08f86..bac793a 100644
> --- a/drivers/media/video/v4l2-ctrls.c
> +++ b/drivers/media/video/v4l2-ctrls.c
> @@ -590,7 +590,8 @@ static void send_event(struct v4l2_fh *fh, struct
> v4l2_ctrl *ctrl, u32 changes) fill_event(&ev, ctrl, changes);
> 
>  	list_for_each_entry(sev, &ctrl->ev_subs, node)
> -		if (sev->fh && sev->fh != fh)
> +		if (sev->fh && (sev->fh != fh ||
> +				!(sev->flags & V4L2_EVENT_SUB_FL_NO_FEEDBACK)))
>  			v4l2_event_queue_fh(sev->fh, &ev);
>  }
> 
> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> index baafe2f..00bae77 100644
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h
> @@ -1832,7 +1832,8 @@ struct v4l2_event {
>  	__u32				reserved[8];
>  };
> 
> -#define V4L2_EVENT_SUB_FL_SEND_INITIAL (1 << 0)
> +#define V4L2_EVENT_SUB_FL_SEND_INITIAL	(1 << 0)
> +#define V4L2_EVENT_SUB_FL_NO_FEEDBACK	(1 << 1)
> 
>  struct v4l2_event_subscription {
>  	__u32				type;

-- 
Regards,

Laurent Pinchart
