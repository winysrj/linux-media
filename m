Return-path: <linux-media-owner@vger.kernel.org>
Received: from 2a.88.344a.static.theplanet.com ([74.52.136.42]:46671 "EHLO
	metroid.mu3d.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753819Ab3I3CC0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Sep 2013 22:02:26 -0400
From: Jean-Francois Thibert <jfthibert@google.com>
Cc: Jean-Francois Thibert <jfthibert@google.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] Add support for KWorld UB435-Q V2
Date: Sun, 29 Sep 2013 20:45:21 -0400
Message-Id: <1380501923-23127-1-git-send-email-jfthibert@google.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This adds support for the UB435-Q V2. It seems that you might need to
use the device once with the official driver to reprogram the device
descriptors. Thanks to Jarod Wilson for the initial attempt at adding
support for this device.

Jean-Francois Thibert (1):
  Add support for KWorld UB435-Q V2

 drivers/media/usb/em28xx/em28xx-cards.c |   14 +++++++++++++-
 drivers/media/usb/em28xx/em28xx-dvb.c   |   27 +++++++++++++++++++++++++++
 drivers/media/usb/em28xx/em28xx.h       |    1 +
 3 files changed, 41 insertions(+), 1 deletions(-)

-- 
1.7.5.4

