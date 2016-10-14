Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59052 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756259AbcJNUWn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 16:22:43 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Malcolm Priestley <tvboxspy@gmail.com>,
        Michael Ira Krufky <mkrufky@linuxtv.org>,
        Olli Salonen <olli.salonen@iki.fi>,
        Abhilash Jindal <klock.android@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH 02/57] [media] dvb-frontends: don't break long lines
Date: Fri, 14 Oct 2016 17:19:50 -0300
Message-Id: <b667d2ed1ecfba34b3cca99a891978bc14d21bf3.1476475771.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476475770.git.mchehab@s-opensource.com>
References: <cover.1476475770.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476475770.git.mchehab@s-opensource.com>
References: <cover.1476475770.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Due to the 80-cols checkpatch warnings, several strings
were broken into multiple lines. This is not considered
a good practice anymore, as it makes harder to grep for
strings at the source code. So, join those continuation
lines.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-frontends/au8522_common.c |  4 ++--
 drivers/media/dvb-frontends/cx24110.c       |  4 ++--
 drivers/media/dvb-frontends/cx24113.c       |  4 ++--
 drivers/media/dvb-frontends/cx24116.c       | 10 +++++-----
 drivers/media/dvb-frontends/cx24117.c       |  4 ++--
 drivers/media/dvb-frontends/cx24123.c       |  4 ++--
 drivers/media/dvb-frontends/ds3000.c        | 15 +++++++--------
 drivers/media/dvb-frontends/lgdt330x.c      |  3 +--
 drivers/media/dvb-frontends/m88rs2000.c     | 11 +++++------
 drivers/media/dvb-frontends/mt312.c         |  7 +++----
 drivers/media/dvb-frontends/nxt200x.c       | 11 +++++------
 drivers/media/dvb-frontends/or51132.c       |  6 ++----
 drivers/media/dvb-frontends/or51211.c       |  3 +--
 drivers/media/dvb-frontends/s5h1409.c       |  4 ++--
 drivers/media/dvb-frontends/s5h1411.c       |  4 ++--
 drivers/media/dvb-frontends/s5h1432.c       |  4 ++--
 drivers/media/dvb-frontends/s921.c          |  4 ++--
 drivers/media/dvb-frontends/si21xx.c        |  8 ++++----
 drivers/media/dvb-frontends/sp887x.c        |  3 +--
 drivers/media/dvb-frontends/stv0288.c       | 11 +++++------
 drivers/media/dvb-frontends/stv0297.c       |  4 ++--
 drivers/media/dvb-frontends/stv0299.c       |  7 +++----
 drivers/media/dvb-frontends/stv0900_sw.c    |  3 +--
 drivers/media/dvb-frontends/tda10021.c      |  3 +--
 drivers/media/dvb-frontends/tda10023.c      |  6 ++----
 drivers/media/dvb-frontends/tda10048.c      | 12 ++++--------
 drivers/media/dvb-frontends/ves1820.c       |  8 ++++----
 drivers/media/dvb-frontends/zl10036.c       |  4 ++--
 drivers/media/dvb-frontends/zl10039.c       |  3 +--
 29 files changed, 77 insertions(+), 97 deletions(-)

diff --git a/drivers/media/dvb-frontends/au8522_common.c b/drivers/media/dvb-frontends/au8522_common.c
index f135126bc373..cf4ac240a01f 100644
--- a/drivers/media/dvb-frontends/au8522_common.c
+++ b/drivers/media/dvb-frontends/au8522_common.c
@@ -50,8 +50,8 @@ int au8522_writereg(struct au8522_state *state, u16 reg, u8 data)
 	ret = i2c_transfer(state->i2c, &msg, 1);
 
 	if (ret != 1)
-		printk("%s: writereg error (reg == 0x%02x, val == 0x%04x, "
-		       "ret == %i)\n", __func__, reg, data, ret);
+		printk("%s: writereg error (reg == 0x%02x, val == 0x%04x, ret == %i)\n",
+		       __func__, reg, data, ret);
 
 	return (ret != 1) ? -1 : 0;
 }
diff --git a/drivers/media/dvb-frontends/cx24110.c b/drivers/media/dvb-frontends/cx24110.c
index 6cb81ec12847..92a08c7bf794 100644
--- a/drivers/media/dvb-frontends/cx24110.c
+++ b/drivers/media/dvb-frontends/cx24110.c
@@ -120,8 +120,8 @@ static int cx24110_writereg (struct cx24110_state* state, int reg, int data)
 	int err;
 
 	if ((err = i2c_transfer(state->i2c, &msg, 1)) != 1) {
-		dprintk ("%s: writereg error (err == %i, reg == 0x%02x,"
-			 " data == 0x%02x)\n", __func__, err, reg, data);
+		dprintk("%s: writereg error (err == %i, reg == 0x%02x, data == 0x%02x)\n",
+			__func__, err, reg, data);
 		return -EREMOTEIO;
 	}
 
