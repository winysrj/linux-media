Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ve0-f177.google.com ([209.85.128.177]:33245 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754045Ab3CKXZe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Mar 2013 19:25:34 -0400
Received: by mail-ve0-f177.google.com with SMTP id m1so3112352ves.36
        for <linux-media@vger.kernel.org>; Mon, 11 Mar 2013 16:25:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20121228102928.4103390e@redhat.com>
References: <20121228102928.4103390e@redhat.com>
Date: Tue, 12 Mar 2013 03:25:33 +0400
Message-ID: <CALW4P+KzhmzAeQUQDRxEyfiHNSkCeua81p=xzukp0k3tF7JEEg@mail.gmail.com>
Subject: Re: Fw: [patch 02/03 v2] usb hid quirks for Masterkit MA901 usb radio
From: Alexey Klimov <klimov.linux@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jiri Kosina <jkosina@suse.cz>
Cc: LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jiri and Mauro, all,

On Fri, Dec 28, 2012 at 4:29 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Hi Jiri,
>
> There's another radio device that it is incorrectly detected as an HID driver.
> As I'll be applying the driver's patch via the media tree, do you mind if I also
> apply this hid patch there?
>
> Thanks!
> Mauro
>
> Forwarded message:
>
> Date: Mon, 12 Nov 2012 07:57:03 +0100
> From: Alexey Klimov <klimov.linux@gmail.com>
> To: linux-media@vger.kernel.org
> Subject: [patch 02/03 v2] usb hid quirks for Masterkit MA901 usb radio
>
>
> Don't let Masterkit MA901 USB radio be handled by usb hid drivers.
>
> This device will be handled by radio-ma901.c driver.
>
> Signed-off-by: Alexey Klimov <klimov.linux@gmail.com>
>
>
> diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
> index 5de3bb3..8e06569 100644
> --- a/drivers/hid/hid-core.c
> +++ b/drivers/hid/hid-core.c
> @@ -2025,6 +2025,7 @@ static const struct hid_device_id hid_ignore_list[] = {
>         { HID_USB_DEVICE(USB_VENDOR_ID_LD, USB_DEVICE_ID_LD_HYBRID) },
>         { HID_USB_DEVICE(USB_VENDOR_ID_LD, USB_DEVICE_ID_LD_HEATCONTROL) },
>         { HID_USB_DEVICE(USB_VENDOR_ID_MADCATZ, USB_DEVICE_ID_MADCATZ_BEATPAD) },
> +       { HID_USB_DEVICE(USB_VENDOR_ID_MASTERKIT, USB_DEVICE_ID_MASTERKIT_MA901RADIO) },
>         { HID_USB_DEVICE(USB_VENDOR_ID_MCC, USB_DEVICE_ID_MCC_PMD1024LS) },
>         { HID_USB_DEVICE(USB_VENDOR_ID_MCC, USB_DEVICE_ID_MCC_PMD1208LS) },
>         { HID_USB_DEVICE(USB_VENDOR_ID_MICROCHIP, USB_DEVICE_ID_PICKIT1) },
> diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
> index 1dcb76f..17aa4f6 100644
> --- a/drivers/hid/hid-ids.h
> +++ b/drivers/hid/hid-ids.h
> @@ -533,6 +533,9 @@
>  #define USB_VENDOR_ID_MADCATZ          0x0738
>  #define USB_DEVICE_ID_MADCATZ_BEATPAD  0x4540
>
> +#define USB_VENDOR_ID_MASTERKIT                        0x16c0
> +#define USB_DEVICE_ID_MASTERKIT_MA901RADIO     0x05df
> +
>  #define USB_VENDOR_ID_MCC              0x09db
>  #define USB_DEVICE_ID_MCC_PMD1024LS    0x0076
>  #define USB_DEVICE_ID_MCC_PMD1208LS    0x007a

Well, since patch also was pushed to stable trees like 3.5, 3.8, 3.2
and this fact made me look a little closer to usb ids. Actually, i
googled these usb ids: 16c0 05df, link:
http://www.google.com/search?q=16c0+05df
and here comes some doubts.

For my eyes it looks like this usb radio consists of two chips: atmel
tiny85 + actually fm tuner KT0830EG. It looks like tiny85 is used in
many devices with the same usb ids like in our patch and people works
with tiny85 using some software under linux. I don't know if linux
software using hiddev/hidraw devices but this patch doesn't allow
appearing of /dev/hiddev or /dev/hidraw files for any usb device with
ids 0x16c0 0x05df, right? Is there any chance that using such patch we
can break some linux software that uses /dev/hid* files and related
functionality to communicate with tiny85?

Please note that i'm not expert in tiny85 chip and i don't have any
deep knowledges on how usb ids are allocated for every device in the
world.
Masterkit company changed (or was able to change?) only Manufacturer,
Product, Serial fields in ma901 usb radio. I attached lsusb output in
the end of letter. Bad thing here is that Masterkit has other usb not
radio devices with the same usb ids based on tiny85 on the market.


Sorry if i'm over-alarmed, i just really dont want to break any
userspace programs by this patch.

If everything above is correct then i can use some dev->product,
dev->manufacturer, dev->serial checks in probe() function in
radio-ma901.c driver in the way like it's done in radio-keene.c driver
in probe function. If for example probe will discover that product
doesn't match then i can return -ENODEV. It's just an idea. But i
don't know if it is possible to do something with hid quirks: revert
and put comments somewhere or workaround and additional checks?
Well, any comments are welcome.

-- 
Best regards, Klimov Alexey



lsusb output:

Bus 003 Device 002: ID 16c0:05df VOTI
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0         8
  idVendor           0x16c0 VOTI
  idProduct          0x05df
  bcdDevice            1.00
  iManufacturer           1 www.masterkit.ru
  iProduct                2 MA901
  iSerial                 3 SHS
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           34
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0x80
      (Bus Powered)
    MaxPower              250mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         3 Human Interface Device
      bInterfaceSubClass      0 No Subclass
      bInterfaceProtocol      0 None
      iInterface              0
        HID Device Descriptor:
          bLength                 9
          bDescriptorType        33
          bcdHID               1.01
          bCountryCode            0 Not supported
          bNumDescriptors         1
          bDescriptorType        34 Report
          wDescriptorLength      22
         Report Descriptors:
           ** UNAVAILABLE **
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0008  1x 8 bytes
        bInterval             100
Device Status:     0x0000
  (Bus Powered)
