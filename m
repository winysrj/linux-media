Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:58707 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750739AbdETML5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 20 May 2017 08:11:57 -0400
Received: from mail-yw0-f170.google.com ([209.85.161.170]) by mail.gmx.com
 (mrgmx002 [212.227.17.184]) with ESMTPSA (Nemesis) id
 0MMBun-1dK1SR2ghR-007yZb for <linux-media@vger.kernel.org>; Sat, 20 May 2017
 14:11:54 +0200
Received: by mail-yw0-f170.google.com with SMTP id l74so44382882ywe.2
        for <linux-media@vger.kernel.org>; Sat, 20 May 2017 05:11:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201205092112.02807.linux@rainbow-software.org>
References: <201205092112.02807.linux@rainbow-software.org>
From: Christopher Chavez <chrischavez@gmx.us>
Date: Sat, 20 May 2017 07:11:33 -0500
Message-ID: <CAAFQ00nD8Z+qhYCbfX8a84Ampqr27B1dP+ADsH7cBZhgJ+jpjw@mail.gmail.com>
Subject: Re: Dazzle DVC80 under FC16
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Bruno Martins <lists@skorzen.net>, linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>
> On May 9, 2012, at 2:12 PM, Ondrej Zary <linux@rainbow-software.org> wrote:
> Can you test this patch? It should make the driver ignore the second
> interface with no endpoints.
> --- a/drivers/media/video/usbvision/usbvision-video.c
> +++ b/drivers/media/video/usbvision/usbvision-video.c
> @@ -1504,6 +1504,11 @@ static int __devinit usbvision_probe(struct usb_interface *intf,
> interface = &dev->actconfig->interface[usbvision_device_data[model].interface]->altsetting[0];
> else
> interface = &dev->actconfig->interface[ifnum]->altsetting[0];
> + if (interface->desc.bNumEndpoints < 1) {
> + dev_err(&intf->dev, "%s: interface %d. has no endpoints\n",
> +    __func__, ifnum);
> + return -ENODEV;
> + }
> endpoint = &interface->endpoint[1].desc;
> if (!usb_endpoint_xfer_isoc(endpoint)) {
> dev_err(&intf->dev, "%s: interface %d. has non-ISO endpoint!\n",


Leaving a reply for reference: while trying to add support for another
device [1], I noticed that the fix for CVE-2015-7833 [2] contained a
check similar to the one in Zary's patch:

(from commit fa52bd506f274b7619955917abfde355e3d19ffe)



 drivers/media/usb/usbvision/usbvision-video.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/usbvision/usbvision-video.c
b/drivers/media/usb/usbvision/usbvision-video.c
index b693206..d1dc1a1 100644
--- a/drivers/media/usb/usbvision/usbvision-video.c
+++ b/drivers/media/usb/usbvision/usbvision-video.c
@@ -1463,9 +1463,23 @@ static int usbvision_probe(struct usb_interface *intf,

  if (usbvision_device_data[model].interface >= 0)
  interface = &dev->actconfig->interface[usbvision_device_data[model].interface]->altsetting[0];
- else
+ else if (ifnum < dev->actconfig->desc.bNumInterfaces)
  interface = &dev->actconfig->interface[ifnum]->altsetting[0];
+ else {
+ dev_err(&intf->dev, "interface %d is invalid, max is %d\n",
+    ifnum, dev->actconfig->desc.bNumInterfaces - 1);
+ ret = -ENODEV;
+ goto err_usb;
+ }
+
+ if (interface->desc.bNumEndpoints < 2) {
+ dev_err(&intf->dev, "interface %d has %d endpoints, but must"
+    " have minimum 2\n", ifnum, interface->desc.bNumEndpoints);
+ ret = -ENODEV;
+ goto err_usb;
+ }
  endpoint = &interface->endpoint[1].desc;
+
  if (!usb_endpoint_xfer_isoc(endpoint)) {
  dev_err(&intf->dev, "%s: interface %d. has non-ISO endpoint!\n",
     __func__, ifnum);



I can still reproduce the "cannot change alternate number to 1
(error=-22)" issue, however. Unless something else is broken, e.g. in
my card definition, I haven't made any progress myself on figuring out
why this happens.

[1] usbvision: problems adding support for ATI TV Wonder USB Edition
https://www.spinics.net/lists/linux-media/msg95854.html

[2] usbvision: fix crash on detecting device with invalid configuration
https://www.spinics.net/lists/linux-media/msg94831.html

Christopher A. Chavez
