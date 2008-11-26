Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp4.pp.htv.fi ([213.243.153.38])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <a.seppala+linux-dvb@gmail.com>) id 1L5PDU-0003JY-C1
	for linux-dvb@linuxtv.org; Wed, 26 Nov 2008 19:34:25 +0100
Message-ID: <492D96AB.9020009@gmail.com>
Date: Wed, 26 Nov 2008 20:34:19 +0200
From: =?ISO-8859-1?Q?Antti_Sepp=E4l=E4?= <a.seppala+linux-dvb@gmail.com>
MIME-Version: 1.0
To: Linux DVB <linux-dvb@linuxtv.org>
Subject: [linux-dvb] [PATCH] Cablestar 2 i2c retries
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hello.

At some point the Flexcop driver was changed to support newer Flexcop cards.
These modifications however broke the detection of Cablestar 2 DVB-C cards.

The reason is that the earlier version of the driver used to retry
unsuccessful i2c operations. The demodulator of Cablestar 2 cards (stv0297)
seems to be very dependent on these retries and adding them back fixes
Cablestar detection.

Signed-off-by: Antti Sepp=E4l=E4 <a.seppala@gmail.com>

diff -r 8aabdabb517c linux/drivers/media/dvb/b2c2/flexcop-fe-tuner.c
--- a/linux/drivers/media/dvb/b2c2/flexcop-fe-tuner.c	Tue Nov 25 14:10:14 2=
008 -0200
+++ b/linux/drivers/media/dvb/b2c2/flexcop-fe-tuner.c	Wed Nov 26 20:05:36 2=
008 +0200
@@ -628,12 +628,14 @@
 	}
 =

 	/* try the cable dvb (stv0297) */
+	fc->fc_i2c_adap[0].no_base_addr =3D 1;
 	fc->fe =3D dvb_attach(stv0297_attach, &alps_tdee4_stv0297_config, i2c);
 	if (fc->fe !=3D NULL) {
 		fc->dev_type =3D FC_CABLE;
 		fc->fe->ops.tuner_ops.set_params =3D alps_tdee4_stv0297_tuner_set_params;
 		goto fe_found;
 	}
+	fc->fc_i2c_adap[0].no_base_addr =3D 0;
 =

 	/* try the sky v2.3 (vp310/Samsung tbdu18132(tsa5059)) */
 	fc->fe =3D dvb_attach(mt312_attach,
diff -r 8aabdabb517c linux/drivers/media/dvb/b2c2/flexcop-i2c.c
--- a/linux/drivers/media/dvb/b2c2/flexcop-i2c.c	Tue Nov 25 14:10:14 2008 -=
0200
+++ b/linux/drivers/media/dvb/b2c2/flexcop-i2c.c	Wed Nov 26 20:05:36 2008 +=
0200
@@ -47,8 +47,12 @@
 	int len =3D r100.tw_sm_c_100.total_bytes, /* remember total_bytes is bufl=
en-1 */
 		ret;
 =

-	r100.tw_sm_c_100.no_base_addr_ack_error =3D i2c->no_base_addr;
 	ret =3D flexcop_i2c_operation(i2c->fc, &r100);
+	if (ret !=3D 0) {
+		deb_i2c("Retrying operation\n");
+		r100.tw_sm_c_100.no_base_addr_ack_error =3D i2c->no_base_addr;
+		ret =3D flexcop_i2c_operation(i2c->fc, &r100);
+	}
 	if (ret !=3D 0) {
 		deb_i2c("read failed. %d\n", ret);
 		return ret;

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
