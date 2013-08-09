Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:51426 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966169Ab3HIMKi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Aug 2013 08:10:38 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 0/2] Fix AB-BA deadlock in vb2_prepare_buffer()
Date: Fri,  9 Aug 2013 14:11:24 +0200
Message-Id: <1376050286-8201-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This patch set fixes a deadlock in the vb2_prepare_buffer() function. See the
commit message of patch 1/2 for more information. Patch 2/2 then proceeds to
refactor vb2_prepare_buffer() and vb2_qbuf() to avoid code duplication.

Laurent Pinchart (2):
  media: vb2: Fix potential deadlock in vb2_prepare_buffer
  media: vb2: Share code between vb2_prepare_buf and vb2_qbuf

 drivers/media/v4l2-core/videobuf2-core.c | 212 +++++++++++++++----------------
 1 file changed, 101 insertions(+), 111 deletions(-)

-- 
Regards,

Laurent Pinchart

