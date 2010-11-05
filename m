Return-path: <mchehab@gaivota>
Received: from zone0.gcu-squad.org ([212.85.147.21]:7031 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094Ab0KEKfs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Nov 2010 06:35:48 -0400
Date: Fri, 5 Nov 2010 11:35:35 +0100
From: Jean Delvare <khali@linux-fr.org>
To: LMML <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH] V4L/DVB: dibx000_common: Restore i2c algo pointer
Message-ID: <20101105113535.25d0e168@endymion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Commit a90f933507859941c4a58028d7593a80f57895c4 accidentally removed
the piece of code setting the i2c algo pointer. Restore it.

That's what happens when you put two code statements on the same
line...

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
---
Sorry about this, I didn't notice this uncommon construct when writing
the initial patch.

This should go to Linus ASAP.

 drivers/media/dvb/frontends/dibx000_common.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-2.6.37-rc1.orig/drivers/media/dvb/frontends/dibx000_common.c	2010-11-02 09:19:35.000000000 +0100
+++ linux-2.6.37-rc1/drivers/media/dvb/frontends/dibx000_common.c	2010-11-05 11:13:48.000000000 +0100
@@ -130,6 +130,7 @@ static int i2c_adapter_init(struct i2c_a
 			    struct dibx000_i2c_master *mst)
 {
 	strncpy(i2c_adap->name, name, sizeof(i2c_adap->name));
+	i2c_adap->algo = algo;
 	i2c_adap->algo_data = NULL;
 	i2c_set_adapdata(i2c_adap, mst);
 	if (i2c_add_adapter(i2c_adap) < 0)


-- 
Jean Delvare
