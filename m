Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:38425 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754220AbcBXVMR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Feb 2016 16:12:17 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH 0/2] Renesas VSP1: Fix DRM API header
Date: Wed, 24 Feb 2016 23:12:08 +0200
Message-Id: <1456348330-28928-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This series fixes the problem that commit 18922936dc28 ("[media] vsp1_drm.h:
add missing prototypes") tried to address. The functions has prototypes in a
different header file, to proper fix is to include that header instead of
duplicating prototypes.

Mauro, this series applies on top of the vsp1 branch, but doesn't have to be
merged into it as it's not a dependency for the DRM pull request I've sent.
I'll thus send you a normal pull request for this once the patches will be
reviewed.

Laurent Pinchart (2):
  v4l: vsp1: Fix vsp1_du_atomic_(begin|flush) declarations
  v4l: vsp1: drm: Include correct header file

 drivers/media/platform/vsp1/vsp1_drm.c |  2 +-
 drivers/media/platform/vsp1/vsp1_drm.h | 11 -----------
 include/media/vsp1.h                   |  4 ++--
 3 files changed, 3 insertions(+), 14 deletions(-)

-- 
Regards,

Laurent Pinchart

