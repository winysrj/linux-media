Return-path: <linux-media-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:57922 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753211Ab0BIXQI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Feb 2010 18:16:08 -0500
Date: Tue, 9 Feb 2010 15:16:03 -0800
From: Greg KH <gregkh@suse.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Matthias Schwarzott <zzam@gentoo.org>,
	Douglas Schilling Landgraf <dougsland@redhat.com>,
	Andreas Oberritter <obi@linuxtv.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andreas Gruenbacher <agruen@suse.de>
Subject: [PATCH] dvb: l64781.ko broken with gcc 4.5
Message-ID: <20100209231603.GA22588@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Richard Guenther <rguenther@suse.de>

I'm trying to fix it on the GCC side (PR43007), but the module is
quite stupid in using ULL constants to operate on u32 values:

static int apply_frontend_param (struct dvb_frontend* fe, struct
dvb_frontend_parameters *param)
{
...
 static const u32 ppm = 8000;
 u32 spi_bias;
...

 spi_bias *= 1000ULL;
 spi_bias /= 1000ULL + ppm/1000;


which causes current GCC 4.5 to emit calls to __udivdi3 for i?86 again.

This patch fixes this issue.

Signed-off-by: Richard Guenther <rguenther@suse.de>
Cc: Andreas Gruenbacher <agruen@suse.de>
Cc: stable <stable@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Matthias Schwarzott <zzam@gentoo.org>
Cc: Douglas Schilling Landgraf <dougsland@redhat.com>
Cc: Andreas Oberritter <obi@linuxtv.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/dvb/frontends/l64781.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/media/dvb/frontends/l64781.c
+++ b/drivers/media/dvb/frontends/l64781.c
@@ -192,8 +192,8 @@ static int apply_frontend_param (struct
 	spi_bias *= qam_tab[p->constellation];
 	spi_bias /= p->code_rate_HP + 1;
 	spi_bias /= (guard_tab[p->guard_interval] + 32);
-	spi_bias *= 1000ULL;
-	spi_bias /= 1000ULL + ppm/1000;
+	spi_bias *= 1000;
+	spi_bias /= 1000 + ppm/1000;
 	spi_bias *= p->code_rate_HP;
 
 	val0x04 = (p->transmission_mode << 2) | p->guard_interval;
