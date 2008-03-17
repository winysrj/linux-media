Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from pne-smtpout3-sn2.hy.skanova.net ([81.228.8.111])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1Jb59E-0000YH-LD
	for linux-dvb@linuxtv.org; Mon, 17 Mar 2008 03:32:25 +0100
Message-ID: <47DDD817.9020605@iki.fi>
Date: Mon, 17 Mar 2008 04:31:51 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: insomniac <insomniac@slackware.it>
References: <20080316182618.2e984a46@slackware.it>	<abf3e5070803161342y4a68b638m1ae82e8b24cc9a4b@mail.gmail.com>	<20080317011939.36408857@slackware.it>
	<47DDC4B5.5050607@iki.fi>	<20080317025002.2fee3860@slackware.it>
	<47DDD009.30504@iki.fi> <20080317025849.49b07428@slackware.it>
In-Reply-To: <20080317025849.49b07428@slackware.it>
Content-Type: multipart/mixed; boundary="------------070502010402010105080908"
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] New unsupported device
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
--------------070502010402010105080908
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

insomniac wrote:
> On Mon, 17 Mar 2008 03:57:29 +0200
> Antti Palosaari <crope@iki.fi> wrote:
> 
>> I think it is not correct driver .inf file. inf-file you have is for 
>> Pinnacle PCTV 72e with product ID 0236 and lsusb you have has product
>> ID 0237.
> 
> You are right. Here is the correct (I think) .inf
> http://rafb.net/p/UFxQHw88.html

yes, thats correct. I made simple patch, you can test if it does 
something nasty. You can also look dib0700_devices.c file and try some 
changes. Patch can be applied towards current v4l-dvb-master.

regards
Antti
-- 
http://palosaari.fi/

--------------070502010402010105080908
Content-Type: text/x-diff;
 name="pinnacle_pctv_73e_1.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="pinnacle_pctv_73e_1.patch"

diff -r 2e9a92dbe2be linux/drivers/media/dvb/dvb-usb/dib0700_devices.c
--- a/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c	Sun Mar 16 12:14:12 2008 -0300
+++ b/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c	Mon Mar 17 04:28:33 2008 +0200
@@ -905,6 +905,7 @@ struct usb_device_id dib0700_usb_id_tabl
 		{ USB_DEVICE(USB_VID_ASUS,      USB_PID_ASUS_U3100) },
 /* 25 */	{ USB_DEVICE(USB_VID_HAUPPAUGE, USB_PID_HAUPPAUGE_NOVA_T_STICK_3) },
 		{ USB_DEVICE(USB_VID_HAUPPAUGE, USB_PID_HAUPPAUGE_MYTV_T) },
+		{ USB_DEVICE(USB_VID_PINNACLE,  0x0237) }, // PCTV 73e looks similar as PCTV 2000e
 		{ 0 }		/* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, dib0700_usb_id_table);
@@ -1032,7 +1033,7 @@ struct dvb_usb_device_properties dib0700
 			}
 		},
 
-		.num_device_descs = 4,
+		.num_device_descs = 5,
 		.devices = {
 			{   "Pinnacle PCTV 2000e",
 				{ &dib0700_usb_id_table[11], NULL },
@@ -1048,6 +1049,10 @@ struct dvb_usb_device_properties dib0700
 			},
 			{   "DiBcom STK7700D reference design",
 				{ &dib0700_usb_id_table[14], NULL },
+				{ NULL },
+			},
+			{   "Pinnacle PCTV 73e",
+				{ &dib0700_usb_id_table[27], NULL },
 				{ NULL },
 			}
 		},

--------------070502010402010105080908
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------070502010402010105080908--
