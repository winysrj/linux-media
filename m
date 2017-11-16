Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0125.hostedemail.com ([216.40.44.125]:37192 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1759056AbdKPP1i (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 16 Nov 2017 10:27:38 -0500
From: Joe Perches <joe@perches.com>
To: Chanwoo Choi <cw00.choi@samsung.com>, linux-pm@vger.kernel.org,
        linux-integrity@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: [PATCH 0/4] treewide: Fix line continuation formats
Date: Thu, 16 Nov 2017 07:27:25 -0800
Message-Id: <cover.1510845910.git.joe@perches.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Avoid using line continations in formats as that causes unexpected
output.

Joe Perches (4):
  rk3399_dmc: Fix line continuation format
  drm: amd: Fix line continuation formats
  [media] dibx000_common: Fix line continuation format
  ima: Fix line continuation format

 drivers/devfreq/rk3399_dmc.c                       |  4 ++--
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c   | 11 ++++-----
 .../amd/powerplay/hwmgr/process_pptables_v1_0.c    |  6 ++---
 drivers/gpu/drm/amd/powerplay/hwmgr/vega10_hwmgr.c | 27 ++++++++--------------
 drivers/gpu/drm/amd/powerplay/smumgr/ci_smumgr.c   |  6 ++---
 .../gpu/drm/amd/powerplay/smumgr/iceland_smumgr.c  |  9 +++-----
 .../gpu/drm/amd/powerplay/smumgr/vega10_smumgr.c   |  6 ++---
 drivers/media/dvb-frontends/dibx000_common.c       |  8 +++----
 security/integrity/ima/ima_template.c              | 11 ++++-----
 9 files changed, 33 insertions(+), 55 deletions(-)

-- 
2.15.0
