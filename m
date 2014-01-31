Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:3563 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbaAaJ44 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Jan 2014 04:56:56 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, laurent.pinchart@ideasonboard.com,
	s.nawrocki@samsung.com, ismael.luceno@corp.bluecherry.net,
	Pete Eberlein <pete@sensoray.com>
Subject: [REVIEW PATCH 00/32] Add support for complex controls, use in solo/go7007
Date: Fri, 31 Jan 2014 10:55:58 +0100
Message-Id: <1391162190-8620-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series adds support for complex controls (aka 'Properties') to
the control framework and uses them in the go7007 and solo6x10 drivers.
It is the first part of a larger patch series that adds support for configuration
stores and support for 'Multiple Selections'.

This patch series is based on this RFCv3:

http://lwn.net/Articles/582694/

Changes since RFCv3 are:

- added patches 23-32 that add the Detection Control Class and implement motion
  detection in the go7007 and solo6x10 staging drivers. Once this is in these
  drivers can be moved to drivers/media.

These Detection patches are essentially identical to the original patches:
http://lwn.net/Articles/564835/

The only change is that I am using the new matrix controls instead of introducing
new matrix ioctls.

If there are no more objections, then I am going to make a pull request for this
in two weeks time.

Regards,

	Hans

