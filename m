Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:32983 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752773AbbGBMBk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Jul 2015 08:01:40 -0400
Message-ID: <559527D7.1030408@xs4all.nl>
Date: Thu, 02 Jul 2015 14:00:23 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
CC: Bjornar Salberg <bsalberg@cisco.com>
Subject: [RFC] How to get current position/status of iris/focus/pan/tilt/zoom?
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When using V4L2_CID_IRIS/FOCUS/PAN/TILT/ZOOM_ABSOLUTE/RELATIVE, how do you know
when the new position has been reached? If this is controlled through a motor,
then it may take some time and ideally you would like to be able to get the
current absolute position (if the hardware knows) and whether the final position
has been reached or not.

In addition, it should be possible to raise fault conditions.

The way the ABSOLUTE controls are defined is ambiguous since it doesn't say
anything about what it returns when you read it: is that the current absolute
position, or the last set absolute position? I suspect it is the second one.

If it is the second one, then I propose a V4L2_CID_IRIS_CURRENT control (and
ditto for the other variants) that is a read-only control returning the current
position with the same range and unit as the ABSOLUTE control.

For the status/fault information I think the V4L2_CID_AUTO_FOCUS_STATUS comes
close, but it is too specific for auto focus. For manually positioning things
this might be more suitable:

V4L2_CID_IRIS_STATUS	bitmask

	V4L2_IRIS_STATUS_MOVING (or perhaps _BUSY?)
	V4L2_IRIS_STATUS_FAILED

And ditto for the other variants.

Interaction between V4L2_CID_FOCUS_STATUS and AUTO_FOCUS_STATUS:

If auto focus is enabled, then FOCUS_STATUS is always 0, if auto focus is
disabled, then AUTO_FOCUS_STATUS is always IDLE.

Comments? Ideas?

Regards,

	Hans
