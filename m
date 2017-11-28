Return-path: <linux-media-owner@vger.kernel.org>
Received: from kadath.azazel.net ([81.187.231.250]:45296 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753170AbdK1K2A (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Nov 2017 05:28:00 -0500
From: Jeremy Sowden <jeremy@azazel.net>
To: linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Jeremy Sowden <jeremy@azazel.net>
Subject: [PATCH v2 0/3] Sparse fixes for the Atom ISP Staging Driver
Date: Tue, 28 Nov 2017 10:27:24 +0000
Message-Id: <20171128102726.30542-1-jeremy@azazel.net>
In-Reply-To: <20171127190938.73c6b15a@alans-desktop>
References: <20171127190938.73c6b15a@alans-desktop>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixed some sparse warnings in the Atom ISP staging driver.

This time with longer commit messages. :)

I've chosen to ignore checkpatch.pl's suggestion to change the types of
the arrays in the second patch from int16_t to s16.

Jeremy Sowden (2):
  media: staging: atomisp: fix for sparse "using plain integer as NULL
    pointer" warnings.
  media: staging: atomisp: fixes for "symbol was not declared. Should it
    be static?" sparse warnings.

 .../isp/kernels/eed1_8/ia_css_eed1_8.host.c        | 24 +++++++++++-----------
 .../isp_param/interface/ia_css_isp_param_types.h   |  2 +-
 2 files changed, 13 insertions(+), 13 deletions(-)


base-commit: 844056fd74ebdd826bd23a7d989597e15f478acb
-- 
2.15.0
