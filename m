Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2163 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932146AbaAaLMQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Jan 2014 06:12:16 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: detlev.casanova@gmail.com, laurent.pinchart@ideasonboard.com
Subject: [RFC PATCH 0/2] Allow inheritance of private controls
Date: Fri, 31 Jan 2014 12:12:04 +0100
Message-Id: <1391166726-27026-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Devices with a simple video pipeline may want to inherit private controls
of sub-devices and expose them to the video node instead of v4l-subdev
nodes (which may be inhibit anyway by the driver).

Add support for this.

A typical real-life example of this is a PCI capture card with just a single
video receiver sub-device. Creating v4l-subdev nodes for this is overkill
since it is clear which control belongs to which subdev.

Regards,

	Hans

