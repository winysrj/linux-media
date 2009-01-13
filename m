Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from moutng.kundenserver.de ([212.227.126.187])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <manuel.kampert@online.de>) id 1LMhEn-0003mD-VP
	for linux-dvb@linuxtv.org; Tue, 13 Jan 2009 12:15:14 +0100
Date: Tue, 13 Jan 2009 12:14:40 +0100 (CET)
From: manuel.kampert@online.de
To: linux-dvb@linuxtv.org
Message-ID: <2099216668.935253.1231845280189.JavaMail.webmailer@webmail.1and1.com>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_935252_514028586.1231845280189"
Subject: [linux-dvb] FreeX / NoZap CI Module
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

------=_Part_935252_514028586.1231845280189
Content-Type: multipart/alternative;
	boundary="----=_Part_935250_2146952273.1231845280188"

------=_Part_935250_2146952273.1231845280188
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable




here is an dirty hack to get my FreeX / NoZap (aka. Joker CAM) module worki=
ng on my S2-3200. It may also work with other=C2=A0 (newer) budget_ci desig=
n based cards.=20


The problem was the CAM never reports STATUSREG_FR and the driver will time=
 out @ DVB_CA_SLOTSTATE_WAITFR.






------=_Part_935250_2146952273.1231845280188
Content-Type: multipart/related;
	boundary="----=_Part_935251_1806615417.1231845280189"

------=_Part_935251_1806615417.1231845280189
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<html xmlns=3D"http://www.w3.org/1999/xhtml" xml:lang=3D"en" lang=3D"en"><t=
itle></title><head><meta http-equiv=3D"Content-type" content=3D"text/html; =
charset=3DUTF-8" /><style type=3D"text/css"> html, body {overflow-x: visibl=
e; } html { width:100%; height:100%;margin:0px; padding:0px; overflow-y: au=
to; overflow-x: auto; }body { font-size: 100.01%; font-family : Verdana, Ge=
neva, Arial, Helvetica, sans-serif; background-color:transparent; overflow:=
show; background-image:none; margin:0px; padding:5px; }p { margin:0px; padd=
ing:0px; } body { font-size: 12px; font-family : Verdana, Geneva, Arial, He=
lvetica, sans-serif; } p { margin: 0; padding: 0; } blockquote { padding-le=
ft: 5px; margin-left: 5px; margin-bottom: 0px; margin-top: 0px; } blockquot=
e.quote { border-left: 1px solid #CCC; padding-left: 5px; margin-left: 5px;=
 } .misspelled { background: transparent url(//webmailng.1und1.de/static_re=
source/mailclient/widgets/basic/parts/maileditor/spellchecking_underline.gi=
f) repeat-x scroll center bottom; } .correct {} .unknown {} .ignored {}</st=
yle></head><body id=3D"bodyElement" style=3D"">
<p><span style=3D"">here is an dirty hack to get my FreeX / NoZap (aka. Jok=
er CAM) module working on my S2-3200. It may also work with other&nbsp; (ne=
wer) budget_ci design based cards. </span><span></span></p><p><span style=
=3D""><br></span></p><p><span style=3D"">The problem was the CAM never repo=
rts </span>STATUSREG_FR and the driver will time out @ DVB_CA_SLOTSTATE_WAI=
TFR.<span></span></p><p><span></span><span></span><br></p><p><span style=3D=
""><br></span></p></body></html>
------=_Part_935251_1806615417.1231845280189--

------=_Part_935250_2146952273.1231845280188--

------=_Part_935252_514028586.1231845280189
Content-Type: text/x-patch; charset=us-ascii; name=freeXNoZap.patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=freeXNoZap.patch
Content-Length: 1250

diff -Naur a/linux/drivers/media/dvb/dvb-core/dvb_ca_en50221.c b/linux/drivers/media/dvb/dvb-core/dvb_ca_en50221.c
--- a/linux/drivers/media/dvb/dvb-core/dvb_ca_en50221.c	2009-01-12 11:50:12.000000000 +0100
+++ b/linux/drivers/media/dvb/dvb-core/dvb_ca_en50221.c	2009-01-13 11:55:08.000000000 +0100
@@ -1084,7 +1084,7 @@
 				if (time_after(jiffies, ca->slot_info[slot].timeout)) {
 					printk("dvb_ca adapter %d: DVB CAM did not respond :(\n",
 					       ca->dvbdev->adapter->num);
-					ca->slot_info[slot].slot_state = DVB_CA_SLOTSTATE_INVALID;
+					ca->slot_info[slot].slot_state = DVB_CA_SLOTSTATE_LINKINIT;
 					dvb_ca_en50221_thread_update_delay(ca);
 					break;
 				}
diff -Naur a/v4l/dvb_ca_en50221.c b/v4l/dvb_ca_en50221.c
--- a/v4l/dvb_ca_en50221.c	2009-01-12 11:50:12.000000000 +0100
+++ b/v4l/dvb_ca_en50221.c	2009-01-13 11:55:08.000000000 +0100
@@ -1084,7 +1084,7 @@
 				if (time_after(jiffies, ca->slot_info[slot].timeout)) {
 					printk("dvb_ca adapter %d: DVB CAM did not respond :(\n",
 					       ca->dvbdev->adapter->num);
-					ca->slot_info[slot].slot_state = DVB_CA_SLOTSTATE_INVALID;
+					ca->slot_info[slot].slot_state = DVB_CA_SLOTSTATE_LINKINIT;
 					dvb_ca_en50221_thread_update_delay(ca);
 					break;
 				}

------=_Part_935252_514028586.1231845280189
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
------=_Part_935252_514028586.1231845280189--
