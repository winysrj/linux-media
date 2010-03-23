Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:3971 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024Ab0CWLkx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Mar 2010 07:40:53 -0400
Date: Tue, 23 Mar 2010 14:40:43 +0300
From: Dan Carpenter <error27@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Douglas Schilling Landgraf <dougsland@redhat.com>,
	Robert Krakora <rob.krakora@messagenetsystems.com>,
	Nicola Soranzo <nsoranzo@tiscali.it>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [patch v2] em28xx: "Empia Em28xx Audio" too long
Message-ID: <20100323114043.GY21571@bicker>
References: <20100319114825.GO5331@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100319114825.GO5331@bicker>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

card->driver is 15 characters and a NULL.  The original code
goes past the end of the array.

Signed-off-by: Dan Carpenter <error27@gmail.com>
---
V2:  Takashi Iwai asked me to change the space to a hyphen since this is 
used as an identifier in alsa-lib.

diff --git a/drivers/media/video/em28xx/em28xx-audio.c b/drivers/media/video/em28xx/em28xx-audio.c
index bd78338..e182abf 100644
--- a/drivers/media/video/em28xx/em28xx-audio.c
+++ b/drivers/media/video/em28xx/em28xx-audio.c
@@ -491,7 +491,7 @@ static int em28xx_audio_init(struct em28xx *dev)
 	strcpy(pcm->name, "Empia 28xx Capture");
 
 	snd_card_set_dev(card, &dev->udev->dev);
-	strcpy(card->driver, "Empia Em28xx Audio");
+	strcpy(card->driver, "Em28xx-Audio");
 	strcpy(card->shortname, "Em28xx Audio");
 	strcpy(card->longname, "Empia Em28xx Audio");
 
