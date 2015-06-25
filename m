Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0140.hostedemail.com ([216.40.44.140]:36076 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751493AbbFYNR0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Jun 2015 09:17:26 -0400
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
	by smtpgrave04.hostedemail.com (Postfix) with ESMTP id B3932B1900
	for <linux-media@vger.kernel.org>; Thu, 25 Jun 2015 13:07:27 +0000 (UTC)
Date: Thu, 25 Jun 2015 09:07:24 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Kamil Debski <k.debski@samsung.com>,
	linux-media@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH 2/2] [media] videobuf2: add trace events
Message-ID: <20150625090724.09fb03f8@gandalf.local.home>
In-Reply-To: <1435226487-24863-2-git-send-email-p.zabel@pengutronix.de>
References: <1435226487-24863-1-git-send-email-p.zabel@pengutronix.de>
	<1435226487-24863-2-git-send-email-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 25 Jun 2015 12:01:27 +0200
Philipp Zabel <p.zabel@pengutronix.de> wrote:

> diff --git a/include/trace/events/v4l2.h b/include/trace/events/v4l2.h
> index 89d0497..3d15cf1 100644
> --- a/include/trace/events/v4l2.h
> +++ b/include/trace/events/v4l2.h
> @@ -175,9 +175,108 @@ SHOW_FIELD
>  		)							\
>  	)
>  
> +#define VB2_TRACE_EVENT(event_name)					\

This is what we have DECLARE_EVENT_CLASS for. Please use that,
otherwise you are adding about 5k of text per event (where as
DEFINE_EVENT adds only about 250 bytes).

DECLARE_EVENT_CLASS(vb2_event_class,
[..]


> +	TRACE_EVENT(event_name,						\
> +		TP_PROTO(struct vb2_queue *q, struct vb2_buffer *vb),	\
> +									\
> +		TP_ARGS(q, vb),						\
> +									\
> +		TP_STRUCT__entry(					\
> +			__field(int, minor)				\
> +			__field(u32, queued_count)			\
> +			__field(int, owned_by_drv_count)		\
> +			__field(u32, index)				\
> +			__field(u32, type)				\
> +			__field(u32, bytesused)				\
> +			__field(u32, flags)				\
> +			__field(u32, field)				\
> +			__field(s64, timestamp)				\
> +			__field(u32, timecode_type)			\
> +			__field(u32, timecode_flags)			\
> +			__field(u8, timecode_frames)			\
> +			__field(u8, timecode_seconds)			\
> +			__field(u8, timecode_minutes)			\
> +			__field(u8, timecode_hours)			\
> +			__field(u8, timecode_userbits0)			\
> +			__field(u8, timecode_userbits1)			\
> +			__field(u8, timecode_userbits2)			\
> +			__field(u8, timecode_userbits3)			\
> +			__field(u32, sequence)				\
> +		),							\
> +									\
> +		TP_fast_assign(						\
> +			__entry->minor = q->owner ?			\
> +				q->owner->vdev->minor : -1;		\
> +			__entry->queued_count = q->queued_count;	\
> +			__entry->owned_by_drv_count =			\
> +				atomic_read(&q->owned_by_drv_count);	\
> +			__entry->index = vb->v4l2_buf.index;		\
> +			__entry->type = vb->v4l2_buf.type;		\
> +			__entry->bytesused = vb->v4l2_buf.bytesused;	\
> +			__entry->flags = vb->v4l2_buf.flags;		\
> +			__entry->field = vb->v4l2_buf.field;		\
> +			__entry->timestamp =				\
> +				timeval_to_ns(&vb->v4l2_buf.timestamp);	\
> +			__entry->timecode_type =			\
> +				vb->v4l2_buf.timecode.type;		\
> +			__entry->timecode_flags =			\
> +				vb->v4l2_buf.timecode.flags;		\
> +			__entry->timecode_frames =			\
> +				vb->v4l2_buf.timecode.frames;		\
> +			__entry->timecode_seconds =			\
> +				vb->v4l2_buf.timecode.seconds;		\
> +			__entry->timecode_minutes =			\
> +				vb->v4l2_buf.timecode.minutes;		\
> +			__entry->timecode_hours =			\
> +				vb->v4l2_buf.timecode.hours;		\
> +			__entry->timecode_userbits0 =			\
> +				vb->v4l2_buf.timecode.userbits[0];	\
> +			__entry->timecode_userbits1 =			\
> +				vb->v4l2_buf.timecode.userbits[1];	\
> +			__entry->timecode_userbits2 =			\
> +				vb->v4l2_buf.timecode.userbits[2];	\
> +			__entry->timecode_userbits3 =			\
> +				vb->v4l2_buf.timecode.userbits[3];	\
> +			__entry->sequence = vb->v4l2_buf.sequence;	\
> +		),							\
> +									\
> +		TP_printk("minor = %d, queued = %u, owned_by_drv = %d "	\
> +			  "index = %u, type = %s, "			\
> +			  "bytesused = %u, flags = %s, "		\
> +			  "field = %s, timestamp = %llu, timecode = { "	\
> +			  "type = %s, flags = %s, frames = %u, "	\
> +			  "seconds = %u, minutes = %u, hours = %u, "	\
> +			  "userbits = { %u %u %u %u } }, "		\
> +			  "sequence = %u", __entry->minor,		\
> +			  __entry->queued_count,			\
> +			  __entry->owned_by_drv_count,			\
> +			  __entry->index, show_type(__entry->type),	\
> +			  __entry->bytesused,				\
> +			  show_flags(__entry->flags),			\
> +			  show_field(__entry->field),			\
> +			  __entry->timestamp,				\
> +			  show_timecode_type(__entry->timecode_type),	\
> +			  show_timecode_flags(__entry->timecode_flags),	\
> +			  __entry->timecode_frames,			\
> +			  __entry->timecode_seconds,			\
> +			  __entry->timecode_minutes,			\
> +			  __entry->timecode_hours,			\
> +			  __entry->timecode_userbits0,			\
> +			  __entry->timecode_userbits1,			\
> +			  __entry->timecode_userbits2,			\
> +			  __entry->timecode_userbits3,			\
> +			  __entry->sequence				\
> +		)							\
> +	)
> +
>  V4L2_TRACE_EVENT(v4l2_dqbuf);
>  V4L2_TRACE_EVENT(v4l2_qbuf);

While you are at it, nuke the above macro and convert that too.

>  
> +VB2_TRACE_EVENT(vb2_buf_done);
> +VB2_TRACE_EVENT(vb2_buf_queue);
> +VB2_TRACE_EVENT(vb2_dqbuf);
> +VB2_TRACE_EVENT(vb2_qbuf);

DEFINE_EVENT(vb2_event_class, vb2_buf_done, ...)
[..]

-- Steve

> +
>  #endif /* if !defined(_TRACE_V4L2_H) || defined(TRACE_HEADER_MULTI_READ) */
>  
>  /* This part must be outside protection */

