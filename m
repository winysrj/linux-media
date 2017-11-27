Return-path: <linux-media-owner@vger.kernel.org>
Received: from kadath.azazel.net ([81.187.231.250]:35460 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751712AbdK0L5b (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Nov 2017 06:57:31 -0500
From: Jeremy Sowden <jeremy@azazel.net>
To: linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Jeremy Sowden <jeremy@azazel.net>
Subject: [PATCH 0/3] Sparse fixes for the Atom ISP Staging Driver
Date: Mon, 27 Nov 2017 11:30:51 +0000
Message-Id: <20171127113054.27657-1-jeremy@azazel.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixed some sparse warnings in the Atom ISP staging driver and the checkpatch
warnings that affected my patches.

Jeremy Sowden (3):
  media: staging: atomisp: address member of struct ia_css_host_data is
    a pointer-to-char, so define default as NULL.
  media: staging: atomisp: defined as static some const arrays which
    don't need external linkage.
  media: staging: atomisp: prefer s16 to int16_t.

 .../isp/kernels/eed1_8/ia_css_eed1_8.host.c        | 25 +++++++++++-----------
 .../isp_param/interface/ia_css_isp_param_types.h   |  2 +-
 2 files changed, 13 insertions(+), 14 deletions(-)


base-commit: 844056fd74ebdd826bd23a7d989597e15f478acb
-- 
2.15.0
