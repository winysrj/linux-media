Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:46392 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910AbcC3Ten (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Mar 2016 15:34:43 -0400
From: Helen Mae Koike Fornazier <helen.koike@collabora.co.uk>
To: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	sakari.ailus@iki.fi, hverkuil@xs4all.nl,
	sakari.ailus@linux.intel.com, mchehab@osg.samsung.com,
	hans.verkuil@cisco.com, s.nawrocki@samsung.com
Cc: Helen Mae Koike Fornazier <helen.koike@collabora.co.uk>
Subject: [PATCH v4 0/2] media: updating error codes on streamon
Date: Wed, 30 Mar 2016 16:34:28 -0300
Message-Id: <cover.1459365719.git.helen.koike@collabora.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix error code on streamon

Changes since v3:

	[media] media: change pipeline validation return error
		* Nothing has changed
	[media] DocBook: update error code in videoc-streamon
		* Added "link" word
		* Added Ack-by 

The patch set is based on 'media/master' branch and available at
        https://github.com/helen-fornazier/opw-staging media/devel

Helen Mae Koike Fornazier (2):
  [media] media: change pipeline validation return error
  [media] DocBook: update error code in videoc-streamon

 Documentation/DocBook/media/v4l/vidioc-streamon.xml | 8 ++++++++
 drivers/media/media-entity.c                        | 2 +-
 drivers/media/v4l2-core/v4l2-subdev.c               | 4 ++--
 3 files changed, 11 insertions(+), 3 deletions(-)

-- 
1.9.1

