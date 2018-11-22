Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:52874 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731622AbeKVUgr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Nov 2018 15:36:47 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT FIXES FOR v4.20] gspca regression fix
Message-ID: <68773825-a0ea-4525-7dc7-5a675cdad697@xs4all.nl>
Date: Thu, 22 Nov 2018 10:58:01 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 5200ab6a32d6055428896a49ec9e3b1652c1a100:

  media: vidioc_cropcap -> vidioc_g_pixelaspect (2018-11-20 13:57:21 -0500)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git tags/br-v4.20m

for you to fetch changes up to e3e33f1da1e0a266435c61394320e64588631a59:

  gspca: fix frame overflow error (2018-11-22 10:50:37 +0100)

----------------------------------------------------------------
Tag branch

----------------------------------------------------------------
Hans Verkuil (1):
      gspca: fix frame overflow error

 drivers/media/usb/gspca/gspca.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)
