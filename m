Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp1.su.se ([130.237.162.112] helo=smtp.su.se)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <pelle@dsv.su.se>) id 1Jm6xF-0001Jq-H6
	for linux-dvb@linuxtv.org; Wed, 16 Apr 2008 14:41:44 +0200
Message-ID: <4805F3FA.5080901@dsv.su.se>
Date: Wed, 16 Apr 2008 14:41:30 +0200
From: Per Olofsson <pelle@dsv.su.se>
MIME-Version: 1.0
To: bas@kompasmedia.nl
References: <bf9a9c0dd71fe6e733de49fd916fe4eb@localhost>
In-Reply-To: <bf9a9c0dd71fe6e733de49fd916fe4eb@localhost>
Content-Type: multipart/mixed; boundary="------------090603080307000904000501"
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Mantis 2033 change tuner
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--------------090603080307000904000501
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi,

I don't own the card in question, but I am interesting in buying one if it works :-)

Bas v.d. Wiel wrote:
> Hello all,
> As I got no response to my question about changing tuner chips on Mantis
> cards (I have one with chip ID 0x7d which I read about earlier), I started
> experimenting with the sources from jusst.de. I changed mantis_dvb.c in a
> crude way by simply copying the contents of a case statement for a Mantis
> 2040 to the one for the 2033 and commenting out the original 2033 block
> that loads the tda10021.

Hrm, 2040? Where did you find that case statement?

Otherwise, have you tried using the case statement for TERRATEC_CINERGY_C_PCI
instead? It looks exactly the same as the 2033 case apart from the tda10023
tuner. Perhaps try the attached (untested) patch?

> To my surprise this compiled without any trouble and everything gets loaded
> and recognized without error upon next bootup, including the tda10023.
> However, as I expected, something crashes in a very bad way when I actually
> try to use the tuner with dvb-scan. Am I doing something wrong? Or is my
> card simply not supported (yet) by the mantis driver (too new maybe)?

Could you post the diff? Also make sure you have the latest mantis source code
(use "hg pull" + "hg up" to update).

-- 
Pelle

--------------090603080307000904000501
Content-Type: text/x-diff;
 name="mantis.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="mantis.patch"

diff -r b7b8a2a81f3e linux/drivers/media/dvb/mantis/mantis_dvb.c
--- a/linux/drivers/media/dvb/mantis/mantis_dvb.c	Wed Apr 16 15:22:16 2008 +0400
+++ b/linux/drivers/media/dvb/mantis/mantis_dvb.c	Wed Apr 16 14:33:49 2008 +0200
@@ -259,7 +259,7 @@
 			}
 		}
 		break;
-	case MANTIS_VP_2033_DVB_C:	// VP-2033
+      //case MANTIS_VP_2033_DVB_C:	// VP-2033
 		dprintk(verbose, MANTIS_ERROR, 1, "Probing for CU1216 (DVB-C)");
 		mantis->fe = tda10021_attach(&philips_cu1216_config, &mantis->adapter, read_pwm(mantis));
 		if (mantis->fe) {
@@ -274,6 +274,7 @@
 		}
 		break;
 	case TERRATEC_CINERGY_C_PCI:
+	case MANTIS_VP_2033_DVB_C:
 		dprintk(verbose, MANTIS_ERROR, 1, "Probing for CU1216 (DVB-C)");
 		mantis->fe = tda10023_attach(&tda10023_cu1216_config, &mantis->adapter, read_pwm(mantis));
 		if (mantis->fe) {

--------------090603080307000904000501
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------090603080307000904000501--
