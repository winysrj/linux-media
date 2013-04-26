Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43993 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756824Ab3DZMta (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Apr 2013 08:49:30 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: =?UTF-8?q?Jon=20Arne=20J=C3=B8rgensen?= <jonarne@jonarne.no>
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 0/2] saa7115: add detection code for gm7113c
Date: Fri, 26 Apr 2013 09:49:15 -0300
Message-Id: <1366980557-23077-1-git-send-email-mchehab@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jen,

Ezequiel pinged me today on IRC warning me that, at least on his
stk1160 device with gm1113c, the analog demod, labeled as GM1113C 1145,
returns 0x10 on all reads (e. g. version 0).

So, I decided to write a patch with the ideas I exposed on my last
emails, plus a code that would allow saa7115 to work with both
auto-detection and manual binding.

I didn't add there the part of your code with the gm7113c specifics,
as I prefer if you can rebase your patch on the top of those two,
of course assuming that they'll work.

Patches weren't test yet.

Jen/Ezequiel,

Could you please test them?

Mauro Carvalho Chehab (2):
  saa7115: move the autodetection code out of the probe function
  saa7115: add detection code for gm7113c

 drivers/media/i2c/saa7115.c     | 165 ++++++++++++++++++++++++++++------------
 include/media/v4l2-chip-ident.h |   2 +
 2 files changed, 119 insertions(+), 48 deletions(-)

-- 
1.8.1.4

