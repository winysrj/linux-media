Return-path: <linux-media-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:40981 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760074AbZIPWcp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Sep 2009 18:32:45 -0400
Message-Id: <20090916222904.181440643@mini.kroah.org>
Date: Wed, 16 Sep 2009 15:28:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-media <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Douglas Schilling Landgraf <dougsland@redhat.com>,
	Franklin Meng <fmeng2002@yahoo.com>,
	Michael Krufky <mkrufky@linuxtv.org>
Subject: [patch 20/24] V4L: em28xx: set up tda9887_conf in em28xx_card_setup()
References: <20090916222819.244332644@mini.kroah.org>
Content-Disposition: inline; filename=v4l-em28xx-set-up-tda9887_conf-in-em28xx_card_setup.patch
In-Reply-To: <20090916222934.GA31846@kroah.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
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


