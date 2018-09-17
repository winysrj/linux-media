Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:51614 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726753AbeIQQeC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Sep 2018 12:34:02 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT FIXES FOR v4.19] Fix cros-ec-cec build error
Message-ID: <f5a8df24-d616-a702-8dd4-1b74911ed05a@xs4all.nl>
Date: Mon, 17 Sep 2018 13:07:06 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 78cf8c842c111df656c63b5d04997ea4e40ef26a:

  media: drxj: fix spelling mistake in fall-through annotations (2018-09-12 11:21:52 -0400)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git tags/v4.19b

for you to fetch changes up to 8b700bb12aea882e14eb1a48789581dd7724c410:

  media: platform: fix cros-ec-cec build error (2018-09-17 11:40:14 +0200)

----------------------------------------------------------------
Tag v4.19b

----------------------------------------------------------------
Randy Dunlap (1):
      media: platform: fix cros-ec-cec build error

 drivers/media/platform/Kconfig | 2 ++
 1 file changed, 2 insertions(+)
