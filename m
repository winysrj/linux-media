Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:3260 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647Ab0C1KYD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Mar 2010 06:24:03 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: What would be a good time to move subdev drivers to a subdev directory?
Date: Sun, 28 Mar 2010 12:24:17 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201003281224.17678.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Currently drivers/media/video is a mix of subdev drivers and bridge/platform
drivers. I think it would be good to create a drivers/media/subdev directory
where subdev drivers can go.

We discussed in the past whether we should have categories for audio subdevs,
video subdevs, etc. but I think that will cause problems, especially with
future multifunction devices.

What is your opinion on this, and what would be a good time to start moving
drivers?

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
