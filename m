Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wf-out-1314.google.com ([209.85.200.169])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <x04n2.0@gmail.com>) id 1Lh9uL-0003q5-0c
	for linux-dvb@linuxtv.org; Tue, 10 Mar 2009 22:54:42 +0100
Received: by wf-out-1314.google.com with SMTP id 28so3017565wfc.17
	for <linux-dvb@linuxtv.org>; Tue, 10 Mar 2009 14:54:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <47310330903061303l338d5eb5nf3c8d4f3bcde0bdd@mail.gmail.com>
References: <47310330903061303l338d5eb5nf3c8d4f3bcde0bdd@mail.gmail.com>
Date: Tue, 10 Mar 2009 22:54:35 +0100
Message-ID: <47310330903101454h4fa1362axe2dbd61804093a76@mail.gmail.com>
From: "x04n 2.0" <x04n2.0@gmail.com>
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Patch for Yuan MC770 DVB-T (1164:0871)
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1254894739=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1254894739==
Content-Type: multipart/alternative; boundary=000e0cd28d78fc9c270464cacb7d

--000e0cd28d78fc9c270464cacb7d
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi,

I've recently buyed a Toshiba Qosmio F50-10Q with a Yuan MC770 DVB-T
(1164:0871) and I tried to make it work,
operation which ended quite satisfactory.

So i would like to share my patch with your team.

I'm running Linux kernel 2.6.28, using distro Debian Lenny and Kaffeine as a
TV viewer.

I've downloaded the actual status of the mercurial at
http://linuxtv.org/hg/v4l-dvb and modified the source to add this device.

So I compiled the drivers and did overwrite (make install) the current
kernel modules.

I placed the firmware files dvb-usb-dib0700-1.20.fw and xc3028-v27.fw in
/lib/firmware.

So now everything is working quite fine.

Best regards,

Xoan Loureiro (Vigo / Spain)

diff -r a4843e1304e6 linux/drivers/media/dvb/dvb-usb/dib0700_devices.c
--- a/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c    Sun Feb 22
18:00:00 2009 -0000
+++ b/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c    Sun Feb 22
18:00:00 2009 +0000
@@ -1419,6 +1419,7 @@ struct usb_device_id dib0700_usb_id_tabl
    { USB_DEVICE(USB_VID_TERRATEC,    USB_PID_TERRATEC_CINERGY_T_EXPRESS) },
    { USB_DEVICE(USB_VID_TERRATEC,
            USB_PID_TERRATEC_CINERGY_DT_XS_DIVERSITY_2) },
+    { USB_DEVICE(USB_VID_YUAN,    USB_PID_YUAN_MC770) },
     { 0 }        /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, dib0700_usb_id_table);
@@ -1729,7 +1730,7 @@ struct dvb_usb_device_properties dib0700
             },
         },

-        .num_device_descs = 5,
+        .num_device_descs = 7,
         .devices = {
             {   "Terratec Cinergy HT USB XE",
                 { &dib0700_usb_id_table[27], NULL },
@@ -1725,6 +1726,10 @@ struct dvb_usb_device_properties dib0700
                 { &dib0700_usb_id_table[39], NULL },
                 { NULL },
             },
+            {   "YUAN High-Tech MC770",
+                { &dib0700_usb_id_table[44], NULL },
+                { NULL },
+            },
         },
         .rc_interval      = DEFAULT_RC_INTERVAL,
         .rc_key_map       = dib0700_rc_keys,
diff -r a4843e1304e6 linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
--- a/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c    Sun Feb 22
18:00:00 2009 -0000
+++ b/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h    Sun Feb 22 18:00:00
2009 +0000
@@ -233,6 +232,7 @@
 #define USB_PID_ASUS_U3100                0x173f
 #define USB_PID_YUAN_EC372S                0x1edc
 #define USB_PID_YUAN_STK7700PH                0x1f08
+#define USB_PID_YUAN_MC770                0x0871
 #define USB_PID_DW2102                    0x2102
 #define USB_PID_XTENSIONS_XD_380            0x0381
 #define USB_PID_TELESTAR_STARSTICK_2            0x8000