diff --git a/drivers/media/dvb-frontends/cx24113.c b/drivers/media/dvb-frontends/cx24113.c
index 3883c3b31aef..3812ef8cac08 100644
--- a/drivers/media/dvb-frontends/cx24113.c
+++ b/drivers/media/dvb-frontends/cx24113.c
@@ -108,8 +108,8 @@ static int cx24113_writereg(struct cx24113_state *state, int reg, int data)
 		.flags = 0, .buf = buf, .len = 2 };
 	int err = i2c_transfer(state->i2c, &msg, 1);
 	if (err != 1) {
-		printk(KERN_DEBUG "%s: writereg error(err == %i, reg == 0x%02x,"
-			 " data == 0x%02x)\n", __func__, err, reg, data);
+		printk(KERN_DEBUG "%s: writereg error(err == %i, reg == 0x%02x, data == 0x%02x)\n",
+		       __func__, err, reg, data);
 		return err;
 	}
 
diff --git a/drivers/media/dvb-frontends/cx24116.c b/drivers/media/dvb-frontends/cx24116.c
index 8814f36d53fb..b652963df103 100644
--- a/drivers/media/dvb-frontends/cx24116.c
+++ b/drivers/media/dvb-frontends/cx24116.c
@@ -209,8 +209,8 @@ static int cx24116_writereg(struct cx24116_state *state, int reg, int data)
 
 	err = i2c_transfer(state->i2c, &msg, 1);
 	if (err != 1) {
-		printk(KERN_ERR "%s: writereg error(err == %i, reg == 0x%02x,"
-			 " value == 0x%02x)\n", __func__, err, reg, data);
+		printk(KERN_ERR "%s: writereg error(err == %i, reg == 0x%02x, value == 0x%02x)\n",
+		       __func__, err, reg, data);
 		return -EREMOTEIO;
 	}
 
@@ -498,8 +498,8 @@ static int cx24116_firmware_ondemand(struct dvb_frontend *fe)
 		printk(KERN_INFO "%s: Waiting for firmware upload(2)...\n",
 			__func__);
 		if (ret) {
-			printk(KERN_ERR "%s: No firmware uploaded "
-				"(timeout or file not found?)\n", __func__);
+			printk(KERN_ERR "%s: No firmware uploaded (timeout or file not found?)\n",
+			       __func__);
 			return ret;
 		}
 
@@ -967,7 +967,7 @@ static int cx24116_send_diseqc_msg(struct dvb_frontend *fe,
 
 	/* Validate length */
 	if (d->msg_len > sizeof(d->msg))
-                return -EINVAL;
+		return -EINVAL;
 
 	/* Dump DiSEqC message */
 	if (debug) {
diff --git a/drivers/media/dvb-frontends/cx24117.c b/drivers/media/dvb-frontends/cx24117.c
index a3f7eb4e609d..0e757be1c50d 100644
--- a/drivers/media/dvb-frontends/cx24117.c
+++ b/drivers/media/dvb-frontends/cx24117.c
@@ -474,8 +474,8 @@ static int cx24117_firmware_ondemand(struct dvb_frontend *fe)
 			"%s: Waiting for firmware upload(2)...\n", __func__);
 		if (ret) {
 			dev_err(&state->priv->i2c->dev,
-				"%s: No firmware uploaded "
-				"(timeout or file not found?)\n", __func__);
+				"%s: No firmware uploaded (timeout or file not found?)\n",
+				__func__);
 			return ret;
 		}
 
