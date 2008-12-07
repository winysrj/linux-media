Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from yx-out-2324.google.com ([74.125.44.29])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <phaedrus961@googlemail.com>) id 1L97FP-0003tz-TY
	for linux-dvb@linuxtv.org; Sun, 07 Dec 2008 01:11:45 +0100
Received: by yx-out-2324.google.com with SMTP id 8so246562yxg.41
	for <linux-dvb@linuxtv.org>; Sat, 06 Dec 2008 16:11:39 -0800 (PST)
Message-ID: <303162d70812061611p92bffcfr821daa823525b1f5@mail.gmail.com>
Date: Sat, 6 Dec 2008 17:11:39 -0700
From: "Frank Dischner" <phaedrus961@googlemail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] [PATCH] Add QAM64 support for hvr-950q (au8522)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi,

The hvr-950q can't tune any qam64 channels, because it uses the qam256
modulation table for both qam64/256. This patch adds the qam64
modulation table to the au8522 driver. I got the numbers from sniffing
the windows driver so I can't be sure they're correct, but it 'works
for me'.

Frank


Signed-off-by: Frank Dischner <phaedrus961@gmail.con>

--- linux/drivers/media/dvb/frontends/au8522.c.orig     2008-12-05
09:10:41.000000000 -0700
+++ linux/drivers/media/dvb/frontends/au8522.c  2008-12-05
09:54:29.000000000 -0700
@@ -377,11 +377,90 @@ static struct {
       { 0x8231, 0x13 },
 };

-/* QAM Modulation table */
+/* QAM64 Modulation table */
 static struct {
       u16 reg;
       u16 data;
-} QAM_mod_tab[] = {
+} QAM64_mod_tab[] = {
+       { 0x80a3, 0x09 },
+       { 0x80a4, 0x00 },
+       { 0x8081, 0xc4 },
+       { 0x80a5, 0x40 },
+       { 0x80aa, 0x77 },
+       { 0x80ad, 0x77 },
+       { 0x80a6, 0x67 },
+       { 0x8262, 0x20 },
+       { 0x821c, 0x30 },
+       { 0x80b8, 0x3e },
+       { 0x80b9, 0xf0 },
+       { 0x80ba, 0x01 },
+       { 0x80bb, 0x18 },
+       { 0x80bc, 0x50 },
+       { 0x80bd, 0x00 },
+       { 0x80be, 0xea },
+       { 0x80bf, 0xef },
+       { 0x80c0, 0xfc },
+       { 0x80c1, 0xbd },
+       { 0x80c2, 0x1f },
+       { 0x80c3, 0xfc },
+       { 0x80c4, 0xdd },
+       { 0x80c5, 0xaf },
+       { 0x80c6, 0x00 },
+       { 0x80c7, 0x38 },
+       { 0x80c8, 0x30 },
+       { 0x80c9, 0x05 },
+       { 0x80ca, 0x4a },
+       { 0x80cb, 0xd0 },
+       { 0x80cc, 0x01 },
+       { 0x80cd, 0xd9 },
+       { 0x80ce, 0x6f },
+       { 0x80cf, 0xf9 },
+       { 0x80d0, 0x70 },
+       { 0x80d1, 0xdf },
+       { 0x80d2, 0xf7 },
+       { 0x80d3, 0xc2 },
+       { 0x80d4, 0xdf },
+       { 0x80d5, 0x02 },
+       { 0x80d6, 0x9a },
+       { 0x80d7, 0xd0 },
+       { 0x8250, 0x0d },
+       { 0x8251, 0xcd },
+       { 0x8252, 0xe0 },
+       { 0x8253, 0x05 },
+       { 0x8254, 0xa7 },
+       { 0x8255, 0xff },
+       { 0x8256, 0xed },
+       { 0x8257, 0x5b },
+       { 0x8258, 0xae },
+       { 0x8259, 0xe6 },
+       { 0x825a, 0x3d },
+       { 0x825b, 0x0f },
+       { 0x825c, 0x0d },
+       { 0x825d, 0xea },
+       { 0x825e, 0xf2 },
+       { 0x825f, 0x51 },
+       { 0x8260, 0xf5 },
+       { 0x8261, 0x06 },
+       { 0x821a, 0x00 },
+       { 0x8546, 0x40 },
+       { 0x8210, 0xc7 },
+       { 0x8211, 0xaa },
+       { 0x8212, 0xab },
+       { 0x8213, 0x02 },
+       { 0x8502, 0x00 },
+       { 0x8121, 0x04 },
+       { 0x8122, 0x04 },
+       { 0x852e, 0x10 },
+       { 0x80a4, 0xca },
+       { 0x80a7, 0x40 },
+       { 0x8526, 0x01 },
+};
+
+/* QAM256 Modulation table */
+static struct {
+       u16 reg;
+       u16 data;
+} QAM256_mod_tab[] = {
       { 0x80a3, 0x09 },
       { 0x80a4, 0x00 },
       { 0x8081, 0xc4 },
@@ -474,12 +553,19 @@ static int au8522_enable_modulation(stru
               au8522_set_if(fe, state->config->vsb_if);
               break;
       case QAM_64:
+               dprintk("%s() QAM 64\n", __func__);
+               for (i = 0; i < ARRAY_SIZE(QAM64_mod_tab); i++)
+                       au8522_writereg(state,
+                               QAM64_mod_tab[i].reg,
+                               QAM64_mod_tab[i].data);
+               au8522_set_if(fe, state->config->qam_if);
+               break;
       case QAM_256:
-               dprintk("%s() QAM 64/256\n", __func__);
-               for (i = 0; i < ARRAY_SIZE(QAM_mod_tab); i++)
+               dprintk("%s() QAM 256\n", __func__);
+               for (i = 0; i < ARRAY_SIZE(QAM256_mod_tab); i++)
                       au8522_writereg(state,
-                               QAM_mod_tab[i].reg,
-                               QAM_mod_tab[i].data);
+                               QAM256_mod_tab[i].reg,
+                               QAM256_mod_tab[i].data);
               au8522_set_if(fe, state->config->qam_if);
               break;
       default:

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
