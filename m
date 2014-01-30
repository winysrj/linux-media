Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f173.google.com ([209.85.216.173]:42161 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166AbaA3DWp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jan 2014 22:22:45 -0500
Received: by mail-qc0-f173.google.com with SMTP id i8so4129723qcq.18
        for <linux-media@vger.kernel.org>; Wed, 29 Jan 2014 19:22:44 -0800 (PST)
Date: Wed, 29 Jan 2014 22:22:41 -0500
From: Michael Krufky <mkrufky@linuxtv.org>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, mkrufky@linuxtv.org
Subject: [GIT PULL] cx24117 & mxl111sf fixes
Message-ID: <20140129222241.4cd229a1@vujade>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit
587d1b06e07b4a079453c74ba9edf17d21931049:

  [media] rc-core: reuse device numbers (2014-01-15 11:46:37 -0200)

are available in the git repository at:

  git://linuxtv.org/mkrufky/dvb dvb

for you to fetch changes up to 07f717f6ace478c462ecd65ddad5b7912a082044:

  mxl111sf: Fix compile when CONFIG_DVB_USB_MXL111SF is unset
  (2014-01-29 22:17:09 -0500)

----------------------------------------------------------------
Andi Shyti (2):
      cx24117: remove dead code in always 'false' if statement
      cx24117: use a valid dev pointer for dev_err printout

Dave Jones (2):
      mxl111sf: Fix unintentional garbage stack read
      mxl111sf: Fix compile when CONFIG_DVB_USB_MXL111SF is unset

 drivers/media/dvb-frontends/cx24117.c         | 10 +---------
 drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.h |  2 +-
 drivers/media/usb/dvb-usb-v2/mxl111sf.c       |  2 +-
 3 files changed, 3 insertions(+), 11 deletions(-)