diff --git a/drivers/media/dvb-frontends/cx24123.c b/drivers/media/dvb-frontends/cx24123.c
index 113b0949408a..b1287de98e86 100644
--- a/drivers/media/dvb-frontends/cx24123.c
+++ b/drivers/media/dvb-frontends/cx24123.c
@@ -255,8 +255,8 @@ static int cx24123_i2c_writereg(struct cx24123_state *state,
 
 	err = i2c_transfer(state->i2c, &msg, 1);
 	if (err != 1) {
-		printk("%s: writereg error(err == %i, reg == 0x%02x,"
-			 " data == 0x%02x)\n", __func__, err, reg, data);
+		printk("%s: writereg error(err == %i, reg == 0x%02x, data == 0x%02x)\n",
+		       __func__, err, reg, data);
 		return err;
 	}
 
diff --git a/drivers/media/dvb-frontends/ds3000.c b/drivers/media/dvb-frontends/ds3000.c
index 447b518e287a..6dc79d4528c2 100644
--- a/drivers/media/dvb-frontends/ds3000.c
+++ b/drivers/media/dvb-frontends/ds3000.c
@@ -248,8 +248,8 @@ static int ds3000_writereg(struct ds3000_state *state, int reg, int data)
 
 	err = i2c_transfer(state->i2c, &msg, 1);
 	if (err != 1) {
-		printk(KERN_ERR "%s: writereg error(err == %i, reg == 0x%02x,"
-			 " value == 0x%02x)\n", __func__, err, reg, data);
+		printk(KERN_ERR "%s: writereg error(err == %i, reg == 0x%02x, value == 0x%02x)\n",
+		       __func__, err, reg, data);
 		return -EREMOTEIO;
 	}
 
@@ -296,8 +296,8 @@ static int ds3000_writeFW(struct ds3000_state *state, int reg,
 
 		ret = i2c_transfer(state->i2c, &msg, 1);
 		if (ret != 1) {
-			printk(KERN_ERR "%s: write error(err == %i, "
-				"reg == 0x%02x\n", __func__, ret, reg);
+			printk(KERN_ERR "%s: write error(err == %i, reg == 0x%02x\n",
+			       __func__, ret, reg);
 			ret = -EREMOTEIO;
 			goto error;
 		}
@@ -364,8 +364,8 @@ static int ds3000_firmware_ondemand(struct dvb_frontend *fe)
 				state->i2c->dev.parent);
 	printk(KERN_INFO "%s: Waiting for firmware upload(2)...\n", __func__);
 	if (ret) {
-		printk(KERN_ERR "%s: No firmware uploaded (timeout or file not "
-				"found?)\n", __func__);
+		printk(KERN_ERR "%s: No firmware uploaded (timeout or file not found?)\n",
+		       __func__);
 		return ret;
 	}
 
@@ -1144,8 +1144,7 @@ static struct dvb_frontend_ops ds3000_ops = {
 module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "Activates frontend debugging (default:0)");
 
-MODULE_DESCRIPTION("DVB Frontend module for Montage Technology "
-			"DS3000 hardware");
+MODULE_DESCRIPTION("DVB Frontend module for Montage Technology DS3000 hardware");
 MODULE_AUTHOR("Konstantin Dimitrov <kosio.dimitrov@gmail.com>");
 MODULE_LICENSE("GPL");
 MODULE_FIRMWARE(DS3000_DEFAULT_FIRMWARE);
diff --git a/drivers/media/dvb-frontends/lgdt330x.c b/drivers/media/dvb-frontends/lgdt330x.c
index 96bf254da21e..8cb6c56d220a 100644
--- a/drivers/media/dvb-frontends/lgdt330x.c
+++ b/drivers/media/dvb-frontends/lgdt330x.c
@@ -405,8 +405,7 @@ static int lgdt330x_set_parameters(struct dvb_frontend *fe)
 			return -1;
 		}
 		if (err < 0)
-			printk(KERN_WARNING "lgdt330x: %s: error blasting "
-			       "bytes to lgdt3303 for modulation type(%d)\n",
+			printk(KERN_WARNING "lgdt330x: %s: error blasting bytes to lgdt3303 for modulation type(%d)\n",
 			       __func__, p->modulation);
 
 		/*
diff --git a/drivers/media/dvb-frontends/m88rs2000.c b/drivers/media/dvb-frontends/m88rs2000.c
index ef79a4ec31e2..3669c906ba01 100644
--- a/drivers/media/dvb-frontends/m88rs2000.c
+++ b/drivers/media/dvb-frontends/m88rs2000.c
@@ -75,8 +75,8 @@ static int m88rs2000_writereg(struct m88rs2000_state *state,
 	ret = i2c_transfer(state->i2c, &msg, 1);
 
 	if (ret != 1)
-		deb_info("%s: writereg error (reg == 0x%02x, val == 0x%02x, "
-			"ret == %i)\n", __func__, reg, data, ret);
+		deb_info("%s: writereg error (reg == 0x%02x, val == 0x%02x, ret == %i)\n",
+			 __func__, reg, data, ret);
 
 	return (ret != 1) ? -EREMOTEIO : 0;
 }
@@ -618,10 +618,9 @@ static int m88rs2000_set_frontend(struct dvb_frontend *fe)
 	state->no_lock_count = 0;
 
 	if (c->delivery_system != SYS_DVBS) {
-			deb_info("%s: unsupported delivery "
-				"system selected (%d)\n",
-				__func__, c->delivery_system);
-			return -EOPNOTSUPP;
+		deb_info("%s: unsupported delivery system selected (%d)\n",
+			 __func__, c->delivery_system);
+		return -EOPNOTSUPP;
 	}
 
 	/* Set Tuner */
diff --git a/drivers/media/dvb-frontends/mt312.c b/drivers/media/dvb-frontends/mt312.c
index fc08429c99b7..fdee75b1b99a 100644
--- a/drivers/media/dvb-frontends/mt312.c
+++ b/drivers/media/dvb-frontends/mt312.c
@@ -457,8 +457,8 @@ static int mt312_read_status(struct dvb_frontend *fe, enum fe_status *s)
 	if (ret < 0)
 		return ret;
 
-	dprintk("QPSK_STAT_H: 0x%02x, QPSK_STAT_L: 0x%02x,"
-		" FEC_STATUS: 0x%02x\n", status[0], status[1], status[2]);
+	dprintk("QPSK_STAT_H: 0x%02x, QPSK_STAT_L: 0x%02x, FEC_STATUS: 0x%02x\n",
+		status[0], status[1], status[2]);
 
 	if (status[0] & 0xc0)
 		*s |= FE_HAS_SIGNAL;	/* signal noise ratio */
@@ -827,8 +827,7 @@ struct dvb_frontend *mt312_attach(const struct mt312_config *config,
 		state->freq_mult = 9;
 		break;
 	default:
-		printk(KERN_WARNING "Only Zarlink VP310/MT312/ZL10313"
-			" are supported chips.\n");
+		printk(KERN_WARNING "Only Zarlink VP310/MT312/ZL10313 are supported chips.\n");
 		goto error;
 	}
 
diff --git a/drivers/media/dvb-frontends/nxt200x.c b/drivers/media/dvb-frontends/nxt200x.c
index 79c3040912ab..7c23f0499f23 100644
--- a/drivers/media/dvb-frontends/nxt200x.c
+++ b/drivers/media/dvb-frontends/nxt200x.c
@@ -289,8 +289,7 @@ static void nxt200x_microcontroller_stop (struct nxt200x_state* state)
 		counter++;
 	}
 
