Return-path: <linux-media-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:59939 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752787AbeFTLBn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Jun 2018 07:01:43 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-usb@vger.kernel.org, tglx@linutronix.de,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 23/27] media: usbtv: use irqsave() in USB's complete callback
Date: Wed, 20 Jun 2018 13:01:01 +0200
Message-Id: <20180620110105.19955-24-bigeasy@linutronix.de>
In-Reply-To: <20180620110105.19955-1-bigeasy@linutronix.de>
References: <20180620110105.19955-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The USB completion callback does not disable interrupts while acquiring
the lock. We want to remove the local_irq_disable() invocation from
__usb_hcd_giveback_urb() and therefore it is required for the callback
handler to disable the interrupts while acquiring the lock.
The callback may be invoked either in IRQ or BH context depending on the
USB host controller.
Use the _irqsave() variant of the locking primitives.

Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/media/usb/usbtv/usbtv-audio.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/usbtv/usbtv-audio.c b/drivers/media/usb/usbt=
v/usbtv-audio.c
index 2c2ca77fa01f..4ce38246ed64 100644
--- a/drivers/media/usb/usbtv/usbtv-audio.c
+++ b/drivers/media/usb/usbtv/usbtv-audio.c
@@ -126,6 +126,7 @@ static void usbtv_audio_urb_received(struct urb *urb)
 	struct snd_pcm_runtime *runtime =3D substream->runtime;
 	size_t i, frame_bytes, chunk_length, buffer_pos, period_pos;
 	int period_elapsed;
+	unsigned long flags;
 	void *urb_current;
=20
 	switch (urb->status) {
@@ -179,12 +180,12 @@ static void usbtv_audio_urb_received(struct urb *urb)
 		}
 	}
=20
-	snd_pcm_stream_lock(substream);
+	snd_pcm_stream_lock_irqsave(substream, flags);
=20
 	chip->snd_buffer_pos =3D buffer_pos;
 	chip->snd_period_pos =3D period_pos;
=20
-	snd_pcm_stream_unlock(substream);
+	snd_pcm_stream_unlock_irqrestore(substream, flags);
=20
 	if (period_elapsed)
 		snd_pcm_period_elapsed(substream);
--=20
2.17.1
