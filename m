Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from joan.kewl.org ([212.161.35.248])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <darron@kewl.org>) id 1KsRu4-0000iV-Bl
	for linux-dvb@linuxtv.org; Wed, 22 Oct 2008 02:48:49 +0200
From: Darron Broad <darron@kewl.org>
To: Andrej Podzimek <andrej@podzimek.org>
In-reply-to: <48FE6351.2000805@podzimek.org> 
References: <48FE2872.3070105@podzimek.org> <48FE3553.5080009@iki.fi>
	<48FE6351.2000805@podzimek.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="----- =_aaaaaaaaaa0"
Content-ID: <10305.1224636434.0@kewl.org>
Date: Wed, 22 Oct 2008 01:48:43 +0100
Message-ID: <10307.1224636523@kewl.org>
Cc: Antti Palosaari <crope@iki.fi>, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] MSI DigiVox mini II V3.0 stopped working
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

------- =_aaaaaaaaaa0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <10305.1224636434.1@kewl.org>

In message <48FE6351.2000805@podzimek.org>, Andrej Podzimek wrote:
>One more little note about the firmware:
>
>	[andrej@xandrej firmware]$ sha1sum dvb-usb-af9015.fw
>	6a0edcc65f490d69534d4f071915fc73f5461560  dvb-usb-af9015.fw
>
>That file can be found here: http://www.otit.fi/~crope/v4l-dvb/af9015/af9015_firmware_cutter/firmware_files/4.95.0/dvb-usb-af9015.fw
>
>Is it the right one? Shell I try something else?

Lo

try this patch (WARNING, although I have one of these devices
and this looked to fix it, I have no idea what this actually means).

------- =_aaaaaaaaaa0
Content-Type: text/x-diff; name="dmb.diff"; charset="us-ascii"
Content-ID: <10305.1224636434.2@kewl.org>
Content-Transfer-Encoding: quoted-printable

diff -r 964e3eafa442 linux/drivers/media/dvb/dvb-usb/af9015.c
--- a/linux/drivers/media/dvb/dvb-usb/af9015.c	Tue Oct 21 21:09:38 2008 +0=
100
+++ b/linux/drivers/media/dvb/dvb-usb/af9015.c	Wed Oct 22 01:45:41 2008 +0=
100
@@ -1204,6 +1204,7 @@
 static struct dvb_usb_device_properties af9015_properties[] =3D {
 	{
 		.caps =3D DVB_USB_IS_AN_I2C_ADAPTER,
+		.no_reconnect =3D 1,
 =

 		.usb_ctrl =3D DEVICE_SPECIFIC,
 		.download_firmware =3D af9015_download_firmware,
@@ -1302,6 +1303,7 @@
 		}
 	}, {
 		.caps =3D DVB_USB_IS_AN_I2C_ADAPTER,
+		.no_reconnect =3D 1,
 =

 		.usb_ctrl =3D DEVICE_SPECIFIC,
 		.download_firmware =3D af9015_download_firmware,

------- =_aaaaaaaaaa0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <10305.1224636434.3@kewl.org>

--

 // /
{:)==={ Darron Broad <darron@kewl.org>
 \\ \ 


------- =_aaaaaaaaaa0
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
------- =_aaaaaaaaaa0--
