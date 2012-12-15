Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10235 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752684Ab2LOM3d (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Dec 2012 07:29:33 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id qBFCTXI5030975
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 15 Dec 2012 07:29:33 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 0/2] Add more protocols to em28xx IR
Date: Sat, 15 Dec 2012 10:29:10 -0200
Message-Id: <1355574552-18472-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series add support for NEC protocol variants and to RC6
mode 0 on em2874 and newer devices.

It was tested with a Terratec HTC device, and using 4 different remote
control models:
	- RC5 Hauppauge Grey remote;
	- NEC Terratec remote;
	- NEC-like 24-bits protocol Pixelview remote;
	- Philips RC6 remote.

It work properly with all the above remotes.

Mauro Carvalho Chehab (2):
  [media] em28xx: add support for NEC proto variants on em2874 and
    upper
  [media] em28xx: add support for RC6 mode 0 on devices that support it

 drivers/media/usb/em28xx/em28xx-input.c | 149 ++++++++++++++++++++++++--------
 drivers/media/usb/em28xx/em28xx-reg.h   |   1 +
 2 files changed, 114 insertions(+), 36 deletions(-)

-- 
1.7.11.7

