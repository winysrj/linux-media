Return-path: <linux-media-owner@vger.kernel.org>
Received: from co202.xi-lite.net ([149.6.83.202]:46702 "EHLO co202.xi-lite.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751929Ab3BFI7X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Feb 2013 03:59:23 -0500
From: Olivier GRENIE <olivier.grenie@parrot.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: Patrick BOETTCHER <patrick.boettcher@parrot.com>,
	Nickolai Zeldovich <nickolai@csail.mit.edu>
Date: Wed, 6 Feb 2013 09:04:39 +0000
Subject: RE: [git:v4l-dvb/for_v3.9] [media]
 drivers/media/usb/dvb-usb/dib0700_core.c: fix left shift
Message-ID: <C73E570AC040D442A4DD326F39F0F00E27342E2907@SAPHIR.xi-lite.lan>
References: <E1U2pik-000196-0O@www.linuxtv.org>
In-Reply-To: <E1U2pik-000196-0O@www.linuxtv.org>
Content-Language: fr-FR
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro,
I do not agree with the patch. Let's take an example: adap->id = 0. Then:
	* 1 << ~(adap->id) = 1 << ~(0) = 0
	* ~(1 << adap->id) = ~(1 << 0) = 0xFE

The correct change should be: st->channel_state |= 1 << (1 - adap->id); Indeed, the original source code was not correct.

Regards,
Olivier

-----Message d'origine-----
De : Mauro Carvalho Chehab [mailto:mchehab@redhat.com] 
Envoyé : mardi 5 février 2013 22:04
À : linuxtv-commits@linuxtv.org
Cc : Patrick BOETTCHER; Olivier GRENIE; Nickolai Zeldovich
Objet : [git:v4l-dvb/for_v3.9] [media] drivers/media/usb/dvb-usb/dib0700_core.c: fix left shift

This is an automatic generated email to let you know that the following patch were queued at the http://git.linuxtv.org/media_tree.git tree:

Subject: [media] drivers/media/usb/dvb-usb/dib0700_core.c: fix left shift
Author:  Nickolai Zeldovich <nickolai@csail.mit.edu>
Date:    Sat Jan 5 15:13:05 2013 -0300

Fix bug introduced in 7757ddda6f4febbc52342d82440dd4f7a7d4f14f, where instead of bit-negating the bitmask, the bit position was bit-negated instead.

Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
Cc: Olivier Grenie <olivier.grenie@dibcom.fr>
Cc: Patrick Boettcher <patrick.boettcher@dibcom.fr>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

 drivers/media/usb/dvb-usb/dib0700_core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

---

http://git.linuxtv.org/media_tree.git?a=commitdiff;h=7e20f6bfc47992d93b36f4ed068782f8726b75a3

diff --git a/drivers/media/usb/dvb-usb/dib0700_core.c b/drivers/media/usb/dvb-usb/dib0700_core.c
index bf2a908..bd6a437 100644
--- a/drivers/media/usb/dvb-usb/dib0700_core.c
+++ b/drivers/media/usb/dvb-usb/dib0700_core.c
@@ -584,7 +584,7 @@ int dib0700_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
 		if (onoff)
 			st->channel_state |=	1 << (adap->id);
 		else
-			st->channel_state |=	1 << ~(adap->id);
+			st->channel_state &=  ~(1 << (adap->id));
 	} else {
 		if (onoff)
 			st->channel_state |=	1 << (adap->fe_adap[0].stream.props.endpoint-2);
