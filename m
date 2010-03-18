Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:56470 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190Ab0CRMyo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Mar 2010 08:54:44 -0400
Received: from localhost.localdomain (unknown [192.100.124.156])
	by perceval.irobotique.be (Postfix) with ESMTPSA id 05324359F2
	for <linux-media@vger.kernel.org>; Thu, 18 Mar 2010 12:54:41 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH v2 0/2] Add iris absolute and relative control CIDs
Date: Thu, 18 Mar 2010 13:56:56 +0100
Message-Id: <1268917018-3458-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everybody,

Here's a second version of the iris control patch set that incorporates
comments from Sergio and Mauro (I modified the documentation to make the 
relationship between control values and iris opening clearer).

I can send a pull request for those patches after review.

Laurent Pinchart (2):
  v4l: Add V4L2_CID_IRIS_ABSOLUTE and V4L2_CID_IRIS_RELATIVE controls
  uvcvideo: Support iris absolute and relative controls

 Documentation/DocBook/v4l/compat.xml      |   11 +++++++++++
 Documentation/DocBook/v4l/controls.xml    |   19 +++++++++++++++++++
 Documentation/DocBook/v4l/videodev2.h.xml |    3 +++
 drivers/media/video/uvc/uvc_ctrl.c        |   20 ++++++++++++++++++++
 include/linux/videodev2.h                 |    3 +++
 5 files changed, 56 insertions(+), 0 deletions(-)

-- 
Regards,

Laurent Pinchart

