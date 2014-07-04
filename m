Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:59185 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756569AbaGDKiJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Jul 2014 06:38:09 -0400
Message-ID: <53B6840A.20102@xs4all.nl>
Date: Fri, 04 Jul 2014 12:38:02 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Divneil Wadhawan <divneil@outlook.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: No audio support in struct v4l2_subdev_format
References: <BAY176-W7B3F24A204E68896226E0A9000@phx.gbl>,<53B65DCA.6010803@xs4all.nl> <BAY176-W23C9AA5FB70F17EDEB68F8A9000@phx.gbl>,<53B679C2.7030002@xs4all.nl> <BAY176-W32B9E16B0436D20DF363BEA9000@phx.gbl>
In-Reply-To: <BAY176-W32B9E16B0436D20DF363BEA9000@phx.gbl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Divneil,

On 07/04/2014 12:24 PM, Divneil Wadhawan wrote:
> 
> 
> Hi Hans,
> 
> 
>> I don't understand the problem. When the application starts the first thing it should
>> do is to call VIDIOC_QUERY_DV_TIMINGS: that will tell it if any signal is present.
> 
> I guess dv timings will be valid for DVI too. If yes, then there is no audio.
> 
> There's no video device for this, just subdev.
> 
> 
> 
>> An alternative might be to extend v4l2_src_change_event_subscribe() and have it honor
>> the V4L2_EVENT_SUB_FL_SEND_INITIAL flag: if set, it should issue this event at once.
>> That might actually be a nice improvement.
> 
> Okay, if it gives the already fired event, then it's good.

It should generate an initial SOURCE_CHANGE event with 'changes' set to
V4L2_EVENT_SRC_CH_RESOLUTION. That way the application that just subscribed to this
event with V4L2_EVENT_SUB_FL_SEND_INITIAL will get an initial event.

> 
> 
> There is one concern for this v4l2_src_change_event_subscribe().
> 
> I was using v4l2_subscribed_event_ops for storing the "struct v4l2_subscribed_event sev."
> 
> 
> Later take out from list so, that I can call v4l2_event_queue() from the async event handler.
> 
> 
> I didn't had to worry for addition/deletion of "sev" from my list as this was managed by event framework calling these ops.
> 
> So, now with v4l2_src_change_event_subscribe(), I cannot use the ops, and I have to manage "fh" using list.
> 
> This addition deletion must now be handled by me, and cannot be taken care by v4l2_event_subdev_unsubscribe().

I hate to say this, but I have no idea what you mean. Can you show some code?

> 
> I hope I have not missed any trivial stuff ;)
> 
> 
> 
>> But what has that to do with audio?
> 
> For video, we have VIDIOC_SUBDEV_G_FMT, for audio, there's nothing.

But shouldn't that be handled by an alsa driver? That's what someone has to
figure out: what goes in alsa and what still has to be provided by V4L2. For HDMI
output in e.g. an nvidia card the audio is fully handled by alsa AFAIK.

Obviously the hdmi driver has to work together with the alsa driver since it has
to exchange the audio infoframe information, but that's internal to the kernel.

To my knowledge nobody has really worked on this.

Regards,

	Hans
