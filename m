Return-path: <linux-media-owner@vger.kernel.org>
Received: from bay004-omc2s7.hotmail.com ([65.54.190.82]:64259 "EHLO
	BAY004-OMC2S7.hotmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409AbaGDLiE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Jul 2014 07:38:04 -0400
Message-ID: <BAY176-W264D5BED6FA556ABDE0763A9000@phx.gbl>
From: Divneil Wadhawan <divneil@outlook.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: RE: No audio support in struct v4l2_subdev_format
Date: Fri, 4 Jul 2014 17:08:03 +0530
In-Reply-To: <53B6840A.20102@xs4all.nl>
References: <BAY176-W7B3F24A204E68896226E0A9000@phx.gbl>,<53B65DCA.6010803@xs4all.nl>
 <BAY176-W23C9AA5FB70F17EDEB68F8A9000@phx.gbl>,<53B679C2.7030002@xs4all.nl>
 <BAY176-W32B9E16B0436D20DF363BEA9000@phx.gbl>,<53B6840A.20102@xs4all.nl>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,



> It should generate an initial SOURCE_CHANGE event with 'changes' set to
> V4L2_EVENT_SRC_CH_RESOLUTION. That way the application that just subscribed to this
> event with V4L2_EVENT_SUB_FL_SEND_INITIAL will get an initial event.

Just checked in 3.10 which I am using, this is for the control events.

So, I will check in detail and in case fits our case, will reuse the part in my code.


> I hate to say this, but I have no idea what you mean. Can you show some code?


static int hdmirx_evt_add(struct v4l2_subscribed_event *sev, unsigned elems)
{
        struct v4l2_fh *fh = sev->fh;
        struct v4l2_subdev *sd = vdev_to_v4l2_subdev(fh->vdev);
        struct hdmirx_ctx_s *hdmirx_ctx = v4l2_get_subdevdata(sd);


        .......


        list_add_tail(&sev->node, &hdmirx_ctx->subs_list);


        ........


        return 0;
}


static void hdmirx_evt_del(struct v4l2_subscribed_event *sev)
{
        struct v4l2_fh *fh = sev->fh;
        struct v4l2_subdev *sd = vdev_to_v4l2_subdev(fh->vdev);
        struct hdmirx_ctx_s *hdmirx_ctx = v4l2_get_subdevdata(sd);



        .............


        list_del(&sev->node);


        ..........

}



struct v4l2_subscribed_event_ops hdmirx_event_ops = {
        .add = hdmirx_status_evt_add,
        .del = hdmirx_status_evt_del,
        .replace = v4l2_ctrl_replace,
        .merge = v4l2_ctrl_merge,
};



hdmi_core_subscribe_event()

{



 ret = v4l2_event_subscribe(fh, sub,
                     HDMIRX_EVENT_QUEUE_DEPTH, &hdmirx_event_ops);


}


static const struct v4l2_subdev_core_ops hdmirx_subdev_core_ops = {
        .ioctl =  xxx
        .subscribe_event = hdmirx_core_subscribe_event,

...

}


v4l2_event_subscribe() takes the 4th arg as the event_ops. ctrl and source_change events are not allowing 

to override ops. It can be like:

int v4l2_ctrl_subdev_subscribe_event(struct v4l2_subdev *sd, struct v4l2_fh *fh,
                                     struct v4l2_event_subscription *sub, xxx )

{

    if (!xxx)

         default ops as open source


}



> But shouldn't that be handled by an alsa driver? That's what someone has to
> figure out: what goes in alsa and what still has to be provided by V4L2. For HDMI
> output in e.g. an nvidia card the audio is fully handled by alsa AFAIK.

Okay, I will come back on this later.

Let's see if I can do something better with the event handling.


Regards,

Divneil 		 	   		  