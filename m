Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:29395 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683Ab3GYJDS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Jul 2013 05:03:18 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: UVC and V4L2_CAP_AUDIO
Date: Thu, 25 Jul 2013 11:03:13 +0200
Cc: =?iso-8859-1?q?B=E5rd_Eirik_Winther?= <bwinther@cisco.com>,
	"linux-media" <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201307251103.13456.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

While working on adding alsa streaming support to qv4l2 we noticed that uvc
doesn't set this capability telling userspace that the webcam supports audio.

Is it possible at all in the uvc driver to determine whether or not a uvc
webcam has a microphone?

If not, then it looks like the only way to find the associated alsa device
is to use libmedia_dev (or its replacement, although I wonder if anyone is
still working on that).

And in particular, the presence of CAP_AUDIO cannot be used to determine
whether the device has audio capabilities, it can only be used to determine
if the V4L2 audio ioctls are supported. That would have to be clarified in
the spec.

Regards,

	Hans
