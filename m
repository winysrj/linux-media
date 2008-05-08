Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtps.ntu.edu.tw ([140.112.2.142])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <b87605214@ntu.edu.tw>) id 1Ju7ok-0001tC-VG
	for linux-dvb@linuxtv.org; Thu, 08 May 2008 17:14:03 +0200
From: lin <b87605214@ntu.edu.tw>
To: linux-dvb@linuxtv.org
Date: Thu, 8 May 2008 23:12:59 +0800
References: <200805071307.15982.b87605214@ntu.edu.tw>
	<48219F49.9090709@Rods.id.au>
In-Reply-To: <48219F49.9090709@Rods.id.au>
MIME-Version: 1.0
Message-Id: <200805082312.59928.b87605214@ntu.edu.tw>
Subject: Re: [linux-dvb] Try to Make DVB-T part of Compro VideoMate T750 Work
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1974318695=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1974318695==
Content-Type: multipart/alternative;
  boundary="Boundary-01=_7hxIIr6cveb8cyi"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_7hxIIr6cveb8cyi
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit

On 2008 May 7 Wednesday 20:23:37 you wrote:
>     Hi, what I2C addresses are you using for each device?

Hi, Rod:

Sorry for late replying...

Following is my patch to v4l-dvb (v4l-dvb-4c4fd6b8755c)
The patch is mainly adapted from Newbigin's patch, but the case in saa7134_board_init2 is talltolly a nonsense guessing...    lol

Ask a newbie question...  lol
What's the role of I2C plays in between these chips?

linleno
---

diff -ru v4l-dvb-4c4fd6b8755c-ori/linux/drivers/media/video/saa7134/saa7134-cards.c v4l-dvb-4c4fd6b8755c/linux/drivers/media/video/saa7134/saa7134-cards.c
--- v4l-dvb-4c4fd6b8755c-ori/linux/drivers/media/video/saa7134/saa7134-cards.c  2008-05-02 18:51:27.000000000 +0800
+++ v4l-dvb-4c4fd6b8755c/linux/drivers/media/video/saa7134/saa7134-cards.c      2008-05-08 22:42:06.000000000 +0800
@@ -5936,6 +5936,7 @@
        case SAA7134_BOARD_AVERMEDIA_SUPER_007:
        case SAA7134_BOARD_TWINHAN_DTV_DVB_3056:
        case SAA7134_BOARD_CREATIX_CTX953:
