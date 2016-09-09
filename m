Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:58082 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752255AbcIIMSt (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Sep 2016 08:18:49 -0400
Received: from avalon.localnet (dfj612yywbrz---v8rgfy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:120b:a9ff:fe3c:7148])
        by galahad.ideasonboard.com (Postfix) with ESMTPSA id B44D620035
        for <linux-media@vger.kernel.org>; Fri,  9 Sep 2016 14:18:21 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.9] FCP and VSP1 changes
Date: Fri, 09 Sep 2016 15:19:24 +0300
Message-ID: <1967004.zoqjgcyvGJ@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This pull request supersedes the one sent on September the 5th under the title 
"[GIT PULL FOR v4.9] VSP1 changes". I've stripped the histogram-related 
patches that you would like to discuss, to only keep the non-controversial 
patches that are ready for v4.9, and added other FCP-related patches from my 
tree.

The following changes since commit 036bbb8213ecca49799217f30497dc0484178e53:

  [media] cobalt: update EDID (2016-09-06 16:46:39 -0300)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git vsp1/next

for you to fetch changes up to f4664c79de7314ab463490625c8a889510c7ea91:

  v4l: vsp1: Add R8A7792 VSP1V support (2016-09-09 14:57:35 +0300)

----------------------------------------------------------------
Kieran Bingham (3):
      dt-bindings: Update Renesas R-Car FCP DT bindings for FCPF
      dt-bindings: Document Renesas R-Car FCP power-domains usage
      v4l: rcar-fcp: Extend compatible list to support the FDP

Laurent Pinchart (5):
      v4l: ioctl: Clear the v4l2_pix_format_mplane reserved field
      v4l: rcar-fcp: Keep the coding style consistent
      v4l: rcar-fcp: Don't force users to check for disabled FCP support
      v4l: vsp1: Report device model and rev through media device information
      v4l: vsp1: Fix tri-planar format support through DRM API

Sergei Shtylyov (1):
      v4l: vsp1: Add R8A7792 VSP1V support

 Documentation/devicetree/bindings/media/renesas,fcp.txt |  9 +++++-
 drivers/media/platform/rcar-fcp.c                       |  9 +++---
 drivers/media/platform/vsp1/vsp1.h                      |  2 ++
 drivers/media/platform/vsp1/vsp1_drm.c                  |  6 ++--
 drivers/media/platform/vsp1/vsp1_drv.c                  | 43 ++++++++++++++--
 drivers/media/platform/vsp1/vsp1_regs.h                 |  2 ++
 drivers/media/v4l2-core/v4l2-ioctl.c                    |  8 ++---
 include/media/rcar-fcp.h                                |  2 +-
 include/media/vsp1.h                                    |  2 +-
-- 
Regards,

Laurent Pinchart

