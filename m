Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:50299 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932961AbcKKPLs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 Nov 2016 10:11:48 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.10] Various fixes.
Message-ID: <48b4f2e5-540c-6c78-bcee-81172431d9e4@xs4all.nl>
Date: Fri, 11 Nov 2016 16:11:43 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit bd676c0c04ec94bd830b9192e2c33f2c4532278d:

  [media] v4l2-flash-led-class: remove a now unused var (2016-10-24 18:51:29 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.10c

for you to fetch changes up to 497f3f8192dda32c2897ccaaf9b02dc1d094c97e:

  cobalt: fix copy-and-paste error (2016-11-11 12:00:21 +0100)

----------------------------------------------------------------
Hans Verkuil (3):
      cec-core.rst: improve documentation
      control.rst: improve the queryctrl code examples
      cobalt: fix copy-and-paste error

Maninder Singh (1):
      staging: st-cec: add parentheses around complex macros

Markus Elfring (2):
      DaVinci-VPBE: Check return value of a setup_if_config() call in vpbe_set_output()
      DaVinci-VPFE-Capture: Replace a memcpy() call by an assignment in vpfe_enum_input()

Wu-Cheng Li (1):
      mtk-vcodec: add index check in decoder vidioc_qbuf.

 Documentation/media/kapi/cec-core.rst              | 24 ++++++++++----
 Documentation/media/uapi/v4l/control.rst           | 88 +++++++++++++++++++++++++++++++-------------------
 drivers/media/pci/cobalt/cobalt-v4l2.c             |  2 +-
 drivers/media/platform/davinci/vpbe.c              |  4 +--
 drivers/media/platform/davinci/vpfe_capture.c      |  2 +-
 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c |  4 +++
 drivers/staging/media/st-cec/stih-cec.c            |  4 +--
 7 files changed, 82 insertions(+), 46 deletions(-)
