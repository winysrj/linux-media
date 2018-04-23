Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:40061 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755559AbeDWPjO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 11:39:14 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Fabio Estevam <festevam@gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT FIXES FOR v4.17] imx regression bug fix
Message-ID: <b25e6bb0-d14a-8ff1-e245-912e3fa78a45@xs4all.nl>
Date: Mon, 23 Apr 2018 17:39:08 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 1d338b86e17d87215cf57b1ad1d13b2afe582d33:

  media: v4l2-compat-ioctl32: better document the code (2018-04-20 08:24:13 -0400)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.17h

for you to fetch changes up to 8721c681d779a28b21be97ec4ce7891a55205e07:

  media: imx-media-csi: Fix inconsistent IS_ERR and PTR_ERR (2018-04-23 17:24:08 +0200)

----------------------------------------------------------------
From: Gustavo A. R. Silva (1):
      media: imx-media-csi: Fix inconsistent IS_ERR and PTR_ERR

 drivers/staging/media/imx/imx-media-csi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
