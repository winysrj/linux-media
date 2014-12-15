Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:47459 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbaLOU36 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Dec 2014 15:29:58 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi
Subject: [PATCH 0/3] yavta: Compound control support
Date: Mon, 15 Dec 2014 22:29:53 +0200
Message-Id: <1418675396-12485-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This patch set implements compound control get and set support for yavta. Only
the integer types are currently supported.

I'm not sure to be happy with the way compound control values are printed. I'm
open to suggestions (or better, patches ;-)) on how to improve this.

Laurent Pinchart (3):
  Implement VIDIOC_QUERY_EXT_CTRL support
  Implement compound control get support
  Implement compound control set support

 yavta.c | 414 +++++++++++++++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 316 insertions(+), 98 deletions(-)

-- 
Regards,

Laurent Pinchart

