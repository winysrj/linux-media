Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49978 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756338Ab3ILXCT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Sep 2013 19:02:19 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 0/3] Some improvements/fixes for Siano driver
Date: Thu, 12 Sep 2013 16:59:57 -0300
Message-Id: <1379016000-19577-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I got a few reports those days about Siano regressions/issues.

The first one was reported at:
       https://bugzilla.kernel.org/show_bug.cgi?id=60645

While its fix was already upstream, the "error" messages there doesn't
help, as it induced people to believe that it was a firmware related
error.

The second one was reported via IRC, and it is related to the first
generation of Siano devices (sms1000).

It was a regression caused on kernel 3.9, that made those devices to
fail.

It turns that, on those devices, the driver should first initialize
one USB ID and load a firmware. After firmware load, the device got
replaced by another USB ID, and the device initialization can be
done, on a diferent USB Interface.

This series fixes the second issue and improves the debug message,
in order to make easier to identify what's going wrong at the
init process.

Mauro Carvalho Chehab (3):
  [media] siano: Don't show debug messages as errors
  [media] siano: Improve debug/info messages
  [media] siano: Fix initialization for Stellar models

 drivers/media/common/siano/smscoreapi.c |  4 ++--
 drivers/media/usb/siano/smsusb.c        | 40 +++++++++++++++++++++++----------
 2 files changed, 30 insertions(+), 14 deletions(-)

-- 
1.8.3.1

