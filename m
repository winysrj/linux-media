Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:44728 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753656AbdLOIsg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Dec 2017 03:48:36 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Steve Longerbeam <slongerbeam@gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.16, v2] media: imx: Add better OF graph support
Message-ID: <0a2a8e2f-52d1-1fbc-00dd-4962aa2c770d@xs4all.nl>
Date: Fri, 15 Dec 2017 09:48:34 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Note: the new v4l2-async work makes it possible to simplify this. That
will be done in follow-up patches. It's easier to do that if this is in
first.

This v2 is just a rebased version of v1 to fix merge conflicts.

Regards,

    Hans

The following changes since commit 0ca4e3130402caea8731a7b54afde56a6edb17c9:

  media: pxa_camera: rename the soc_camera_ prefix to pxa_camera_ (2017-12-14 12:40:01 -0500)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git imx

for you to fetch changes up to c7db71987c4fdbfcc62cb01f5f88fee25e2d0df0:

  media: staging/imx: update TODO (2017-12-15 09:46:20 +0100)

----------------------------------------------------------------
Steve Longerbeam (9):
      media: staging/imx: get CSI bus type from nearest upstream entity
      media: staging/imx: remove static media link arrays
      media: staging/imx: of: allow for recursing downstream
      media: staging/imx: remove devname string from imx_media_subdev
      media: staging/imx: pass fwnode handle to find/add async subdev
      media: staging/imx: remove static subdev arrays
      media: staging/imx: convert static vdev lists to list_head
      media: staging/imx: reorder function prototypes
      media: staging/imx: update TODO

 drivers/staging/media/imx/TODO                    |  63 +++++++--
 drivers/staging/media/imx/imx-ic-prp.c            |   4 +-
 drivers/staging/media/imx/imx-media-capture.c     |   2 +
 drivers/staging/media/imx/imx-media-csi.c         | 187 +++++++++++++++------------
 drivers/staging/media/imx/imx-media-dev.c         | 401 +++++++++++++++++++++++++---------------------------------
 drivers/staging/media/imx/imx-media-internal-sd.c | 253 ++++++++++++++++++------------------
 drivers/staging/media/imx/imx-media-of.c          | 278 ++++++++++++++++++++--------------------
 drivers/staging/media/imx/imx-media-utils.c       | 122 ++++++++----------
 drivers/staging/media/imx/imx-media.h             | 187 ++++++++++-----------------
 9 files changed, 721 insertions(+), 776 deletions(-)
