Return-path: <linux-media-owner@vger.kernel.org>
Received: from kadath.azazel.net ([81.187.231.250]:47342 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751031AbdLAVpw (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Dec 2017 16:45:52 -0500
Received: from ulthar.dreamlands ([192.168.96.2])
        by kadath.azazel.net with esmtp (Exim 4.89)
        (envelope-from <jeremy@azazel.net>)
        id 1eKt82-0006Bv-IX
        for linux-media@vger.kernel.org; Fri, 01 Dec 2017 21:45:50 +0000
From: Jeremy Sowden <jeremy@azazel.net>
To: linux-media@vger.kernel.org
Subject: [PATCH v3 0/3] media: atomisp: clean up of data-structure initialization in the CSS API
Date: Fri,  1 Dec 2017 21:45:47 +0000
Message-Id: <20171201214550.7369-1-jeremy@azazel.net>
In-Reply-To: <20171201150725.cfcp6b4bs2ncqsip@mwanda>
References: <20171201150725.cfcp6b4bs2ncqsip@mwanda>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v3.

  Rebased on to git://linuxtv.org/media_tree.git.  Patch-set applies cleanly to
  linux-next as of 20171201.

v2.

  Fixed a couple of bugs and addressed checkpatch errors.

v1.

  The CSS API uses a lot of nested anonymous structs defined in object
  macros to assign default values to its data-structures.  These have
  been changed to use compound-literals and designated initializers to
  make them more comprehensible and less fragile.

  The compound-literals can also be used in assignment, which made it
  possible get rid of some temporary variables whose only purpose is to
  be initialized by one of these anonymous structs and then serve as the
  rvalue in an assignment expression.

  The designated initializers also allow the removal of lots of
  struct-members initialized to zero values.

  I made the changes in three stages: firstly, I converted the default
  values to compound-literals and designated initializers and removed
  the temporary variables; secondly, I removed the zero-valued
  struct-members; finally, I removed some structs which had become
  empty.

Jeremy Sowden (3):
  media: atomisp: convert default struct values to use compound-literals
    with designated initializers.
  media: atomisp: delete zero-valued struct members.
  media: atomisp: delete empty default struct values.

 .../hive_isp_css_common/input_formatter_global.h   |  16 ---
 .../pci/atomisp2/css2400/ia_css_frame_public.h     |  39 +++---
 .../atomisp/pci/atomisp2/css2400/ia_css_pipe.h     | 138 ++++++++-------------
 .../pci/atomisp2/css2400/ia_css_pipe_public.h      | 118 +++---------------
 .../atomisp/pci/atomisp2/css2400/ia_css_types.h    |  79 ++++--------
 .../isp/kernels/s3a/s3a_1.0/ia_css_s3a_types.h     |  50 +-------
 .../kernels/sdis/common/ia_css_sdis_common_types.h |  34 ++---
 .../isp/kernels/sdis/sdis_1.0/ia_css_sdis.host.c   |   3 +-
 .../runtime/binary/interface/ia_css_binary.h       |  93 ++------------
 .../atomisp2/css2400/runtime/binary/src/binary.c   |   3 +-
 .../isp_param/interface/ia_css_isp_param_types.h   |  10 --
 .../runtime/pipeline/interface/ia_css_pipeline.h   |  29 ++---
 .../css2400/runtime/pipeline/src/pipeline.c        |   7 +-
 .../media/atomisp/pci/atomisp2/css2400/sh_css.c    |  31 ++---
 .../atomisp/pci/atomisp2/css2400/sh_css_legacy.h   |  11 --
 .../atomisp/pci/atomisp2/css2400/sh_css_metrics.h  |  21 ----
 16 files changed, 160 insertions(+), 522 deletions(-)


base-commit: 781b045baefdabf7e0bc9f33672ca830d3db9f27
-- 
2.15.0
