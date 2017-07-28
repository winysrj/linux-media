Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:50120 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751007AbdG1Hi5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Jul 2017 03:38:57 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.14] Doc and TGP fixes
Message-ID: <dc878037-1039-be63-cd69-11757235271a@xs4all.nl>
Date: Fri, 28 Jul 2017 09:38:52 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here are various documentation fixes/improvements.

The first patch renames the old pixfmt-0XX.rst files to something I can
understand since I could never find the right rst file for the colorspace
documentation...

Regards,

	Hans

The following changes since commit da48c948c263c9d87dfc64566b3373a858cc8aa2:

   media: fix warning on v4l2_subdev_call() result interpreted as bool (2017-07-26 13:43:17 -0400)

are available in the git repository at:

   git://linuxtv.org/hverkuil/media_tree.git tpg-doc-fixes

for you to fetch changes up to 2ebc8a9b217c24a2e12f775b1b107ce7b8c28166:

   v4l2-tpg-core.c: fix typo in bt2020_full matrix (2017-07-28 09:33:58 +0200)

----------------------------------------------------------------
Hans Verkuil (6):
       media/doc: rename and reorder pixfmt files
       media/doc: improve bt.2020 documentation
       media/doc: improve the SMPTE 2084 documentation
       v4l2-tpg: fix the SMPTE-2084 transfer function
       media/extended-controls.rst: fix wrong enum names
       v4l2-tpg-core.c: fix typo in bt2020_full matrix

  .../media/uapi/v4l/{pixfmt-006.rst => colorspaces-defs.rst}          |   2 +-
  .../media/uapi/v4l/{pixfmt-007.rst => colorspaces-details.rst}       |  47 ++++++++++
  Documentation/media/uapi/v4l/extended-controls.rst                   |  26 +++---
  Documentation/media/uapi/v4l/pixfmt-008.rst                          |  32 -------
  .../media/uapi/v4l/{pixfmt-013.rst => pixfmt-compressed.rst}         |   0
  Documentation/media/uapi/v4l/{pixfmt-004.rst => pixfmt-intro.rst}    |   0
  .../media/uapi/v4l/{pixfmt-003.rst => pixfmt-v4l2-mplane.rst}        |   0
  Documentation/media/uapi/v4l/{pixfmt-002.rst => pixfmt-v4l2.rst}     |   0
  Documentation/media/uapi/v4l/pixfmt.rst                              |  15 ++-
  drivers/media/common/v4l2-tpg/v4l2-tpg-colors.c                      | 154 ++++++++++++++++---------------
  drivers/media/common/v4l2-tpg/v4l2-tpg-core.c                        |   2 +-
  11 files changed, 151 insertions(+), 127 deletions(-)
  rename Documentation/media/uapi/v4l/{pixfmt-006.rst => colorspaces-defs.rst} (98%)
  rename Documentation/media/uapi/v4l/{pixfmt-007.rst => colorspaces-details.rst} (92%)
  delete mode 100644 Documentation/media/uapi/v4l/pixfmt-008.rst
  rename Documentation/media/uapi/v4l/{pixfmt-013.rst => pixfmt-compressed.rst} (100%)
  rename Documentation/media/uapi/v4l/{pixfmt-004.rst => pixfmt-intro.rst} (100%)
  rename Documentation/media/uapi/v4l/{pixfmt-003.rst => pixfmt-v4l2-mplane.rst} (100%)
  rename Documentation/media/uapi/v4l/{pixfmt-002.rst => pixfmt-v4l2.rst} (100%)
