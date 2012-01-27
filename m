Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:2644 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957Ab2A0R7W (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Jan 2012 12:59:22 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Andy Walls <awalls@md.metrocast.net>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Steven Toth <stoth@kernellabs.com>
Subject: [PATCH 0/2] v4l2: standardize log start/end messages
Date: Fri, 27 Jan 2012 18:59:11 +0100
Message-Id: <1327687153-14757-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The output from VIDIOC_LOG_STATUS should be bracketed by a 'START STATUS' and
'END STATUS' line to clearly group the status report in the kernel log and to
make it possible for a tool like v4l2-ctl to easily find and show the status
output.

Often this was forgotten, so this is now done automatically as long as drivers
use the v4l2_device struct.

It was also added for the subdev nodes.

A new helper function was also added for drivers that just want to log the
current control values in the log.

Regards,

	Hans

