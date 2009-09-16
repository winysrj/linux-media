Return-path: <linux-media-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:35812 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760112AbZIPVpc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Sep 2009 17:45:32 -0400
Subject: patch v4l-em28xx-set-up-tda9887_conf-in-em28xx_card_setup.patch added to 2.6.30-stable tree
To: mkrufky@linuxtv.org, dougsland@redhat.com, fmeng2002@yahoo.com,
	gregkh@suse.de, Larry.Finger@lwfinger.net,
	linux-media@vger.kernel.org, mchehab@redhat.com
Cc: <stable@kernel.org>, <stable-commits@vger.kernel.org>
From: <gregkh@suse.de>
Date: Wed, 16 Sep 2009 14:45:19 -0700
In-Reply-To: <37219a840909120731j1166b2b0r8c51dc7ba8dbea6a@mail.gmail.com>
Message-Id: <20090916214536.0D0C1489B2@coco.kroah.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


This is a note to let you know that we have just queued up the patch titled

    Subject: V4L: em28xx: set up tda9887_conf in em28xx_card_setup()

to the 2.6.30-stable tree.  Its filename is

    v4l-em28xx-set-up-tda9887_conf-in-em28xx_card_setup.patch

A git repo of this tree can be found at 
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary


>From mkrufky@linuxtv.org  Wed Sep 16 14:36:28 2009
From: Michael Krufky <mkrufky@linuxtv.org>
Date: Sat, 12 Sep 2009 10:31:05 -0400
Subject: V4L: em28xx: set up tda9887_conf in em28xx_card_setup()
To: stable@kernel.org
Cc: Larry Finger <Larry.Finger@lwfinger.net>, linux-media <linux-media@vger.kernel.org>, Mauro Carvalho Chehab <mchehab@redhat.com>, Douglas Schilling Landgraf <dougsland@redhat.com>, Franklin Meng <fmeng2002@yahoo.com>
Message-ID: <37219a840909120731j1166b2b0r8c51dc7ba8dbea6a@mail.gmail.com>

From: Franklin Meng <fmeng2002@yahoo.com>

V4L: em28xx: set up tda9887_conf in em28xx_card_setup()

(cherry picked from commit ae3340cbf59ea362c2016eea762456cc0969fd9e)

Added tda9887_conf set up into em28xx_card_setup()

Signed-off-by: Franklin Meng <fmeng2002@yahoo.com>
Signed-off-by: Douglas Schilling Landgraf <dougsland@redhat.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Tested-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/em28xx/em28xx-cards.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/media/video/em28xx/em28xx-cards.c
+++ b/drivers/media/video/em28xx/em28xx-cards.c
@@ -1886,6 +1886,9 @@ void em28xx_card_setup(struct em28xx *de
 	if (em28xx_boards[dev->model].tuner_addr)
 		dev->tuner_addr = em28xx_boards[dev->model].tuner_addr;
 
+	if (em28xx_boards[dev->model].tda9887_conf)
+		dev->tda9887_conf = em28xx_boards[dev->model].tda9887_conf;
+
 	/* request some modules */
 	switch (dev->model) {
 	case EM2820_BOARD_HAUPPAUGE_WINTV_USB_2:


Patches currently in stable-queue which might be from mkrufky@linuxtv.org are

queue-2.6.30/v4l-em28xx-set-up-tda9887_conf-in-em28xx_card_setup.patch
