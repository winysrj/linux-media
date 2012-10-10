Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp208.alice.it ([82.57.200.104]:42491 "EHLO smtp208.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756309Ab2JJNj2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Oct 2012 09:39:28 -0400
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: Aapo Tahkola <aet@rasterburn.org>,
	Antonio Ospite <ospite@studenti.unina.it>,
	CityK <cityk@rogers.com>
Subject: [PATCH 0/5] v4l-utils: add some scripts from the wiki.
Date: Wed, 10 Oct 2012 15:39:17 +0200
Message-Id: <1349876363-12098-1-git-send-email-ospite@studenti.unina.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi,

I recently used some scripts I found on the linuxtv.org wiki to extract
a firmware for a m920x device from USB dumps made with UsbSniff2.0 on
WIndows XP.

I thought these scripts may be collected in v4l-utils where it is easier
to change them.

The first two patches add the scripts as they are now on the wiki, I am
sending them on behalf of the original author even if I was not able to
contact him, I hope this is OK.

The subsequent changes are little fixes to make m920x_parse.pl work for me.

Regards,
   Antonio


Aapo Tahkola (2):
  contrib: add some scripts to extract m920x firmwares from USB dumps
  contrib: add a script to convert usbmon captures to usbsnoop

Antonio Ospite (3):
  m920x_parse.pl: use string comparison operators
  m920x_parse.pl: fix strict and warnings checks
  m920x_parse.pl: add support for consuming the output of
    parse-sniffusb2.pl

 contrib/m920x/m920x_parse.pl       |  295 ++++++++++++++++++++++++++++++++++++
 contrib/m920x/m920x_sp_firmware.pl |  115 ++++++++++++++
 contrib/usbmon2usbsnoop.pl         |   53 +++++++
 3 files changed, 463 insertions(+)
 create mode 100755 contrib/m920x/m920x_parse.pl
 create mode 100755 contrib/m920x/m920x_sp_firmware.pl
 create mode 100755 contrib/usbmon2usbsnoop.pl

-- 
Antonio Ospite
http://ao2.it

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
