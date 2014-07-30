Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:3674 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbaG3IOC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Jul 2014 04:14:02 -0400
Message-ID: <53D8A93F.20506@xs4all.nl>
Date: Wed, 30 Jul 2014 10:13:51 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Joe Perches <joe@perches.com>
Subject: [GIT PULL FOR v3.17] Fix MAINTAINERS file and one sparse fix
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

I forgot to update the MAINTAINERS file when I moved the solo6x10 and go7007
drivers out of staging. Thanks to Joe for making a patch for this.

I also added a trivial sparse fix from Wei Yongjun for the radio-miropcm20 driver.

Regards,

	Hans

The following changes since commit 7f196789b3ffee243b681d3e7dab8890038db856:

  si2135: Declare the structs even if frontend is not enabled (2014-07-28 10:37:08 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.17h

for you to fetch changes up to 2f5fdc4fc55f3c0ba4a05995e27126b72edfe840:

  radio-miropcm20: fix sparse NULL pointer warning (2014-07-30 10:10:51 +0200)

----------------------------------------------------------------
Joe Perches (2):
      MAINTAINERS: Update solo6x10 patterns
      MAINTAINERS: Update go7007 pattern

Wei Yongjun (1):
      radio-miropcm20: fix sparse NULL pointer warning

 MAINTAINERS                           | 22 ++++++++++++----------
 drivers/media/radio/radio-miropcm20.c |  2 +-
 2 files changed, 13 insertions(+), 11 deletions(-)
