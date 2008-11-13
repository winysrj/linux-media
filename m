Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from outmailhost.telefonica.net ([213.4.149.242]
	helo=ctsmtpout3.frontal.correo)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jareguero@telefonica.net>) id 1L0ed7-0006Fy-SI
	for linux-dvb@linuxtv.org; Thu, 13 Nov 2008 17:01:14 +0100
From: Jose Alberto Reguero <jareguero@telefonica.net>
To: linux-dvb@linuxtv.org
Date: Thu, 13 Nov 2008 17:00:31 +0100
References: <1587493004@web.de> <491C4A81.8020700@iki.fi>
In-Reply-To: <491C4A81.8020700@iki.fi>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_f8EHJGr3D9YZg4j"
Message-Id: <200811131700.31884.jareguero@telefonica.net>
Cc: Antti Palosaari <crope@iki.fi>,
	Sebastian Marskamp <SebastianMarskamp@web.de>
Subject: Re: [linux-dvb] af9015 problem on fedora rawhide 9.93 with 2.6.27x
	kernel
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

--Boundary-00=_f8EHJGr3D9YZg4j
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

El Jueves, 13 de Noviembre de 2008, Antti Palosaari escribi=F3:
> Sebastian Marskamp wrote:
> > Theres also a patch   , which works fine for me.
> >
> > http://www.linuxtv.org/pipermail/linux-dvb/attachments/20081022/94261bb=
c/
> >attachment.diff
>
> This patch is not OK because it still sends reconnect USB-command. It
> may lead to situation stick reconnects but driver does not except that.
>
> It seems like problem is that it sends USB-reconnect command to the
> stick firmware immediately after firmware is downloaded. Sometimes
> (especially Kernel 2.6.27) USB-reconnect command will be rejected by
> stick firmware because firmware is not started yet. Small sleep just
> before USB-reconnect is needed to ensure stick firmware is running.
>
> Is there anyone who has this problem and can make & test patch?
>
> regards
> Antti

The attached patch work for me.

Jose Alberto


--Boundary-00=_f8EHJGr3D9YZg4j
Content-Type: text/x-patch;
  charset="iso-8859-1";
  name="af9015.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="af9015.diff"

diff -r b45ffc93fb82 linux/drivers/media/dvb/dvb-usb/af9015.c
--- a/linux/drivers/media/dvb/dvb-usb/af9015.c	Wed Nov 05 00:59:37 2008 +0000
+++ b/linux/drivers/media/dvb/dvb-usb/af9015.c	Thu Nov 13 16:50:22 2008 +0100
@@ -681,12 +681,6 @@
 		goto error;
 	}
 
-	/* firmware is running, reconnect device in the usb bus */
-	req.cmd = RECONNECT_USB;
-	ret = af9015_rw_udev(udev, &req);
-	if (ret)
-		err("reconnect failed: %d", ret);
-
 error:
 	return ret;
 }
@@ -1219,6 +1213,7 @@
 		.usb_ctrl = DEVICE_SPECIFIC,
 		.download_firmware = af9015_download_firmware,
 		.firmware = "dvb-usb-af9015.fw",
+		.no_reconnect = 1,
 
 		.size_of_priv = sizeof(struct af9015_state), \
 
@@ -1317,6 +1312,7 @@
 		.usb_ctrl = DEVICE_SPECIFIC,
 		.download_firmware = af9015_download_firmware,
 		.firmware = "dvb-usb-af9015.fw",
+		.no_reconnect = 1,
 
 		.size_of_priv = sizeof(struct af9015_state), \
 

--Boundary-00=_f8EHJGr3D9YZg4j
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--Boundary-00=_f8EHJGr3D9YZg4j--
