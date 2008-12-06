Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB6Ne72L027127
	for <video4linux-list@redhat.com>; Sat, 6 Dec 2008 18:40:07 -0500
Received: from nf-out-0910.google.com (nf-out-0910.google.com [64.233.182.189])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB6Ndp4N010580
	for <video4linux-list@redhat.com>; Sat, 6 Dec 2008 18:39:51 -0500
Received: by nf-out-0910.google.com with SMTP id d3so285928nfc.21
	for <video4linux-list@redhat.com>; Sat, 06 Dec 2008 15:39:50 -0800 (PST)
From: Alexey Klimov <klimov.linux@gmail.com>
To: Tobias Lorenz <tobias.lorenz@gmx.net>, Mark Lord <mlord@pobox.com>,
	Jiri Kosina <jkosina@suse.cz>, Jiri Slaby <jirislaby@gmail.com>
In-Reply-To: <200812031929.12660.tobias.lorenz@gmx.net>
References: <200812031929.12660.tobias.lorenz@gmx.net>
Content-Type: text/plain
Date: Sun, 07 Dec 2008 02:40:32 +0300
Message-Id: <1228606832.5603.51.camel@tux.localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: greg@kroah.com, video4linux-list@redhat.com,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] si470x: Support for DealExtreme
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Wed, 2008-12-03 at 19:29 +0100, Tobias Lorenz wrote:
> Mauro,
> 
> Please pull from http://linuxtv.org/hg/~tlorenz/v4l-dvb
> for the following changeset:
> 
> 01/01: Add USB ID for the Sil4701 radio from DealExtreme.
> http://linuxtv.org/hg/~tlorenz/v4l-dvb?cmd=changeset;node=42f57f457d9d3a91d5f3966b59bfa87679ecb1c7

>  Documentation/video4linux/si470x.txt |    1 +
>  drivers/media/radio/radio-si470x.c   |    4 ++++
>  2 files changed, 5 insertions(+)
> 
> Thanks,
> Tobias
> --

Hello, all
This patch changes only radio driver. As we know, usbhid module creates
hiddev-device, binds device and doesn't allow si470x module to probe()
device. I contacted to Mark and he confirmed that usbhid module
disallowed si470x to work normally. So, i did patch that makes
usb-hidqurks in hid-subsystem.

Mauro, don't you mind if it goes through Jiri's tree ?

Jiri, can you take it to your hid-tree ?

(actually, i don't who should be placed in Cc section of patch; patch
can be applied well against 28-rc7-git4)

---
HID: Don't allow DealExtreme usb-radio be handled by usb hid driver

This device is already handled by radio-si470x driver, and we
therefore want usbhid to ignore it. Patch places usb ids of that device
in ignore section of hid-core.c

Signed-off-by: Alexey Klimov <klimov.linux@gmail.com>

---
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 40df3e1..0ac2b66 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1420,6 +1420,7 @@ static const struct hid_device_id hid_ignore_list[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CMEDIA, USB_DEVICE_ID_CM109) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CYPRESS, USB_DEVICE_ID_CYPRESS_HIDCOM) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CYPRESS, USB_DEVICE_ID_CYPRESS_ULTRAMOUSE) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_DEALEXTREAME, USB_DEVICE_ID_DEALEXTREAME_RADIO_SI4701) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_DELORME, USB_DEVICE_ID_DELORME_EARTHMATE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_DELORME, USB_DEVICE_ID_DELORME_EM_LT20) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ESSENTIAL_REALITY, USB_DEVICE_ID_ESSENTIAL_REALITY_P5) },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 3928969..1fe0b8b 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -141,6 +141,9 @@
 #define USB_DEVICE_ID_CYPRESS_BARCODE_1	0xde61
 #define USB_DEVICE_ID_CYPRESS_BARCODE_2	0xde64
 
+#define USB_VENDOR_ID_DEALEXTREAME	0x10c5
+#define USB_DEVICE_ID_DEALEXTREAME_RADIO_SI4701	0x819a
+
 #define USB_VENDOR_ID_DELL		0x413c
 #define USB_DEVICE_ID_DELL_W7658	0x2005
 #define USB_DEVICE_ID_DELL_SK8115	0x2105


-- 
Best regards, Klimov Alexey

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
