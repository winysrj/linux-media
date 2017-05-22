Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:41732 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1757781AbdEVJXT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 May 2017 05:23:19 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.12] Fix stupid rainshadow bug
Message-ID: <f0e64971-678e-90bb-6792-6386d2b63f47@xs4all.nl>
Date: Mon, 22 May 2017 11:23:13 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Let's fix this serious bug before it ends up in the 4.12 release.

Regards,

	Hans

The following changes since commit 36bcba973ad478042d1ffc6e89afd92e8bd17030:

  [media] mtk_vcodec_dec: return error at mtk_vdec_pic_info_update() (2017-05-19 07:12:05 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.12j

for you to fetch changes up to 71eb916453ed806ee105ef896b8f02f7eab2d4fc:

  rainshadow-cec: ensure exit_loop is intialized (2017-05-22 10:39:11 +0200)

----------------------------------------------------------------
Colin Ian King (1):
      rainshadow-cec: ensure exit_loop is intialized

 drivers/media/usb/rainshadow-cec/rainshadow-cec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
