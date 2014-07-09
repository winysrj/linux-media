Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:52813 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751032AbaGIL0z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Jul 2014 07:26:55 -0400
Message-ID: <53BD26EE.8030207@xs4all.nl>
Date: Wed, 09 Jul 2014 13:26:38 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Divneil Wadhawan <divneil@outlook.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: No audio support in struct v4l2_subdev_format
References: <BAY176-W7B3F24A204E68896226E0A9000@phx.gbl>,<53B65DCA.6010803@xs4all.nl>,<BAY176-W23C9AA5FB70F17EDEB68F8A9000@phx.gbl>,<53B679C2.7030002@xs4all.nl>,<BAY176-W32B9E16B0436D20DF363BEA9000@phx.gbl>,<53B6840A.20102@xs4all.nl>,<BAY176-W264D5BED6FA556ABDE0763A9000@phx.gbl>,<53B7BA57.1010003@xs4all.nl>,<BAY176-W46A88AA74FC1924DEFE69FA90D0@phx.gbl> <BAY176-W4659BEC4FE091329110E3AA90F0@phx.gbl>
In-Reply-To: <BAY176-W4659BEC4FE091329110E3AA90F0@phx.gbl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/09/2014 12:55 PM, Divneil Wadhawan wrote:
> Hi Hans,
> 
> 
> I agree that it was not a good implementation of using event.
> 
> (Please discard the exact code, as it is erroneous in managing ctrl events replace/merge and other ones)
> 
> 
> I restart with the concern.
> 
> Here, I have a v4l2 subdev, which can generate events from the time we load it.
> 
> We later found some use cases, where we would like the application to get the events too.
> 
> 
> v4l2_event_queue_fh() requires fh. 
> 
> I think, there's no way of gaining the access to this fh, except the SUBSCRIBE_EVENT or any calls landing on subdev before this.
> 
> The adding and deleting of fh in the list, is well managed by the event ops.
> 
> However, adding fh to the list is the tricky part, as I don't want to fill in the link list with the same fh over and over.

I still don't understand your problem. So the application wants to subscribe to an event,
it calls VIDIOC_SUBSCRIBE_EVENT and from that point onwards it will receive those events.

All the driver does is to call v4l2_event_subscribe (possibly through helper functions
like v4l2_src_change_event_subscribe).

You never have to touch filehandles yourself, that's all done in v4l2-event.c.

When your driver needs to raise the event it will typically call v4l2_event_queue() and
in rare cases v4l2_event_queue_fh() to send an event to a specific filehandle (primarily
used by m2m devices which have a per-filehandle state).

If you would like to have an initial event that is issued as soon as a filehandle subscribes
to an event, then the application has to set the V4L2_EVENT_SUB_FL_SEND_INITIAL flag and
that event also has to support that flag. It would make sense that v4l2_src_change_event_subscribe()
is extended to support that flag.

The bottom line is that you never have to touch filehandles or keep track of them.

Are you perhaps trying to receive events from a sub-device in a platform driver?
If that's the case, then let me know since that is not supported and it should
really be improved (I have some ideas about that). The only communication between
a subdev and the bridge driver is via the notify callback in v4l2_device.

Regards,

	Hans