-	pr_warn("Timeout waiting for nxt200x to stop. This is ok after "
-		"firmware upload.\n");
+	pr_warn("Timeout waiting for nxt200x to stop. This is ok after firmware upload.\n");
 	return;
 }
 
@@ -893,8 +892,8 @@ static int nxt2002_init(struct dvb_frontend* fe)
 			       state->i2c->dev.parent);
 	pr_debug("%s: Waiting for firmware upload(2)...\n", __func__);
 	if (ret) {
-		pr_err("%s: No firmware uploaded (timeout or file not found?)"
-		       "\n", __func__);
+		pr_err("%s: No firmware uploaded (timeout or file not found?)\n",
+		       __func__);
 		return ret;
 	}
 
@@ -960,8 +959,8 @@ static int nxt2004_init(struct dvb_frontend* fe)
 			       state->i2c->dev.parent);
 	pr_debug("%s: Waiting for firmware upload(2)...\n", __func__);
 	if (ret) {
-		pr_err("%s: No firmware uploaded (timeout or file not found?)"
-		       "\n", __func__);
+		pr_err("%s: No firmware uploaded (timeout or file not found?)\n",
+		       __func__);
 		return ret;
 	}
 
diff --git a/drivers/media/dvb-frontends/or51132.c b/drivers/media/dvb-frontends/or51132.c
index a165af990672..bacea20822ea 100644
--- a/drivers/media/dvb-frontends/or51132.c
+++ b/drivers/media/dvb-frontends/or51132.c
@@ -342,15 +342,13 @@ static int or51132_set_parameters(struct dvb_frontend *fe)
 		       fwname);
 		ret = request_firmware(&fw, fwname, state->i2c->dev.parent);
 		if (ret) {
-			printk(KERN_WARNING "or51132: No firmware up"
-			       "loaded(timeout or file not found?)\n");
+			printk(KERN_WARNING "or51132: No firmware uploaded(timeout or file not found?)\n");
 			return ret;
 		}
 		ret = or51132_load_firmware(fe, fw);
 		release_firmware(fw);
 		if (ret) {
-			printk(KERN_WARNING "or51132: Writing firmware to "
-			       "device failed!\n");
+			printk(KERN_WARNING "or51132: Writing firmware to device failed!\n");
 			return ret;
 		}
 		printk("or51132: Firmware upload complete.\n");
diff --git a/drivers/media/dvb-frontends/or51211.c b/drivers/media/dvb-frontends/or51211.c
index e82413b975e6..839479eab3b3 100644
--- a/drivers/media/dvb-frontends/or51211.c
+++ b/drivers/media/dvb-frontends/or51211.c
@@ -377,8 +377,7 @@ static int or51211_init(struct dvb_frontend* fe)
 					       OR51211_DEFAULT_FIRMWARE);
 		pr_info("Got Hotplug firmware\n");
 		if (ret) {
-			pr_warn("No firmware uploaded "
-				"(timeout or file not found?)\n");
+			pr_warn("No firmware uploaded (timeout or file not found?)\n");
 			return ret;
 		}
 
