Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:50825 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbZJTORK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Oct 2009 10:17:10 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: Why doesn't video_ioctl2 reuse video_usercopy ?
Date: Tue, 20 Oct 2009 16:17:25 +0200
Cc: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200910201617.25206.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everybody,

while working on subdevs device node implementation noticed that video_ioctl2 
doesn't use video_usercopy but has its own (slightly modified) copy of the 
code. As I need to perform a similar operation for subdevs ioctls I was 
wondering if we could have a single video_usercopy implementation that could 
be used by both video_ioctl2 and the subdevs ioctl handler.

-- 
Regards,

Laurent Pinchart
