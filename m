Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:30640 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755239Ab0KMTfc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Nov 2010 14:35:32 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id oADJZWow014739
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 13 Nov 2010 14:35:32 -0500
Received: from pedra (vpn-229-222.phx2.redhat.com [10.3.229.222])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id oADJXRSk018179
	for <linux-media@vger.kernel.org>; Sat, 13 Nov 2010 14:35:31 -0500
Date: Sat, 13 Nov 2010 17:33:19 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 0/3] Remove ir-common module
Message-ID: <20101113173319.088ea5c7@pedra>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

I did some tests using the Encore FM 5.3. This were the last device using
the legacy IR support on saa7134. After it, only one device
(Nebula Electronics DigiTV) still uses it. It is an old device, so, it will
probably not be easy to find someone with such hardware.

As the conversion requires to test if raw decoding work with bttv (e. g.
if the hardware works properly generating IRQ's on both GPIO transitions),
we need someone with this hardware, or with another hardware that connects
an IRQ directly into a bttv GPIO pin capable of generating IRQ's.
While we don't have it, let's just move the legacy code to bttv driver.

Mauro Carvalho Chehab (3):
  [media] saa7134: use rc-core raw decoders for Encore FM 5.3
  [media] saa7134: Remove legacy IR decoding logic inside the module
  [media] rc: Remove ir-common module

 drivers/media/rc/Kconfig                    |    5 -
 drivers/media/rc/Makefile                   |    2 -
 drivers/media/rc/ir-functions.c             |  120 --------------
 drivers/media/video/bt8xx/Kconfig           |    2 +-
 drivers/media/video/bt8xx/bttv-input.c      |  103 ++++++++++++-
 drivers/media/video/saa7134/Kconfig         |    2 +-
 drivers/media/video/saa7134/saa7134-input.c |  226 +--------------------------
 drivers/media/video/saa7134/saa7134.h       |    2 +-
 8 files changed, 107 insertions(+), 355 deletions(-)
 delete mode 100644 drivers/media/rc/ir-functions.c