diff --git a/drivers/media/dvb-frontends/s5h1409.c b/drivers/media/dvb-frontends/s5h1409.c
index c68965ad97c0..56c3fb442d6c 100644
--- a/drivers/media/dvb-frontends/s5h1409.c
+++ b/drivers/media/dvb-frontends/s5h1409.c
@@ -321,8 +321,8 @@ static int s5h1409_writereg(struct s5h1409_state *state, u8 reg, u16 data)
 	ret = i2c_transfer(state->i2c, &msg, 1);
 
 	if (ret != 1)
-		printk(KERN_ERR "%s: error (reg == 0x%02x, val == 0x%04x, "
-		       "ret == %i)\n", __func__, reg, data, ret);
+		printk(KERN_ERR "%s: error (reg == 0x%02x, val == 0x%04x, ret == %i)\n",
+		       __func__, reg, data, ret);
 
 	return (ret != 1) ? -1 : 0;
 }
diff --git a/drivers/media/dvb-frontends/s5h1411.c b/drivers/media/dvb-frontends/s5h1411.c
index 90f86e82b087..a861854981b7 100644
--- a/drivers/media/dvb-frontends/s5h1411.c
+++ b/drivers/media/dvb-frontends/s5h1411.c
@@ -350,8 +350,8 @@ static int s5h1411_writereg(struct s5h1411_state *state,
 	ret = i2c_transfer(state->i2c, &msg, 1);
 
 	if (ret != 1)
-		printk(KERN_ERR "%s: writereg error 0x%02x 0x%02x 0x%04x, "
-		       "ret == %i)\n", __func__, addr, reg, data, ret);
+		printk(KERN_ERR "%s: writereg error 0x%02x 0x%02x 0x%04x, ret == %i)\n",
+		       __func__, addr, reg, data, ret);
 
 	return (ret != 1) ? -1 : 0;
 }
diff --git a/drivers/media/dvb-frontends/s5h1432.c b/drivers/media/dvb-frontends/s5h1432.c
index 4215652f8eb7..5de79739cf63 100644
--- a/drivers/media/dvb-frontends/s5h1432.c
+++ b/drivers/media/dvb-frontends/s5h1432.c
@@ -63,8 +63,8 @@ static int s5h1432_writereg(struct s5h1432_state *state,
 	ret = i2c_transfer(state->i2c, &msg, 1);
 
 	if (ret != 1)
-		printk(KERN_ERR "%s: writereg error 0x%02x 0x%02x 0x%04x, "
-		       "ret == %i)\n", __func__, addr, reg, data, ret);
+		printk(KERN_ERR "%s: writereg error 0x%02x 0x%02x 0x%04x, ret == %i)\n",
+		       __func__, addr, reg, data, ret);
 
 	return (ret != 1) ? -1 : 0;
 }
diff --git a/drivers/media/dvb-frontends/s921.c b/drivers/media/dvb-frontends/s921.c
index b5e3d90eba5e..98cceb149b91 100644
--- a/drivers/media/dvb-frontends/s921.c
+++ b/drivers/media/dvb-frontends/s921.c
@@ -214,8 +214,8 @@ static int s921_i2c_writereg(struct s921_state *state,
 
 	rc = i2c_transfer(state->i2c, &msg, 1);
 	if (rc != 1) {
-		printk("%s: writereg rcor(rc == %i, reg == 0x%02x,"
-			 " data == 0x%02x)\n", __func__, rc, reg, data);
+		printk("%s: writereg rcor(rc == %i, reg == 0x%02x, data == 0x%02x)\n",
+		       __func__, rc, reg, data);
 		return rc;
 	}
 
diff --git a/drivers/media/dvb-frontends/si21xx.c b/drivers/media/dvb-frontends/si21xx.c
index 62ad7a7be9f8..61e44fd88271 100644
--- a/drivers/media/dvb-frontends/si21xx.c
+++ b/drivers/media/dvb-frontends/si21xx.c
@@ -245,8 +245,8 @@ static int si21_writeregs(struct si21xx_state *state, u8 reg1,
 	ret = i2c_transfer(state->i2c, &msg, 1);
 
 	if (ret != 1)
-		dprintk("%s: writereg error (reg1 == 0x%02x, data == 0x%02x, "
-			"ret == %i)\n", __func__, reg1, data[0], ret);
+		dprintk("%s: writereg error (reg1 == 0x%02x, data == 0x%02x, ret == %i)\n",
+			 __func__, reg1, data[0], ret);
 
 	return (ret != 1) ? -EREMOTEIO : 0;
 }
@@ -265,8 +265,8 @@ static int si21_writereg(struct si21xx_state *state, u8 reg, u8 data)
 	ret = i2c_transfer(state->i2c, &msg, 1);
 
 	if (ret != 1)
-		dprintk("%s: writereg error (reg == 0x%02x, data == 0x%02x, "
-			"ret == %i)\n", __func__, reg, data, ret);
+		dprintk("%s: writereg error (reg == 0x%02x, data == 0x%02x, ret == %i)\n",
+			 __func__, reg, data, ret);
 
 	return (ret != 1) ? -EREMOTEIO : 0;
 }
