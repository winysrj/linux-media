Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33433 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751925AbdGWKN1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 23 Jul 2017 06:13:27 -0400
Received: by mail-wm0-f67.google.com with SMTP id 65so11771562wmf.0
        for <linux-media@vger.kernel.org>; Sun, 23 Jul 2017 03:13:26 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: jasmin@anw.at, r.scobie@clear.net.nz
Subject: [PATCH 4/7] [media] dvb-frontends/stv0910: cosmetics: fixup comments, misc
Date: Sun, 23 Jul 2017 12:13:12 +0200
Message-Id: <20170723101315.12523-5-d.scheller.oss@gmail.com>
In-Reply-To: <20170723101315.12523-1-d.scheller.oss@gmail.com>
References: <20170723101315.12523-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Fix up block comment style, whitespaces, c++ style comments et al.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/dvb-frontends/stv0910.c      |  401 +++---
 drivers/media/dvb-frontends/stv0910_regs.h | 1953 ++++++++++++++--------------
 2 files changed, 1181 insertions(+), 1173 deletions(-)

diff --git a/drivers/media/dvb-frontends/stv0910.c b/drivers/media/dvb-frontends/stv0910.c
index 8dc767a118a0..e2162fa8cad6 100644
--- a/drivers/media/dvb-frontends/stv0910.c
+++ b/drivers/media/dvb-frontends/stv0910.c
@@ -208,135 +208,135 @@ static int write_shared_reg(struct stv *state, u16 reg, u8 mask, u8 val)
 }
 
 static struct slookup s1_sn_lookup[] = {
-	{   0,    9242  },  /*C/N=  0dB*/
-	{   5,    9105  },  /*C/N=0.5dB*/
-	{  10,    8950  },  /*C/N=1.0dB*/
-	{  15,    8780  },  /*C/N=1.5dB*/
-	{  20,    8566  },  /*C/N=2.0dB*/
-	{  25,    8366  },  /*C/N=2.5dB*/
-	{  30,    8146  },  /*C/N=3.0dB*/
-	{  35,    7908  },  /*C/N=3.5dB*/
-	{  40,    7666  },  /*C/N=4.0dB*/
-	{  45,    7405  },  /*C/N=4.5dB*/
-	{  50,    7136  },  /*C/N=5.0dB*/
-	{  55,    6861  },  /*C/N=5.5dB*/
-	{  60,    6576  },  /*C/N=6.0dB*/
-	{  65,    6330  },  /*C/N=6.5dB*/
-	{  70,    6048  },  /*C/N=7.0dB*/
-	{  75,    5768  },  /*C/N=7.5dB*/
-	{  80,    5492  },  /*C/N=8.0dB*/
-	{  85,    5224  },  /*C/N=8.5dB*/
-	{  90,    4959  },  /*C/N=9.0dB*/
-	{  95,    4709  },  /*C/N=9.5dB*/
-	{  100,   4467  },  /*C/N=10.0dB*/
-	{  105,   4236  },  /*C/N=10.5dB*/
-	{  110,   4013  },  /*C/N=11.0dB*/
-	{  115,   3800  },  /*C/N=11.5dB*/
-	{  120,   3598  },  /*C/N=12.0dB*/
-	{  125,   3406  },  /*C/N=12.5dB*/
-	{  130,   3225  },  /*C/N=13.0dB*/
-	{  135,   3052  },  /*C/N=13.5dB*/
-	{  140,   2889  },  /*C/N=14.0dB*/
-	{  145,   2733  },  /*C/N=14.5dB*/
-	{  150,   2587  },  /*C/N=15.0dB*/
-	{  160,   2318  },  /*C/N=16.0dB*/
-	{  170,   2077  },  /*C/N=17.0dB*/
-	{  180,   1862  },  /*C/N=18.0dB*/
-	{  190,   1670  },  /*C/N=19.0dB*/
-	{  200,   1499  },  /*C/N=20.0dB*/
-	{  210,   1347  },  /*C/N=21.0dB*/
-	{  220,   1213  },  /*C/N=22.0dB*/
-	{  230,   1095  },  /*C/N=23.0dB*/
-	{  240,    992  },  /*C/N=24.0dB*/
-	{  250,    900  },  /*C/N=25.0dB*/
-	{  260,    826  },  /*C/N=26.0dB*/
-	{  270,    758  },  /*C/N=27.0dB*/
-	{  280,    702  },  /*C/N=28.0dB*/
-	{  290,    653  },  /*C/N=29.0dB*/
-	{  300,    613  },  /*C/N=30.0dB*/
-	{  310,    579  },  /*C/N=31.0dB*/
-	{  320,    550  },  /*C/N=32.0dB*/
-	{  330,    526  },  /*C/N=33.0dB*/
-	{  350,    490  },  /*C/N=33.0dB*/
-	{  400,    445  },  /*C/N=40.0dB*/
-	{  450,    430  },  /*C/N=45.0dB*/
-	{  500,    426  },  /*C/N=50.0dB*/
-	{  510,    425  }   /*C/N=51.0dB*/
+	{   0,    9242  }, /* C/N=   0dB */
+	{   5,    9105  }, /* C/N= 0.5dB */
+	{  10,    8950  }, /* C/N= 1.0dB */
+	{  15,    8780  }, /* C/N= 1.5dB */
+	{  20,    8566  }, /* C/N= 2.0dB */
+	{  25,    8366  }, /* C/N= 2.5dB */
+	{  30,    8146  }, /* C/N= 3.0dB */
+	{  35,    7908  }, /* C/N= 3.5dB */
+	{  40,    7666  }, /* C/N= 4.0dB */
+	{  45,    7405  }, /* C/N= 4.5dB */
+	{  50,    7136  }, /* C/N= 5.0dB */
+	{  55,    6861  }, /* C/N= 5.5dB */
+	{  60,    6576  }, /* C/N= 6.0dB */
+	{  65,    6330  }, /* C/N= 6.5dB */
+	{  70,    6048  }, /* C/N= 7.0dB */
+	{  75,    5768  }, /* C/N= 7.5dB */
+	{  80,    5492  }, /* C/N= 8.0dB */
+	{  85,    5224  }, /* C/N= 8.5dB */
+	{  90,    4959  }, /* C/N= 9.0dB */
+	{  95,    4709  }, /* C/N= 9.5dB */
+	{  100,   4467  }, /* C/N=10.0dB */
+	{  105,   4236  }, /* C/N=10.5dB */
+	{  110,   4013  }, /* C/N=11.0dB */
+	{  115,   3800  }, /* C/N=11.5dB */
+	{  120,   3598  }, /* C/N=12.0dB */
+	{  125,   3406  }, /* C/N=12.5dB */
+	{  130,   3225  }, /* C/N=13.0dB */
+	{  135,   3052  }, /* C/N=13.5dB */
+	{  140,   2889  }, /* C/N=14.0dB */
+	{  145,   2733  }, /* C/N=14.5dB */
+	{  150,   2587  }, /* C/N=15.0dB */
+	{  160,   2318  }, /* C/N=16.0dB */
+	{  170,   2077  }, /* C/N=17.0dB */
+	{  180,   1862  }, /* C/N=18.0dB */
+	{  190,   1670  }, /* C/N=19.0dB */
+	{  200,   1499  }, /* C/N=20.0dB */
+	{  210,   1347  }, /* C/N=21.0dB */
+	{  220,   1213  }, /* C/N=22.0dB */
+	{  230,   1095  }, /* C/N=23.0dB */
+	{  240,    992  }, /* C/N=24.0dB */
+	{  250,    900  }, /* C/N=25.0dB */
+	{  260,    826  }, /* C/N=26.0dB */
+	{  270,    758  }, /* C/N=27.0dB */
+	{  280,    702  }, /* C/N=28.0dB */
+	{  290,    653  }, /* C/N=29.0dB */
+	{  300,    613  }, /* C/N=30.0dB */
+	{  310,    579  }, /* C/N=31.0dB */
+	{  320,    550  }, /* C/N=32.0dB */
+	{  330,    526  }, /* C/N=33.0dB */
+	{  350,    490  }, /* C/N=33.0dB */
+	{  400,    445  }, /* C/N=40.0dB */
+	{  450,    430  }, /* C/N=45.0dB */
+	{  500,    426  }, /* C/N=50.0dB */
+	{  510,    425  }  /* C/N=51.0dB */
 };
 
 static struct slookup s2_sn_lookup[] = {
-	{  -30,  13950  },  /*C/N=-2.5dB*/
-	{  -25,  13580  },  /*C/N=-2.5dB*/
-	{  -20,  13150  },  /*C/N=-2.0dB*/
-	{  -15,  12760  },  /*C/N=-1.5dB*/
-	{  -10,  12345  },  /*C/N=-1.0dB*/
-	{   -5,  11900  },  /*C/N=-0.5dB*/
-	{    0,  11520  },  /*C/N=   0dB*/
-	{    5,  11080  },  /*C/N= 0.5dB*/
-	{   10,  10630  },  /*C/N= 1.0dB*/
-	{   15,  10210  },  /*C/N= 1.5dB*/
-	{   20,   9790  },  /*C/N= 2.0dB*/
-	{   25,   9390  },  /*C/N= 2.5dB*/
-	{   30,   8970  },  /*C/N= 3.0dB*/
-	{   35,   8575  },  /*C/N= 3.5dB*/
-	{   40,   8180  },  /*C/N= 4.0dB*/
-	{   45,   7800  },  /*C/N= 4.5dB*/
-	{   50,   7430  },  /*C/N= 5.0dB*/
-	{   55,   7080  },  /*C/N= 5.5dB*/
-	{   60,   6720  },  /*C/N= 6.0dB*/
-	{   65,   6320  },  /*C/N= 6.5dB*/
-	{   70,   6060  },  /*C/N= 7.0dB*/
-	{   75,   5760  },  /*C/N= 7.5dB*/
-	{   80,   5480  },  /*C/N= 8.0dB*/
-	{   85,   5200  },  /*C/N= 8.5dB*/
-	{   90,   4930  },  /*C/N= 9.0dB*/
-	{   95,   4680  },  /*C/N= 9.5dB*/
-	{  100,   4425  },  /*C/N=10.0dB*/
-	{  105,   4210  },  /*C/N=10.5dB*/
-	{  110,   3980  },  /*C/N=11.0dB*/
-	{  115,   3765  },  /*C/N=11.5dB*/
-	{  120,   3570  },  /*C/N=12.0dB*/
-	{  125,   3315  },  /*C/N=12.5dB*/
-	{  130,   3140  },  /*C/N=13.0dB*/
-	{  135,   2980  },  /*C/N=13.5dB*/
-	{  140,   2820  },  /*C/N=14.0dB*/
-	{  145,   2670  },  /*C/N=14.5dB*/
-	{  150,   2535  },  /*C/N=15.0dB*/
-	{  160,   2270  },  /*C/N=16.0dB*/
-	{  170,   2035  },  /*C/N=17.0dB*/
-	{  180,   1825  },  /*C/N=18.0dB*/
-	{  190,   1650  },  /*C/N=19.0dB*/
-	{  200,   1485  },  /*C/N=20.0dB*/
-	{  210,   1340  },  /*C/N=21.0dB*/
-	{  220,   1212  },  /*C/N=22.0dB*/
-	{  230,   1100  },  /*C/N=23.0dB*/
-	{  240,   1000  },  /*C/N=24.0dB*/
-	{  250,    910  },  /*C/N=25.0dB*/
-	{  260,    836  },  /*C/N=26.0dB*/
-	{  270,    772  },  /*C/N=27.0dB*/
-	{  280,    718  },  /*C/N=28.0dB*/
-	{  290,    671  },  /*C/N=29.0dB*/
-	{  300,    635  },  /*C/N=30.0dB*/
-	{  310,    602  },  /*C/N=31.0dB*/
-	{  320,    575  },  /*C/N=32.0dB*/
-	{  330,    550  },  /*C/N=33.0dB*/
-	{  350,    517  },  /*C/N=35.0dB*/
-	{  400,    480  },  /*C/N=40.0dB*/
-	{  450,    466  },  /*C/N=45.0dB*/
-	{  500,    464  },  /*C/N=50.0dB*/
-	{  510,    463  },  /*C/N=51.0dB*/
+	{  -30,  13950  }, /* C/N=-2.5dB */
+	{  -25,  13580  }, /* C/N=-2.5dB */
+	{  -20,  13150  }, /* C/N=-2.0dB */
+	{  -15,  12760  }, /* C/N=-1.5dB */
+	{  -10,  12345  }, /* C/N=-1.0dB */
+	{   -5,  11900  }, /* C/N=-0.5dB */
+	{    0,  11520  }, /* C/N=   0dB */
+	{    5,  11080  }, /* C/N= 0.5dB */
+	{   10,  10630  }, /* C/N= 1.0dB */
+	{   15,  10210  }, /* C/N= 1.5dB */
+	{   20,   9790  }, /* C/N= 2.0dB */
+	{   25,   9390  }, /* C/N= 2.5dB */
+	{   30,   8970  }, /* C/N= 3.0dB */
+	{   35,   8575  }, /* C/N= 3.5dB */
+	{   40,   8180  }, /* C/N= 4.0dB */
+	{   45,   7800  }, /* C/N= 4.5dB */
+	{   50,   7430  }, /* C/N= 5.0dB */
+	{   55,   7080  }, /* C/N= 5.5dB */
+	{   60,   6720  }, /* C/N= 6.0dB */
+	{   65,   6320  }, /* C/N= 6.5dB */
+	{   70,   6060  }, /* C/N= 7.0dB */
+	{   75,   5760  }, /* C/N= 7.5dB */
+	{   80,   5480  }, /* C/N= 8.0dB */
+	{   85,   5200  }, /* C/N= 8.5dB */
+	{   90,   4930  }, /* C/N= 9.0dB */
+	{   95,   4680  }, /* C/N= 9.5dB */
+	{  100,   4425  }, /* C/N=10.0dB */
+	{  105,   4210  }, /* C/N=10.5dB */
+	{  110,   3980  }, /* C/N=11.0dB */
+	{  115,   3765  }, /* C/N=11.5dB */
+	{  120,   3570  }, /* C/N=12.0dB */
+	{  125,   3315  }, /* C/N=12.5dB */
+	{  130,   3140  }, /* C/N=13.0dB */
+	{  135,   2980  }, /* C/N=13.5dB */
+	{  140,   2820  }, /* C/N=14.0dB */
+	{  145,   2670  }, /* C/N=14.5dB */
+	{  150,   2535  }, /* C/N=15.0dB */
+	{  160,   2270  }, /* C/N=16.0dB */
+	{  170,   2035  }, /* C/N=17.0dB */
+	{  180,   1825  }, /* C/N=18.0dB */
+	{  190,   1650  }, /* C/N=19.0dB */
+	{  200,   1485  }, /* C/N=20.0dB */
+	{  210,   1340  }, /* C/N=21.0dB */
+	{  220,   1212  }, /* C/N=22.0dB */
+	{  230,   1100  }, /* C/N=23.0dB */
+	{  240,   1000  }, /* C/N=24.0dB */
+	{  250,    910  }, /* C/N=25.0dB */
+	{  260,    836  }, /* C/N=26.0dB */
+	{  270,    772  }, /* C/N=27.0dB */
+	{  280,    718  }, /* C/N=28.0dB */
+	{  290,    671  }, /* C/N=29.0dB */
+	{  300,    635  }, /* C/N=30.0dB */
+	{  310,    602  }, /* C/N=31.0dB */
+	{  320,    575  }, /* C/N=32.0dB */
+	{  330,    550  }, /* C/N=33.0dB */
+	{  350,    517  }, /* C/N=35.0dB */
+	{  400,    480  }, /* C/N=40.0dB */
+	{  450,    466  }, /* C/N=45.0dB */
+	{  500,    464  }, /* C/N=50.0dB */
+	{  510,    463  }, /* C/N=51.0dB */
 };
 
 static struct slookup padc_lookup[] = {
-	{    0,  118000 }, /* PADC=+0dBm  */
-	{ -100,  93600  }, /* PADC=-1dBm  */
-	{ -200,  74500  }, /* PADC=-2dBm  */
-	{ -300,  59100  }, /* PADC=-3dBm  */
-	{ -400,  47000  }, /* PADC=-4dBm  */
-	{ -500,  37300  }, /* PADC=-5dBm  */
-	{ -600,  29650  }, /* PADC=-6dBm  */
-	{ -700,  23520  }, /* PADC=-7dBm  */
-	{ -900,  14850  }, /* PADC=-9dBm  */
+	{    0,  118000 }, /* PADC= +0dBm */
+	{ -100,  93600  }, /* PADC= -1dBm */
+	{ -200,  74500  }, /* PADC= -2dBm */
+	{ -300,  59100  }, /* PADC= -3dBm */
+	{ -400,  47000  }, /* PADC= -4dBm */
+	{ -500,  37300  }, /* PADC= -5dBm */
+	{ -600,  29650  }, /* PADC= -6dBm */
+	{ -700,  23520  }, /* PADC= -7dBm */
+	{ -900,  14850  }, /* PADC= -9dBm */
 	{ -1100, 9380   }, /* PADC=-11dBm */
 	{ -1300, 5910   }, /* PADC=-13dBm */
 	{ -1500, 3730   }, /* PADC=-15dBm */
@@ -350,7 +350,8 @@ static struct slookup padc_lookup[] = {
  * Tracking carrier loop carrier QPSK 1/4 to 8PSK 9/10 long Frame
  *********************************************************************/
 static u8 s2car_loop[] =	{
-	/* Modcod  2MPon 2MPoff 5MPon 5MPoff 10MPon 10MPoff
+	/*
+	 * Modcod  2MPon 2MPoff 5MPon 5MPoff 10MPon 10MPoff
 	 * 20MPon 20MPoff 30MPon 30MPoff
 	 */
 
@@ -393,7 +394,8 @@ static u8 s2car_loop[] =	{
 	 * Tracking carrier loop carrier 16APSK 2/3 to 32APSK 9/10 long Frame
 	 **********************************************************************/
 
-	/* Modcod 2MPon  2MPoff 5MPon 5MPoff 10MPon 10MPoff 20MPon
+	/*
+	 * Modcod 2MPon  2MPoff 5MPon 5MPoff 10MPon 10MPoff 20MPon
 	 * 20MPoff 30MPon 30MPoff
 	 */
 
@@ -692,24 +694,24 @@ static int get_bit_error_rate_s(struct stv *state, u32 *bernumerator,
 static u32 dvbs2_nbch(enum dvbs2_mod_cod mod_cod, enum dvbs2_fectype fectype)
 {
 	static u32 nbch[][2] = {
-		{    0,     0}, /* DUMMY_PLF */
-		{16200,  3240}, /* QPSK_1_4, */
-		{21600,  5400}, /* QPSK_1_3, */
-		{25920,  6480}, /* QPSK_2_5, */
-		{32400,  7200}, /* QPSK_1_2, */
-		{38880,  9720}, /* QPSK_3_5, */
-		{43200, 10800}, /* QPSK_2_3, */
-		{48600, 11880}, /* QPSK_3_4, */
-		{51840, 12600}, /* QPSK_4_5, */
-		{54000, 13320}, /* QPSK_5_6, */
-		{57600, 14400}, /* QPSK_8_9, */
-		{58320, 16000}, /* QPSK_9_10, */
-		{43200,  9720}, /* 8PSK_3_5, */
-		{48600, 10800}, /* 8PSK_2_3, */
-		{51840, 11880}, /* 8PSK_3_4, */
-		{54000, 13320}, /* 8PSK_5_6, */
-		{57600, 14400}, /* 8PSK_8_9, */
-		{58320, 16000}, /* 8PSK_9_10, */
+		{    0,     0}, /* DUMMY_PLF   */
+		{16200,  3240}, /* QPSK_1_4,   */
+		{21600,  5400}, /* QPSK_1_3,   */
+		{25920,  6480}, /* QPSK_2_5,   */
+		{32400,  7200}, /* QPSK_1_2,   */
+		{38880,  9720}, /* QPSK_3_5,   */
+		{43200, 10800}, /* QPSK_2_3,   */
+		{48600, 11880}, /* QPSK_3_4,   */
+		{51840, 12600}, /* QPSK_4_5,   */
+		{54000, 13320}, /* QPSK_5_6,   */
+		{57600, 14400}, /* QPSK_8_9,   */
+		{58320, 16000}, /* QPSK_9_10,  */
+		{43200,  9720}, /* 8PSK_3_5,   */
+		{48600, 10800}, /* 8PSK_2_3,   */
+		{51840, 11880}, /* 8PSK_3_4,   */
+		{54000, 13320}, /* 8PSK_5_6,   */
+		{57600, 14400}, /* 8PSK_8_9,   */
+		{58320, 16000}, /* 8PSK_9_10,  */
 		{43200, 10800}, /* 16APSK_2_3, */
 		{48600, 11880}, /* 16APSK_3_4, */
 		{51840, 12600}, /* 16APSK_4_5, */
@@ -853,7 +855,7 @@ static int stop(struct stv *state)
 		write_reg(state, RSTV0910_P2_TSCFGH + state->regoff,
 			  state->tscfgh | 0x01);
 		read_reg(state, RSTV0910_P2_PDELCTRL1 + state->regoff, &tmp);
-		tmp &= ~0x01; /*release reset DVBS2 packet delin*/
+		tmp &= ~0x01; /* release reset DVBS2 packet delin */
 		write_reg(state, RSTV0910_P2_PDELCTRL1 + state->regoff, tmp);
 		/* Blind optim*/
 		write_reg(state, RSTV0910_P2_AGC2O + state->regoff, 0x5B);
@@ -870,38 +872,38 @@ static int init_search_param(struct stv *state)
 	u8 tmp;
 
 	read_reg(state, RSTV0910_P2_PDELCTRL1 + state->regoff, &tmp);
-	tmp |= 0x20; // Filter_en (no effect if SIS=non-MIS
+	tmp |= 0x20; /* Filter_en (no effect if SIS=non-MIS */
 	write_reg(state, RSTV0910_P2_PDELCTRL1 + state->regoff, tmp);
 
 	read_reg(state, RSTV0910_P2_PDELCTRL2 + state->regoff, &tmp);
-	tmp &= ~0x02; // frame mode = 0
+	tmp &= ~0x02; /* frame mode = 0 */
 	write_reg(state, RSTV0910_P2_PDELCTRL2 + state->regoff, tmp);
 
 	write_reg(state, RSTV0910_P2_UPLCCST0 + state->regoff, 0xe0);
 	write_reg(state, RSTV0910_P2_ISIBITENA + state->regoff, 0x00);
 
 	read_reg(state, RSTV0910_P2_TSSTATEM + state->regoff, &tmp);
-	tmp &= ~0x01; // nosync = 0, in case next signal is standard TS
+	tmp &= ~0x01; /* nosync = 0, in case next signal is standard TS */
 	write_reg(state, RSTV0910_P2_TSSTATEM + state->regoff, tmp);
 
 	read_reg(state, RSTV0910_P2_TSCFGL + state->regoff, &tmp);
-	tmp &= ~0x04; // embindvb = 0
+	tmp &= ~0x04; /* embindvb = 0 */
 	write_reg(state, RSTV0910_P2_TSCFGL + state->regoff, tmp);
 
 	read_reg(state, RSTV0910_P2_TSINSDELH + state->regoff, &tmp);
-	tmp &= ~0x80; // syncbyte = 0
+	tmp &= ~0x80; /* syncbyte = 0 */
 	write_reg(state, RSTV0910_P2_TSINSDELH + state->regoff, tmp);
 
 	read_reg(state, RSTV0910_P2_TSINSDELM + state->regoff, &tmp);
-	tmp &= ~0x08; // token = 0
+	tmp &= ~0x08; /* token = 0 */
 	write_reg(state, RSTV0910_P2_TSINSDELM + state->regoff, tmp);
 
 	read_reg(state, RSTV0910_P2_TSDLYSET2 + state->regoff, &tmp);
-	tmp &= ~0x30; // hysteresis threshold = 0
+	tmp &= ~0x30; /* hysteresis threshold = 0 */
 	write_reg(state, RSTV0910_P2_TSDLYSET2 + state->regoff, tmp);
 
 	read_reg(state, RSTV0910_P2_PDELCTRL0 + state->regoff, &tmp);
-	tmp = (tmp & ~0x30) | 0x10; // isi obs mode = 1, observe min ISI
+	tmp = (tmp & ~0x30) | 0x10; /* isi obs mode = 1, observe min ISI */
 	write_reg(state, RSTV0910_P2_PDELCTRL0 + state->regoff, tmp);
 
 	return 0;
@@ -952,11 +954,11 @@ static int set_vth_default(struct stv *state)
 static int set_vth(struct stv *state)
 {
 	static struct slookup vthlookup_table[] = {
-		{250,	8780}, /*C/N=1.5dB*/
-		{100,	7405}, /*C/N=4.5dB*/
-		{40,	6330}, /*C/N=6.5dB*/
-		{12,	5224}, /*C/N=8.5dB*/
-		{5,	4236} /*C/N=10.5dB*/
+		{250,	8780}, /* C/N= 1.5dB */
+		{100,	7405}, /* C/N= 4.5dB */
+		{40,	6330}, /* C/N= 6.5dB */
+		{12,	5224}, /* C/N= 8.5dB */
+		{5,	4236}  /* C/N=10.5dB */
 	};
 
 	int i;
@@ -1001,7 +1003,8 @@ static int start(struct stv *state, struct dtv_frontend_properties *p)
 	init_search_param(state);
 
 	if (p->stream_id != NO_STREAM_ID_FILTER) {
-		/* Backwards compatibility to "crazy" API.
+		/*
+		 * Backwards compatibility to "crazy" API.
 		 * PRBS X root cannot be 0, so this should always work.
 		 */
 		if (p->stream_id & 0xffffff00)
@@ -1022,22 +1025,22 @@ static int start(struct stv *state, struct dtv_frontend_properties *p)
 		state->cur_scrambling_code = scrambling_code;
 	}
 
-	if (p->symbol_rate <= 1000000) {  /* SR <=1Msps */
+	if (p->symbol_rate <= 1000000) { /* SR <=1Msps */
 		state->demod_timeout = 3000;
 		state->fec_timeout = 2000;
-	} else if (p->symbol_rate <= 2000000) {  /* 1Msps < SR <=2Msps */
+	} else if (p->symbol_rate <= 2000000) { /* 1Msps < SR <=2Msps */
 		state->demod_timeout = 2500;
 		state->fec_timeout = 1300;
-	} else if (p->symbol_rate <= 5000000) {  /* 2Msps< SR <=5Msps */
+	} else if (p->symbol_rate <= 5000000) { /* 2Msps< SR <=5Msps */
 		state->demod_timeout = 1000;
 		state->fec_timeout = 650;
-	} else if (p->symbol_rate <= 10000000) {  /* 5Msps< SR <=10Msps */
+	} else if (p->symbol_rate <= 10000000) { /* 5Msps< SR <=10Msps */
 		state->demod_timeout = 700;
 		state->fec_timeout = 350;
-	} else if (p->symbol_rate < 20000000) {  /* 10Msps< SR <=20Msps */
+	} else if (p->symbol_rate < 20000000) { /* 10Msps< SR <=20Msps */
 		state->demod_timeout = 400;
 		state->fec_timeout = 200;
-	} else {  /* SR >=20Msps */
+	} else { /* SR >=20Msps */
 		state->demod_timeout = 300;
 		state->fec_timeout = 200;
 	}
@@ -1065,7 +1068,7 @@ static int start(struct stv *state, struct dtv_frontend_properties *p)
 
 	enable_puncture_rate(state, FEC_NONE);
 
-	/* 8PSK 3/5, 8PSK 2/3 Poff tracking optimization WA*/
+	/* 8PSK 3/5, 8PSK 2/3 Poff tracking optimization WA */
 	write_reg(state, RSTV0910_P2_ACLC2S2Q + state->regoff, 0x0B);
 	write_reg(state, RSTV0910_P2_ACLC2S28 + state->regoff, 0x0A);
 	write_reg(state, RSTV0910_P2_BCLC2S2Q + state->regoff, 0x84);
@@ -1078,8 +1081,10 @@ static int start(struct stv *state, struct dtv_frontend_properties *p)
 	write_reg(state, RSTV0910_P2_BCLC2S216A + state->regoff, 0x84);
 	write_reg(state, RSTV0910_P2_BCLC2S232A + state->regoff, 0x84);
 
-	/* Reset CAR3, bug DVBS2->DVBS1 lock*/
-	/* Note: The bit is only pulsed -> no lock on shared register needed */
+	/*
+	 * Reset CAR3, bug DVBS2->DVBS1 lock
+	 * Note: The bit is only pulsed -> no lock on shared register needed
+	 */
 	write_reg(state, RSTV0910_TSTRES0, state->nr ? 0x04 : 0x08);
 	write_reg(state, RSTV0910_TSTRES0, 0);
 
@@ -1098,7 +1103,7 @@ static int start(struct stv *state, struct dtv_frontend_properties *p)
 	write_reg(state, RSTV0910_P2_CFRUP1 + state->regoff,
 		  (freq >> 8) & 0xff);
 	write_reg(state, RSTV0910_P2_CFRUP0 + state->regoff, (freq & 0xff));
-	/*CFR Low Setting*/
+	/* CFR Low Setting */
 	freq = -freq;
 	write_reg(state, RSTV0910_P2_CFRLOW1 + state->regoff,
 		  (freq >> 8) & 0xff);
@@ -1120,7 +1125,7 @@ static int start(struct stv *state, struct dtv_frontend_properties *p)
 
 static int init_diseqc(struct stv *state)
 {
-	u16 offs = state->nr ? 0x40 : 0;  /* Address offset */
+	u16 offs = state->nr ? 0x40 : 0; /* Address offset */
 	u8 freq = ((state->base->mclk + 11000 * 32) / (22000 * 32));
 
 	/* Disable receiver */
@@ -1144,26 +1149,26 @@ static int probe(struct stv *state)
 	if (id != 0x51)
 		return -EINVAL;
 
-	 /* Configure the I2C repeater to off */
+	/* Configure the I2C repeater to off */
 	write_reg(state, RSTV0910_P1_I2CRPT, 0x24);
 	/* Configure the I2C repeater to off */
 	write_reg(state, RSTV0910_P2_I2CRPT, 0x24);
 	/* Set the I2C to oversampling ratio */
 	write_reg(state, RSTV0910_I2CCFG, 0x88); /* state->i2ccfg */
 
-	write_reg(state, RSTV0910_OUTCFG,    0x00);  /* OUTCFG */
-	write_reg(state, RSTV0910_PADCFG,    0x05);  /* RFAGC Pads Dev = 05 */
-	write_reg(state, RSTV0910_SYNTCTRL,  0x02);  /* SYNTCTRL */
-	write_reg(state, RSTV0910_TSGENERAL, state->tsgeneral);  /* TSGENERAL */
-	write_reg(state, RSTV0910_CFGEXT,    0x02);  /* CFGEXT */
+	write_reg(state, RSTV0910_OUTCFG,    0x00); /* OUTCFG */
+	write_reg(state, RSTV0910_PADCFG,    0x05); /* RFAGC Pads Dev = 05 */
+	write_reg(state, RSTV0910_SYNTCTRL,  0x02); /* SYNTCTRL */
+	write_reg(state, RSTV0910_TSGENERAL, state->tsgeneral); /* TSGENERAL */
+	write_reg(state, RSTV0910_CFGEXT,    0x02); /* CFGEXT */
 
 	if (state->single)
-		write_reg(state, RSTV0910_GENCFG, 0x14);  /* GENCFG */
+		write_reg(state, RSTV0910_GENCFG, 0x14); /* GENCFG */
 	else
-		write_reg(state, RSTV0910_GENCFG, 0x15);  /* GENCFG */
+		write_reg(state, RSTV0910_GENCFG, 0x15); /* GENCFG */
 
-	write_reg(state, RSTV0910_P1_TNRCFG2, 0x02);  /* IQSWAP = 0 */
-	write_reg(state, RSTV0910_P2_TNRCFG2, 0x82);  /* IQSWAP = 1 */
+	write_reg(state, RSTV0910_P1_TNRCFG2, 0x02); /* IQSWAP = 0 */
+	write_reg(state, RSTV0910_P2_TNRCFG2, 0x82); /* IQSWAP = 1 */
 
 	write_reg(state, RSTV0910_P1_CAR3CFG, 0x02);
 	write_reg(state, RSTV0910_P2_CAR3CFG, 0x02);
@@ -1184,7 +1189,7 @@ static int probe(struct stv *state)
 	/* TS output */
 	write_reg(state, RSTV0910_P1_TSCFGH, state->tscfgh | 0x01);
 	write_reg(state, RSTV0910_P1_TSCFGH, state->tscfgh);
-	write_reg(state, RSTV0910_P1_TSCFGM, 0xC0);  /* Manual speed */
+	write_reg(state, RSTV0910_P1_TSCFGM, 0xC0); /* Manual speed */
 	write_reg(state, RSTV0910_P1_TSCFGL, 0x20);
 
 	/* Speed = 67.5 MHz */
@@ -1192,7 +1197,7 @@ static int probe(struct stv *state)
 
 	write_reg(state, RSTV0910_P2_TSCFGH, state->tscfgh | 0x01);
 	write_reg(state, RSTV0910_P2_TSCFGH, state->tscfgh);
-	write_reg(state, RSTV0910_P2_TSCFGM, 0xC0);  /* Manual speed */
+	write_reg(state, RSTV0910_P2_TSCFGM, 0xC0); /* Manual speed */
 	write_reg(state, RSTV0910_P2_TSCFGL, 0x20);
 
 	/* Speed = 67.5 MHz */
@@ -1425,7 +1430,8 @@ static int read_status(struct dvb_frontend *fe, enum fe_status *status)
 			manage_matype_info(state);
 
 			if (state->receive_mode == RCVMODE_DVBS2) {
-				/* FSTV0910_P2_MANUALSX_ROLLOFF,
+				/*
+				 * FSTV0910_P2_MANUALSX_ROLLOFF,
 				 * FSTV0910_P2_MANUALS2_ROLLOFF = 0
 				 */
 				state->demod_bits &= ~0x84;
@@ -1435,12 +1441,12 @@ static int read_status(struct dvb_frontend *fe, enum fe_status *status)
 				read_reg(state,
 					 RSTV0910_P2_PDELCTRL2 + state->regoff,
 					 &tmp);
-				/*reset DVBS2 packet delinator error counter */
+				/* reset DVBS2 packet delinator error counter */
 				tmp |= 0x40;
 				write_reg(state,
 					  RSTV0910_P2_PDELCTRL2 + state->regoff,
 					  tmp);
-				/*reset DVBS2 packet delinator error counter */
+				/* reset DVBS2 packet delinator error counter */
 				tmp &= ~0x40;
 				write_reg(state,
 					  RSTV0910_P2_PDELCTRL2 + state->regoff,
@@ -1462,11 +1468,12 @@ static int read_status(struct dvb_frontend *fe, enum fe_status *status)
 					  RSTV0910_P2_ERRCTRL1 + state->regoff,
 					  BER_SRC_S | state->berscale);
 			}
-			/*Reset the Total packet counter */
+			/* Reset the Total packet counter */
 			write_reg(state,
 				  RSTV0910_P2_FBERCPT4 + state->regoff, 0x00);
-			/* Reset the packet Error counter2 (and Set it to
-			 * infinit error count mode )
+			/*
+			 * Reset the packet Error counter2 (and Set it to
+			 * infinit error count mode)
 			 */
 			write_reg(state,
 				  RSTV0910_P2_ERRCTRL2 + state->regoff, 0xc1);
@@ -1683,17 +1690,17 @@ static struct dvb_frontend_ops stv0910_ops = {
 					  FE_CAN_MULTISTREAM
 	},
 	.sleep				= sleep,
-	.release                        = release,
-	.i2c_gate_ctrl                  = gate_ctrl,
+	.release			= release,
+	.i2c_gate_ctrl			= gate_ctrl,
 	.set_frontend			= set_parameters,
-	.get_frontend_algo              = get_algo,
-	.get_frontend                   = get_frontend,
-	.tune                           = tune,
+	.get_frontend_algo		= get_algo,
+	.get_frontend			= get_frontend,
+	.tune				= tune,
 	.read_status			= read_status,
 	.set_tone			= set_tone,
 
 	.diseqc_send_master_cmd		= send_master_cmd,
-	.diseqc_send_burst              = send_burst,
+	.diseqc_send_burst		= send_burst,
 };
 
 static struct stv_base *match_base(struct i2c_adapter *i2c, u8 adr)
@@ -1738,8 +1745,8 @@ struct dvb_frontend *stv0910_attach(struct i2c_adapter *i2c,
 	state->nr = nr;
 	state->regoff = state->nr ? 0 : 0x200;
 	state->search_range = 16000000;
-	state->demod_bits = 0x10;     /* Inversion : Auto with reset to 0 */
-	state->receive_mode   = RCVMODE_NONE;
+	state->demod_bits = 0x10; /* Inversion : Auto with reset to 0 */
+	state->receive_mode = RCVMODE_NONE;
 	state->cur_scrambling_code = (~0U);
 	state->single = cfg->single ? 1 : 0;
 
@@ -1767,8 +1774,8 @@ struct dvb_frontend *stv0910_attach(struct i2c_adapter *i2c,
 		}
 		list_add(&base->stvlist, &stvlist);
 	}
-	state->fe.ops               = stv0910_ops;
-	state->fe.demodulator_priv  = state;
+	state->fe.ops = stv0910_ops;
+	state->fe.demodulator_priv = state;
 	state->nr = nr;
 
 	dev_info(&i2c->dev, "%s demod found at adr %02X on %s\n",
diff --git a/drivers/media/dvb-frontends/stv0910_regs.h b/drivers/media/dvb-frontends/stv0910_regs.h
index 17c9a51e2e34..32ced4eaf296 100644
--- a/drivers/media/dvb-frontends/stv0910_regs.h
+++ b/drivers/media/dvb-frontends/stv0910_regs.h
@@ -1,4 +1,5 @@
-/* @DVB-S/DVB-S2 STMicroelectronics STV0900 register definitions
+/*
+ * @DVB-S/DVB-S2 STMicroelectronics STV0900 register definitions
  * Author Manfred Voelkel, August 2013
  * (c) 2013 Digital Devices GmbH Germany.  All rights reserved
  *
@@ -12,32 +13,32 @@
  *  ======================================================================
  */
 
-/*MID*/
+/* MID */
 #define RSTV0910_MID  0xf100
 #define FSTV0910_MCHIP_IDENT  0xf10000f0
 #define FSTV0910_MRELEASE  0xf100000f
 
-/*DID*/
+/* DID */
 #define RSTV0910_DID  0xf101
 #define FSTV0910_DEVICE_ID  0xf10100ff
 
-/*DACR1*/
+/* DACR1 */
 #define RSTV0910_DACR1  0xf113
 #define FSTV0910_DAC_MODE  0xf11300e0
 #define FSTV0910_DAC_VALUE1  0xf113000f
 
-/*DACR2*/
+/* DACR2 */
 #define RSTV0910_DACR2  0xf114
 #define FSTV0910_DAC_VALUE0  0xf11400ff
 
-/*PADCFG*/
+/* PADCFG */
 #define RSTV0910_PADCFG  0xf11a
 #define FSTV0910_AGCRF2_OPD  0xf11a0008
 #define FSTV0910_AGCRF2_XOR  0xf11a0004
 #define FSTV0910_AGCRF1_OPD  0xf11a0002
 #define FSTV0910_AGCRF1_XOR  0xf11a0001
 
-/*OUTCFG2*/
+/* OUTCFG2 */
 #define RSTV0910_OUTCFG2  0xf11b
 #define FSTV0910_TS2_ERROR_XOR  0xf11b0080
 #define FSTV0910_TS2_DPN_XOR  0xf11b0040
@@ -48,7 +49,7 @@
 #define FSTV0910_TS1_STROUT_XOR  0xf11b0002
 #define FSTV0910_TS1_CLOCKOUT_XOR  0xf11b0001
 
-/*OUTCFG*/
+/* OUTCFG */
 #define RSTV0910_OUTCFG  0xf11c
 #define FSTV0910_TS2_OUTSER_HZ  0xf11c0020
 #define FSTV0910_TS1_OUTSER_HZ  0xf11c0010
@@ -56,7 +57,7 @@
 #define FSTV0910_TS1_OUTPAR_HZ  0xf11c0004
 #define FSTV0910_TS_SERDATA0  0xf11c0002
 
-/*IRQSTATUS3*/
+/* IRQSTATUS3 */
 #define RSTV0910_IRQSTATUS3  0xf120
 #define FSTV0910_SPLL_LOCK  0xf1200020
 #define FSTV0910_SSTREAM_LCK_1  0xf1200010
@@ -64,7 +65,7 @@
 #define FSTV0910_SDVBS1_PRF_2  0xf1200002
 #define FSTV0910_SDVBS1_PRF_1  0xf1200001
 
-/*IRQSTATUS2*/
+/* IRQSTATUS2 */
 #define RSTV0910_IRQSTATUS2  0xf121
 #define FSTV0910_SSPY_ENDSIM_1  0xf1210080
 #define FSTV0910_SSPY_ENDSIM_2  0xf1210040
@@ -74,7 +75,7 @@
 #define FSTV0910_SPKTDEL_ERROR_1  0xf1210002
 #define FSTV0910_SPKTDEL_LOCKB_1  0xf1210001
 
-/*IRQSTATUS1*/
+/* IRQSTATUS1 */
 #define RSTV0910_IRQSTATUS1  0xf122
 #define FSTV0910_SPKTDEL_LOCK_1  0xf1220080
 #define FSTV0910_SFEC_LOCKB_2  0xf1220040
@@ -85,7 +86,7 @@
 #define FSTV0910_SDEMOD_LOCK_2  0xf1220002
 #define FSTV0910_SDEMOD_IRQ_2  0xf1220001
 
-/*IRQSTATUS0*/
+/* IRQSTATUS0 */
 #define RSTV0910_IRQSTATUS0  0xf123
 #define FSTV0910_SDEMOD_LOCKB_1  0xf1230080
 #define FSTV0910_SDEMOD_LOCK_1  0xf1230040
@@ -94,7 +95,7 @@
 #define FSTV0910_SDISEQC2_IRQ  0xf1230004
 #define FSTV0910_SDISEQC1_IRQ  0xf1230001
 
-/*IRQMASK3*/
+/* IRQMASK3 */
 #define RSTV0910_IRQMASK3  0xf124
 #define FSTV0910_MPLL_LOCK  0xf1240020
 #define FSTV0910_MSTREAM_LCK_1  0xf1240010
@@ -102,7 +103,7 @@
 #define FSTV0910_MDVBS1_PRF_2  0xf1240002
 #define FSTV0910_MDVBS1_PRF_1  0xf1240001
 
-/*IRQMASK2*/
+/* IRQMASK2 */
 #define RSTV0910_IRQMASK2  0xf125
 #define FSTV0910_MSPY_ENDSIM_1  0xf1250080
 #define FSTV0910_MSPY_ENDSIM_2  0xf1250040
@@ -112,7 +113,7 @@
 #define FSTV0910_MPKTDEL_ERROR_1  0xf1250002
 #define FSTV0910_MPKTDEL_LOCKB_1  0xf1250001
 
-/*IRQMASK1*/
+/* IRQMASK1 */
 #define RSTV0910_IRQMASK1  0xf126
 #define FSTV0910_MPKTDEL_LOCK_1  0xf1260080
 #define FSTV0910_MFEC_LOCKB_2  0xf1260040
@@ -123,7 +124,7 @@
 #define FSTV0910_MDEMOD_LOCK_2  0xf1260002
 #define FSTV0910_MDEMOD_IRQ_2  0xf1260001
 
-/*IRQMASK0*/
+/* IRQMASK0 */
 #define RSTV0910_IRQMASK0  0xf127
 #define FSTV0910_MDEMOD_LOCKB_1  0xf1270080
 #define FSTV0910_MDEMOD_LOCK_1  0xf1270040
@@ -132,12 +133,12 @@
 #define FSTV0910_MDISEQC2_IRQ  0xf1270004
 #define FSTV0910_MDISEQC1_IRQ  0xf1270001
 
-/*I2CCFG*/
+/* I2CCFG */
 #define RSTV0910_I2CCFG  0xf129
 #define FSTV0910_I2C_FASTMODE  0xf1290008
 #define FSTV0910_I2CADDR_INC  0xf1290003
 
-/*P1_I2CRPT*/
+/* P1_I2CRPT */
 #define RSTV0910_P1_I2CRPT  0xf12a
 #define FSTV0910_P1_I2CT_ON  0xf12a0080
 #define FSTV0910_P1_ENARPT_LEVEL  0xf12a0070
@@ -145,7 +146,7 @@
 #define FSTV0910_P1_STOP_ENABLE  0xf12a0004
 #define FSTV0910_P1_STOP_SDAT2SDA  0xf12a0002
 
-/*P2_I2CRPT*/
+/* P2_I2CRPT */
 #define RSTV0910_P2_I2CRPT  0xf12b
 #define FSTV0910_P2_I2CT_ON  0xf12b0080
 #define FSTV0910_P2_ENARPT_LEVEL  0xf12b0070
@@ -153,181 +154,181 @@
 #define FSTV0910_P2_STOP_ENABLE  0xf12b0004
 #define FSTV0910_P2_STOP_SDAT2SDA  0xf12b0002
 
-/*GPIO0CFG*/
+/* GPIO0CFG */
 #define RSTV0910_GPIO0CFG  0xf140
 #define FSTV0910_GPIO0_OPD  0xf1400080
 #define FSTV0910_GPIO0_CONFIG  0xf140007e
 #define FSTV0910_GPIO0_XOR  0xf1400001
 
-/*GPIO1CFG*/
+/* GPIO1CFG */
 #define RSTV0910_GPIO1CFG  0xf141
 #define FSTV0910_GPIO1_OPD  0xf1410080
 #define FSTV0910_GPIO1_CONFIG  0xf141007e
 #define FSTV0910_GPIO1_XOR  0xf1410001
 
-/*GPIO2CFG*/
+/* GPIO2CFG */
 #define RSTV0910_GPIO2CFG  0xf142
 #define FSTV0910_GPIO2_OPD  0xf1420080
 #define FSTV0910_GPIO2_CONFIG  0xf142007e
 #define FSTV0910_GPIO2_XOR  0xf1420001
 
-/*GPIO3CFG*/
+/* GPIO3CFG */
 #define RSTV0910_GPIO3CFG  0xf143
 #define FSTV0910_GPIO3_OPD  0xf1430080
 #define FSTV0910_GPIO3_CONFIG  0xf143007e
 #define FSTV0910_GPIO3_XOR  0xf1430001
 
-/*GPIO4CFG*/
+/* GPIO4CFG */
 #define RSTV0910_GPIO4CFG  0xf144
 #define FSTV0910_GPIO4_OPD  0xf1440080
 #define FSTV0910_GPIO4_CONFIG  0xf144007e
 #define FSTV0910_GPIO4_XOR  0xf1440001
 
-/*GPIO5CFG*/
+/* GPIO5CFG */
 #define RSTV0910_GPIO5CFG  0xf145
 #define FSTV0910_GPIO5_OPD  0xf1450080
 #define FSTV0910_GPIO5_CONFIG  0xf145007e
 #define FSTV0910_GPIO5_XOR  0xf1450001
 
-/*GPIO6CFG*/
+/* GPIO6CFG */
 #define RSTV0910_GPIO6CFG  0xf146
 #define FSTV0910_GPIO6_OPD  0xf1460080
 #define FSTV0910_GPIO6_CONFIG  0xf146007e
 #define FSTV0910_GPIO6_XOR  0xf1460001
 
-/*GPIO7CFG*/
+/* GPIO7CFG */
 #define RSTV0910_GPIO7CFG  0xf147
 #define FSTV0910_GPIO7_OPD  0xf1470080
 #define FSTV0910_GPIO7_CONFIG  0xf147007e
 #define FSTV0910_GPIO7_XOR  0xf1470001
 
-/*GPIO8CFG*/
+/* GPIO8CFG */
 #define RSTV0910_GPIO8CFG  0xf148
 #define FSTV0910_GPIO8_OPD  0xf1480080
 #define FSTV0910_GPIO8_CONFIG  0xf148007e
 #define FSTV0910_GPIO8_XOR  0xf1480001
 
-/*GPIO9CFG*/
+/* GPIO9CFG */
 #define RSTV0910_GPIO9CFG  0xf149
 #define FSTV0910_GPIO9_OPD  0xf1490080
 #define FSTV0910_GPIO9_CONFIG  0xf149007e
 #define FSTV0910_GPIO9_XOR  0xf1490001
 
-/*GPIO10CFG*/
+/* GPIO10CFG */
 #define RSTV0910_GPIO10CFG  0xf14a
 #define FSTV0910_GPIO10_OPD  0xf14a0080
 #define FSTV0910_GPIO10_CONFIG  0xf14a007e
 #define FSTV0910_GPIO10_XOR  0xf14a0001
 
-/*GPIO11CFG*/
+/* GPIO11CFG */
 #define RSTV0910_GPIO11CFG  0xf14b
 #define FSTV0910_GPIO11_OPD  0xf14b0080
 #define FSTV0910_GPIO11_CONFIG  0xf14b007e
 #define FSTV0910_GPIO11_XOR  0xf14b0001
 
-/*GPIO12CFG*/
+/* GPIO12CFG */
 #define RSTV0910_GPIO12CFG  0xf14c
 #define FSTV0910_GPIO12_OPD  0xf14c0080
 #define FSTV0910_GPIO12_CONFIG  0xf14c007e
 #define FSTV0910_GPIO12_XOR  0xf14c0001
 
-/*GPIO13CFG*/
+/* GPIO13CFG */
 #define RSTV0910_GPIO13CFG  0xf14d
 #define FSTV0910_GPIO13_OPD  0xf14d0080
 #define FSTV0910_GPIO13_CONFIG  0xf14d007e
 #define FSTV0910_GPIO13_XOR  0xf14d0001
 
-/*GPIO14CFG*/
+/* GPIO14CFG */
 #define RSTV0910_GPIO14CFG  0xf14e
 #define FSTV0910_GPIO14_OPD  0xf14e0080
 #define FSTV0910_GPIO14_CONFIG  0xf14e007e
 #define FSTV0910_GPIO14_XOR  0xf14e0001
 
-/*GPIO15CFG*/
+/* GPIO15CFG */
 #define RSTV0910_GPIO15CFG  0xf14f
 #define FSTV0910_GPIO15_OPD  0xf14f0080
 #define FSTV0910_GPIO15_CONFIG  0xf14f007e
 #define FSTV0910_GPIO15_XOR  0xf14f0001
 
-/*GPIO16CFG*/
+/* GPIO16CFG */
 #define RSTV0910_GPIO16CFG  0xf150
 #define FSTV0910_GPIO16_OPD  0xf1500080
 #define FSTV0910_GPIO16_CONFIG  0xf150007e
 #define FSTV0910_GPIO16_XOR  0xf1500001
 
-/*GPIO17CFG*/
+/* GPIO17CFG */
 #define RSTV0910_GPIO17CFG  0xf151
 #define FSTV0910_GPIO17_OPD  0xf1510080
 #define FSTV0910_GPIO17_CONFIG  0xf151007e
 #define FSTV0910_GPIO17_XOR  0xf1510001
 
-/*GPIO18CFG*/
+/* GPIO18CFG */
 #define RSTV0910_GPIO18CFG  0xf152
 #define FSTV0910_GPIO18_OPD  0xf1520080
 #define FSTV0910_GPIO18_CONFIG  0xf152007e
 #define FSTV0910_GPIO18_XOR  0xf1520001
 
-/*GPIO19CFG*/
+/* GPIO19CFG */
 #define RSTV0910_GPIO19CFG  0xf153
 #define FSTV0910_GPIO19_OPD  0xf1530080
 #define FSTV0910_GPIO19_CONFIG  0xf153007e
 #define FSTV0910_GPIO19_XOR  0xf1530001
 
-/*GPIO20CFG*/
+/* GPIO20CFG */
 #define RSTV0910_GPIO20CFG  0xf154
 #define FSTV0910_GPIO20_OPD  0xf1540080
 #define FSTV0910_GPIO20_CONFIG  0xf154007e
 #define FSTV0910_GPIO20_XOR  0xf1540001
 
-/*GPIO21CFG*/
+/* GPIO21CFG */
 #define RSTV0910_GPIO21CFG  0xf155
 #define FSTV0910_GPIO21_OPD  0xf1550080
 #define FSTV0910_GPIO21_CONFIG  0xf155007e
 #define FSTV0910_GPIO21_XOR  0xf1550001
 
-/*GPIO22CFG*/
+/* GPIO22CFG */
 #define RSTV0910_GPIO22CFG  0xf156
 #define FSTV0910_GPIO22_OPD  0xf1560080
 #define FSTV0910_GPIO22_CONFIG  0xf156007e
 #define FSTV0910_GPIO22_XOR  0xf1560001
 
-/*STRSTATUS1*/
+/* STRSTATUS1 */
 #define RSTV0910_STRSTATUS1  0xf16a
 #define FSTV0910_STRSTATUS_SEL2  0xf16a00f0
 #define FSTV0910_STRSTATUS_SEL1  0xf16a000f
 
-/*STRSTATUS2*/
+/* STRSTATUS2 */
 #define RSTV0910_STRSTATUS2  0xf16b
 #define FSTV0910_STRSTATUS_SEL4  0xf16b00f0
 #define FSTV0910_STRSTATUS_SEL3  0xf16b000f
 
-/*STRSTATUS3*/
+/* STRSTATUS3 */
 #define RSTV0910_STRSTATUS3  0xf16c
 #define FSTV0910_STRSTATUS_SEL6  0xf16c00f0
 #define FSTV0910_STRSTATUS_SEL5  0xf16c000f
 
-/*FSKTFC2*/
+/* FSKTFC2 */
 #define RSTV0910_FSKTFC2  0xf170
 #define FSTV0910_FSKT_KMOD  0xf17000fc
 #define FSTV0910_FSKT_CAR2  0xf1700003
 
-/*FSKTFC1*/
+/* FSKTFC1 */
 #define RSTV0910_FSKTFC1  0xf171
 #define FSTV0910_FSKT_CAR1  0xf17100ff
 
-/*FSKTFC0*/
+/* FSKTFC0 */
 #define RSTV0910_FSKTFC0  0xf172
 #define FSTV0910_FSKT_CAR0  0xf17200ff
 
-/*FSKTDELTAF1*/
+/* FSKTDELTAF1 */
 #define RSTV0910_FSKTDELTAF1  0xf173
 #define FSTV0910_FSKT_DELTAF1  0xf173000f
 
-/*FSKTDELTAF0*/
+/* FSKTDELTAF0 */
 #define RSTV0910_FSKTDELTAF0  0xf174
 #define FSTV0910_FSKT_DELTAF0  0xf17400ff
 
-/*FSKTCTRL*/
+/* FSKTCTRL */
 #define RSTV0910_FSKTCTRL  0xf175
 #define FSTV0910_FSKT_PINSEL  0xf1750080
 #define FSTV0910_FSKT_EN_SGN  0xf1750040
@@ -335,129 +336,129 @@
 #define FSTV0910_FSKT_MOD_EN  0xf175001c
 #define FSTV0910_FSKT_DACMODE  0xf1750003
 
-/*FSKRFC2*/
+/* FSKRFC2 */
 #define RSTV0910_FSKRFC2  0xf176
 #define FSTV0910_FSKR_DETSGN  0xf1760040
 #define FSTV0910_FSKR_OUTSGN  0xf1760020
 #define FSTV0910_FSKR_KAGC  0xf176001c
 #define FSTV0910_FSKR_CAR2  0xf1760003
 
-/*FSKRFC1*/
+/* FSKRFC1 */
 #define RSTV0910_FSKRFC1  0xf177
 #define FSTV0910_FSKR_CAR1  0xf17700ff
 
-/*FSKRFC0*/
+/* FSKRFC0 */
 #define RSTV0910_FSKRFC0  0xf178
 #define FSTV0910_FSKR_CAR0  0xf17800ff
 
-/*FSKRK1*/
+/* FSKRK1 */
 #define RSTV0910_FSKRK1  0xf179
 #define FSTV0910_FSKR_K1_EXP  0xf17900e0
 #define FSTV0910_FSKR_K1_MANT  0xf179001f
 
-/*FSKRK2*/
+/* FSKRK2 */
 #define RSTV0910_FSKRK2  0xf17a
 #define FSTV0910_FSKR_K2_EXP  0xf17a00e0
 #define FSTV0910_FSKR_K2_MANT  0xf17a001f
 
-/*FSKRAGCR*/
+/* FSKRAGCR */
 #define RSTV0910_FSKRAGCR  0xf17b
 #define FSTV0910_FSKR_OUTCTL  0xf17b00c0
 #define FSTV0910_FSKR_AGC_REF  0xf17b003f
 
-/*FSKRAGC*/
+/* FSKRAGC */
 #define RSTV0910_FSKRAGC  0xf17c
 #define FSTV0910_FSKR_AGC_ACCU  0xf17c00ff
 
-/*FSKRALPHA*/
+/* FSKRALPHA */
 #define RSTV0910_FSKRALPHA  0xf17d
 #define FSTV0910_FSKR_ALPHA_EXP  0xf17d001c
 #define FSTV0910_FSKR_ALPHA_M  0xf17d0003
 
-/*FSKRPLTH1*/
+/* FSKRPLTH1 */
 #define RSTV0910_FSKRPLTH1  0xf17e
 #define FSTV0910_FSKR_BETA  0xf17e00f0
 #define FSTV0910_FSKR_PLL_TRESH1  0xf17e000f
 
-/*FSKRPLTH0*/
+/* FSKRPLTH0 */
 #define RSTV0910_FSKRPLTH0  0xf17f
 #define FSTV0910_FSKR_PLL_TRESH0  0xf17f00ff
 
-/*FSKRDF1*/
+/* FSKRDF1 */
 #define RSTV0910_FSKRDF1  0xf180
 #define FSTV0910_FSKR_OUT  0xf1800080
 #define FSTV0910_FSKR_STATE  0xf1800060
 #define FSTV0910_FSKR_DELTAF1  0xf180001f
 
-/*FSKRDF0*/
+/* FSKRDF0 */
 #define RSTV0910_FSKRDF0  0xf181
 #define FSTV0910_FSKR_DELTAF0  0xf18100ff
 
-/*FSKRSTEPP*/
+/* FSKRSTEPP */
 #define RSTV0910_FSKRSTEPP  0xf182
 #define FSTV0910_FSKR_STEP_PLUS  0xf18200ff
 
-/*FSKRSTEPM*/
+/* FSKRSTEPM */
 #define RSTV0910_FSKRSTEPM  0xf183
 #define FSTV0910_FSKR_STEP_MINUS  0xf18300ff
 
-/*FSKRDET1*/
+/* FSKRDET1 */
 #define RSTV0910_FSKRDET1  0xf184
 #define FSTV0910_FSKR_DETECT  0xf1840080
 #define FSTV0910_FSKR_CARDET_ACCU1  0xf184000f
 
-/*FSKRDET0*/
+/* FSKRDET0 */
 #define RSTV0910_FSKRDET0  0xf185
 #define FSTV0910_FSKR_CARDET_ACCU0  0xf18500ff
 
-/*FSKRDTH1*/
+/* FSKRDTH1 */
 #define RSTV0910_FSKRDTH1  0xf186
 #define FSTV0910_FSKR_CARLOSS_THRESH1  0xf18600f0
 #define FSTV0910_FSKR_CARDET_THRESH1  0xf186000f
 
-/*FSKRDTH0*/
+/* FSKRDTH0 */
 #define RSTV0910_FSKRDTH0  0xf187
 #define FSTV0910_FSKR_CARDET_THRESH0  0xf18700ff
 
-/*FSKRLOSS*/
+/* FSKRLOSS */
 #define RSTV0910_FSKRLOSS  0xf188
 #define FSTV0910_FSKR_CARLOSS_THRESH0  0xf18800ff
 
-/*NCOARSE*/
+/* NCOARSE */
 #define RSTV0910_NCOARSE  0xf1b3
 #define FSTV0910_CP  0xf1b300f8
 #define FSTV0910_IDF  0xf1b30007
 
-/*NCOARSE1*/
+/* NCOARSE1 */
 #define RSTV0910_NCOARSE1  0xf1b4
 #define FSTV0910_N_DIV  0xf1b400ff
 
-/*NCOARSE2*/
+/* NCOARSE2 */
 #define RSTV0910_NCOARSE2  0xf1b5
 #define FSTV0910_ODF  0xf1b5003f
 
-/*SYNTCTRL*/
+/* SYNTCTRL */
 #define RSTV0910_SYNTCTRL  0xf1b6
 #define FSTV0910_STANDBY  0xf1b60080
 #define FSTV0910_BYPASSPLLCORE  0xf1b60040
 #define FSTV0910_STOP_PLL  0xf1b60008
 #define FSTV0910_OSCI_E  0xf1b60002
 
-/*FILTCTRL*/
+/* FILTCTRL */
 #define RSTV0910_FILTCTRL  0xf1b7
 #define FSTV0910_INV_CLKFSK  0xf1b70002
 #define FSTV0910_BYPASS_APPLI  0xf1b70001
 
-/*PLLSTAT*/
+/* PLLSTAT */
 #define RSTV0910_PLLSTAT  0xf1b8
 #define FSTV0910_PLLLOCK  0xf1b80001
 
-/*STOPCLK1*/
+/* STOPCLK1 */
 #define RSTV0910_STOPCLK1  0xf1c2
 #define FSTV0910_INV_CLKADCI2  0xf1c20004
 #define FSTV0910_INV_CLKADCI1  0xf1c20001
 
-/*STOPCLK2*/
+/* STOPCLK2 */
 #define RSTV0910_STOPCLK2  0xf1c3
 #define FSTV0910_STOP_DVBS2FEC2  0xf1c30020
 #define FSTV0910_STOP_DVBS2FEC  0xf1c30010
@@ -466,47 +467,47 @@
 #define FSTV0910_STOP_DEMOD2  0xf1c30002
 #define FSTV0910_STOP_DEMOD  0xf1c30001
 
-/*PREGCTL*/
+/* PREGCTL */
 #define RSTV0910_PREGCTL  0xf1c8
 #define FSTV0910_REG3V3TO2V5_POFF  0xf1c80080
 
-/*TSTTNR0*/
+/* TSTTNR0 */
 #define RSTV0910_TSTTNR0  0xf1df
 #define FSTV0910_FSK_PON  0xf1df0004
 
-/*TSTTNR1*/
+/* TSTTNR1 */
 #define RSTV0910_TSTTNR1  0xf1e0
 #define FSTV0910_ADC1_PON  0xf1e00002
 
-/*TSTTNR2*/
+/* TSTTNR2 */
 #define RSTV0910_TSTTNR2  0xf1e1
 #define FSTV0910_I2C_DISEQC_PON  0xf1e10020
 #define FSTV0910_DISEQC_CLKDIV  0xf1e1000f
 
-/*TSTTNR3*/
+/* TSTTNR3 */
 #define RSTV0910_TSTTNR3  0xf1e2
 #define FSTV0910_ADC2_PON  0xf1e20002
 
-/*P2_IQCONST*/
+/* P2_IQCONST */
 #define RSTV0910_P2_IQCONST  0xf200
 #define FSTV0910_P2_CONSTEL_SELECT  0xf2000060
 #define FSTV0910_P2_IQSYMB_SEL  0xf200001f
 
-/*P2_NOSCFG*/
+/* P2_NOSCFG */
 #define RSTV0910_P2_NOSCFG  0xf201
 #define FSTV0910_P2_DUMMYPL_NOSDATA  0xf2010020
 #define FSTV0910_P2_NOSPLH_BETA  0xf2010018
 #define FSTV0910_P2_NOSDATA_BETA  0xf2010007
 
-/*P2_ISYMB*/
+/* P2_ISYMB */
 #define RSTV0910_P2_ISYMB  0xf202
 #define FSTV0910_P2_I_SYMBOL  0xf20201ff
 
-/*P2_QSYMB*/
+/* P2_QSYMB */
 #define RSTV0910_P2_QSYMB  0xf203
 #define FSTV0910_P2_Q_SYMBOL  0xf20301ff
 
-/*P2_AGC1CFG*/
+/* P2_AGC1CFG */
 #define RSTV0910_P2_AGC1CFG  0xf204
 #define FSTV0910_P2_DC_FROZEN  0xf2040080
 #define FSTV0910_P2_DC_CORRECT  0xf2040040
@@ -515,70 +516,70 @@
 #define FSTV0910_P2_QUAD_FROZEN  0xf2040008
 #define FSTV0910_P2_QUAD_CORRECT  0xf2040004
 
-/*P2_AGC1CN*/
+/* P2_AGC1CN */
 #define RSTV0910_P2_AGC1CN  0xf206
 #define FSTV0910_P2_AGC1_LOCKED  0xf2060080
 #define FSTV0910_P2_AGC1_MINPOWER  0xf2060010
 #define FSTV0910_P2_AGCOUT_FAST  0xf2060008
 #define FSTV0910_P2_AGCIQ_BETA  0xf2060007
 
-/*P2_AGC1REF*/
+/* P2_AGC1REF */
 #define RSTV0910_P2_AGC1REF  0xf207
 #define FSTV0910_P2_AGCIQ_REF  0xf20700ff
 
-/*P2_IDCCOMP*/
+/* P2_IDCCOMP */
 #define RSTV0910_P2_IDCCOMP  0xf208
 #define FSTV0910_P2_IAVERAGE_ADJ  0xf20801ff
 
-/*P2_QDCCOMP*/
+/* P2_QDCCOMP */
 #define RSTV0910_P2_QDCCOMP  0xf209
 #define FSTV0910_P2_QAVERAGE_ADJ  0xf20901ff
 
-/*P2_POWERI*/
+/* P2_POWERI */
 #define RSTV0910_P2_POWERI  0xf20a
 #define FSTV0910_P2_POWER_I  0xf20a00ff
 
-/*P2_POWERQ*/
+/* P2_POWERQ */
 #define RSTV0910_P2_POWERQ  0xf20b
 #define FSTV0910_P2_POWER_Q  0xf20b00ff
 
-/*P2_AGC1AMM*/
+/* P2_AGC1AMM */
 #define RSTV0910_P2_AGC1AMM  0xf20c
 #define FSTV0910_P2_AMM_VALUE  0xf20c00ff
 
-/*P2_AGC1QUAD*/
+/* P2_AGC1QUAD */
 #define RSTV0910_P2_AGC1QUAD  0xf20d
 #define FSTV0910_P2_QUAD_VALUE  0xf20d01ff
 
-/*P2_AGCIQIN1*/
+/* P2_AGCIQIN1 */
 #define RSTV0910_P2_AGCIQIN1  0xf20e
 #define FSTV0910_P2_AGCIQ_VALUE1  0xf20e00ff
 
-/*P2_AGCIQIN0*/
+/* P2_AGCIQIN0 */
 #define RSTV0910_P2_AGCIQIN0  0xf20f
 #define FSTV0910_P2_AGCIQ_VALUE0  0xf20f00ff
 
-/*P2_DEMOD*/
+/* P2_DEMOD */
 #define RSTV0910_P2_DEMOD  0xf210
 #define FSTV0910_P2_MANUALS2_ROLLOFF  0xf2100080
 #define FSTV0910_P2_SPECINV_CONTROL  0xf2100030
 #define FSTV0910_P2_MANUALSX_ROLLOFF  0xf2100004
 #define FSTV0910_P2_ROLLOFF_CONTROL  0xf2100003
 
-/*P2_DMDMODCOD*/
+/* P2_DMDMODCOD */
 #define RSTV0910_P2_DMDMODCOD  0xf211
 #define FSTV0910_P2_MANUAL_MODCOD  0xf2110080
 #define FSTV0910_P2_DEMOD_MODCOD  0xf211007c
 #define FSTV0910_P2_DEMOD_TYPE  0xf2110003
 
-/*P2_DSTATUS*/
+/* P2_DSTATUS */
 #define RSTV0910_P2_DSTATUS  0xf212
 #define FSTV0910_P2_CAR_LOCK  0xf2120080
 #define FSTV0910_P2_TMGLOCK_QUALITY  0xf2120060
 #define FSTV0910_P2_LOCK_DEFINITIF  0xf2120008
 #define FSTV0910_P2_OVADC_DETECT  0xf2120001
 
-/*P2_DSTATUS2*/
+/* P2_DSTATUS2 */
 #define RSTV0910_P2_DSTATUS2  0xf213
 #define FSTV0910_P2_DEMOD_DELOCK  0xf2130080
 #define FSTV0910_P2_MODCODRQ_SYNCTAG  0xf2130020
@@ -588,7 +589,7 @@
 #define FSTV0910_P2_CFR_OVERFLOW  0xf2130002
 #define FSTV0910_P2_GAMMA_OVERUNDER  0xf2130001
 
-/*P2_DMDCFGMD*/
+/* P2_DMDCFGMD */
 #define RSTV0910_P2_DMDCFGMD  0xf214
 #define FSTV0910_P2_DVBS2_ENABLE  0xf2140080
 #define FSTV0910_P2_DVBS1_ENABLE  0xf2140040
@@ -596,503 +597,503 @@
 #define FSTV0910_P2_CFR_AUTOSCAN  0xf2140008
 #define FSTV0910_P2_TUN_RNG  0xf2140003
 
-/*P2_DMDCFG2*/
+/* P2_DMDCFG2 */
 #define RSTV0910_P2_DMDCFG2  0xf215
 #define FSTV0910_P2_S1S2_SEQUENTIAL  0xf2150040
 #define FSTV0910_P2_INFINITE_RELOCK  0xf2150010
 
-/*P2_DMDISTATE*/
+/* P2_DMDISTATE */
 #define RSTV0910_P2_DMDISTATE  0xf216
 #define FSTV0910_P2_I2C_NORESETDMODE  0xf2160080
 #define FSTV0910_P2_I2C_DEMOD_MODE  0xf216001f
 
-/*P2_DMDT0M*/
+/* P2_DMDT0M */
 #define RSTV0910_P2_DMDT0M  0xf217
 #define FSTV0910_P2_DMDT0_MIN  0xf21700ff
 
-/*P2_DMDSTATE*/
+/* P2_DMDSTATE */
 #define RSTV0910_P2_DMDSTATE  0xf21b
 #define FSTV0910_P2_HEADER_MODE  0xf21b0060
 
-/*P2_DMDFLYW*/
+/* P2_DMDFLYW */
 #define RSTV0910_P2_DMDFLYW  0xf21c
 #define FSTV0910_P2_I2C_IRQVAL  0xf21c00f0
 #define FSTV0910_P2_FLYWHEEL_CPT  0xf21c000f
 
-/*P2_DSTATUS3*/
+/* P2_DSTATUS3 */
 #define RSTV0910_P2_DSTATUS3  0xf21d
 #define FSTV0910_P2_CFR_ZIGZAG  0xf21d0080
 #define FSTV0910_P2_DEMOD_CFGMODE  0xf21d0060
 #define FSTV0910_P2_GAMMA_LOWBAUDRATE  0xf21d0010
 
-/*P2_DMDCFG3*/
+/* P2_DMDCFG3 */
 #define RSTV0910_P2_DMDCFG3  0xf21e
 #define FSTV0910_P2_NOSTOP_FIFOFULL  0xf21e0008
 
-/*P2_DMDCFG4*/
+/* P2_DMDCFG4 */
 #define RSTV0910_P2_DMDCFG4  0xf21f
 #define FSTV0910_P2_DIS_VITLOCK  0xf21f0080
 #define FSTV0910_P2_DIS_CLKENABLE  0xf21f0004
 
-/*P2_CORRELMANT*/
+/* P2_CORRELMANT */
 #define RSTV0910_P2_CORRELMANT  0xf220
 #define FSTV0910_P2_CORREL_MANT  0xf22000ff
 
-/*P2_CORRELABS*/
+/* P2_CORRELABS */
 #define RSTV0910_P2_CORRELABS  0xf221
 #define FSTV0910_P2_CORREL_ABS  0xf22100ff
 
-/*P2_CORRELEXP*/
+/* P2_CORRELEXP */
 #define RSTV0910_P2_CORRELEXP  0xf222
 #define FSTV0910_P2_CORREL_ABSEXP  0xf22200f0
 #define FSTV0910_P2_CORREL_EXP  0xf222000f
 
-/*P2_PLHMODCOD*/
+/* P2_PLHMODCOD */
 #define RSTV0910_P2_PLHMODCOD  0xf224
 #define FSTV0910_P2_SPECINV_DEMOD  0xf2240080
 #define FSTV0910_P2_PLH_MODCOD  0xf224007c
 #define FSTV0910_P2_PLH_TYPE  0xf2240003
 
-/*P2_DMDREG*/
+/* P2_DMDREG */
 #define RSTV0910_P2_DMDREG  0xf225
 #define FSTV0910_P2_DECIM_PLFRAMES  0xf2250001
 
-/*P2_AGCNADJ*/
+/* P2_AGCNADJ */
 #define RSTV0910_P2_AGCNADJ  0xf226
 #define FSTV0910_P2_RADJOFF_AGC2  0xf2260080
 #define FSTV0910_P2_RADJOFF_AGC1  0xf2260040
 #define FSTV0910_P2_AGC_NADJ  0xf226013f
 
-/*P2_AGCKS*/
+/* P2_AGCKS */
 #define RSTV0910_P2_AGCKS  0xf227
 #define FSTV0910_P2_RSADJ_MANUALCFG  0xf2270080
 #define FSTV0910_P2_RSADJ_CCMMODE  0xf2270040
 #define FSTV0910_P2_RADJ_SPSK  0xf227013f
 
-/*P2_AGCKQ*/
+/* P2_AGCKQ */
 #define RSTV0910_P2_AGCKQ  0xf228
 #define FSTV0910_P2_RADJON_DVBS1  0xf2280040
 #define FSTV0910_P2_RADJ_QPSK  0xf228013f
 
-/*P2_AGCK8*/
+/* P2_AGCK8 */
 #define RSTV0910_P2_AGCK8  0xf229
 #define FSTV0910_P2_RADJ_8PSK  0xf229013f
 
-/*P2_AGCK16*/
+/* P2_AGCK16 */
 #define RSTV0910_P2_AGCK16  0xf22a
 #define FSTV0910_P2_R2ADJOFF_16APSK  0xf22a0040
 #define FSTV0910_P2_R1ADJOFF_16APSK  0xf22a0020
 #define FSTV0910_P2_RADJ_16APSK  0xf22a011f
 
-/*P2_AGCK32*/
+/* P2_AGCK32 */
 #define RSTV0910_P2_AGCK32  0xf22b
 #define FSTV0910_P2_R3ADJOFF_32APSK  0xf22b0080
 #define FSTV0910_P2_R2ADJOFF_32APSK  0xf22b0040
 #define FSTV0910_P2_R1ADJOFF_32APSK  0xf22b0020
 #define FSTV0910_P2_RADJ_32APSK  0xf22b011f
 
-/*P2_AGC2O*/
+/* P2_AGC2O */
 #define RSTV0910_P2_AGC2O  0xf22c
 #define FSTV0910_P2_CSTENV_MODE  0xf22c00c0
 #define FSTV0910_P2_AGC2_COEF  0xf22c0007
 
-/*P2_AGC2REF*/
+/* P2_AGC2REF */
 #define RSTV0910_P2_AGC2REF  0xf22d
 #define FSTV0910_P2_AGC2_REF  0xf22d00ff
 
-/*P2_AGC1ADJ*/
+/* P2_AGC1ADJ */
 #define RSTV0910_P2_AGC1ADJ  0xf22e
 #define FSTV0910_P2_AGC1_ADJUSTED  0xf22e007f
 
-/*P2_AGCRSADJ*/
+/* P2_AGCRSADJ */
 #define RSTV0910_P2_AGCRSADJ  0xf22f
 #define FSTV0910_P2_RS_ADJUSTED  0xf22f007f
 
-/*P2_AGCRQADJ*/
+/* P2_AGCRQADJ */
 #define RSTV0910_P2_AGCRQADJ  0xf230
 #define FSTV0910_P2_RQ_ADJUSTED  0xf230007f
 
-/*P2_AGCR8ADJ*/
+/* P2_AGCR8ADJ */
 #define RSTV0910_P2_AGCR8ADJ  0xf231
 #define FSTV0910_P2_R8_ADJUSTED  0xf231007f
 
-/*P2_AGCR1ADJ*/
+/* P2_AGCR1ADJ */
 #define RSTV0910_P2_AGCR1ADJ  0xf232
 #define FSTV0910_P2_R1_ADJUSTED  0xf232007f
 
-/*P2_AGCR2ADJ*/
+/* P2_AGCR2ADJ */
 #define RSTV0910_P2_AGCR2ADJ  0xf233
 #define FSTV0910_P2_R2_ADJUSTED  0xf233007f
 
-/*P2_AGCR3ADJ*/
+/* P2_AGCR3ADJ */
 #define RSTV0910_P2_AGCR3ADJ  0xf234
 #define FSTV0910_P2_R3_ADJUSTED  0xf234007f
 
-/*P2_AGCREFADJ*/
+/* P2_AGCREFADJ */
 #define RSTV0910_P2_AGCREFADJ  0xf235
 #define FSTV0910_P2_AGC2REF_ADJUSTED  0xf235007f
 
-/*P2_AGC2I1*/
+/* P2_AGC2I1 */
 #define RSTV0910_P2_AGC2I1  0xf236
 #define FSTV0910_P2_AGC2_INTEGRATOR1  0xf23600ff
 
-/*P2_AGC2I0*/
+/* P2_AGC2I0 */
 #define RSTV0910_P2_AGC2I0  0xf237
 #define FSTV0910_P2_AGC2_INTEGRATOR0  0xf23700ff
 
-/*P2_CARCFG*/
+/* P2_CARCFG */
 #define RSTV0910_P2_CARCFG  0xf238
 #define FSTV0910_P2_ROTAON  0xf2380004
 #define FSTV0910_P2_PH_DET_ALGO  0xf2380003
 
-/*P2_ACLC*/
+/* P2_ACLC */
 #define RSTV0910_P2_ACLC  0xf239
 #define FSTV0910_P2_CAR_ALPHA_MANT  0xf2390030
 #define FSTV0910_P2_CAR_ALPHA_EXP  0xf239000f
 
-/*P2_BCLC*/
+/* P2_BCLC */
 #define RSTV0910_P2_BCLC  0xf23a
 #define FSTV0910_P2_CAR_BETA_MANT  0xf23a0030
 #define FSTV0910_P2_CAR_BETA_EXP  0xf23a000f
 
-/*P2_ACLCS2*/
+/* P2_ACLCS2 */
 #define RSTV0910_P2_ACLCS2  0xf23b
 #define FSTV0910_P2_CARS2_APLHA_MANTISSE  0xf23b0030
 #define FSTV0910_P2_CARS2_ALPHA_EXP  0xf23b000f
 
-/*P2_BCLCS2*/
+/* P2_BCLCS2 */
 #define RSTV0910_P2_BCLCS2  0xf23c
 #define FSTV0910_P2_CARS2_BETA_MANTISSE  0xf23c0030
 #define FSTV0910_P2_CARS2_BETA_EXP  0xf23c000f
 
-/*P2_CARFREQ*/
+/* P2_CARFREQ */
 #define RSTV0910_P2_CARFREQ  0xf23d
 #define FSTV0910_P2_KC_COARSE_EXP  0xf23d00f0
 #define FSTV0910_P2_BETA_FREQ  0xf23d000f
 
-/*P2_CARHDR*/
+/* P2_CARHDR */
 #define RSTV0910_P2_CARHDR  0xf23e
 #define FSTV0910_P2_K_FREQ_HDR  0xf23e00ff
 
-/*P2_LDT*/
+/* P2_LDT */
 #define RSTV0910_P2_LDT  0xf23f
 #define FSTV0910_P2_CARLOCK_THRES  0xf23f01ff
 
-/*P2_LDT2*/
+/* P2_LDT2 */
 #define RSTV0910_P2_LDT2  0xf240
 #define FSTV0910_P2_CARLOCK_THRES2  0xf24001ff
 
-/*P2_CFRICFG*/
+/* P2_CFRICFG */
 #define RSTV0910_P2_CFRICFG  0xf241
 #define FSTV0910_P2_NEG_CFRSTEP  0xf2410001
 
-/*P2_CFRUP1*/
+/* P2_CFRUP1 */
 #define RSTV0910_P2_CFRUP1  0xf242
 #define FSTV0910_P2_CFR_UP1  0xf24201ff
 
-/*P2_CFRUP0*/
+/* P2_CFRUP0 */
 #define RSTV0910_P2_CFRUP0  0xf243
 #define FSTV0910_P2_CFR_UP0  0xf24300ff
 
-/*P2_CFRIBASE1*/
+/* P2_CFRIBASE1 */
 #define RSTV0910_P2_CFRIBASE1  0xf244
 #define FSTV0910_P2_CFRINIT_BASE1  0xf24400ff
 
-/*P2_CFRIBASE0*/
+/* P2_CFRIBASE0 */
 #define RSTV0910_P2_CFRIBASE0  0xf245
 #define FSTV0910_P2_CFRINIT_BASE0  0xf24500ff
 
-/*P2_CFRLOW1*/
+/* P2_CFRLOW1 */
 #define RSTV0910_P2_CFRLOW1  0xf246
 #define FSTV0910_P2_CFR_LOW1  0xf24601ff
 
-/*P2_CFRLOW0*/
+/* P2_CFRLOW0 */
 #define RSTV0910_P2_CFRLOW0  0xf247
 #define FSTV0910_P2_CFR_LOW0  0xf24700ff
 
-/*P2_CFRINIT1*/
+/* P2_CFRINIT1 */
 #define RSTV0910_P2_CFRINIT1  0xf248
 #define FSTV0910_P2_CFR_INIT1  0xf24801ff
 
-/*P2_CFRINIT0*/
+/* P2_CFRINIT0 */
 #define RSTV0910_P2_CFRINIT0  0xf249
 #define FSTV0910_P2_CFR_INIT0  0xf24900ff
 
-/*P2_CFRINC1*/
+/* P2_CFRINC1 */
 #define RSTV0910_P2_CFRINC1  0xf24a
 #define FSTV0910_P2_MANUAL_CFRINC  0xf24a0080
 #define FSTV0910_P2_CFR_INC1  0xf24a003f
 
-/*P2_CFRINC0*/
+/* P2_CFRINC0 */
 #define RSTV0910_P2_CFRINC0  0xf24b
 #define FSTV0910_P2_CFR_INC0  0xf24b00ff
 
-/*P2_CFR2*/
+/* P2_CFR2 */
 #define RSTV0910_P2_CFR2  0xf24c
 #define FSTV0910_P2_CAR_FREQ2  0xf24c01ff
 
-/*P2_CFR1*/
+/* P2_CFR1 */
 #define RSTV0910_P2_CFR1  0xf24d
 #define FSTV0910_P2_CAR_FREQ1  0xf24d00ff
 
-/*P2_CFR0*/
+/* P2_CFR0 */
 #define RSTV0910_P2_CFR0  0xf24e
 #define FSTV0910_P2_CAR_FREQ0  0xf24e00ff
 
-/*P2_LDI*/
+/* P2_LDI */
 #define RSTV0910_P2_LDI  0xf24f
 #define FSTV0910_P2_LOCK_DET_INTEGR  0xf24f01ff
 
-/*P2_TMGCFG*/
+/* P2_TMGCFG */
 #define RSTV0910_P2_TMGCFG  0xf250
 #define FSTV0910_P2_TMGLOCK_BETA  0xf25000c0
 #define FSTV0910_P2_DO_TIMING_CORR  0xf2500010
 #define FSTV0910_P2_TMG_MINFREQ  0xf2500003
 
-/*P2_RTC*/
+/* P2_RTC */
 #define RSTV0910_P2_RTC  0xf251
 #define FSTV0910_P2_TMGALPHA_EXP  0xf25100f0
 #define FSTV0910_P2_TMGBETA_EXP  0xf251000f
 
-/*P2_RTCS2*/
+/* P2_RTCS2 */
 #define RSTV0910_P2_RTCS2  0xf252
 #define FSTV0910_P2_TMGALPHAS2_EXP  0xf25200f0
 #define FSTV0910_P2_TMGBETAS2_EXP  0xf252000f
 
-/*P2_TMGTHRISE*/
+/* P2_TMGTHRISE */
 #define RSTV0910_P2_TMGTHRISE  0xf253
 #define FSTV0910_P2_TMGLOCK_THRISE  0xf25300ff
 
-/*P2_TMGTHFALL*/
+/* P2_TMGTHFALL */
 #define RSTV0910_P2_TMGTHFALL  0xf254
 #define FSTV0910_P2_TMGLOCK_THFALL  0xf25400ff
 
-/*P2_SFRUPRATIO*/
+/* P2_SFRUPRATIO */
 #define RSTV0910_P2_SFRUPRATIO  0xf255
 #define FSTV0910_P2_SFR_UPRATIO  0xf25500ff
 
-/*P2_SFRLOWRATIO*/
+/* P2_SFRLOWRATIO */
 #define RSTV0910_P2_SFRLOWRATIO  0xf256
 #define FSTV0910_P2_SFR_LOWRATIO  0xf25600ff
 
-/*P2_KTTMG*/
+/* P2_KTTMG */
 #define RSTV0910_P2_KTTMG  0xf257
 #define FSTV0910_P2_KT_TMG_EXP  0xf25700f0
 
-/*P2_KREFTMG*/
+/* P2_KREFTMG */
 #define RSTV0910_P2_KREFTMG  0xf258
 #define FSTV0910_P2_KREF_TMG  0xf25800ff
 
-/*P2_SFRSTEP*/
+/* P2_SFRSTEP */
 #define RSTV0910_P2_SFRSTEP  0xf259
 #define FSTV0910_P2_SFR_SCANSTEP  0xf25900f0
 #define FSTV0910_P2_SFR_CENTERSTEP  0xf259000f
 
-/*P2_TMGCFG2*/
+/* P2_TMGCFG2 */
 #define RSTV0910_P2_TMGCFG2  0xf25a
 #define FSTV0910_P2_DIS_AUTOSAMP  0xf25a0008
 #define FSTV0910_P2_SFRRATIO_FINE  0xf25a0001
 
-/*P2_KREFTMG2*/
+/* P2_KREFTMG2 */
 #define RSTV0910_P2_KREFTMG2  0xf25b
 #define FSTV0910_P2_KREF_TMG2  0xf25b00ff
 
-/*P2_TMGCFG3*/
+/* P2_TMGCFG3 */
 #define RSTV0910_P2_TMGCFG3  0xf25d
 #define FSTV0910_P2_CONT_TMGCENTER  0xf25d0008
 #define FSTV0910_P2_AUTO_GUP  0xf25d0004
 #define FSTV0910_P2_AUTO_GLOW  0xf25d0002
 
-/*P2_SFRINIT1*/
+/* P2_SFRINIT1 */
 #define RSTV0910_P2_SFRINIT1  0xf25e
 #define FSTV0910_P2_SFR_INIT1  0xf25e00ff
 
-/*P2_SFRINIT0*/
+/* P2_SFRINIT0 */
 #define RSTV0910_P2_SFRINIT0  0xf25f
 #define FSTV0910_P2_SFR_INIT0  0xf25f00ff
 
-/*P2_SFRUP1*/
+/* P2_SFRUP1 */
 #define RSTV0910_P2_SFRUP1  0xf260
 #define FSTV0910_P2_SYMB_FREQ_UP1  0xf26000ff
 
-/*P2_SFRUP0*/
+/* P2_SFRUP0 */
 #define RSTV0910_P2_SFRUP0  0xf261
 #define FSTV0910_P2_SYMB_FREQ_UP0  0xf26100ff
 
-/*P2_SFRLOW1*/
+/* P2_SFRLOW1 */
 #define RSTV0910_P2_SFRLOW1  0xf262
 #define FSTV0910_P2_SYMB_FREQ_LOW1  0xf26200ff
 
-/*P2_SFRLOW0*/
+/* P2_SFRLOW0 */
 #define RSTV0910_P2_SFRLOW0  0xf263
 #define FSTV0910_P2_SYMB_FREQ_LOW0  0xf26300ff
 
-/*P2_SFR3*/
+/* P2_SFR3 */
 #define RSTV0910_P2_SFR3  0xf264
 #define FSTV0910_P2_SYMB_FREQ3  0xf26400ff
 
-/*P2_SFR2*/
+/* P2_SFR2 */
 #define RSTV0910_P2_SFR2  0xf265
 #define FSTV0910_P2_SYMB_FREQ2  0xf26500ff
 
-/*P2_SFR1*/
+/* P2_SFR1 */
 #define RSTV0910_P2_SFR1  0xf266
 #define FSTV0910_P2_SYMB_FREQ1  0xf26600ff
 
-/*P2_SFR0*/
+/* P2_SFR0 */
 #define RSTV0910_P2_SFR0  0xf267
 #define FSTV0910_P2_SYMB_FREQ0  0xf26700ff
 
-/*P2_TMGREG2*/
+/* P2_TMGREG2 */
 #define RSTV0910_P2_TMGREG2  0xf268
 #define FSTV0910_P2_TMGREG2  0xf26800ff
 
-/*P2_TMGREG1*/
+/* P2_TMGREG1 */
 #define RSTV0910_P2_TMGREG1  0xf269
 #define FSTV0910_P2_TMGREG1  0xf26900ff
 
-/*P2_TMGREG0*/
+/* P2_TMGREG0 */
 #define RSTV0910_P2_TMGREG0  0xf26a
 #define FSTV0910_P2_TMGREG0  0xf26a00ff
 
-/*P2_TMGLOCK1*/
+/* P2_TMGLOCK1 */
 #define RSTV0910_P2_TMGLOCK1  0xf26b
 #define FSTV0910_P2_TMGLOCK_LEVEL1  0xf26b01ff
 
-/*P2_TMGLOCK0*/
+/* P2_TMGLOCK0 */
 #define RSTV0910_P2_TMGLOCK0  0xf26c
 #define FSTV0910_P2_TMGLOCK_LEVEL0  0xf26c00ff
 
-/*P2_TMGOBS*/
+/* P2_TMGOBS */
 #define RSTV0910_P2_TMGOBS  0xf26d
 #define FSTV0910_P2_ROLLOFF_STATUS  0xf26d00c0
 
-/*P2_EQUALCFG*/
+/* P2_EQUALCFG */
 #define RSTV0910_P2_EQUALCFG  0xf26f
 #define FSTV0910_P2_EQUAL_ON  0xf26f0040
 #define FSTV0910_P2_MU_EQUALDFE  0xf26f0007
 
-/*P2_EQUAI1*/
+/* P2_EQUAI1 */
 #define RSTV0910_P2_EQUAI1  0xf270
 #define FSTV0910_P2_EQUA_ACCI1  0xf27001ff
 
-/*P2_EQUAQ1*/
+/* P2_EQUAQ1 */
 #define RSTV0910_P2_EQUAQ1  0xf271
 #define FSTV0910_P2_EQUA_ACCQ1  0xf27101ff
 
-/*P2_EQUAI2*/
+/* P2_EQUAI2 */
 #define RSTV0910_P2_EQUAI2  0xf272
 #define FSTV0910_P2_EQUA_ACCI2  0xf27201ff
 
-/*P2_EQUAQ2*/
+/* P2_EQUAQ2 */
 #define RSTV0910_P2_EQUAQ2  0xf273
 #define FSTV0910_P2_EQUA_ACCQ2  0xf27301ff
 
-/*P2_EQUAI3*/
+/* P2_EQUAI3 */
 #define RSTV0910_P2_EQUAI3  0xf274
 #define FSTV0910_P2_EQUA_ACCI3  0xf27401ff
 
-/*P2_EQUAQ3*/
+/* P2_EQUAQ3 */
 #define RSTV0910_P2_EQUAQ3  0xf275
 #define FSTV0910_P2_EQUA_ACCQ3  0xf27501ff
 
-/*P2_EQUAI4*/
+/* P2_EQUAI4 */
 #define RSTV0910_P2_EQUAI4  0xf276
 #define FSTV0910_P2_EQUA_ACCI4  0xf27601ff
 
-/*P2_EQUAQ4*/
+/* P2_EQUAQ4 */
 #define RSTV0910_P2_EQUAQ4  0xf277
 #define FSTV0910_P2_EQUA_ACCQ4  0xf27701ff
 
-/*P2_EQUAI5*/
+/* P2_EQUAI5 */
 #define RSTV0910_P2_EQUAI5  0xf278
 #define FSTV0910_P2_EQUA_ACCI5  0xf27801ff
 
-/*P2_EQUAQ5*/
+/* P2_EQUAQ5 */
 #define RSTV0910_P2_EQUAQ5  0xf279
 #define FSTV0910_P2_EQUA_ACCQ5  0xf27901ff
 
-/*P2_EQUAI6*/
+/* P2_EQUAI6 */
 #define RSTV0910_P2_EQUAI6  0xf27a
 #define FSTV0910_P2_EQUA_ACCI6  0xf27a01ff
 
-/*P2_EQUAQ6*/
+/* P2_EQUAQ6 */
 #define RSTV0910_P2_EQUAQ6  0xf27b
 #define FSTV0910_P2_EQUA_ACCQ6  0xf27b01ff
 
-/*P2_EQUAI7*/
+/* P2_EQUAI7 */
 #define RSTV0910_P2_EQUAI7  0xf27c
 #define FSTV0910_P2_EQUA_ACCI7  0xf27c01ff
 
-/*P2_EQUAQ7*/
+/* P2_EQUAQ7 */
 #define RSTV0910_P2_EQUAQ7  0xf27d
 #define FSTV0910_P2_EQUA_ACCQ7  0xf27d01ff
 
-/*P2_EQUAI8*/
+/* P2_EQUAI8 */
 #define RSTV0910_P2_EQUAI8  0xf27e
 #define FSTV0910_P2_EQUA_ACCI8  0xf27e01ff
 
-/*P2_EQUAQ8*/
+/* P2_EQUAQ8 */
 #define RSTV0910_P2_EQUAQ8  0xf27f
 #define FSTV0910_P2_EQUA_ACCQ8  0xf27f01ff
 
-/*P2_NNOSDATAT1*/
+/* P2_NNOSDATAT1 */
 #define RSTV0910_P2_NNOSDATAT1  0xf280
 #define FSTV0910_P2_NOSDATAT_NORMED1  0xf28000ff
 
-/*P2_NNOSDATAT0*/
+/* P2_NNOSDATAT0 */
 #define RSTV0910_P2_NNOSDATAT0  0xf281
 #define FSTV0910_P2_NOSDATAT_NORMED0  0xf28100ff
 
-/*P2_NNOSDATA1*/
+/* P2_NNOSDATA1 */
 #define RSTV0910_P2_NNOSDATA1  0xf282
 #define FSTV0910_P2_NOSDATA_NORMED1  0xf28200ff
 
-/*P2_NNOSDATA0*/
+/* P2_NNOSDATA0 */
 #define RSTV0910_P2_NNOSDATA0  0xf283
 #define FSTV0910_P2_NOSDATA_NORMED0  0xf28300ff
 
-/*P2_NNOSPLHT1*/
+/* P2_NNOSPLHT1 */
 #define RSTV0910_P2_NNOSPLHT1  0xf284
 #define FSTV0910_P2_NOSPLHT_NORMED1  0xf28400ff
 
-/*P2_NNOSPLHT0*/
+/* P2_NNOSPLHT0 */
 #define RSTV0910_P2_NNOSPLHT0  0xf285
 #define FSTV0910_P2_NOSPLHT_NORMED0  0xf28500ff
 
-/*P2_NNOSPLH1*/
+/* P2_NNOSPLH1 */
 #define RSTV0910_P2_NNOSPLH1  0xf286
 #define FSTV0910_P2_NOSPLH_NORMED1  0xf28600ff
 
-/*P2_NNOSPLH0*/
+/* P2_NNOSPLH0 */
 #define RSTV0910_P2_NNOSPLH0  0xf287
 #define FSTV0910_P2_NOSPLH_NORMED0  0xf28700ff
 
-/*P2_NOSDATAT1*/
+/* P2_NOSDATAT1 */
 #define RSTV0910_P2_NOSDATAT1  0xf288
 #define FSTV0910_P2_NOSDATAT_UNNORMED1  0xf28800ff
 
-/*P2_NOSDATAT0*/
+/* P2_NOSDATAT0 */
 #define RSTV0910_P2_NOSDATAT0  0xf289
 #define FSTV0910_P2_NOSDATAT_UNNORMED0  0xf28900ff
 
-/*P2_NNOSFRAME1*/
+/* P2_NNOSFRAME1 */
 #define RSTV0910_P2_NNOSFRAME1  0xf28a
 #define FSTV0910_P2_NOSFRAME_NORMED1  0xf28a00ff
 
-/*P2_NNOSFRAME0*/
+/* P2_NNOSFRAME0 */
 #define RSTV0910_P2_NNOSFRAME0  0xf28b
 #define FSTV0910_P2_NOSFRAME_NORMED0  0xf28b00ff
 
-/*P2_NNOSRAD1*/
+/* P2_NNOSRAD1 */
 #define RSTV0910_P2_NNOSRAD1  0xf28c
 #define FSTV0910_P2_NOSRADIAL_NORMED1  0xf28c00ff
 
-/*P2_NNOSRAD0*/
+/* P2_NNOSRAD0 */
 #define RSTV0910_P2_NNOSRAD0  0xf28d
 #define FSTV0910_P2_NOSRADIAL_NORMED0  0xf28d00ff
 
-/*P2_NOSCFGF1*/
+/* P2_NOSCFGF1 */
 #define RSTV0910_P2_NOSCFGF1  0xf28e
 #define FSTV0910_P2_LOWNOISE_MESURE  0xf28e0080
 #define FSTV0910_P2_NOS_DELFRAME  0xf28e0040
@@ -1100,177 +1101,177 @@
 #define FSTV0910_P2_FRAMESEL_TYPESEL  0xf28e000c
 #define FSTV0910_P2_FRAMESEL_TYPE  0xf28e0003
 
-/*P2_NOSCFGF2*/
+/* P2_NOSCFGF2 */
 #define RSTV0910_P2_NOSCFGF2  0xf28f
 #define FSTV0910_P2_DIS_NOSPILOTS  0xf28f0080
 #define FSTV0910_P2_FRAMESEL_MODCODSEL  0xf28f0060
 #define FSTV0910_P2_FRAMESEL_MODCOD  0xf28f001f
 
-/*P2_CAR2CFG*/
+/* P2_CAR2CFG */
 #define RSTV0910_P2_CAR2CFG  0xf290
 #define FSTV0910_P2_ROTA2ON  0xf2900004
 #define FSTV0910_P2_PH_DET_ALGO2  0xf2900003
 
-/*P2_CFR2CFR1*/
+/* P2_CFR2CFR1 */
 #define RSTV0910_P2_CFR2CFR1  0xf291
 #define FSTV0910_P2_EN_S2CAR2CENTER  0xf2910020
 #define FSTV0910_P2_CFR2TOCFR1_BETA  0xf2910007
 
-/*P2_CAR3CFG*/
+/* P2_CAR3CFG */
 #define RSTV0910_P2_CAR3CFG  0xf292
 #define FSTV0910_P2_CARRIER23_MODE  0xf29200c0
 #define FSTV0910_P2_CAR3INTERM_DVBS1  0xf2920020
 #define FSTV0910_P2_ABAMPLIF_MODE  0xf2920018
 #define FSTV0910_P2_CARRIER3_ALPHA3DL  0xf2920007
 
-/*P2_CFR22*/
+/* P2_CFR22 */
 #define RSTV0910_P2_CFR22  0xf293
 #define FSTV0910_P2_CAR2_FREQ2  0xf29301ff
 
-/*P2_CFR21*/
+/* P2_CFR21 */
 #define RSTV0910_P2_CFR21  0xf294
 #define FSTV0910_P2_CAR2_FREQ1  0xf29400ff
 
-/*P2_CFR20*/
+/* P2_CFR20 */
 #define RSTV0910_P2_CFR20  0xf295
 #define FSTV0910_P2_CAR2_FREQ0  0xf29500ff
 
-/*P2_ACLC2S2Q*/
+/* P2_ACLC2S2Q */
 #define RSTV0910_P2_ACLC2S2Q  0xf297
 #define FSTV0910_P2_ENAB_SPSKSYMB  0xf2970080
 #define FSTV0910_P2_CAR2S2_Q_ALPH_M  0xf2970030
 #define FSTV0910_P2_CAR2S2_Q_ALPH_E  0xf297000f
 
-/*P2_ACLC2S28*/
+/* P2_ACLC2S28 */
 #define RSTV0910_P2_ACLC2S28  0xf298
 #define FSTV0910_P2_CAR2S2_8_ALPH_M  0xf2980030
 #define FSTV0910_P2_CAR2S2_8_ALPH_E  0xf298000f
 
-/*P2_ACLC2S216A*/
+/* P2_ACLC2S216A */
 #define RSTV0910_P2_ACLC2S216A  0xf299
 #define FSTV0910_P2_CAR2S2_16A_ALPH_M  0xf2990030
 #define FSTV0910_P2_CAR2S2_16A_ALPH_E  0xf299000f
 
-/*P2_ACLC2S232A*/
+/* P2_ACLC2S232A */
 #define RSTV0910_P2_ACLC2S232A  0xf29a
 #define FSTV0910_P2_CAR2S2_32A_ALPH_M  0xf29a0030
 #define FSTV0910_P2_CAR2S2_32A_ALPH_E  0xf29a000f
 
-/*P2_BCLC2S2Q*/
+/* P2_BCLC2S2Q */
 #define RSTV0910_P2_BCLC2S2Q  0xf29c
 #define FSTV0910_P2_CAR2S2_Q_BETA_M  0xf29c0030
 #define FSTV0910_P2_CAR2S2_Q_BETA_E  0xf29c000f
 
-/*P2_BCLC2S28*/
+/* P2_BCLC2S28 */
 #define RSTV0910_P2_BCLC2S28  0xf29d
 #define FSTV0910_P2_CAR2S2_8_BETA_M  0xf29d0030
 #define FSTV0910_P2_CAR2S2_8_BETA_E  0xf29d000f
 
-/*P2_BCLC2S216A*/
+/* P2_BCLC2S216A */
 #define RSTV0910_P2_BCLC2S216A  0xf29e
 #define FSTV0910_P2_DVBS2S216A_NIP  0xf29e0080
 #define FSTV0910_P2_CAR2S2_16A_BETA_M  0xf29e0030
 #define FSTV0910_P2_CAR2S2_16A_BETA_E  0xf29e000f
 
-/*P2_BCLC2S232A*/
+/* P2_BCLC2S232A */
 #define RSTV0910_P2_BCLC2S232A  0xf29f
 #define FSTV0910_P2_DVBS2S232A_NIP  0xf29f0080
 #define FSTV0910_P2_CAR2S2_32A_BETA_M  0xf29f0030
 #define FSTV0910_P2_CAR2S2_32A_BETA_E  0xf29f000f
 
-/*P2_PLROOT2*/
+/* P2_PLROOT2 */
 #define RSTV0910_P2_PLROOT2  0xf2ac
 #define FSTV0910_P2_PLSCRAMB_MODE  0xf2ac000c
 #define FSTV0910_P2_PLSCRAMB_ROOT2  0xf2ac0003
 
-/*P2_PLROOT1*/
+/* P2_PLROOT1 */
 #define RSTV0910_P2_PLROOT1  0xf2ad
 #define FSTV0910_P2_PLSCRAMB_ROOT1  0xf2ad00ff
 
-/*P2_PLROOT0*/
+/* P2_PLROOT0 */
 #define RSTV0910_P2_PLROOT0  0xf2ae
 #define FSTV0910_P2_PLSCRAMB_ROOT0  0xf2ae00ff
 
-/*P2_MODCODLST0*/
+/* P2_MODCODLST0 */
 #define RSTV0910_P2_MODCODLST0  0xf2b0
 #define FSTV0910_P2_NACCES_MODCODCH  0xf2b00001
 
-/*P2_MODCODLST1*/
+/* P2_MODCODLST1 */
 #define RSTV0910_P2_MODCODLST1  0xf2b1
 #define FSTV0910_P2_SYMBRATE_FILTER  0xf2b10008
 #define FSTV0910_P2_NRESET_MODCODLST  0xf2b10004
 #define FSTV0910_P2_DIS_32PSK_9_10  0xf2b10003
 
-/*P2_MODCODLST2*/
+/* P2_MODCODLST2 */
 #define RSTV0910_P2_MODCODLST2  0xf2b2
 #define FSTV0910_P2_DIS_32PSK_8_9  0xf2b200f0
 #define FSTV0910_P2_DIS_32PSK_5_6  0xf2b2000f
 
-/*P2_MODCODLST3*/
+/* P2_MODCODLST3 */
 #define RSTV0910_P2_MODCODLST3  0xf2b3
 #define FSTV0910_P2_DIS_32PSK_4_5  0xf2b300f0
 #define FSTV0910_P2_DIS_32PSK_3_4  0xf2b3000f
 
-/*P2_MODCODLST4*/
+/* P2_MODCODLST4 */
 #define RSTV0910_P2_MODCODLST4  0xf2b4
 #define FSTV0910_P2_DUMMYPL_PILOT  0xf2b40080
 #define FSTV0910_P2_DUMMYPL_NOPILOT  0xf2b40040
 #define FSTV0910_P2_DIS_16PSK_9_10  0xf2b40030
 #define FSTV0910_P2_DIS_16PSK_8_9  0xf2b4000f
 
-/*P2_MODCODLST5*/
+/* P2_MODCODLST5 */
 #define RSTV0910_P2_MODCODLST5  0xf2b5
 #define FSTV0910_P2_DIS_16PSK_5_6  0xf2b500f0
 #define FSTV0910_P2_DIS_16PSK_4_5  0xf2b5000f
 
-/*P2_MODCODLST6*/
+/* P2_MODCODLST6 */
 #define RSTV0910_P2_MODCODLST6  0xf2b6
 #define FSTV0910_P2_DIS_16PSK_3_4  0xf2b600f0
 #define FSTV0910_P2_DIS_16PSK_2_3  0xf2b6000f
 
-/*P2_MODCODLST7*/
+/* P2_MODCODLST7 */
 #define RSTV0910_P2_MODCODLST7  0xf2b7
 #define FSTV0910_P2_MODCOD_NNOSFILTER  0xf2b70080
 #define FSTV0910_P2_DIS_8PSK_9_10  0xf2b70030
 #define FSTV0910_P2_DIS_8PSK_8_9  0xf2b7000f
 
-/*P2_MODCODLST8*/
+/* P2_MODCODLST8 */
 #define RSTV0910_P2_MODCODLST8  0xf2b8
 #define FSTV0910_P2_DIS_8PSK_5_6  0xf2b800f0
 #define FSTV0910_P2_DIS_8PSK_3_4  0xf2b8000f
 
-/*P2_MODCODLST9*/
+/* P2_MODCODLST9 */
 #define RSTV0910_P2_MODCODLST9  0xf2b9
 #define FSTV0910_P2_DIS_8PSK_2_3  0xf2b900f0
 #define FSTV0910_P2_DIS_8PSK_3_5  0xf2b9000f
 
-/*P2_MODCODLSTA*/
+/* P2_MODCODLSTA */
 #define RSTV0910_P2_MODCODLSTA  0xf2ba
 #define FSTV0910_P2_NOSFILTER_LIMITE  0xf2ba0080
 #define FSTV0910_P2_DIS_QPSK_9_10  0xf2ba0030
 #define FSTV0910_P2_DIS_QPSK_8_9  0xf2ba000f
 
-/*P2_MODCODLSTB*/
+/* P2_MODCODLSTB */
 #define RSTV0910_P2_MODCODLSTB  0xf2bb
 #define FSTV0910_P2_DIS_QPSK_5_6  0xf2bb00f0
 #define FSTV0910_P2_DIS_QPSK_4_5  0xf2bb000f
 
-/*P2_MODCODLSTC*/
+/* P2_MODCODLSTC */
 #define RSTV0910_P2_MODCODLSTC  0xf2bc
 #define FSTV0910_P2_DIS_QPSK_3_4  0xf2bc00f0
 #define FSTV0910_P2_DIS_QPSK_2_3  0xf2bc000f
 
-/*P2_MODCODLSTD*/
+/* P2_MODCODLSTD */
 #define RSTV0910_P2_MODCODLSTD  0xf2bd
 #define FSTV0910_P2_DIS_QPSK_3_5  0xf2bd00f0
 #define FSTV0910_P2_DIS_QPSK_1_2  0xf2bd000f
 
-/*P2_MODCODLSTE*/
+/* P2_MODCODLSTE */
 #define RSTV0910_P2_MODCODLSTE  0xf2be
 #define FSTV0910_P2_DIS_QPSK_2_5  0xf2be00f0
 #define FSTV0910_P2_DIS_QPSK_1_3  0xf2be000f
 
-/*P2_MODCODLSTF*/
+/* P2_MODCODLSTF */
 #define RSTV0910_P2_MODCODLSTF  0xf2bf
 #define FSTV0910_P2_DIS_QPSK_1_4  0xf2bf00f0
 #define FSTV0910_P2_DEMOD_INVMODLST  0xf2bf0008
@@ -1278,30 +1279,30 @@
 #define FSTV0910_P2_DDEMOD_NSET  0xf2bf0002
 #define FSTV0910_P2_MODCOD_NSTOCK  0xf2bf0001
 
-/*P2_GAUSSR0*/
+/* P2_GAUSSR0 */
 #define RSTV0910_P2_GAUSSR0  0xf2c0
 #define FSTV0910_P2_EN_CCIMODE  0xf2c00080
 #define FSTV0910_P2_R0_GAUSSIEN  0xf2c0007f
 
-/*P2_CCIR0*/
+/* P2_CCIR0 */
 #define RSTV0910_P2_CCIR0  0xf2c1
 #define FSTV0910_P2_CCIDETECT_PLHONLY  0xf2c10080
 #define FSTV0910_P2_R0_CCI  0xf2c1007f
 
-/*P2_CCIQUANT*/
+/* P2_CCIQUANT */
 #define RSTV0910_P2_CCIQUANT  0xf2c2
 #define FSTV0910_P2_CCI_BETA  0xf2c200e0
 #define FSTV0910_P2_CCI_QUANT  0xf2c2001f
 
-/*P2_CCITHRES*/
+/* P2_CCITHRES */
 #define RSTV0910_P2_CCITHRES  0xf2c3
 #define FSTV0910_P2_CCI_THRESHOLD  0xf2c300ff
 
-/*P2_CCIACC*/
+/* P2_CCIACC */
 #define RSTV0910_P2_CCIACC  0xf2c4
 #define FSTV0910_P2_CCI_VALUE  0xf2c400ff
 
-/*P2_DSTATUS4*/
+/* P2_DSTATUS4 */
 #define RSTV0910_P2_DSTATUS4  0xf2c5
 #define FSTV0910_P2_RAINFADE_DETECT  0xf2c50080
 #define FSTV0910_P2_NOTHRES2_FAIL  0xf2c50040
@@ -1310,234 +1311,234 @@
 #define FSTV0910_P2_CSTENV_DETECT  0xf2c50002
 #define FSTV0910_P2_DETECTION_TRIAX  0xf2c50001
 
-/*P2_DMDRESCFG*/
+/* P2_DMDRESCFG */
 #define RSTV0910_P2_DMDRESCFG  0xf2c6
 #define FSTV0910_P2_DMDRES_RESET  0xf2c60080
 #define FSTV0910_P2_DMDRES_STRALL  0xf2c60008
 #define FSTV0910_P2_DMDRES_NEWONLY  0xf2c60004
 #define FSTV0910_P2_DMDRES_NOSTORE  0xf2c60002
 
-/*P2_DMDRESADR*/
+/* P2_DMDRESADR */
 #define RSTV0910_P2_DMDRESADR  0xf2c7
 #define FSTV0910_P2_DMDRES_VALIDCFR  0xf2c70040
 #define FSTV0910_P2_DMDRES_MEMFULL  0xf2c70030
 #define FSTV0910_P2_DMDRES_RESNBR  0xf2c7000f
 
-/*P2_DMDRESDATA7*/
+/* P2_DMDRESDATA7 */
 #define RSTV0910_P2_DMDRESDATA7  0xf2c8
 #define FSTV0910_P2_DMDRES_DATA7  0xf2c800ff
 
-/*P2_DMDRESDATA6*/
+/* P2_DMDRESDATA6 */
 #define RSTV0910_P2_DMDRESDATA6  0xf2c9
 #define FSTV0910_P2_DMDRES_DATA6  0xf2c900ff
 
-/*P2_DMDRESDATA5*/
+/* P2_DMDRESDATA5 */
 #define RSTV0910_P2_DMDRESDATA5  0xf2ca
 #define FSTV0910_P2_DMDRES_DATA5  0xf2ca00ff
 
-/*P2_DMDRESDATA4*/
+/* P2_DMDRESDATA4 */
 #define RSTV0910_P2_DMDRESDATA4  0xf2cb
 #define FSTV0910_P2_DMDRES_DATA4  0xf2cb00ff
 
-/*P2_DMDRESDATA3*/
+/* P2_DMDRESDATA3 */
 #define RSTV0910_P2_DMDRESDATA3  0xf2cc
 #define FSTV0910_P2_DMDRES_DATA3  0xf2cc00ff
 
-/*P2_DMDRESDATA2*/
+/* P2_DMDRESDATA2 */
 #define RSTV0910_P2_DMDRESDATA2  0xf2cd
 #define FSTV0910_P2_DMDRES_DATA2  0xf2cd00ff
 
-/*P2_DMDRESDATA1*/
+/* P2_DMDRESDATA1 */
 #define RSTV0910_P2_DMDRESDATA1  0xf2ce
 #define FSTV0910_P2_DMDRES_DATA1  0xf2ce00ff
 
-/*P2_DMDRESDATA0*/
+/* P2_DMDRESDATA0 */
 #define RSTV0910_P2_DMDRESDATA0  0xf2cf
 #define FSTV0910_P2_DMDRES_DATA0  0xf2cf00ff
 
-/*P2_FFEI1*/
+/* P2_FFEI1 */
 #define RSTV0910_P2_FFEI1  0xf2d0
 #define FSTV0910_P2_FFE_ACCI1  0xf2d001ff
 
-/*P2_FFEQ1*/
+/* P2_FFEQ1 */
 #define RSTV0910_P2_FFEQ1  0xf2d1
 #define FSTV0910_P2_FFE_ACCQ1  0xf2d101ff
 
-/*P2_FFEI2*/
+/* P2_FFEI2 */
 #define RSTV0910_P2_FFEI2  0xf2d2
 #define FSTV0910_P2_FFE_ACCI2  0xf2d201ff
 
-/*P2_FFEQ2*/
+/* P2_FFEQ2 */
 #define RSTV0910_P2_FFEQ2  0xf2d3
 #define FSTV0910_P2_FFE_ACCQ2  0xf2d301ff
 
-/*P2_FFEI3*/
+/* P2_FFEI3 */
 #define RSTV0910_P2_FFEI3  0xf2d4
 #define FSTV0910_P2_FFE_ACCI3  0xf2d401ff
 
-/*P2_FFEQ3*/
+/* P2_FFEQ3 */
 #define RSTV0910_P2_FFEQ3  0xf2d5
 #define FSTV0910_P2_FFE_ACCQ3  0xf2d501ff
 
-/*P2_FFEI4*/
+/* P2_FFEI4 */
 #define RSTV0910_P2_FFEI4  0xf2d6
 #define FSTV0910_P2_FFE_ACCI4  0xf2d601ff
 
-/*P2_FFEQ4*/
+/* P2_FFEQ4 */
 #define RSTV0910_P2_FFEQ4  0xf2d7
 #define FSTV0910_P2_FFE_ACCQ4  0xf2d701ff
 
-/*P2_FFECFG*/
+/* P2_FFECFG */
 #define RSTV0910_P2_FFECFG  0xf2d8
 #define FSTV0910_P2_EQUALFFE_ON  0xf2d80040
 #define FSTV0910_P2_EQUAL_USEDSYMB  0xf2d80030
 #define FSTV0910_P2_MU_EQUALFFE  0xf2d80007
 
-/*P2_TNRCFG2*/
+/* P2_TNRCFG2 */
 #define RSTV0910_P2_TNRCFG2  0xf2e1
 #define FSTV0910_P2_TUN_IQSWAP  0xf2e10080
 
-/*P2_SMAPCOEF7*/
+/* P2_SMAPCOEF7 */
 #define RSTV0910_P2_SMAPCOEF7  0xf300
 #define FSTV0910_P2_DIS_QSCALE  0xf3000080
 #define FSTV0910_P2_SMAPCOEF_Q_LLR12  0xf300017f
 
-/*P2_SMAPCOEF6*/
+/* P2_SMAPCOEF6 */
 #define RSTV0910_P2_SMAPCOEF6  0xf301
 #define FSTV0910_P2_DIS_AGC2SCALE  0xf3010080
 #define FSTV0910_P2_ADJ_8PSKLLR1  0xf3010004
 #define FSTV0910_P2_OLD_8PSKLLR1  0xf3010002
 #define FSTV0910_P2_DIS_AB8PSK  0xf3010001
 
-/*P2_SMAPCOEF5*/
+/* P2_SMAPCOEF5 */
 #define RSTV0910_P2_SMAPCOEF5  0xf302
 #define FSTV0910_P2_DIS_8SCALE  0xf3020080
 #define FSTV0910_P2_SMAPCOEF_8P_LLR23  0xf302017f
 
-/*P2_SMAPCOEF4*/
+/* P2_SMAPCOEF4 */
 #define RSTV0910_P2_SMAPCOEF4  0xf303
 #define FSTV0910_P2_SMAPCOEF_16APSK_LLR12  0xf303017f
 
-/*P2_SMAPCOEF3*/
+/* P2_SMAPCOEF3 */
 #define RSTV0910_P2_SMAPCOEF3  0xf304
 #define FSTV0910_P2_SMAPCOEF_16APSK_LLR34  0xf304017f
 
-/*P2_SMAPCOEF2*/
+/* P2_SMAPCOEF2 */
 #define RSTV0910_P2_SMAPCOEF2  0xf305
 #define FSTV0910_P2_SMAPCOEF_32APSK_R2R3  0xf30501f0
 #define FSTV0910_P2_SMAPCOEF_32APSK_LLR2  0xf305010f
 
-/*P2_SMAPCOEF1*/
+/* P2_SMAPCOEF1 */
 #define RSTV0910_P2_SMAPCOEF1  0xf306
 #define FSTV0910_P2_DIS_16SCALE  0xf3060080
 #define FSTV0910_P2_SMAPCOEF_32_LLR34  0xf306017f
 
-/*P2_SMAPCOEF0*/
+/* P2_SMAPCOEF0 */
 #define RSTV0910_P2_SMAPCOEF0  0xf307
 #define FSTV0910_P2_DIS_32SCALE  0xf3070080
 #define FSTV0910_P2_SMAPCOEF_32_LLR15  0xf307017f
 
-/*P2_NOSTHRES1*/
+/* P2_NOSTHRES1 */
 #define RSTV0910_P2_NOSTHRES1  0xf309
 #define FSTV0910_P2_NOS_THRESHOLD1  0xf30900ff
 
-/*P2_NOSTHRES2*/
+/* P2_NOSTHRES2 */
 #define RSTV0910_P2_NOSTHRES2  0xf30a
 #define FSTV0910_P2_NOS_THRESHOLD2  0xf30a00ff
 
-/*P2_NOSDIFF1*/
+/* P2_NOSDIFF1 */
 #define RSTV0910_P2_NOSDIFF1  0xf30b
 #define FSTV0910_P2_NOSTHRES1_DIFF  0xf30b00ff
 
-/*P2_RAINFADE*/
+/* P2_RAINFADE */
 #define RSTV0910_P2_RAINFADE  0xf30c
 #define FSTV0910_P2_NOSTHRES_DATAT  0xf30c0080
 #define FSTV0910_P2_RAINFADE_CNLIMIT  0xf30c0070
 #define FSTV0910_P2_RAINFADE_TIMEOUT  0xf30c0007
 
-/*P2_NOSRAMCFG*/
+/* P2_NOSRAMCFG */
 #define RSTV0910_P2_NOSRAMCFG  0xf30d
 #define FSTV0910_P2_NOSRAM_ACTIVATION  0xf30d0030
 #define FSTV0910_P2_NOSRAM_CNRONLY  0xf30d0008
 #define FSTV0910_P2_NOSRAM_LGNCNR1  0xf30d0007
 
-/*P2_NOSRAMPOS*/
+/* P2_NOSRAMPOS */
 #define RSTV0910_P2_NOSRAMPOS  0xf30e
 #define FSTV0910_P2_NOSRAM_LGNCNR0  0xf30e00f0
 #define FSTV0910_P2_NOSRAM_VALIDE  0xf30e0004
 #define FSTV0910_P2_NOSRAM_CNRVAL1  0xf30e0003
 
-/*P2_NOSRAMVAL*/
+/* P2_NOSRAMVAL */
 #define RSTV0910_P2_NOSRAMVAL  0xf30f
 #define FSTV0910_P2_NOSRAM_CNRVAL0  0xf30f00ff
 
-/*P2_DMDPLHSTAT*/
+/* P2_DMDPLHSTAT */
 #define RSTV0910_P2_DMDPLHSTAT  0xf320
 #define FSTV0910_P2_PLH_STATISTIC  0xf32000ff
 
-/*P2_LOCKTIME3*/
+/* P2_LOCKTIME3 */
 #define RSTV0910_P2_LOCKTIME3  0xf322
 #define FSTV0910_P2_DEMOD_LOCKTIME3  0xf32200ff
 
-/*P2_LOCKTIME2*/
+/* P2_LOCKTIME2 */
 #define RSTV0910_P2_LOCKTIME2  0xf323
 #define FSTV0910_P2_DEMOD_LOCKTIME2  0xf32300ff
 
-/*P2_LOCKTIME1*/
+/* P2_LOCKTIME1 */
 #define RSTV0910_P2_LOCKTIME1  0xf324
 #define FSTV0910_P2_DEMOD_LOCKTIME1  0xf32400ff
 
-/*P2_LOCKTIME0*/
+/* P2_LOCKTIME0 */
 #define RSTV0910_P2_LOCKTIME0  0xf325
 #define FSTV0910_P2_DEMOD_LOCKTIME0  0xf32500ff
 
-/*P2_VITSCALE*/
+/* P2_VITSCALE */
 #define RSTV0910_P2_VITSCALE  0xf332
 #define FSTV0910_P2_NVTH_NOSRANGE  0xf3320080
 #define FSTV0910_P2_VERROR_MAXMODE  0xf3320040
 #define FSTV0910_P2_NSLOWSN_LOCKED  0xf3320008
 #define FSTV0910_P2_DIS_RSFLOCK  0xf3320002
 
-/*P2_FECM*/
+/* P2_FECM */
 #define RSTV0910_P2_FECM  0xf333
 #define FSTV0910_P2_DSS_DVB  0xf3330080
 #define FSTV0910_P2_DSS_SRCH  0xf3330010
 #define FSTV0910_P2_SYNCVIT  0xf3330002
 #define FSTV0910_P2_IQINV  0xf3330001
 
-/*P2_VTH12*/
+/* P2_VTH12 */
 #define RSTV0910_P2_VTH12  0xf334
 #define FSTV0910_P2_VTH12  0xf33400ff
 
-/*P2_VTH23*/
+/* P2_VTH23 */
 #define RSTV0910_P2_VTH23  0xf335
 #define FSTV0910_P2_VTH23  0xf33500ff
 
-/*P2_VTH34*/
+/* P2_VTH34 */
 #define RSTV0910_P2_VTH34  0xf336
 #define FSTV0910_P2_VTH34  0xf33600ff
 
-/*P2_VTH56*/
+/* P2_VTH56 */
 #define RSTV0910_P2_VTH56  0xf337
 #define FSTV0910_P2_VTH56  0xf33700ff
 
-/*P2_VTH67*/
+/* P2_VTH67 */
 #define RSTV0910_P2_VTH67  0xf338
 #define FSTV0910_P2_VTH67  0xf33800ff
 
-/*P2_VTH78*/
+/* P2_VTH78 */
 #define RSTV0910_P2_VTH78  0xf339
 #define FSTV0910_P2_VTH78  0xf33900ff
 
-/*P2_VITCURPUN*/
+/* P2_VITCURPUN */
 #define RSTV0910_P2_VITCURPUN  0xf33a
 #define FSTV0910_P2_VIT_CURPUN  0xf33a001f
 
-/*P2_VERROR*/
+/* P2_VERROR */
 #define RSTV0910_P2_VERROR  0xf33b
 #define FSTV0910_P2_REGERR_VIT  0xf33b00ff
 
-/*P2_PRVIT*/
+/* P2_PRVIT */
 #define RSTV0910_P2_PRVIT  0xf33c
 #define FSTV0910_P2_DIS_VTHLOCK  0xf33c0040
 #define FSTV0910_P2_E7_8VIT  0xf33c0020
@@ -1547,7 +1548,7 @@
 #define FSTV0910_P2_E2_3VIT  0xf33c0002
 #define FSTV0910_P2_E1_2VIT  0xf33c0001
 
-/*P2_VAVSRVIT*/
+/* P2_VAVSRVIT */
 #define RSTV0910_P2_VAVSRVIT  0xf33d
 #define FSTV0910_P2_AMVIT  0xf33d0080
 #define FSTV0910_P2_FROZENVIT  0xf33d0040
@@ -1555,52 +1556,52 @@
 #define FSTV0910_P2_TOVVIT  0xf33d000c
 #define FSTV0910_P2_HYPVIT  0xf33d0003
 
-/*P2_VSTATUSVIT*/
+/* P2_VSTATUSVIT */
 #define RSTV0910_P2_VSTATUSVIT  0xf33e
 #define FSTV0910_P2_PRFVIT  0xf33e0010
 #define FSTV0910_P2_LOCKEDVIT  0xf33e0008
 
-/*P2_VTHINUSE*/
+/* P2_VTHINUSE */
 #define RSTV0910_P2_VTHINUSE  0xf33f
 #define FSTV0910_P2_VIT_INUSE  0xf33f00ff
 
-/*P2_KDIV12*/
+/* P2_KDIV12 */
 #define RSTV0910_P2_KDIV12  0xf340
 #define FSTV0910_P2_K_DIVIDER_12  0xf340007f
 
-/*P2_KDIV23*/
+/* P2_KDIV23 */
 #define RSTV0910_P2_KDIV23  0xf341
 #define FSTV0910_P2_K_DIVIDER_23  0xf341007f
 
-/*P2_KDIV34*/
+/* P2_KDIV34 */
 #define RSTV0910_P2_KDIV34  0xf342
 #define FSTV0910_P2_K_DIVIDER_34  0xf342007f
 
-/*P2_KDIV56*/
+/* P2_KDIV56 */
 #define RSTV0910_P2_KDIV56  0xf343
 #define FSTV0910_P2_K_DIVIDER_56  0xf343007f
 
-/*P2_KDIV67*/
+/* P2_KDIV67 */
 #define RSTV0910_P2_KDIV67  0xf344
 #define FSTV0910_P2_K_DIVIDER_67  0xf344007f
 
-/*P2_KDIV78*/
+/* P2_KDIV78 */
 #define RSTV0910_P2_KDIV78  0xf345
 #define FSTV0910_P2_K_DIVIDER_78  0xf345007f
 
-/*P2_TSPIDFLT1*/
+/* P2_TSPIDFLT1 */
 #define RSTV0910_P2_TSPIDFLT1  0xf346
 #define FSTV0910_P2_PIDFLT_ADDR  0xf34600ff
 
-/*P2_TSPIDFLT0*/
+/* P2_TSPIDFLT0 */
 #define RSTV0910_P2_TSPIDFLT0  0xf347
 #define FSTV0910_P2_PIDFLT_DATA  0xf34700ff
 
-/*P2_PDELCTRL0*/
+/* P2_PDELCTRL0 */
 #define RSTV0910_P2_PDELCTRL0  0xf34f
 #define FSTV0910_P2_ISIOBS_MODE  0xf34f0030
 
-/*P2_PDELCTRL1*/
+/* P2_PDELCTRL1 */
 #define RSTV0910_P2_PDELCTRL1  0xf350
 #define FSTV0910_P2_INV_MISMASK  0xf3500080
 #define FSTV0910_P2_FILTER_EN  0xf3500020
@@ -1609,68 +1610,68 @@
 #define FSTV0910_P2_EN_MIS00  0xf3500002
 #define FSTV0910_P2_ALGOSWRST  0xf3500001
 
-/*P2_PDELCTRL2*/
+/* P2_PDELCTRL2 */
 #define RSTV0910_P2_PDELCTRL2  0xf351
 #define FSTV0910_P2_FORCE_CONTINUOUS  0xf3510080
 #define FSTV0910_P2_RESET_UPKO_COUNT  0xf3510040
 #define FSTV0910_P2_USER_PKTDELIN_NB  0xf3510020
 #define FSTV0910_P2_FRAME_MODE  0xf3510002
 
-/*P2_HYSTTHRESH*/
+/* P2_HYSTTHRESH */
 #define RSTV0910_P2_HYSTTHRESH  0xf354
 #define FSTV0910_P2_DELIN_LOCKTHRES  0xf35400f0
 #define FSTV0910_P2_DELIN_UNLOCKTHRES  0xf354000f
 
-/*P2_UPLCCST0*/
+/* P2_UPLCCST0 */
 #define RSTV0910_P2_UPLCCST0  0xf358
 #define FSTV0910_P2_UPL_CST0  0xf35800f8
 #define FSTV0910_P2_UPL_MODE  0xf3580007
 
-/*P2_ISIENTRY*/
+/* P2_ISIENTRY */
 #define RSTV0910_P2_ISIENTRY  0xf35e
 #define FSTV0910_P2_ISI_ENTRY  0xf35e00ff
 
-/*P2_ISIBITENA*/
+/* P2_ISIBITENA */
 #define RSTV0910_P2_ISIBITENA  0xf35f
 #define FSTV0910_P2_ISI_BIT_EN  0xf35f00ff
 
-/*P2_MATSTR1*/
+/* P2_MATSTR1 */
 #define RSTV0910_P2_MATSTR1  0xf360
 #define FSTV0910_P2_MATYPE_CURRENT1  0xf36000ff
 
-/*P2_MATSTR0*/
+/* P2_MATSTR0 */
 #define RSTV0910_P2_MATSTR0  0xf361
 #define FSTV0910_P2_MATYPE_CURRENT0  0xf36100ff
 
-/*P2_UPLSTR1*/
+/* P2_UPLSTR1 */
 #define RSTV0910_P2_UPLSTR1  0xf362
 #define FSTV0910_P2_UPL_CURRENT1  0xf36200ff
 
-/*P2_UPLSTR0*/
+/* P2_UPLSTR0 */
 #define RSTV0910_P2_UPLSTR0  0xf363
 #define FSTV0910_P2_UPL_CURRENT0  0xf36300ff
 
-/*P2_DFLSTR1*/
+/* P2_DFLSTR1 */
 #define RSTV0910_P2_DFLSTR1  0xf364
 #define FSTV0910_P2_DFL_CURRENT1  0xf36400ff
 
-/*P2_DFLSTR0*/
+/* P2_DFLSTR0 */
 #define RSTV0910_P2_DFLSTR0  0xf365
 #define FSTV0910_P2_DFL_CURRENT0  0xf36500ff
 
-/*P2_SYNCSTR*/
+/* P2_SYNCSTR */
 #define RSTV0910_P2_SYNCSTR  0xf366
 #define FSTV0910_P2_SYNC_CURRENT  0xf36600ff
 
-/*P2_SYNCDSTR1*/
+/* P2_SYNCDSTR1 */
 #define RSTV0910_P2_SYNCDSTR1  0xf367
 #define FSTV0910_P2_SYNCD_CURRENT1  0xf36700ff
 
-/*P2_SYNCDSTR0*/
+/* P2_SYNCDSTR0 */
 #define RSTV0910_P2_SYNCDSTR0  0xf368
 #define FSTV0910_P2_SYNCD_CURRENT0  0xf36800ff
 
-/*P2_PDELSTATUS1*/
+/* P2_PDELSTATUS1 */
 #define RSTV0910_P2_PDELSTATUS1  0xf369
 #define FSTV0910_P2_PKTDELIN_DELOCK  0xf3690080
 #define FSTV0910_P2_SYNCDUPDFL_BADDFL  0xf3690040
@@ -1679,33 +1680,33 @@
 #define FSTV0910_P2_PKTDELIN_LOCK  0xf3690002
 #define FSTV0910_P2_FIRST_LOCK  0xf3690001
 
-/*P2_PDELSTATUS2*/
+/* P2_PDELSTATUS2 */
 #define RSTV0910_P2_PDELSTATUS2  0xf36a
 #define FSTV0910_P2_FRAME_MODCOD  0xf36a007c
 #define FSTV0910_P2_FRAME_TYPE  0xf36a0003
 
-/*P2_BBFCRCKO1*/
+/* P2_BBFCRCKO1 */
 #define RSTV0910_P2_BBFCRCKO1  0xf36b
 #define FSTV0910_P2_BBHCRC_KOCNT1  0xf36b00ff
 
-/*P2_BBFCRCKO0*/
+/* P2_BBFCRCKO0 */
 #define RSTV0910_P2_BBFCRCKO0  0xf36c
 #define FSTV0910_P2_BBHCRC_KOCNT0  0xf36c00ff
 
-/*P2_UPCRCKO1*/
+/* P2_UPCRCKO1 */
 #define RSTV0910_P2_UPCRCKO1  0xf36d
 #define FSTV0910_P2_PKTCRC_KOCNT1  0xf36d00ff
 
-/*P2_UPCRCKO0*/
+/* P2_UPCRCKO0 */
 #define RSTV0910_P2_UPCRCKO0  0xf36e
 #define FSTV0910_P2_PKTCRC_KOCNT0  0xf36e00ff
 
-/*P2_PDELCTRL3*/
+/* P2_PDELCTRL3 */
 #define RSTV0910_P2_PDELCTRL3  0xf36f
 #define FSTV0910_P2_NOFIFO_BCHERR  0xf36f0020
 #define FSTV0910_P2_PKTDELIN_DELACMERR  0xf36f0010
 
-/*P2_TSSTATEM*/
+/* P2_TSSTATEM */
 #define RSTV0910_P2_TSSTATEM  0xf370
 #define FSTV0910_P2_TSDIL_ON  0xf3700080
 #define FSTV0910_P2_TSRS_ON  0xf3700020
@@ -1715,7 +1716,7 @@
 #define FSTV0910_P2_TSACM_MODE  0xf3700002
 #define FSTV0910_P2_TSOUT_NOSYNC  0xf3700001
 
-/*P2_TSSTATEL*/
+/* P2_TSSTATEL */
 #define RSTV0910_P2_TSSTATEL  0xf371
 #define FSTV0910_P2_TSNOSYNCBYTE  0xf3710080
 #define FSTV0910_P2_TSPARITY_ON  0xf3710040
@@ -1724,7 +1725,7 @@
 #define FSTV0910_P2_TSCRC8_ON  0xf3710002
 #define FSTV0910_P2_TSDSS_PACKET  0xf3710001
 
-/*P2_TSCFGH*/
+/* P2_TSCFGH */
 #define RSTV0910_P2_TSCFGH  0xf372
 #define FSTV0910_P2_TSFIFO_DVBCI  0xf3720080
 #define FSTV0910_P2_TSFIFO_SERIAL  0xf3720040
@@ -1734,14 +1735,14 @@
 #define FSTV0910_P2_TSFIFO_ERRMODE  0xf3720006
 #define FSTV0910_P2_RST_HWARE  0xf3720001
 
-/*P2_TSCFGM*/
+/* P2_TSCFGM */
 #define RSTV0910_P2_TSCFGM  0xf373
 #define FSTV0910_P2_TSFIFO_MANSPEED  0xf37300c0
 #define FSTV0910_P2_TSFIFO_PERMDATA  0xf3730020
 #define FSTV0910_P2_TSFIFO_NONEWSGNL  0xf3730010
 #define FSTV0910_P2_TSFIFO_INVDATA  0xf3730001
 
-/*P2_TSCFGL*/
+/* P2_TSCFGL */
 #define RSTV0910_P2_TSCFGL  0xf374
 #define FSTV0910_P2_TSFIFO_BCLKDEL1CK  0xf37400c0
 #define FSTV0910_P2_BCHERROR_MODE  0xf3740030
@@ -1749,11 +1750,11 @@
 #define FSTV0910_P2_TSFIFO_EMBINDVB  0xf3740004
 #define FSTV0910_P2_TSFIFO_BITSPEED  0xf3740003
 
-/*P2_TSSYNC*/
+/* P2_TSSYNC */
 #define RSTV0910_P2_TSSYNC  0xf375
 #define FSTV0910_P2_TSFIFO_SYNCMODE  0xf3750018
 
-/*P2_TSINSDELH*/
+/* P2_TSINSDELH */
 #define RSTV0910_P2_TSINSDELH  0xf376
 #define FSTV0910_P2_TSDEL_SYNCBYTE  0xf3760080
 #define FSTV0910_P2_TSDEL_XXHEADER  0xf3760040
@@ -1761,7 +1762,7 @@
 #define FSTV0910_P2_TSINSDEL_RSPARITY  0xf3760002
 #define FSTV0910_P2_TSINSDEL_CRC8  0xf3760001
 
-/*P2_TSINSDELM*/
+/* P2_TSINSDELM */
 #define RSTV0910_P2_TSINSDELM  0xf377
 #define FSTV0910_P2_TSINS_EMODCOD  0xf3770010
 #define FSTV0910_P2_TSINS_TOKEN  0xf3770008
@@ -1769,7 +1770,7 @@
 #define FSTV0910_P2_TSINS_MATYPE  0xf3770002
 #define FSTV0910_P2_TSINS_UPL  0xf3770001
 
-/*P2_TSINSDELL*/
+/* P2_TSINSDELL */
 #define RSTV0910_P2_TSINSDELL  0xf378
 #define FSTV0910_P2_TSINS_DFL  0xf3780080
 #define FSTV0910_P2_TSINS_SYNCD  0xf3780040
@@ -1780,20 +1781,20 @@
 #define FSTV0910_P2_TSINS_TSCONFIG  0xf3780002
 #define FSTV0910_P2_TSINS_LATENCY  0xf3780001
 
-/*P2_TSDIVN*/
+/* P2_TSDIVN */
 #define RSTV0910_P2_TSDIVN  0xf379
 #define FSTV0910_P2_TSFIFO_SPEEDMODE  0xf37900c0
 #define FSTV0910_P2_TSFIFO_RISEOK  0xf3790007
 
-/*P2_TSCFG4*/
+/* P2_TSCFG4 */
 #define RSTV0910_P2_TSCFG4  0xf37a
 #define FSTV0910_P2_TSFIFO_TSSPEEDMODE  0xf37a00c0
 
-/*P2_TSSPEED*/
+/* P2_TSSPEED */
 #define RSTV0910_P2_TSSPEED  0xf380
 #define FSTV0910_P2_TSFIFO_OUTSPEED  0xf38000ff
 
-/*P2_TSSTATUS*/
+/* P2_TSSTATUS */
 #define RSTV0910_P2_TSSTATUS  0xf381
 #define FSTV0910_P2_TSFIFO_LINEOK  0xf3810080
 #define FSTV0910_P2_TSFIFO_ERROR  0xf3810040
@@ -1801,111 +1802,111 @@
 #define FSTV0910_P2_TSREGUL_ERROR  0xf3810004
 #define FSTV0910_P2_DIL_READY  0xf3810001
 
-/*P2_TSSTATUS2*/
+/* P2_TSSTATUS2 */
 #define RSTV0910_P2_TSSTATUS2  0xf382
 #define FSTV0910_P2_TSFIFO_DEMODSEL  0xf3820080
 #define FSTV0910_P2_TSFIFOSPEED_STORE  0xf3820040
 #define FSTV0910_P2_DILXX_RESET  0xf3820020
 #define FSTV0910_P2_SCRAMBDETECT  0xf3820002
 
-/*P2_TSBITRATE1*/
+/* P2_TSBITRATE1 */
 #define RSTV0910_P2_TSBITRATE1  0xf383
 #define FSTV0910_P2_TSFIFO_BITRATE1  0xf38300ff
 
-/*P2_TSBITRATE0*/
+/* P2_TSBITRATE0 */
 #define RSTV0910_P2_TSBITRATE0  0xf384
 #define FSTV0910_P2_TSFIFO_BITRATE0  0xf38400ff
 
-/*P2_TSPACKLEN1*/
+/* P2_TSPACKLEN1 */
 #define RSTV0910_P2_TSPACKLEN1  0xf385
 #define FSTV0910_P2_TSFIFO_PACKCPT  0xf38500e0
 
-/*P2_TSDLY2*/
+/* P2_TSDLY2 */
 #define RSTV0910_P2_TSDLY2  0xf389
 #define FSTV0910_P2_SOFFIFO_LATENCY2  0xf389000f
 
-/*P2_TSDLY1*/
+/* P2_TSDLY1 */
 #define RSTV0910_P2_TSDLY1  0xf38a
 #define FSTV0910_P2_SOFFIFO_LATENCY1  0xf38a00ff
 
-/*P2_TSDLY0*/
+/* P2_TSDLY0 */
 #define RSTV0910_P2_TSDLY0  0xf38b
 #define FSTV0910_P2_SOFFIFO_LATENCY0  0xf38b00ff
 
-/*P2_TSNPDAV*/
+/* P2_TSNPDAV */
 #define RSTV0910_P2_TSNPDAV  0xf38c
 #define FSTV0910_P2_TSNPD_AVERAGE  0xf38c00ff
 
-/*P2_TSBUFSTAT2*/
+/* P2_TSBUFSTAT2 */
 #define RSTV0910_P2_TSBUFSTAT2  0xf38d
 #define FSTV0910_P2_TSISCR_3BYTES  0xf38d0080
 #define FSTV0910_P2_TSISCR_NEWDATA  0xf38d0040
 #define FSTV0910_P2_TSISCR_BUFSTAT2  0xf38d003f
 
-/*P2_TSBUFSTAT1*/
+/* P2_TSBUFSTAT1 */
 #define RSTV0910_P2_TSBUFSTAT1  0xf38e
 #define FSTV0910_P2_TSISCR_BUFSTAT1  0xf38e00ff
 
-/*P2_TSBUFSTAT0*/
+/* P2_TSBUFSTAT0 */
 #define RSTV0910_P2_TSBUFSTAT0  0xf38f
 #define FSTV0910_P2_TSISCR_BUFSTAT0  0xf38f00ff
 
-/*P2_TSDEBUGL*/
+/* P2_TSDEBUGL */
 #define RSTV0910_P2_TSDEBUGL  0xf391
 #define FSTV0910_P2_TSFIFO_ERROR_EVNT  0xf3910004
 #define FSTV0910_P2_TSFIFO_OVERFLOWM  0xf3910001
 
-/*P2_TSDLYSET2*/
+/* P2_TSDLYSET2 */
 #define RSTV0910_P2_TSDLYSET2  0xf392
 #define FSTV0910_P2_SOFFIFO_OFFSET  0xf39200c0
 #define FSTV0910_P2_HYSTERESIS_THRESHOLD  0xf3920030
 #define FSTV0910_P2_SOFFIFO_SYMBOFFS2  0xf392000f
 
-/*P2_TSDLYSET1*/
+/* P2_TSDLYSET1 */
 #define RSTV0910_P2_TSDLYSET1  0xf393
 #define FSTV0910_P2_SOFFIFO_SYMBOFFS1  0xf39300ff
 
-/*P2_TSDLYSET0*/
+/* P2_TSDLYSET0 */
 #define RSTV0910_P2_TSDLYSET0  0xf394
 #define FSTV0910_P2_SOFFIFO_SYMBOFFS0  0xf39400ff
 
-/*P2_ERRCTRL1*/
+/* P2_ERRCTRL1 */
 #define RSTV0910_P2_ERRCTRL1  0xf398
 #define FSTV0910_P2_ERR_SOURCE1  0xf39800f0
 #define FSTV0910_P2_NUM_EVENT1  0xf3980007
 
-/*P2_ERRCNT12*/
+/* P2_ERRCNT12 */
 #define RSTV0910_P2_ERRCNT12  0xf399
 #define FSTV0910_P2_ERRCNT1_OLDVALUE  0xf3990080
 #define FSTV0910_P2_ERR_CNT12  0xf399007f
 
-/*P2_ERRCNT11*/
+/* P2_ERRCNT11 */
 #define RSTV0910_P2_ERRCNT11  0xf39a
 #define FSTV0910_P2_ERR_CNT11  0xf39a00ff
 
-/*P2_ERRCNT10*/
+/* P2_ERRCNT10 */
 #define RSTV0910_P2_ERRCNT10  0xf39b
 #define FSTV0910_P2_ERR_CNT10  0xf39b00ff
 
-/*P2_ERRCTRL2*/
+/* P2_ERRCTRL2 */
 #define RSTV0910_P2_ERRCTRL2  0xf39c
 #define FSTV0910_P2_ERR_SOURCE2  0xf39c00f0
 #define FSTV0910_P2_NUM_EVENT2  0xf39c0007
 
-/*P2_ERRCNT22*/
+/* P2_ERRCNT22 */
 #define RSTV0910_P2_ERRCNT22  0xf39d
 #define FSTV0910_P2_ERRCNT2_OLDVALUE  0xf39d0080
 #define FSTV0910_P2_ERR_CNT22  0xf39d007f
 
-/*P2_ERRCNT21*/
+/* P2_ERRCNT21 */
 #define RSTV0910_P2_ERRCNT21  0xf39e
 #define FSTV0910_P2_ERR_CNT21  0xf39e00ff
 
-/*P2_ERRCNT20*/
+/* P2_ERRCNT20 */
 #define RSTV0910_P2_ERRCNT20  0xf39f
 #define FSTV0910_P2_ERR_CNT20  0xf39f00ff
 
-/*P2_FECSPY*/
+/* P2_FECSPY */
 #define RSTV0910_P2_FECSPY  0xf3a0
 #define FSTV0910_P2_SPY_ENABLE  0xf3a00080
 #define FSTV0910_P2_NO_SYNCBYTE  0xf3a00040
@@ -1915,7 +1916,7 @@
 #define FSTV0910_P2_BERMETER_LMODE  0xf3a00002
 #define FSTV0910_P2_BERMETER_RESET  0xf3a00001
 
-/*P2_FSPYCFG*/
+/* P2_FSPYCFG */
 #define RSTV0910_P2_FSPYCFG  0xf3a1
 #define FSTV0910_P2_FECSPY_INPUT  0xf3a100c0
 #define FSTV0910_P2_RST_ON_ERROR  0xf3a10020
@@ -1923,18 +1924,18 @@
 #define FSTV0910_P2_I2C_MODE  0xf3a1000c
 #define FSTV0910_P2_SPY_HYSTERESIS  0xf3a10003
 
-/*P2_FSPYDATA*/
+/* P2_FSPYDATA */
 #define RSTV0910_P2_FSPYDATA  0xf3a2
 #define FSTV0910_P2_SPY_STUFFING  0xf3a20080
 #define FSTV0910_P2_SPY_CNULLPKT  0xf3a20020
 #define FSTV0910_P2_SPY_OUTDATA_MODE  0xf3a2001f
 
-/*P2_FSPYOUT*/
+/* P2_FSPYOUT */
 #define RSTV0910_P2_FSPYOUT  0xf3a3
 #define FSTV0910_P2_FSPY_DIRECT  0xf3a30080
 #define FSTV0910_P2_STUFF_MODE  0xf3a30007
 
-/*P2_FSTATUS*/
+/* P2_FSTATUS */
 #define RSTV0910_P2_FSTATUS  0xf3a4
 #define FSTV0910_P2_SPY_ENDSIM  0xf3a40080
 #define FSTV0910_P2_VALID_SIM  0xf3a40040
@@ -1942,49 +1943,49 @@
 #define FSTV0910_P2_DSS_SYNCBYTE  0xf3a40010
 #define FSTV0910_P2_RESULT_STATE  0xf3a4000f
 
-/*P2_FBERCPT4*/
+/* P2_FBERCPT4 */
 #define RSTV0910_P2_FBERCPT4  0xf3a8
 #define FSTV0910_P2_FBERMETER_CPT4  0xf3a800ff
 
-/*P2_FBERCPT3*/
+/* P2_FBERCPT3 */
 #define RSTV0910_P2_FBERCPT3  0xf3a9
 #define FSTV0910_P2_FBERMETER_CPT3  0xf3a900ff
 
-/*P2_FBERCPT2*/
+/* P2_FBERCPT2 */
 #define RSTV0910_P2_FBERCPT2  0xf3aa
 #define FSTV0910_P2_FBERMETER_CPT2  0xf3aa00ff
 
-/*P2_FBERCPT1*/
+/* P2_FBERCPT1 */
 #define RSTV0910_P2_FBERCPT1  0xf3ab
 #define FSTV0910_P2_FBERMETER_CPT1  0xf3ab00ff
 
-/*P2_FBERCPT0*/
+/* P2_FBERCPT0 */
 #define RSTV0910_P2_FBERCPT0  0xf3ac
 #define FSTV0910_P2_FBERMETER_CPT0  0xf3ac00ff
 
-/*P2_FBERERR2*/
+/* P2_FBERERR2 */
 #define RSTV0910_P2_FBERERR2  0xf3ad
 #define FSTV0910_P2_FBERMETER_ERR2  0xf3ad00ff
 
-/*P2_FBERERR1*/
+/* P2_FBERERR1 */
 #define RSTV0910_P2_FBERERR1  0xf3ae
 #define FSTV0910_P2_FBERMETER_ERR1  0xf3ae00ff
 
-/*P2_FBERERR0*/
+/* P2_FBERERR0 */
 #define RSTV0910_P2_FBERERR0  0xf3af
 #define FSTV0910_P2_FBERMETER_ERR0  0xf3af00ff
 
-/*P2_FSPYBER*/
+/* P2_FSPYBER */
 #define RSTV0910_P2_FSPYBER  0xf3b2
 #define FSTV0910_P2_FSPYBER_SYNCBYTE  0xf3b20010
 #define FSTV0910_P2_FSPYBER_UNSYNC  0xf3b20008
 #define FSTV0910_P2_FSPYBER_CTIME  0xf3b20007
 
-/*P2_SFERROR*/
+/* P2_SFERROR */
 #define RSTV0910_P2_SFERROR  0xf3c1
 #define FSTV0910_P2_SFEC_REGERR_VIT  0xf3c100ff
 
-/*P2_SFECSTATUS*/
+/* P2_SFECSTATUS */
 #define RSTV0910_P2_SFECSTATUS  0xf3c3
 #define FSTV0910_P2_SFEC_ON  0xf3c30080
 #define FSTV0910_P2_SFEC_OFF  0xf3c30040
@@ -1993,31 +1994,31 @@
 #define FSTV0910_P2_SFEC_DEMODSEL  0xf3c30002
 #define FSTV0910_P2_SFEC_OVFON  0xf3c30001
 
-/*P2_SFKDIV12*/
+/* P2_SFKDIV12 */
 #define RSTV0910_P2_SFKDIV12  0xf3c4
 #define FSTV0910_P2_SFECKDIV12_MAN  0xf3c40080
 
-/*P2_SFKDIV23*/
+/* P2_SFKDIV23 */
 #define RSTV0910_P2_SFKDIV23  0xf3c5
 #define FSTV0910_P2_SFECKDIV23_MAN  0xf3c50080
 
-/*P2_SFKDIV34*/
+/* P2_SFKDIV34 */
 #define RSTV0910_P2_SFKDIV34  0xf3c6
 #define FSTV0910_P2_SFECKDIV34_MAN  0xf3c60080
 
-/*P2_SFKDIV56*/
+/* P2_SFKDIV56 */
 #define RSTV0910_P2_SFKDIV56  0xf3c7
 #define FSTV0910_P2_SFECKDIV56_MAN  0xf3c70080
 
-/*P2_SFKDIV67*/
+/* P2_SFKDIV67 */
 #define RSTV0910_P2_SFKDIV67  0xf3c8
 #define FSTV0910_P2_SFECKDIV67_MAN  0xf3c80080
 
-/*P2_SFKDIV78*/
+/* P2_SFKDIV78 */
 #define RSTV0910_P2_SFKDIV78  0xf3c9
 #define FSTV0910_P2_SFECKDIV78_MAN  0xf3c90080
 
-/*P2_SFSTATUS*/
+/* P2_SFSTATUS */
 #define RSTV0910_P2_SFSTATUS  0xf3cc
 #define FSTV0910_P2_SFEC_LINEOK  0xf3cc0080
 #define FSTV0910_P2_SFEC_ERROR  0xf3cc0040
@@ -2028,48 +2029,48 @@
 #define FSTV0910_P2_SFEC_UNREGULA  0xf3cc0002
 #define FSTV0910_P2_SFEC_READY  0xf3cc0001
 
-/*P2_SFDLYSET2*/
+/* P2_SFDLYSET2 */
 #define RSTV0910_P2_SFDLYSET2  0xf3d0
 #define FSTV0910_P2_SFEC_DISABLE  0xf3d00002
 
-/*P2_SFERRCTRL*/
+/* P2_SFERRCTRL */
 #define RSTV0910_P2_SFERRCTRL  0xf3d8
 #define FSTV0910_P2_SFEC_ERR_SOURCE  0xf3d800f0
 #define FSTV0910_P2_SFEC_NUM_EVENT  0xf3d80007
 
-/*P2_SFERRCNT2*/
+/* P2_SFERRCNT2 */
 #define RSTV0910_P2_SFERRCNT2  0xf3d9
 #define FSTV0910_P2_SFERRC_OLDVALUE  0xf3d90080
 #define FSTV0910_P2_SFEC_ERR_CNT2  0xf3d9007f
 
-/*P2_SFERRCNT1*/
+/* P2_SFERRCNT1 */
 #define RSTV0910_P2_SFERRCNT1  0xf3da
 #define FSTV0910_P2_SFEC_ERR_CNT1  0xf3da00ff
 
-/*P2_SFERRCNT0*/
+/* P2_SFERRCNT0 */
 #define RSTV0910_P2_SFERRCNT0  0xf3db
 #define FSTV0910_P2_SFEC_ERR_CNT0  0xf3db00ff
 
-/*P1_IQCONST*/
+/* P1_IQCONST */
 #define RSTV0910_P1_IQCONST  0xf400
 #define FSTV0910_P1_CONSTEL_SELECT  0xf4000060
 #define FSTV0910_P1_IQSYMB_SEL  0xf400001f
 
-/*P1_NOSCFG*/
+/* P1_NOSCFG */
 #define RSTV0910_P1_NOSCFG  0xf401
 #define FSTV0910_P1_DUMMYPL_NOSDATA  0xf4010020
 #define FSTV0910_P1_NOSPLH_BETA  0xf4010018
 #define FSTV0910_P1_NOSDATA_BETA  0xf4010007
 
-/*P1_ISYMB*/
+/* P1_ISYMB */
 #define RSTV0910_P1_ISYMB  0xf402
 #define FSTV0910_P1_I_SYMBOL  0xf40201ff
 
-/*P1_QSYMB*/
+/* P1_QSYMB */
 #define RSTV0910_P1_QSYMB  0xf403
 #define FSTV0910_P1_Q_SYMBOL  0xf40301ff
 
-/*P1_AGC1CFG*/
+/* P1_AGC1CFG */
 #define RSTV0910_P1_AGC1CFG  0xf404
 #define FSTV0910_P1_DC_FROZEN  0xf4040080
 #define FSTV0910_P1_DC_CORRECT  0xf4040040
@@ -2078,70 +2079,70 @@
 #define FSTV0910_P1_QUAD_FROZEN  0xf4040008
 #define FSTV0910_P1_QUAD_CORRECT  0xf4040004
 
-/*P1_AGC1CN*/
+/* P1_AGC1CN */
 #define RSTV0910_P1_AGC1CN  0xf406
 #define FSTV0910_P1_AGC1_LOCKED  0xf4060080
 #define FSTV0910_P1_AGC1_MINPOWER  0xf4060010
 #define FSTV0910_P1_AGCOUT_FAST  0xf4060008
 #define FSTV0910_P1_AGCIQ_BETA  0xf4060007
 
-/*P1_AGC1REF*/
+/* P1_AGC1REF */
 #define RSTV0910_P1_AGC1REF  0xf407
 #define FSTV0910_P1_AGCIQ_REF  0xf40700ff
 
-/*P1_IDCCOMP*/
+/* P1_IDCCOMP */
 #define RSTV0910_P1_IDCCOMP  0xf408
 #define FSTV0910_P1_IAVERAGE_ADJ  0xf40801ff
 
-/*P1_QDCCOMP*/
+/* P1_QDCCOMP */
 #define RSTV0910_P1_QDCCOMP  0xf409
 #define FSTV0910_P1_QAVERAGE_ADJ  0xf40901ff
 
-/*P1_POWERI*/
+/* P1_POWERI */
 #define RSTV0910_P1_POWERI  0xf40a
 #define FSTV0910_P1_POWER_I  0xf40a00ff
 
-/*P1_POWERQ*/
+/* P1_POWERQ */
 #define RSTV0910_P1_POWERQ  0xf40b
 #define FSTV0910_P1_POWER_Q  0xf40b00ff
 
-/*P1_AGC1AMM*/
+/* P1_AGC1AMM */
 #define RSTV0910_P1_AGC1AMM  0xf40c
 #define FSTV0910_P1_AMM_VALUE  0xf40c00ff
 
-/*P1_AGC1QUAD*/
+/* P1_AGC1QUAD */
 #define RSTV0910_P1_AGC1QUAD  0xf40d
 #define FSTV0910_P1_QUAD_VALUE  0xf40d01ff
 
-/*P1_AGCIQIN1*/
+/* P1_AGCIQIN1 */
 #define RSTV0910_P1_AGCIQIN1  0xf40e
 #define FSTV0910_P1_AGCIQ_VALUE1  0xf40e00ff
 
-/*P1_AGCIQIN0*/
+/* P1_AGCIQIN0 */
 #define RSTV0910_P1_AGCIQIN0  0xf40f
 #define FSTV0910_P1_AGCIQ_VALUE0  0xf40f00ff
 
-/*P1_DEMOD*/
+/* P1_DEMOD */
 #define RSTV0910_P1_DEMOD  0xf410
 #define FSTV0910_P1_MANUALS2_ROLLOFF  0xf4100080
 #define FSTV0910_P1_SPECINV_CONTROL  0xf4100030
 #define FSTV0910_P1_MANUALSX_ROLLOFF  0xf4100004
 #define FSTV0910_P1_ROLLOFF_CONTROL  0xf4100003
 
-/*P1_DMDMODCOD*/
+/* P1_DMDMODCOD */
 #define RSTV0910_P1_DMDMODCOD  0xf411
 #define FSTV0910_P1_MANUAL_MODCOD  0xf4110080
 #define FSTV0910_P1_DEMOD_MODCOD  0xf411007c
 #define FSTV0910_P1_DEMOD_TYPE  0xf4110003
 
-/*P1_DSTATUS*/
+/* P1_DSTATUS */
 #define RSTV0910_P1_DSTATUS  0xf412
 #define FSTV0910_P1_CAR_LOCK  0xf4120080
 #define FSTV0910_P1_TMGLOCK_QUALITY  0xf4120060
 #define FSTV0910_P1_LOCK_DEFINITIF  0xf4120008
 #define FSTV0910_P1_OVADC_DETECT  0xf4120001
 
-/*P1_DSTATUS2*/
+/* P1_DSTATUS2 */
 #define RSTV0910_P1_DSTATUS2  0xf413
 #define FSTV0910_P1_DEMOD_DELOCK  0xf4130080
 #define FSTV0910_P1_MODCODRQ_SYNCTAG  0xf4130020
@@ -2151,7 +2152,7 @@
 #define FSTV0910_P1_CFR_OVERFLOW  0xf4130002
 #define FSTV0910_P1_GAMMA_OVERUNDER  0xf4130001
 
-/*P1_DMDCFGMD*/
+/* P1_DMDCFGMD */
 #define RSTV0910_P1_DMDCFGMD  0xf414
 #define FSTV0910_P1_DVBS2_ENABLE  0xf4140080
 #define FSTV0910_P1_DVBS1_ENABLE  0xf4140040
@@ -2159,503 +2160,503 @@
 #define FSTV0910_P1_CFR_AUTOSCAN  0xf4140008
 #define FSTV0910_P1_TUN_RNG  0xf4140003
 
-/*P1_DMDCFG2*/
+/* P1_DMDCFG2 */
 #define RSTV0910_P1_DMDCFG2  0xf415
 #define FSTV0910_P1_S1S2_SEQUENTIAL  0xf4150040
 #define FSTV0910_P1_INFINITE_RELOCK  0xf4150010
 
-/*P1_DMDISTATE*/
+/* P1_DMDISTATE */
 #define RSTV0910_P1_DMDISTATE  0xf416
 #define FSTV0910_P1_I2C_NORESETDMODE  0xf4160080
 #define FSTV0910_P1_I2C_DEMOD_MODE  0xf416001f
 
-/*P1_DMDT0M*/
+/* P1_DMDT0M */
 #define RSTV0910_P1_DMDT0M  0xf417
 #define FSTV0910_P1_DMDT0_MIN  0xf41700ff
 
-/*P1_DMDSTATE*/
+/* P1_DMDSTATE */
 #define RSTV0910_P1_DMDSTATE  0xf41b
 #define FSTV0910_P1_HEADER_MODE  0xf41b0060
 
-/*P1_DMDFLYW*/
+/* P1_DMDFLYW */
 #define RSTV0910_P1_DMDFLYW  0xf41c
 #define FSTV0910_P1_I2C_IRQVAL  0xf41c00f0
 #define FSTV0910_P1_FLYWHEEL_CPT  0xf41c000f
 
-/*P1_DSTATUS3*/
+/* P1_DSTATUS3 */
 #define RSTV0910_P1_DSTATUS3  0xf41d
 #define FSTV0910_P1_CFR_ZIGZAG  0xf41d0080
 #define FSTV0910_P1_DEMOD_CFGMODE  0xf41d0060
 #define FSTV0910_P1_GAMMA_LOWBAUDRATE  0xf41d0010
 
-/*P1_DMDCFG3*/
+/* P1_DMDCFG3 */
 #define RSTV0910_P1_DMDCFG3  0xf41e
 #define FSTV0910_P1_NOSTOP_FIFOFULL  0xf41e0008
 
-/*P1_DMDCFG4*/
+/* P1_DMDCFG4 */
 #define RSTV0910_P1_DMDCFG4  0xf41f
 #define FSTV0910_P1_DIS_VITLOCK  0xf41f0080
 #define FSTV0910_P1_DIS_CLKENABLE  0xf41f0004
 
-/*P1_CORRELMANT*/
+/* P1_CORRELMANT */
 #define RSTV0910_P1_CORRELMANT  0xf420
 #define FSTV0910_P1_CORREL_MANT  0xf42000ff
 
-/*P1_CORRELABS*/
+/* P1_CORRELABS */
 #define RSTV0910_P1_CORRELABS  0xf421
 #define FSTV0910_P1_CORREL_ABS  0xf42100ff
 
-/*P1_CORRELEXP*/
+/* P1_CORRELEXP */
 #define RSTV0910_P1_CORRELEXP  0xf422
 #define FSTV0910_P1_CORREL_ABSEXP  0xf42200f0
 #define FSTV0910_P1_CORREL_EXP  0xf422000f
 
-/*P1_PLHMODCOD*/
+/* P1_PLHMODCOD */
 #define RSTV0910_P1_PLHMODCOD  0xf424
 #define FSTV0910_P1_SPECINV_DEMOD  0xf4240080
 #define FSTV0910_P1_PLH_MODCOD  0xf424007c
 #define FSTV0910_P1_PLH_TYPE  0xf4240003
 
-/*P1_DMDREG*/
+/* P1_DMDREG */
 #define RSTV0910_P1_DMDREG  0xf425
 #define FSTV0910_P1_DECIM_PLFRAMES  0xf4250001
 
-/*P1_AGCNADJ*/
+/* P1_AGCNADJ */
 #define RSTV0910_P1_AGCNADJ  0xf426
 #define FSTV0910_P1_RADJOFF_AGC2  0xf4260080
 #define FSTV0910_P1_RADJOFF_AGC1  0xf4260040
 #define FSTV0910_P1_AGC_NADJ  0xf426013f
 
-/*P1_AGCKS*/
+/* P1_AGCKS */
 #define RSTV0910_P1_AGCKS  0xf427
 #define FSTV0910_P1_RSADJ_MANUALCFG  0xf4270080
 #define FSTV0910_P1_RSADJ_CCMMODE  0xf4270040
 #define FSTV0910_P1_RADJ_SPSK  0xf427013f
 
-/*P1_AGCKQ*/
+/* P1_AGCKQ */
 #define RSTV0910_P1_AGCKQ  0xf428
 #define FSTV0910_P1_RADJON_DVBS1  0xf4280040
 #define FSTV0910_P1_RADJ_QPSK  0xf428013f
 
-/*P1_AGCK8*/
+/* P1_AGCK8 */
 #define RSTV0910_P1_AGCK8  0xf429
 #define FSTV0910_P1_RADJ_8PSK  0xf429013f
 
-/*P1_AGCK16*/
+/* P1_AGCK16 */
 #define RSTV0910_P1_AGCK16  0xf42a
 #define FSTV0910_P1_R2ADJOFF_16APSK  0xf42a0040
 #define FSTV0910_P1_R1ADJOFF_16APSK  0xf42a0020
 #define FSTV0910_P1_RADJ_16APSK  0xf42a011f
 
-/*P1_AGCK32*/
+/* P1_AGCK32 */
 #define RSTV0910_P1_AGCK32  0xf42b
 #define FSTV0910_P1_R3ADJOFF_32APSK  0xf42b0080
 #define FSTV0910_P1_R2ADJOFF_32APSK  0xf42b0040
 #define FSTV0910_P1_R1ADJOFF_32APSK  0xf42b0020
 #define FSTV0910_P1_RADJ_32APSK  0xf42b011f
 
-/*P1_AGC2O*/
+/* P1_AGC2O */
 #define RSTV0910_P1_AGC2O  0xf42c
 #define FSTV0910_P1_CSTENV_MODE  0xf42c00c0
 #define FSTV0910_P1_AGC2_COEF  0xf42c0007
 
-/*P1_AGC2REF*/
+/* P1_AGC2REF */
 #define RSTV0910_P1_AGC2REF  0xf42d
 #define FSTV0910_P1_AGC2_REF  0xf42d00ff
 
-/*P1_AGC1ADJ*/
+/* P1_AGC1ADJ */
 #define RSTV0910_P1_AGC1ADJ  0xf42e
 #define FSTV0910_P1_AGC1_ADJUSTED  0xf42e007f
 
-/*P1_AGCRSADJ*/
+/* P1_AGCRSADJ */
 #define RSTV0910_P1_AGCRSADJ  0xf42f
 #define FSTV0910_P1_RS_ADJUSTED  0xf42f007f
 
-/*P1_AGCRQADJ*/
+/* P1_AGCRQADJ */
 #define RSTV0910_P1_AGCRQADJ  0xf430
 #define FSTV0910_P1_RQ_ADJUSTED  0xf430007f
 
-/*P1_AGCR8ADJ*/
+/* P1_AGCR8ADJ */
 #define RSTV0910_P1_AGCR8ADJ  0xf431
 #define FSTV0910_P1_R8_ADJUSTED  0xf431007f
 
-/*P1_AGCR1ADJ*/
+/* P1_AGCR1ADJ */
 #define RSTV0910_P1_AGCR1ADJ  0xf432
 #define FSTV0910_P1_R1_ADJUSTED  0xf432007f
 
-/*P1_AGCR2ADJ*/
+/* P1_AGCR2ADJ */
 #define RSTV0910_P1_AGCR2ADJ  0xf433
 #define FSTV0910_P1_R2_ADJUSTED  0xf433007f
 
-/*P1_AGCR3ADJ*/
+/* P1_AGCR3ADJ */
 #define RSTV0910_P1_AGCR3ADJ  0xf434
 #define FSTV0910_P1_R3_ADJUSTED  0xf434007f
 
-/*P1_AGCREFADJ*/
+/* P1_AGCREFADJ */
 #define RSTV0910_P1_AGCREFADJ  0xf435
 #define FSTV0910_P1_AGC2REF_ADJUSTED  0xf435007f
 
-/*P1_AGC2I1*/
+/* P1_AGC2I1 */
 #define RSTV0910_P1_AGC2I1  0xf436
 #define FSTV0910_P1_AGC2_INTEGRATOR1  0xf43600ff
 
-/*P1_AGC2I0*/
+/* P1_AGC2I0 */
 #define RSTV0910_P1_AGC2I0  0xf437
 #define FSTV0910_P1_AGC2_INTEGRATOR0  0xf43700ff
 
-/*P1_CARCFG*/
+/* P1_CARCFG */
 #define RSTV0910_P1_CARCFG  0xf438
 #define FSTV0910_P1_ROTAON  0xf4380004
 #define FSTV0910_P1_PH_DET_ALGO  0xf4380003
 
-/*P1_ACLC*/
+/* P1_ACLC */
 #define RSTV0910_P1_ACLC  0xf439
 #define FSTV0910_P1_CAR_ALPHA_MANT  0xf4390030
 #define FSTV0910_P1_CAR_ALPHA_EXP  0xf439000f
 
-/*P1_BCLC*/
+/* P1_BCLC */
 #define RSTV0910_P1_BCLC  0xf43a
 #define FSTV0910_P1_CAR_BETA_MANT  0xf43a0030
 #define FSTV0910_P1_CAR_BETA_EXP  0xf43a000f
 
-/*P1_ACLCS2*/
+/* P1_ACLCS2 */
 #define RSTV0910_P1_ACLCS2  0xf43b
 #define FSTV0910_P1_CARS2_APLHA_MANTISSE  0xf43b0030
 #define FSTV0910_P1_CARS2_ALPHA_EXP  0xf43b000f
 
-/*P1_BCLCS2*/
+/* P1_BCLCS2 */
 #define RSTV0910_P1_BCLCS2  0xf43c
 #define FSTV0910_P1_CARS2_BETA_MANTISSE  0xf43c0030
 #define FSTV0910_P1_CARS2_BETA_EXP  0xf43c000f
 
-/*P1_CARFREQ*/
+/* P1_CARFREQ */
 #define RSTV0910_P1_CARFREQ  0xf43d
 #define FSTV0910_P1_KC_COARSE_EXP  0xf43d00f0
 #define FSTV0910_P1_BETA_FREQ  0xf43d000f
 
-/*P1_CARHDR*/
+/* P1_CARHDR */
 #define RSTV0910_P1_CARHDR  0xf43e
 #define FSTV0910_P1_K_FREQ_HDR  0xf43e00ff
 
-/*P1_LDT*/
+/* P1_LDT */
 #define RSTV0910_P1_LDT  0xf43f
 #define FSTV0910_P1_CARLOCK_THRES  0xf43f01ff
 
-/*P1_LDT2*/
+/* P1_LDT2 */
 #define RSTV0910_P1_LDT2  0xf440
 #define FSTV0910_P1_CARLOCK_THRES2  0xf44001ff
 
-/*P1_CFRICFG*/
+/* P1_CFRICFG */
 #define RSTV0910_P1_CFRICFG  0xf441
 #define FSTV0910_P1_NEG_CFRSTEP  0xf4410001
 
-/*P1_CFRUP1*/
+/* P1_CFRUP1 */
 #define RSTV0910_P1_CFRUP1  0xf442
 #define FSTV0910_P1_CFR_UP1  0xf44201ff
 
-/*P1_CFRUP0*/
+/* P1_CFRUP0 */
 #define RSTV0910_P1_CFRUP0  0xf443
 #define FSTV0910_P1_CFR_UP0  0xf44300ff
 
-/*P1_CFRIBASE1*/
+/* P1_CFRIBASE1 */
 #define RSTV0910_P1_CFRIBASE1  0xf444
 #define FSTV0910_P1_CFRINIT_BASE1  0xf44400ff
 
-/*P1_CFRIBASE0*/
+/* P1_CFRIBASE0 */
 #define RSTV0910_P1_CFRIBASE0  0xf445
 #define FSTV0910_P1_CFRINIT_BASE0  0xf44500ff
 
-/*P1_CFRLOW1*/
+/* P1_CFRLOW1 */
 #define RSTV0910_P1_CFRLOW1  0xf446
 #define FSTV0910_P1_CFR_LOW1  0xf44601ff
 
-/*P1_CFRLOW0*/
+/* P1_CFRLOW0 */
 #define RSTV0910_P1_CFRLOW0  0xf447
 #define FSTV0910_P1_CFR_LOW0  0xf44700ff
 
-/*P1_CFRINIT1*/
+/* P1_CFRINIT1 */
 #define RSTV0910_P1_CFRINIT1  0xf448
 #define FSTV0910_P1_CFR_INIT1  0xf44801ff
 
-/*P1_CFRINIT0*/
+/* P1_CFRINIT0 */
 #define RSTV0910_P1_CFRINIT0  0xf449
 #define FSTV0910_P1_CFR_INIT0  0xf44900ff
 
-/*P1_CFRINC1*/
+/* P1_CFRINC1 */
 #define RSTV0910_P1_CFRINC1  0xf44a
 #define FSTV0910_P1_MANUAL_CFRINC  0xf44a0080
 #define FSTV0910_P1_CFR_INC1  0xf44a003f
 
-/*P1_CFRINC0*/
+/* P1_CFRINC0 */
 #define RSTV0910_P1_CFRINC0  0xf44b
 #define FSTV0910_P1_CFR_INC0  0xf44b00ff
 
-/*P1_CFR2*/
+/* P1_CFR2 */
 #define RSTV0910_P1_CFR2  0xf44c
 #define FSTV0910_P1_CAR_FREQ2  0xf44c01ff
 
-/*P1_CFR1*/
+/* P1_CFR1 */
 #define RSTV0910_P1_CFR1  0xf44d
 #define FSTV0910_P1_CAR_FREQ1  0xf44d00ff
 
-/*P1_CFR0*/
+/* P1_CFR0 */
 #define RSTV0910_P1_CFR0  0xf44e
 #define FSTV0910_P1_CAR_FREQ0  0xf44e00ff
 
-/*P1_LDI*/
+/* P1_LDI */
 #define RSTV0910_P1_LDI  0xf44f
 #define FSTV0910_P1_LOCK_DET_INTEGR  0xf44f01ff
 
-/*P1_TMGCFG*/
+/* P1_TMGCFG */
 #define RSTV0910_P1_TMGCFG  0xf450
 #define FSTV0910_P1_TMGLOCK_BETA  0xf45000c0
 #define FSTV0910_P1_DO_TIMING_CORR  0xf4500010
 #define FSTV0910_P1_TMG_MINFREQ  0xf4500003
 
-/*P1_RTC*/
+/* P1_RTC */
 #define RSTV0910_P1_RTC  0xf451
 #define FSTV0910_P1_TMGALPHA_EXP  0xf45100f0
 #define FSTV0910_P1_TMGBETA_EXP  0xf451000f
 
-/*P1_RTCS2*/
+/* P1_RTCS2 */
 #define RSTV0910_P1_RTCS2  0xf452
 #define FSTV0910_P1_TMGALPHAS2_EXP  0xf45200f0
 #define FSTV0910_P1_TMGBETAS2_EXP  0xf452000f
 
-/*P1_TMGTHRISE*/
+/* P1_TMGTHRISE */
 #define RSTV0910_P1_TMGTHRISE  0xf453
 #define FSTV0910_P1_TMGLOCK_THRISE  0xf45300ff
 
-/*P1_TMGTHFALL*/
+/* P1_TMGTHFALL */
 #define RSTV0910_P1_TMGTHFALL  0xf454
 #define FSTV0910_P1_TMGLOCK_THFALL  0xf45400ff
 
-/*P1_SFRUPRATIO*/
+/* P1_SFRUPRATIO */
 #define RSTV0910_P1_SFRUPRATIO  0xf455
 #define FSTV0910_P1_SFR_UPRATIO  0xf45500ff
 
-/*P1_SFRLOWRATIO*/
+/* P1_SFRLOWRATIO */
 #define RSTV0910_P1_SFRLOWRATIO  0xf456
 #define FSTV0910_P1_SFR_LOWRATIO  0xf45600ff
 
-/*P1_KTTMG*/
+/* P1_KTTMG */
 #define RSTV0910_P1_KTTMG  0xf457
 #define FSTV0910_P1_KT_TMG_EXP  0xf45700f0
 
-/*P1_KREFTMG*/
+/* P1_KREFTMG */
 #define RSTV0910_P1_KREFTMG  0xf458
 #define FSTV0910_P1_KREF_TMG  0xf45800ff
 
-/*P1_SFRSTEP*/
+/* P1_SFRSTEP */
 #define RSTV0910_P1_SFRSTEP  0xf459
 #define FSTV0910_P1_SFR_SCANSTEP  0xf45900f0
 #define FSTV0910_P1_SFR_CENTERSTEP  0xf459000f
 
-/*P1_TMGCFG2*/
+/* P1_TMGCFG2 */
 #define RSTV0910_P1_TMGCFG2  0xf45a
 #define FSTV0910_P1_DIS_AUTOSAMP  0xf45a0008
 #define FSTV0910_P1_SFRRATIO_FINE  0xf45a0001
 
-/*P1_KREFTMG2*/
+/* P1_KREFTMG2 */
 #define RSTV0910_P1_KREFTMG2  0xf45b
 #define FSTV0910_P1_KREF_TMG2  0xf45b00ff
 
-/*P1_TMGCFG3*/
+/* P1_TMGCFG3 */
 #define RSTV0910_P1_TMGCFG3  0xf45d
 #define FSTV0910_P1_CONT_TMGCENTER  0xf45d0008
 #define FSTV0910_P1_AUTO_GUP  0xf45d0004
 #define FSTV0910_P1_AUTO_GLOW  0xf45d0002
 
-/*P1_SFRINIT1*/
+/* P1_SFRINIT1 */
 #define RSTV0910_P1_SFRINIT1  0xf45e
 #define FSTV0910_P1_SFR_INIT1  0xf45e00ff
 
-/*P1_SFRINIT0*/
+/* P1_SFRINIT0 */
 #define RSTV0910_P1_SFRINIT0  0xf45f
 #define FSTV0910_P1_SFR_INIT0  0xf45f00ff
 
-/*P1_SFRUP1*/
+/* P1_SFRUP1 */
 #define RSTV0910_P1_SFRUP1  0xf460
 #define FSTV0910_P1_SYMB_FREQ_UP1  0xf46000ff
 
-/*P1_SFRUP0*/
+/* P1_SFRUP0 */
 #define RSTV0910_P1_SFRUP0  0xf461
 #define FSTV0910_P1_SYMB_FREQ_UP0  0xf46100ff
 
-/*P1_SFRLOW1*/
+/* P1_SFRLOW1 */
 #define RSTV0910_P1_SFRLOW1  0xf462
 #define FSTV0910_P1_SYMB_FREQ_LOW1  0xf46200ff
 
-/*P1_SFRLOW0*/
+/* P1_SFRLOW0 */
 #define RSTV0910_P1_SFRLOW0  0xf463
 #define FSTV0910_P1_SYMB_FREQ_LOW0  0xf46300ff
 
-/*P1_SFR3*/
+/* P1_SFR3 */
 #define RSTV0910_P1_SFR3  0xf464
 #define FSTV0910_P1_SYMB_FREQ3  0xf46400ff
 
-/*P1_SFR2*/
+/* P1_SFR2 */
 #define RSTV0910_P1_SFR2  0xf465
 #define FSTV0910_P1_SYMB_FREQ2  0xf46500ff
 
-/*P1_SFR1*/
+/* P1_SFR1 */
 #define RSTV0910_P1_SFR1  0xf466
 #define FSTV0910_P1_SYMB_FREQ1  0xf46600ff
 
-/*P1_SFR0*/
+/* P1_SFR0 */
 #define RSTV0910_P1_SFR0  0xf467
 #define FSTV0910_P1_SYMB_FREQ0  0xf46700ff
 
-/*P1_TMGREG2*/
+/* P1_TMGREG2 */
 #define RSTV0910_P1_TMGREG2  0xf468
 #define FSTV0910_P1_TMGREG2  0xf46800ff
 
-/*P1_TMGREG1*/
+/* P1_TMGREG1 */
 #define RSTV0910_P1_TMGREG1  0xf469
 #define FSTV0910_P1_TMGREG1  0xf46900ff
 
-/*P1_TMGREG0*/
+/* P1_TMGREG0 */
 #define RSTV0910_P1_TMGREG0  0xf46a
 #define FSTV0910_P1_TMGREG0  0xf46a00ff
 
-/*P1_TMGLOCK1*/
+/* P1_TMGLOCK1 */
 #define RSTV0910_P1_TMGLOCK1  0xf46b
 #define FSTV0910_P1_TMGLOCK_LEVEL1  0xf46b01ff
 
-/*P1_TMGLOCK0*/
+/* P1_TMGLOCK0 */
 #define RSTV0910_P1_TMGLOCK0  0xf46c
 #define FSTV0910_P1_TMGLOCK_LEVEL0  0xf46c00ff
 
-/*P1_TMGOBS*/
+/* P1_TMGOBS */
 #define RSTV0910_P1_TMGOBS  0xf46d
 #define FSTV0910_P1_ROLLOFF_STATUS  0xf46d00c0
 
-/*P1_EQUALCFG*/
+/* P1_EQUALCFG */
 #define RSTV0910_P1_EQUALCFG  0xf46f
 #define FSTV0910_P1_EQUAL_ON  0xf46f0040
 #define FSTV0910_P1_MU_EQUALDFE  0xf46f0007
 
-/*P1_EQUAI1*/
+/* P1_EQUAI1 */
 #define RSTV0910_P1_EQUAI1  0xf470
 #define FSTV0910_P1_EQUA_ACCI1  0xf47001ff
 
-/*P1_EQUAQ1*/
+/* P1_EQUAQ1 */
 #define RSTV0910_P1_EQUAQ1  0xf471
 #define FSTV0910_P1_EQUA_ACCQ1  0xf47101ff
 
-/*P1_EQUAI2*/
+/* P1_EQUAI2 */
 #define RSTV0910_P1_EQUAI2  0xf472
 #define FSTV0910_P1_EQUA_ACCI2  0xf47201ff
 
-/*P1_EQUAQ2*/
+/* P1_EQUAQ2 */
 #define RSTV0910_P1_EQUAQ2  0xf473
 #define FSTV0910_P1_EQUA_ACCQ2  0xf47301ff
 
-/*P1_EQUAI3*/
+/* P1_EQUAI3 */
 #define RSTV0910_P1_EQUAI3  0xf474
 #define FSTV0910_P1_EQUA_ACCI3  0xf47401ff
 
-/*P1_EQUAQ3*/
+/* P1_EQUAQ3 */
 #define RSTV0910_P1_EQUAQ3  0xf475
 #define FSTV0910_P1_EQUA_ACCQ3  0xf47501ff
 
-/*P1_EQUAI4*/
+/* P1_EQUAI4 */
 #define RSTV0910_P1_EQUAI4  0xf476
 #define FSTV0910_P1_EQUA_ACCI4  0xf47601ff
 
-/*P1_EQUAQ4*/
+/* P1_EQUAQ4 */
 #define RSTV0910_P1_EQUAQ4  0xf477
 #define FSTV0910_P1_EQUA_ACCQ4  0xf47701ff
 
-/*P1_EQUAI5*/
+/* P1_EQUAI5 */
 #define RSTV0910_P1_EQUAI5  0xf478
 #define FSTV0910_P1_EQUA_ACCI5  0xf47801ff
 
-/*P1_EQUAQ5*/
+/* P1_EQUAQ5 */
 #define RSTV0910_P1_EQUAQ5  0xf479
 #define FSTV0910_P1_EQUA_ACCQ5  0xf47901ff
 
-/*P1_EQUAI6*/
+/* P1_EQUAI6 */
 #define RSTV0910_P1_EQUAI6  0xf47a
 #define FSTV0910_P1_EQUA_ACCI6  0xf47a01ff
 
-/*P1_EQUAQ6*/
+/* P1_EQUAQ6 */
 #define RSTV0910_P1_EQUAQ6  0xf47b
 #define FSTV0910_P1_EQUA_ACCQ6  0xf47b01ff
 
-/*P1_EQUAI7*/
+/* P1_EQUAI7 */
 #define RSTV0910_P1_EQUAI7  0xf47c
 #define FSTV0910_P1_EQUA_ACCI7  0xf47c01ff
 
-/*P1_EQUAQ7*/
+/* P1_EQUAQ7 */
 #define RSTV0910_P1_EQUAQ7  0xf47d
 #define FSTV0910_P1_EQUA_ACCQ7  0xf47d01ff
 
-/*P1_EQUAI8*/
+/* P1_EQUAI8 */
 #define RSTV0910_P1_EQUAI8  0xf47e
 #define FSTV0910_P1_EQUA_ACCI8  0xf47e01ff
 
-/*P1_EQUAQ8*/
+/* P1_EQUAQ8 */
 #define RSTV0910_P1_EQUAQ8  0xf47f
 #define FSTV0910_P1_EQUA_ACCQ8  0xf47f01ff
 
-/*P1_NNOSDATAT1*/
+/* P1_NNOSDATAT1 */
 #define RSTV0910_P1_NNOSDATAT1  0xf480
 #define FSTV0910_P1_NOSDATAT_NORMED1  0xf48000ff
 
-/*P1_NNOSDATAT0*/
+/* P1_NNOSDATAT0 */
 #define RSTV0910_P1_NNOSDATAT0  0xf481
 #define FSTV0910_P1_NOSDATAT_NORMED0  0xf48100ff
 
-/*P1_NNOSDATA1*/
+/* P1_NNOSDATA1 */
 #define RSTV0910_P1_NNOSDATA1  0xf482
 #define FSTV0910_P1_NOSDATA_NORMED1  0xf48200ff
 
-/*P1_NNOSDATA0*/
+/* P1_NNOSDATA0 */
 #define RSTV0910_P1_NNOSDATA0  0xf483
 #define FSTV0910_P1_NOSDATA_NORMED0  0xf48300ff
 
-/*P1_NNOSPLHT1*/
+/* P1_NNOSPLHT1 */
 #define RSTV0910_P1_NNOSPLHT1  0xf484
 #define FSTV0910_P1_NOSPLHT_NORMED1  0xf48400ff
 
-/*P1_NNOSPLHT0*/
+/* P1_NNOSPLHT0 */
 #define RSTV0910_P1_NNOSPLHT0  0xf485
 #define FSTV0910_P1_NOSPLHT_NORMED0  0xf48500ff
 
-/*P1_NNOSPLH1*/
+/* P1_NNOSPLH1 */
 #define RSTV0910_P1_NNOSPLH1  0xf486
 #define FSTV0910_P1_NOSPLH_NORMED1  0xf48600ff
 
-/*P1_NNOSPLH0*/
+/* P1_NNOSPLH0 */
 #define RSTV0910_P1_NNOSPLH0  0xf487
 #define FSTV0910_P1_NOSPLH_NORMED0  0xf48700ff
 
-/*P1_NOSDATAT1*/
+/* P1_NOSDATAT1 */
 #define RSTV0910_P1_NOSDATAT1  0xf488
 #define FSTV0910_P1_NOSDATAT_UNNORMED1  0xf48800ff
 
-/*P1_NOSDATAT0*/
+/* P1_NOSDATAT0 */
 #define RSTV0910_P1_NOSDATAT0  0xf489
 #define FSTV0910_P1_NOSDATAT_UNNORMED0  0xf48900ff
 
-/*P1_NNOSFRAME1*/
+/* P1_NNOSFRAME1 */
 #define RSTV0910_P1_NNOSFRAME1  0xf48a
 #define FSTV0910_P1_NOSFRAME_NORMED1  0xf48a00ff
 
-/*P1_NNOSFRAME0*/
+/* P1_NNOSFRAME0 */
 #define RSTV0910_P1_NNOSFRAME0  0xf48b
 #define FSTV0910_P1_NOSFRAME_NORMED0  0xf48b00ff
 
-/*P1_NNOSRAD1*/
+/* P1_NNOSRAD1 */
 #define RSTV0910_P1_NNOSRAD1  0xf48c
 #define FSTV0910_P1_NOSRADIAL_NORMED1  0xf48c00ff
 
-/*P1_NNOSRAD0*/
+/* P1_NNOSRAD0 */
 #define RSTV0910_P1_NNOSRAD0  0xf48d
 #define FSTV0910_P1_NOSRADIAL_NORMED0  0xf48d00ff
 
-/*P1_NOSCFGF1*/
+/* P1_NOSCFGF1 */
 #define RSTV0910_P1_NOSCFGF1  0xf48e
 #define FSTV0910_P1_LOWNOISE_MESURE  0xf48e0080
 #define FSTV0910_P1_NOS_DELFRAME  0xf48e0040
@@ -2663,177 +2664,177 @@
 #define FSTV0910_P1_FRAMESEL_TYPESEL  0xf48e000c
 #define FSTV0910_P1_FRAMESEL_TYPE  0xf48e0003
 
-/*P1_NOSCFGF2*/
+/* P1_NOSCFGF2 */
 #define RSTV0910_P1_NOSCFGF2  0xf48f
 #define FSTV0910_P1_DIS_NOSPILOTS  0xf48f0080
 #define FSTV0910_P1_FRAMESEL_MODCODSEL  0xf48f0060
 #define FSTV0910_P1_FRAMESEL_MODCOD  0xf48f001f
 
-/*P1_CAR2CFG*/
+/* P1_CAR2CFG */
 #define RSTV0910_P1_CAR2CFG  0xf490
 #define FSTV0910_P1_ROTA2ON  0xf4900004
 #define FSTV0910_P1_PH_DET_ALGO2  0xf4900003
 
-/*P1_CFR2CFR1*/
+/* P1_CFR2CFR1 */
 #define RSTV0910_P1_CFR2CFR1  0xf491
 #define FSTV0910_P1_EN_S2CAR2CENTER  0xf4910020
 #define FSTV0910_P1_CFR2TOCFR1_BETA  0xf4910007
 
-/*P1_CAR3CFG*/
+/* P1_CAR3CFG */
 #define RSTV0910_P1_CAR3CFG  0xf492
 #define FSTV0910_P1_CARRIER23_MODE  0xf49200c0
 #define FSTV0910_P1_CAR3INTERM_DVBS1  0xf4920020
 #define FSTV0910_P1_ABAMPLIF_MODE  0xf4920018
 #define FSTV0910_P1_CARRIER3_ALPHA3DL  0xf4920007
 
-/*P1_CFR22*/
+/* P1_CFR22 */
 #define RSTV0910_P1_CFR22  0xf493
 #define FSTV0910_P1_CAR2_FREQ2  0xf49301ff
 
-/*P1_CFR21*/
+/* P1_CFR21 */
 #define RSTV0910_P1_CFR21  0xf494
 #define FSTV0910_P1_CAR2_FREQ1  0xf49400ff
 
-/*P1_CFR20*/
+/* P1_CFR20 */
 #define RSTV0910_P1_CFR20  0xf495
 #define FSTV0910_P1_CAR2_FREQ0  0xf49500ff
 
-/*P1_ACLC2S2Q*/
+/* P1_ACLC2S2Q */
 #define RSTV0910_P1_ACLC2S2Q  0xf497
 #define FSTV0910_P1_ENAB_SPSKSYMB  0xf4970080
 #define FSTV0910_P1_CAR2S2_Q_ALPH_M  0xf4970030
 #define FSTV0910_P1_CAR2S2_Q_ALPH_E  0xf497000f
 
-/*P1_ACLC2S28*/
+/* P1_ACLC2S28 */
 #define RSTV0910_P1_ACLC2S28  0xf498
 #define FSTV0910_P1_CAR2S2_8_ALPH_M  0xf4980030
 #define FSTV0910_P1_CAR2S2_8_ALPH_E  0xf498000f
 
-/*P1_ACLC2S216A*/
+/* P1_ACLC2S216A */
 #define RSTV0910_P1_ACLC2S216A  0xf499
 #define FSTV0910_P1_CAR2S2_16A_ALPH_M  0xf4990030
 #define FSTV0910_P1_CAR2S2_16A_ALPH_E  0xf499000f
 
-/*P1_ACLC2S232A*/
+/* P1_ACLC2S232A */
 #define RSTV0910_P1_ACLC2S232A  0xf49a
 #define FSTV0910_P1_CAR2S2_32A_ALPH_M  0xf49a0030
 #define FSTV0910_P1_CAR2S2_32A_ALPH_E  0xf49a000f
 
-/*P1_BCLC2S2Q*/
+/* P1_BCLC2S2Q */
 #define RSTV0910_P1_BCLC2S2Q  0xf49c
 #define FSTV0910_P1_CAR2S2_Q_BETA_M  0xf49c0030
 #define FSTV0910_P1_CAR2S2_Q_BETA_E  0xf49c000f
 
-/*P1_BCLC2S28*/
+/* P1_BCLC2S28 */
 #define RSTV0910_P1_BCLC2S28  0xf49d
 #define FSTV0910_P1_CAR2S2_8_BETA_M  0xf49d0030
 #define FSTV0910_P1_CAR2S2_8_BETA_E  0xf49d000f
 
-/*P1_BCLC2S216A*/
+/* P1_BCLC2S216A */
 #define RSTV0910_P1_BCLC2S216A  0xf49e
 #define FSTV0910_P1_DVBS2S216A_NIP  0xf49e0080
 #define FSTV0910_P1_CAR2S2_16A_BETA_M  0xf49e0030
 #define FSTV0910_P1_CAR2S2_16A_BETA_E  0xf49e000f
 
-/*P1_BCLC2S232A*/
+/* P1_BCLC2S232A */
 #define RSTV0910_P1_BCLC2S232A  0xf49f
 #define FSTV0910_P1_DVBS2S232A_NIP  0xf49f0080
 #define FSTV0910_P1_CAR2S2_32A_BETA_M  0xf49f0030
 #define FSTV0910_P1_CAR2S2_32A_BETA_E  0xf49f000f
 
-/*P1_PLROOT2*/
+/* P1_PLROOT2 */
 #define RSTV0910_P1_PLROOT2  0xf4ac
 #define FSTV0910_P1_PLSCRAMB_MODE  0xf4ac000c
 #define FSTV0910_P1_PLSCRAMB_ROOT2  0xf4ac0003
 
-/*P1_PLROOT1*/
+/* P1_PLROOT1 */
 #define RSTV0910_P1_PLROOT1  0xf4ad
 #define FSTV0910_P1_PLSCRAMB_ROOT1  0xf4ad00ff
 
-/*P1_PLROOT0*/
+/* P1_PLROOT0 */
 #define RSTV0910_P1_PLROOT0  0xf4ae
 #define FSTV0910_P1_PLSCRAMB_ROOT0  0xf4ae00ff
 
-/*P1_MODCODLST0*/
+/* P1_MODCODLST0 */
 #define RSTV0910_P1_MODCODLST0  0xf4b0
 #define FSTV0910_P1_NACCES_MODCODCH  0xf4b00001
 
-/*P1_MODCODLST1*/
+/* P1_MODCODLST1 */
 #define RSTV0910_P1_MODCODLST1  0xf4b1
 #define FSTV0910_P1_SYMBRATE_FILTER  0xf4b10008
 #define FSTV0910_P1_NRESET_MODCODLST  0xf4b10004
 #define FSTV0910_P1_DIS_32PSK_9_10  0xf4b10003
 
-/*P1_MODCODLST2*/
+/* P1_MODCODLST2 */
 #define RSTV0910_P1_MODCODLST2  0xf4b2
 #define FSTV0910_P1_DIS_32PSK_8_9  0xf4b200f0
 #define FSTV0910_P1_DIS_32PSK_5_6  0xf4b2000f
 
-/*P1_MODCODLST3*/
+/* P1_MODCODLST3 */
 #define RSTV0910_P1_MODCODLST3  0xf4b3
 #define FSTV0910_P1_DIS_32PSK_4_5  0xf4b300f0
 #define FSTV0910_P1_DIS_32PSK_3_4  0xf4b3000f
 
-/*P1_MODCODLST4*/
+/* P1_MODCODLST4 */
 #define RSTV0910_P1_MODCODLST4  0xf4b4
 #define FSTV0910_P1_DUMMYPL_PILOT  0xf4b40080
 #define FSTV0910_P1_DUMMYPL_NOPILOT  0xf4b40040
 #define FSTV0910_P1_DIS_16PSK_9_10  0xf4b40030
 #define FSTV0910_P1_DIS_16PSK_8_9  0xf4b4000f
 
-/*P1_MODCODLST5*/
+/* P1_MODCODLST5 */
 #define RSTV0910_P1_MODCODLST5  0xf4b5
 #define FSTV0910_P1_DIS_16PSK_5_6  0xf4b500f0
 #define FSTV0910_P1_DIS_16PSK_4_5  0xf4b5000f
 
-/*P1_MODCODLST6*/
+/* P1_MODCODLST6 */
 #define RSTV0910_P1_MODCODLST6  0xf4b6
 #define FSTV0910_P1_DIS_16PSK_3_4  0xf4b600f0
 #define FSTV0910_P1_DIS_16PSK_2_3  0xf4b6000f
 
-/*P1_MODCODLST7*/
+/* P1_MODCODLST7 */
 #define RSTV0910_P1_MODCODLST7  0xf4b7
 #define FSTV0910_P1_MODCOD_NNOSFILTER  0xf4b70080
 #define FSTV0910_P1_DIS_8PSK_9_10  0xf4b70030
 #define FSTV0910_P1_DIS_8PSK_8_9  0xf4b7000f
 
-/*P1_MODCODLST8*/
+/* P1_MODCODLST8 */
 #define RSTV0910_P1_MODCODLST8  0xf4b8
 #define FSTV0910_P1_DIS_8PSK_5_6  0xf4b800f0
 #define FSTV0910_P1_DIS_8PSK_3_4  0xf4b8000f
 
-/*P1_MODCODLST9*/
+/* P1_MODCODLST9 */
 #define RSTV0910_P1_MODCODLST9  0xf4b9
 #define FSTV0910_P1_DIS_8PSK_2_3  0xf4b900f0
 #define FSTV0910_P1_DIS_8PSK_3_5  0xf4b9000f
 
-/*P1_MODCODLSTA*/
+/* P1_MODCODLSTA */
 #define RSTV0910_P1_MODCODLSTA  0xf4ba
 #define FSTV0910_P1_NOSFILTER_LIMITE  0xf4ba0080
 #define FSTV0910_P1_DIS_QPSK_9_10  0xf4ba0030
 #define FSTV0910_P1_DIS_QPSK_8_9  0xf4ba000f
 
-/*P1_MODCODLSTB*/
+/* P1_MODCODLSTB */
 #define RSTV0910_P1_MODCODLSTB  0xf4bb
 #define FSTV0910_P1_DIS_QPSK_5_6  0xf4bb00f0
 #define FSTV0910_P1_DIS_QPSK_4_5  0xf4bb000f
 
-/*P1_MODCODLSTC*/
+/* P1_MODCODLSTC */
 #define RSTV0910_P1_MODCODLSTC  0xf4bc
 #define FSTV0910_P1_DIS_QPSK_3_4  0xf4bc00f0
 #define FSTV0910_P1_DIS_QPSK_2_3  0xf4bc000f
 
-/*P1_MODCODLSTD*/
+/* P1_MODCODLSTD */
 #define RSTV0910_P1_MODCODLSTD  0xf4bd
 #define FSTV0910_P1_DIS_QPSK_3_5  0xf4bd00f0
 #define FSTV0910_P1_DIS_QPSK_1_2  0xf4bd000f
 
-/*P1_MODCODLSTE*/
+/* P1_MODCODLSTE */
 #define RSTV0910_P1_MODCODLSTE  0xf4be
 #define FSTV0910_P1_DIS_QPSK_2_5  0xf4be00f0
 #define FSTV0910_P1_DIS_QPSK_1_3  0xf4be000f
 
-/*P1_MODCODLSTF*/
+/* P1_MODCODLSTF */
 #define RSTV0910_P1_MODCODLSTF  0xf4bf
 #define FSTV0910_P1_DIS_QPSK_1_4  0xf4bf00f0
 #define FSTV0910_P1_DEMOD_INVMODLST  0xf4bf0008
@@ -2841,30 +2842,30 @@
 #define FSTV0910_P1_DDEMOD_NSET  0xf4bf0002
 #define FSTV0910_P1_MODCOD_NSTOCK  0xf4bf0001
 
-/*P1_GAUSSR0*/
+/* P1_GAUSSR0 */
 #define RSTV0910_P1_GAUSSR0  0xf4c0
 #define FSTV0910_P1_EN_CCIMODE  0xf4c00080
 #define FSTV0910_P1_R0_GAUSSIEN  0xf4c0007f
 
-/*P1_CCIR0*/
+/* P1_CCIR0 */
 #define RSTV0910_P1_CCIR0  0xf4c1
 #define FSTV0910_P1_CCIDETECT_PLHONLY  0xf4c10080
 #define FSTV0910_P1_R0_CCI  0xf4c1007f
 
-/*P1_CCIQUANT*/
+/* P1_CCIQUANT */
 #define RSTV0910_P1_CCIQUANT  0xf4c2
 #define FSTV0910_P1_CCI_BETA  0xf4c200e0
 #define FSTV0910_P1_CCI_QUANT  0xf4c2001f
 
-/*P1_CCITHRES*/
+/* P1_CCITHRES */
 #define RSTV0910_P1_CCITHRES  0xf4c3
 #define FSTV0910_P1_CCI_THRESHOLD  0xf4c300ff
 
-/*P1_CCIACC*/
+/* P1_CCIACC */
 #define RSTV0910_P1_CCIACC  0xf4c4
 #define FSTV0910_P1_CCI_VALUE  0xf4c400ff
 
-/*P1_DSTATUS4*/
+/* P1_DSTATUS4 */
 #define RSTV0910_P1_DSTATUS4  0xf4c5
 #define FSTV0910_P1_RAINFADE_DETECT  0xf4c50080
 #define FSTV0910_P1_NOTHRES2_FAIL  0xf4c50040
@@ -2873,234 +2874,234 @@
 #define FSTV0910_P1_CSTENV_DETECT  0xf4c50002
 #define FSTV0910_P1_DETECTION_TRIAX  0xf4c50001
 
-/*P1_DMDRESCFG*/
+/* P1_DMDRESCFG */
 #define RSTV0910_P1_DMDRESCFG  0xf4c6
 #define FSTV0910_P1_DMDRES_RESET  0xf4c60080
 #define FSTV0910_P1_DMDRES_STRALL  0xf4c60008
 #define FSTV0910_P1_DMDRES_NEWONLY  0xf4c60004
 #define FSTV0910_P1_DMDRES_NOSTORE  0xf4c60002
 
-/*P1_DMDRESADR*/
+/* P1_DMDRESADR */
 #define RSTV0910_P1_DMDRESADR  0xf4c7
 #define FSTV0910_P1_DMDRES_VALIDCFR  0xf4c70040
 #define FSTV0910_P1_DMDRES_MEMFULL  0xf4c70030
 #define FSTV0910_P1_DMDRES_RESNBR  0xf4c7000f
 
-/*P1_DMDRESDATA7*/
+/* P1_DMDRESDATA7 */
 #define RSTV0910_P1_DMDRESDATA7  0xf4c8
 #define FSTV0910_P1_DMDRES_DATA7  0xf4c800ff
 
-/*P1_DMDRESDATA6*/
+/* P1_DMDRESDATA6 */
 #define RSTV0910_P1_DMDRESDATA6  0xf4c9
 #define FSTV0910_P1_DMDRES_DATA6  0xf4c900ff
 
-/*P1_DMDRESDATA5*/
+/* P1_DMDRESDATA5 */
 #define RSTV0910_P1_DMDRESDATA5  0xf4ca
 #define FSTV0910_P1_DMDRES_DATA5  0xf4ca00ff
 
-/*P1_DMDRESDATA4*/
+/* P1_DMDRESDATA4 */
 #define RSTV0910_P1_DMDRESDATA4  0xf4cb
 #define FSTV0910_P1_DMDRES_DATA4  0xf4cb00ff
 
-/*P1_DMDRESDATA3*/
+/* P1_DMDRESDATA3 */
 #define RSTV0910_P1_DMDRESDATA3  0xf4cc
 #define FSTV0910_P1_DMDRES_DATA3  0xf4cc00ff
 
-/*P1_DMDRESDATA2*/
+/* P1_DMDRESDATA2 */
 #define RSTV0910_P1_DMDRESDATA2  0xf4cd
 #define FSTV0910_P1_DMDRES_DATA2  0xf4cd00ff
 
-/*P1_DMDRESDATA1*/
+/* P1_DMDRESDATA1 */
 #define RSTV0910_P1_DMDRESDATA1  0xf4ce
 #define FSTV0910_P1_DMDRES_DATA1  0xf4ce00ff
 
-/*P1_DMDRESDATA0*/
+/* P1_DMDRESDATA0 */
 #define RSTV0910_P1_DMDRESDATA0  0xf4cf
 #define FSTV0910_P1_DMDRES_DATA0  0xf4cf00ff
 
-/*P1_FFEI1*/
+/* P1_FFEI1 */
 #define RSTV0910_P1_FFEI1  0xf4d0
 #define FSTV0910_P1_FFE_ACCI1  0xf4d001ff
 
-/*P1_FFEQ1*/
+/* P1_FFEQ1 */
 #define RSTV0910_P1_FFEQ1  0xf4d1
 #define FSTV0910_P1_FFE_ACCQ1  0xf4d101ff
 
-/*P1_FFEI2*/
+/* P1_FFEI2 */
 #define RSTV0910_P1_FFEI2  0xf4d2
 #define FSTV0910_P1_FFE_ACCI2  0xf4d201ff
 
-/*P1_FFEQ2*/
+/* P1_FFEQ2 */
 #define RSTV0910_P1_FFEQ2  0xf4d3
 #define FSTV0910_P1_FFE_ACCQ2  0xf4d301ff
 
-/*P1_FFEI3*/
+/* P1_FFEI3 */
 #define RSTV0910_P1_FFEI3  0xf4d4
 #define FSTV0910_P1_FFE_ACCI3  0xf4d401ff
 
-/*P1_FFEQ3*/
+/* P1_FFEQ3 */
 #define RSTV0910_P1_FFEQ3  0xf4d5
 #define FSTV0910_P1_FFE_ACCQ3  0xf4d501ff
 
-/*P1_FFEI4*/
+/* P1_FFEI4 */
 #define RSTV0910_P1_FFEI4  0xf4d6
 #define FSTV0910_P1_FFE_ACCI4  0xf4d601ff
 
-/*P1_FFEQ4*/
+/* P1_FFEQ4 */
 #define RSTV0910_P1_FFEQ4  0xf4d7
 #define FSTV0910_P1_FFE_ACCQ4  0xf4d701ff
 
-/*P1_FFECFG*/
+/* P1_FFECFG */
 #define RSTV0910_P1_FFECFG  0xf4d8
 #define FSTV0910_P1_EQUALFFE_ON  0xf4d80040
 #define FSTV0910_P1_EQUAL_USEDSYMB  0xf4d80030
 #define FSTV0910_P1_MU_EQUALFFE  0xf4d80007
 
-/*P1_TNRCFG2*/
+/* P1_TNRCFG2 */
 #define RSTV0910_P1_TNRCFG2  0xf4e1
 #define FSTV0910_P1_TUN_IQSWAP  0xf4e10080
 
-/*P1_SMAPCOEF7*/
+/* P1_SMAPCOEF7 */
 #define RSTV0910_P1_SMAPCOEF7  0xf500
 #define FSTV0910_P1_DIS_QSCALE  0xf5000080
 #define FSTV0910_P1_SMAPCOEF_Q_LLR12  0xf500017f
 
-/*P1_SMAPCOEF6*/
+/* P1_SMAPCOEF6 */
 #define RSTV0910_P1_SMAPCOEF6  0xf501
 #define FSTV0910_P1_DIS_AGC2SCALE  0xf5010080
 #define FSTV0910_P1_ADJ_8PSKLLR1  0xf5010004
 #define FSTV0910_P1_OLD_8PSKLLR1  0xf5010002
 #define FSTV0910_P1_DIS_AB8PSK  0xf5010001
 
-/*P1_SMAPCOEF5*/
+/* P1_SMAPCOEF5 */
 #define RSTV0910_P1_SMAPCOEF5  0xf502
 #define FSTV0910_P1_DIS_8SCALE  0xf5020080
 #define FSTV0910_P1_SMAPCOEF_8P_LLR23  0xf502017f
 
-/*P1_SMAPCOEF4*/
+/* P1_SMAPCOEF4 */
 #define RSTV0910_P1_SMAPCOEF4  0xf503
 #define FSTV0910_P1_SMAPCOEF_16APSK_LLR12  0xf503017f
 
-/*P1_SMAPCOEF3*/
+/* P1_SMAPCOEF3 */
 #define RSTV0910_P1_SMAPCOEF3  0xf504
 #define FSTV0910_P1_SMAPCOEF_16APSK_LLR34  0xf504017f
 
-/*P1_SMAPCOEF2*/
+/* P1_SMAPCOEF2 */
 #define RSTV0910_P1_SMAPCOEF2  0xf505
 #define FSTV0910_P1_SMAPCOEF_32APSK_R2R3  0xf50501f0
 #define FSTV0910_P1_SMAPCOEF_32APSK_LLR2  0xf505010f
 
-/*P1_SMAPCOEF1*/
+/* P1_SMAPCOEF1 */
 #define RSTV0910_P1_SMAPCOEF1  0xf506
 #define FSTV0910_P1_DIS_16SCALE  0xf5060080
 #define FSTV0910_P1_SMAPCOEF_32_LLR34  0xf506017f
 
-/*P1_SMAPCOEF0*/
+/* P1_SMAPCOEF0 */
 #define RSTV0910_P1_SMAPCOEF0  0xf507
 #define FSTV0910_P1_DIS_32SCALE  0xf5070080
 #define FSTV0910_P1_SMAPCOEF_32_LLR15  0xf507017f
 
-/*P1_NOSTHRES1*/
+/* P1_NOSTHRES1 */
 #define RSTV0910_P1_NOSTHRES1  0xf509
 #define FSTV0910_P1_NOS_THRESHOLD1  0xf50900ff
 
-/*P1_NOSTHRES2*/
+/* P1_NOSTHRES2 */
 #define RSTV0910_P1_NOSTHRES2  0xf50a
 #define FSTV0910_P1_NOS_THRESHOLD2  0xf50a00ff
 
-/*P1_NOSDIFF1*/
+/* P1_NOSDIFF1 */
 #define RSTV0910_P1_NOSDIFF1  0xf50b
 #define FSTV0910_P1_NOSTHRES1_DIFF  0xf50b00ff
 
-/*P1_RAINFADE*/
+/* P1_RAINFADE */
 #define RSTV0910_P1_RAINFADE  0xf50c
 #define FSTV0910_P1_NOSTHRES_DATAT  0xf50c0080
 #define FSTV0910_P1_RAINFADE_CNLIMIT  0xf50c0070
 #define FSTV0910_P1_RAINFADE_TIMEOUT  0xf50c0007
 
-/*P1_NOSRAMCFG*/
+/* P1_NOSRAMCFG */
 #define RSTV0910_P1_NOSRAMCFG  0xf50d
 #define FSTV0910_P1_NOSRAM_ACTIVATION  0xf50d0030
 #define FSTV0910_P1_NOSRAM_CNRONLY  0xf50d0008
 #define FSTV0910_P1_NOSRAM_LGNCNR1  0xf50d0007
 
-/*P1_NOSRAMPOS*/
+/* P1_NOSRAMPOS */
 #define RSTV0910_P1_NOSRAMPOS  0xf50e
 #define FSTV0910_P1_NOSRAM_LGNCNR0  0xf50e00f0
 #define FSTV0910_P1_NOSRAM_VALIDE  0xf50e0004
 #define FSTV0910_P1_NOSRAM_CNRVAL1  0xf50e0003
 
-/*P1_NOSRAMVAL*/
+/* P1_NOSRAMVAL */
 #define RSTV0910_P1_NOSRAMVAL  0xf50f
 #define FSTV0910_P1_NOSRAM_CNRVAL0  0xf50f00ff
 
-/*P1_DMDPLHSTAT*/
+/* P1_DMDPLHSTAT */
 #define RSTV0910_P1_DMDPLHSTAT  0xf520
 #define FSTV0910_P1_PLH_STATISTIC  0xf52000ff
 
-/*P1_LOCKTIME3*/
+/* P1_LOCKTIME3 */
 #define RSTV0910_P1_LOCKTIME3  0xf522
 #define FSTV0910_P1_DEMOD_LOCKTIME3  0xf52200ff
 
-/*P1_LOCKTIME2*/
+/* P1_LOCKTIME2 */
 #define RSTV0910_P1_LOCKTIME2  0xf523
 #define FSTV0910_P1_DEMOD_LOCKTIME2  0xf52300ff
 
-/*P1_LOCKTIME1*/
+/* P1_LOCKTIME1 */
 #define RSTV0910_P1_LOCKTIME1  0xf524
 #define FSTV0910_P1_DEMOD_LOCKTIME1  0xf52400ff
 
-/*P1_LOCKTIME0*/
+/* P1_LOCKTIME0 */
 #define RSTV0910_P1_LOCKTIME0  0xf525
 #define FSTV0910_P1_DEMOD_LOCKTIME0  0xf52500ff
 
-/*P1_VITSCALE*/
+/* P1_VITSCALE */
 #define RSTV0910_P1_VITSCALE  0xf532
 #define FSTV0910_P1_NVTH_NOSRANGE  0xf5320080
 #define FSTV0910_P1_VERROR_MAXMODE  0xf5320040
 #define FSTV0910_P1_NSLOWSN_LOCKED  0xf5320008
 #define FSTV0910_P1_DIS_RSFLOCK  0xf5320002
 
-/*P1_FECM*/
+/* P1_FECM */
 #define RSTV0910_P1_FECM  0xf533
 #define FSTV0910_P1_DSS_DVB  0xf5330080
 #define FSTV0910_P1_DSS_SRCH  0xf5330010
 #define FSTV0910_P1_SYNCVIT  0xf5330002
 #define FSTV0910_P1_IQINV  0xf5330001
 
-/*P1_VTH12*/
+/* P1_VTH12 */
 #define RSTV0910_P1_VTH12  0xf534
 #define FSTV0910_P1_VTH12  0xf53400ff
 
-/*P1_VTH23*/
+/* P1_VTH23 */
 #define RSTV0910_P1_VTH23  0xf535
 #define FSTV0910_P1_VTH23  0xf53500ff
 
-/*P1_VTH34*/
+/* P1_VTH34 */
 #define RSTV0910_P1_VTH34  0xf536
 #define FSTV0910_P1_VTH34  0xf53600ff
 
-/*P1_VTH56*/
+/* P1_VTH56 */
 #define RSTV0910_P1_VTH56  0xf537
 #define FSTV0910_P1_VTH56  0xf53700ff
 
-/*P1_VTH67*/
+/* P1_VTH67 */
 #define RSTV0910_P1_VTH67  0xf538
 #define FSTV0910_P1_VTH67  0xf53800ff
 
-/*P1_VTH78*/
+/* P1_VTH78 */
 #define RSTV0910_P1_VTH78  0xf539
 #define FSTV0910_P1_VTH78  0xf53900ff
 
-/*P1_VITCURPUN*/
+/* P1_VITCURPUN */
 #define RSTV0910_P1_VITCURPUN  0xf53a
 #define FSTV0910_P1_VIT_CURPUN  0xf53a001f
 
-/*P1_VERROR*/
+/* P1_VERROR */
 #define RSTV0910_P1_VERROR  0xf53b
 #define FSTV0910_P1_REGERR_VIT  0xf53b00ff
 
-/*P1_PRVIT*/
+/* P1_PRVIT */
 #define RSTV0910_P1_PRVIT  0xf53c
 #define FSTV0910_P1_DIS_VTHLOCK  0xf53c0040
 #define FSTV0910_P1_E7_8VIT  0xf53c0020
@@ -3110,7 +3111,7 @@
 #define FSTV0910_P1_E2_3VIT  0xf53c0002
 #define FSTV0910_P1_E1_2VIT  0xf53c0001
 
-/*P1_VAVSRVIT*/
+/* P1_VAVSRVIT */
 #define RSTV0910_P1_VAVSRVIT  0xf53d
 #define FSTV0910_P1_AMVIT  0xf53d0080
 #define FSTV0910_P1_FROZENVIT  0xf53d0040
@@ -3118,52 +3119,52 @@
 #define FSTV0910_P1_TOVVIT  0xf53d000c
 #define FSTV0910_P1_HYPVIT  0xf53d0003
 
-/*P1_VSTATUSVIT*/
+/* P1_VSTATUSVIT */
 #define RSTV0910_P1_VSTATUSVIT  0xf53e
 #define FSTV0910_P1_PRFVIT  0xf53e0010
 #define FSTV0910_P1_LOCKEDVIT  0xf53e0008
 
-/*P1_VTHINUSE*/
+/* P1_VTHINUSE */
 #define RSTV0910_P1_VTHINUSE  0xf53f
 #define FSTV0910_P1_VIT_INUSE  0xf53f00ff
 
-/*P1_KDIV12*/
+/* P1_KDIV12 */
 #define RSTV0910_P1_KDIV12  0xf540
 #define FSTV0910_P1_K_DIVIDER_12  0xf540007f
 
-/*P1_KDIV23*/
+/* P1_KDIV23 */
 #define RSTV0910_P1_KDIV23  0xf541
 #define FSTV0910_P1_K_DIVIDER_23  0xf541007f
 
-/*P1_KDIV34*/
+/* P1_KDIV34 */
 #define RSTV0910_P1_KDIV34  0xf542
 #define FSTV0910_P1_K_DIVIDER_34  0xf542007f
 
-/*P1_KDIV56*/
+/* P1_KDIV56 */
 #define RSTV0910_P1_KDIV56  0xf543
 #define FSTV0910_P1_K_DIVIDER_56  0xf543007f
 
-/*P1_KDIV67*/
+/* P1_KDIV67 */
 #define RSTV0910_P1_KDIV67  0xf544
 #define FSTV0910_P1_K_DIVIDER_67  0xf544007f
 
-/*P1_KDIV78*/
+/* P1_KDIV78 */
 #define RSTV0910_P1_KDIV78  0xf545
 #define FSTV0910_P1_K_DIVIDER_78  0xf545007f
 
-/*P1_TSPIDFLT1*/
+/* P1_TSPIDFLT1 */
 #define RSTV0910_P1_TSPIDFLT1  0xf546
 #define FSTV0910_P1_PIDFLT_ADDR  0xf54600ff
 
-/*P1_TSPIDFLT0*/
+/* P1_TSPIDFLT0 */
 #define RSTV0910_P1_TSPIDFLT0  0xf547
 #define FSTV0910_P1_PIDFLT_DATA  0xf54700ff
 
-/*P1_PDELCTRL0*/
+/* P1_PDELCTRL0 */
 #define RSTV0910_P1_PDELCTRL0  0xf54f
 #define FSTV0910_P1_ISIOBS_MODE  0xf54f0030
 
-/*P1_PDELCTRL1*/
+/* P1_PDELCTRL1 */
 #define RSTV0910_P1_PDELCTRL1  0xf550
 #define FSTV0910_P1_INV_MISMASK  0xf5500080
 #define FSTV0910_P1_FILTER_EN  0xf5500020
@@ -3172,68 +3173,68 @@
 #define FSTV0910_P1_EN_MIS00  0xf5500002
 #define FSTV0910_P1_ALGOSWRST  0xf5500001
 
-/*P1_PDELCTRL2*/
+/* P1_PDELCTRL2 */
 #define RSTV0910_P1_PDELCTRL2  0xf551
 #define FSTV0910_P1_FORCE_CONTINUOUS  0xf5510080
 #define FSTV0910_P1_RESET_UPKO_COUNT  0xf5510040
 #define FSTV0910_P1_USER_PKTDELIN_NB  0xf5510020
 #define FSTV0910_P1_FRAME_MODE  0xf5510002
 
-/*P1_HYSTTHRESH*/
+/* P1_HYSTTHRESH */
 #define RSTV0910_P1_HYSTTHRESH  0xf554
 #define FSTV0910_P1_DELIN_LOCKTHRES  0xf55400f0
 #define FSTV0910_P1_DELIN_UNLOCKTHRES  0xf554000f
 
-/*P1_UPLCCST0*/
+/* P1_UPLCCST0 */
 #define RSTV0910_P1_UPLCCST0  0xf558
 #define FSTV0910_P1_UPL_CST0  0xf55800f8
 #define FSTV0910_P1_UPL_MODE  0xf5580007
 
-/*P1_ISIENTRY*/
+/* P1_ISIENTRY */
 #define RSTV0910_P1_ISIENTRY  0xf55e
 #define FSTV0910_P1_ISI_ENTRY  0xf55e00ff
 
-/*P1_ISIBITENA*/
+/* P1_ISIBITENA */
 #define RSTV0910_P1_ISIBITENA  0xf55f
 #define FSTV0910_P1_ISI_BIT_EN  0xf55f00ff
 
-/*P1_MATSTR1*/
+/* P1_MATSTR1 */
 #define RSTV0910_P1_MATSTR1  0xf560
 #define FSTV0910_P1_MATYPE_CURRENT1  0xf56000ff
 
-/*P1_MATSTR0*/
+/* P1_MATSTR0 */
 #define RSTV0910_P1_MATSTR0  0xf561
 #define FSTV0910_P1_MATYPE_CURRENT0  0xf56100ff
 
-/*P1_UPLSTR1*/
+/* P1_UPLSTR1 */
 #define RSTV0910_P1_UPLSTR1  0xf562
 #define FSTV0910_P1_UPL_CURRENT1  0xf56200ff
 
-/*P1_UPLSTR0*/
+/* P1_UPLSTR0 */
 #define RSTV0910_P1_UPLSTR0  0xf563
 #define FSTV0910_P1_UPL_CURRENT0  0xf56300ff
 
-/*P1_DFLSTR1*/
+/* P1_DFLSTR1 */
 #define RSTV0910_P1_DFLSTR1  0xf564
 #define FSTV0910_P1_DFL_CURRENT1  0xf56400ff
 
-/*P1_DFLSTR0*/
+/* P1_DFLSTR0 */
 #define RSTV0910_P1_DFLSTR0  0xf565
 #define FSTV0910_P1_DFL_CURRENT0  0xf56500ff
 
-/*P1_SYNCSTR*/
+/* P1_SYNCSTR */
 #define RSTV0910_P1_SYNCSTR  0xf566
 #define FSTV0910_P1_SYNC_CURRENT  0xf56600ff
 
-/*P1_SYNCDSTR1*/
+/* P1_SYNCDSTR1 */
 #define RSTV0910_P1_SYNCDSTR1  0xf567
 #define FSTV0910_P1_SYNCD_CURRENT1  0xf56700ff
 
-/*P1_SYNCDSTR0*/
+/* P1_SYNCDSTR0 */
 #define RSTV0910_P1_SYNCDSTR0  0xf568
 #define FSTV0910_P1_SYNCD_CURRENT0  0xf56800ff
 
-/*P1_PDELSTATUS1*/
+/* P1_PDELSTATUS1 */
 #define RSTV0910_P1_PDELSTATUS1  0xf569
 #define FSTV0910_P1_PKTDELIN_DELOCK  0xf5690080
 #define FSTV0910_P1_SYNCDUPDFL_BADDFL  0xf5690040
@@ -3242,33 +3243,33 @@
 #define FSTV0910_P1_PKTDELIN_LOCK  0xf5690002
 #define FSTV0910_P1_FIRST_LOCK  0xf5690001
 
-/*P1_PDELSTATUS2*/
+/* P1_PDELSTATUS2 */
 #define RSTV0910_P1_PDELSTATUS2  0xf56a
 #define FSTV0910_P1_FRAME_MODCOD  0xf56a007c
 #define FSTV0910_P1_FRAME_TYPE  0xf56a0003
 
-/*P1_BBFCRCKO1*/
+/* P1_BBFCRCKO1 */
 #define RSTV0910_P1_BBFCRCKO1  0xf56b
 #define FSTV0910_P1_BBHCRC_KOCNT1  0xf56b00ff
 
-/*P1_BBFCRCKO0*/
+/* P1_BBFCRCKO0 */
 #define RSTV0910_P1_BBFCRCKO0  0xf56c
 #define FSTV0910_P1_BBHCRC_KOCNT0  0xf56c00ff
 
-/*P1_UPCRCKO1*/
+/* P1_UPCRCKO1 */
 #define RSTV0910_P1_UPCRCKO1  0xf56d
 #define FSTV0910_P1_PKTCRC_KOCNT1  0xf56d00ff
 
-/*P1_UPCRCKO0*/
+/* P1_UPCRCKO0 */
 #define RSTV0910_P1_UPCRCKO0  0xf56e
 #define FSTV0910_P1_PKTCRC_KOCNT0  0xf56e00ff
 
-/*P1_PDELCTRL3*/
+/* P1_PDELCTRL3 */
 #define RSTV0910_P1_PDELCTRL3  0xf56f
 #define FSTV0910_P1_NOFIFO_BCHERR  0xf56f0020
 #define FSTV0910_P1_PKTDELIN_DELACMERR  0xf56f0010
 
-/*P1_TSSTATEM*/
+/* P1_TSSTATEM */
 #define RSTV0910_P1_TSSTATEM  0xf570
 #define FSTV0910_P1_TSDIL_ON  0xf5700080
 #define FSTV0910_P1_TSRS_ON  0xf5700020
@@ -3278,7 +3279,7 @@
 #define FSTV0910_P1_TSACM_MODE  0xf5700002
 #define FSTV0910_P1_TSOUT_NOSYNC  0xf5700001
 
-/*P1_TSSTATEL*/
+/* P1_TSSTATEL */
 #define RSTV0910_P1_TSSTATEL  0xf571
 #define FSTV0910_P1_TSNOSYNCBYTE  0xf5710080
 #define FSTV0910_P1_TSPARITY_ON  0xf5710040
@@ -3287,7 +3288,7 @@
 #define FSTV0910_P1_TSCRC8_ON  0xf5710002
 #define FSTV0910_P1_TSDSS_PACKET  0xf5710001
 
-/*P1_TSCFGH*/
+/* P1_TSCFGH */
 #define RSTV0910_P1_TSCFGH  0xf572
 #define FSTV0910_P1_TSFIFO_DVBCI  0xf5720080
 #define FSTV0910_P1_TSFIFO_SERIAL  0xf5720040
@@ -3297,14 +3298,14 @@
 #define FSTV0910_P1_TSFIFO_ERRMODE  0xf5720006
 #define FSTV0910_P1_RST_HWARE  0xf5720001
 
-/*P1_TSCFGM*/
+/* P1_TSCFGM */
 #define RSTV0910_P1_TSCFGM  0xf573
 #define FSTV0910_P1_TSFIFO_MANSPEED  0xf57300c0
 #define FSTV0910_P1_TSFIFO_PERMDATA  0xf5730020
 #define FSTV0910_P1_TSFIFO_NONEWSGNL  0xf5730010
 #define FSTV0910_P1_TSFIFO_INVDATA  0xf5730001
 
-/*P1_TSCFGL*/
+/* P1_TSCFGL */
 #define RSTV0910_P1_TSCFGL  0xf574
 #define FSTV0910_P1_TSFIFO_BCLKDEL1CK  0xf57400c0
 #define FSTV0910_P1_BCHERROR_MODE  0xf5740030
@@ -3312,11 +3313,11 @@
 #define FSTV0910_P1_TSFIFO_EMBINDVB  0xf5740004
 #define FSTV0910_P1_TSFIFO_BITSPEED  0xf5740003
 
-/*P1_TSSYNC*/
+/* P1_TSSYNC */
 #define RSTV0910_P1_TSSYNC  0xf575
 #define FSTV0910_P1_TSFIFO_SYNCMODE  0xf5750018
 
-/*P1_TSINSDELH*/
+/* P1_TSINSDELH */
 #define RSTV0910_P1_TSINSDELH  0xf576
 #define FSTV0910_P1_TSDEL_SYNCBYTE  0xf5760080
 #define FSTV0910_P1_TSDEL_XXHEADER  0xf5760040
@@ -3324,7 +3325,7 @@
 #define FSTV0910_P1_TSINSDEL_RSPARITY  0xf5760002
 #define FSTV0910_P1_TSINSDEL_CRC8  0xf5760001
 
-/*P1_TSINSDELM*/
+/* P1_TSINSDELM */
 #define RSTV0910_P1_TSINSDELM  0xf577
 #define FSTV0910_P1_TSINS_EMODCOD  0xf5770010
 #define FSTV0910_P1_TSINS_TOKEN  0xf5770008
@@ -3332,7 +3333,7 @@
 #define FSTV0910_P1_TSINS_MATYPE  0xf5770002
 #define FSTV0910_P1_TSINS_UPL  0xf5770001
 
-/*P1_TSINSDELL*/
+/* P1_TSINSDELL */
 #define RSTV0910_P1_TSINSDELL  0xf578
 #define FSTV0910_P1_TSINS_DFL  0xf5780080
 #define FSTV0910_P1_TSINS_SYNCD  0xf5780040
@@ -3343,20 +3344,20 @@
 #define FSTV0910_P1_TSINS_TSCONFIG  0xf5780002
 #define FSTV0910_P1_TSINS_LATENCY  0xf5780001
 
-/*P1_TSDIVN*/
+/* P1_TSDIVN */
 #define RSTV0910_P1_TSDIVN  0xf579
 #define FSTV0910_P1_TSFIFO_SPEEDMODE  0xf57900c0
 #define FSTV0910_P1_TSFIFO_RISEOK  0xf5790007
 
-/*P1_TSCFG4*/
+/* P1_TSCFG4 */
 #define RSTV0910_P1_TSCFG4  0xf57a
 #define FSTV0910_P1_TSFIFO_TSSPEEDMODE  0xf57a00c0
 
-/*P1_TSSPEED*/
+/* P1_TSSPEED */
 #define RSTV0910_P1_TSSPEED  0xf580
 #define FSTV0910_P1_TSFIFO_OUTSPEED  0xf58000ff
 
-/*P1_TSSTATUS*/
+/* P1_TSSTATUS */
 #define RSTV0910_P1_TSSTATUS  0xf581
 #define FSTV0910_P1_TSFIFO_LINEOK  0xf5810080
 #define FSTV0910_P1_TSFIFO_ERROR  0xf5810040
@@ -3364,111 +3365,111 @@
 #define FSTV0910_P1_TSREGUL_ERROR  0xf5810004
 #define FSTV0910_P1_DIL_READY  0xf5810001
 
-/*P1_TSSTATUS2*/
+/* P1_TSSTATUS2 */
 #define RSTV0910_P1_TSSTATUS2  0xf582
 #define FSTV0910_P1_TSFIFO_DEMODSEL  0xf5820080
 #define FSTV0910_P1_TSFIFOSPEED_STORE  0xf5820040
 #define FSTV0910_P1_DILXX_RESET  0xf5820020
 #define FSTV0910_P1_SCRAMBDETECT  0xf5820002
 
-/*P1_TSBITRATE1*/
+/* P1_TSBITRATE1 */
 #define RSTV0910_P1_TSBITRATE1  0xf583
 #define FSTV0910_P1_TSFIFO_BITRATE1  0xf58300ff
 
-/*P1_TSBITRATE0*/
+/* P1_TSBITRATE0 */
 #define RSTV0910_P1_TSBITRATE0  0xf584
 #define FSTV0910_P1_TSFIFO_BITRATE0  0xf58400ff
 
-/*P1_TSPACKLEN1*/
+/* P1_TSPACKLEN1 */
 #define RSTV0910_P1_TSPACKLEN1  0xf585
 #define FSTV0910_P1_TSFIFO_PACKCPT  0xf58500e0
 
-/*P1_TSDLY2*/
+/* P1_TSDLY2 */
 #define RSTV0910_P1_TSDLY2  0xf589
 #define FSTV0910_P1_SOFFIFO_LATENCY2  0xf589000f
 
-/*P1_TSDLY1*/
+/* P1_TSDLY1 */
 #define RSTV0910_P1_TSDLY1  0xf58a
 #define FSTV0910_P1_SOFFIFO_LATENCY1  0xf58a00ff
 
-/*P1_TSDLY0*/
+/* P1_TSDLY0 */
 #define RSTV0910_P1_TSDLY0  0xf58b
 #define FSTV0910_P1_SOFFIFO_LATENCY0  0xf58b00ff
 
-/*P1_TSNPDAV*/
+/* P1_TSNPDAV */
 #define RSTV0910_P1_TSNPDAV  0xf58c
 #define FSTV0910_P1_TSNPD_AVERAGE  0xf58c00ff
 
-/*P1_TSBUFSTAT2*/
+/* P1_TSBUFSTAT2 */
 #define RSTV0910_P1_TSBUFSTAT2  0xf58d
 #define FSTV0910_P1_TSISCR_3BYTES  0xf58d0080
 #define FSTV0910_P1_TSISCR_NEWDATA  0xf58d0040
 #define FSTV0910_P1_TSISCR_BUFSTAT2  0xf58d003f
 
-/*P1_TSBUFSTAT1*/
+/* P1_TSBUFSTAT1 */
 #define RSTV0910_P1_TSBUFSTAT1  0xf58e
 #define FSTV0910_P1_TSISCR_BUFSTAT1  0xf58e00ff
 
-/*P1_TSBUFSTAT0*/
+/* P1_TSBUFSTAT0 */
 #define RSTV0910_P1_TSBUFSTAT0  0xf58f
 #define FSTV0910_P1_TSISCR_BUFSTAT0  0xf58f00ff
 
-/*P1_TSDEBUGL*/
+/* P1_TSDEBUGL */
 #define RSTV0910_P1_TSDEBUGL  0xf591
 #define FSTV0910_P1_TSFIFO_ERROR_EVNT  0xf5910004
 #define FSTV0910_P1_TSFIFO_OVERFLOWM  0xf5910001
 
-/*P1_TSDLYSET2*/
+/* P1_TSDLYSET2 */
 #define RSTV0910_P1_TSDLYSET2  0xf592
 #define FSTV0910_P1_SOFFIFO_OFFSET  0xf59200c0
 #define FSTV0910_P1_HYSTERESIS_THRESHOLD  0xf5920030
 #define FSTV0910_P1_SOFFIFO_SYMBOFFS2  0xf592000f
 
-/*P1_TSDLYSET1*/
+/* P1_TSDLYSET1 */
 #define RSTV0910_P1_TSDLYSET1  0xf593
 #define FSTV0910_P1_SOFFIFO_SYMBOFFS1  0xf59300ff
 
-/*P1_TSDLYSET0*/
+/* P1_TSDLYSET0 */
 #define RSTV0910_P1_TSDLYSET0  0xf594
 #define FSTV0910_P1_SOFFIFO_SYMBOFFS0  0xf59400ff
 
-/*P1_ERRCTRL1*/
+/* P1_ERRCTRL1 */
 #define RSTV0910_P1_ERRCTRL1  0xf598
 #define FSTV0910_P1_ERR_SOURCE1  0xf59800f0
 #define FSTV0910_P1_NUM_EVENT1  0xf5980007
 
-/*P1_ERRCNT12*/
+/* P1_ERRCNT12 */
 #define RSTV0910_P1_ERRCNT12  0xf599
 #define FSTV0910_P1_ERRCNT1_OLDVALUE  0xf5990080
 #define FSTV0910_P1_ERR_CNT12  0xf599007f
 
-/*P1_ERRCNT11*/
+/* P1_ERRCNT11 */
 #define RSTV0910_P1_ERRCNT11  0xf59a
 #define FSTV0910_P1_ERR_CNT11  0xf59a00ff
 
-/*P1_ERRCNT10*/
+/* P1_ERRCNT10 */
 #define RSTV0910_P1_ERRCNT10  0xf59b
 #define FSTV0910_P1_ERR_CNT10  0xf59b00ff
 
-/*P1_ERRCTRL2*/
+/* P1_ERRCTRL2 */
 #define RSTV0910_P1_ERRCTRL2  0xf59c
 #define FSTV0910_P1_ERR_SOURCE2  0xf59c00f0
 #define FSTV0910_P1_NUM_EVENT2  0xf59c0007
 
-/*P1_ERRCNT22*/
+/* P1_ERRCNT22 */
 #define RSTV0910_P1_ERRCNT22  0xf59d
 #define FSTV0910_P1_ERRCNT2_OLDVALUE  0xf59d0080
 #define FSTV0910_P1_ERR_CNT22  0xf59d007f
 
-/*P1_ERRCNT21*/
+/* P1_ERRCNT21 */
 #define RSTV0910_P1_ERRCNT21  0xf59e
 #define FSTV0910_P1_ERR_CNT21  0xf59e00ff
 
-/*P1_ERRCNT20*/
+/* P1_ERRCNT20 */
 #define RSTV0910_P1_ERRCNT20  0xf59f
 #define FSTV0910_P1_ERR_CNT20  0xf59f00ff
 
-/*P1_FECSPY*/
+/* P1_FECSPY */
 #define RSTV0910_P1_FECSPY  0xf5a0
 #define FSTV0910_P1_SPY_ENABLE  0xf5a00080
 #define FSTV0910_P1_NO_SYNCBYTE  0xf5a00040
@@ -3478,7 +3479,7 @@
 #define FSTV0910_P1_BERMETER_LMODE  0xf5a00002
 #define FSTV0910_P1_BERMETER_RESET  0xf5a00001
 
-/*P1_FSPYCFG*/
+/* P1_FSPYCFG */
 #define RSTV0910_P1_FSPYCFG  0xf5a1
 #define FSTV0910_P1_FECSPY_INPUT  0xf5a100c0
 #define FSTV0910_P1_RST_ON_ERROR  0xf5a10020
@@ -3486,18 +3487,18 @@
 #define FSTV0910_P1_I2C_MODE  0xf5a1000c
 #define FSTV0910_P1_SPY_HYSTERESIS  0xf5a10003
 
-/*P1_FSPYDATA*/
+/* P1_FSPYDATA */
 #define RSTV0910_P1_FSPYDATA  0xf5a2
 #define FSTV0910_P1_SPY_STUFFING  0xf5a20080
 #define FSTV0910_P1_SPY_CNULLPKT  0xf5a20020
 #define FSTV0910_P1_SPY_OUTDATA_MODE  0xf5a2001f
 
-/*P1_FSPYOUT*/
+/* P1_FSPYOUT */
 #define RSTV0910_P1_FSPYOUT  0xf5a3
 #define FSTV0910_P1_FSPY_DIRECT  0xf5a30080
 #define FSTV0910_P1_STUFF_MODE  0xf5a30007
 
-/*P1_FSTATUS*/
+/* P1_FSTATUS */
 #define RSTV0910_P1_FSTATUS  0xf5a4
 #define FSTV0910_P1_SPY_ENDSIM  0xf5a40080
 #define FSTV0910_P1_VALID_SIM  0xf5a40040
@@ -3505,49 +3506,49 @@
 #define FSTV0910_P1_DSS_SYNCBYTE  0xf5a40010
 #define FSTV0910_P1_RESULT_STATE  0xf5a4000f
 
-/*P1_FBERCPT4*/
+/* P1_FBERCPT4 */
 #define RSTV0910_P1_FBERCPT4  0xf5a8
 #define FSTV0910_P1_FBERMETER_CPT4  0xf5a800ff
 
-/*P1_FBERCPT3*/
+/* P1_FBERCPT3 */
 #define RSTV0910_P1_FBERCPT3  0xf5a9
 #define FSTV0910_P1_FBERMETER_CPT3  0xf5a900ff
 
-/*P1_FBERCPT2*/
+/* P1_FBERCPT2 */
 #define RSTV0910_P1_FBERCPT2  0xf5aa
 #define FSTV0910_P1_FBERMETER_CPT2  0xf5aa00ff
 
-/*P1_FBERCPT1*/
+/* P1_FBERCPT1 */
 #define RSTV0910_P1_FBERCPT1  0xf5ab
 #define FSTV0910_P1_FBERMETER_CPT1  0xf5ab00ff
 
-/*P1_FBERCPT0*/
+/* P1_FBERCPT0 */
 #define RSTV0910_P1_FBERCPT0  0xf5ac
 #define FSTV0910_P1_FBERMETER_CPT0  0xf5ac00ff
 
-/*P1_FBERERR2*/
+/* P1_FBERERR2 */
 #define RSTV0910_P1_FBERERR2  0xf5ad
 #define FSTV0910_P1_FBERMETER_ERR2  0xf5ad00ff
 
-/*P1_FBERERR1*/
+/* P1_FBERERR1 */
 #define RSTV0910_P1_FBERERR1  0xf5ae
 #define FSTV0910_P1_FBERMETER_ERR1  0xf5ae00ff
 
-/*P1_FBERERR0*/
+/* P1_FBERERR0 */
 #define RSTV0910_P1_FBERERR0  0xf5af
 #define FSTV0910_P1_FBERMETER_ERR0  0xf5af00ff
 
-/*P1_FSPYBER*/
+/* P1_FSPYBER */
 #define RSTV0910_P1_FSPYBER  0xf5b2
 #define FSTV0910_P1_FSPYBER_SYNCBYTE  0xf5b20010
 #define FSTV0910_P1_FSPYBER_UNSYNC  0xf5b20008
 #define FSTV0910_P1_FSPYBER_CTIME  0xf5b20007
 
-/*P1_SFERROR*/
+/* P1_SFERROR */
 #define RSTV0910_P1_SFERROR  0xf5c1
 #define FSTV0910_P1_SFEC_REGERR_VIT  0xf5c100ff
 
-/*P1_SFECSTATUS*/
+/* P1_SFECSTATUS */
 #define RSTV0910_P1_SFECSTATUS  0xf5c3
 #define FSTV0910_P1_SFEC_ON  0xf5c30080
 #define FSTV0910_P1_SFEC_OFF  0xf5c30040
@@ -3556,31 +3557,31 @@
 #define FSTV0910_P1_SFEC_DEMODSEL  0xf5c30002
 #define FSTV0910_P1_SFEC_OVFON  0xf5c30001
 
-/*P1_SFKDIV12*/
+/* P1_SFKDIV12 */
 #define RSTV0910_P1_SFKDIV12  0xf5c4
 #define FSTV0910_P1_SFECKDIV12_MAN  0xf5c40080
 
-/*P1_SFKDIV23*/
+/* P1_SFKDIV23 */
 #define RSTV0910_P1_SFKDIV23  0xf5c5
 #define FSTV0910_P1_SFECKDIV23_MAN  0xf5c50080
 
-/*P1_SFKDIV34*/
+/* P1_SFKDIV34 */
 #define RSTV0910_P1_SFKDIV34  0xf5c6
 #define FSTV0910_P1_SFECKDIV34_MAN  0xf5c60080
 
-/*P1_SFKDIV56*/
+/* P1_SFKDIV56 */
 #define RSTV0910_P1_SFKDIV56  0xf5c7
 #define FSTV0910_P1_SFECKDIV56_MAN  0xf5c70080
 
-/*P1_SFKDIV67*/
+/* P1_SFKDIV67 */
 #define RSTV0910_P1_SFKDIV67  0xf5c8
 #define FSTV0910_P1_SFECKDIV67_MAN  0xf5c80080
 
-/*P1_SFKDIV78*/
+/* P1_SFKDIV78 */
 #define RSTV0910_P1_SFKDIV78  0xf5c9
 #define FSTV0910_P1_SFECKDIV78_MAN  0xf5c90080
 
-/*P1_SFSTATUS*/
+/* P1_SFSTATUS */
 #define RSTV0910_P1_SFSTATUS  0xf5cc
 #define FSTV0910_P1_SFEC_LINEOK  0xf5cc0080
 #define FSTV0910_P1_SFEC_ERROR  0xf5cc0040
@@ -3591,29 +3592,29 @@
 #define FSTV0910_P1_SFEC_UNREGULA  0xf5cc0002
 #define FSTV0910_P1_SFEC_READY  0xf5cc0001
 
-/*P1_SFDLYSET2*/
+/* P1_SFDLYSET2 */
 #define RSTV0910_P1_SFDLYSET2  0xf5d0
 #define FSTV0910_P1_SFEC_DISABLE  0xf5d00002
 
-/*P1_SFERRCTRL*/
+/* P1_SFERRCTRL */
 #define RSTV0910_P1_SFERRCTRL  0xf5d8
 #define FSTV0910_P1_SFEC_ERR_SOURCE  0xf5d800f0
 #define FSTV0910_P1_SFEC_NUM_EVENT  0xf5d80007
 
-/*P1_SFERRCNT2*/
+/* P1_SFERRCNT2 */
 #define RSTV0910_P1_SFERRCNT2  0xf5d9
 #define FSTV0910_P1_SFERRC_OLDVALUE  0xf5d90080
 #define FSTV0910_P1_SFEC_ERR_CNT2  0xf5d9007f
 
-/*P1_SFERRCNT1*/
+/* P1_SFERRCNT1 */
 #define RSTV0910_P1_SFERRCNT1  0xf5da
 #define FSTV0910_P1_SFEC_ERR_CNT1  0xf5da00ff
 
-/*P1_SFERRCNT0*/
+/* P1_SFERRCNT0 */
 #define RSTV0910_P1_SFERRCNT0  0xf5db
 #define FSTV0910_P1_SFEC_ERR_CNT0  0xf5db00ff
 
-/*RCCFG2*/
+/* RCCFG2 */
 #define RSTV0910_RCCFG2  0xf600
 #define FSTV0910_TSRCFIFO_DVBCI  0xf6000080
 #define FSTV0910_TSRCFIFO_SERIAL  0xf6000040
@@ -3622,21 +3623,21 @@
 #define FSTV0910_TSRCFIFO_HSGNLOUT  0xf6000008
 #define FSTV0910_TSRCFIFO_ERRMODE  0xf6000006
 
-/*RCCFG1*/
+/* RCCFG1 */
 #define RSTV0910_RCCFG1  0xf601
 #define FSTV0910_TSRCFIFO_MANSPEED  0xf60100c0
 #define FSTV0910_TSRCFIFO_PERMDATA  0xf6010020
 #define FSTV0910_TSRCFIFO_NONEWSGNL  0xf6010010
 #define FSTV0910_TSRCFIFO_INVDATA  0xf6010001
 
-/*RCCFG0*/
+/* RCCFG0 */
 #define RSTV0910_RCCFG0  0xf602
 #define FSTV0910_TSRCFIFO_BCLKDEL1CK  0xf60200c0
 #define FSTV0910_TSRCFIFO_DUTY50  0xf6020010
 #define FSTV0910_TSRCFIFO_NSGNL2DATA  0xf6020008
 #define FSTV0910_TSRCFIFO_NPDSGNL  0xf6020004
 
-/*RCINSDEL2*/
+/* RCINSDEL2 */
 #define RSTV0910_RCINSDEL2  0xf603
 #define FSTV0910_TSRCDEL_SYNCBYTE  0xf6030080
 #define FSTV0910_TSRCDEL_XXHEADER  0xf6030040
@@ -3647,7 +3648,7 @@
 #define FSTV0910_TSRCINSDEL_RSPARITY  0xf6030002
 #define FSTV0910_TSRCINSDEL_CRC8  0xf6030001
 
-/*RCINSDEL1*/
+/* RCINSDEL1 */
 #define RSTV0910_RCINSDEL1  0xf604
 #define FSTV0910_TSRCINS_BBPADDING  0xf6040080
 #define FSTV0910_TSRCINS_BCHFEC  0xf6040040
@@ -3657,7 +3658,7 @@
 #define FSTV0910_TSRCINS_MATYPE  0xf6040002
 #define FSTV0910_TSRCINS_UPL  0xf6040001
 
-/*RCINSDEL0*/
+/* RCINSDEL0 */
 #define RSTV0910_RCINSDEL0  0xf605
 #define FSTV0910_TSRCINS_DFL  0xf6050080
 #define FSTV0910_TSRCINS_SYNCD  0xf6050040
@@ -3668,7 +3669,7 @@
 #define FSTV0910_TSRCINS_TSCONFIG  0xf6050002
 #define FSTV0910_TSRCINS_LATENCY  0xf6050001
 
-/*RCSTATUS*/
+/* RCSTATUS */
 #define RSTV0910_RCSTATUS  0xf606
 #define FSTV0910_TSRCFIFO_LINEOK  0xf6060080
 #define FSTV0910_TSRCFIFO_ERROR  0xf6060040
@@ -3677,17 +3678,17 @@
 #define FSTV0910_TSRCFIFOSPEED_STORE  0xf6060004
 #define FSTV0910_TSRCSPEED_IMPOSSIBLE  0xf6060001
 
-/*RCSPEED*/
+/* RCSPEED */
 #define RSTV0910_RCSPEED  0xf607
 #define FSTV0910_TSRCFIFO_OUTSPEED  0xf60700ff
 
-/*TSGENERAL*/
+/* TSGENERAL */
 #define RSTV0910_TSGENERAL  0xf630
 #define FSTV0910_TSFIFO_DISTS2PAR  0xf6300040
 #define FSTV0910_MUXSTREAM_OUTMODE  0xf6300008
 #define FSTV0910_TSFIFO_PERMPARAL  0xf6300006
 
-/*P1_DISIRQCFG*/
+/* P1_DISIRQCFG */
 #define RSTV0910_P1_DISIRQCFG  0xf700
 #define FSTV0910_P1_ENRXEND  0xf7000040
 #define FSTV0910_P1_ENRXFIFO8B  0xf7000020
@@ -3697,7 +3698,7 @@
 #define FSTV0910_P1_ENTXFIFO64B  0xf7000002
 #define FSTV0910_P1_ENGAPBURST  0xf7000001
 
-/*P1_DISIRQSTAT*/
+/* P1_DISIRQSTAT */
 #define RSTV0910_P1_DISIRQSTAT  0xf701
 #define FSTV0910_P1_IRQRXEND  0xf7010040
 #define FSTV0910_P1_IRQRXFIFO8B  0xf7010020
@@ -3707,7 +3708,7 @@
 #define FSTV0910_P1_IRQTXFIFO64B  0xf7010002
 #define FSTV0910_P1_IRQGAPBURST  0xf7010001
 
-/*P1_DISTXCFG*/
+/* P1_DISTXCFG */
 #define RSTV0910_P1_DISTXCFG  0xf702
 #define FSTV0910_P1_DISTX_RESET  0xf7020080
 #define FSTV0910_P1_TIM_OFF  0xf7020040
@@ -3716,7 +3717,7 @@
 #define FSTV0910_P1_DIS_PRECHARGE  0xf7020004
 #define FSTV0910_P1_DISEQC_MODE  0xf7020003
 
-/*P1_DISTXSTATUS*/
+/* P1_DISTXSTATUS */
 #define RSTV0910_P1_DISTXSTATUS  0xf703
 #define FSTV0910_P1_TX_FIFO_FULL  0xf7030040
 #define FSTV0910_P1_TX_IDLE  0xf7030020
@@ -3726,28 +3727,28 @@
 #define FSTV0910_P1_TR_TIMEOUT  0xf7030002
 #define FSTV0910_P1_TR_FINISH  0xf7030001
 
-/*P1_DISTXBYTES*/
+/* P1_DISTXBYTES */
 #define RSTV0910_P1_DISTXBYTES  0xf704
 #define FSTV0910_P1_TXFIFO_BYTES  0xf70400ff
 
-/*P1_DISTXFIFO*/
+/* P1_DISTXFIFO */
 #define RSTV0910_P1_DISTXFIFO  0xf705
 #define FSTV0910_P1_DISEQC_TX_FIFO  0xf70500ff
 
-/*P1_DISTXF22*/
+/* P1_DISTXF22 */
 #define RSTV0910_P1_DISTXF22  0xf706
 #define FSTV0910_P1_F22TX  0xf70600ff
 
-/*P1_DISTIMEOCFG*/
+/* P1_DISTIMEOCFG */
 #define RSTV0910_P1_DISTIMEOCFG  0xf708
 #define FSTV0910_P1_RXCHOICE  0xf7080006
 #define FSTV0910_P1_TIMEOUT_OFF  0xf7080001
 
-/*P1_DISTIMEOUT*/
+/* P1_DISTIMEOUT */
 #define RSTV0910_P1_DISTIMEOUT  0xf709
 #define FSTV0910_P1_TIMEOUT_COUNT  0xf70900ff
 
-/*P1_DISRXCFG*/
+/* P1_DISRXCFG */
 #define RSTV0910_P1_DISRXCFG  0xf70a
 #define FSTV0910_P1_DISRX_RESET  0xf70a0080
 #define FSTV0910_P1_EXTENVELOP  0xf70a0040
@@ -3756,7 +3757,7 @@
 #define FSTV0910_P1_SIGNED_RXIN  0xf70a0002
 #define FSTV0910_P1_DISRX_ON  0xf70a0001
 
-/*P1_DISRXSTAT1*/
+/* P1_DISRXSTAT1 */
 #define RSTV0910_P1_DISRXSTAT1  0xf70b
 #define FSTV0910_P1_RXEND  0xf70b0080
 #define FSTV0910_P1_RXACTIVE  0xf70b0040
@@ -3765,7 +3766,7 @@
 #define FSTV0910_P1_8BFIFOREADY  0xf70b0008
 #define FSTV0910_P1_FIFOEMPTY  0xf70b0004
 
-/*P1_DISRXSTAT0*/
+/* P1_DISRXSTAT0 */
 #define RSTV0910_P1_DISRXSTAT0  0xf70c
 #define FSTV0910_P1_RXFAIL  0xf70c0080
 #define FSTV0910_P1_FIFOPFAIL  0xf70c0040
@@ -3774,55 +3775,55 @@
 #define FSTV0910_P1_SHORT22K  0xf70c0008
 #define FSTV0910_P1_RXMSGLOST  0xf70c0004
 
-/*P1_DISRXBYTES*/
+/* P1_DISRXBYTES */
 #define RSTV0910_P1_DISRXBYTES  0xf70d
 #define FSTV0910_P1_RXFIFO_BYTES  0xf70d001f
 
-/*P1_DISRXPARITY1*/
+/* P1_DISRXPARITY1 */
 #define RSTV0910_P1_DISRXPARITY1  0xf70e
 #define FSTV0910_P1_DISRX_PARITY1  0xf70e00ff
 
-/*P1_DISRXPARITY0*/
+/* P1_DISRXPARITY0 */
 #define RSTV0910_P1_DISRXPARITY0  0xf70f
 #define FSTV0910_P1_DISRX_PARITY0  0xf70f00ff
 
-/*P1_DISRXFIFO*/
+/* P1_DISRXFIFO */
 #define RSTV0910_P1_DISRXFIFO  0xf710
 #define FSTV0910_P1_DISEQC_RX_FIFO  0xf71000ff
 
-/*P1_DISRXDC1*/
+/* P1_DISRXDC1 */
 #define RSTV0910_P1_DISRXDC1  0xf711
 #define FSTV0910_P1_DC_VALUE1  0xf7110103
 
-/*P1_DISRXDC0*/
+/* P1_DISRXDC0 */
 #define RSTV0910_P1_DISRXDC0  0xf712
 #define FSTV0910_P1_DC_VALUE0  0xf71200ff
 
-/*P1_DISRXF221*/
+/* P1_DISRXF221 */
 #define RSTV0910_P1_DISRXF221  0xf714
 #define FSTV0910_P1_F22RX1  0xf714000f
 
-/*P1_DISRXF220*/
+/* P1_DISRXF220 */
 #define RSTV0910_P1_DISRXF220  0xf715
 #define FSTV0910_P1_F22RX0  0xf71500ff
 
-/*P1_DISRXF100*/
+/* P1_DISRXF100 */
 #define RSTV0910_P1_DISRXF100  0xf716
 #define FSTV0910_P1_F100RX  0xf71600ff
 
-/*P1_DISRXSHORT22K*/
+/* P1_DISRXSHORT22K */
 #define RSTV0910_P1_DISRXSHORT22K  0xf71c
 #define FSTV0910_P1_SHORT22K_LENGTH  0xf71c001f
 
-/*P1_ACRPRESC*/
+/* P1_ACRPRESC */
 #define RSTV0910_P1_ACRPRESC  0xf71e
 #define FSTV0910_P1_ACR_PRESC  0xf71e0007
 
-/*P1_ACRDIV*/
+/* P1_ACRDIV */
 #define RSTV0910_P1_ACRDIV  0xf71f
 #define FSTV0910_P1_ACR_DIV  0xf71f00ff
 
-/*P2_DISIRQCFG*/
+/* P2_DISIRQCFG */
 #define RSTV0910_P2_DISIRQCFG  0xf740
 #define FSTV0910_P2_ENRXEND  0xf7400040
 #define FSTV0910_P2_ENRXFIFO8B  0xf7400020
@@ -3832,7 +3833,7 @@
 #define FSTV0910_P2_ENTXFIFO64B  0xf7400002
 #define FSTV0910_P2_ENGAPBURST  0xf7400001
 
-/*P2_DISIRQSTAT*/
+/* P2_DISIRQSTAT */
 #define RSTV0910_P2_DISIRQSTAT  0xf741
 #define FSTV0910_P2_IRQRXEND  0xf7410040
 #define FSTV0910_P2_IRQRXFIFO8B  0xf7410020
@@ -3842,7 +3843,7 @@
 #define FSTV0910_P2_IRQTXFIFO64B  0xf7410002
 #define FSTV0910_P2_IRQGAPBURST  0xf7410001
 
-/*P2_DISTXCFG*/
+/* P2_DISTXCFG */
 #define RSTV0910_P2_DISTXCFG  0xf742
 #define FSTV0910_P2_DISTX_RESET  0xf7420080
 #define FSTV0910_P2_TIM_OFF  0xf7420040
@@ -3851,7 +3852,7 @@
 #define FSTV0910_P2_DIS_PRECHARGE  0xf7420004
 #define FSTV0910_P2_DISEQC_MODE  0xf7420003
 
-/*P2_DISTXSTATUS*/
+/* P2_DISTXSTATUS */
 #define RSTV0910_P2_DISTXSTATUS  0xf743
 #define FSTV0910_P2_TX_FIFO_FULL  0xf7430040
 #define FSTV0910_P2_TX_IDLE  0xf7430020
@@ -3861,28 +3862,28 @@
 #define FSTV0910_P2_TR_TIMEOUT  0xf7430002
 #define FSTV0910_P2_TR_FINISH  0xf7430001
 
-/*P2_DISTXBYTES*/
+/* P2_DISTXBYTES */
 #define RSTV0910_P2_DISTXBYTES  0xf744
 #define FSTV0910_P2_TXFIFO_BYTES  0xf74400ff
 
-/*P2_DISTXFIFO*/
+/* P2_DISTXFIFO */
 #define RSTV0910_P2_DISTXFIFO  0xf745
 #define FSTV0910_P2_DISEQC_TX_FIFO  0xf74500ff
 
-/*P2_DISTXF22*/
+/* P2_DISTXF22 */
 #define RSTV0910_P2_DISTXF22  0xf746
 #define FSTV0910_P2_F22TX  0xf74600ff
 
-/*P2_DISTIMEOCFG*/
+/* P2_DISTIMEOCFG */
 #define RSTV0910_P2_DISTIMEOCFG  0xf748
 #define FSTV0910_P2_RXCHOICE  0xf7480006
 #define FSTV0910_P2_TIMEOUT_OFF  0xf7480001
 
-/*P2_DISTIMEOUT*/
+/* P2_DISTIMEOUT */
 #define RSTV0910_P2_DISTIMEOUT  0xf749
 #define FSTV0910_P2_TIMEOUT_COUNT  0xf74900ff
 
-/*P2_DISRXCFG*/
+/* P2_DISRXCFG */
 #define RSTV0910_P2_DISRXCFG  0xf74a
 #define FSTV0910_P2_DISRX_RESET  0xf74a0080
 #define FSTV0910_P2_EXTENVELOP  0xf74a0040
@@ -3891,7 +3892,7 @@
 #define FSTV0910_P2_SIGNED_RXIN  0xf74a0002
 #define FSTV0910_P2_DISRX_ON  0xf74a0001
 
-/*P2_DISRXSTAT1*/
+/* P2_DISRXSTAT1 */
 #define RSTV0910_P2_DISRXSTAT1  0xf74b
 #define FSTV0910_P2_RXEND  0xf74b0080
 #define FSTV0910_P2_RXACTIVE  0xf74b0040
@@ -3900,7 +3901,7 @@
 #define FSTV0910_P2_8BFIFOREADY  0xf74b0008
 #define FSTV0910_P2_FIFOEMPTY  0xf74b0004
 
-/*P2_DISRXSTAT0*/
+/* P2_DISRXSTAT0 */
 #define RSTV0910_P2_DISRXSTAT0  0xf74c
 #define FSTV0910_P2_RXFAIL  0xf74c0080
 #define FSTV0910_P2_FIFOPFAIL  0xf74c0040
@@ -3909,270 +3910,270 @@
 #define FSTV0910_P2_SHORT22K  0xf74c0008
 #define FSTV0910_P2_RXMSGLOST  0xf74c0004
 
-/*P2_DISRXBYTES*/
+/* P2_DISRXBYTES */
 #define RSTV0910_P2_DISRXBYTES  0xf74d
 #define FSTV0910_P2_RXFIFO_BYTES  0xf74d001f
 
-/*P2_DISRXPARITY1*/
+/* P2_DISRXPARITY1 */
 #define RSTV0910_P2_DISRXPARITY1  0xf74e
 #define FSTV0910_P2_DISRX_PARITY1  0xf74e00ff
 
-/*P2_DISRXPARITY0*/
+/* P2_DISRXPARITY0 */
 #define RSTV0910_P2_DISRXPARITY0  0xf74f
 #define FSTV0910_P2_DISRX_PARITY0  0xf74f00ff
 
-/*P2_DISRXFIFO*/
+/* P2_DISRXFIFO */
 #define RSTV0910_P2_DISRXFIFO  0xf750
 #define FSTV0910_P2_DISEQC_RX_FIFO  0xf75000ff
 
-/*P2_DISRXDC1*/
+/* P2_DISRXDC1 */
 #define RSTV0910_P2_DISRXDC1  0xf751
 #define FSTV0910_P2_DC_VALUE1  0xf7510103
 
-/*P2_DISRXDC0*/
+/* P2_DISRXDC0 */
 #define RSTV0910_P2_DISRXDC0  0xf752
 #define FSTV0910_P2_DC_VALUE0  0xf75200ff
 
-/*P2_DISRXF221*/
+/* P2_DISRXF221 */
 #define RSTV0910_P2_DISRXF221  0xf754
 #define FSTV0910_P2_F22RX1  0xf754000f
 
-/*P2_DISRXF220*/
+/* P2_DISRXF220 */
 #define RSTV0910_P2_DISRXF220  0xf755
 #define FSTV0910_P2_F22RX0  0xf75500ff
 
-/*P2_DISRXF100*/
+/* P2_DISRXF100 */
 #define RSTV0910_P2_DISRXF100  0xf756
 #define FSTV0910_P2_F100RX  0xf75600ff
 
-/*P2_DISRXSHORT22K*/
+/* P2_DISRXSHORT22K */
 #define RSTV0910_P2_DISRXSHORT22K  0xf75c
 #define FSTV0910_P2_SHORT22K_LENGTH  0xf75c001f
 
-/*P2_ACRPRESC*/
+/* P2_ACRPRESC */
 #define RSTV0910_P2_ACRPRESC  0xf75e
 #define FSTV0910_P2_ACR_PRESC  0xf75e0007
 
-/*P2_ACRDIV*/
+/* P2_ACRDIV */
 #define RSTV0910_P2_ACRDIV  0xf75f
 #define FSTV0910_P2_ACR_DIV  0xf75f00ff
 
-/*P1_NBITER_NF1*/
+/* P1_NBITER_NF1 */
 #define RSTV0910_P1_NBITER_NF1  0xfa00
 #define FSTV0910_P1_NBITER_NF_QPSK_1_4  0xfa0000ff
 
-/*P1_NBITER_NF2*/
+/* P1_NBITER_NF2 */
 #define RSTV0910_P1_NBITER_NF2  0xfa01
 #define FSTV0910_P1_NBITER_NF_QPSK_1_3  0xfa0100ff
 
-/*P1_NBITER_NF3*/
+/* P1_NBITER_NF3 */
 #define RSTV0910_P1_NBITER_NF3  0xfa02
 #define FSTV0910_P1_NBITER_NF_QPSK_2_5  0xfa0200ff
 
-/*P1_NBITER_NF4*/
+/* P1_NBITER_NF4 */
 #define RSTV0910_P1_NBITER_NF4  0xfa03
 #define FSTV0910_P1_NBITER_NF_QPSK_1_2  0xfa0300ff
 
-/*P1_NBITER_NF5*/
+/* P1_NBITER_NF5 */
 #define RSTV0910_P1_NBITER_NF5  0xfa04
 #define FSTV0910_P1_NBITER_NF_QPSK_3_5  0xfa0400ff
 
-/*P1_NBITER_NF6*/
+/* P1_NBITER_NF6 */
 #define RSTV0910_P1_NBITER_NF6  0xfa05
 #define FSTV0910_P1_NBITER_NF_QPSK_2_3  0xfa0500ff
 
-/*P1_NBITER_NF7*/
+/* P1_NBITER_NF7 */
 #define RSTV0910_P1_NBITER_NF7  0xfa06
 #define FSTV0910_P1_NBITER_NF_QPSK_3_4  0xfa0600ff
 
-/*P1_NBITER_NF8*/
+/* P1_NBITER_NF8 */
 #define RSTV0910_P1_NBITER_NF8  0xfa07
 #define FSTV0910_P1_NBITER_NF_QPSK_4_5  0xfa0700ff
 
-/*P1_NBITER_NF9*/
+/* P1_NBITER_NF9 */
 #define RSTV0910_P1_NBITER_NF9  0xfa08
 #define FSTV0910_P1_NBITER_NF_QPSK_5_6  0xfa0800ff
 
-/*P1_NBITER_NF10*/
+/* P1_NBITER_NF10 */
 #define RSTV0910_P1_NBITER_NF10  0xfa09
 #define FSTV0910_P1_NBITER_NF_QPSK_8_9  0xfa0900ff
 
-/*P1_NBITER_NF11*/
+/* P1_NBITER_NF11 */
 #define RSTV0910_P1_NBITER_NF11  0xfa0a
 #define FSTV0910_P1_NBITER_NF_QPSK_9_10  0xfa0a00ff
 
-/*P1_NBITER_NF12*/
+/* P1_NBITER_NF12 */
 #define RSTV0910_P1_NBITER_NF12  0xfa0b
 #define FSTV0910_P1_NBITER_NF_8PSK_3_5  0xfa0b00ff
 
-/*P1_NBITER_NF13*/
+/* P1_NBITER_NF13 */
 #define RSTV0910_P1_NBITER_NF13  0xfa0c
 #define FSTV0910_P1_NBITER_NF_8PSK_2_3  0xfa0c00ff
 
-/*P1_NBITER_NF14*/
+/* P1_NBITER_NF14 */
 #define RSTV0910_P1_NBITER_NF14  0xfa0d
 #define FSTV0910_P1_NBITER_NF_8PSK_3_4  0xfa0d00ff
 
-/*P1_NBITER_NF15*/
+/* P1_NBITER_NF15 */
 #define RSTV0910_P1_NBITER_NF15  0xfa0e
 #define FSTV0910_P1_NBITER_NF_8PSK_5_6  0xfa0e00ff
 
-/*P1_NBITER_NF16*/
+/* P1_NBITER_NF16 */
 #define RSTV0910_P1_NBITER_NF16  0xfa0f
 #define FSTV0910_P1_NBITER_NF_8PSK_8_9  0xfa0f00ff
 
-/*P1_NBITER_NF17*/
+/* P1_NBITER_NF17 */
 #define RSTV0910_P1_NBITER_NF17  0xfa10
 #define FSTV0910_P1_NBITER_NF_8PSK_9_10  0xfa1000ff
 
-/*P1_NBITER_NF18*/
+/* P1_NBITER_NF18 */
 #define RSTV0910_P1_NBITER_NF18  0xfa11
 #define FSTV0910_P1_NBITER_NF_16APSK_2_3  0xfa1100ff
 
-/*P1_NBITER_NF19*/
+/* P1_NBITER_NF19 */
 #define RSTV0910_P1_NBITER_NF19  0xfa12
 #define FSTV0910_P1_NBITER_NF_16APSK_3_4  0xfa1200ff
 
-/*P1_NBITER_NF20*/
+/* P1_NBITER_NF20 */
 #define RSTV0910_P1_NBITER_NF20  0xfa13
 #define FSTV0910_P1_NBITER_NF_16APSK_4_5  0xfa1300ff
 
-/*P1_NBITER_NF21*/
+/* P1_NBITER_NF21 */
 #define RSTV0910_P1_NBITER_NF21  0xfa14
 #define FSTV0910_P1_NBITER_NF_16APSK_5_6  0xfa1400ff
 
-/*P1_NBITER_NF22*/
+/* P1_NBITER_NF22 */
 #define RSTV0910_P1_NBITER_NF22  0xfa15
 #define FSTV0910_P1_NBITER_NF_16APSK_8_9  0xfa1500ff
 
-/*P1_NBITER_NF23*/
+/* P1_NBITER_NF23 */
 #define RSTV0910_P1_NBITER_NF23  0xfa16
 #define FSTV0910_P1_NBITER_NF_16APSK_9_10  0xfa1600ff
 
-/*P1_NBITER_NF24*/
+/* P1_NBITER_NF24 */
 #define RSTV0910_P1_NBITER_NF24  0xfa17
 #define FSTV0910_P1_NBITER_NF_32APSK_3_4  0xfa1700ff
 
-/*P1_NBITER_NF25*/
+/* P1_NBITER_NF25 */
 #define RSTV0910_P1_NBITER_NF25  0xfa18
 #define FSTV0910_P1_NBITER_NF_32APSK_4_5  0xfa1800ff
 
-/*P1_NBITER_NF26*/
+/* P1_NBITER_NF26 */
 #define RSTV0910_P1_NBITER_NF26  0xfa19
 #define FSTV0910_P1_NBITER_NF_32APSK_5_6  0xfa1900ff
 
-/*P1_NBITER_NF27*/
+/* P1_NBITER_NF27 */
 #define RSTV0910_P1_NBITER_NF27  0xfa1a
 #define FSTV0910_P1_NBITER_NF_32APSK_8_9  0xfa1a00ff
 
-/*P1_NBITER_NF28*/
+/* P1_NBITER_NF28 */
 #define RSTV0910_P1_NBITER_NF28  0xfa1b
 #define FSTV0910_P1_NBITER_NF_32APSK_9_10  0xfa1b00ff
 
-/*P1_NBITER_SF1*/
+/* P1_NBITER_SF1 */
 #define RSTV0910_P1_NBITER_SF1  0xfa1c
 #define FSTV0910_P1_NBITER_SF_QPSK_1_4  0xfa1c00ff
 
-/*P1_NBITER_SF2*/
+/* P1_NBITER_SF2 */
 #define RSTV0910_P1_NBITER_SF2  0xfa1d
 #define FSTV0910_P1_NBITER_SF_QPSK_1_3  0xfa1d00ff
 
-/*P1_NBITER_SF3*/
+/* P1_NBITER_SF3 */
 #define RSTV0910_P1_NBITER_SF3  0xfa1e
 #define FSTV0910_P1_NBITER_SF_QPSK_2_5  0xfa1e00ff
 
-/*P1_NBITER_SF4*/
+/* P1_NBITER_SF4 */
 #define RSTV0910_P1_NBITER_SF4  0xfa1f
 #define FSTV0910_P1_NBITER_SF_QPSK_1_2  0xfa1f00ff
 
-/*P1_NBITER_SF5*/
+/* P1_NBITER_SF5 */
 #define RSTV0910_P1_NBITER_SF5  0xfa20
 #define FSTV0910_P1_NBITER_SF_QPSK_3_5  0xfa2000ff
 
-/*P1_NBITER_SF6*/
+/* P1_NBITER_SF6 */
 #define RSTV0910_P1_NBITER_SF6  0xfa21
 #define FSTV0910_P1_NBITER_SF_QPSK_2_3  0xfa2100ff
 
-/*P1_NBITER_SF7*/
+/* P1_NBITER_SF7 */
 #define RSTV0910_P1_NBITER_SF7  0xfa22
 #define FSTV0910_P1_NBITER_SF_QPSK_3_4  0xfa2200ff
 
-/*P1_NBITER_SF8*/
+/* P1_NBITER_SF8 */
 #define RSTV0910_P1_NBITER_SF8  0xfa23
 #define FSTV0910_P1_NBITER_SF_QPSK_4_5  0xfa2300ff
 
-/*P1_NBITER_SF9*/
+/* P1_NBITER_SF9 */
 #define RSTV0910_P1_NBITER_SF9  0xfa24
 #define FSTV0910_P1_NBITER_SF_QPSK_5_6  0xfa2400ff
 
-/*P1_NBITER_SF10*/
+/* P1_NBITER_SF10 */
 #define RSTV0910_P1_NBITER_SF10  0xfa25
 #define FSTV0910_P1_NBITER_SF_QPSK_8_9  0xfa2500ff
 
-/*P1_NBITER_SF12*/
+/* P1_NBITER_SF12 */
 #define RSTV0910_P1_NBITER_SF12  0xfa26
 #define FSTV0910_P1_NBITER_SF_8PSK_3_5  0xfa2600ff
 
-/*P1_NBITER_SF13*/
+/* P1_NBITER_SF13 */
 #define RSTV0910_P1_NBITER_SF13  0xfa27
 #define FSTV0910_P1_NBITER_SF_8PSK_2_3  0xfa2700ff
 
-/*P1_NBITER_SF14*/
+/* P1_NBITER_SF14 */
 #define RSTV0910_P1_NBITER_SF14  0xfa28
 #define FSTV0910_P1_NBITER_SF_8PSK_3_4  0xfa2800ff
 
-/*P1_NBITER_SF15*/
+/* P1_NBITER_SF15 */
 #define RSTV0910_P1_NBITER_SF15  0xfa29
 #define FSTV0910_P1_NBITER_SF_8PSK_5_6  0xfa2900ff
 
-/*P1_NBITER_SF16*/
+/* P1_NBITER_SF16 */
 #define RSTV0910_P1_NBITER_SF16  0xfa2a
 #define FSTV0910_P1_NBITER_SF_8PSK_8_9  0xfa2a00ff
 
-/*P1_NBITER_SF18*/
+/* P1_NBITER_SF18 */
 #define RSTV0910_P1_NBITER_SF18  0xfa2b
 #define FSTV0910_P1_NBITER_SF_16APSK_2_3  0xfa2b00ff
 
-/*P1_NBITER_SF19*/
+/* P1_NBITER_SF19 */
 #define RSTV0910_P1_NBITER_SF19  0xfa2c
 #define FSTV0910_P1_NBITER_SF_16APSK_3_4  0xfa2c00ff
 
-/*P1_NBITER_SF20*/
+/* P1_NBITER_SF20 */
 #define RSTV0910_P1_NBITER_SF20  0xfa2d
 #define FSTV0910_P1_NBITER_SF_16APSK_4_5  0xfa2d00ff
 
-/*P1_NBITER_SF21*/
+/* P1_NBITER_SF21 */
 #define RSTV0910_P1_NBITER_SF21  0xfa2e
 #define FSTV0910_P1_NBITER_SF_16APSK_5_6  0xfa2e00ff
 
-/*P1_NBITER_SF22*/
+/* P1_NBITER_SF22 */
 #define RSTV0910_P1_NBITER_SF22  0xfa2f
 #define FSTV0910_P1_NBITER_SF_16APSK_8_9  0xfa2f00ff
 
-/*P1_NBITER_SF24*/
+/* P1_NBITER_SF24 */
 #define RSTV0910_P1_NBITER_SF24  0xfa30
 #define FSTV0910_P1_NBITER_SF_32APSK_3_4  0xfa3000ff
 
-/*P1_NBITER_SF25*/
+/* P1_NBITER_SF25 */
 #define RSTV0910_P1_NBITER_SF25  0xfa31
 #define FSTV0910_P1_NBITER_SF_32APSK_4_5  0xfa3100ff
 
-/*P1_NBITER_SF26*/
+/* P1_NBITER_SF26 */
 #define RSTV0910_P1_NBITER_SF26  0xfa32
 #define FSTV0910_P1_NBITER_SF_32APSK_5_6  0xfa3200ff
 
-/*P1_NBITER_SF27*/
+/* P1_NBITER_SF27 */
 #define RSTV0910_P1_NBITER_SF27  0xfa33
 #define FSTV0910_P1_NBITER_SF_32APSK_8_9  0xfa3300ff
 
-/*SELSATUR6*/
+/* SELSATUR6 */
 #define RSTV0910_SELSATUR6  0xfa34
 #define FSTV0910_SSAT_SF27  0xfa340008
 #define FSTV0910_SSAT_SF26  0xfa340004
 #define FSTV0910_SSAT_SF25  0xfa340002
 #define FSTV0910_SSAT_SF24  0xfa340001
 
-/*SELSATUR5*/
+/* SELSATUR5 */
 #define RSTV0910_SELSATUR5  0xfa35
 #define FSTV0910_SSAT_SF22  0xfa350080
 #define FSTV0910_SSAT_SF21  0xfa350040
@@ -4183,7 +4184,7 @@
 #define FSTV0910_SSAT_SF15  0xfa350002
 #define FSTV0910_SSAT_SF14  0xfa350001
 
-/*SELSATUR4*/
+/* SELSATUR4 */
 #define RSTV0910_SELSATUR4  0xfa36
 #define FSTV0910_SSAT_SF13  0xfa360080
 #define FSTV0910_SSAT_SF12  0xfa360040
@@ -4194,7 +4195,7 @@
 #define FSTV0910_SSAT_SF6  0xfa360002
 #define FSTV0910_SSAT_SF5  0xfa360001
 
-/*SELSATUR3*/
+/* SELSATUR3 */
 #define RSTV0910_SELSATUR3  0xfa37
 #define FSTV0910_SSAT_SF4  0xfa370080
 #define FSTV0910_SSAT_SF3  0xfa370040
@@ -4205,7 +4206,7 @@
 #define FSTV0910_SSAT_NF26  0xfa370002
 #define FSTV0910_SSAT_NF25  0xfa370001
 
-/*SELSATUR2*/
+/* SELSATUR2 */
 #define RSTV0910_SELSATUR2  0xfa38
 #define FSTV0910_SSAT_NF24  0xfa380080
 #define FSTV0910_SSAT_NF23  0xfa380040
@@ -4216,7 +4217,7 @@
 #define FSTV0910_SSAT_NF18  0xfa380002
 #define FSTV0910_SSAT_NF17  0xfa380001
 
-/*SELSATUR1*/
+/* SELSATUR1 */
 #define RSTV0910_SELSATUR1  0xfa39
 #define FSTV0910_SSAT_NF16  0xfa390080
 #define FSTV0910_SSAT_NF15  0xfa390040
@@ -4227,7 +4228,7 @@
 #define FSTV0910_SSAT_NF10  0xfa390002
 #define FSTV0910_SSAT_NF9  0xfa390001
 
-/*SELSATUR0*/
+/* SELSATUR0 */
 #define RSTV0910_SELSATUR0  0xfa3a
 #define FSTV0910_SSAT_NF8  0xfa3a0080
 #define FSTV0910_SSAT_NF7  0xfa3a0040
@@ -4238,519 +4239,519 @@
 #define FSTV0910_SSAT_NF2  0xfa3a0002
 #define FSTV0910_SSAT_NF1  0xfa3a0001
 
-/*GAINLLR_NF1*/
+/* GAINLLR_NF1 */
 #define RSTV0910_GAINLLR_NF1  0xfa40
 #define FSTV0910_GAINLLR_NF_QPSK_1_4  0xfa40007f
 
-/*GAINLLR_NF2*/
+/* GAINLLR_NF2 */
 #define RSTV0910_GAINLLR_NF2  0xfa41
 #define FSTV0910_GAINLLR_NF_QPSK_1_3  0xfa41007f
 
-/*GAINLLR_NF3*/
+/* GAINLLR_NF3 */
 #define RSTV0910_GAINLLR_NF3  0xfa42
 #define FSTV0910_GAINLLR_NF_QPSK_2_5  0xfa42007f
 
-/*GAINLLR_NF4*/
+/* GAINLLR_NF4 */
 #define RSTV0910_GAINLLR_NF4  0xfa43
 #define FSTV0910_GAINLLR_NF_QPSK_1_2  0xfa43007f
 
-/*GAINLLR_NF5*/
+/* GAINLLR_NF5 */
 #define RSTV0910_GAINLLR_NF5  0xfa44
 #define FSTV0910_GAINLLR_NF_QPSK_3_5  0xfa44007f
 
-/*GAINLLR_NF6*/
+/* GAINLLR_NF6 */
 #define RSTV0910_GAINLLR_NF6  0xfa45
 #define FSTV0910_GAINLLR_NF_QPSK_2_3  0xfa45007f
 
-/*GAINLLR_NF7*/
+/* GAINLLR_NF7 */
 #define RSTV0910_GAINLLR_NF7  0xfa46
 #define FSTV0910_GAINLLR_NF_QPSK_3_4  0xfa46007f
 
-/*GAINLLR_NF8*/
+/* GAINLLR_NF8 */
 #define RSTV0910_GAINLLR_NF8  0xfa47
 #define FSTV0910_GAINLLR_NF_QPSK_4_5  0xfa47007f
 
-/*GAINLLR_NF9*/
+/* GAINLLR_NF9 */
 #define RSTV0910_GAINLLR_NF9  0xfa48
 #define FSTV0910_GAINLLR_NF_QPSK_5_6  0xfa48007f
 
-/*GAINLLR_NF10*/
+/* GAINLLR_NF10 */
 #define RSTV0910_GAINLLR_NF10  0xfa49
 #define FSTV0910_GAINLLR_NF_QPSK_8_9  0xfa49007f
 
-/*GAINLLR_NF11*/
+/* GAINLLR_NF11 */
 #define RSTV0910_GAINLLR_NF11  0xfa4a
 #define FSTV0910_GAINLLR_NF_QPSK_9_10  0xfa4a007f
 
-/*GAINLLR_NF12*/
+/* GAINLLR_NF12 */
 #define RSTV0910_GAINLLR_NF12  0xfa4b
 #define FSTV0910_GAINLLR_NF_8PSK_3_5  0xfa4b007f
 
-/*GAINLLR_NF13*/
+/* GAINLLR_NF13 */
 #define RSTV0910_GAINLLR_NF13  0xfa4c
 #define FSTV0910_GAINLLR_NF_8PSK_2_3  0xfa4c007f
 
-/*GAINLLR_NF14*/
+/* GAINLLR_NF14 */
 #define RSTV0910_GAINLLR_NF14  0xfa4d
 #define FSTV0910_GAINLLR_NF_8PSK_3_4  0xfa4d007f
 
-/*GAINLLR_NF15*/
+/* GAINLLR_NF15 */
 #define RSTV0910_GAINLLR_NF15  0xfa4e
 #define FSTV0910_GAINLLR_NF_8PSK_5_6  0xfa4e007f
 
-/*GAINLLR_NF16*/
+/* GAINLLR_NF16 */
 #define RSTV0910_GAINLLR_NF16  0xfa4f
 #define FSTV0910_GAINLLR_NF_8PSK_8_9  0xfa4f007f
 
-/*GAINLLR_NF17*/
+/* GAINLLR_NF17 */
 #define RSTV0910_GAINLLR_NF17  0xfa50
 #define FSTV0910_GAINLLR_NF_8PSK_9_10  0xfa50007f
 
-/*GAINLLR_NF18*/
+/* GAINLLR_NF18 */
 #define RSTV0910_GAINLLR_NF18  0xfa51
 #define FSTV0910_GAINLLR_NF_16APSK_2_3  0xfa51007f
 
-/*GAINLLR_NF19*/
+/* GAINLLR_NF19 */
 #define RSTV0910_GAINLLR_NF19  0xfa52
 #define FSTV0910_GAINLLR_NF_16APSK_3_4  0xfa52007f
 
-/*GAINLLR_NF20*/
+/* GAINLLR_NF20 */
 #define RSTV0910_GAINLLR_NF20  0xfa53
 #define FSTV0910_GAINLLR_NF_16APSK_4_5  0xfa53007f
 
-/*GAINLLR_NF21*/
+/* GAINLLR_NF21 */
 #define RSTV0910_GAINLLR_NF21  0xfa54
 #define FSTV0910_GAINLLR_NF_16APSK_5_6  0xfa54007f
 
-/*GAINLLR_NF22*/
+/* GAINLLR_NF22 */
 #define RSTV0910_GAINLLR_NF22  0xfa55
 #define FSTV0910_GAINLLR_NF_16APSK_8_9  0xfa55007f
 
-/*GAINLLR_NF23*/
+/* GAINLLR_NF23 */
 #define RSTV0910_GAINLLR_NF23  0xfa56
 #define FSTV0910_GAINLLR_NF_16APSK_9_10  0xfa56007f
 
-/*GAINLLR_NF24*/
+/* GAINLLR_NF24 */
 #define RSTV0910_GAINLLR_NF24  0xfa57
 #define FSTV0910_GAINLLR_NF_32APSK_3_4  0xfa57007f
 
-/*GAINLLR_NF25*/
+/* GAINLLR_NF25 */
 #define RSTV0910_GAINLLR_NF25  0xfa58
 #define FSTV0910_GAINLLR_NF_32APSK_4_5  0xfa58007f
 
-/*GAINLLR_NF26*/
+/* GAINLLR_NF26 */
 #define RSTV0910_GAINLLR_NF26  0xfa59
 #define FSTV0910_GAINLLR_NF_32APSK_5_6  0xfa59007f
 
-/*GAINLLR_NF27*/
+/* GAINLLR_NF27 */
 #define RSTV0910_GAINLLR_NF27  0xfa5a
 #define FSTV0910_GAINLLR_NF_32APSK_8_9  0xfa5a007f
 
-/*GAINLLR_NF28*/
+/* GAINLLR_NF28 */
 #define RSTV0910_GAINLLR_NF28  0xfa5b
 #define FSTV0910_GAINLLR_NF_32APSK_9_10  0xfa5b007f
 
-/*GAINLLR_SF1*/
+/* GAINLLR_SF1 */
 #define RSTV0910_GAINLLR_SF1  0xfa5c
 #define FSTV0910_GAINLLR_SF_QPSK_1_4  0xfa5c007f
 
-/*GAINLLR_SF2*/
+/* GAINLLR_SF2 */
 #define RSTV0910_GAINLLR_SF2  0xfa5d
 #define FSTV0910_GAINLLR_SF_QPSK_1_3  0xfa5d007f
 
-/*GAINLLR_SF3*/
+/* GAINLLR_SF3 */
 #define RSTV0910_GAINLLR_SF3  0xfa5e
 #define FSTV0910_GAINLLR_SF_QPSK_2_5  0xfa5e007f
 
-/*GAINLLR_SF4*/
+/* GAINLLR_SF4 */
 #define RSTV0910_GAINLLR_SF4  0xfa5f
 #define FSTV0910_GAINLLR_SF_QPSK_1_2  0xfa5f007f
 
-/*GAINLLR_SF5*/
+/* GAINLLR_SF5 */
 #define RSTV0910_GAINLLR_SF5  0xfa60
 #define FSTV0910_GAINLLR_SF_QPSK_3_5  0xfa60007f
 
-/*GAINLLR_SF6*/
+/* GAINLLR_SF6 */
 #define RSTV0910_GAINLLR_SF6  0xfa61
 #define FSTV0910_GAINLLR_SF_QPSK_2_3  0xfa61007f
 
-/*GAINLLR_SF7*/
+/* GAINLLR_SF7 */
 #define RSTV0910_GAINLLR_SF7  0xfa62
 #define FSTV0910_GAINLLR_SF_QPSK_3_4  0xfa62007f
 
-/*GAINLLR_SF8*/
+/* GAINLLR_SF8 */
 #define RSTV0910_GAINLLR_SF8  0xfa63
 #define FSTV0910_GAINLLR_SF_QPSK_4_5  0xfa63007f
 
-/*GAINLLR_SF9*/
+/* GAINLLR_SF9 */
 #define RSTV0910_GAINLLR_SF9  0xfa64
 #define FSTV0910_GAINLLR_SF_QPSK_5_6  0xfa64007f
 
-/*GAINLLR_SF10*/
+/* GAINLLR_SF10 */
 #define RSTV0910_GAINLLR_SF10  0xfa65
 #define FSTV0910_GAINLLR_SF_QPSK_8_9  0xfa65007f
 
-/*GAINLLR_SF12*/
+/* GAINLLR_SF12 */
 #define RSTV0910_GAINLLR_SF12  0xfa66
 #define FSTV0910_GAINLLR_SF_8PSK_3_5  0xfa66007f
 
-/*GAINLLR_SF13*/
+/* GAINLLR_SF13 */
 #define RSTV0910_GAINLLR_SF13  0xfa67
 #define FSTV0910_GAINLLR_SF_8PSK_2_3  0xfa67007f
 
-/*GAINLLR_SF14*/
+/* GAINLLR_SF14 */
 #define RSTV0910_GAINLLR_SF14  0xfa68
 #define FSTV0910_GAINLLR_SF_8PSK_3_4  0xfa68007f
 
-/*GAINLLR_SF15*/
+/* GAINLLR_SF15 */
 #define RSTV0910_GAINLLR_SF15  0xfa69
 #define FSTV0910_GAINLLR_SF_8PSK_5_6  0xfa69007f
 
-/*GAINLLR_SF16*/
+/* GAINLLR_SF16 */
 #define RSTV0910_GAINLLR_SF16  0xfa6a
 #define FSTV0910_GAINLLR_SF_8PSK_8_9  0xfa6a007f
 
-/*GAINLLR_SF18*/
+/* GAINLLR_SF18 */
 #define RSTV0910_GAINLLR_SF18  0xfa6b
 #define FSTV0910_GAINLLR_SF_16APSK_2_3  0xfa6b007f
 
-/*GAINLLR_SF19*/
+/* GAINLLR_SF19 */
 #define RSTV0910_GAINLLR_SF19  0xfa6c
 #define FSTV0910_GAINLLR_SF_16APSK_3_4  0xfa6c007f
 
-/*GAINLLR_SF20*/
+/* GAINLLR_SF20 */
 #define RSTV0910_GAINLLR_SF20  0xfa6d
 #define FSTV0910_GAINLLR_SF_16APSK_4_5  0xfa6d007f
 
-/*GAINLLR_SF21*/
+/* GAINLLR_SF21 */
 #define RSTV0910_GAINLLR_SF21  0xfa6e
 #define FSTV0910_GAINLLR_SF_16APSK_5_6  0xfa6e007f
 
-/*GAINLLR_SF22*/
+/* GAINLLR_SF22 */
 #define RSTV0910_GAINLLR_SF22  0xfa6f
 #define FSTV0910_GAINLLR_SF_16APSK_8_9  0xfa6f007f
 
-/*GAINLLR_SF24*/
+/* GAINLLR_SF24 */
 #define RSTV0910_GAINLLR_SF24  0xfa70
 #define FSTV0910_GAINLLR_SF_32APSK_3_4  0xfa70007f
 
-/*GAINLLR_SF25*/
+/* GAINLLR_SF25 */
 #define RSTV0910_GAINLLR_SF25  0xfa71
 #define FSTV0910_GAINLLR_SF_32APSK_4_5  0xfa71007f
 
-/*GAINLLR_SF26*/
+/* GAINLLR_SF26 */
 #define RSTV0910_GAINLLR_SF26  0xfa72
 #define FSTV0910_GAINLLR_SF_32APSK_5_6  0xfa72007f
 
-/*GAINLLR_SF27*/
+/* GAINLLR_SF27 */
 #define RSTV0910_GAINLLR_SF27  0xfa73
 #define FSTV0910_GAINLLR_SF_32APSK_8_9  0xfa73007f
 
-/*CFGEXT*/
+/* CFGEXT */
 #define RSTV0910_CFGEXT  0xfa80
 #define FSTV0910_BYPBCH  0xfa800040
 #define FSTV0910_BYPLDPC  0xfa800020
 #define FSTV0910_SHORTMULT  0xfa800004
 
-/*GENCFG*/
+/* GENCFG */
 #define RSTV0910_GENCFG  0xfa86
 #define FSTV0910_BROADCAST  0xfa860010
 #define FSTV0910_CROSSINPUT  0xfa860002
 #define FSTV0910_DDEMOD  0xfa860001
 
-/*LDPCERR1*/
+/* LDPCERR1 */
 #define RSTV0910_LDPCERR1  0xfa96
 #define FSTV0910_LDPC_ERRORS1  0xfa9600ff
 
-/*LDPCERR0*/
+/* LDPCERR0 */
 #define RSTV0910_LDPCERR0  0xfa97
 #define FSTV0910_LDPC_ERRORS0  0xfa9700ff
 
-/*BCHERR*/
+/* BCHERR */
 #define RSTV0910_BCHERR  0xfa98
 #define FSTV0910_ERRORFLAG  0xfa980010
 #define FSTV0910_BCH_ERRORS_COUNTER  0xfa98000f
 
-/*P1_MAXEXTRAITER*/
+/* P1_MAXEXTRAITER */
 #define RSTV0910_P1_MAXEXTRAITER  0xfab1
 #define FSTV0910_P1_MAX_EXTRA_ITER  0xfab100ff
 
-/*P2_MAXEXTRAITER*/
+/* P2_MAXEXTRAITER */
 #define RSTV0910_P2_MAXEXTRAITER  0xfab6
 #define FSTV0910_P2_MAX_EXTRA_ITER  0xfab600ff
 
-/*P1_STATUSITER*/
+/* P1_STATUSITER */
 #define RSTV0910_P1_STATUSITER  0xfabc
 #define FSTV0910_P1_STATUS_ITER  0xfabc00ff
 
-/*P1_STATUSMAXITER*/
+/* P1_STATUSMAXITER */
 #define RSTV0910_P1_STATUSMAXITER  0xfabd
 #define FSTV0910_P1_STATUS_MAX_ITER  0xfabd00ff
 
-/*P2_STATUSITER*/
+/* P2_STATUSITER */
 #define RSTV0910_P2_STATUSITER  0xfabe
 #define FSTV0910_P2_STATUS_ITER  0xfabe00ff
 
-/*P2_STATUSMAXITER*/
+/* P2_STATUSMAXITER */
 #define RSTV0910_P2_STATUSMAXITER  0xfabf
 #define FSTV0910_P2_STATUS_MAX_ITER  0xfabf00ff
 
-/*P2_NBITER_NF1*/
+/* P2_NBITER_NF1 */
 #define RSTV0910_P2_NBITER_NF1  0xfac0
 #define FSTV0910_P2_NBITER_NF_QPSK_1_4  0xfac000ff
 
-/*P2_NBITER_NF2*/
+/* P2_NBITER_NF2 */
 #define RSTV0910_P2_NBITER_NF2  0xfac1
 #define FSTV0910_P2_NBITER_NF_QPSK_1_3  0xfac100ff
 
-/*P2_NBITER_NF3*/
+/* P2_NBITER_NF3 */
 #define RSTV0910_P2_NBITER_NF3  0xfac2
 #define FSTV0910_P2_NBITER_NF_QPSK_2_5  0xfac200ff
 
-/*P2_NBITER_NF4*/
+/* P2_NBITER_NF4 */
 #define RSTV0910_P2_NBITER_NF4  0xfac3
 #define FSTV0910_P2_NBITER_NF_QPSK_1_2  0xfac300ff
 
-/*P2_NBITER_NF5*/
+/* P2_NBITER_NF5 */
 #define RSTV0910_P2_NBITER_NF5  0xfac4
 #define FSTV0910_P2_NBITER_NF_QPSK_3_5  0xfac400ff
 
-/*P2_NBITER_NF6*/
+/* P2_NBITER_NF6 */
 #define RSTV0910_P2_NBITER_NF6  0xfac5
 #define FSTV0910_P2_NBITER_NF_QPSK_2_3  0xfac500ff
 
-/*P2_NBITER_NF7*/
+/* P2_NBITER_NF7 */
 #define RSTV0910_P2_NBITER_NF7  0xfac6
 #define FSTV0910_P2_NBITER_NF_QPSK_3_4  0xfac600ff
 
-/*P2_NBITER_NF8*/
+/* P2_NBITER_NF8 */
 #define RSTV0910_P2_NBITER_NF8  0xfac7
 #define FSTV0910_P2_NBITER_NF_QPSK_4_5  0xfac700ff
 
-/*P2_NBITER_NF9*/
+/* P2_NBITER_NF9 */
 #define RSTV0910_P2_NBITER_NF9  0xfac8
 #define FSTV0910_P2_NBITER_NF_QPSK_5_6  0xfac800ff
 
-/*P2_NBITER_NF10*/
+/* P2_NBITER_NF10 */
 #define RSTV0910_P2_NBITER_NF10  0xfac9
 #define FSTV0910_P2_NBITER_NF_QPSK_8_9  0xfac900ff
 
-/*P2_NBITER_NF11*/
+/* P2_NBITER_NF11 */
 #define RSTV0910_P2_NBITER_NF11  0xfaca
 #define FSTV0910_P2_NBITER_NF_QPSK_9_10  0xfaca00ff
 
-/*P2_NBITER_NF12*/
+/* P2_NBITER_NF12 */
 #define RSTV0910_P2_NBITER_NF12  0xfacb
 #define FSTV0910_P2_NBITER_NF_8PSK_3_5  0xfacb00ff
 
-/*P2_NBITER_NF13*/
+/* P2_NBITER_NF13 */
 #define RSTV0910_P2_NBITER_NF13  0xfacc
 #define FSTV0910_P2_NBITER_NF_8PSK_2_3  0xfacc00ff
 
-/*P2_NBITER_NF14*/
+/* P2_NBITER_NF14 */
 #define RSTV0910_P2_NBITER_NF14  0xfacd
 #define FSTV0910_P2_NBITER_NF_8PSK_3_4  0xfacd00ff
 
-/*P2_NBITER_NF15*/
+/* P2_NBITER_NF15 */
 #define RSTV0910_P2_NBITER_NF15  0xface
 #define FSTV0910_P2_NBITER_NF_8PSK_5_6  0xface00ff
 
-/*P2_NBITER_NF16*/
+/* P2_NBITER_NF16 */
 #define RSTV0910_P2_NBITER_NF16  0xfacf
 #define FSTV0910_P2_NBITER_NF_8PSK_8_9  0xfacf00ff
 
-/*P2_NBITER_NF17*/
+/* P2_NBITER_NF17 */
 #define RSTV0910_P2_NBITER_NF17  0xfad0
 #define FSTV0910_P2_NBITER_NF_8PSK_9_10  0xfad000ff
 
-/*P2_NBITER_NF18*/
+/* P2_NBITER_NF18 */
 #define RSTV0910_P2_NBITER_NF18  0xfad1
 #define FSTV0910_P2_NBITER_NF_16APSK_2_3  0xfad100ff
 
-/*P2_NBITER_NF19*/
+/* P2_NBITER_NF19 */
 #define RSTV0910_P2_NBITER_NF19  0xfad2
 #define FSTV0910_P2_NBITER_NF_16APSK_3_4  0xfad200ff
 
-/*P2_NBITER_NF20*/
+/* P2_NBITER_NF20 */
 #define RSTV0910_P2_NBITER_NF20  0xfad3
 #define FSTV0910_P2_NBITER_NF_16APSK_4_5  0xfad300ff
 
-/*P2_NBITER_NF21*/
+/* P2_NBITER_NF21 */
 #define RSTV0910_P2_NBITER_NF21  0xfad4
 #define FSTV0910_P2_NBITER_NF_16APSK_5_6  0xfad400ff
 
-/*P2_NBITER_NF22*/
+/* P2_NBITER_NF22 */
 #define RSTV0910_P2_NBITER_NF22  0xfad5
 #define FSTV0910_P2_NBITER_NF_16APSK_8_9  0xfad500ff
 
-/*P2_NBITER_NF23*/
+/* P2_NBITER_NF23 */
 #define RSTV0910_P2_NBITER_NF23  0xfad6
 #define FSTV0910_P2_NBITER_NF_16APSK_9_10  0xfad600ff
 
-/*P2_NBITER_NF24*/
+/* P2_NBITER_NF24 */
 #define RSTV0910_P2_NBITER_NF24  0xfad7
 #define FSTV0910_P2_NBITER_NF_32APSK_3_4  0xfad700ff
 
-/*P2_NBITER_NF25*/
+/* P2_NBITER_NF25 */
 #define RSTV0910_P2_NBITER_NF25  0xfad8
 #define FSTV0910_P2_NBITER_NF_32APSK_4_5  0xfad800ff
 
-/*P2_NBITER_NF26*/
+/* P2_NBITER_NF26 */
 #define RSTV0910_P2_NBITER_NF26  0xfad9
 #define FSTV0910_P2_NBITER_NF_32APSK_5_6  0xfad900ff
 
-/*P2_NBITER_NF27*/
+/* P2_NBITER_NF27 */
 #define RSTV0910_P2_NBITER_NF27  0xfada
 #define FSTV0910_P2_NBITER_NF_32APSK_8_9  0xfada00ff
 
-/*P2_NBITER_NF28*/
+/* P2_NBITER_NF28 */
 #define RSTV0910_P2_NBITER_NF28  0xfadb
 #define FSTV0910_P2_NBITER_NF_32APSK_9_10  0xfadb00ff
 
-/*P2_NBITER_SF1*/
+/* P2_NBITER_SF1 */
 #define RSTV0910_P2_NBITER_SF1  0xfadc
 #define FSTV0910_P2_NBITER_SF_QPSK_1_4  0xfadc00ff
 
-/*P2_NBITER_SF2*/
+/* P2_NBITER_SF2 */
 #define RSTV0910_P2_NBITER_SF2  0xfadd
 #define FSTV0910_P2_NBITER_SF_QPSK_1_3  0xfadd00ff
 
-/*P2_NBITER_SF3*/
+/* P2_NBITER_SF3 */
 #define RSTV0910_P2_NBITER_SF3  0xfade
 #define FSTV0910_P2_NBITER_SF_QPSK_2_5  0xfade00ff
 
-/*P2_NBITER_SF4*/
+/* P2_NBITER_SF4 */
 #define RSTV0910_P2_NBITER_SF4  0xfadf
 #define FSTV0910_P2_NBITER_SF_QPSK_1_2  0xfadf00ff
 
-/*P2_NBITER_SF5*/
+/* P2_NBITER_SF5 */
 #define RSTV0910_P2_NBITER_SF5  0xfae0
 #define FSTV0910_P2_NBITER_SF_QPSK_3_5  0xfae000ff
 
-/*P2_NBITER_SF6*/
+/* P2_NBITER_SF6 */
 #define RSTV0910_P2_NBITER_SF6  0xfae1
 #define FSTV0910_P2_NBITER_SF_QPSK_2_3  0xfae100ff
 
-/*P2_NBITER_SF7*/
+/* P2_NBITER_SF7 */
 #define RSTV0910_P2_NBITER_SF7  0xfae2
 #define FSTV0910_P2_NBITER_SF_QPSK_3_4  0xfae200ff
 
-/*P2_NBITER_SF8*/
+/* P2_NBITER_SF8 */
 #define RSTV0910_P2_NBITER_SF8  0xfae3
 #define FSTV0910_P2_NBITER_SF_QPSK_4_5  0xfae300ff
 
-/*P2_NBITER_SF9*/
+/* P2_NBITER_SF9 */
 #define RSTV0910_P2_NBITER_SF9  0xfae4
 #define FSTV0910_P2_NBITER_SF_QPSK_5_6  0xfae400ff
 
-/*P2_NBITER_SF10*/
+/* P2_NBITER_SF10 */
 #define RSTV0910_P2_NBITER_SF10  0xfae5
 #define FSTV0910_P2_NBITER_SF_QPSK_8_9  0xfae500ff
 
-/*P2_NBITER_SF12*/
+/* P2_NBITER_SF12 */
 #define RSTV0910_P2_NBITER_SF12  0xfae6
 #define FSTV0910_P2_NBITER_SF_8PSK_3_5  0xfae600ff
 
-/*P2_NBITER_SF13*/
+/* P2_NBITER_SF13 */
 #define RSTV0910_P2_NBITER_SF13  0xfae7
 #define FSTV0910_P2_NBITER_SF_8PSK_2_3  0xfae700ff
 
-/*P2_NBITER_SF14*/
+/* P2_NBITER_SF14 */
 #define RSTV0910_P2_NBITER_SF14  0xfae8
 #define FSTV0910_P2_NBITER_SF_8PSK_3_4  0xfae800ff
 
-/*P2_NBITER_SF15*/
+/* P2_NBITER_SF15 */
 #define RSTV0910_P2_NBITER_SF15  0xfae9
 #define FSTV0910_P2_NBITER_SF_8PSK_5_6  0xfae900ff
 
-/*P2_NBITER_SF16*/
+/* P2_NBITER_SF16 */
 #define RSTV0910_P2_NBITER_SF16  0xfaea
 #define FSTV0910_P2_NBITER_SF_8PSK_8_9  0xfaea00ff
 
-/*P2_NBITER_SF18*/
+/* P2_NBITER_SF18 */
 #define RSTV0910_P2_NBITER_SF18  0xfaeb
 #define FSTV0910_P2_NBITER_SF_16APSK_2_3  0xfaeb00ff
 
-/*P2_NBITER_SF19*/
+/* P2_NBITER_SF19 */
 #define RSTV0910_P2_NBITER_SF19  0xfaec
 #define FSTV0910_P2_NBITER_SF_16APSK_3_4  0xfaec00ff
 
-/*P2_NBITER_SF20*/
+/* P2_NBITER_SF20 */
 #define RSTV0910_P2_NBITER_SF20  0xfaed
 #define FSTV0910_P2_NBITER_SF_16APSK_4_5  0xfaed00ff
 
-/*P2_NBITER_SF21*/
+/* P2_NBITER_SF21 */
 #define RSTV0910_P2_NBITER_SF21  0xfaee
 #define FSTV0910_P2_NBITER_SF_16APSK_5_6  0xfaee00ff
 
-/*P2_NBITER_SF22*/
+/* P2_NBITER_SF22 */
 #define RSTV0910_P2_NBITER_SF22  0xfaef
 #define FSTV0910_P2_NBITER_SF_16APSK_8_9  0xfaef00ff
 
-/*P2_NBITER_SF24*/
+/* P2_NBITER_SF24 */
 #define RSTV0910_P2_NBITER_SF24  0xfaf0
 #define FSTV0910_P2_NBITER_SF_32APSK_3_4  0xfaf000ff
 
-/*P2_NBITER_SF25*/
+/* P2_NBITER_SF25 */
 #define RSTV0910_P2_NBITER_SF25  0xfaf1
 #define FSTV0910_P2_NBITER_SF_32APSK_4_5  0xfaf100ff
 
-/*P2_NBITER_SF26*/
+/* P2_NBITER_SF26 */
 #define RSTV0910_P2_NBITER_SF26  0xfaf2
 #define FSTV0910_P2_NBITER_SF_32APSK_5_6  0xfaf200ff
 
-/*P2_NBITER_SF27*/
+/* P2_NBITER_SF27 */
 #define RSTV0910_P2_NBITER_SF27  0xfaf3
 #define FSTV0910_P2_NBITER_SF_32APSK_8_9  0xfaf300ff
 
-/*TSTRES0*/
+/* TSTRES0 */
 #define RSTV0910_TSTRES0  0xff11
 #define FSTV0910_FRESFEC  0xff110080
 #define FSTV0910_FRESSYM1  0xff110008
 #define FSTV0910_FRESSYM2  0xff110004
 
-/*TSTOUT*/
+/* TSTOUT */
 #define RSTV0910_TSTOUT  0xff12
 #define FSTV0910_TS  0xff12003e
 #define FSTV0910_TEST_OUT  0xff120001
 
-/*TSTIN*/
+/* TSTIN */
 #define RSTV0910_TSTIN  0xff13
 #define FSTV0910_TEST_IN  0xff130080
 
-/*P2_TSTDMD*/
+/* P2_TSTDMD */
 #define RSTV0910_P2_TSTDMD  0xff20
 #define FSTV0910_P2_CFRINIT_INVZIGZAG  0xff200008
 
-/*P2_TCTL1*/
+/* P2_TCTL1 */
 #define RSTV0910_P2_TCTL1  0xff24
 #define FSTV0910_P2_TST_IQSYMBSEL  0xff24001f
 
-/*P2_TCTL4*/
+/* P2_TCTL4 */
 #define RSTV0910_P2_TCTL4  0xff28
 #define FSTV0910_P2_CFR2TOCFR1_DVBS1  0xff2800c0
 
-/*P2_TPKTDELIN*/
+/* P2_TPKTDELIN */
 #define RSTV0910_P2_TPKTDELIN  0xff37
 #define FSTV0910_P2_CFG_RSPARITYON  0xff370080
 
-/*P1_TSTDMD*/
+/* P1_TSTDMD */
 #define RSTV0910_P1_TSTDMD  0xff40
 #define FSTV0910_P1_CFRINIT_INVZIGZAG  0xff400008
 
-/*P1_TCTL1*/
+/* P1_TCTL1 */
 #define RSTV0910_P1_TCTL1  0xff44
 #define FSTV0910_P1_TST_IQSYMBSEL  0xff44001f
 
-/*P1_TCTL4*/
+/* P1_TCTL4 */
 #define RSTV0910_P1_TCTL4  0xff48
 #define FSTV0910_P1_CFR2TOCFR1_DVBS1  0xff4800c0
 
-/*P1_TPKTDELIN*/
+/* P1_TPKTDELIN */
 #define RSTV0910_P1_TPKTDELIN  0xff57
 #define FSTV0910_P1_CFG_RSPARITYON  0xff570080
 
-/*TSTTSRS*/
+/* TSTTSRS */
 #define RSTV0910_TSTTSRS  0xff6d
 #define FSTV0910_TSTRS_DISRS2  0xff6d0002
 #define FSTV0910_TSTRS_DISRS1  0xff6d0001
-- 
2.13.0