+       case SAA7134_BOARD_VIDEOMATE_T750:
        {
                /* this is a hybrid board, initialize to analog mode
                 * and configure firmware eeprom address
diff -ru v4l-dvb-4c4fd6b8755c-ori/linux/drivers/media/video/saa7134/saa7134-dvb.c v4l-dvb-4c4fd6b8755c/linux/drivers/media/video/saa7134/saa7134-dvb.c
--- v4l-dvb-4c4fd6b8755c-ori/linux/drivers/media/video/saa7134/saa7134-dvb.c    2008-05-02 18:51:27.000000000 +0800
+++ v4l-dvb-4c4fd6b8755c/linux/drivers/media/video/saa7134/saa7134-dvb.c        2008-05-08 22:42:54.000000000 +0800
@@ -40,6 +40,8 @@
 #include "tda1004x.h"
 #include "nxt200x.h"
 #include "tuner-xc2028.h"
+#include "zl10353.h"
+#include "qt1010.h"

 #include "tda10086.h"
 #include "tda826x.h"
@@ -937,6 +939,17 @@
        .demod_address    = 0x0a,
 };

+static struct zl10353_config videomate_t750_zl10353_config = {
+       .demod_address  = 0x0f,
+       .no_tuner = 0,
+       .parallel_ts = 1,
+};
+
+static struct qt1010_config videomate_t750_qt1010_config = {
+       .i2c_address = 0x62
+};
+
+
 /* ==================================================================
  * Core code
  */
@@ -1263,15 +1276,33 @@
                        goto dettach_frontend;
                break;
        case SAA7134_BOARD_AVERMEDIA_CARDBUS_506:
-#if 0
-       /*FIXME: What frontend does Videomate T750 use? */
-       case SAA7134_BOARD_VIDEOMATE_T750:
-#endif
                dev->dvb.frontend = dvb_attach(mt352_attach,
                                               &avermedia_e506r_mt352_dev,
                                               &dev->i2c_adap);
                attach_xc3028 = 1;
                break;
+#if 1
+       /*FIXME: What frontend does Videomate T750 use? */
+       case SAA7134_BOARD_VIDEOMATE_T750:
+               printk("Compro VideoMate T750 DVB setup\n");
+               dev->dvb.frontend = dvb_attach(zl10353_attach,
+                                               &videomate_t750_zl10353_config,
+                                               &dev->i2c_adap);
+               if (dev->dvb.frontend != NULL) {
+                       printk("Attaching pll\n");
+                       // if there is a gate function then the i2c bus breaks.....!
+                       dev->dvb.frontend->ops.i2c_gate_ctrl = 0;
+
+                       if (dvb_attach(qt1010_attach,
+                                      dev->dvb.frontend,
+                                      &dev->i2c_adap,
+                                      &videomate_t750_qt1010_config) == NULL)
+                       {
+                               wprintk("error attaching QT1010\n");
+                       }
+               }
+               break;
+#endif
        case SAA7134_BOARD_MD7134_BRIDGE_2:
                dev->dvb.frontend = dvb_attach(tda10086_attach,
                                                &sd1878_4m, &dev->i2c_adap);

--Boundary-01=_7hxIIr6cveb8cyi
Content-Type: text/html;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit

<html><head><meta name="qrichtext" content="1" /></head><body style="font-size:10pt;font-family:DejaVu Serif">
<p>On 2008 May 7 Wednesday 20:23:37 you wrote:</p>
<p>&gt;     Hi, what I2C addresses are you using for each device?</p>
<p></p>
<p>Hi, Rod:</p>
<p></p>
<p>Sorry for late replying...</p>
<p></p>
<p>Following is my patch to v4l-dvb (v4l-dvb-4c4fd6b8755c)</p>
<p>The patch is mainly adapted from Newbigin's patch, but the case in saa7134_board_init2 is talltolly a nonsense guessing...    lol</p>
<p></p>
<p>Ask a newbie question...  lol</p>
<p>What's the role of I2C plays in between these chips?</p>
<p></p>
<p>linleno</p>
<p>---</p>
<p></p>
<p>diff -ru v4l-dvb-4c4fd6b8755c-ori/linux/drivers/media/video/saa7134/saa7134-cards.c v4l-dvb-4c4fd6b8755c/linux/drivers/media/video/saa7134/saa7134-cards.c</p>
<p>--- v4l-dvb-4c4fd6b8755c-ori/linux/drivers/media/video/saa7134/saa7134-cards.c  2008-05-02 18:51:27.000000000 +0800</p>
<p>+++ v4l-dvb-4c4fd6b8755c/linux/drivers/media/video/saa7134/saa7134-cards.c      2008-05-08 22:42:06.000000000 +0800</p>
<p>@@ -5936,6 +5936,7 @@</p>
<p>        case SAA7134_BOARD_AVERMEDIA_SUPER_007:</p>
<p>        case SAA7134_BOARD_TWINHAN_DTV_DVB_3056:</p>
<p>        case SAA7134_BOARD_CREATIX_CTX953:</p>
<p>+       case SAA7134_BOARD_VIDEOMATE_T750:</p>
<p>        {</p>
<p>                /* this is a hybrid board, initialize to analog mode</p>
<p>                 * and configure firmware eeprom address</p>
<p>diff -ru v4l-dvb-4c4fd6b8755c-ori/linux/drivers/media/video/saa7134/saa7134-dvb.c v4l-dvb-4c4fd6b8755c/linux/drivers/media/video/saa7134/saa7134-dvb.c</p>
<p>--- v4l-dvb-4c4fd6b8755c-ori/linux/drivers/media/video/saa7134/saa7134-dvb.c    2008-05-02 18:51:27.000000000 +0800</p>
<p>+++ v4l-dvb-4c4fd6b8755c/linux/drivers/media/video/saa7134/saa7134-dvb.c        2008-05-08 22:42:54.000000000 +0800</p>
<p>@@ -40,6 +40,8 @@</p>
<p> #include &quot;tda1004x.h&quot;</p>
<p> #include &quot;nxt200x.h&quot;</p>
<p> #include &quot;tuner-xc2028.h&quot;</p>
<p>+#include &quot;zl10353.h&quot;</p>
<p>+#include &quot;qt1010.h&quot;</p>
<p></p>
<p> #include &quot;tda10086.h&quot;</p>
<p> #include &quot;tda826x.h&quot;</p>
<p>@@ -937,6 +939,17 @@</p>
<p>        .demod_address    = 0x0a,</p>
<p> };</p>
<p></p>
<p>+static struct zl10353_config videomate_t750_zl10353_config = {</p>
<p>+       .demod_address  = 0x0f,</p>
<p>+       .no_tuner = 0,</p>
<p>+       .parallel_ts = 1,</p>
<p>+};</p>
<p>+</p>
<p>+static struct qt1010_config videomate_t750_qt1010_config = {</p>
<p>+       .i2c_address = 0x62</p>
<p>+};</p>
<p>+</p>
<p>+</p>
<p> /* ==================================================================</p>
<p>  * Core code</p>
<p>  */</p>
<p>@@ -1263,15 +1276,33 @@</p>
<p>                        goto dettach_frontend;</p>
<p>                break;</p>
<p>        case SAA7134_BOARD_AVERMEDIA_CARDBUS_506:</p>
<p>-#if 0</p>
<p>-       /*FIXME: What frontend does Videomate T750 use? */</p>
<p>-       case SAA7134_BOARD_VIDEOMATE_T750:</p>
<p>-#endif</p>
<p>                dev-&gt;dvb.frontend = dvb_attach(mt352_attach,</p>
<p>                                               &amp;avermedia_e506r_mt352_dev,</p>
<p>                                               &amp;dev-&gt;i2c_adap);</p>
<p>                attach_xc3028 = 1;</p>
<p>                break;</p>
<p>+#if 1</p>
<p>+       /*FIXME: What frontend does Videomate T750 use? */</p>
<p>+       case SAA7134_BOARD_VIDEOMATE_T750:</p>
<p>+               printk(&quot;Compro VideoMate T750 DVB setup\n&quot;);</p>
<p>+               dev-&gt;dvb.frontend = dvb_attach(zl10353_attach,</p>
<p>+                                               &amp;videomate_t750_zl10353_config,</p>
<p>+                                               &amp;dev-&gt;i2c_adap);</p>
<p>+               if (dev-&gt;dvb.frontend != NULL) {</p>
<p>+                       printk(&quot;Attaching pll\n&quot;);</p>
<p>+                       // if there is a gate function then the i2c bus breaks.....!</p>
<p>+                       dev-&gt;dvb.frontend-&gt;ops.i2c_gate_ctrl = 0;</p>
<p>+</p>
<p>+                       if (dvb_attach(qt1010_attach,</p>
<p>+                                      dev-&gt;dvb.frontend,</p>
<p>+                                      &amp;dev-&gt;i2c_adap,</p>
<p>+                                      &amp;videomate_t750_qt1010_config) == NULL)</p>
<p>+                       {</p>
<p>+                               wprintk(&quot;error attaching QT1010\n&quot;);</p>
<p>+                       }</p>
<p>+               }</p>
<p>+               break;</p>
<p>+#endif</p>
<p>        case SAA7134_BOARD_MD7134_BRIDGE_2:</p>
<p>                dev-&gt;dvb.frontend = dvb_attach(tda10086_attach,</p>
<p>                                                &amp;sd1878_4m, &amp;dev-&gt;i2c_adap);</p>
<p></p>
</body></html>
--Boundary-01=_7hxIIr6cveb8cyi--


--===============1974318695==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1974318695==--
