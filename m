Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from aa012msr.fastwebnet.it ([85.18.95.72])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <insomniac@slackware.it>) id 1JbOgE-00054V-EE
	for linux-dvb@linuxtv.org; Tue, 18 Mar 2008 00:23:47 +0100
Date: Tue, 18 Mar 2008 00:21:11 +0100
From: insomniac <insomniac@slackware.it>
To: "Albert Comerma" <albert.comerma@gmail.com>
Message-ID: <20080318002111.2a815091@slackware.it>
In-Reply-To: <ea4209750803171559q2ab79b17od0f6a6bead0dfcf6@mail.gmail.com>
References: <20080316182618.2e984a46@slackware.it> <47DE5F42.8070005@iki.fi>
	<20080317213321.01b408cd@slackware.it>
	<ea4209750803171412x63a3a711t96614c03019aaf84@mail.gmail.com>
	<20080317221546.6a4dd75e@slackware.it>
	<ea4209750803171420t55f203eev3ba21b70d93bc39f@mail.gmail.com>
	<20080317222416.38cf913f@slackware.it>
	<ea4209750803171427x45224559l4b60f804401e6c87@mail.gmail.com>
	<ea4209750803171438x34e25fb5o6bbfa91b38defa2e@mail.gmail.com>
	<20080317234614.7b9a4c38@slackware.it>
	<ea4209750803171559q2ab79b17od0f6a6bead0dfcf6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/w_lk3Baze_psO+UJbmT.U3Q"
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

--MP_/w_lk3Baze_psO+UJbmT.U3Q
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Mon, 17 Mar 2008 23:59:07 +0100
"Albert Comerma" <albert.comerma@gmail.com> wrote:

> It's not clear that the patch worked with the differences of the
> source (it has a reference to the identifier matrix). I will try to
> add it just to check there's no problem with that. But tomorrw...

Yes, they differ, so I tried to patch by hand. In attachment the patch
I did based on Antti's patch and your tarball (after a make clean).
Don't really know if that makes sense in my case.

Regards,
-- 
Andrea Barberio

a.barberio@oltrelinux.com - Linux&C.
andrea.barberio@slackware.it - Slackware Linux Project Italia
GPG key on http://insomniac.slackware.it/gpgkey.asc
2818 A961 D6D8 1A8C 6E84  6181 5FA6 03B2 E68A 0B7D
SIP: 5327786, Phone: 06 916503784

--MP_/w_lk3Baze_psO+UJbmT.U3Q
Content-Type: text/x-patch; name=pinnacle.73e.diff
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=pinnacle.73e.diff

diff -Nru v4l-dvb/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c v4l-dvb-73e/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c
--- v4l-dvb/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c	2008-01-10 13:24:20.000000000 +0100
+++ v4l-dvb-73e/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c	2008-03-18 00:05:45.000000000 +0100
@@ -854,6 +854,7 @@
 /* 20 */{ USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_EXPRESS) },
 /* 21 */{ USB_DEVICE(USB_VID_GIGABYTE, USB_PID_GIGABYTE_U7000) },
 /* 22 */{ USB_DEVICE(USB_VID_PINNACLE, USB_PID_PINNACLE_PCTV72e) },
+	{ USB_DEVICE(USB_VID_PINNACLE,  0x0237) }, // PCTV 73e looks similar as PCTV 2000e
 		{ 0 }		/* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, dib0700_usb_id_table);
@@ -895,7 +896,7 @@
 			},
 		},
 
-		.num_device_descs = 8,
+		.num_device_descs = 9,
 		.devices = {
 			{   "DiBcom STK7700P reference design",
 				{ &dib0700_usb_id_table[0], &dib0700_usb_id_table[1] },
@@ -929,6 +930,10 @@
 			{   "Gigabyte U7000",
 				{ &dib0700_usb_id_table[21], NULL },
 				{ NULL },
+			},
+			{   "Pinnacle PCTV 73e",
+				{ &dib0700_usb_id_table[14], NULL },
+				{ NULL },
 			}
 		},
 

--MP_/w_lk3Baze_psO+UJbmT.U3Q
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--MP_/w_lk3Baze_psO+UJbmT.U3Q--
