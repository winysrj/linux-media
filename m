Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp207.alice.it ([82.57.200.103]:4515 "EHLO smtp207.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753807AbaFYJ3V (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Jun 2014 05:29:21 -0400
From: Antonio Ospite <ao2@ao2.it>
To: linux-media@vger.kernel.org
Cc: Antonio Ospite <ao2@ao2.it>, Hans de Goede <hdegoede@redhat.com>,
	Alexander Sosna <alexander@xxor.de>
Subject: [PATCH 0/2] gspca, gspca_kinect: add support for the depth stream
Date: Wed, 25 Jun 2014 11:27:55 +0200
Message-Id: <1403688477-30408-1-git-send-email-ao2@ao2.it>
In-Reply-To: <1401913499-6475-1-git-send-email-ao2@ao2.it>
References: <1401913499-6475-1-git-send-email-ao2@ao2.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

here are the patches to make gspca able to deal with the Kinect depth
stream at 10bpp.

If anyone is really interested in the 11bpp data too, ping me.

Alexander, please let us know if you can test these anytime soon.

Thanks,
   Antonio

Antonio Ospite (2):
  gspca: provide a mechanism to select a specific transfer endpoint
  gspca_kinect: add support for the depth stream

 drivers/media/usb/gspca/gspca.c  | 20 +++++---
 drivers/media/usb/gspca/gspca.h  |  1 +
 drivers/media/usb/gspca/kinect.c | 98 +++++++++++++++++++++++++++++++++++-----
 3 files changed, 102 insertions(+), 17 deletions(-)

-- 
Antonio Ospite
http://ao2.it

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
