Return-path: <linux-media-owner@vger.kernel.org>
Received: from bay004-omc2s20.hotmail.com ([65.54.190.95]:59393 "EHLO
	BAY004-OMC2S20.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752631AbaGDKYM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Jul 2014 06:24:12 -0400
Message-ID: <BAY176-W32B9E16B0436D20DF363BEA9000@phx.gbl>
From: Divneil Wadhawan <divneil@outlook.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: RE: No audio support in struct v4l2_subdev_format
Date: Fri, 4 Jul 2014 15:54:12 +0530
In-Reply-To: <53B679C2.7030002@xs4all.nl>
References: <BAY176-W7B3F24A204E68896226E0A9000@phx.gbl>,<53B65DCA.6010803@xs4all.nl>
 <BAY176-W23C9AA5FB70F17EDEB68F8A9000@phx.gbl>,<53B679C2.7030002@xs4all.nl>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Hi Hans,


> I don't understand the problem. When the application starts the first thing it should
> do is to call VIDIOC_QUERY_DV_TIMINGS: that will tell it if any signal is present.

I guess dv timings will be valid for DVI too. If yes, then there is no audio.

There's no video device for this, just subdev.



> An alternative might be to extend v4l2_src_change_event_subscribe() and have it honor
> the V4L2_EVENT_SUB_FL_SEND_INITIAL flag: if set, it should issue this event at once.
> That might actually be a nice improvement.

Okay, if it gives the already fired event, then it's good.


There is one concern for this v4l2_src_change_event_subscribe().

I was using v4l2_subscribed_event_ops for storing the "struct v4l2_subscribed_event sev."


Later take out from list so, that I can call v4l2_event_queue() from the async event handler.


I didn't had to worry for addition/deletion of "sev" from my list as this was managed by event framework calling these ops.

So, now with v4l2_src_change_event_subscribe(), I cannot use the ops, and I have to manage "fh" using list.

This addition deletion must now be handled by me, and cannot be taken care by v4l2_event_subdev_unsubscribe().

I hope I have not missed any trivial stuff ;)



> But what has that to do with audio?

For video, we have VIDIOC_SUBDEV_G_FMT, for audio, there's nothing.


Regards,

Divneil 		 	   		  