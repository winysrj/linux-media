Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52756 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753538AbcEPKCT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 May 2016 06:02:19 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: sakari.ailus@iki.fi
Cc: linux-media@vger.kernel.org
Subject: [PATCH 0/4] yavta: Implement compound controls support
Date: Mon, 16 May 2016 13:02:08 +0300
Message-Id: <1463392932-28307-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This series implements compound controls support for yavta. The support is
currently limited to (multidimensional) arrays of integer types, and will be
extended later as needed.

One point worth noting is patch 4/4 that adds support for setting a control to
a value stored in a file. This is particularly useful for large array controls
as specifying the control value on the command line would be cumbersome.

Laurent Pinchart (4):
  Implement VIDIOC_QUERY_EXT_CTRL support
  Implement compound control get support
  Implement compound control set support
  Support setting control from values stored in a file

 yavta.c | 438 +++++++++++++++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 340 insertions(+), 98 deletions(-)

-- 
Regards,

Laurent Pinchart