Bus 007 Device 002: ID 1164:0871 YUAN High-Tech Development Co., Ltd
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  idVendor           0x1164 YUAN High-Tech Development Co., Ltd
  idProduct          0x0871
  bcdDevice            1.00
  iManufacturer           1 YUANRD
  iProduct                2 STK7700D
  iSerial                 3 0000000001
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           46
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0xa0
      (Bus Powered)
      Remote Wakeup
    MaxPower              500mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           4
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0
      bInterfaceProtocol      0
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x01  EP 1 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               1
Device Qualifier (for other device speed):
  bLength                10
  bDescriptorType         6
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  bNumConfigurations      1
Device Status:     0x0000
  (Bus Powered)

--000e0cd28d78fc9c270464cacb7d
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: base64

PGRpdiBjbGFzcz0iZ21haWxfcXVvdGUiPkhpLDxicj48YnI+SSYjMzk7dmUgcmVjZW50bHkgYnV5
ZWQgYSBUb3NoaWJhIFFvc21pbyBGNTAtMTBRIHdpdGggYSBZdWFuIE1DNzcwIERWQi1UICgxMTY0
OjA4NzEpIGFuZCBJIHRyaWVkIHRvIG1ha2UgaXQgd29yayw8YnI+b3BlcmF0aW9uIHdoaWNoIGVu
ZGVkIHF1aXRlIHNhdGlzZmFjdG9yeS48YnI+PGJyPlNvIGkgd291bGQgbGlrZSB0byBzaGFyZSBt
eSBwYXRjaCB3aXRoIHlvdXIgdGVhbS48YnI+Cgo8YnI+SSYjMzk7bSBydW5uaW5nIExpbnV4IGtl
cm5lbCAyLjYuMjgsIHVzaW5nIGRpc3RybyBEZWJpYW4gTGVubnkgYW5kIEthZmZlaW5lIGFzIGEg
VFYgdmlld2VyLjxicj48YnI+SSYjMzk7dmUgZG93bmxvYWRlZCB0aGUgYWN0dWFsIHN0YXR1cyBv
ZiB0aGUgbWVyY3VyaWFsIGF0IDxhIGhyZWY9Imh0dHA6Ly9saW51eHR2Lm9yZy9oZy92NGwtZHZi
IiB0YXJnZXQ9Il9ibGFuayI+aHR0cDovL2xpbnV4dHYub3JnL2hnL3Y0bC1kdmI8L2E+IGFuZCBt
b2RpZmllZCB0aGUgc291cmNlIHRvIGFkZCB0aGlzIGRldmljZS48YnI+Cgo8YnI+U28gSSBjb21w
aWxlZCB0aGUgZHJpdmVycyBhbmQgZGlkIG92ZXJ3cml0ZSAobWFrZSBpbnN0YWxsKSB0aGUgY3Vy
cmVudCBrZXJuZWwgbW9kdWxlcy48YnI+PGJyPkkgcGxhY2VkIHRoZSBmaXJtd2FyZSBmaWxlcyBk
dmItdXNiLWRpYjA3MDAtMS4yMC5mdyBhbmQgeGMzMDI4LXYyNy5mdyBpbiAvbGliL2Zpcm13YXJl
Ljxicj48YnI+U28gbm93IGV2ZXJ5dGhpbmcgaXMgd29ya2luZyBxdWl0ZSBmaW5lLjxicj4KCjxi
cj5CZXN0IHJlZ2FyZHMsPGJyPjxicj5Yb2FuIExvdXJlaXJvIChWaWdvIC8gU3BhaW4pPGJyPjxi
cj5kaWZmIC1yIGE0ODQzZTEzMDRlNiBsaW51eC9kcml2ZXJzL21lZGlhL2R2Yi9kdmItdXNiL2Rp
YjA3MDBfZGV2aWNlcy5jPGJyPi0tLSBhL2xpbnV4L2RyaXZlcnMvbWVkaWEvZHZiL2R2Yi11c2Iv
ZGliMDcwMF9kZXZpY2VzLmOgoKAgU3VuIEZlYiAyMiAxODowMDowMCAyMDA5IC0wMDAwPGJyPgoK
KysrIGIvbGludXgvZHJpdmVycy9tZWRpYS9kdmIvZHZiLXVzYi9kaWIwNzAwX2RldmljZXMuY6Cg
oCBTdW4gRmViIDIyIDE4OjAwOjAwIDIwMDkgKzAwMDA8YnI+QEAgLTE0MTksNiArMTQxOSw3IEBA
IHN0cnVjdCB1c2JfZGV2aWNlX2lkIGRpYjA3MDBfdXNiX2lkX3RhYmw8YnI+oKCgIHsgVVNCX0RF
VklDRShVU0JfVklEX1RFUlJBVEVDLKCgoCBVU0JfUElEX1RFUlJBVEVDX0NJTkVSR1lfVF9FWFBS
RVNTKSB9LDxicj4KCqCgoCB7IFVTQl9ERVZJQ0UoVVNCX1ZJRF9URVJSQVRFQyw8YnI+oKCgIKCg
oCCgoKAgVVNCX1BJRF9URVJSQVRFQ19DSU5FUkdZX0RUX1hTX0RJVkVSU0lUWV8yKSB9LDxicj4r
oKCgIHsgVVNCX0RFVklDRShVU0JfVklEX1lVQU4soKCgIFVTQl9QSURfWVVBTl9NQzc3MCkgfSw8
YnI+oKCgoCB7IDAgfaCgoCCgoKAgLyogVGVybWluYXRpbmcgZW50cnkgKi88YnI+oH07PGJyPqBN
T0RVTEVfREVWSUNFX1RBQkxFKHVzYiwgZGliMDcwMF91c2JfaWRfdGFibGUpOzxicj4KCkBAIC0x
NzI5LDcgKzE3MzAsNyBAQCBzdHJ1Y3QgZHZiX3VzYl9kZXZpY2VfcHJvcGVydGllcyBkaWIwNzAw
PGJyPqCgoKAgoKCgIKCgoCB9LDxicj6goKCgIKCgoCB9LDxicj6gPGJyPi2goKAgoKCgIC5udW1f
ZGV2aWNlX2Rlc2NzID0gNSw8YnI+K6CgoCCgoKAgLm51bV9kZXZpY2VfZGVzY3MgPSA3LDxicj6g
oKCgIKCgoCAuZGV2aWNlcyA9IHs8YnI+oKCgoCCgoKAgoKCgIHugoCAmcXVvdDtUZXJyYXRlYyBD
aW5lcmd5IEhUIFVTQiBYRSZxdW90Oyw8YnI+CgqgoKCgIKCgoCCgoKAgoKCgIHsgJmFtcDtkaWIw
NzAwX3VzYl9pZF90YWJsZVsyN10sIE5VTEwgfSw8YnI+QEAgLTE3MjUsNiArMTcyNiwxMCBAQCBz
dHJ1Y3QgZHZiX3VzYl9kZXZpY2VfcHJvcGVydGllcyBkaWIwNzAwPGJyPqCgoKAgoKCgIKCgoCCg
oKAgeyAmYW1wO2RpYjA3MDBfdXNiX2lkX3RhYmxlWzM5XSwgTlVMTCB9LDxicj6goKCgIKCgoCCg
oKAgoKCgIHsgTlVMTCB9LDxicj6goKCgIKCgoCCgoKAgfSw8YnI+CgoroKCgIKCgoCCgoKAge6Cg
ICZxdW90O1lVQU4gSGlnaC1UZWNoIE1DNzcwJnF1b3Q7LDxicj4roKCgIKCgoCCgoKAgoKCgIHsg
JmFtcDtkaWIwNzAwX3VzYl9pZF90YWJsZVs0NF0sIE5VTEwgfSw8YnI+K6CgoCCgoKAgoKCgIKCg
oCB7IE5VTEwgfSw8YnI+K6CgoCCgoKAgoKCgIH0sPGJyPqCgoKAgoKCgIH0sPGJyPqCgoKAgoKCg
IC5yY19pbnRlcnZhbKCgoKCgID0gREVGQVVMVF9SQ19JTlRFUlZBTCw8YnI+CgqgoKCgIKCgoCAu
cmNfa2V5X21hcKCgoKCgoCA9IGRpYjA3MDBfcmNfa2V5cyw8YnI+ZGlmZiAtciBhNDg0M2UxMzA0
ZTYgbGludXgvZHJpdmVycy9tZWRpYS9kdmIvZHZiLXVzYi9kdmItdXNiLWlkcy5oPGJyPi0tLSBh
L2xpbnV4L2RyaXZlcnMvbWVkaWEvZHZiL2R2Yi11c2IvZGliMDcwMF9kZXZpY2VzLmOgoKAgU3Vu
IEZlYiAyMiAxODowMDowMCAyMDA5IC0wMDAwPGJyPisrKyBiL2xpbnV4L2RyaXZlcnMvbWVkaWEv
ZHZiL2R2Yi11c2IvZHZiLXVzYi1pZHMuaKCgoCBTdW4gRmViIDIyIDE4OjAwOjAwIDIwMDkgKzAw
MDA8YnI+CgpAQCAtMjMzLDYgKzIzMiw3IEBAPGJyPqAjZGVmaW5lIFVTQl9QSURfQVNVU19VMzEw
MKCgoCCgoKAgoKCgIKCgoCAweDE3M2Y8YnI+oCNkZWZpbmUgVVNCX1BJRF9ZVUFOX0VDMzcyU6Cg
oCCgoKAgoKCgIKCgoCAweDFlZGM8YnI+oCNkZWZpbmUgVVNCX1BJRF9ZVUFOX1NUSzc3MDBQSKCg
oCCgoKAgoKCgIKCgoCAweDFmMDg8YnI+KyNkZWZpbmUgVVNCX1BJRF9ZVUFOX01DNzcwoKCgIKCg
oCCgoKAgoKCgIDB4MDg3MTxicj4KCqAjZGVmaW5lIFVTQl9QSURfRFcyMTAyoKCgIKCgoCCgoKAg
oKCgIKCgoCAweDIxMDI8YnI+oCNkZWZpbmUgVVNCX1BJRF9YVEVOU0lPTlNfWERfMzgwoKCgIKCg
oCCgoKAgMHgwMzgxPGJyPqAjZGVmaW5lIFVTQl9QSURfVEVMRVNUQVJfU1RBUlNUSUNLXzKgoKAg
oKCgIKCgoCAweDgwMDA8YnI+PGJyPkJ1cyAwMDcgRGV2aWNlIDAwMjogSUQgMTE2NDowODcxIFlV
QU4gSGlnaC1UZWNoIERldmVsb3BtZW50IENvLiwgTHRkIDxicj4KCkRldmljZSBEZXNjcmlwdG9y
OqCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgIDxicj6g
IGJMZW5ndGigoKCgoKCgoKCgoKCgoKAgMTigoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCg
oKCgoKCgoKCgoCA8YnI+oCBiRGVzY3JpcHRvclR5cGWgoKCgoKCgoCAxoKCgoKCgoKCgoKCgoKCg
oKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKAgPGJyPqAgYmNkVVNCoKCgoKCgoKCgoKCgoKAgMi4w
MKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgIDxicj4KCqAgYkRldmlj
ZUNsYXNzoKCgoKCgoKCgoKAgMCAoRGVmaW5lZCBhdCBJbnRlcmZhY2UgbGV2ZWwpoKCgoKCgoKCg
oKCgIDxicj6gIGJEZXZpY2VTdWJDbGFzc6CgoKCgoKCgIDCgoKCgoKCgoKCgoKCgoKCgoKCgoKCg
oKCgoKCgoKCgoKCgoKCgoKCgoCA8YnI+oCBiRGV2aWNlUHJvdG9jb2ygoKCgoKCgoCAwoKCgoKCg
oKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKAgPGJyPqAgYk1heFBhY2tldFNpemUw
oKCgoKCgoCA2NKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgIDxicj4K
CqAgaWRWZW5kb3KgoKCgoKCgoKCgIDB4MTE2NCBZVUFOIEhpZ2gtVGVjaCBEZXZlbG9wbWVudCBD
by4sIEx0ZKCgoKCgIDxicj6gIGlkUHJvZHVjdKCgoKCgoKCgoCAweDA4NzGgoKCgoKCgoKCgoKCg
oKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoCA8YnI+oCBiY2REZXZpY2WgoKCgoKCgoKCgoCAx
LjAwoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKAgPGJyPqAgaU1hbnVm
YWN0dXJlcqCgoKCgoKCgoKAgMSBZVUFOUkSgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCg
oKCgIDxicj4KCqAgaVByb2R1Y3SgoKCgoKCgoKCgoKCgoKAgMiBTVEs3NzAwRKCgoKCgoKCgoKCg
oKCgoKCgoKCgoKCgoKCgoKCgoKCgIDxicj6gIGlTZXJpYWygoKCgoKCgoKCgoKCgoKCgIDMgMDAw
MDAwMDAwMaCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoCA8YnI+oCBiTnVtQ29uZmlndXJh
dGlvbnOgoKCgoCAxoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKAgPGJy
PqAgQ29uZmlndXJhdGlvbiBEZXNjcmlwdG9yOqCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCg
oKCgoKCgoKCgoKCgIDxicj4KCqCgoCBiTGVuZ3RooKCgoKCgoKCgoKCgoKCgoCA5oKCgoKCgoKCg
oKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgIDxicj6goKAgYkRlc2NyaXB0b3JUeXBloKCg
oKCgoKAgMqCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoCA8YnI+oKCgIHdU
b3RhbExlbmd0aKCgoKCgoKCgoKAgNDagoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCg
oKCgoKAgPGJyPqCgoCBiTnVtSW50ZXJmYWNlc6CgoKCgoKCgoCAxoKCgoKCgoKCgoKCgoKCgoKCg
oKCgoKCgoKCgoKCgoKCgoKCgoKCgIDxicj4KCqCgoCBiQ29uZmlndXJhdGlvblZhbHVloKCgoCAx
oKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgIDxicj6goKAgaUNvbmZpZ3Vy
YXRpb26goKCgoKCgoKAgMKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoCA8
YnI+oKCgIGJtQXR0cmlidXRlc6CgoKCgoKCgIDB4YTCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCg
oKCgoKCgoKCgoKCgoKAgPGJyPqCgoKCgIChCdXMgUG93ZXJlZCmgoKCgoKCgoKCgoKCgoKCgoKCg
oKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgIDxicj4KCqCgoKCgIFJlbW90ZSBXYWtldXCg
oKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgIDxicj6goKAg
TWF4UG93ZXKgoKCgoKCgoKCgoKCgIDUwMG1BoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCg
oKCgoKCgoCA8YnI+oKCgIEludGVyZmFjZSBEZXNjcmlwdG9yOqCgoKCgoKCgoKCgoKCgoKCgoKCg
oKCgoKCgoKCgoKCgoKCgoKCgoKCgoKAgPGJyPqCgoKCgIGJMZW5ndGigoKCgoKCgoKCgoKCgoKCg
IDmgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgIDxicj4KCqCgoKCgIGJEZXNj
cmlwdG9yVHlwZaCgoKCgoKCgIDSgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCg
IDxicj6goKCgoCBiSW50ZXJmYWNlTnVtYmVyoKCgoKCgoCAwoKCgoKCgoKCgoKCgoKCgoKCgoKCg
oKCgoKCgoKCgoKCgoKCgoCA8YnI+oKCgoKAgYkFsdGVybmF0ZVNldHRpbmegoKCgoKAgMKCgoKCg
oKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKAgPGJyPqCgoKCgIGJOdW1FbmRwb2ludHOg
oKCgoKCgoKCgIDSgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgIDxicj4KCqCg
oKCgIGJJbnRlcmZhY2VDbGFzc6CgoKCgoCAyNTUgVmVuZG9yIFNwZWNpZmljIENsYXNzoKCgoKCg
oKCgoKCgoKCgIDxicj6goKCgoCBiSW50ZXJmYWNlU3ViQ2xhc3OgoKCgoCAwoKCgoKCgoKCgoKCg
oKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoCA8YnI+oKCgoKAgYkludGVyZmFjZVByb3RvY29soKCg
oKAgMKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKAgPGJyPqCgoKCgIGlJbnRl
cmZhY2WgoKCgoKCgoKCgoKCgIDCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCg
IDxicj4KCqCgoKCgIEVuZHBvaW50IERlc2NyaXB0b3I6oKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCg
oKCgoKCgoKCgoKCgoKCgoKCgIDxicj6goKCgoKCgIGJMZW5ndGigoKCgoKCgoKCgoKCgoKCgIDeg
oKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoCA8YnI+oKCgoKCgoCBiRGVzY3JpcHRv
clR5cGWgoKCgoKCgoCA1oKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKAgPGJyPqCg
oKCgoKAgYkVuZHBvaW50QWRkcmVzc6CgoKAgMHgwMaAgRVAgMSBPVVSgoKCgoKCgoKCgoKCgoKCg
oKCgoKCgoKCgIDxicj4KCqCgoKCgoKAgYm1BdHRyaWJ1dGVzoKCgoKCgoKCgoKAgMqCgoKCgoKCg
oKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgIDxicj6goKCgoKCgoKAgVHJhbnNmZXIgVHlwZaCg
oKCgoKCgoKCgIEJ1bGugoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoCA8YnI+oKCgoKCgoKCg
IFN5bmNoIFR5cGWgoKCgoKCgoKCgoKCgoCBOb25loKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCg
oKAgPGJyPqCgoKCgoKCgoCBVc2FnZSBUeXBloKCgoKCgoKCgoKCgoKAgRGF0YaCgoKCgoKCgoKCg
oKCgoKCgoKCgoKCgoKCgoKCgIDxicj4KCqCgoKCgoKAgd01heFBhY2tldFNpemWgoKCgIDB4MDIw
MKAgMXggNTEyIGJ5dGVzoKCgoKCgoKCgoKCgoKCgoKCgoKCgIDxicj6goKCgoKCgIGJJbnRlcnZh
bKCgoKCgoKCgoKCgoKCgIDGgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoCA8YnI+
oKCgoKAgRW5kcG9pbnQgRGVzY3JpcHRvcjqgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCg
oKCgoKCgoKCgoKAgPGJyPqCgoKCgoKAgYkxlbmd0aKCgoKCgoKCgoKCgoKCgoKAgNzxicj4KCqCg
oKCgoKAgYkRlc2NyaXB0b3JUeXBloKCgoKCgoKAgNTxicj6goKCgoKCgIGJFbmRwb2ludEFkZHJl
c3OgoKCgIDB4ODGgIEVQIDEgSU48YnI+oKCgoKCgoCBibUF0dHJpYnV0ZXOgoKCgoKCgoKCgoCAy
PGJyPqCgoKCgoKCgoCBUcmFuc2ZlciBUeXBloKCgoKCgoKCgoKAgQnVsazxicj6goKCgoKCgoKAg
U3luY2ggVHlwZaCgoKCgoKCgoKCgoKCgIE5vbmU8YnI+oKCgoKCgoKCgIFVzYWdlIFR5cGWgoKCg
oKCgoKCgoKCgoCBEYXRhPGJyPgoKoKCgoKCgoCB3TWF4UGFja2V0U2l6ZaCgoKAgMHgwMjAwoCAx
eCA1MTIgYnl0ZXM8YnI+oKCgoKCgoCBiSW50ZXJ2YWygoKCgoKCgoKCgoKCgoCAxPGJyPqCgoKCg
IEVuZHBvaW50IERlc2NyaXB0b3I6PGJyPqCgoKCgoKAgYkxlbmd0aKCgoKCgoKCgoKCgoKCgoKAg
Nzxicj6goKCgoKCgIGJEZXNjcmlwdG9yVHlwZaCgoKCgoKCgIDU8YnI+oKCgoKCgoCBiRW5kcG9p
bnRBZGRyZXNzoKCgoCAweDgyoCBFUCAyIElOPGJyPgoKoKCgoKCgoCBibUF0dHJpYnV0ZXOgoKCg
oKCgoKCgoCAyPGJyPqCgoKCgoKCgoCBUcmFuc2ZlciBUeXBloKCgoKCgoKCgoKAgQnVsazxicj6g
oKCgoKCgoKAgU3luY2ggVHlwZaCgoKCgoKCgoKCgoKCgIE5vbmU8YnI+oKCgoKCgoKCgIFVzYWdl
IFR5cGWgoKCgoKCgoKCgoKCgoCBEYXRhPGJyPqCgoKCgoKAgd01heFBhY2tldFNpemWgoKCgIDB4
MDIwMKAgMXggNTEyIGJ5dGVzPGJyPqCgoKCgoKAgYkludGVydmFsoKCgoKCgoKCgoKCgoKAgMTxi
cj4KCqCgoKCgIEVuZHBvaW50IERlc2NyaXB0b3I6PGJyPqCgoKCgoKAgYkxlbmd0aKCgoKCgoKCg
oKCgoKCgoKAgNzxicj6goKCgoKCgIGJEZXNjcmlwdG9yVHlwZaCgoKCgoKCgIDU8YnI+oKCgoKCg
oCBiRW5kcG9pbnRBZGRyZXNzoKCgoCAweDgzoCBFUCAzIElOPGJyPqCgoKCgoKAgYm1BdHRyaWJ1
dGVzoKCgoKCgoKCgoKAgMjxicj6goKCgoKCgoKAgVHJhbnNmZXIgVHlwZaCgoKCgoKCgoKCgIEJ1
bGs8YnI+CgqgoKCgoKCgoKAgU3luY2ggVHlwZaCgoKCgoKCgoKCgoKCgIE5vbmU8YnI+oKCgoKCg
oKCgIFVzYWdlIFR5cGWgoKCgoKCgoKCgoKCgoCBEYXRhPGJyPqCgoKCgoKAgd01heFBhY2tldFNp
emWgoKCgIDB4MDIwMKAgMXggNTEyIGJ5dGVzPGJyPqCgoKCgoKAgYkludGVydmFsoKCgoKCgoKCg
oKCgoKAgMTxicj5EZXZpY2UgUXVhbGlmaWVyIChmb3Igb3RoZXIgZGV2aWNlIHNwZWVkKTo8YnI+
CqAgYkxlbmd0aKCgoKCgoKCgoKCgoKCgoCAxMDxicj4KoCBiRGVzY3JpcHRvclR5cGWgoKCgoKCg
oCA2PGJyPqAgYmNkVVNCoKCgoKCgoKCgoKCgoKAgMi4wMDxicj6gIGJEZXZpY2VDbGFzc6CgoKCg
oKCgoKCgIDAgKERlZmluZWQgYXQgSW50ZXJmYWNlIGxldmVsKTxicj6gIGJEZXZpY2VTdWJDbGFz
c6CgoKCgoKCgIDA8YnI+oCBiRGV2aWNlUHJvdG9jb2ygoKCgoKCgoCAwPGJyPqAgYk1heFBhY2tl
dFNpemUwoKCgoKCgoCA2NDxicj6gIGJOdW1Db25maWd1cmF0aW9uc6CgoKCgIDE8YnI+CgpEZXZp
Y2UgU3RhdHVzOqCgoKAgMHgwMDAwPGJyPqAgKEJ1cyBQb3dlcmVkKTxicj48YnI+CjwvZGl2Pjxi
cj4K
--000e0cd28d78fc9c270464cacb7d--


--===============1254894739==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1254894739==--
