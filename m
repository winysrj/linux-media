Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:55671 "EHLO
        lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751498AbdEEK2B (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 5 May 2017 06:28:01 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.12] Fix for nasty tc358743 regression
Message-ID: <952319a4-9d15-af35-266a-bd86a3f2ba57@xs4all.nl>
Date: Fri, 5 May 2017 12:27:56 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 3622d3e77ecef090b5111e3c5423313f11711dfa:

  [media] ov2640: print error if devm_*_optional*() fails (2017-04-25 07:08:21 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.12i

for you to fetch changes up to ad21c3167e4a67d5aa2a46a134ca07c4fa8c6719:

  tc358743: fix register i2c_rd/wr function fix (2017-05-05 12:19:17 +0200)

----------------------------------------------------------------
Philipp Zabel (1):
      tc358743: fix register i2c_rd/wr function fix

 drivers/media/i2c/tc358743.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
