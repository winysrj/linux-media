Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:43574 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753256AbdLHK5E (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Dec 2017 05:57:04 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Steve Longerbeam <slongerbeam@gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.16] media: imx: Add better OF graph support
Message-ID: <4fa72331-0b80-1df6-ed58-d907e585bd50@xs4all.nl>
Date: Fri, 8 Dec 2017 11:56:58 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Note: the new v4l2-async work makes it possible to simplify this. That
will be done in follow-up patches. It's easier to do that if this is in
first.

Regards,

	Hans

The following changes since commit 781b045baefdabf7e0bc9f33672ca830d3db9f27:

  media: imx274: Fix error handling, add MAINTAINERS entry (2017-11-30 04:45:12 -0500)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git imx

for you to fetch changes up to 82737cbb02f269b8eb608c7bd906a79072f6adad:

  media: staging/imx: update TODO (2017-12-04 14:05:19 +0100)

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

 drivers/staging/media/imx/TODO                    |  63 ++++++--
 drivers/staging/media/imx/imx-ic-prp.c            |   4 +-
 drivers/staging/media/imx/imx-media-capture.c     |   2 +
 drivers/staging/media/imx/imx-media-csi.c         | 187 +++++++++++++----------
 drivers/staging/media/imx/imx-media-dev.c         | 400 ++++++++++++++++++++++----------------------------
 drivers/staging/media/imx/imx-media-internal-sd.c | 253 ++++++++++++++++---------------
 drivers/staging/media/imx/imx-media-of.c          | 278 +++++++++++++++++------------------
 drivers/staging/media/imx/imx-media-utils.c       | 122 +++++++--------
 drivers/staging/media/imx/imx-media.h             | 187 +++++++++--------------
 9 files changed, 722 insertions(+), 774 deletions(-)
