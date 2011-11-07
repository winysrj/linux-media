Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46365 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348Ab1KGT55 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Nov 2011 14:57:57 -0500
Received: by faan17 with SMTP id n17so369538faa.19
        for <linux-media@vger.kernel.org>; Mon, 07 Nov 2011 11:57:56 -0800 (PST)
Message-ID: <4EB8383F.2000201@gmail.com>
Date: Mon, 07 Nov 2011 20:57:51 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: gennarone@gmail.com
CC: linux-media <linux-media@vger.kernel.org>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: [PATCH 00/13] Remaining coding style clean up of AS102 driver
References: <1320611510-3326-1-git-send-email-snjw23@gmail.com> <4EB7F709.2050503@gmail.com> <4EB802A0.7030600@gmail.com>
In-Reply-To: <4EB802A0.7030600@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Gianluca,

On 11/07/2011 05:09 PM, Gianluca Gennari wrote:
> Hi Sylwestwer,
> I was about to test the new driver when I discovered that my as102
> device is not included in the list of supported devices:
> 
> /* Super Digi KEY */
> #define AS102_SUPER_DIGI_NAME	"Super Digi KEY"
> #define SUPER_DIGI_USB_VID	0x2137
> #define SUPER_DIGI_USB_PID	0x0001
> 
> It's a "Digital key" offered by Sky Italia to its customers to watch
> terrestrial programs with the Sky satellite decoders.

I'm not sure if your device needs some special handling, but it might work
if you repeat steps as in this patch: 
http://git.linuxtv.org/media_tree.git/commitdiff/5f9745b2c942b2ab220831b2c51a18c3f1374249

Have you tried it already ?

Possibly something like this is enough (only compile tested):

diff --git a/drivers/staging/media/as102/as102_usb_drv.c b/drivers/staging/media/as102/as102_usb_drv.c
index 9faab5b..9edb366 100644
--- a/drivers/staging/media/as102/as102_usb_drv.c
+++ b/drivers/staging/media/as102/as102_usb_drv.c
@@ -42,6 +42,7 @@ static struct usb_device_id as102_usb_id_table[] = {
        { USB_DEVICE(PCTV_74E_USB_VID, PCTV_74E_USB_PID) },
        { USB_DEVICE(ELGATO_EYETV_DTT_USB_VID, ELGATO_EYETV_DTT_USB_PID) },
        { USB_DEVICE(NBOX_DVBT_DONGLE_USB_VID, NBOX_DVBT_DONGLE_USB_PID) },
+       { USB_DEVICE(SUPER_DIGI_USB_VID, SUPER_DIGI_USB_PID) },
        { } /* Terminating entry */
 };
 
@@ -52,6 +53,7 @@ static const char * const as102_device_names[] = {
        AS102_PCTV_74E,
        AS102_ELGATO_EYETV_DTT_NAME,
        AS102_NBOX_DVBT_DONGLE_NAME,
+       AS102_SUPER_DIGI_NAME,
        NULL /* Terminating entry */
 };
 
diff --git a/drivers/staging/media/as102/as102_usb_drv.h b/drivers/staging/media/as102/as102_usb_drv.h
index 35925b7..6f95af2 100644
--- a/drivers/staging/media/as102/as102_usb_drv.h
+++ b/drivers/staging/media/as102/as102_usb_drv.h
@@ -47,6 +47,11 @@
 #define NBOX_DVBT_DONGLE_USB_VID       0x0b89
 #define NBOX_DVBT_DONGLE_USB_PID       0x0007
 
+/* Super Digi KEY */
+#define AS102_SUPER_DIGI_NAME          "Super Digi KEY"
+#define SUPER_DIGI_USB_VID             0x2137
+#define SUPER_DIGI_USB_PID             0x0001
+

My knowledge about this driver is rather limited, in case of any issues I
guess it's best to ask Devin directly.


-- 
Regards,
Sylwester
