Return-path: <mchehab@gaivota>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:9852 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007Ab0L0Gpg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Dec 2010 01:45:36 -0500
From: "Shuzhen Wang" <shuzhenw@codeaurora.org>
To: "'Hans Verkuil'" <hverkuil@xs4all.nl>
Cc: <linux-media@vger.kernel.org>, <hzhong@codeaurora.org>,
	<yyan@codeaurora.org>
References: <000601cba2d8$eaedcdc0$c0c96940$@org> <201012241219.31754.hverkuil@xs4all.nl>
In-Reply-To: <201012241219.31754.hverkuil@xs4all.nl>
Subject: RE: RFC: V4L2 driver for Qualcomm MSM camera.
Date: Sun, 26 Dec 2010 22:45:01 -0800
Message-ID: <000f01cba591$95fda4a0$c1f8ede0$@org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Content-Language: en-us
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hello, Hans,

Thank you very much for the comments!

I don't have answers to all of your comments, but will reply as much as I
can.
Since a lot of folks are on break here, we will have feedbacks for the other
ones 
after the holiday.


> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Hans Verkuil
> 
> Does config control the sensor or the main msm subsystem? Or both?
> 

It controls both. 

> Just to repeat what I have discussed with Qualcomm before (so that
> everyone knows):
> I have no problem with proprietary code as long as:
> 
> 1) the hardware and driver APIs are clearly documented allowing someone
> else to
> make their own algorithms.
>

Yes, we will have the APIs clearly documented for the hardware and driver. 
 
> 2) the initial state of the hardware as set up by the driver is good
> enough to
> capture video in normal lighting conditions. In other words: the daemon
> should not
> be needed for testing the driver. I compare this with cheap webcams
> that often
> need software white balancing to get a decent picture. They still work
> without
> that, but the picture simply doesn't look very good.
> 

I agree that it's a very good idea to be able to run the driver without
daemon.
Our challenge is that we have all the hardware pipeline configuration in the
daemon. The driver doesn't know how to configure the pipeline as a whole
based on
user specification, it only cares about the configuration of each individual
component. 

> We also discussed the daemon in the past. The idea was that it should
> be called
> from libv4l2. Is this still the plan?
>

[to be commented on later]

> Take a look at the new core-assisted locking scheme implemented for
> 2.6.37.
> This might simplify your driver. Just FYI.
> 

We will take a look at this.

> Laurent Pinchart has a patch series adding support for device nodes for
> sub-devices. The only reason that series isn't merged yet is that there
> are
> no merged drivers that need it. You should use those patches to
> implement
> these ioctls in sub-devices. I guess you probably want to create a
> subdev
> for the VFE hardware. The SENSOR_INFO ioctl seems like something that
> can
> be implemented using the upcoming media controller framework.
> 
> My guess is that these ioctls will need some work.
> 
> 
> It's more likely that the private ioctls will go through subdev device
> nodes.
> 
> That's really what they were designed for.
> 

Agreed. We will make the sensor and VFE hardware related calls go through 
subdebv device nodes.


Thanks,
Shuzhen

--
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
--

