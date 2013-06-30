Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f44.google.com ([209.85.216.44]:40041 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325Ab3F3SJS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Jun 2013 14:09:18 -0400
Received: by mail-qa0-f44.google.com with SMTP id o13so1615781qaj.3
        for <linux-media@vger.kernel.org>; Sun, 30 Jun 2013 11:09:18 -0700 (PDT)
Date: Sun, 30 Jun 2013 14:09:49 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
To: mchehab@redhat.com, linux-media@vger.kernel.org
Subject: [GIT PULL] git://linuxtv.org/mkrufky/hauppauge dib0700
Message-ID: <20130630140949.32253b33@vujade>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit
1c26190a8d492adadac4711fe5762d46204b18b0:

  [media] exynos4-is: Correct colorspace handling at FIMC-LITE
  (2013-06-28 15:33:27 -0300)

are available in the git repository at:

  git://linuxtv.org/mkrufky/hauppauge dib0700

for you to fetch changes up to b5a7481571163fc1c83a12987be8a6ebd88bc91a:

  dib0700: add support for PCTV 2002e & PCTV 2002e SE (2013-06-30
  11:43:58 -0400)

----------------------------------------------------------------
Michael Krufky (1):
      dib0700: add support for PCTV 2002e & PCTV 2002e SE

 drivers/media/dvb-core/dvb-usb-ids.h        |  2 ++
 drivers/media/usb/dvb-usb/dib0700_devices.c | 12 +++++++++++-
 2 files changed, 13 insertions(+), 1 deletion(-)
