Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:4487 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933484Ab0JRW4V (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Oct 2010 18:56:21 -0400
Date: Mon, 18 Oct 2010 20:53:00 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Srinivasa.Deevi@conexant.com, jarod@redhat.com,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 0/3]  Fix IR support at cx231xx
Message-ID: <20101018205300.23e0da75@pedra>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

cx231xx has a stub for IR handling, but this is incomplete. However, as
the IR were designed to work with a standard MCE driver on another OS,
the better is to just drop the cx231xx internal handling, and let the
mceusb driver take care of the protocol.

Maybe some adjustments may be needed, to be sure that we're using the right
generation of the MCE protocol.

Mauro Carvalho Chehab (3):
  mceusb: add support for cx231xx-based IR (e. g. Polaris)
  cx231xx: Only register USB interface 1
  cx231xx: Remove IR support from the driver

 drivers/media/IR/mceusb.c                   |   20 ++
 drivers/media/video/cx231xx/cx231xx-cards.c |   49 +-----
 drivers/media/video/cx231xx/cx231xx-input.c |  251 ---------------------------
 drivers/media/video/cx231xx/cx231xx.h       |    4 -
 4 files changed, 28 insertions(+), 296 deletions(-)
 delete mode 100644 drivers/media/video/cx231xx/cx231xx-input.c

