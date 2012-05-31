Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:2884 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754340Ab2EaJWv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 May 2012 05:22:51 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: marbugge@cisco.com, Soby Mathew <soby.mathew@st.com>,
	mats.randgaard@cisco.com, manjunath.hadli@ti.com,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>
Subject: [RFCv1 PATCH 0/3] Add missing DVI-A/D/I and HDMI/DisplayPort connector support
Date: Thu, 31 May 2012 11:22:41 +0200
Message-Id: <1338456164-25080-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

This patch series implements this RFC: http://www.spinics.net/lists/linux-media/msg47671.html

The changes since that RFC are:

- Added a start_block to struct v4l2_subdev_edid: this allows you to get specific EDID blocks
  instead of all blocks from the beginning. This field must be 0 when setting the EDID.

- If 'blocks' is 0 when S_EDID is called, then that means that the EDID should be disabled.
  This will effectively pull the hotplug pin down. BTW, setting a new EDID will always pull
  the hotplug pin down, write the new EDID, and pull it high again as per the spec. Being
  able to disable the EDID allows you to test without an EDID present, but it is also
  needed if you want to do some creative EDID juggling. For example, the adv7842 allows you
  to either have up to 4 blocks of digital EDID or have two blocks analog and two blocks
  digital EDID. Should you want to switch between those modes, then you need to be able
  to disable an EDID so that you can reconfigure the mode.

- The term 'port' has been replaced with the more generic term 'pad' and refers to a subdev
  pad. The idea is that an HDMI receiver will have a number of input pads where each pad
  corresponds to a HDMI connector. What looks a bit odd at the moment is that there is nothing
  too connect to those pads in the media controller because we do not have connector entities.
  Connector entities are needed for ALSA and DRM as well, so once this is in and several of
  our drivers that will use this, then I will look into adding support for those entities as
  well. It's not my highest priority at the moment, though.

This set of controls and ioctls is sufficient for us (Cisco Systems Norway) to support
our hardware and to be able to upstream the two receivers and two transmitters that
we use. Note that CEC support is left out as well, that too will be revisited once we
can get our code upstream.

Comments are welcome!

Regards,

	Hans

