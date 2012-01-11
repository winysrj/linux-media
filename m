Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:45771 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756909Ab2AKKoI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jan 2012 05:44:08 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Rupert Eibauer <Rupert.Eibauer@ces.ch>
Subject: Re: V4L spec possibly broken
Date: Wed, 11 Jan 2012 11:44:03 +0100
Cc: linux-media@vger.kernel.org
References: <OFC0C35484.6D81A1B1-ONC1257982.003765AA-C1257982.003771F1@ces.ch>
In-Reply-To: <OFC0C35484.6D81A1B1-ONC1257982.003765AA-C1257982.003771F1@ces.ch>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201111144.03446.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 11 January 2012 11:05:36 Rupert Eibauer wrote:
> Hello,
> 
> I am working on the linux driver for our new video capture board and
> facing some compatibility problem which seems to be related to unclear
> language in the V4L specification.
> 
> The device supports a larger number of inputs, but with a different set of
> standards on each of them.
> 
> Now, the problem is that ffmpeg is using VIDIOC_ENUMSTD/VIDIOC_S_STD
> before VIDIOC_S_INPUT.
> So the driver has to give a list of supported standards before knowing
> which input the device will be taking.
> 
> Currently I am experimenting with a workaround to remember the set
> standard and then failing
> on VIDIOC_S_INPUT when not compatible, but this seems to create more
> problems than it solves. I have
> the feeling that this behaviour is not covered by the specification, and
> it makes the driver unnecesarily complex.
> 
> In my opinion, the standard is broken: on page
> http://v4l2spec.bytesex.org/spec/r11217.htm, it says:
> "It is good practice to select an input before querying or negotiating any
> other parameters."
> It should be changed to "Aplications must...", and ffmpeg needs fixing to
> call VIDIOC_S_INPUT before VIDIOC_ENUMSTD.
> 
> I hope to get some opinion from you, if this is the right approach or not.

You are correct, it should be 'must' rather than 'good practice'.

I've made a patch that updates the text accordingly. I'll post it soon 
together with some other spec updates.

Regards,

	Hans

> 
> Best regards,
> Rupert Eibauer
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