diff --git a/drivers/media/dvb-frontends/sp887x.c b/drivers/media/dvb-frontends/sp887x.c
index 4378fe1b978e..f9194b7b7fec 100644
--- a/drivers/media/dvb-frontends/sp887x.c
+++ b/drivers/media/dvb-frontends/sp887x.c
@@ -63,8 +63,7 @@ static int sp887x_writereg (struct sp887x_state* state, u16 reg, u16 data)
 		if (!(reg == 0xf1a && data == 0x000 &&
 			(ret == -EREMOTEIO || ret == -EFAULT)))
 		{
-			printk("%s: writereg error "
-			       "(reg %03x, data %03x, ret == %i)\n",
+			printk("%s: writereg error (reg %03x, data %03x, ret == %i)\n",
 			       __func__, reg & 0xffff, data & 0xffff, ret);
 			return ret;
 		}
diff --git a/drivers/media/dvb-frontends/stv0288.c b/drivers/media/dvb-frontends/stv0288.c
index c93d9a45f7f7..12f6a4205e3e 100644
--- a/drivers/media/dvb-frontends/stv0288.c
+++ b/drivers/media/dvb-frontends/stv0288.c
@@ -74,8 +74,8 @@ static int stv0288_writeregI(struct stv0288_state *state, u8 reg, u8 data)
 	ret = i2c_transfer(state->i2c, &msg, 1);
 
 	if (ret != 1)
-		dprintk("%s: writereg error (reg == 0x%02x, val == 0x%02x, "
-			"ret == %i)\n", __func__, reg, data, ret);
+		dprintk("%s: writereg error (reg == 0x%02x, val == 0x%02x, ret == %i)\n",
+			__func__, reg, data, ret);
 
 	return (ret != 1) ? -EREMOTEIO : 0;
 }
@@ -465,10 +465,9 @@ static int stv0288_set_frontend(struct dvb_frontend *fe)
 	dprintk("%s : FE_SET_FRONTEND\n", __func__);
 
 	if (c->delivery_system != SYS_DVBS) {
-			dprintk("%s: unsupported delivery "
-				"system selected (%d)\n",
-				__func__, c->delivery_system);
-			return -EOPNOTSUPP;
+		dprintk("%s: unsupported delivery system selected (%d)\n",
+			__func__, c->delivery_system);
+		return -EOPNOTSUPP;
 	}
 
 	if (state->config->set_ts_params)
diff --git a/drivers/media/dvb-frontends/stv0297.c b/drivers/media/dvb-frontends/stv0297.c
index 81b27b7c0c96..73b4d4243b74 100644
--- a/drivers/media/dvb-frontends/stv0297.c
+++ b/drivers/media/dvb-frontends/stv0297.c
@@ -57,8 +57,8 @@ static int stv0297_writereg(struct stv0297_state *state, u8 reg, u8 data)
 	ret = i2c_transfer(state->i2c, &msg, 1);
 
 	if (ret != 1)
-		dprintk("%s: writereg error (reg == 0x%02x, val == 0x%02x, "
-			"ret == %i)\n", __func__, reg, data, ret);
+		dprintk("%s: writereg error (reg == 0x%02x, val == 0x%02x, ret == %i)\n",
+			__func__, reg, data, ret);
 
 	return (ret != 1) ? -1 : 0;
 }
diff --git a/drivers/media/dvb-frontends/stv0299.c b/drivers/media/dvb-frontends/stv0299.c
index 7927fa925f2f..a9b28ceb80d8 100644
--- a/drivers/media/dvb-frontends/stv0299.c
+++ b/drivers/media/dvb-frontends/stv0299.c
@@ -88,8 +88,8 @@ static int stv0299_writeregI (struct stv0299_state* state, u8 reg, u8 data)
 	ret = i2c_transfer (state->i2c, &msg, 1);
 
 	if (ret != 1)
-		dprintk("%s: writereg error (reg == 0x%02x, val == 0x%02x, "
-			"ret == %i)\n", __func__, reg, data, ret);
+		dprintk("%s: writereg error (reg == 0x%02x, val == 0x%02x, ret == %i)\n",
+			__func__, reg, data, ret);
 
 	return (ret != 1) ? -EREMOTEIO : 0;
 }
@@ -761,8 +761,7 @@ module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "Turn on/off frontend debugging (default:off).");
 
 MODULE_DESCRIPTION("ST STV0299 DVB Demodulator driver");
