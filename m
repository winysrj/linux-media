Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7RM4LNO002882
	for <video4linux-list@redhat.com>; Wed, 27 Aug 2008 18:04:21 -0400
Received: from smtp5.pp.htv.fi (smtp5.pp.htv.fi [213.243.153.39])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7RM4HYC003150
	for <video4linux-list@redhat.com>; Wed, 27 Aug 2008 18:04:18 -0400
Date: Thu, 28 Aug 2008 01:03:24 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Steven Toth <stoth@hauppauge.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	v4l-dvb-maintainer@linuxtv.org
Message-ID: <20080827220324.GO11734@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Cc: video4linux-list@redhat.com
Subject: [2.6 patch] tda10048_firmware_upload(): fix a memory leak
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

This patch fixes a memory leak ("fw" wasn't freed).

Reported-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/media/dvb/frontends/tda10048.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

f145212b4721c45be84cf3cbbd765799f5859cab 
diff --git a/drivers/media/dvb/frontends/tda10048.c b/drivers/media/dvb/frontends/tda10048.c
index 0ab8d86..affb29f 100644
--- a/drivers/media/dvb/frontends/tda10048.c
+++ b/drivers/media/dvb/frontends/tda10048.c
@@ -246,121 +246,121 @@ static int tda10048_writeregbulk(struct tda10048_state *state, u8 reg,
 		ret = -ENOMEM;
 		goto error;
 	}
 
 	*buf = reg;
 	memcpy(buf + 1, data, len);
 
 	msg.addr = state->config->demod_address;
 	msg.flags = 0;
 	msg.buf = buf;
 	msg.len = len + 1;
 
 	dprintk(2, "%s():  write len = %d\n",
 		__func__, msg.len);
 
 	ret = i2c_transfer(state->i2c, &msg, 1);
 	if (ret != 1) {
 		printk(KERN_ERR "%s(): writereg error err %i\n",
 			 __func__, ret);
 		ret = -EREMOTEIO;
 	}
 
 error:
 	kfree(buf);
 
 	return ret;
 }
 
 static int tda10048_firmware_upload(struct dvb_frontend *fe)
 {
 	struct tda10048_state *state = fe->demodulator_priv;
 	const struct firmware *fw;
 	int ret;
 	int pos = 0;
 	int cnt;
 	u8 wlen = state->config->fwbulkwritelen;
 
 	if ((wlen != TDA10048_BULKWRITE_200) && (wlen != TDA10048_BULKWRITE_50))
 		wlen = TDA10048_BULKWRITE_200;
 
 	/* request the firmware, this will block and timeout */
 	printk(KERN_INFO "%s: waiting for firmware upload (%s)...\n",
 		__func__,
 		TDA10048_DEFAULT_FIRMWARE);
 
 	ret = request_firmware(&fw, TDA10048_DEFAULT_FIRMWARE,
 		&state->i2c->dev);
 	if (ret) {
 		printk(KERN_ERR "%s: Upload failed. (file not found?)\n",
 			__func__);
 		return -EIO;
 	} else {
 		printk(KERN_INFO "%s: firmware read %Zu bytes.\n",
 			__func__,
 			fw->size);
 		ret = 0;
 	}
 
 	if (fw->size != TDA10048_DEFAULT_FIRMWARE_SIZE) {
 		printk(KERN_ERR "%s: firmware incorrect size\n", __func__);
-		return -EIO;
+		ret = -EIO;
 	} else {
 		printk(KERN_INFO "%s: firmware uploading\n", __func__);
 
 		/* Soft reset */
 		tda10048_writereg(state, TDA10048_CONF_TRISTATE1,
 			tda10048_readreg(state, TDA10048_CONF_TRISTATE1)
 				& 0xfe);
 		tda10048_writereg(state, TDA10048_CONF_TRISTATE1,
 			tda10048_readreg(state, TDA10048_CONF_TRISTATE1)
 				| 0x01);
 
 		/* Put the demod into host download mode */
 		tda10048_writereg(state, TDA10048_CONF_C4_1,
 			tda10048_readreg(state, TDA10048_CONF_C4_1) & 0xf9);
 
 		/* Boot the DSP */
 		tda10048_writereg(state, TDA10048_CONF_C4_1,
 			tda10048_readreg(state, TDA10048_CONF_C4_1) | 0x08);
 
 		/* Prepare for download */
 		tda10048_writereg(state, TDA10048_DSP_CODE_CPT, 0);
 
 		/* Download the firmware payload */
 		while (pos < fw->size) {
 
 			if ((fw->size - pos) > wlen)
 				cnt = wlen;
 			else
 				cnt = fw->size - pos;
 
 			tda10048_writeregbulk(state, TDA10048_DSP_CODE_IN,
 				&fw->data[pos], cnt);
 
 			pos += cnt;
 		}
 
 		ret = -EIO;
 		/* Wait up to 250ms for the DSP to boot */
 		for (cnt = 0; cnt < 250 ; cnt += 10) {
 
 			msleep(10);
 
 			if (tda10048_readreg(state, TDA10048_SYNC_STATUS)
 				& 0x40) {
 				ret = 0;
 				break;
 			}
 		}
 	}
 
 	release_firmware(fw);
 
 	if (ret == 0) {
 		printk(KERN_INFO "%s: firmware uploaded\n", __func__);
 		state->fwloaded = 1;
 	} else
 		printk(KERN_ERR "%s: firmware upload failed\n", __func__);
 
 	return ret;
 }

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
