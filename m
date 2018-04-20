Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-1.cisco.com ([173.38.203.51]:58126 "EHLO
        aer-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754074AbeDTIZa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Apr 2018 04:25:30 -0400
Received: from [10.47.79.81] ([10.47.79.81])
        (authenticated bits=0)
        by aer-core-3.cisco.com (8.14.5/8.14.5) with ESMTP id w3K8PQv7008784
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
        for <linux-media@vger.kernel.org>; Fri, 20 Apr 2018 08:25:27 GMT
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hansverk@cisco.com>
Subject: [GIT FIXES FOR v4.17] New board, two fixes
Message-ID: <85e67b02-cafd-ce35-e2e9-c72ea0fdf423@cisco.com>
Date: Fri, 20 Apr 2018 10:25:26 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Three patches for 4.17: two are fixes, one add a new cx231xx board.

Regards,

	Hans

The following changes since commit 42a182282ea2426d56b2d63be634ee419194c45c:

  media: si470x: fix a typo at the Makefile causing build issues (2018-04-18 15:21:41 -0400)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.17g

for you to fetch changes up to 219744bbe295ed0369f1b1fa789ea46704cffd82:

  media: rcar-vin: Fix image alignment for setting pre clipping (2018-04-20 10:14:08 +0200)

----------------------------------------------------------------
Colin Ian King (1):
      media: cec: set ev rather than v with CEC_PIN_EVENT_FL_DROPPED bit

Kai-Heng Feng (1):
      media: cx231xx: Add support for AverMedia DVD EZMaker 7

Koji Matsuoka (1):
      media: rcar-vin: Fix image alignment for setting pre clipping

 drivers/media/cec/cec-pin.c                 | 2 +-
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 4 ++--
 drivers/media/usb/cx231xx/cx231xx-cards.c   | 3 +++
 3 files changed, 6 insertions(+), 3 deletions(-)
