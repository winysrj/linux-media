Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:2443 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213Ab3GHLH5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Jul 2013 07:07:57 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [BRAINSTORM] Controls, matrices and properties
Date: Mon, 8 Jul 2013 13:06:56 +0200
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201307081306.56324.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I have been working on support for passing matrices to/from drivers using a
new matrix API. See this earlier thread for more background information:

http://comments.gmane.org/gmane.linux.drivers.video-input-infrastructure/66200

The basic feedback is that, yes, matrices are useful, but it is yet another
control-like API.

My problem with using the control API for things like this is that the control
API has been designed for use with GUIs: e.g. the controls are elements that
the end-user can modify through a GUI. Things like a matrix or some really
low-level driver property are either hard to model in a GUI or too advanced
and obscure for an end-user.

On the other hand, the control framework has all the desirable properties that
you would want: atomicity (as far as is allowed by the hardware), the ability
to get/set multiple controls in one ioctl, efficient, inheritance of subdev
controls in bridge devices, events, etc.

I'm wondering whether we cannot tweak the control API a bit to make it possible
to use it for matrices and general 'properties' as well. The main requirement
for me is that when applications enumerate over controls such properties should
never turn up in the enumerations: only controls suitable for a GUI should
appear. After all, an application would have no idea what to do with a matrix
of e.g. 200x300 elements.

While it is possible to extend queryctrl to e.g. enumerate only properties
instead of controls, it is probably better to create a new VIDIOC_QUERYPROP
ioctl. Also because the v4l2_queryctrl is pretty full and has no support to set
the minimum/maximum values of a 64 bit value. In addition, the name field is not
needed for a property, I think. Currently the name is there for the GUI, not
for identification purposes.

For setting/getting controls the existing extended control API can be used,
although I would be inclined to go for VIDIOC_G/S/TRY_PROPS ioctls as well.
For example, when I set a matrix property it is very desirable to pass only
a subset of the matrix along instead of a full matrix. In my original matrix
proposal I had a v4l2_rect struct that defined that. But there is no space
in struct v4l2_ext_control to store such information.

In general, implementing properties requires more variation since the GUI
restriction has been lifted. Also, properties can be assigned to specific
internal objects (e.g. buffer specific properties), so you need fields to
tell the kernel with which object the property is associated.

However, although the public API is different from the control API, there
is no reason not to use the internal control framework for both.

Internally controls and properties work pretty much the same way and can all
be handled by the control framework. Only supporting e.g. per-buffer controls
would take work since that is currently not implemented.

At the moment this is just an idea and I don't want to spend time on creating
a detailed RFC if people don't like it. So comments are welcome!

Regards,

	Hans
