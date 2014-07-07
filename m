Return-path: <linux-media-owner@vger.kernel.org>
Received: from bay004-omc2s23.hotmail.com ([65.54.190.98]:49985 "EHLO
	BAY004-OMC2S23.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751149AbaGGE7x convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Jul 2014 00:59:53 -0400
Message-ID: <BAY176-W46A88AA74FC1924DEFE69FA90D0@phx.gbl>
From: Divneil Wadhawan <divneil@outlook.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: RE: No audio support in struct v4l2_subdev_format
Date: Mon, 7 Jul 2014 10:29:53 +0530
In-Reply-To: <53B7BA57.1010003@xs4all.nl>
References: <BAY176-W7B3F24A204E68896226E0A9000@phx.gbl>,<53B65DCA.6010803@xs4all.nl>
 <BAY176-W23C9AA5FB70F17EDEB68F8A9000@phx.gbl>,<53B679C2.7030002@xs4all.nl>
 <BAY176-W32B9E16B0436D20DF363BEA9000@phx.gbl>,<53B6840A.20102@xs4all.nl>
 <BAY176-W264D5BED6FA556ABDE0763A9000@phx.gbl>,<53B7BA57.1010003@xs4all.nl>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,


> int my_subdev_subscribe_event(struct v4l2_subdev *sd, struct v4l2_fh *fh,
> struct v4l2_event_subscription *sub)
> {
> switch (sub->type) {
> case V4L2_EVENT_CTRL:
> return v4l2_ctrl_subdev_subscribe_event(sd, fh, sub);
> case V4L2_EVENT_SOURCE_CHANGE:
> return v4l2_src_change_event_subdev_subscribe(sd, fh, sub);
> ...
> default:
> return -EINVAL;
> }
The state machine is already ON, whether the user does a subdev open or not.

So, the events are generated anyways.

I guess it's not too weird as the v4l2_event_queue_fh() requires fh, and it seems okay to get hold off fh by using these ops.


Regards,

Divneil 		 	   		  