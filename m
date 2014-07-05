Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:44964 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754424AbaGEImI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 5 Jul 2014 04:42:08 -0400
Message-ID: <53B7BA57.1010003@xs4all.nl>
Date: Sat, 05 Jul 2014 10:41:59 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Divneil Wadhawan <divneil@outlook.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: No audio support in struct v4l2_subdev_format
References: <BAY176-W7B3F24A204E68896226E0A9000@phx.gbl>,<53B65DCA.6010803@xs4all.nl> <BAY176-W23C9AA5FB70F17EDEB68F8A9000@phx.gbl>,<53B679C2.7030002@xs4all.nl> <BAY176-W32B9E16B0436D20DF363BEA9000@phx.gbl>,<53B6840A.20102@xs4all.nl> <BAY176-W264D5BED6FA556ABDE0763A9000@phx.gbl>
In-Reply-To: <BAY176-W264D5BED6FA556ABDE0763A9000@phx.gbl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/04/2014 01:38 PM, Divneil Wadhawan wrote:
> Hi Hans,
> 
> 
> 
>> It should generate an initial SOURCE_CHANGE event with 'changes' set to
>> V4L2_EVENT_SRC_CH_RESOLUTION. That way the application that just subscribed to this
>> event with V4L2_EVENT_SUB_FL_SEND_INITIAL will get an initial event.
> 
> Just checked in 3.10 which I am using, this is for the control events.
> 
> So, I will check in detail and in case fits our case, will reuse the part in my code.
> 
> 
>> I hate to say this, but I have no idea what you mean. Can you show some code?
> 
> 
> static int hdmirx_evt_add(struct v4l2_subscribed_event *sev, unsigned elems)
> {
>         struct v4l2_fh *fh = sev->fh;
>         struct v4l2_subdev *sd = vdev_to_v4l2_subdev(fh->vdev);
>         struct hdmirx_ctx_s *hdmirx_ctx = v4l2_get_subdevdata(sd);
> 
> 
>         .......
> 
> 
>         list_add_tail(&sev->node, &hdmirx_ctx->subs_list);
> 
> 
>         ........
> 
> 
>         return 0;
> }
> 
> 
> static void hdmirx_evt_del(struct v4l2_subscribed_event *sev)
> {
>         struct v4l2_fh *fh = sev->fh;
>         struct v4l2_subdev *sd = vdev_to_v4l2_subdev(fh->vdev);
>         struct hdmirx_ctx_s *hdmirx_ctx = v4l2_get_subdevdata(sd);
> 
> 
> 
>         .............
> 
> 
>         list_del(&sev->node);
> 
> 
>         ..........
> 
> }
> 
> 
> 
> struct v4l2_subscribed_event_ops hdmirx_event_ops = {
>         .add = hdmirx_status_evt_add,
>         .del = hdmirx_status_evt_del,
>         .replace = v4l2_ctrl_replace,
>         .merge = v4l2_ctrl_merge,
> };
> 
> 
> 
> hdmi_core_subscribe_event()
> 
> {
> 
> 
> 
>  ret = v4l2_event_subscribe(fh, sub,
>                      HDMIRX_EVENT_QUEUE_DEPTH, &hdmirx_event_ops);
> 
> 
> }
> 
> 
> static const struct v4l2_subdev_core_ops hdmirx_subdev_core_ops = {
>         .ioctl =  xxx
>         .subscribe_event = hdmirx_core_subscribe_event,
> 
> ...
> 
> }

Very weird code. If you want to support events all you have to do is this:

int my_subdev_subscribe_event(struct v4l2_subdev *sd, struct v4l2_fh *fh,
                                     struct v4l2_event_subscription *sub)
{
	switch (sub->type) {
	case V4L2_EVENT_CTRL:
		return v4l2_ctrl_subdev_subscribe_event(sd, fh, sub);
	case V4L2_EVENT_SOURCE_CHANGE:
		return v4l2_src_change_event_subdev_subscribe(sd, fh, sub);
	...
	default:
		return -EINVAL;
	}
}

Since your QUEUE_DEPTH event is custom and I have no idea what it does, I also
can't say if you really need event_ops, but it seems very peculiar. It is almost
certainly wrong what you are doing.

Regards,

	Hans

> 
> 
> v4l2_event_subscribe() takes the 4th arg as the event_ops. ctrl and source_change events are not allowing 
> 
> to override ops. It can be like:
> 
> int v4l2_ctrl_subdev_subscribe_event(struct v4l2_subdev *sd, struct v4l2_fh *fh,
>                                      struct v4l2_event_subscription *sub, xxx )
> 
> {
> 
>     if (!xxx)
> 
>          default ops as open source
> 
> 
> }
> 
> 
> 
>> But shouldn't that be handled by an alsa driver? That's what someone has to
>> figure out: what goes in alsa and what still has to be provided by V4L2. For HDMI
>> output in e.g. an nvidia card the audio is fully handled by alsa AFAIK.
> 
> Okay, I will come back on this later.
> 
> Let's see if I can do something better with the event handling.
> 
> 
> Regards,
> 
> Divneil 		 	   		  --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

