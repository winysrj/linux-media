Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33878 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751029AbdIKSta (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Sep 2017 14:49:30 -0400
Date: Mon, 11 Sep 2017 20:49:27 +0200
From: Vincent Hervieux <vincent.hervieux@gmail.com>
To: mchehab@kernel.org, gregkh@linuxfoundation.org,
        alan@llwyncelyn.cymru, sakari.ailus@linux.intel.com,
        hans.verkuil@cisco.com, rvarsha016@gmail.com,
        dan.carpenter@oracle.com, fengguang.wu@intel.com,
        daeseok.youn@gmail.com
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, vincent.hervieux@gmail.com
Subject: [PATCH 0/2] staging: atomisp: activate ATOMISP2401 support
Message-ID: <cover.1505142435.git.vincent.hervieux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently atomisp module supports Intel's Baytrail SoC and contains
some compilation switches to support Intel's Cherrytrail SoC instead.
The patchset aims to :
- 1/2: activate ATOMISP2400 or ATOMISP2401 from the menu.
- 2/2: fix compilation errors for ATOMISP2401.
I'm not so confident with patch 2/2, as it is only working around the non declared functions by using the 2400 path. As I couln't find any declaration/definition for the ISP2401 missing functions...So any help would be appreciated.
Also patch 2/2 doesn't correct any cosmetic changes reported by checkpatch.pl as explained in TODO step 6.

Vincent Hervieux (2):
  staging: atomisp: add menu entries to choose between ATOMISP_2400 and
    ATOMISP_2401.
  staging: atomisp: fix compilation errors in case of ISP2401.

 drivers/staging/media/atomisp/pci/Kconfig          | 23 +++++++++++++++++++++
 .../staging/media/atomisp/pci/atomisp2/Makefile    | 10 ++++++++-
 .../media/atomisp/pci/atomisp2/atomisp_cmd.c       |  5 ++---
 .../media/atomisp/pci/atomisp2/atomisp_v4l2.c      |  6 +++++-
 .../pci/atomisp2/css2400/ia_css_acc_types.h        |  1 +
 .../css2400/runtime/debug/src/ia_css_debug.c       |  3 ---
 .../media/atomisp/pci/atomisp2/css2400/sh_css.c    | 24 ++++++++++------------
 .../atomisp/pci/atomisp2/css2400/sh_css_params.c   |  8 +-------
 8 files changed, 52 insertions(+), 28 deletions(-)

-- 
2.11.0
