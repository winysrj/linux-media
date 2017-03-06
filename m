Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:36859 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752685AbdCFSWb (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 6 Mar 2017 13:22:31 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Dave Airlie <airlied@redhat.com>
Subject: [GIT FIXES for 4.11] VSP + DU interface update
Date: Mon, 06 Mar 2017 20:22:32 +0200
Message-ID: <19090246.7pM2HLYyms@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

As discussed on IRC, here's a pull request for the VSP + DU patch that 
modifies the interface between the two drivers. Given the high risk of 
conflicts, merging it in v4.11-rc2 is the easiest option, after which I will 
send pull requests as usual for v4.12.

The patch has been fully tested by itself on top of v4.11-rc1.

The following changes since commit c1ae3cfa0e89fa1a7ecc4c99031f5e9ae99d9201:

  Linux 4.11-rc1 (2017-03-05 12:59:56 -0800)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git vsp1/fixes

for you to fetch changes up to 196855efefa3875b7d552617a4df0e2e80f34db6:

  v4l: vsp1: Adapt vsp1_du_setup_lif() interface to use a structure 
(2017-03-06 19:21:30 +0200)

----------------------------------------------------------------
Kieran Bingham (1):
      v4l: vsp1: Adapt vsp1_du_setup_lif() interface to use a structure

 drivers/gpu/drm/rcar-du/rcar_du_vsp.c  |  8 ++++++--
 drivers/media/platform/vsp1/vsp1_drm.c | 33 ++++++++++++++++-----------------
 include/media/vsp1.h                   | 13 +++++++++++--
 3 files changed, 33 insertions(+), 21 deletions(-)

-- 
Regards,

Laurent Pinchart
