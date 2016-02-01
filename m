Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:39700 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932962AbcBAPIw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Feb 2016 10:08:52 -0500
Date: Mon, 1 Feb 2016 13:08:46 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Alec Leamas <leamas.alec@gmail.com>
Cc: david@hardeman.nu, austin.lund@gmail.com,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] Revert "[media] media/rc: Send sync space information
 on lirc device"
Message-ID: <20160201130846.36eb1cdc@recife.lan>
In-Reply-To: <1453792266-1542-1-git-send-email-leamas.alec@gmail.com>
References: <1453792266-1542-1-git-send-email-leamas.alec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 26 Jan 2016 08:11:06 +0100
Alec Leamas <leamas.alec@gmail.com> escreveu:

> This reverts commit a8f29e89f2b54fbf2c52be341f149bc195b63a8b. This
> commit handled drivers failing to issue a spac which causes sequences
> of mark-mark-space instead of the expected space-mark-space-mark...
> 
> The fix added an extra space for each and every timeout which fixes
> the problem for the failing drivers. However, for existing working
> drivers it  the added space causes mark-space-space sequences in the
> output which break userspace rightfully expecting
> space-mark-space-mark...
> 
> Thus, the fix is broken and reverted. The fix is discussed in
> https://bugzilla.redhat.com/show_bug.cgi?id=1260862. In particular,
> the original committer Austin Lund agrees.

Reverting a patch applied on 3.18 seems very risky as other drivers
may rely on this behavior.

I guess the best thing here would be to detect if a space was
already sent, before sending an extra space at ev.reset, e. g.
something like the following (untested) patch.

Could you please check if it solves the issue?

Thanks,
Mauro

lirc: don't send two space events at reset

The LIRC protocol doesn't expect to receive two space events without
a pulse between them. This doesn't happen on the usual handling, but
ev.reset could cause an extra long space event, with is wrong.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>


diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
index 5effc65d2947..e03ea0091dcd 100644
--- a/drivers/media/rc/ir-lirc-codec.c
+++ b/drivers/media/rc/ir-lirc-codec.c
@@ -39,13 +39,14 @@ static int ir_lirc_decode(struct rc_dev *dev, struct ir_raw_event ev)
 		return -EINVAL;
 
 	/* Packet start */
-	if (ev.reset) {
+	if (ev.reset && lirc->last_ev_is_pulse) {
 		/* Userspace expects a long space event before the start of
 		 * the signal to use as a sync.  This may be done with repeat
 		 * packets and normal samples.  But if a reset has been sent
 		 * then we assume that a long time has passed, so we send a
 		 * space with the maximum time value. */
 		sample = LIRC_SPACE(LIRC_VALUE_MASK);
+		lirc->last_ev_is_pulse = false;
 		IR_dprintk(2, "delivering reset sync space to lirc_dev\n");
 
 	/* Carrier reports */
@@ -84,6 +85,7 @@ static int ir_lirc_decode(struct rc_dev *dev, struct ir_raw_event ev)
 							(u64)LIRC_VALUE_MASK);
 
 			gap_sample = LIRC_SPACE(lirc->gap_duration);
+			lirc->last_ev_is_pulse = false;
 			lirc_buffer_write(dev->raw->lirc.drv->rbuf,
 						(unsigned char *) &gap_sample);
 			lirc->gap = false;
@@ -91,6 +93,8 @@ static int ir_lirc_decode(struct rc_dev *dev, struct ir_raw_event ev)
 
 		sample = ev.pulse ? LIRC_PULSE(ev.duration / 1000) :
 					LIRC_SPACE(ev.duration / 1000);
+		lirc->last_ev_is_pulse = ev.pulse;
+
 		IR_dprintk(2, "delivering %uus %s to lirc_dev\n",
 			   TO_US(ev.duration), TO_STR(ev.pulse));
 	}
diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index 7359f3d03b64..6d9c92e0b7a7 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -108,7 +108,7 @@ struct ir_raw_event_ctrl {
 		u64 gap_duration;
 		bool gap;
 		bool send_timeout_reports;
-
+		bool last_ev_is_pulse;
 	} lirc;
 	struct xmp_dec {
 		int state;