-MODULE_AUTHOR("Ralph Metzler, Holger Waechtler, Peter Schildmann, Felix Domke, "
-	      "Andreas Oberritter, Andrew de Quincey, Kenneth Aafly");
+MODULE_AUTHOR("Ralph Metzler, Holger Waechtler, Peter Schildmann, Felix Domke, Andreas Oberritter, Andrew de Quincey, Kenneth Aafly");
 MODULE_LICENSE("GPL");
 
 EXPORT_SYMBOL(stv0299_attach);
diff --git a/drivers/media/dvb-frontends/stv0900_sw.c b/drivers/media/dvb-frontends/stv0900_sw.c
index fa63a9e929ce..bded82774f4b 100644
--- a/drivers/media/dvb-frontends/stv0900_sw.c
+++ b/drivers/media/dvb-frontends/stv0900_sw.c
@@ -1485,8 +1485,7 @@ static u32 stv0900_search_srate_coarse(struct dvb_frontend *fe)
 		current_step++;
 		direction *= -1;
 
-		dprintk("lock: I2C_DEMOD_MODE_FIELD =0. Search started."
-			" tuner freq=%d agc2=0x%x srate_coarse=%d tmg_cpt=%d\n",
+		dprintk("lock: I2C_DEMOD_MODE_FIELD =0. Search started. tuner freq=%d agc2=0x%x srate_coarse=%d tmg_cpt=%d\n",
 			tuner_freq, agc2_integr, coarse_srate, timingcpt);
 
 		if ((timingcpt >= 5) &&
diff --git a/drivers/media/dvb-frontends/tda10021.c b/drivers/media/dvb-frontends/tda10021.c
index 806c56691ca5..4c514e6bffda 100644
--- a/drivers/media/dvb-frontends/tda10021.c
+++ b/drivers/media/dvb-frontends/tda10021.c
@@ -77,8 +77,7 @@ static int _tda10021_writereg (struct tda10021_state* state, u8 reg, u8 data)
 
 	ret = i2c_transfer (state->i2c, &msg, 1);
 	if (ret != 1)
-		printk("DVB: TDA10021(%d): %s, writereg error "
-			"(reg == 0x%02x, val == 0x%02x, ret == %i)\n",
+		printk("DVB: TDA10021(%d): %s, writereg error (reg == 0x%02x, val == 0x%02x, ret == %i)\n",
 			state->frontend.dvb->num, __func__, reg, data, ret);
 
 	msleep(10);
diff --git a/drivers/media/dvb-frontends/tda10023.c b/drivers/media/dvb-frontends/tda10023.c
index 3b8c7e499d0d..0c416be76d65 100644
--- a/drivers/media/dvb-frontends/tda10023.c
+++ b/drivers/media/dvb-frontends/tda10023.c
@@ -72,8 +72,7 @@ static u8 tda10023_readreg (struct tda10023_state* state, u8 reg)
 	ret = i2c_transfer (state->i2c, msg, 2);
 	if (ret != 2) {
 		int num = state->frontend.dvb ? state->frontend.dvb->num : -1;
-		printk(KERN_ERR "DVB: TDA10023(%d): %s: readreg error "
-			"(reg == 0x%02x, ret == %i)\n",
+		printk(KERN_ERR "DVB: TDA10023(%d): %s: readreg error (reg == 0x%02x, ret == %i)\n",
 			num, __func__, reg, ret);
 	}
 	return b1[0];
@@ -88,8 +87,7 @@ static int tda10023_writereg (struct tda10023_state* state, u8 reg, u8 data)
 	ret = i2c_transfer (state->i2c, &msg, 1);
 	if (ret != 1) {
 		int num = state->frontend.dvb ? state->frontend.dvb->num : -1;
-		printk(KERN_ERR "DVB: TDA10023(%d): %s, writereg error "
-			"(reg == 0x%02x, val == 0x%02x, ret == %i)\n",
+		printk(KERN_ERR "DVB: TDA10023(%d): %s, writereg error (reg == 0x%02x, val == 0x%02x, ret == %i)\n",
 			num, __func__, reg, data, ret);
 	}
 	return (ret != 1) ? -EREMOTEIO : 0;
diff --git a/drivers/media/dvb-frontends/tda10048.c b/drivers/media/dvb-frontends/tda10048.c
index c2bf89d0b0b0..7cb23f89a03b 100644
--- a/drivers/media/dvb-frontends/tda10048.c
+++ b/drivers/media/dvb-frontends/tda10048.c
@@ -1063,32 +1063,28 @@ static void tda10048_establish_defaults(struct dvb_frontend *fe)
 	/* Validate/default the config */
 	if (config->dtv6_if_freq_khz == 0) {
 		config->dtv6_if_freq_khz = TDA10048_IF_4300;
-		printk(KERN_WARNING "%s() tda10048_config.dtv6_if_freq_khz "
-			"is not set (defaulting to %d)\n",
+		printk(KERN_WARNING "%s() tda10048_config.dtv6_if_freq_khz is not set (defaulting to %d)\n",
 			__func__,
 			config->dtv6_if_freq_khz);
 	}
 
 	if (config->dtv7_if_freq_khz == 0) {
 		config->dtv7_if_freq_khz = TDA10048_IF_4300;
-		printk(KERN_WARNING "%s() tda10048_config.dtv7_if_freq_khz "
-			"is not set (defaulting to %d)\n",
+		printk(KERN_WARNING "%s() tda10048_config.dtv7_if_freq_khz is not set (defaulting to %d)\n",
 			__func__,
 			config->dtv7_if_freq_khz);
 	}
 
 	if (config->dtv8_if_freq_khz == 0) {
 		config->dtv8_if_freq_khz = TDA10048_IF_4300;
-		printk(KERN_WARNING "%s() tda10048_config.dtv8_if_freq_khz "
-			"is not set (defaulting to %d)\n",
+		printk(KERN_WARNING "%s() tda10048_config.dtv8_if_freq_khz is not set (defaulting to %d)\n",
 			__func__,
 			config->dtv8_if_freq_khz);
 	}
 
 	if (config->clk_freq_khz == 0) {
 		config->clk_freq_khz = TDA10048_CLK_16000;
-		printk(KERN_WARNING "%s() tda10048_config.clk_freq_khz "
-			"is not set (defaulting to %d)\n",
+		printk(KERN_WARNING "%s() tda10048_config.clk_freq_khz is not set (defaulting to %d)\n",
 			__func__,
 			config->clk_freq_khz);
 	}
diff --git a/drivers/media/dvb-frontends/ves1820.c b/drivers/media/dvb-frontends/ves1820.c
index b09fe88c40f8..24ac54b3b967 100644
--- a/drivers/media/dvb-frontends/ves1820.c
+++ b/drivers/media/dvb-frontends/ves1820.c
@@ -65,8 +65,8 @@ static int ves1820_writereg(struct ves1820_state *state, u8 reg, u8 data)
 	ret = i2c_transfer(state->i2c, &msg, 1);
 
 	if (ret != 1)
-		printk("ves1820: %s(): writereg error (reg == 0x%02x, "
-			"val == 0x%02x, ret == %i)\n", __func__, reg, data, ret);
+		printk("ves1820: %s(): writereg error (reg == 0x%02x, val == 0x%02x, ret == %i)\n",
+		       __func__, reg, data, ret);
 
 	return (ret != 1) ? -EREMOTEIO : 0;
 }
@@ -84,8 +84,8 @@ static u8 ves1820_readreg(struct ves1820_state *state, u8 reg)
 	ret = i2c_transfer(state->i2c, msg, 2);
 
 	if (ret != 2)
-		printk("ves1820: %s(): readreg error (reg == 0x%02x, "
-		"ret == %i)\n", __func__, reg, ret);
+		printk("ves1820: %s(): readreg error (reg == 0x%02x, ret == %i)\n",
+		       __func__, reg, ret);
 
 	return b1[0];
 }
diff --git a/drivers/media/dvb-frontends/zl10036.c b/drivers/media/dvb-frontends/zl10036.c
index 7ed81315965f..df5d0fe24687 100644
--- a/drivers/media/dvb-frontends/zl10036.c
+++ b/drivers/media/dvb-frontends/zl10036.c
@@ -85,8 +85,8 @@ static int zl10036_read_status_reg(struct zl10036_state *state)
 	deb_i2c("R(status): %02x  [FL=%d]\n", status,
 		(status & STATUS_FL) ? 1 : 0);
 	if (status & STATUS_POR)
-		deb_info("%s: Power-On-Reset bit enabled - "
-			"need to initialize the tuner\n", __func__);
+		deb_info("%s: Power-On-Reset bit enabled - need to initialize the tuner\n",
+			 __func__);
 
 	return status;
 }
diff --git a/drivers/media/dvb-frontends/zl10039.c b/drivers/media/dvb-frontends/zl10039.c
index f8c271be196c..d6ded11fee49 100644
--- a/drivers/media/dvb-frontends/zl10039.c
+++ b/drivers/media/dvb-frontends/zl10039.c
@@ -152,8 +152,7 @@ static int zl10039_init(struct dvb_frontend *fe)
 	/* Reset logic */
 	ret = zl10039_writereg(state, GENERAL, 0x40);
 	if (ret < 0) {
-		dprintk("Note: i2c write error normal when resetting the "
-			"tuner\n");
+		dprintk("Note: i2c write error normal when resetting the tuner\n");
 	}
 	/* Wake up */
 	ret = zl10039_writereg(state, GENERAL, 0x01);
-- 
2.7.4


