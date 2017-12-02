Return-path: <linux-media-owner@vger.kernel.org>
Received: from kadath.azazel.net ([81.187.231.250]:33630 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752365AbdLBWME (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 2 Dec 2017 17:12:04 -0500
From: Jeremy Sowden <jeremy@azazel.net>
To: linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH v4 0/3] media: atomisp: clean up of data-structure initialization in the CSS API
Date: Sat,  2 Dec 2017 22:11:58 +0000
Message-Id: <20171202221201.6063-1-jeremy@azazel.net>
In-Reply-To: <20171202213443.GC32301@azazel.net>
References: <20171202213443.GC32301@azazel.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v4.

  Removed the parens around the compound-literals in the macro
  definitions.  They were superfluous and the errors reported by
  checkpatch.pl appear to have been false positives resulting from a
  bug.

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
 .../pci/atomisp2/css2400/ia_css_frame_public.h     |  29 ++----
 .../atomisp/pci/atomisp2/css2400/ia_css_pipe.h     | 113 ++++++++-------------
 .../pci/atomisp2/css2400/ia_css_pipe_public.h      | 108 +++-----------------
 .../atomisp/pci/atomisp2/css2400/ia_css_types.h    |  64 +++---------
 .../isp/kernels/s3a/s3a_1.0/ia_css_s3a_types.h     |  50 +--------
 .../kernels/sdis/common/ia_css_sdis_common_types.h |  31 ++----
 .../isp/kernels/sdis/sdis_1.0/ia_css_sdis.host.c   |   3 +-
 .../runtime/binary/interface/ia_css_binary.h       |  88 ++--------------
 .../atomisp2/css2400/runtime/binary/src/binary.c   |   3 +-
 .../isp_param/interface/ia_css_isp_param_types.h   |  10 --
 .../runtime/pipeline/interface/ia_css_pipeline.h   |  24 ++---
 .../css2400/runtime/pipeline/src/pipeline.c        |   7 +-
 .../media/atomisp/pci/atomisp2/css2400/sh_css.c    |  31 ++----
 .../atomisp/pci/atomisp2/css2400/sh_css_legacy.h   |  11 --
 .../atomisp/pci/atomisp2/css2400/sh_css_metrics.h  |  21 ----
 16 files changed, 116 insertions(+), 493 deletions(-)


base-commit: 781b045baefdabf7e0bc9f33672ca830d3db9f27
-- 
2.15.0
