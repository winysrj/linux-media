Return-path: <mchehab@pedra>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:3549 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932540Ab1EYNeN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 May 2011 09:34:13 -0400
Received: from tschai (64-103-25-233.cisco.com [64.103.25.233])
	(authenticated bits=0)
	by smtp-vbr5.xs4all.nl (8.13.8/8.13.8) with ESMTP id p4PDYARU007307
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Wed, 25 May 2011 15:34:11 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [RFCv2 PATCH 00/11] Control Event
Date: Wed, 25 May 2011 15:33:44 +0200
Message-Id: <1306330435-11799-1-git-send-email-hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This is the second version of the patch series introducing a new event that
is triggered when a control's value or state changes.

It incorporates the comments made since version 1.

Most of these patches are relatively minor infrastructure changes. The real
work is done in patch 7.

This patch series builds on the bitmask patch series.

The main changes since version 1 are:

- The patches that add the bitmask control type are split off since these
  are needed sooner than the control events and they are indepedent of one
  another.

- Instead of having separate CTRL_CH_VALUE and CTRL_CH_STATE events, there
  is now just one V4L2_EVENT_CTRL event which has a bitmask telling what was
  changed since the last event. In addition, the event payload gives all the
  relevant control data (type, value, min, max, step, def, flags). This greatly
  simplifies the applications that need to use this as it prevents having
  to do additional calls to VIDIOC_G_CTRL or VIDIOC_QUERYCTRL.

- If you call VIDIOC_S_CTRL or VIDIOC_S_EXT_CTRLS, then the filehandle passed
  to the ioctl function will be skipped when the events for the new value
  are generated. This prevents nasty feedback loops.

- Documentation was added.

The vivi driver has been updated to support control events.

The qv4l2 application has also been updated to test control events.
You can find it here:

http://git.linuxtv.org/hverkuil/v4l-utils.git?a=shortlog;h=refs/heads/core

Please review! I'd like to get this in for 2.6.41.

Still on my TODO list (will be done as separate patch series):

- Change the way volatile controls are handled.

- Add autofoo/foo support.

- Make it possible to update control values from interrupt context. This will
  only be possible for a certain subset of controls.

- I need to figure out how to handle the case where there are two inputs, each
  with its own subdev and set of controls. Switching inputs would imply switching
  controls as well. I've tried several things, but it's all very awkward.

Regards,

	Hans

