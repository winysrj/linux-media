Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:41324 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752206AbbCXLsr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Mar 2015 07:48:47 -0400
Message-ID: <55114F17.9040206@xs4all.nl>
Date: Tue, 24 Mar 2015 04:48:39 -0700
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Divneil Rai WADHAWAN <divneil.wadhawan@st.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "divneil@outlook.com" <divneil@outlook.com>
Subject: Re: Subdev notification for video device
References: <C17522D12DF21D4F9DC8833224F23A8705F96EEB@EAPEX1MAIL1.st.com>
In-Reply-To: <C17522D12DF21D4F9DC8833224F23A8705F96EEB@EAPEX1MAIL1.st.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/24/2015 12:49 AM, Divneil Rai WADHAWAN wrote:
> Hello,
> 
> I have a use case, where, I am using subdev configuration to setup video capture.
> The pipeline is something like this:
> 
> Subdevs: sd_display, sd_capture
> Vdev: vcapture
> 
>  (0)sd_display(1) -> (0)sd_capture(1)->(0)vcapture
> 
> sd_display informs sd_capture of video resolution change and vdev using sd_capture needs to be informed, so, that vdev capture can be stopped.
> 
> Here, subdev notification/subscription is missing to/from vdev, in my understanding.
> subdev can send notification to v4l2-dev, but not vdev.
> Can you help with that? Thanks.

This is correct. The subdev doesn't and cannot know anything about which video node(s)
need(s) to send out a source change event. The only driver that can is the top-level driver
that knows the topology and can map the event from the sd to the correct video_device.

If your driver uses the media controller, then it should be possible to write a generic
function that would use the topology to discover automatically which video_device nodes
are linked to the sd and propagate the event to those video devices.

Such a generic v4l2_dev notify function doesn't exist today though. Patches are welcome.

If the driver doesn't use the media controller, then the top-level driver should provide
this knowledge in its v4l2_dev notifier function.

Regards,

	Hans
