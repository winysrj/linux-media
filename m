Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:43818 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730337AbeKVWlO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Nov 2018 17:41:14 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Ezequiel Garcia <ezequiel@collabora.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT FIXES FOR v4.20] Revert "media: dt-bindings: Document the
 Rockchip VPU bindings"
Message-ID: <fcd781dc-c4ea-c94a-067c-e8e6bace7e66@xs4all.nl>
Date: Thu, 22 Nov 2018 13:02:06 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 5200ab6a32d6055428896a49ec9e3b1652c1a100:

  media: vidioc_cropcap -> vidioc_g_pixelaspect (2018-11-20 13:57:21 -0500)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git tags/br-v4.20n

for you to fetch changes up to a91f8d8762388bedff87e967a8655514775568fc:

  Revert "media: dt-bindings: Document the Rockchip VPU bindings" (2018-11-22 13:00:10 +0100)

----------------------------------------------------------------
Tag branch

----------------------------------------------------------------
Ezequiel Garcia (1):
      Revert "media: dt-bindings: Document the Rockchip VPU bindings"

 Documentation/devicetree/bindings/media/rockchip-vpu.txt | 29 -----------------------------
 1 file changed, 29 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/media/rockchip-vpu.txt
