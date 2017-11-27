Return-path: <linux-media-owner@vger.kernel.org>
Received: from kadath.azazel.net ([81.187.231.250]:36922 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751951AbdK0Mph (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Nov 2017 07:45:37 -0500
From: Jeremy Sowden <jeremy@azazel.net>
To: linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Jeremy Sowden <jeremy@azazel.net>
Subject: [PATCH v2 0/3] Sparse fixes for the Atom ISP Staging Driver
Date: Mon, 27 Nov 2017 12:44:47 +0000
Message-Id: <20171127124450.28799-1-jeremy@azazel.net>
In-Reply-To: <20171127122125.GB8561@kroah.com>
References: <20171127122125.GB8561@kroah.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixed some sparse warnings in the Atom ISP staging driver and the checkpatch
warnings that affected my patches.

This time with longer commit messages. :)

Jeremy Sowden (3):
  media: staging: atomisp: fix for sparse "using plain integer as NULL
    pointer" warnings.
  media: staging: atomisp: fixes for "symbol was not declared. Should it
    be static?" sparse warnings.
  media: staging: atomisp: fixed some checkpatch integer type warnings.

 .../isp/kernels/eed1_8/ia_css_eed1_8.host.c        | 25 +++++++++++-----------
 .../isp_param/interface/ia_css_isp_param_types.h   |  2 +-
 2 files changed, 13 insertions(+), 14 deletions(-)


base-commit: 844056fd74ebdd826bd23a7d989597e15f478acb
-- 
2.15.0
