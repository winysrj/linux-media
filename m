Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:4782 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756090Ab3CYLcn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Mar 2013 07:32:43 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [REVIEW PATCH] tuner-core fix for au0828 g_tuner bug
Date: Mon, 25 Mar 2013 12:32:31 +0100
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201303251232.31456.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While testing the au0828 driver overhaul patch series:

http://patchwork.linuxtv.org/patch/17576/

I discovered that the signal strength as reported by VIDIOC_G_TUNER was
always 0. Initially I thought it was related to the i2c gate, but after
testing some more that turned out to be wrong, although it did gave me the
clue that it was related to the order in which subdevs were called. If
the g_tuner op of au8522 was called before that of tuner-core, then it would
fail, if the order was the other way around then it would work.

Some digging in tuner-core clarified it: if the has_signal callback is set,
then tuner-core would call 'vt->signal = analog_ops->has_signal(&t->fe);'.
But has_signal is always filled in, even if the frontend doesn't implement
get_rf_strength, as is the case for the xc5000. And in that case vt->signal
is overwritten with 0.

Solution: don't set the has_signal callback if get_rf_strength is not
supported. Ditto for get_afc.

Regards,

	Hans

-------- patch ----------
If the tuner frontend does not support get_rf_strength, then don't set
the has_signal callback. Ditto for get_afc.

Both callbacks overwrite the signal and afc fields of struct v4l2_tuner
but that should only happen if the tuner can actually detect this. If
it can't, then it should leave those fields alone so other subdevices
can try and detect the signal/afc.

This fixes the bug where the au8522 detected a signal and then tuner-core
overwrote it with 0 since the xc5000 tuner does not support get_rf_strength.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/tuner-core.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/tuner-core.c b/drivers/media/v4l2-core/tuner-core.c
index f775768..dd8a803 100644
--- a/drivers/media/v4l2-core/tuner-core.c
+++ b/drivers/media/v4l2-core/tuner-core.c
@@ -253,7 +253,7 @@ static int fe_set_config(struct dvb_frontend *fe, void *priv_cfg)
 
 static void tuner_status(struct dvb_frontend *fe);
 
-static struct analog_demod_ops tuner_analog_ops = {
+static const struct analog_demod_ops tuner_analog_ops = {
 	.set_params     = fe_set_params,
 	.standby        = fe_standby,
 	.has_signal     = fe_has_signal,
@@ -453,6 +453,11 @@ static void set_type(struct i2c_client *c, unsigned int type,
 		memcpy(analog_ops, &tuner_analog_ops,
 		       sizeof(struct analog_demod_ops));
 
+		if (fe_tuner_ops->get_rf_strength == NULL)
+			analog_ops->has_signal = NULL;
+		if (fe_tuner_ops->get_afc == NULL)
+			analog_ops->get_afc = NULL;
+
 	} else {
 		t->name = analog_ops->info.name;
 	}
-- 
1.7.10.4

