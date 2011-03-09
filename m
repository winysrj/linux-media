Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:53082 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318Ab1CIV1A (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Mar 2011 16:27:00 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, jaeryul.oh@samsung.com
Subject: [PATCH/RFC 0/2] Support controls at the subdev file handler level
Date: Wed,  9 Mar 2011 22:27:19 +0100
Message-Id: <1299706041-21589-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi everybody,

Here's a patch set that adds support for per-file-handle controls on V4L2
subdevs. The patches are work in progress, but I'm still sending them as
Samsung expressed interest in a similar feature on V4L2 device nodes.

Laurent Pinchart (2):
  v4l: subdev: Move file handle support to drivers
  v4l: subdev: Add support for file handler control handler

 drivers/media/video/v4l2-subdev.c |  144 +++++++++++++++++++-----------------
 include/media/v4l2-subdev.h       |   10 ++-
 2 files changed, 84 insertions(+), 70 deletions(-)

-- 
Regards,

Laurent Pinchart

