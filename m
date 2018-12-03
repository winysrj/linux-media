Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:35913 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725885AbeLCT2N (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 3 Dec 2018 14:28:13 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT FIXES FOR v4.20] seco-cec: add missing header
Message-ID: <62615fef-ca55-0747-8794-e6eee87c20a1@xs4all.nl>
Date: Mon, 3 Dec 2018 20:28:02 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 708d75fe1c7c6e9abc5381b6fcc32b49830383d0:

  media: dvb-pll: don't re-validate tuner frequencies (2018-11-23 12:27:18 -0500)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git tags/br-v4.20p

for you to fetch changes up to 783f306b4e480b964daa5ac45d13edd1579f42e4:

  media: seco-cec: add missing header file to fix build (2018-12-03 20:26:37 +0100)

----------------------------------------------------------------
Tag branch

----------------------------------------------------------------
Randy Dunlap (1):
      media: seco-cec: add missing header file to fix build

 drivers/media/platform/seco-cec/seco-cec.c | 1 +
 1 file changed, 1 insertion(+)
