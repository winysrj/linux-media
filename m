Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:46038 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751256AbZEXLlR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 24 May 2009 07:41:17 -0400
Message-ID: <4A193230.3040205@gmx.de>
Date: Sun, 24 May 2009 13:40:32 +0200
From: Stefan Below <stefanbelow@gmx.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: CPen driver development / image format
Content-Type: multipart/mixed;
 boundary="------------020509090700040105020603"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020509090700040105020603
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

i have a nice penscanner (CPEN-20, like Iris pen) and i am trying to 
write a driver for it.
Everything runs fine, except that i have no clue what kind of image 
format i receive.

The penscanner has a little camera (i think its only gray or bw camera).

additional technical informations from the CPEN website:
   Image Resolution: Grayscale 330 DPI
   Scan Area Size: 10 x 6 mm



Here is the first part from the transfered image (cutout from usb-sniff 
output):
[547050 ms]  <<<  URB 499 coming back  <<< -- 
URB_FUNCTION_BULK_OR_INTERRUPT_TRANSFER:
PipeHandle           = 88a69984 [endpoint 0x00000082]
TransferFlags        = 00000003 (USBD_TRANSFER_DIRECTION_IN, 
USBD_SHORT_TRANSFER_OK)
TransferBufferLength = 000001ee
TransferBuffer       = 88be9be0
TransferBufferMDL    = 889b77a8
 00000000: 02 01 08 01 00 20 23 78 b5 20 00 00 00 00 80 00
 00000010: 50 00 03 00 d8 01 80 71 f1 ff df ff 88 11 51 f1
 00000020: ff df ff 88 71 f2 ff cf ff f8 ff ff 0f ff f8 ff
 00000030: ff 0f ff f8 ff ff 0f ff f8 ff ff 0f ff f8 ff ff
 00000040: 0f ff f8 12 18 25 ff bf ff f8 12 ff ff fc 8f 2f
 00000050: f1 ff cf ff 18 f1 ff ff fd 8f 18 ff ff 6f ff f8
 00000060: ff ff 0f ff f8 ff ff 0f ff f8 ff ff 0f ff 28 c2
 00000070: 44 54 53 f1 ff f3 8f 1f 81 71 62 f2 ff f2 8f 1f
 00000080: f1 1a ff 2f ff 88 f1 15 ff ff f0 8f ff ff ff f0
 00000090: 8f ff ff ff f0 8f 1f f2 ff cf ff f8 ff 11 ff fd
 000000a0: 8f 1f 31 a1 82 51 f1 cf ff f8 1a ff ff f4 8f ff
 000000b0: 1d ff 1f ff f8 ff ff 0f ff f8 ff ff 0f ff f8 ff
 000000c0: ff 0f ff f8 ff ff 0f ff f8 ff ff 0f ff f8 ff ff
 000000d0: 0f ff f8 ff ff 0f ff f8 ff ff 0f ff a8 f1 ff ff
 000000e0: f4 8f ff ff ff f0 8f ff ff ff f0 8f ff ff ff f0
 000000f0: 8f ff ff ff f0 8f ff ff ff f0 8f ff ff ff f0 8f
 00000100: ff ff ff f0 8f ff ff ff f0 8f ff ff ff f0 8f ff
 00000110: ff ff f0 8f ff ff ff f0 8f ff ff ff f0 8f ff ff
 00000120: ff f0 8f ff ff ff f0 9f ff ff ef ff fa ff ff fd
 00000130: 8f 13 14 ff ff 6f ff f8 ff ff 0f ff f9 ff ff fe
 00000140: 8f ff ff ff f0 8f 12 ff ff cf ff 88 f1 ff ff f6
 00000150: 8f 13 14 ff ff 6f ff 28 f2 ff ff fb 8f 22 ff ff
 00000160: bf ff f9 ff ff fe bf 11 23 ff ff 5f ff 3d 21 f1
 00000170: ff ff f3 cf 12 51 14 ff ff fc 8f 42 32 16 ff ff
 00000180: fc ff 44 f3 ff cf ff 2d 26 f3 ff cf ff 0f 41 33
 00000190: 11 0f f1 ff f9 cf 64 12 22 13 ff ff f5 cf 12 41
 000001a0: 14 12 16 ff ff f3 df 11 41 23 ff ff fd df 33 ff
 000001b0: ff 4f ff 3d 22 31 f1 ff df ff 3d 92 f2 ff 9f ff
 000001c0: 3d 35 21 81 f1 ff 1f ff 2e 12 41 22 41 f2 ff 3f
 000001d0: ff 1d 11 44 27 f3 ff 2f ff 1d 11 32 21 65 32 f1
 000001e0: ff fc ff 27 13 31 31 61 f1 ff f9 8f f1 ff
UrbLink              = 00000000
[547050 ms] UsbSnoop - DispatchAny(b5572610) : 
IRP_MJ_INTERNAL_DEVICE_CONTROL

The first 0x16 bytes should be a header.

I attached the image output from windows and the whole usb sniff logfile.


I hope someone can help me to :-)

Stefan

--------------020509090700040105020603
Content-Type: image/x-portable-bitmap;
 name="testn_crop.pbm"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="testn_crop.pbm"

UDQKIyBDUkVBVE9SOiBHSU1QIFBOTSBGaWx0ZXIgVmVyc2lvbiAxLjEKNDIgMTM4CgAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAP+AAAAAAP/////AAP//////wP//////wP//////
wP//////wP//////wP//////wP//////wP//////wP//////wP//////wP//////wP//////
wP//////wP//////wP//////wP//////wP//////wP//////wP//////wP//////wP//////
wP//////wP//////wP//////wP//////wP//////wP//////wP//////wP//////wP//////
wP//////wP//////wP//////wP//////wP//////wP//////wP//////wP//////wP//////
wP//////wP//////wP//////wP//////wP//////wP//////wP//////wP//////wP//////
wP//////gP//////gP//////wP//////QP//////gP//////gP//////AP/////+AP/////+
AP/////+AP//////AP//////AP/////+AP/////+AP/////+AP/////+AP/////+AP/////+
AP/////+AP/////+AP/////+AP/////+AP/////+AP/////+AP/////+AP/////wAP/////8
AP/////8AP/////8AP/////8AP/////8AP/////8AP/////8AP/////wAP/////8AP/////8
AP/////8AP/////+AP/////8AP/////8AP/////8AAH////8AAAP//2/AAAAAAAPAAAAAAAM
AAAAAAAMAAAAAAAAAA==
--------------020509090700040105020603
Content-Type: text/x-log;
 name="usbsnoop_testn.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="usbsnoop_testn.log"

[547017 ms]  <<<  URB 497 coming back  <<< 
-- URB_FUNCTION_BULK_OR_INTERRUPT_TRANSFER:
  PipeHandle           = 88a69984 [endpoint 0x00000082]
  TransferFlags        = 00000003 (USBD_TRANSFER_DIRECTION_IN, USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000006
  TransferBuffer       = 88be9be0
  TransferBufferMDL    = 889b77a8
    00000000: 02 01 08 01 01 20
  UrbLink              = 00000000
[547017 ms] UsbSnoop - DispatchAny(b5572610) : IRP_MJ_INTERNAL_DEVICE_CONTROL
[547017 ms] UsbSnoop - MyDispatchInternalIOCTL(b5573e80) : fdo=88b11400, Irp=889b46b0, IRQL=2
[547017 ms]  >>>  URB 498 going down  >>> 
-- URB_FUNCTION_BULK_OR_INTERRUPT_TRANSFER:
  PipeHandle           = 88a69984 [endpoint 0x00000082]
  TransferFlags        = 00000003 (USBD_TRANSFER_DIRECTION_IN, USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 0000041c
  TransferBuffer       = 88be9be0
  TransferBufferMDL    = 00000000
  UrbLink              = 00000000
[547019 ms] UsbSnoop - MyInternalIOCTLCompletion(b5573db0) : fido=00000000, Irp=889b46b0, Context=88b3f208, IRQL=2
[547019 ms]  <<<  URB 498 coming back  <<< 
-- URB_FUNCTION_BULK_OR_INTERRUPT_TRANSFER:
  PipeHandle           = 88a69984 [endpoint 0x00000082]
  TransferFlags        = 00000003 (USBD_TRANSFER_DIRECTION_IN, USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000007
  TransferBuffer       = 88be9be0
  TransferBufferMDL    = 889b77a8
    00000000: 02 01 08 01 00 30 01
  UrbLink              = 00000000
[547019 ms] UsbSnoop - DispatchAny(b5572610) : IRP_MJ_INTERNAL_DEVICE_CONTROL
[547019 ms] UsbSnoop - MyDispatchInternalIOCTL(b5573e80) : fdo=88b11400, Irp=889b46b0, IRQL=2
[547019 ms]  >>>  URB 499 going down  >>> 
-- URB_FUNCTION_BULK_OR_INTERRUPT_TRANSFER:
  PipeHandle           = 88a69984 [endpoint 0x00000082]
  TransferFlags        = 00000003 (USBD_TRANSFER_DIRECTION_IN, USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 0000041c
  TransferBuffer       = 88be9be0
  TransferBufferMDL    = 00000000
  UrbLink              = 00000000
[547050 ms] UsbSnoop - MyInternalIOCTLCompletion(b5573db0) : fido=00000000, Irp=889b46b0, Context=88bc4040, IRQL=2
[547050 ms]  <<<  URB 499 coming back  <<< 
-- URB_FUNCTION_BULK_OR_INTERRUPT_TRANSFER:
  PipeHandle           = 88a69984 [endpoint 0x00000082]
  TransferFlags        = 00000003 (USBD_TRANSFER_DIRECTION_IN, USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 000001ee
  TransferBuffer       = 88be9be0
  TransferBufferMDL    = 889b77a8
    00000000: 02 01 08 01 00 20 23 78 b5 20 00 00 00 00 80 00
    00000010: 50 00 03 00 d8 01 80 71 f1 ff df ff 88 11 51 f1
    00000020: ff df ff 88 71 f2 ff cf ff f8 ff ff 0f ff f8 ff
    00000030: ff 0f ff f8 ff ff 0f ff f8 ff ff 0f ff f8 ff ff
    00000040: 0f ff f8 12 18 25 ff bf ff f8 12 ff ff fc 8f 2f
    00000050: f1 ff cf ff 18 f1 ff ff fd 8f 18 ff ff 6f ff f8
    00000060: ff ff 0f ff f8 ff ff 0f ff f8 ff ff 0f ff 28 c2
    00000070: 44 54 53 f1 ff f3 8f 1f 81 71 62 f2 ff f2 8f 1f
    00000080: f1 1a ff 2f ff 88 f1 15 ff ff f0 8f ff ff ff f0
    00000090: 8f ff ff ff f0 8f 1f f2 ff cf ff f8 ff 11 ff fd
    000000a0: 8f 1f 31 a1 82 51 f1 cf ff f8 1a ff ff f4 8f ff
    000000b0: 1d ff 1f ff f8 ff ff 0f ff f8 ff ff 0f ff f8 ff
    000000c0: ff 0f ff f8 ff ff 0f ff f8 ff ff 0f ff f8 ff ff
    000000d0: 0f ff f8 ff ff 0f ff f8 ff ff 0f ff a8 f1 ff ff
    000000e0: f4 8f ff ff ff f0 8f ff ff ff f0 8f ff ff ff f0
    000000f0: 8f ff ff ff f0 8f ff ff ff f0 8f ff ff ff f0 8f
    00000100: ff ff ff f0 8f ff ff ff f0 8f ff ff ff f0 8f ff
    00000110: ff ff f0 8f ff ff ff f0 8f ff ff ff f0 8f ff ff
    00000120: ff f0 8f ff ff ff f0 9f ff ff ef ff fa ff ff fd
    00000130: 8f 13 14 ff ff 6f ff f8 ff ff 0f ff f9 ff ff fe
    00000140: 8f ff ff ff f0 8f 12 ff ff cf ff 88 f1 ff ff f6
    00000150: 8f 13 14 ff ff 6f ff 28 f2 ff ff fb 8f 22 ff ff
    00000160: bf ff f9 ff ff fe bf 11 23 ff ff 5f ff 3d 21 f1
    00000170: ff ff f3 cf 12 51 14 ff ff fc 8f 42 32 16 ff ff
    00000180: fc ff 44 f3 ff cf ff 2d 26 f3 ff cf ff 0f 41 33
    00000190: 11 0f f1 ff f9 cf 64 12 22 13 ff ff f5 cf 12 41
    000001a0: 14 12 16 ff ff f3 df 11 41 23 ff ff fd df 33 ff
    000001b0: ff 4f ff 3d 22 31 f1 ff df ff 3d 92 f2 ff 9f ff
    000001c0: 3d 35 21 81 f1 ff 1f ff 2e 12 41 22 41 f2 ff 3f
    000001d0: ff 1d 11 44 27 f3 ff 2f ff 1d 11 32 21 65 32 f1
    000001e0: ff fc ff 27 13 31 31 61 f1 ff f9 8f f1 ff
  UrbLink              = 00000000
[547050 ms] UsbSnoop - DispatchAny(b5572610) : IRP_MJ_INTERNAL_DEVICE_CONTROL
[547050 ms] UsbSnoop - MyDispatchInternalIOCTL(b5573e80) : fdo=88b11400, Irp=889b46b0, IRQL=2
[547050 ms]  >>>  URB 500 going down  >>> 
-- URB_FUNCTION_BULK_OR_INTERRUPT_TRANSFER:
  PipeHandle           = 88a69984 [endpoint 0x00000082]
  TransferFlags        = 00000003 (USBD_TRANSFER_DIRECTION_IN, USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 0000041c
  TransferBuffer       = 88be9be0
  TransferBufferMDL    = 00000000
  UrbLink              = 00000000
[547061 ms] UsbSnoop - MyInternalIOCTLCompletion(b5573db0) : fido=00000000, Irp=889b46b0, Context=88bf3b28, IRQL=2
[547061 ms]  <<<  URB 500 coming back  <<< 
-- URB_FUNCTION_BULK_OR_INTERRUPT_TRANSFER:
  PipeHandle           = 88a69984 [endpoint 0x00000082]
  TransferFlags        = 00000003 (USBD_TRANSFER_DIRECTION_IN, USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 0000024e
  TransferBuffer       = 88be9be0
  TransferBufferMDL    = 889b77a8
    00000000: 02 01 08 01 00 20 d9 97 b5 20 00 00 00 00 80 00
    00000010: 50 00 03 00 38 02 80 23 21 34 11 11 f1 ff 2f ff
    00000020: 3d 26 34 f1 ff 6f ff 19 42 11 14 11 f2 ff bf ff
    00000030: 1a 41 32 21 f4 ff af ff 38 32 31 31 f1 ff df ff
    00000040: 39 31 21 f2 ff ff f2 8f 11 ff ff df ff 18 f1 10
    00000050: ff ff fc 8f 11 21 12 22 35 54 13 12 21 14 11 ff
    00000060: fe 8f 41 13 12 24 25 31 14 14 ff 6f ff 18 34 53
    00000070: 53 11 21 41 f3 ff f8 cf 14 27 11 14 21 14 13 1a
    00000080: ff fc af 11 14 27 16 11 11 ff ff f1 9f 13 14 11
    00000090: 15 16 ff ff f5 8f 11 ff 13 ff 9f ff 18 f1 17 11
    000000a0: ff ff f3 8f 41 13 21 11 12 51 41 13 31 34 14 ff
    000000b0: fc 8f 11 11 24 11 12 21 12 14 12 34 13 21 11 ff
    000000c0: 0f ff 28 81 41 d2 21 62 31 f1 df ff 28 42 63 62
    000000d0: 21 81 63 31 f1 9f ff 98 52 71 81 f1 ff fb 8f 29
    000000e0: 15 19 15 ff cf ff f8 21 ff ff fc 8f 18 18 df f1
    000000f0: df ff f8 20 22 14 25 28 ff 2f ff f8 13 16 ff ff
    00000100: f4 8f 28 5f 21 91 f1 ff f1 8f 29 ff ff 4f ff f8
    00000110: 11 ff ff fd 8f 1b ff ff 3f ff f8 ff ff 0f ff a8
    00000120: f1 12 ff ff f1 8f ff 12 ff cf ff f8 ff ff 0f ff
    00000130: f8 ff ff 0f ff a8 f1 ff ff f4 8f ff ff ff f0 8f
    00000140: ff ff ff f0 8f ff ff ff f0 8f ff ff ff f0 8f ff
    00000150: ff ff f0 8f ff ff ff f0 8f ff ff ff f0 8f ff ff
    00000160: ff f0 8f ff ff ff f0 8f ff ff ff f0 8f ff ff ff
    00000170: f0 8f ff ff ff f0 8f 11 ff ff df ff f8 ff ff 0f
    00000180: ff fa ff ff fd af ff ff df ff 38 f2 ff ff fa 8f
    00000190: 11 26 ff ff 5f ff 39 f1 ff ff fa af 21 ff ff af
    000001a0: ff 1c 12 f1 ff ff f6 8f 14 23 ff ff 5f ff 28 33
    000001b0: f1 ff ff f6 8f 51 12 ff ff 6f ff 28 33 f1 ff ff
    000001c0: f6 9f 41 12 12 ff ff 3f ff 0f 31 11 23 ff ff fc
    000001d0: ff 10 35 f1 ff df ff 6f 11 21 ff ff fc ff 37 f1
    000001e0: ff cf ff 5f 61 15 ff ff f5 ff 1c a1 f1 ff fd ff
    000001f0: 1c 31 f2 ff 4f ff 1c 1f 11 21 11 ff ff f2 ff 16
    00000200: 14 12 21 f2 ff 3f ff 0f 51 71 33 ff ff f3 ff a7
    00000210: 21 f1 ff 2f ff 0f a1 12 33 ff ff f3 df 52 21 21
    00000220: 21 33 22 ff ef ff 1d 11 4d f3 ff 2f ff 0f a1 31
    00000230: 32 11 ff ff f1 ff 18 17 24 21 51 f1 ff f5 df f1
    00000240: 12 25 f1 ff fd ff 0f 32 41 ff df ff 48 ff
  UrbLink              = 00000000
[547061 ms] UsbSnoop - DispatchAny(b5572610) : IRP_MJ_INTERNAL_DEVICE_CONTROL
[547061 ms] UsbSnoop - MyDispatchInternalIOCTL(b5573e80) : fdo=88b11400, Irp=889b46b0, IRQL=2
[547061 ms]  >>>  URB 501 going down  >>> 
-- URB_FUNCTION_BULK_OR_INTERRUPT_TRANSFER:
  PipeHandle           = 88a69984 [endpoint 0x00000082]
  TransferFlags        = 00000003 (USBD_TRANSFER_DIRECTION_IN, USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 0000041c
  TransferBuffer       = 88be9be0
  TransferBufferMDL    = 00000000
  UrbLink              = 00000000
[547072 ms] UsbSnoop - MyInternalIOCTLCompletion(b5573db0) : fido=00000000, Irp=889b46b0, Context=89b05130, IRQL=2
[547072 ms]  <<<  URB 501 coming back  <<< 
-- URB_FUNCTION_BULK_OR_INTERRUPT_TRANSFER:
  PipeHandle           = 88a69984 [endpoint 0x00000082]
  TransferFlags        = 00000003 (USBD_TRANSFER_DIRECTION_IN, USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000252
  TransferBuffer       = 88be9be0
  TransferBufferMDL    = 889b77a8
    00000000: 02 01 08 01 00 20 7e b7 b5 20 00 00 00 00 80 00
    00000010: 50 00 03 00 3c 02 80 23 12 15 29 12 43 f1 ff f1
    00000020: ef 81 61 41 11 24 ff af ff 1d 13 2c f3 ff 3f ff
    00000030: 1e 23 22 26 21 f1 ff 2f ff 3f 31 32 11 12 ff ff
    00000040: f6 9f 32 12 31 23 ff ff fc df 11 11 37 15 ff ff
    00000050: f5 8f 21 15 23 14 ff ff fb ff 11 16 16 18 f5 ff
    00000060: f8 8f 41 11 21 11 f2 20 11 11 f2 ff f8 ff 36 25
    00000070: 24 51 f1 ff f9 cf 53 54 13 31 15 1c ff fc df 23
    00000080: 11 63 33 11 22 ff cf ff 1a 14 12 21 21 11 41 12
    00000090: 61 f1 ff fa af 12 14 11 15 31 42 11 15 ff 9f ff
    000000a0: 18 22 41 72 41 11 f1 ff 3f ff 3d 5f 13 31 15 ff
    000000b0: 3f ff 18 14 11 12 12 38 11 42 42 11 f2 ff f2 8f
    000000c0: 31 14 31 53 24 12 34 15 13 ff fd 8f 22 53 11 52
    000000d0: 23 32 16 11 11 ff 3f ff 38 41 15 73 22 22 f1 ff
    000000e0: fc 8f 29 11 23 18 13 ff ef ff 98 61 e2 f1 ff fc
    000000f0: 8f 18 12 33 13 19 1e ff fd 8f 18 14 21 32 32 33
    00000100: 13 ff 8f ff f8 20 11 11 24 13 ff ef ff 88 f2 12
    00000110: 12 ff ef ff 98 c2 f1 ff 6f ff f8 11 16 ff ff f6
    00000120: 8f 1f f1 ff df ff f8 ff ff 0f ff a8 f1 ff ff f4
    00000130: 8f 1a 6f f1 ff fc 8f ff ff ff f0 8f 1b 19 ff ff
    00000140: f8 8f 1a ff ff 4f ff f8 ff ff 0f ff f8 ff ff 0f
    00000150: ff f8 ff ff 0f ff f8 ff ff 0f ff c8 f1 ff ff f2
    00000160: 8f ff ff ff f0 8f ff ff ff f0 8f ff ff ff f0 8f
    00000170: 1a ff ff 4f ff f8 ff ff 0f ff f8 ff ff 0f ff 48
    00000180: f1 ff ff fa 8f 11 19 ff ff 3f ff f8 ff ff 0f ff
    00000190: 9a f1 ff ff f3 af ff ff df ff 1a 12 11 f1 ff ff
    000001a0: f6 8f 11 11 21 11 ff ff 6f ff 19 71 f1 ff ff f4
    000001b0: af 41 ff ff 8f ff 0f ff ff 8f ff 1b f8 ff ff f3
    000001c0: 8f 72 ff ff 6f ff 2e 11 f1 ff ff f4 8f 42 12 11
    000001d0: ff ff 4f ff 2f 12 14 ff ff fd ff 10 13 22 f2 ff
    000001e0: cf ff 0f 71 21 11 ff ff fa ff fb ff cf ff 9f 21
    000001f0: ff ff fb ff 5c f1 ff 5f ff cf 11 ff ff f9 ff 1e
    00000200: f5 ff 3f ff ef 12 11 11 ff ff f2 ff 16 14 22 15
    00000210: f2 ff fe ff 1e 11 f4 ff 2f ff 9f 11 21 13 12 ff
    00000220: ff f2 ff 1b 32 21 f1 ff 2f ff 1e 2e 14 f3 ff fe
    00000230: ff 9f ff ef ff 0f f1 f7 ff 0f ff ff 47 41 f1 ff
    00000240: f6 ff 1f 61 13 ff bf ff ff 10 13 f4 ff fe 8f f4
    00000250: ff fe
  UrbLink              = 00000000
[547072 ms] UsbSnoop - DispatchAny(b5572610) : IRP_MJ_INTERNAL_DEVICE_CONTROL
[547072 ms] UsbSnoop - MyDispatchInternalIOCTL(b5573e80) : fdo=88b11400, Irp=889b46b0, IRQL=2
[547072 ms]  >>>  URB 502 going down  >>> 
-- URB_FUNCTION_BULK_OR_INTERRUPT_TRANSFER:
  PipeHandle           = 88a69984 [endpoint 0x00000082]
  TransferFlags        = 00000003 (USBD_TRANSFER_DIRECTION_IN, USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 0000041c
  TransferBuffer       = 88be9be0
  TransferBufferMDL    = 00000000
  UrbLink              = 00000000
[547083 ms] UsbSnoop - MyInternalIOCTLCompletion(b5573db0) : fido=00000000, Irp=889b46b0, Context=89a4d9c8, IRQL=2
[547083 ms]  <<<  URB 502 coming back  <<< 
-- URB_FUNCTION_BULK_OR_INTERRUPT_TRANSFER:
  PipeHandle           = 88a69984 [endpoint 0x00000082]
  TransferFlags        = 00000003 (USBD_TRANSFER_DIRECTION_IN, USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 0000025a
  TransferBuffer       = 88be9be0
  TransferBufferMDL    = 889b77a8
    00000000: 02 01 08 01 00 20 16 d7 b5 20 00 00 00 00 80 00
    00000010: 50 00 03 00 44 02 80 ff 32 f1 ff f1 ff ef 41 32
    00000020: 11 ff fc ff 8f 11 21 32 17 ff fc ff 8f 11 51 15
    00000030: ff 1f ff 8f f1 21 33 f1 ff f4 9f d1 31 21 71 14
    00000040: ff af ff 0f 71 31 12 41 13 ff ef ff 3f 41 31 12
    00000050: 41 21 15 ff 9f ff ff 10 0f 11 32 ff 0f ff ff 2f
    00000060: 13 11 12 ff fc ff 8f 21 51 24 12 ff fc cf 71 11
    00000070: 52 31 b1 21 26 ff fc ff 10 12 13 16 0f ff 8f ff
    00000080: 1a 14 8f 22 11 ff 8f ff 1e 16 14 19 51 a1 f1 df
    00000090: ff 18 12 12 12 4f 22 12 1b ff fc ff 10 ff 10 14
    000000a0: f1 ff f0 8f 61 f1 13 12 21 12 12 11 22 f1 ef ff
    000000b0: 18 5f 42 21 11 32 22 11 ff 2f ff 28 22 16 29 38
    000000c0: 11 13 51 f1 cf ff 19 33 15 19 5a f1 ff f5 8f 22
    000000d0: 65 41 14 51 11 ff cf ff 18 31 21 16 24 11 61 11
    000000e0: f1 ff fc 8f 13 24 11 11 41 21 13 25 1d ff fd 8f
    000000f0: 57 a1 41 11 31 12 15 14 ff fc 8f 16 12 22 61 a3
    00000100: 18 14 ff fc 9f 37 22 11 11 23 4f f1 ff f1 8f 38
    00000110: 11 22 21 13 11 24 ff df ff a8 42 42 f3 ff 5f ff
    00000120: b8 31 53 f1 ff 6f ff b8 22 61 f1 ff 7f ff f8 1d
    00000130: ff ff f1 8f 2a 11 1b 12 ff ff f1 8f 1a 15 14 14
    00000140: ff ff f3 8f 13 27 13 14 ff ff f8 8f 1a 12 12 ff
    00000150: ff fd 8f 1a ff ff 4f ff b8 f1 ff ff f3 8f ff ff
    00000160: ff f0 8f ff ff ff f0 8f ff ff ff f0 8f 2c ff ff
    00000170: 1f ff f8 ff ff 0f ff 68 f2 ff ff f7 8f 2a ff ff
    00000180: 3f ff a8 f1 ff ff f4 8f 1a ff ff 4f ff 48 f2 ff
    00000190: ff f9 8f 11 16 12 ff ff 3f ff f8 ff ff 0f ff 1a
    000001a0: 41 21 f1 ff ff f3 af 23 ff ff 8f ff 0f 11 31 ff
    000001b0: ff 2f ff 18 11 f6 ff ff f6 ef 11 21 21 ff ff 1f
    000001c0: ff 1f 12 11 ff ff 2f ff 4f ff ff 4f ff 5f ff ff
    000001d0: 3f ff 18 fc ff ff f2 ff 14 21 f1 ff ef ff 18 15
    000001e0: 24 f2 ff ff f0 ff 13 f6 ff df ff bf ff ff fc ff
    000001f0: 10 17 12 11 f1 ff 8f ff df ff ff fa ff 3c 31 f1
    00000200: ff 3f ff ff 11 f2 ff 4f ff ff 10 21 22 f1 ff fe
    00000210: ff 5f 13 ff ef ff ff 21 f3 ff 2f ff ff 16 f2 ff
    00000220: fe ff 1f 21 21 12 ff df ff ef 31 22 ff ff f1 ff
    00000230: 1e f6 ff 2f ff ff 10 16 f1 ff fe ff 9f ff ef ff
    00000240: ff 12 f5 ff 0f ff ff 38 f1 ff fb ff 8f 11 ff df
    00000250: ff ff 19 f1 ff fc 8f f1 ff fc
  UrbLink              = 00000000
[547083 ms] UsbSnoop - DispatchAny(b5572610) : IRP_MJ_INTERNAL_DEVICE_CONTROL
[547083 ms] UsbSnoop - MyDispatchInternalIOCTL(b5573e80) : fdo=88b11400, Irp=889b46b0, IRQL=2
[547083 ms]  >>>  URB 503 going down  >>> 
-- URB_FUNCTION_BULK_OR_INTERRUPT_TRANSFER:
  PipeHandle           = 88a69984 [endpoint 0x00000082]
  TransferFlags        = 00000003 (USBD_TRANSFER_DIRECTION_IN, USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 0000041c
  TransferBuffer       = 88be9be0
  TransferBufferMDL    = 00000000
  UrbLink              = 00000000
[547093 ms] UsbSnoop - MyInternalIOCTLCompletion(b5573db0) : fido=00000000, Irp=889b46b0, Context=88a7f6d0, IRQL=2
[547093 ms]  <<<  URB 503 coming back  <<< 
-- URB_FUNCTION_BULK_OR_INTERRUPT_TRANSFER:
  PipeHandle           = 88a69984 [endpoint 0x00000082]
  TransferFlags        = 00000003 (USBD_TRANSFER_DIRECTION_IN, USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000236
  TransferBuffer       = 88be9be0
  TransferBufferMDL    = 889b77a8
    00000000: 02 01 08 01 00 20 bb f6 b5 20 00 00 00 00 80 00
    00000010: 50 00 03 00 20 02 80 ff 11 12 f1 ff f2 ff ff 23
    00000020: 22 f1 df ff ff 19 13 f2 ff f6 ff ff 11 71 f1 df
    00000030: ff ff 18 11 23 f1 ff f6 ff af 21 ff af ff ff 28
    00000040: f1 ff fc ff 17 1b 42 f3 ff f8 ff ff 13 13 f3 df
    00000050: ff ff 2f 21 11 12 ff fd ff af 31 21 14 ff 0f ff
    00000060: ff 2f 15 12 ff fc ff 13 13 7f 11 24 12 ff fd ef
    00000070: f1 18 f4 ff fa ff 8f 23 21 ff 7f ff 1f f1 f8 ff
    00000080: fd ff ef 21 41 21 ff fd ff 6f 21 21 21 11 21 ff
    00000090: 3f ff 17 ff 44 21 f1 ff f2 8f 22 f2 3a 31 f2 ff
    000000a0: f5 9f 31 f1 15 29 f2 ff f6 7f 31 11 63 51 91 21
    000000b0: 19 ff 2f ff 17 11 11 21 1f 42 12 ff cf ff 18 11
    000000c0: 12 11 12 1c 52 11 c1 f1 ef ff 1a 11 14 1c 2a f1
    000000d0: ff f9 7f f6 12 14 f4 ff fd 8f 28 42 21 52 11 21
    000000e0: 12 ff af ff 88 43 12 22 12 41 f2 ff fe 7f 2a 33
    000000f0: 13 41 ff ff f4 7f 17 32 51 23 ff ff f7 7f 3a 32
    00000100: 14 17 ff ef ff 98 51 71 11 f1 ff 5f ff a7 22 81
    00000110: f3 ff 4f ff 98 12 22 41 31 f2 ff 4f ff a7 33 41
    00000120: b1 f1 ff fc 7f 18 21 12 11 1a ff ff f3 7f 2a 1a
    00000130: ff ff f8 7f 18 12 ff ff 4f ff a7 f1 ff ff f5 7f
    00000140: ff ff ff f0 8f ff ff ff f0 8f 16 12 22 ff ff 2f
    00000150: ff d7 f1 ff ff f2 7f 26 ff ff 8f ff 67 11 11 11
    00000160: f1 ff ff f3 7f 18 21 ff ff 4f ff 87 11 f1 ff ff
    00000170: f5 7f 24 32 ff ff 5f ff 29 52 f1 ff ff f4 7f 21
    00000180: 13 14 ff ff 4f ff 3b 22 f1 ff ff f4 9f 14 23 ff
    00000190: ff 4f ff 1f 31 ff ff 3f ff 19 f8 ff ff f5 bf 91
    000001a0: ff ff 2f ff 1a 24 f3 ff ff f3 ff f0 ff ff f8 ff
    000001b0: f5 ff ff f3 ff f6 ff ff f2 ff 13 22 f1 ff ef ff
    000001c0: 1e 14 23 f1 ff cf ff 6f 21 ff ff fe ff fb ff cf
    000001d0: ff af 31 ff ff f9 ff fd ff af ff bf 18 ff ff f3
    000001e0: ff 1c f5 ff 5f ff ff 10 11 f1 ff 4f ff ef 51 ff
    000001f0: ff f3 ff 5f ff ff f3 ff 6f 16 ff af ff ff 35 f1
    00000200: ff fe ff 1a 12 21 11 f1 ff 3f ff df 11 21 21 ff
    00000210: ff f2 ff 1e 16 f1 ff 0f ff ff 13 f4 ff 0f ff ff
    00000220: f7 ff 1f ff ff 28 f1 ff fc ff 7f 13 ff cf ff ff
    00000230: 18 f1 ff fd 7f f1
  UrbLink              = 00000000
[547093 ms] UsbSnoop - DispatchAny(b5572610) : IRP_MJ_INTERNAL_DEVICE_CONTROL
[547093 ms] UsbSnoop - MyDispatchInternalIOCTL(b5573e80) : fdo=88b11400, Irp=889b46b0, IRQL=2
[547093 ms]  >>>  URB 504 going down  >>> 
-- URB_FUNCTION_BULK_OR_INTERRUPT_TRANSFER:
  PipeHandle           = 88a69984 [endpoint 0x00000082]
  TransferFlags        = 00000003 (USBD_TRANSFER_DIRECTION_IN, USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 0000041c
  TransferBuffer       = 88be9be0
  TransferBufferMDL    = 00000000
  UrbLink              = 00000000
[547104 ms] UsbSnoop - MyInternalIOCTLCompletion(b5573db0) : fido=00000000, Irp=889b46b0, Context=88bc4040, IRQL=2
[547104 ms]  <<<  URB 504 coming back  <<< 
-- URB_FUNCTION_BULK_OR_INTERRUPT_TRANSFER:
  PipeHandle           = 88a69984 [endpoint 0x00000082]
  TransferFlags        = 00000003 (USBD_TRANSFER_DIRECTION_IN, USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000242
  TransferBuffer       = 88be9be0
  TransferBufferMDL    = 889b77a8
    00000000: 02 01 08 01 00 20 96 16 b6 20 00 00 00 00 80 00
    00000010: 50 00 03 00 2c 02 80 13 ff 14 f1 df ff ff 7f 21
    00000020: 14 12 ff f5 ff ff 12 21 11 72 f1 5f ff ff 2f 14
    00000030: 12 ff fd ff ff 12 f1 ff f4 ff ff f3 ff f5 ff df
    00000040: 21 22 ff 3f ff ff 1e 31 f2 ff f2 ff ff 12 77 f1
    00000050: 5f ff ff 3f 41 11 ff fd ff ff 13 f2 ff f2 ff ff
    00000060: 32 11 f4 cf ff 6f f1 1a 11 11 11 f1 df ff ff 0f
    00000070: 11 11 15 ff fd ff ef 21 13 12 ff fe ff bf 31 11
    00000080: 11 15 ff fd ff ff 27 f1 df ff ff 2f 31 ff 2f ff
    00000090: 17 ff 17 12 21 f2 ef ff 1c bf 41 21 22 ff 2f ff
    000000a0: ff 1d 13 41 12 f1 bf ff 17 ff 14 f1 ff f9 7f 31
    000000b0: 11 f2 12 15 12 f1 ff fa 9f 71 f1 23 15 51 f1 ff
    000000c0: f2 cf f1 1d 31 71 f1 df ff 67 ef 1a ff 0f ff 28
    000000d0: 21 21 9f 21 17 ff 2f ff 28 41 13 12 12 12 25 11
    000000e0: 22 f1 ff fb 7f a8 11 11 51 22 17 ff 6f ff 57 11
    000000f0: 12 13 16 36 81 f1 ff f6 7f 17 32 42 11 31 32 ff
    00000100: ff f1 7f 38 24 11 41 11 ff ff f5 7f 26 22 22 11
    00000110: 12 81 ff ff f1 7f 13 74 11 12 11 11 21 22 ff ff
    00000120: f0 7f 59 22 13 22 11 11 13 ff cf ff 37 41 11 12
    00000130: 62 31 11 f2 ff 2f ff 77 11 13 24 12 f1 ff 8f ff
    00000140: 87 11 a2 f1 ff 8f ff 97 35 f1 ff df ff b7 f2 ff
    00000150: ff f3 7f 1c ff ff 3f ff 67 12 12 13 f1 ff ef ff
    00000160: 37 61 11 f3 ff ff f1 7f 14 21 ff ff 8f ff 67 15
    00000170: f1 ff ff f3 7f 14 13 31 ff ff 3f ff 37 12 13 f2
    00000180: ff ff f4 7f 24 51 11 ff ff 2f ff 29 14 f4 ff ff
    00000190: f3 7f 21 23 11 21 ff ff 3f ff 2b 14 f2 ff ff f3
    000001a0: af 11 11 51 ff ff 3f ff 6f ff ff 2f ff 19 fb ff
    000001b0: ff f2 bf 91 ff ff 2f ff 7f ff ff 1f ff 1f 21 ff
    000001c0: ff 4f ff 5f ff ff 3f ff 9f ff ff fe ff 26 f1 ff
    000001d0: ef ff bf ff ff fc 8f f1 f1 ff df ff bf ff ff fc
    000001e0: ff 1c f1 ff 9f ff ff f0 ff 8f ff ef 11 12 ff ff
    000001f0: f4 ff 4f ff ff f4 ff 4f 13 ff ff f0 ff 6f 31 12
    00000200: ff af ff ff f5 ff 3f ff ff 57 f1 ff fa ff 6f 12
    00000210: ff ef ff ff 11 f4 ff 2f ff ff 10 f5 ff 2f ff ef
    00000220: 71 ff ff f1 ff 9f 11 ff cf ff ff f8 ff 0f ff ff
    00000230: 28 f1 ff fc ff 9f 11 14 ff 7f ff ff 19 f1 ff fc
    00000240: 7f f1
  UrbLink              = 00000000
[547104 ms] UsbSnoop - DispatchAny(b5572610) : IRP_MJ_INTERNAL_DEVICE_CONTROL
[547104 ms] UsbSnoop - MyDispatchInternalIOCTL(b5573e80) : fdo=88b11400, Irp=889b46b0, IRQL=2
[547104 ms]  >>>  URB 505 going down  >>> 
-- URB_FUNCTION_BULK_OR_INTERRUPT_TRANSFER:
  PipeHandle           = 88a69984 [endpoint 0x00000082]
  TransferFlags        = 00000003 (USBD_TRANSFER_DIRECTION_IN, USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 0000041c
  TransferBuffer       = 88be9be0
  TransferBufferMDL    = 00000000
  UrbLink              = 00000000
[547114 ms] UsbSnoop - MyInternalIOCTLCompletion(b5573db0) : fido=00000000, Irp=889b46b0, Context=88bf3b28, IRQL=2
[547114 ms]  <<<  URB 505 coming back  <<< 
-- URB_FUNCTION_BULK_OR_INTERRUPT_TRANSFER:
  PipeHandle           = 88a69984 [endpoint 0x00000082]
  TransferFlags        = 00000003 (USBD_TRANSFER_DIRECTION_IN, USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 0000023e
  TransferBuffer       = 88be9be0
  TransferBufferMDL    = 889b77a8
    00000000: 02 01 08 01 00 20 3d 36 b6 20 00 00 00 00 80 00
    00000010: 50 00 03 00 28 02 80 13 ff 17 31 f2 5f ff ff ef
    00000020: 13 ff f5 ff ff 14 25 f1 af ff ff 3f 23 11 15 ff
    00000030: f7 ff ff 12 12 21 41 11 f1 6f ff ff 4f 11 13 ff
    00000040: fd ff ff 11 f3 ff f3 ff ff f6 ff f2 ff ff 6a f1
    00000050: 6f ff ff af 11 15 ff f5 ff ff 17 41 f1 9f ff ff
    00000060: 4f 42 ff fd ff ff 17 f4 bf ff ff 1f 32 12 ff fe
    00000070: ff 9f 71 22 12 ff fe ff bf 51 14 21 ff fd ff ff
    00000080: 17 42 f1 8f ff ff 6f ff 2f ff 17 ff 12 17 12 f1
    00000090: ff f0 ff af 61 31 22 ff fd ff ff 44 12 f1 bf ff
    000000a0: ff 2d 41 21 f1 ef ff 27 16 af 11 22 13 ff 2f ff
    000000b0: ff 1d 31 21 f1 ff f1 8f f1 4f 31 11 24 ff fd 8f
    000000c0: f5 1e a2 f1 cf ff 28 21 cf 21 ff af ff 19 11 21
    000000d0: 1a 27 11 22 52 21 f1 ff f1 7f 14 43 11 31 91 13
    000000e0: 21 ff bf ff 87 11 1b 46 21 21 12 f1 ff f4 7f 36
    000000f0: 41 61 41 11 21 ff ff f0 7f 16 31 21 21 11 41 11
    00000100: 22 11 ff ef ff 67 12 14 15 11 25 11 11 f1 ff fc
    00000110: 7f 23 b2 12 31 11 22 13 12 ff 8f ff 37 42 25 42
    00000120: 16 31 f1 ff fc 7f 23 85 23 41 ff ff f3 7f 57 b1
    00000130: 14 ff ff f2 7f 18 21 12 11 13 11 ff ff f8 7f 43
    00000140: 52 11 11 21 ff ff fa 7f 4a 13 ff ff fd 7f 1b 11
    00000150: ff ff 2f ff 67 12 12 13 f2 ff df ff 37 21 12 12
    00000160: f5 ff ef ff 37 12 22 12 f2 ff ff f1 7f 46 12 ff
    00000170: ff 3f ff 47 11 11 11 f4 ff ff f2 7f 63 31 ff ff
    00000180: 3f ff 47 12 15 f3 ff ff f0 9f 92 ff ff 3f ff 17
    00000190: 12 16 f2 ff ff f3 cf 41 21 ff ff 3f ff 1a 11 f7
    000001a0: ff ff f3 ff f6 ff ff f2 ff f6 ff ff f2 ff 17 f1
    000001b0: ff ef ff 8f ff ff 0f ff 1f 21 21 ff ff 1f ff 6f
    000001c0: ff ff 2f ff af ff ff fd ff fa ff df ff bf ff ff
    000001d0: fc 8f f1 f2 ff cf ff bf 11 ff ff fa ff fe ff 9f
    000001e0: ff ff f1 ff 7f ff ff 31 f1 ff 3f ff ff 12 f2 ff
    000001f0: 3f ff ff f6 ff 2f ff ff 13 22 f1 ff fe ff 5f 22
    00000200: 17 ff 6f ff ff 16 f2 ff fe ff 9f 13 ff af ff ff
    00000210: 12 23 f1 ff fe ff 6f ff ff f2 ff 8f ff ff f0 ff
    00000220: 8f ff ff f0 ff 8f 11 ff df ff ff f9 ff fe ff 7f
    00000230: 11 21 13 ff 7f ff ff fb ff fc 7f fb ff fc
  UrbLink              = 00000000
[547114 ms] UsbSnoop - DispatchAny(b5572610) : IRP_MJ_INTERNAL_DEVICE_CONTROL
[547114 ms] UsbSnoop - MyDispatchInternalIOCTL(b5573e80) : fdo=88b11400, Irp=889b46b0, IRQL=2
[547114 ms]  >>>  URB 506 going down  >>> 
-- URB_FUNCTION_BULK_OR_INTERRUPT_TRANSFER:
  PipeHandle           = 88a69984 [endpoint 0x00000082]
  TransferFlags        = 00000003 (USBD_TRANSFER_DIRECTION_IN, USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 0000041c
  TransferBuffer       = 88be9be0
  TransferBufferMDL    = 00000000
  UrbLink              = 00000000
[547124 ms] UsbSnoop - MyInternalIOCTLCompletion(b5573db0) : fido=00000000, Irp=889b46b0, Context=89b05130, IRQL=2
[547124 ms]  <<<  URB 506 coming back  <<< 
-- URB_FUNCTION_BULK_OR_INTERRUPT_TRANSFER:
  PipeHandle           = 88a69984 [endpoint 0x00000082]
  TransferFlags        = 00000003 (USBD_TRANSFER_DIRECTION_IN, USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 0000022e
  TransferBuffer       = 88be9be0
  TransferBufferMDL    = 889b77a8
    00000000: 02 01 08 01 00 20 9c 56 b6 20 00 00 00 00 80 00
    00000010: 50 00 03 00 18 02 80 ff 1c 11 f3 5f ff ff af 12
    00000020: 41 ff f5 ff ff 1a 21 21 f1 5f ff ff 4f 41 11 ff
    00000030: fc ff ff 15 21 61 f1 6f ff ff af ff fd ff ff 15
    00000040: f2 ff f0 ff ff 21 13 11 f1 df ff ff af 11 24 ff
    00000050: f5 ff ff 5c f1 5f ff ff 3f 11 11 11 ff fe ff ff
    00000060: 15 15 21 f1 7f ff ff bf ff fc ff ff 10 11 13 11
    00000070: f1 df ff ff 3f 12 12 ff fe ff ff 12 11 21 f2 df
    00000080: ff ff 2f 71 11 ff fb ff ff 12 33 f1 df ff 17 ff
    00000090: 1d f2 ef ff ff 1a 16 14 f2 df ff ff 5f 13 12 ff
    000000a0: fb ff ef 11 12 ff 4f ff 27 ff 10 23 42 f1 ff f1
    000000b0: ff df 11 11 17 ff fd 8f f1 8f 22 22 ff fd 8f 12
    000000c0: f1 3e 71 f1 ff f0 8f 12 f1 2f 21 13 ff 2f ff 19
    000000d0: 11 21 3f 42 22 12 ff 7f ff 37 32 14 1e 21 11 12
    000000e0: 11 f2 ff f6 7f 18 31 e1 13 23 12 11 ff 4f ff 67
    000000f0: 13 14 16 14 f5 ff fe 7f 16 31 21 c1 41 12 13 ff
    00000100: 7f ff 67 17 17 15 11 12 f2 ff fb 7f 23 b2 11 71
    00000110: 21 ff ff f0 7f 23 54 22 32 41 21 12 ff cf ff 37
    00000120: 52 17 21 13 f4 ff 2f ff 77 2f ff ff f7 7f 28 11
    00000130: 12 21 14 ff ff f8 7f 43 62 21 12 11 ff ff f8 7f
    00000140: 4a 25 11 ff ff f8 7f 17 42 17 ff ff f9 7f 13 22
    00000150: 21 31 21 ff ff fd 7f 23 21 21 51 ff ff fe 7f 72
    00000160: 61 ff ff 0f ff 47 11 24 21 f1 ff ff f0 7f 34 61
    00000170: ff ff 2f ff 37 1a f1 ff ff f1 8f 83 31 ff ff 0f
    00000180: ff 29 f9 ff ff f3 ff 12 22 f1 ff ff f0 cf 41 21
    00000190: ff ff 3f ff 1c 27 f1 ff ff f0 ff f8 ff ff f0 ff
    000001a0: f7 ff ff f1 ff f7 ff ff f1 ff f9 ff ef ff 1f 21
    000001b0: 21 12 12 ff ff fa ff f6 ff ff f2 ff fa ff df ff
    000001c0: af ff ff fd ff fb ff cf ff bf ff ff fc ff fc ff
    000001d0: bf ff df 11 ff ff f8 ff 1f ff ff f7 ff 1f 13 ff
    000001e0: ff f3 ff 6f ff ff f2 ff 6f ff ff f2 ff 6f 31 16
    000001f0: ff 6f ff ff 26 f2 ff fd ff 6f 11 ff ff f0 ff 6f
    00000200: 21 ff ef ff ff 12 f3 ff 2f ff ff f6 ff 2f ff ff
    00000210: f6 ff 2f ff ff f8 ff 0f ff ff 18 f1 ff fd ff 9f
    00000220: ff ef ff ff 19 f2 ff fb ff bf ff cf ff b7
  UrbLink              = 00000000
[547124 ms] UsbSnoop - DispatchAny(b5572610) : IRP_MJ_INTERNAL_DEVICE_CONTROL
[547124 ms] UsbSnoop - MyDispatchInternalIOCTL(b5573e80) : fdo=88b11400, Irp=889b46b0, IRQL=2
[547124 ms]  >>>  URB 507 going down  >>> 
-- URB_FUNCTION_BULK_OR_INTERRUPT_TRANSFER:
  PipeHandle           = 88a69984 [endpoint 0x00000082]
  TransferFlags        = 00000003 (USBD_TRANSFER_DIRECTION_IN, USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 0000041c
  TransferBuffer       = 88be9be0
  TransferBufferMDL    = 00000000
  UrbLink              = 00000000
[547134 ms] UsbSnoop - MyInternalIOCTLCompletion(b5573db0) : fido=00000000, Irp=889b46b0, Context=889dd5d0, IRQL=2
[547134 ms]  <<<  URB 507 coming back  <<< 
-- URB_FUNCTION_BULK_OR_INTERRUPT_TRANSFER:
  PipeHandle           = 88a69984 [endpoint 0x00000082]
  TransferFlags        = 00000003 (USBD_TRANSFER_DIRECTION_IN, USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 0000021a
  TransferBuffer       = 88be9be0
  TransferBufferMDL    = 889b77a8
    00000000: 02 01 08 01 00 20 c2 76 b6 20 00 00 00 00 80 00
    00000010: 50 00 03 00 04 02 80 ff 1d 11 f2 5f ff ff ff 11
    00000020: f1 5f ff ff af 11 15 ff f5 ff ff 2a 11 f2 7f ff
    00000030: ff 8f 11 16 ff f6 ff ff 17 f2 df ff ff 2f 41 11
    00000040: ff fe ff ff fa df ff ff cf 24 ff f5 ff ff 1b 31
    00000050: f2 5f ff ff 5f 11 21 15 ff f7 ff ff 3c f1 7f ff
    00000060: ff af 15 ff f7 ff ff 12 11 21 f2 df ff ff 3f 21
    00000070: 22 ff fd ff ff 14 12 f1 ef ff ff 7f 21 ff fd ff
    00000080: ff 12 24 f1 df ff 17 ff 1d f3 df ff ff 8f 11 ff
    00000090: fd ff ff 15 f5 cf ff ff 2f 12 ff 3f ff 27 ff 15
    000000a0: f2 ff f6 ff ff 10 11 21 11 f1 ef ff 18 ff 18 12
    000000b0: 11 f2 df ff 28 ff 12 42 12 21 f1 cf ff 28 11 df
    000000c0: 21 21 22 14 ff fd 9f 11 21 f1 14 24 32 f1 ff f6
    000000d0: 7f 23 43 f1 21 44 11 f1 ff f4 7f 13 11 d2 61 32
    000000e0: 22 12 11 ff 4f ff 37 21 18 3f 13 ff 9f ff 67 18
    000000f0: 1c 24 21 f1 ff f8 7f 13 f2 10 2a f1 ff fb 7f 33
    00000100: b1 21 91 12 13 ff 8f ff 37 42 16 1c 11 11 31 f1
    00000110: ff f8 7f 23 13 91 31 71 ff ff f0 7f f6 43 f1 ff
    00000120: 2f ff 47 31 34 23 11 21 11 f1 ff 3f ff 37 24 1c
    00000130: f1 ff 8f ff 77 11 26 11 12 f1 ff 8f ff 77 12 74
    00000140: f1 ff 9f ff 27 22 15 13 91 f1 ff 4f ff 37 12 12
    00000150: fa ff cf ff 17 0f 14 ff ff fa 7f c2 31 ff ff fd
    00000160: 7f b3 ff ff 2f ff 37 fc ff ff f1 8f f2 f0 ff df
    00000170: ff 19 fb ff ff f2 ff 15 11 f1 ff ef ff 5f 21 ff
    00000180: ff 0f ff 1c 18 f1 ff ff f0 ff f8 ff ff f0 ff f8
    00000190: ff ff f0 ff f9 ff ef ff 9f ff ff fe ff 17 f1 ff
    000001a0: ef ff 9f ff ff fe ff fa ff df ff af ff ff fd ff
    000001b0: fb ff cf ff 9f 21 ff ff fb ff fd ff af ff ff f1
    000001c0: ff 7f ff ff 50 f1 ff 2f ff ff 21 f1 ff 4f ff ff
    000001d0: f5 ff 3f ff ff 26 f1 ff fe ff 6f 21 ff ef ff ff
    000001e0: 26 f2 ff fd ff 8f 14 11 ff 8f ff ff 16 f2 ff fe
    000001f0: ff 1f 42 ff ff f1 ff 6f ff ff f2 ff 8f ff ff f0
    00000200: ff 9f ff ef ff ff f8 ff 0f ff ff fa ff fd ff 9f
    00000210: 21 ff bf ff ff fc ff fb 7f fc
  UrbLink              = 00000000
[547134 ms] UsbSnoop - DispatchAny(b5572610) : IRP_MJ_INTERNAL_DEVICE_CONTROL
[547134 ms] UsbSnoop - MyDispatchInternalIOCTL(b5573e80) : fdo=88b11400, Irp=889b46b0, IRQL=2
[547134 ms]  >>>  URB 508 going down  >>> 
-- URB_FUNCTION_BULK_OR_INTERRUPT_TRANSFER:
  PipeHandle           = 88a69984 [endpoint 0x00000082]
  TransferFlags        = 00000003 (USBD_TRANSFER_DIRECTION_IN, USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 0000041c
  TransferBuffer       = 88be9be0
  TransferBufferMDL    = 00000000
  UrbLink              = 00000000
[547144 ms] UsbSnoop - MyInternalIOCTLCompletion(b5573db0) : fido=00000000, Irp=889b46b0, Context=889f1268, IRQL=2
[547144 ms]  <<<  URB 508 coming back  <<< 
-- URB_FUNCTION_BULK_OR_INTERRUPT_TRANSFER:
  PipeHandle           = 88a69984 [endpoint 0x00000082]
  TransferFlags        = 00000003 (USBD_TRANSFER_DIRECTION_IN, USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 0000020e
  TransferBuffer       = 88be9be0
  TransferBufferMDL    = 889b77a8
    00000000: 02 01 08 01 00 20 e3 95 b6 20 00 00 00 00 80 00
    00000010: 50 00 03 00 f8 01 80 ff 2c 11 f2 5f ff ff af 71
    00000020: ff f5 ff ff 1a 42 f1 5f ff ff bf 21 11 ff f7 ff
    00000030: ff 15 44 f2 7f ff ff 4f 51 ff fd ff ff f8 ff f0
    00000040: ff ff 16 f1 ff f0 ff ff 1a 51 f1 5f ff ff af 11
    00000050: ff fb ff ff 12 14 f1 ef ff ff 5f 41 12 11 ff f8
    00000060: ff ff 12 14 f3 cf ff ff 0f 11 31 13 ff fd ff ff
    00000070: 13 13 f2 df ff ff 4f 31 ff 0f ff ff 7f 21 ff fd
    00000080: ff ff 36 f1 df ff 17 ff 1e f2 df ff ff 3f 31 11
    00000090: ff fe ff ff 15 14 f1 bf ff ff 1e 32 f1 ff f2 7f
    000000a0: f1 6f 31 ff 5f ff ff 2f 11 15 ff fd 8f f1 8f 21
    000000b0: 23 ff fd 8f f2 5f 15 11 ff 0f ff 28 11 ff 11 32
    000000c0: f1 ff f3 9f 11 21 f1 14 15 32 41 f1 ff f1 7f 33
    000000d0: 42 f1 21 44 f1 ff f6 7f 13 11 f2 17 31 12 21 f1
    000000e0: ff f4 7f 13 82 61 41 61 ff df ff 67 18 19 27 f2
    000000f0: ff fa 7f 23 f1 2b 21 f1 ff f8 7f f3 3e 11 f1 ff
    00000100: f8 7f 23 64 81 71 11 13 11 ff 6f ff 37 32 7f ff
    00000110: ff f1 7f f5 44 f2 ff 1f ff 37 23 24 11 13 14 f1
    00000120: ff 5f ff 17 11 14 1d 32 f1 ff 3f ff 77 11 26 f6
    00000130: ff 8f ff 17 42 12 74 f1 ff 9f ff 27 22 15 36 f1
    00000140: ff 9f ff 17 3f ff ff fc 7f f1 30 f1 ff bf ff 27
    00000150: 1c f3 ff df ff 37 fc ff ff f1 7f d3 ff ff 0f ff
    00000160: 28 fd ff ff f0 ff f7 ff ff f1 ff 25 f1 ff ff f0
    00000170: ff f8 ff ff f0 cf 81 11 ff ff 0f ff 9f 12 ff ff
    00000180: fb ff f8 ff ff f0 ff f9 ff ef ff 9f ff ff fe ff
    00000190: 27 21 f1 ff af ff 9f 11 ff ff fc ff fa ff df ff
    000001a0: af ff ff fd ff fc ff bf ff 5f 61 ff ff fb ff fc
    000001b0: ff bf ff ef ff ff f9 ff 0f ff ff f8 ff 1f 22 ff
    000001c0: ff f3 ff 5f ff ff f3 ff 6f 12 ff ef ff ff 16 f2
    000001d0: ff fe ff 6f 22 ff df ff ff f8 ff 0f ff ff f9 ff
    000001e0: fe ff 7f ff ff f1 ff 6f ff ff f2 ff 3f 41 ff ff
    000001f0: f0 ff 9f ff ef ff ff f9 ff fe ff 9f 11 ff cf ff
    00000200: ff 29 f1 ff fb ff bf ff cf ff b7 ff cf ff
  UrbLink              = 00000000
[547144 ms] UsbSnoop - DispatchAny(b5572610) : IRP_MJ_INTERNAL_DEVICE_CONTROL
[547144 ms] UsbSnoop - MyDispatchInternalIOCTL(b5573e80) : fdo=88b11400, Irp=889b46b0, IRQL=2
[547144 ms]  >>>  URB 509 going down  >>> 
-- URB_FUNCTION_BULK_OR_INTERRUPT_TRANSFER:
  PipeHandle           = 88a69984 [endpoint 0x00000082]
  TransferFlags        = 00000003 (USBD_TRANSFER_DIRECTION_IN, USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 0000041c
  TransferBuffer       = 88be9be0
  TransferBufferMDL    = 00000000
  UrbLink              = 00000000
[547154 ms] UsbSnoop - MyInternalIOCTLCompletion(b5573db0) : fido=00000000, Irp=889b46b0, Context=89b04f10, IRQL=2
[547154 ms]  <<<  URB 509 coming back  <<< 
-- URB_FUNCTION_BULK_OR_INTERRUPT_TRANSFER:
  PipeHandle           = 88a69984 [endpoint 0x00000082]
  TransferFlags        = 00000003 (USBD_TRANSFER_DIRECTION_IN, USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000216
  TransferBuffer       = 88be9be0
  TransferBufferMDL    = 889b77a8
    00000000: 02 01 08 01 00 20 c7 b5 b6 20 00 00 00 00 80 00
    00000010: 50 00 03 00 00 02 80 ff 0f 21 ff f5 ff ff 1f 11
    00000020: ff f5 ff ff 1a 12 21 f1 5f ff ff af 11 42 ff f5
    00000030: ff ff 15 14 31 f2 6f ff ff 4f 21 21 ff fd ff ff
    00000040: 12 f7 df ff ff 2f 41 21 ff fd ff ff 1a 12 11 f2
    00000050: 5f ff ff bf 11 11 12 ff f5 ff ff 17 f2 df ff ff
    00000060: 7f 21 12 14 ff f5 ff ff 13 f7 cf ff ff 7f 12 ff
    00000070: fd ff ff 13 13 f2 df ff ff 2f 11 21 11 ff fe ff
    00000080: ff 7a f1 5f ff ff 2f 31 22 17 ff f5 7f f1 ff f1
    00000090: ef ff ff 1a 26 13 f2 df ff ff 4f 42 11 ff fb ff
    000000a0: ff 32 31 f1 df ff 17 ff 16 f2 ff f6 ff ff 10 f1
    000000b0: ff f6 8f f1 8f 11 11 22 ff fd 8f f2 1f 22 15 11
    000000c0: ff 0f ff 28 ff 10 22 21 f1 ff f4 7f 11 11 21 f1
    000000d0: 14 24 13 51 f1 ff f1 7f 33 42 f1 11 12 62 f1 ff
    000000e0: f4 7f 33 f1 19 21 12 f1 ff f7 7f b3 b1 61 ff df
    000000f0: ff 67 18 1c 24 21 f2 ff f7 7f 23 f1 1b f1 ff fc
    00000100: 7f 33 b1 d1 ff ef ff 37 22 11 16 0f 12 ff cf ff
    00000110: 37 22 9f ff ff f0 7f 13 f1 15 11 f1 ff 2f ff 37
    00000120: 13 25 17 f2 ff 7f ff 17 11 14 1d f2 ff 7f ff 57
    00000130: 13 26 11 f4 ff 8f ff 17 42 12 24 41 f1 ff 9f ff
    00000140: 27 12 3d f1 ff 9f ff 17 3f 11 ff ff fa 7f f1 30
    00000150: f2 ff af ff 27 1c 11 f1 ff df ff 37 fc ff ff f1
    00000160: 7f e2 ff ff 0f ff 28 1d f1 ff df ff 8f ff ff 0f
    00000170: ff 5f 31 ff ff fe ff f7 ff ff f1 cf 71 12 ff ff
    00000180: 0f ff 9f ff ff fe ff f8 ff ff f0 ff f9 ff ef ff
    00000190: af ff ff fd ff 14 12 31 f1 ff af ff 9f ff ff fe
    000001a0: ff fa ff df ff af ff ff fd ff fc ff bf ff 5f 31
    000001b0: 21 ff ff fb ff fc ff bf ff ff f0 ff 8f ff ff 41
    000001c0: f1 ff 2f ff ff 21 f2 ff 3f ff ff 25 f1 ff 0f ff
    000001d0: ff 26 f1 ff fe ff 6f 21 ff ef ff ff 16 f3 ff fd
    000001e0: ff 9f ff ef ff ff f9 ff fe ff 2f 51 ff ff f0 ff
    000001f0: 6f ff ff f2 ff 6f 11 ff ff f0 ff 9f 11 ff cf ff
    00000200: ff f9 ff fe ff 9f ff ef ff ff 29 f1 ff fb ff bf
    00000210: ff cf ff b7 ff cf
  UrbLink              = 00000000
[547154 ms] UsbSnoop - DispatchAny(b5572610) : IRP_MJ_INTERNAL_DEVICE_CONTROL
[547154 ms] UsbSnoop - MyDispatchInternalIOCTL(b5573e80) : fdo=88b11400, Irp=889b46b0, IRQL=2
[547154 ms]  >>>  URB 510 going down  >>> 
-- URB_FUNCTION_BULK_OR_INTERRUPT_TRANSFER:
  PipeHandle           = 88a69984 [endpoint 0x00000082]
  TransferFlags        = 00000003 (USBD_TRANSFER_DIRECTION_IN, USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 0000041c
  TransferBuffer       = 88be9be0
  TransferBufferMDL    = 00000000
  UrbLink              = 00000000
[547164 ms] UsbSnoop - MyInternalIOCTLCompletion(b5573db0) : fido=00000000, Irp=889b46b0, Context=8998e2c0, IRQL=2
[547164 ms]  <<<  URB 510 coming back  <<< 
-- URB_FUNCTION_BULK_OR_INTERRUPT_TRANSFER:
  PipeHandle           = 88a69984 [endpoint 0x00000082]
  TransferFlags        = 00000003 (USBD_TRANSFER_DIRECTION_IN, USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 0000020a
  TransferBuffer       = 88be9be0
  TransferBufferMDL    = 889b77a8
    00000000: 02 01 08 01 00 20 9f d5 b6 20 00 00 00 00 80 00
    00000010: 50 00 03 00 f4 01 80 ff 0f 21 ff f5 ff ff 3f ff
    00000020: f5 ff ff 1d 21 f1 5f ff ff cf 13 ff f7 ff ff 4a
    00000030: 11 f2 5f ff ff af ff fd ff ff 18 f1 df ff ff 8f
    00000040: ff 0f ff ff af 11 12 12 ff f5 ff ff 2b f1 9f ff
    00000050: ff 7f 11 14 ff f9 ff ff 15 14 f1 bf ff ff bf ff
    00000060: fc ff ff 10 11 13 11 f1 df ff ff 7f 21 ff fd ff
    00000070: ff 12 11 f3 ff f0 ff ff 17 f2 df ff ff 6f 22 ff
    00000080: fd 7f f1 af 31 11 ff fe ff af b1 ff 1f ff ff 3f
    00000090: 12 13 11 ff fb ff ff 32 31 f1 df ff 17 ff 16 f2
    000000a0: ff f6 ff ff 10 21 f1 ff f3 8f f1 8f 26 ff fd 8f
    000000b0: f2 1f 12 12 13 11 ff 0f ff 28 ff 17 11 f1 ff f2
    000000c0: 7f 11 11 f1 17 24 23 f1 ff f6 7f 11 31 42 f1 11
    000000d0: 12 42 11 f1 ff f4 7f 33 e1 61 21 11 12 13 11 ff
    000000e0: 4f ff 37 11 df ff df ff 67 18 1c 55 f1 ff f7 7f
    000000f0: 23 f1 4b f1 ff f9 7f f3 1d f1 ff fd 7f 23 12 61
    00000100: f1 11 f1 ff fc 7f 23 f1 12 15 f1 ff 0f ff 37 11
    00000110: 4f ff ff f7 7f 33 51 42 21 21 11 11 ff ff f3 7f
    00000120: f1 15 22 f1 ff 4f ff 67 19 f7 ff 8f ff 17 42 12
    00000130: 14 42 f1 ff 9f ff 17 13 fd ff df ff bf ff ff fc
    00000140: 7f f1 30 f2 ff af ff 27 1e 21 f1 ff af ff 37 fc
    00000150: ff ff f1 7f e2 ff ff 0f ff 28 0f ff ff fd ff f7
    00000160: ff ff f1 ff 15 f2 ff ff f0 ff f8 ff ff f0 ff 16
    00000170: f1 ff ff f0 ff f9 ff ef ff 8f ff ff 0f ff 9f ff
    00000180: ff fe ff 1a f1 ff bf ff af 21 ff ff fa ff 19 f1
    00000190: ff cf ff af 13 ff ff f9 ff fa ff df ff cf ff ff
    000001a0: fb ff 15 f6 ff bf ff cf ff ff fb ff 1e f1 ff 7f
    000001b0: ff ff 41 f1 ff 2f ff ff 21 f2 ff 3f ff ff f5 ff
    000001c0: 3f ff ff 16 f2 ff fe ff 6f 21 ff ef ff ff 16 f2
    000001d0: ff fe ff 8f ff ff f0 ff 6f 31 ff df ff ff 13 f3
    000001e0: ff 1f ff ff 37 f1 ff fc ff 8f ff ff f0 ff 9f ff
    000001f0: ef ff ff f9 ff fe ff 9f 12 ff bf ff ff 29 f1 ff
    00000200: fb ff bf ff cf ff b7 ff cf ff
  UrbLink              = 00000000
[547164 ms] UsbSnoop - DispatchAny(b5572610) : IRP_MJ_INTERNAL_DEVICE_CONTROL
[547164 ms] UsbSnoop - MyDispatchInternalIOCTL(b5573e80) : fdo=88b11400, Irp=889b46b0, IRQL=2
[547164 ms]  >>>  URB 511 going down  >>> 
-- URB_FUNCTION_BULK_OR_INTERRUPT_TRANSFER:
  PipeHandle           = 88a69984 [endpoint 0x00000082]
  TransferFlags        = 00000003 (USBD_TRANSFER_DIRECTION_IN, USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 0000041c
  TransferBuffer       = 88be9be0
  TransferBufferMDL    = 00000000
  UrbLink              = 00000000
[547174 ms] UsbSnoop - MyInternalIOCTLCompletion(b5573db0) : fido=00000000, Irp=889b46b0, Context=89a4d9c8, IRQL=2
[547174 ms]  <<<  URB 511 coming back  <<< 
-- URB_FUNCTION_BULK_OR_INTERRUPT_TRANSFER:
  PipeHandle           = 88a69984 [endpoint 0x00000082]
  TransferFlags        = 00000003 (USBD_TRANSFER_DIRECTION_IN, USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 0000020a
  TransferBuffer       = 88be9be0
  TransferBufferMDL    = 889b77a8
    00000000: 02 01 08 01 00 20 63 f5 b6 20 00 00 00 00 80 00
    00000010: 50 00 03 00 f4 01 80 ff 1c f5 5f ff ff ff f3 5f
    00000020: ff ff df 11 12 ff f5 ff ff 1b 11 f4 5f ff ff 5f
    00000030: 41 11 32 ff f6 ff ff fa df ff ff 5f 41 ff fd ff
    00000040: ff 18 f1 df ff ff af 13 13 ff f5 ff ff 1a 21 f1
    00000050: 8f ff ff af 11 ff fb ff ff 2a 21 f1 7f ff ff bf
    00000060: 15 ff f6 ff ff fa df ff ff 3f 31 11 ff fe ff ff
    00000070: 14 21 f2 df ff ff 7f 21 17 ff f5 ff ff 12 23 f1
    00000080: ef ff 17 ff 1d f3 df ff ff 1a 18 12 f2 df ff ff
    00000090: af 11 ff fb ff ff 32 31 f1 df ff 17 ff 13 12 f2
    000000a0: ff f6 ff ff 10 11 51 f1 df ff 18 ff 13 64 f2 df
    000000b0: ff 28 ff 12 72 f1 ff f0 8f 12 f1 1d 45 f1 ff f2
    000000c0: 7f 11 11 f1 17 15 32 41 f1 ff f1 7f 11 31 42 e1
    000000d0: 23 21 14 ff 6f ff 37 13 6f 41 13 12 11 ff 4f ff
    000000e0: 37 11 6f 61 ff df ff 67 18 1c 14 31 f1 ff f8 7f
    000000f0: 23 f1 5b f1 ff f8 7f 33 d1 c1 11 ff bf ff 47 21
    00000100: 11 16 1f 11 13 ff 8f ff 37 22 8f ff ff f1 7f 13
    00000110: f1 35 f1 ff 2f ff 37 13 25 1a 11 f1 ff 3f ff 17
    00000120: 5f 11 16 ff ff f1 7f 95 13 41 ff ff f8 7f 21 24
    00000130: 51 11 14 ff ff f9 7f 31 52 51 16 ff ff f7 ff 1b
    00000140: f1 ff af ff 17 0f 13 ff ff fb 7f c2 31 ff ff fd
    00000150: 7f c3 ff ff 1f ff 27 fe ff ff f0 8f f2 f0 ff df
    00000160: ff 7f ff ff 1f ff 5f 12 ff ff 0f ff 7f ff ff 1f
    00000170: ff 6f 11 ff ff 0f ff 8f ff ff 0f ff 8f ff ff 0f
    00000180: ff 8f ff ff 0f ff 9f ff ff fe ff 14 12 31 f1 ff
    00000190: af ff 9f ff ff fe ff fa ff df ff af 11 ff ff fb
    000001a0: ff fc ff bf ff 5f 31 21 ff ff fb ff fc ff bf ff
    000001b0: df ff ff fa ff 0f ff ff f8 ff 1f 22 ff ff f3 ff
    000001c0: 6f ff ff f2 ff 6f 12 ff ef ff ff 13 12 f3 ff fd
    000001d0: ff 6f 21 ff ef ff ff 16 f2 ff fe ff 6f 31 14 ff
    000001e0: 8f ff ff f7 ff 1f ff ff f8 ff 0f ff ff f9 ff fe
    000001f0: ff 9f ff ef ff ff f9 ff fe ff 9f ff ef ff ff 19
    00000200: f2 ff fb ff bf ff cf ff b7 ff
  UrbLink              = 00000000
[547174 ms] UsbSnoop - DispatchAny(b5572610) : IRP_MJ_INTERNAL_DEVICE_CONTROL
[547174 ms] UsbSnoop - MyDispatchInternalIOCTL(b5573e80) : fdo=88b11400, Irp=889b46b0, IRQL=2
[547174 ms]  >>>  URB 512 going down  >>> 
-- URB_FUNCTION_BULK_OR_INTERRUPT_TRANSFER:
  PipeHandle           = 88a69984 [endpoint 0x00000082]
  TransferFlags        = 00000003 (USBD_TRANSFER_DIRECTION_IN, USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 0000041c
  TransferBuffer       = 88be9be0
  TransferBufferMDL    = 00000000
  UrbLink              = 00000000
[547184 ms] UsbSnoop - MyInternalIOCTLCompletion(b5573db0) : fido=00000000, Irp=889b46b0, Context=88b3f208, IRQL=2
[547184 ms]  <<<  URB 512 coming back  <<< 
-- URB_FUNCTION_BULK_OR_INTERRUPT_TRANSFER:
  PipeHandle           = 88a69984 [endpoint 0x00000082]
  TransferFlags        = 00000003 (USBD_TRANSFER_DIRECTION_IN, USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000202
  TransferBuffer       = 88be9be0
  TransferBufferMDL    = 889b77a8
    00000000: 02 01 08 01 00 20 0e 15 b7 20 00 00 00 00 80 00
    00000010: 50 00 03 00 ec 01 80 ff 1c f5 5f ff ff ff f3 5f
    00000020: ff ff df 11 21 ff f5 ff ff 14 17 f3 7f ff ff af
    00000030: 11 32 ff f6 ff ff 14 f4 ef ff ff 2f 71 ff fd ff
    00000040: ff 12 f6 ef ff ff af 11 24 ff f5 ff ff 3a f1 9f
    00000050: ff ff 9f ff fe ff ff 6b f1 5f ff ff bf 15 ff f6
    00000060: ff ff 14 f5 df ff ff 7f 21 ff fd ff ff 14 12 f2
    00000070: df ff ff 7f 21 ff fd ff ff 36 f1 df ff 17 ff 1d
    00000080: f2 ef ff ff 8f 11 ff fd ff ff 15 11 12 f2 af ff
    00000090: ff 2f 22 ff 2f ff 17 ff 16 42 f1 ff f1 ff ff 10
    000000a0: 11 11 f1 ff f2 7f f2 5f 21 11 15 ff fd 8f f2 2f
    000000b0: 21 ff 8f ff 28 ff 53 31 f1 ff f0 7f 11 11 21 f1
    000000c0: 23 24 32 f1 ff f6 7f 33 42 f1 30 35 f1 ff f6 7f
    000000d0: 33 e1 61 32 22 21 11 ff 4f ff 37 21 13 1b fa ff
    000000e0: fe 7f 86 c1 41 12 13 ff 7f ff 37 12 bf 14 ff 9f
    000000f0: ff 37 df ff ff f0 7f 14 64 e1 13 13 ff 8f ff 37
    00000100: 22 1f 62 ff ff f0 7f f5 53 f1 ff 2f ff 37 23 24
    00000110: 15 43 f1 ff 3f ff 17 26 1c 22 f1 ff 4f ff 67 29
    00000120: 11 f4 ff 8f ff 17 42 12 24 41 f1 ff 9f ff 17 13
    00000130: 16 35 21 f1 ff 7f ff bf 12 ff ff f9 7f f1 30 f1
    00000140: ff bf ff 27 1c f3 ff df ff 37 fc ff ff f1 7f e2
    00000150: ff ff 0f ff 28 0f ff ff fd ff f7 ff ff f1 ff 15
    00000160: f2 ff ff f0 ff f8 ff ff f0 ff f8 ff ff f0 ff 38
    00000170: f1 ff bf ff 8f ff ff 0f ff 9f ff ff fe ff f9 ff
    00000180: ef ff 4f 21 21 12 ff ff fa ff fa ff df ff af ff
    00000190: ff fd ff fa ff df ff bf ff ff fc ff 15 f6 ff bf
    000001a0: ff df ff ff fa ff 2d f1 ff 7f ff ff f1 ff 7f ff
    000001b0: ff 31 f1 ff 3f ff ff 12 f2 ff 3f ff ff 35 f1 ff
    000001c0: fe ff 6f 31 11 ff bf ff ff 16 f2 ff fe ff 6f 21
    000001d0: 14 ff 9f ff ff 39 f1 ff fa ff 7f 11 ff ef ff ff
    000001e0: f7 ff 1f ff ff f9 ff fe ff 8f ff ff f0 ff 8f ff
    000001f0: ff f0 ff 9f ff ef ff ff 19 f3 ff fa ff 9f ff ef
    00000200: ff 97
  UrbLink              = 00000000
[547184 ms] UsbSnoop - DispatchAny(b5572610) : IRP_MJ_INTERNAL_DEVICE_CONTROL
[547184 ms] UsbSnoop - MyDispatchInternalIOCTL(b5573e80) : fdo=88b11400, Irp=889b46b0, IRQL=2
[547184 ms]  >>>  URB 513 going down  >>> 
-- URB_FUNCTION_BULK_OR_INTERRUPT_TRANSFER:
  PipeHandle           = 88a69984 [endpoint 0x00000082]
  TransferFlags        = 00000003 (USBD_TRANSFER_DIRECTION_IN, USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 0000041c
  TransferBuffer       = 88be9be0
  TransferBufferMDL    = 00000000
  UrbLink              = 00000000
[547193 ms] UsbSnoop - MyInternalIOCTLCompletion(b5573db0) : fido=00000000, Irp=889b46b0, Context=889ebab0, IRQL=2
[547193 ms]  <<<  URB 513 coming back  <<< 
-- URB_FUNCTION_BULK_OR_INTERRUPT_TRANSFER:
  PipeHandle           = 88a69984 [endpoint 0x00000082]
  TransferFlags        = 00000003 (USBD_TRANSFER_DIRECTION_IN, USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 000001fe
  TransferBuffer       = 88be9be0
  TransferBufferMDL    = 889b77a8
    00000000: 02 01 08 01 00 20 b7 34 b7 20 00 00 00 00 80 00
    00000010: 50 00 03 00 e8 01 80 ff 3f ff f5 ff ff 3f ff f5
    00000020: ff ff 2d 11 f1 5f ff ff df 41 ff f5 ff ff 3a f5
    00000030: 5f ff ff af 16 ff f6 ff ff 4a f1 8f ff ff af 13
    00000040: 13 ff f5 ff ff 3d f2 5f ff ff bf 41 ff f7 ff ff
    00000050: 17 f1 ef ff ff df ff fa ff ff 5b f1 6f ff ff af
    00000060: ff fd ff ff fa df ff ff 4f 51 ff fd ff ff 2a f1
    00000070: af ff ff 2f 31 12 ff fe 7f f1 af 21 31 ff fd 7f
    00000080: f1 ff 12 f1 bf ff ff 3f 11 31 ff fe ff ef 21 22
    00000090: 13 ff fd 7f f1 3f 21 21 ff 6f ff ff 3f 12 21 ff
    000000a0: fe 8f f1 8f 21 23 ff fd 8f f2 5f 11 15 ff 0f ff
    000000b0: 28 11 ff 21 11 31 f1 ff f1 7f 11 11 f1 17 38 41
    000000c0: f1 ff f1 7f 33 42 f1 11 45 f1 ff f6 7f 33 f1 17
    000000d0: 33 11 12 f1 ff f4 7f 13 32 f1 f8 ff fd 7f 86 c1
    000000e0: 41 12 13 ff 7f ff 37 12 bf 12 21 ff 8f ff 37 2f
    000000f0: b1 ff ef ff 37 22 11 16 1c 22 22 f1 ff f8 7f 23
    00000100: c2 31 52 ff ff f1 7f f5 44 f1 ff 2f ff 37 13 25
    00000110: 1a f1 ff 5f ff 17 16 1d 22 f1 ff 4f ff 67 12 17
    00000120: 11 f4 ff 8f ff 17 42 12 56 11 f1 ff 7f ff 17 13
    00000130: fd ff df ff bf ff ff fc 7f f1 40 f1 ff af ff 27
    00000140: 1c 32 f1 ff af ff 37 fc ff ff f1 7f f2 f0 ff ef
    00000150: ff 28 0f ff ff fd ff f8 ff ff f0 ff 15 f3 ff ef
    00000160: ff 7f ff ff 1f ff 6f 11 ff ff 0f ff 9f ff ff fe
    00000170: ff f8 ff ff f0 ff f9 ff ef ff 9f 11 ff ff fc ff
    00000180: 14 13 11 f2 ff af ff 9f 11 ff ff fc ff fa ff df
    00000190: ff af 11 ff ff fb ff fb ff cf ff cf ff ff fb ff
    000001a0: 1d f1 ff 8f ff ef ff ff f9 ff 0f 15 ff ff f2 ff
    000001b0: 1f 22 ff ff f3 ff 5f ff ff f3 ff 5f 32 ff df ff
    000001c0: ff 16 23 f1 ff fa ff 6f 31 ff df ff ff f9 ff fe
    000001d0: ff 9f ff ef ff ff f6 ff 2f ff ff 16 12 f1 ff fc
    000001e0: ff 9f ff ef ff ff f9 ff fe ff 9f ff ef ff ff fa
    000001f0: ff fd ff 9f 21 14 ff 6f ff ff fc ff fb 7f
  UrbLink              = 00000000
[547193 ms] UsbSnoop - DispatchAny(b5572610) : IRP_MJ_INTERNAL_DEVICE_CONTROL
[547193 ms] UsbSnoop - MyDispatchInternalIOCTL(b5573e80) : fdo=88b11400, Irp=889b46b0, IRQL=2
[547193 ms]  >>>  URB 514 going down  >>> 
-- URB_FUNCTION_BULK_OR_INTERRUPT_TRANSFER:
  PipeHandle           = 88a69984 [endpoint 0x00000082]
  TransferFlags        = 00000003 (USBD_TRANSFER_DIRECTION_IN, USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 0000041c
  TransferBuffer       = 88be9be0
  TransferBufferMDL    = 00000000
  UrbLink              = 00000000
[547203 ms] UsbSnoop - MyInternalIOCTLCompletion(b5573db0) : fido=00000000, Irp=889b46b0, Context=889dd5d0, IRQL=2
[547203 ms]  <<<  URB 514 coming back  <<< 
-- URB_FUNCTION_BULK_OR_INTERRUPT_TRANSFER:
  PipeHandle           = 88a69984 [endpoint 0x00000082]
  TransferFlags        = 00000003 (USBD_TRANSFER_DIRECTION_IN, USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 0000020a
  TransferBuffer       = 88be9be0
  TransferBufferMDL    = 889b77a8
    00000000: 02 01 08 01 00 20 7c 54 b7 20 00 00 00 00 80 00
    00000010: 50 00 03 00 f4 01 80 ff 3f ff f5 ff ff 3f ff f5
    00000020: ff ff 1d f4 5f ff ff cf 21 11 ff f6 ff ff 3b f4
    00000030: 5f ff ff bf 13 ff f8 ff ff 4a f1 8f ff ff af 15
    00000040: 11 ff f5 ff ff 2b 21 f2 5f ff ff af 21 11 12 ff
    00000050: f5 ff ff 3a 11 f2 6f ff ff af 11 13 ff f7 ff ff
    00000060: 12 27 f1 af ff ff af 11 ff fb ff ff 13 f6 df ff
    00000070: ff 4f 21 21 ff fd ff ff 17 f2 df ff ff 6f ff 2f
    00000080: ff 17 ff 1d f3 df ff ff 2f 31 31 ff fd ff ff 26
    00000090: f3 cf ff ff 3f 12 13 ff fd 7f f1 6f 21 11 12 ff
    000000a0: 1f ff ff 0f 11 11 14 ff fe 8f f1 8f 11 24 ff fd
    000000b0: 8f f2 3f 31 13 11 ff 0f ff 28 11 ff f4 ff f7 7f
    000000c0: 11 11 21 f1 14 24 32 f1 ff f6 7f 33 f2 16 15 21
    000000d0: 11 f1 ff f4 7f 13 11 e1 b1 12 22 ff 6f ff 37 11
    000000e0: 14 8f 13 ff 9f ff 67 18 1c 24 21 f3 ff f6 7f 23
    000000f0: f1 2b 21 f1 ff f8 7f 33 f1 5a f1 ff f8 7f 23 64
    00000100: f1 20 f1 ff fc 7f 23 c2 b1 ff ff f0 7f f5 44 f1
    00000110: ff 2f ff 37 13 25 17 21 11 f1 ff 3f ff 17 16 1d
    00000120: f2 ff 7f ff 67 29 f6 ff 8f ff 17 42 12 24 41 f1
    00000130: ff 9f ff 27 22 2c 21 f1 ff 7f ff 17 3f ff ff fc
    00000140: 7f f1 40 f1 ff af ff 27 1c f1 ff ff f0 7f c3 12
    00000150: ff ff fd 7f f2 f0 ff ef ff 28 0f ff ff fd ff f8
    00000160: ff ff f0 ff 15 f3 ff ef ff 5f 21 ff ff 0f ff 1c
    00000170: fa ff ff f0 ff 38 f1 ff bf ff 8f ff ff 0f ff 9f
    00000180: ff ff fe ff f9 ff ef ff 7f 15 ff ff fa ff 19 f1
    00000190: ff cf ff bf ff ff fc ff fa ff df ff cf ff ff fb
    000001a0: ff fc ff bf ff df ff ff fa ff 1f 13 ff ff f3 ff
    000001b0: 1f 14 ff ff f2 ff 1f 13 ff ff f3 ff 5f ff ff f3
    000001c0: ff 4f 11 12 ff ef ff ff 16 f2 ff fe ff 6f 31 ff
    000001d0: df ff ff 16 f1 ff 0f ff ff f9 ff fe ff 7f 11 ff
    000001e0: ef ff ff 16 f1 ff 0f ff ff 17 f1 ff fe ff 9f ff
    000001f0: ef ff ff f9 ff fe ff 9f 12 ff bf ff ff 19 32 f1
    00000200: ff f7 ff bf ff cf ff b7 ff cf
  UrbLink              = 00000000
[547203 ms] UsbSnoop - DispatchAny(b5572610) : IRP_MJ_INTERNAL_DEVICE_CONTROL
[547203 ms] UsbSnoop - MyDispatchInternalIOCTL(b5573e80) : fdo=88b11400, Irp=889b46b0, IRQL=2
[547203 ms]  >>>  URB 515 going down  >>> 
-- URB_FUNCTION_BULK_OR_INTERRUPT_TRANSFER:
  PipeHandle           = 88a69984 [endpoint 0x00000082]
  TransferFlags        = 00000003 (USBD_TRANSFER_DIRECTION_IN, USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 0000041c
  TransferBuffer       = 88be9be0
  TransferBufferMDL    = 00000000
  UrbLink              = 00000000
[547213 ms] UsbSnoop - MyInternalIOCTLCompletion(b5573db0) : fido=00000000, Irp=889b46b0, Context=889f1268, IRQL=2
[547213 ms]  <<<  URB 515 coming back  <<< 
-- URB_FUNCTION_BULK_OR_INTERRUPT_TRANSFER:
  PipeHandle           = 88a69984 [endpoint 0x00000082]
  TransferFlags        = 00000003 (USBD_TRANSFER_DIRECTION_IN, USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 0000021a
  TransferBuffer       = 88be9be0
  TransferBufferMDL    = 889b77a8
    00000000: 02 01 08 01 00 20 49 74 b7 20 00 00 00 00 80 00
    00000010: 50 00 03 00 04 02 80 ff 3f ff f5 ff ff 3f 11 ff
    00000020: f3 ff ff 1d 12 f1 5f ff ff df 41 ff f5 ff ff 3a
    00000030: f4 6f ff ff af 16 ff f6 ff ff 1a 31 f1 7f ff ff
    00000040: af 17 ff f5 ff ff 1d 11 f2 5f ff ff af 51 11 ff
    00000050: f5 ff ff 2a 12 f1 7f ff ff af 21 12 ff f7 ff ff
    00000060: 3c f2 6f ff ff bf 15 ff f6 ff ff fa df ff ff 4f
    00000070: 51 ff fd ff ff 4a f1 8f ff ff 2f 41 21 14 11 ff
    00000080: f6 7f f1 af 21 31 ff fd 7f f1 ef 21 ff fd ff ff
    00000090: 17 12 f2 af ff ff 2f 31 12 ff fe 7f f1 6f 21 11
    000000a0: 21 ff 1f ff ff 4f 11 31 ff fd 8f f1 8f 22 22 ff
    000000b0: fd 8f f2 2f 21 11 12 ff 3f ff 28 11 ff 34 f4 ff
    000000c0: f0 9f 11 21 f1 1a 46 f1 ff f1 7f 33 f2 16 1a f1
    000000d0: ff f4 7f 33 21 f1 13 14 23 11 f1 ff f4 7f 63 b1
    000000e0: 41 51 11 13 11 ff 6f ff 67 18 1c 24 21 f2 ff f7
    000000f0: 7f 23 f1 1b 12 f1 ff f9 7f f3 1e f2 ff fb 7f 23
    00000100: 12 61 21 d1 11 13 11 ff 6f ff 37 12 af 13 ff bf
    00000110: ff 57 4f 12 11 ff ff f2 7f 33 51 92 12 11 ff ff
    00000120: f3 7f 11 41 d1 21 12 ff ff f4 7f a5 62 13 ff ff
    00000130: f4 7f 21 24 41 11 24 11 ff ff f7 7f 22 52 61 31
    00000140: ff ff f9 7f f1 22 f1 ff af ff 17 0f 13 13 ff ff
    00000150: f7 7f f2 31 f1 ff 9f ff 37 fc ff ff f1 7f e3 ff
    00000160: ff fe 8f f2 f0 ff df ff 8f 13 ff ff fb ff 15 f3
    00000170: ff ef ff 5f 21 ff ff 0f ff 5f 21 ff ff 0f ff 8f
    00000180: 13 ff ff fb ff 18 f1 ff df ff 9f ff ff fe ff 19
    00000190: f1 ff cf ff 7f 21 21 ff ff fa ff fb ff cf ff af
    000001a0: 15 ff ff f7 ff 1a 31 f1 ff 7f ff cf ff ff fb ff
    000001b0: fc ff bf ff ff f0 ff 8f ff ff f1 ff 7f ff ff 31
    000001c0: f1 ff 3f ff ff 21 f3 ff 2f ff ff 26 f1 ff fe ff
    000001d0: 6f 21 12 ff bf ff ff 29 f1 ff fb ff 6f 31 ff df
    000001e0: ff ff 2a 11 f1 ff f8 ff af 12 11 ff 8f ff ff 17
    000001f0: f1 ff fe ff 9f 11 ff cf ff ff fb ff fc ff 9f 11
    00000200: ff cf ff ff fa ff fd ff bf ff cf ff ff 19 42 f1
    00000210: ff f6 ff cf ff bf ff c7 ff bf
  UrbLink              = 00000000
[547213 ms] UsbSnoop - DispatchAny(b5572610) : IRP_MJ_INTERNAL_DEVICE_CONTROL
[547213 ms] UsbSnoop - MyDispatchInternalIOCTL(b5573e80) : fdo=88b11400, Irp=889b46b0, IRQL=2
[547213 ms]  >>>  URB 516 going down  >>> 
-- URB_FUNCTION_BULK_OR_INTERRUPT_TRANSFER:
  PipeHandle           = 88a69984 [endpoint 0x00000082]
  TransferFlags        = 00000003 (USBD_TRANSFER_DIRECTION_IN, USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 0000041c
  TransferBuffer       = 88be9be0
  TransferBufferMDL    = 00000000
  UrbLink              = 00000000
[547223 ms] UsbSnoop - MyInternalIOCTLCompletion(b5573db0) : fido=00000000, Irp=889b46b0, Context=89b12908, IRQL=2
[547223 ms]  <<<  URB 516 coming back  <<< 
-- URB_FUNCTION_BULK_OR_INTERRUPT_TRANSFER:
  PipeHandle           = 88a69984 [endpoint 0x00000082]
  TransferFlags        = 00000003 (USBD_TRANSFER_DIRECTION_IN, USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 0000020e
  TransferBuffer       = 88be9be0
  TransferBufferMDL    = 889b77a8
    00000000: 02 01 08 01 00 20 ef 93 b7 20 00 00 00 00 80 00
    00000010: 50 00 03 00 f8 01 80 ff 3f ff f5 ff ff 3f ff f5
    00000020: ff ff 1d 11 f2 5f ff ff cf 41 ff f6 ff ff 2c f4
    00000030: 5f ff ff af ff fd ff ff fa df ff ff af 13 ff f9
    00000040: ff ff 1a 21 11 f2 5f ff ff af 41 ff f8 ff ff 16
    00000050: 13 11 f1 9f ff ff 5f 41 11 ff fb ff ff 12 14 34
    00000060: f1 7f ff ff 2f 31 11 21 ff fc ff ff 13 22 f2 df
    00000070: ff ff 4f 21 21 ff fd ff ff 4a f1 8f ff ff 2f 31
    00000080: 13 ff fd 7f f1 df 12 ff fe 7f f1 af 21 12 ff fe
    00000090: ff ff 13 13 f4 bf ff ff 2f 11 11 12 ff fe 7f f1
    000000a0: 3f 61 ff 5f ff ff 2f 11 11 ff 2f ff 18 ff 18 11
    000000b0: 21 f2 df ff 28 ff 12 f2 ff f8 8f 12 f1 1d f6 ff
    000000c0: f6 9f 11 21 f1 14 15 23 41 f1 ff f1 7f 33 42 f1
    000000d0: 11 12 42 11 f1 ff f4 7f 13 11 21 f1 13 52 21 11
    000000e0: f1 ff f4 7f 13 41 b1 b1 ff df ff 67 18 1c 54 f1
    000000f0: ff f8 7f 23 f1 2b f1 ff fb 7f f3 10 fd ff fe 7f
    00000100: 23 64 f1 11 31 f1 ff f8 7f 23 c2 a1 ff ff f1 7f
    00000110: f5 44 f1 ff 2f ff 37 13 25 15 11 21 11 f1 ff 3f
    00000120: ff 17 11 14 1d f2 ff 7f ff 57 11 11 17 11 f4 ff
    00000130: 8f ff 17 42 12 14 51 f1 ff 9f ff 27 22 15 25 f1
    00000140: ff bf ff 17 3f ff ff fc 7f f1 f0 ff ff f0 7f c2
    00000150: 11 11 12 ff ff fa 7f b3 ff ff 2f ff 37 fc ff ff
    00000160: f1 8f d2 11 ff ff fd ff f8 ff ff f0 ff 15 f3 ff
    00000170: ef ff 7f ff ff 1f ff 1c fa ff ff f0 ff f8 ff ff
    00000180: f0 ff f8 ff ff f0 ff f9 ff ef ff 9f ff ff fe ff
    00000190: 17 22 f1 ff af ff 9f 11 ff ff fc ff fa ff df ff
    000001a0: af ff ff fd ff fb ff cf ff cf ff ff fb ff fd ff
    000001b0: af ff ff f1 ff 7f ff ff 41 f1 ff 2f ff ff 21 f2
    000001c0: ff 3f ff ff 12 f2 ff 3f ff ff 16 f2 ff fe ff 6f
    000001d0: 21 ff ef ff ff 16 f2 ff fe ff 9f 13 ff af ff ff
    000001e0: f9 ff fe ff 7f ff ff f1 ff 7f ff ff f1 ff 9f ff
    000001f0: ef ff ff f9 ff fe ff 9f ff ef ff ff 19 f1 ff fc
    00000200: ff 9f 12 ff bf ff ff 19 f2 ff fb 7f f2 ff
  UrbLink              = 00000000
[547223 ms] UsbSnoop - DispatchAny(b5572610) : IRP_MJ_INTERNAL_DEVICE_CONTROL
[547223 ms] UsbSnoop - MyDispatchInternalIOCTL(b5573e80) : fdo=88b11400, Irp=889b46b0, IRQL=2
[547223 ms]  >>>  URB 517 going down  >>> 
-- URB_FUNCTION_BULK_OR_INTERRUPT_TRANSFER:
  PipeHandle           = 88a69984 [endpoint 0x00000082]
  TransferFlags        = 00000003 (USBD_TRANSFER_DIRECTION_IN, USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 0000041c
  TransferBuffer       = 88be9be0
  TransferBufferMDL    = 00000000
  UrbLink              = 00000000
[547234 ms] UsbSnoop - MyInternalIOCTLCompletion(b5573db0) : fido=00000000, Irp=889b46b0, Context=88a02730, IRQL=2
[547234 ms]  <<<  URB 517 coming back  <<< 
-- URB_FUNCTION_BULK_OR_INTERRUPT_TRANSFER:
  PipeHandle           = 88a69984 [endpoint 0x00000082]
  TransferFlags        = 00000003 (USBD_TRANSFER_DIRECTION_IN, USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000212
  TransferBuffer       = 88be9be0
  TransferBufferMDL    = 889b77a8
    00000000: 02 01 08 01 00 20 a4 b3 b7 20 00 00 00 00 80 00
    00000010: 50 00 03 00 fc 01 80 ff 1c 65 f1 fd ff ff 3f 13
    00000020: ff f1 ff ff 3f ff f4 ff ff 4f ff f5 ff ff 1b 11
    00000030: f4 5f ff ff bf 22 21 ff f5 ff ff 2d f1 7f ff ff
    00000040: af 13 11 11 ff f5 ff ff 1c 12 f2 5f ff ff ff f3
    00000050: 5f ff ff ef 11 11 ff f5 ff ff 1f 11 ff f5 ff ff
    00000060: 2d f2 6f ff ff cf 23 ff f6 ff ff 1a f1 bf ff ff
    00000070: af ff fd ff ff 0f 12 ff f5 ff ff 17 f3 cf ff 17
    00000080: ff 2f ff fd ff ff fa df ff ff bf 11 13 ff f6 ff
    00000090: ff 22 23 f1 df ff 17 ff 4e f1 bf ff ff 7f 21 11
    000000a0: ff fb 8f f1 8f 32 21 11 ff fb 8f f1 6f 11 42 ff
    000000b0: 0f ff 28 ff 13 25 f1 ff f1 9f 11 f1 1d 13 33 f1
    000000c0: ff f1 7f 33 f2 16 18 11 f1 ff f4 7f 33 f1 0f 21
    000000d0: 11 ff 4f ff 37 ff 30 41 f1 ff f4 7f 86 c1 41 21
    000000e0: 22 ff 7f ff 37 12 df 31 ff 8f ff 37 ef 21 12 11
    000000f0: ff 6f ff 37 22 11 16 1f 11 11 11 ff 8f ff 37 22
    00000100: 9f 21 ff cf ff 57 6f 22 11 ff ef ff 37 13 15 1b
    00000110: 11 f1 ff 3f ff 17 11 14 1d 12 13 f1 ff 1f ff 57
    00000120: 1b 36 41 f1 ff fe 7f 21 24 41 21 43 13 ff ff f3
    00000130: 7f 22 c2 41 11 11 ff ff f4 7f f1 13 f2 ff 9f ff
    00000140: 17 0f 23 ff ff fa 7f f2 11 f2 ff af ff 37 fc ff
    00000150: ff f1 7f e2 ff ff 0f ff 28 0f ff ff fd ff 29 f1
    00000160: ff bf ff 9f ff ff fe ff f8 ff ff f0 cf a1 12 ff
    00000170: ff fc ff 29 f1 ff bf ff 8f 11 12 ff ff fa ff 39
    00000180: f1 ff af ff cf ff ff fb ff 1a f3 ff 9f ff bf ff
    00000190: ff fc ff 3a 11 f1 ff 7f ff af 11 ff ff fb ff fc
    000001a0: ff bf ff cf ff ff fb ff 1f ff ff f7 ff 1f ff ff
    000001b0: f7 ff 2f 22 ff ff f2 ff 1f 42 ff ff f1 ff 6f 21
    000001c0: ff ef ff ff 16 f3 ff fd ff af 21 11 ff 8f ff ff
    000001d0: 16 33 f1 ff f9 ff af 32 11 ff 6f ff ff 3a f2 ff
    000001e0: f8 ff 9f ff ef ff ff 59 f1 ff f8 ff 9f 11 ff cf
    000001f0: ff ff 3a 11 f1 ff f7 ff bf 15 ff 6f ff ff fd ff
    00000200: fa ff 9f 31 22 ff 6f ff ff 1d 11 f1 ff f6 7f f1
    00000210: ff f6
  UrbLink              = 00000000
[547234 ms] UsbSnoop - DispatchAny(b5572610) : IRP_MJ_INTERNAL_DEVICE_CONTROL
[547234 ms] UsbSnoop - MyDispatchInternalIOCTL(b5573e80) : fdo=88b11400, Irp=889b46b0, IRQL=2
[547234 ms]  >>>  URB 518 going down  >>> 
-- URB_FUNCTION_BULK_OR_INTERRUPT_TRANSFER:
  PipeHandle           = 88a69984 [endpoint 0x00000082]
  TransferFlags        = 00000003 (USBD_TRANSFER_DIRECTION_IN, USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 0000041c
  TransferBuffer       = 88be9be0
  TransferBufferMDL    = 00000000
  UrbLink              = 00000000
[547244 ms] UsbSnoop - MyInternalIOCTLCompletion(b5573db0) : fido=00000000, Irp=889b46b0, Context=89b05130, IRQL=2
[547244 ms]  <<<  URB 518 coming back  <<< 
-- URB_FUNCTION_BULK_OR_INTERRUPT_TRANSFER:
  PipeHandle           = 88a69984 [endpoint 0x00000082]
  TransferFlags        = 00000003 (USBD_TRANSFER_DIRECTION_IN, USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 0000020a
  TransferBuffer       = 88be9be0
  TransferBufferMDL    = 889b77a8
    00000000: 02 01 08 01 00 20 5e d3 b7 20 00 00 00 00 80 00
    00000010: 50 00 03 00 f4 01 80 ff 3f ff f5 ff ff 3f ff f5
    00000020: ff ff 1d 12 f1 5f ff ff ff f3 5f ff ff af 12 31
    00000030: ff f6 ff ff fb cf ff ff af 15 ff f7 ff ff 2a 11
    00000040: 21 f1 5f ff ff af 11 21 21 ff f5 ff ff 1c 11 f1
    00000050: 7f ff ff af 31 11 ff f7 ff ff 14 27 f2 7f ff ff
    00000060: cf 24 ff f5 ff ff 17 52 f1 7f ff ff 6f 31 ff fd
    00000070: ff ff 14 f5 df ff ff af 14 ff f8 ff ff 36 61 f1
    00000080: 6f ff 17 ff 1d f3 df ff 17 ff 1e 22 f1 af ff ff
    00000090: 7f 21 11 ff fb ff ff 22 23 f1 df ff 17 ff 16 33
    000000a0: f1 ff f1 ff ff 12 41 f2 df ff 18 ff 18 11 21 f2
    000000b0: df ff 28 ff 27 12 21 f1 cf ff 28 ff 36 31 f1 ef
    000000c0: ff 19 11 12 4f 41 22 18 ff 1f ff 37 23 6f 21 21
    000000d0: 12 11 ff 6f ff 37 13 6f 41 22 12 ff 6f ff 37 16
    000000e0: 3f 31 ff ef ff 67 18 1c 14 22 f2 ff f7 7f 23 f1
    000000f0: 1b f3 ff fa 7f 33 c1 c1 12 ff bf ff 37 42 16 12
    00000100: 2c 31 f1 ff f8 7f 23 c2 a1 ff ff f1 7f f5 44 f1
    00000110: ff 2f ff 37 13 25 2a f2 ff 3f ff 17 11 14 1d 22
    00000120: f1 ff 4f ff 67 1a f6 ff 8f ff 17 42 12 14 51 11
    00000130: f1 ff 7f ff 27 22 15 36 11 f1 ff 7f ff 17 3f 12
    00000140: ff ff f9 7f f1 30 f1 ff bf ff 27 1c 23 f1 ff af
    00000150: ff 37 fc ff ff f1 7f e2 ff ff 0f ff 28 fd ff ff
    00000160: f0 ff f8 ff ff f0 ff 15 f3 ff ef ff 8f ff ff 0f
    00000170: ff 1c fa ff ff f0 ff 38 f1 ff bf ff 8f 11 ff ff
    00000180: fd ff f9 ff ef ff af ff ff fd ff 17 22 f1 ff af
    00000190: ff bf ff ff fc ff 2b 11 f1 ff 7f ff af 11 ff ff
    000001a0: fb ff fc ff bf ff cf ff ff fb ff fd ff af ff ff
    000001b0: f1 ff 7f ff ff 32 f1 ff 2f ff ff 21 f2 ff 3f ff
    000001c0: ff 25 f1 ff 0f ff ff 16 f2 ff fe ff 6f 31 ff df
    000001d0: ff ff 16 42 f1 ff f9 ff 9f 13 11 ff 8f ff ff f9
    000001e0: ff fe ff 8f ff ff f0 ff 9f ff ef ff ff 29 f1 ff
    000001f0: fb ff 9f ff ef ff ff f9 ff fe ff 9f ff ef ff ff
    00000200: 19 f1 ff fc ff bf ff cf ff b7
  UrbLink              = 00000000
[547244 ms] UsbSnoop - DispatchAny(b5572610) : IRP_MJ_INTERNAL_DEVICE_CONTROL
[547244 ms] UsbSnoop - MyDispatchInternalIOCTL(b5573e80) : fdo=88b11400, Irp=889b46b0, IRQL=2
[547244 ms]  >>>  URB 519 going down  >>> 
-- URB_FUNCTION_BULK_OR_INTERRUPT_TRANSFER:
  PipeHandle           = 88a69984 [endpoint 0x00000082]
  TransferFlags        = 00000003 (USBD_TRANSFER_DIRECTION_IN, USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 0000041c
  TransferBuffer       = 88be9be0
  TransferBufferMDL    = 00000000
  UrbLink              = 00000000
[547254 ms] UsbSnoop - MyInternalIOCTLCompletion(b5573db0) : fido=00000000, Irp=889b46b0, Context=889f1268, IRQL=2
[547254 ms]  <<<  URB 519 coming back  <<< 
-- URB_FUNCTION_BULK_OR_INTERRUPT_TRANSFER:
  PipeHandle           = 88a69984 [endpoint 0x00000082]
  TransferFlags        = 00000003 (USBD_TRANSFER_DIRECTION_IN, USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 0000020e
  TransferBuffer       = 88be9be0
  TransferBufferMDL    = 889b77a8
    00000000: 02 01 08 01 00 20 00 f3 b7 20 00 00 00 00 80 00
    00000010: 50 00 03 00 f8 01 80 ff 3f 11 11 31 0f b1 ff ff
    00000020: ff 10 23 11 11 f1 fc ff ff 1d 74 f1 fb ff ff 4f
    00000030: ff f5 ff ff 1c f5 5f ff ff cf 21 11 ff f6 ff ff
    00000040: 1c f1 9f ff ff bf 21 13 ff f5 ff ff 3f ff f5 ff
    00000050: ff 3f ff f5 ff ff 2f ff f6 ff ff 1d f4 5f ff ff
    00000060: df 11 21 ff f5 ff ff 1a f1 bf ff ff bf ff fc ff
    00000070: ff 4a f1 8f ff ff af 21 11 21 ff f5 ff ff 4a f3
    00000080: 6f ff 17 ff 2f ff fd ff ff 4a f1 8f ff ff cf 15
    00000090: ff f5 ff ff 27 21 f1 af ff 17 ff 16 32 f2 ff f1
    000000a0: ff ff 16 f3 df ff ff 2f 31 31 ff fd 8f f2 7f 22
    000000b0: 11 ff 0f ff 28 ff 13 15 f3 ff f0 9f 11 f1 17 19
    000000c0: 21 f1 ff f4 7f 11 31 f1 17 15 11 12 f1 ff f4 7f
    000000d0: 33 f1 2b 12 12 f1 ff f4 7f f3 1f 22 ff 8f ff 67
    000000e0: 18 2f 21 32 ff 6f ff 37 ff 11 f3 ff f8 7f f3 10
    000000f0: 1f 12 ff 8f ff 37 22 11 af 11 11 ff 8f ff 37 12
    00000100: af 22 ff bf ff 57 6f 22 ff ff f1 7f 33 f1 12 f3
    00000110: ff 3f ff 17 16 1d 22 21 f2 ff 0f ff 67 1c 34 f2
    00000120: ff 3f ff 17 32 13 28 f4 ff 7f ff 17 13 1d 16 f1
    00000130: ff 4f ff 17 6f ff ff f9 7f f1 30 22 f1 ff 7f ff
    00000140: 27 1c 13 f2 ff af ff 37 fc ff ff f1 7f f2 f0 ff
    00000150: ef ff 28 1d f1 ff df ff 8f 13 ff ff fb ff 15 f3
    00000160: ff ef ff 7f ff ff 1f ff 8f 12 ff ff fc ff 29 f1
    00000170: ff bf ff 8f 11 21 ff ff fa ff f9 ff ef ff af 11
    00000180: 11 ff ff f9 ff 1a f2 ff af ff bf ff ff fc ff 2b
    00000190: 11 f1 ff 7f ff af 11 ff ff fb ff fc ff bf ff cf
    000001a0: ff ff fb ff 0f ff ff f8 ff 1f ff ff f7 ff 2f 13
    000001b0: ff ff f2 ff 1f 42 ff ff f1 ff 6f 21 ff ef ff ff
    000001c0: 16 f3 ff fd ff 6f 31 12 ff af ff ff 16 33 f1 ff
    000001d0: f9 ff 9f 11 12 ff 9f ff ff 19 11 31 f1 ff f6 ff
    000001e0: 9f 11 ff cf ff ff 19 31 f1 ff f8 ff 9f 11 ff cf
    000001f0: ff ff f9 ff fe ff 9f 14 ff 9f ff ff fc ff fb ff
    00000200: 9f 31 12 ff 7f ff ff fc ff fb 7f fc ff fb
  UrbLink              = 00000000
[547254 ms] UsbSnoop - DispatchAny(b5572610) : IRP_MJ_INTERNAL_DEVICE_CONTROL
[547254 ms] UsbSnoop - MyDispatchInternalIOCTL(b5573e80) : fdo=88b11400, Irp=889b46b0, IRQL=2
[547254 ms]  >>>  URB 520 going down  >>> 
-- URB_FUNCTION_BULK_OR_INTERRUPT_TRANSFER:
  PipeHandle           = 88a69984 [endpoint 0x00000082]
  TransferFlags        = 00000003 (USBD_TRANSFER_DIRECTION_IN, USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 0000041c
  TransferBuffer       = 88be9be0
  TransferBufferMDL    = 00000000
  UrbLink              = 00000000
[547264 ms] UsbSnoop - MyInternalIOCTLCompletion(b5573db0) : fido=00000000, Irp=889b46b0, Context=899e8388, IRQL=2
[547264 ms]  <<<  URB 520 coming back  <<< 
-- URB_FUNCTION_BULK_OR_INTERRUPT_TRANSFER:
  PipeHandle           = 88a69984 [endpoint 0x00000082]
  TransferFlags        = 00000003 (USBD_TRANSFER_DIRECTION_IN, USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000206
  TransferBuffer       = 88be9be0
  TransferBufferMDL    = 889b77a8
    00000000: 02 01 08 01 00 20 ca 12 b8 20 00 00 00 00 80 00
    00000010: 50 00 03 00 f0 01 80 ff 3f 14 ff f0 ff ff 3f 11
    00000020: ff f3 ff ff 3f ff f5 ff ff 1c f5 4f ff ff df 42
    00000030: ff f5 ff ff 2b 13 f1 5f ff ff cf 11 ff f9 ff ff
    00000040: 1a 21 21 f1 5f ff ff cf 51 ff f4 ff ff 1f 11 ff
    00000050: f6 ff ff 1e f1 7f ff ff df 41 ff f5 ff ff 3c f2
    00000060: 6f ff ff af 11 22 ff f7 ff ff fb cf ff ff af 14
    00000070: ff f8 ff ff 4a 21 f1 5f ff ff 2f 41 21 ff fd 7f
    00000080: f1 ff f1 ef ff ff af ff fd ff ff 16 13 11 f1 9f
    00000090: ff ff 2f 23 21 ff fd 7f f1 af 23 ff 0f ff ff 2f
    000000a0: 11 21 21 ff fd ff ef 21 11 11 31 ff fd 8f f2 5f
    000000b0: 11 24 ff 0f ff 28 ff 14 21 11 f2 ff f1 9f 11 f1
    000000c0: 1d 46 f1 ff f1 7f 11 31 f1 17 12 12 21 f1 ff f6
    000000d0: 7f 33 f1 16 14 13 12 f1 ff f4 7f f3 0f 14 ff 8f
    000000e0: ff 67 df 23 ff 7f ff 37 ef 13 11 ff 8f ff 37 13
    000000f0: af 11 13 ff 8f ff 37 22 11 16 1f 21 12 ff 8f ff
    00000100: 37 12 9f ff ff f1 7f f5 14 21 f1 ff 2f ff 37 13
    00000110: 1c 23 11 f1 ff 3f ff 17 16 1d 31 21 f1 ff 1f ff
    00000120: 67 18 13 f4 ff 8f ff 17 32 13 46 f2 ff 9f ff 17
    00000130: 1a 16 25 f1 ff 4f ff df ff ff fa 7f f1 21 f1 ff
    00000140: bf ff 27 1c 23 f2 ff 9f ff 37 fc ff ff f1 7f f2
    00000150: f0 ff ef ff 28 0f ff ff fd ff 47 f1 ff bf ff 5f
    00000160: 21 ff ff 0f ff 8f ff ff 0f ff 8f ff ff 0f ff 8f
    00000170: 13 ff ff fb ff 18 f1 ff df ff 9f ff ff fe ff f9
    00000180: ff ef ff 7f 21 21 ff ff fa ff fb ff cf ff af 13
    00000190: ff ff f9 ff fc ff bf ff cf ff ff fb ff fc ff bf
    000001a0: ff ff f0 ff 8f ff df 21 ff ff f7 ff 1f ff ff f7
    000001b0: ff 1f 22 ff ff f3 ff 5f ff ff f3 ff 6f 12 ff ef
    000001c0: ff ff 16 f3 ff fd ff 6f 21 14 ff 9f ff ff 19 13
    000001d0: f1 ff f8 ff 9f 15 ff 8f ff ff f7 ff 1f ff ff 16
    000001e0: f1 ff 0f ff ff 19 f1 ff fc ff 9f 11 ff cf ff ff
    000001f0: 49 f1 ff f9 ff 9f ff ef ff ff fc ff fb ff 9f 11
    00000200: ff cf ff 17 ff cf
  UrbLink              = 00000000
[547264 ms] UsbSnoop - DispatchAny(b5572610) : IRP_MJ_INTERNAL_DEVICE_CONTROL
[547264 ms] UsbSnoop - MyDispatchInternalIOCTL(b5573e80) : fdo=88b11400, Irp=889b46b0, IRQL=2
[547264 ms]  >>>  URB 521 going down  >>> 
-- URB_FUNCTION_BULK_OR_INTERRUPT_TRANSFER:
  PipeHandle           = 88a69984 [endpoint 0x00000082]
  TransferFlags        = 00000003 (USBD_TRANSFER_DIRECTION_IN, USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 0000041c
  TransferBuffer       = 88be9be0
  TransferBufferMDL    = 00000000
  UrbLink              = 00000000
[547274 ms] UsbSnoop - MyInternalIOCTLCompletion(b5573db0) : fido=00000000, Irp=889b46b0, Context=889dd5d0, IRQL=2
[547274 ms]  <<<  URB 521 coming back  <<< 
-- URB_FUNCTION_BULK_OR_INTERRUPT_TRANSFER:
  PipeHandle           = 88a69984 [endpoint 0x00000082]
  TransferFlags        = 00000003 (USBD_TRANSFER_DIRECTION_IN, USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000206
  TransferBuffer       = 88be9be0
  TransferBufferMDL    = 889b77a8
    00000000: 02 01 08 01 00 20 8d 32 b8 20 00 00 00 00 80 00
    00000010: 50 00 03 00 f0 01 80 ff 3f 21 12 df ff ff ff 14
    00000020: 11 f1 1f ff ff ff 43 f2 fd ff ff 4f 11 ff f2 ff
    00000030: ff 4f ff f5 ff ff 1b 22 f1 6f ff ff ff 82 f1 fc
    00000040: ff ff 1f 11 ff f4 ff ff 4f ff f5 ff ff 3f ff f5
    00000050: ff ff 3f ff f4 ff ff 1e f4 5f ff ff df 11 11 ff
    00000060: f6 ff ff 3c f1 7f ff ff af ff fd ff ff fa df ff
    00000070: ff af 21 11 ff f8 ff ff 4a 11 f1 6f ff 17 ff 2f
    00000080: ff fd ff ff 17 f5 af ff ff cf ff fb ff ff 22 14
    00000090: 21 f1 af ff ff 1e 14 11 f1 ff f0 ff ff 14 15 f1
    000000a0: bf ff ff 2f 11 11 31 ff fd 8f f1 8f 21 12 ff 0f
    000000b0: ff 19 ff 17 15 f1 df ff 19 11 ff 21 24 f1 ff f1
    000000c0: 7f 11 31 f1 17 12 12 11 f3 ff f5 7f 33 f1 2b 22
    000000d0: 11 f1 ff f4 7f f3 1f 12 ff 9f ff 37 21 18 2f 21
    000000e0: 32 ff 6f ff 27 ff f6 ff f8 7f f2 0f 14 11 ff 7f
    000000f0: ff 27 14 11 af 13 ff 8f ff 37 12 af ff ff f0 7f
    00000100: f5 15 11 f2 ff 1f ff 37 13 1e 11 24 f1 ff 0f ff
    00000110: 17 16 1d 22 f3 ff 2f ff 67 18 29 f1 ff 4f ff 17
    00000120: 32 13 18 11 11 f1 ff 7f ff 17 2f 51 ff ff f7 7f
    00000130: f1 f6 ff 9f ff 17 0f 11 11 16 ff ff f4 7f c2 31
    00000140: 21 ff ff fa 7f c3 ff ff 1f ff 27 fe ff ff f0 8f
    00000150: f2 f0 ff df ff 9f 12 ff ff fb ff 15 f3 ff ef ff
    00000160: 8f ff ff 0f ff 8f ff ff 0f ff 8f 11 11 ff ff fb
    00000170: ff 38 f1 ff bf ff 9f ff ff fe ff 29 f1 ff bf ff
    00000180: 7f 21 12 ff ff fa ff fb ff cf ff af 15 ff ff f7
    00000190: ff fc ff bf ff cf ff ff fb ff fc ff bf ff df 11
    000001a0: ff ff f8 ff 1f ff ff f7 ff 2f 22 ff ff f2 ff 1f
    000001b0: 32 ff ff f2 ff 6f 11 ff ff f0 ff 6f 31 14 11 ff
    000001c0: 6f ff ff 16 32 f1 ff fa ff 9f 23 ff 9f ff ff 39
    000001d0: f1 ff fa ff 9f 15 ff 8f ff ff 17 f1 ff fe ff 9f
    000001e0: 11 13 ff 8f ff ff 1a f1 ff fb ff af ff df ff ff
    000001f0: 1a f1 ff fb ff cf ff bf ff ff 3c f2 ff f6 ff bf
    00000200: ff cf ff b7 ff cf
  UrbLink              = 00000000
[547274 ms] UsbSnoop - DispatchAny(b5572610) : IRP_MJ_INTERNAL_DEVICE_CONTROL
[547274 ms] UsbSnoop - MyDispatchInternalIOCTL(b5573e80) : fdo=88b11400, Irp=889b46b0, IRQL=2
[547274 ms]  >>>  URB 522 going down  >>> 
-- URB_FUNCTION_BULK_OR_INTERRUPT_TRANSFER:
  PipeHandle           = 88a69984 [endpoint 0x00000082]
  TransferFlags        = 00000003 (USBD_TRANSFER_DIRECTION_IN, USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 0000041c
  TransferBuffer       = 88be9be0
  TransferBufferMDL    = 00000000
  UrbLink              = 00000000
[547283 ms] UsbSnoop - MyInternalIOCTLCompletion(b5573db0) : fido=00000000, Irp=889b46b0, Context=88a02730, IRQL=2
[547283 ms]  <<<  URB 522 coming back  <<< 
-- URB_FUNCTION_BULK_OR_INTERRUPT_TRANSFER:
  PipeHandle           = 88a69984 [endpoint 0x00000082]
  TransferFlags        = 00000003 (USBD_TRANSFER_DIRECTION_IN, USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 000001fe
  TransferBuffer       = 88be9be0
  TransferBufferMDL    = 889b77a8
    00000000: 02 01 08 01 00 20 68 52 b8 20 00 00 00 00 80 00
    00000010: 50 00 03 00 e8 01 80 ff 3f 14 ef ff ff ff 45 f1
    00000020: fd ff ff 4f 13 ff f0 ff ff 4f ff f5 ff ff 3f ff
    00000030: f5 ff ff 1c 12 f2 5f ff ff ff 10 f1 6f ff ff af
    00000040: 11 21 12 ff f5 ff ff 0f 21 ff f4 ff ff 2f 11 ff
    00000050: f5 ff ff 1c 11 f2 6f ff ff df 41 ff f4 ff ff 1d
    00000060: 21 f2 5f ff ff cf 22 ff f7 ff ff fb cf ff ff af
    00000070: 14 ff f8 ff ff 2a 11 f1 8f ff ff 7f 21 16 ff f6
    00000080: 7f f1 ff f1 ef ff ff af 12 ff fa ff ff fc bf ff
    00000090: ff 3f 12 22 12 ff fa ff ff 32 f2 ff f1 ff ff 12
    000000a0: 11 11 f2 ef ff ff 2f 31 31 ff fd 8f f1 6f 11 51
    000000b0: 11 ff fd 9f f1 7f 42 ff 0f ff 1b ff 21 12 21 f1
    000000c0: ff f1 7f 51 f1 17 25 11 11 f1 ff f4 7f 33 f1 16
    000000d0: 15 31 11 f1 ff f4 8f f2 0f 14 ff 8f ff 27 22 cf
    000000e0: 21 21 ff 7f ff 27 ff 12 f3 ff f8 7f 42 f1 19 f2
    000000f0: ff fc 7f 42 11 f1 16 11 31 f1 ff f8 7f 23 f1 f9
    00000100: ff 1f ff 27 21 17 1b 31 f1 ff 1f ff 28 3f 11 31
    00000110: ff ff f4 7f 61 d1 21 21 12 ff ff f1 7f 11 f4 f2
    00000120: ff 8f ff 17 32 13 15 31 f4 ff 7f ff 17 2f 42 12
    00000130: ff ff f4 ff fd ff af ff 17 1f 22 ff ff fa 7f f2
    00000140: f1 ff df ff 37 fc ff ff f1 7f f2 f0 ff ef ff 28
    00000150: 0f ff ff fd ff f9 ff ef ff 5f 21 ff ff 0f ff 8f
    00000160: ff ff 0f ff 8f ff ff 0f ff 8f 13 ff ff fb ff 18
    00000170: f1 ff df ff 9f ff ff fe ff 19 f2 ff bf ff 7f 21
    00000180: 21 ff ff fa ff fb ff cf ff af 13 ff ff f9 ff fc
    00000190: ff bf ff cf ff ff fb ff fc ff bf ff ff f1 ff 7f
    000001a0: ff ff f1 ff 7f ff ff 41 f1 ff 2f ff ff 21 f2 ff
    000001b0: 3f ff ff 16 f1 ff 0f ff ff 16 f2 ff fe ff 6f 31
    000001c0: 12 ff af ff ff 16 f3 ff fd ff 9f 13 ff af ff ff
    000001d0: f9 ff fe ff 7f 11 ff ef ff ff 17 f1 ff fe ff 9f
    000001e0: ff ef ff ff 19 21 f1 ff f9 ff 9f ff ef ff ff 29
    000001f0: f1 ff fb ff cf 13 ff 7f ff ff fc ff fb 7f
  UrbLink              = 00000000
[547283 ms] UsbSnoop - DispatchAny(b5572610) : IRP_MJ_INTERNAL_DEVICE_CONTROL
[547283 ms] UsbSnoop - MyDispatchInternalIOCTL(b5573e80) : fdo=88b11400, Irp=889b46b0, IRQL=2
[547283 ms]  >>>  URB 523 going down  >>> 
-- URB_FUNCTION_BULK_OR_INTERRUPT_TRANSFER:
  PipeHandle           = 88a69984 [endpoint 0x00000082]
  TransferFlags        = 00000003 (USBD_TRANSFER_DIRECTION_IN, USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 0000041c
  TransferBuffer       = 88be9be0
  TransferBufferMDL    = 00000000
  UrbLink              = 00000000
[547292 ms] UsbSnoop - MyInternalIOCTLCompletion(b5573db0) : fido=00000000, Irp=889b46b0, Context=889ebab0, IRQL=2
[547292 ms]  <<<  URB 523 coming back  <<< 
-- URB_FUNCTION_BULK_OR_INTERRUPT_TRANSFER:
  PipeHandle           = 88a69984 [endpoint 0x00000082]
  TransferFlags        = 00000003 (USBD_TRANSFER_DIRECTION_IN, USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 000001fa
  TransferBuffer       = 88be9be0
  TransferBufferMDL    = 889b77a8
    00000000: 02 01 08 01 00 20 7f 72 b8 20 00 00 00 00 80 00
    00000010: 50 00 03 00 e4 01 80 ff 5f 12 21 bf ff ff ff fa
    00000020: fd ff ff 4f 12 12 df ff ff ff f4 4f ff ff df 51
    00000030: ff f4 ff ff 1d f4 6f ff ff af 31 21 ff f5 ff ff
    00000040: 1c 14 f1 4f ff ff ff f4 4f ff ff ff f4 5f ff ff
    00000050: ef 21 ff f5 ff ff 4f ff f5 ff ff 1d f4 5f ff ff
    00000060: af 11 13 11 ff f5 ff ff 13 46 f1 8f ff ff af 12
    00000070: 11 ff f8 ff ff 1a 11 12 f2 5f ff ff af 15 ff f7
    00000080: 7f f1 ff 72 f1 5f ff ff cf 14 ff f6 ff ff fd af
    00000090: ff ff 2f 11 21 21 ff fd ff ff 12 35 41 f1 6f ff
    000000a0: ff af 11 ff fb ff ff 12 13 f3 df ff 18 ff 28 f4
    000000b0: ff f0 9f f1 3f 51 31 11 ff fd ff ff 12 21 f1 ff
    000000c0: f1 df f1 17 12 14 12 f1 ff f4 7f 33 f1 1b 13 12
    000000d0: f2 ff f3 8f f2 2f 21 11 ff 6f ff 17 ff 15 f3 ff
    000000e0: f6 7f f1 7f ff 8f ff 27 ff 33 f1 ff f7 7f 51 f1
    000000f0: 1a 22 f2 ff f7 7f 23 f1 f9 ff 1f ff 17 13 17 1b
    00000100: 11 f3 ff 1f ff 28 5f 41 ff ff f3 7f 61 f1 30 12
    00000110: f1 ff 1f ff 17 41 3f 17 ff ef ff 17 32 3b f4 ff
    00000120: 7f ff 17 2f 51 12 ff ff f4 ff fe ff 9f ff 17 2f
    00000130: 21 ff ff fa 7f f2 11 f2 ff af ff 37 fd ff ff f0
    00000140: 7f f2 10 f1 ff cf ff 28 fe ff ef ff 9f ff ff fe
    00000150: ff 15 f3 ff ef ff 8f ff ff 0f ff 9f 21 ff ff fb
    00000160: ff 18 11 f1 ff bf ff 8f 11 11 ff ff fb ff 49 f1
    00000170: ff 9f ff cf ff ff fb ff 1a f2 ff af ff bf ff ff
    00000180: fc ff 5a f1 ff 7f ff cf ff ff fb ff fc ff bf ff
    00000190: cf 16 ff ff f4 ff 2f ff ff f6 ff 2f 13 ff ff f2
    000001a0: ff 2f 22 ff ff f2 ff 6f ff ff f2 ff 6f 21 ff ef
    000001b0: ff ff f9 ff fe ff 6f 31 12 13 ff 6f ff ff 3b f1
    000001c0: ff f8 ff 9f 11 11 ff af ff ff 2a 11 f1 ff f8 ff
    000001d0: 9f 11 ff cf ff ff f9 ff fe ff cf ff bf ff ff 19
    000001e0: f1 ff fc ff af ff df ff ff 19 42 f1 ff f6 ff df
    000001f0: 22 ff 6f ff ff fb ff fc 7f fb
  UrbLink              = 00000000
[547292 ms] UsbSnoop - DispatchAny(b5572610) : IRP_MJ_INTERNAL_DEVICE_CONTROL
[547292 ms] UsbSnoop - MyDispatchInternalIOCTL(b5573e80) : fdo=88b11400, Irp=889b46b0, IRQL=2
[547292 ms]  >>>  URB 524 going down  >>> 
-- URB_FUNCTION_BULK_OR_INTERRUPT_TRANSFER:
  PipeHandle           = 88a69984 [endpoint 0x00000082]
  TransferFlags        = 00000003 (USBD_TRANSFER_DIRECTION_IN, USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 0000041c
  TransferBuffer       = 88be9be0
  TransferBufferMDL    = 00000000
  UrbLink              = 00000000
[547302 ms] UsbSnoop - MyInternalIOCTLCompletion(b5573db0) : fido=00000000, Irp=889b46b0, Context=899e8388, IRQL=2
[547302 ms]  <<<  URB 524 coming back  <<< 
-- URB_FUNCTION_BULK_OR_INTERRUPT_TRANSFER:
  PipeHandle           = 88a69984 [endpoint 0x00000082]
  TransferFlags        = 00000003 (USBD_TRANSFER_DIRECTION_IN, USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000202
  TransferBuffer       = 88be9be0
  TransferBufferMDL    = 889b77a8
    00000000: 02 01 08 01 00 20 a7 91 b8 20 00 00 00 00 80 00
    00000010: 50 00 03 00 ec 01 80 ff 6f 22 cf ff ff ff 14 13
    00000020: f2 fc ff ff 4f 41 12 bf ff ff ff f4 4f ff ff df
    00000030: 51 ff f4 ff ff 1d 12 f2 4f ff ff df 21 12 ff f4
    00000040: ff ff 1b 11 f5 4f ff ff ff f4 4f ff ff ff f4 4f
    00000050: ff ff ff f3 5f ff ff ff f4 4f ff ff ef 31 ff f5
    00000060: ff ff 2e f1 7f ff ff bf ff fb ff ff 3b f2 8f ff
    00000070: ff af 21 11 21 ff f5 ff ff 4a 11 f1 6f ff 17 ff
    00000080: 2f 13 ff f8 ff ff 18 12 11 21 f1 5f ff ff ef 11
    00000090: 11 ff f6 ff ff 17 22 f1 af ff ff 4f 21 19 ff f6
    000000a0: ff ff fa df ff ff 2f 11 11 31 ff fd 8f f1 8f 31
    000000b0: 11 11 ff fd 9f f1 9f 31 11 ff fd ff ff 12 21 f1
    000000c0: ff f1 df f1 17 16 13 f1 ff f4 7f f2 4f 22 11 ff
    000000d0: 4f ff 28 ff 31 11 f1 ff f6 7f f1 8f ff 7f ff 17
    000000e0: ff 14 f4 ff f6 7f f2 1e 11 11 f2 ff f8 7f f1 2e
    000000f0: 12 f1 ff fa 7f 23 f1 fa ff 0f ff 17 13 17 2b 11
    00000100: f2 ff 1f ff 28 5f 41 ff ff f3 ff 1d 22 21 11 f2
    00000110: ff fd 7f 11 f4 23 f1 ff 4f ff 17 32 1c f5 ff 7f
    00000120: ff 17 3f 21 21 11 ff ff f4 ff fe ff 9f ff 17 2f
    00000130: 21 12 ff ff f7 7f f2 11 f1 ff bf ff 27 fe ff ff
    00000140: f0 7f f2 10 f1 ff cf ff 28 0f ff ff fd ff 29 f1
    00000150: ff bf ff af ff ff fd ff f8 ff ff f0 ff 19 f1 ff
    00000160: cf ff 9f 12 ff ff fb ff f9 ff ef ff 9f 15 ff ff
    00000170: f8 ff fc ff bf ff df ff ff fa ff fb ff cf ff bf
    00000180: 12 11 ff ff f7 ff fc ff bf ff df ff ff fa ff fd
    00000190: ff af ff ff 41 f1 ff 2f ff ff 22 f2 ff 2f ff ff
    000001a0: 21 14 f1 ff fe ff 2f 21 ff ff f3 ff 5f 22 ff ef
    000001b0: ff ff 2a 31 f1 ff f6 ff 6f 31 12 ff af ff ff 39
    000001c0: 11 f1 ff f8 ff 9f 22 12 ff 7f ff ff 2a 13 f1 ff
    000001d0: f6 ff 7f 11 11 ff cf ff ff 59 f1 ff f8 ff af 12
    000001e0: 13 ff 6f ff ff fb ff fc ff 9f 14 ff 9f ff ff fc
    000001f0: ff fb ff 9f 31 12 ff 7f ff ff 2c 11 f1 ff f6 7f
    00000200: f1 ff
  UrbLink              = 00000000
[547302 ms] UsbSnoop - DispatchAny(b5572610) : IRP_MJ_INTERNAL_DEVICE_CONTROL
[547302 ms] UsbSnoop - MyDispatchInternalIOCTL(b5573e80) : fdo=88b11400, Irp=889b46b0, IRQL=2
[547302 ms]  >>>  URB 525 going down  >>> 
-- URB_FUNCTION_BULK_OR_INTERRUPT_TRANSFER:
  PipeHandle           = 88a69984 [endpoint 0x00000082]
  TransferFlags        = 00000003 (USBD_TRANSFER_DIRECTION_IN, USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 0000041c
  TransferBuffer       = 88be9be0
  TransferBufferMDL    = 00000000
  UrbLink              = 00000000
[547311 ms] UsbSnoop - MyInternalIOCTLCompletion(b5573db0) : fido=00000000, Irp=889b46b0, Context=88b3f208, IRQL=2
[547311 ms]  <<<  URB 525 coming back  <<< 
-- URB_FUNCTION_BULK_OR_INTERRUPT_TRANSFER:
  PipeHandle           = 88a69984 [endpoint 0x00000082]
  TransferFlags        = 00000003 (USBD_TRANSFER_DIRECTION_IN, USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 000001f6
  TransferBuffer       = 88be9be0
  TransferBufferMDL    = 889b77a8
    00000000: 02 01 08 01 00 20 6e b1 b8 20 00 00 00 00 80 00
    00000010: 50 00 03 00 e0 01 80 ff 4f 13 12 bf ff ff ff 18
    00000020: 11 f1 fb ff ff 4f 12 ff f1 ff ff 4f 13 ff f0 ff
    00000030: ff 1d f5 4f ff ff cf 31 21 ff f4 ff ff 4f ff f4
    00000040: ff ff 2c 11 11 f1 4f ff ff ff f4 4f ff ff ff 11
    00000050: f2 4f ff ff ff 10 f2 5f ff ff ef 41 ff f4 ff ff
    00000060: 2d f3 5f ff ff bf 11 12 ff f7 ff ff fc bf ff ff
    00000070: bf ff fd ff ff 1a f6 5f ff ff bf 15 ff f6 8f f1
    00000080: ff f2 cf ff ff bf 21 13 ff f5 ff ff 1b f1 af ff
    00000090: ff 3f 22 ff 2f ff ff 4f 21 14 14 ff f5 ff ff fc
    000000a0: cf ff ff 2f 22 31 ff fd 8f f1 8f 11 31 11 ff fd
    000000b0: ff ff f8 ff f0 ff ef 31 13 ff 1f ff 1d 7f a1 11
    000000c0: ff 4f ff 18 ff 18 f1 ff f4 8f f1 3f 21 11 ff 6f
    000000d0: ff 17 ff f8 ff f7 7f f1 3f 11 21 ff 7f ff 27 ff
    000000e0: 32 f1 ff f8 7f f1 0f 22 ff bf ff 27 13 af 11 ff
    000000f0: df ff 17 1b 1b 12 21 f1 ff fe ff 0f 41 ff ff f3
    00000100: ff 1d 31 12 f1 ff 1f ff 17 21 5f 13 ff ff f3 7f
    00000110: 41 91 21 42 ff ff f7 7f f1 13 24 f1 ff 4f ff df
    00000120: ff ff fa 7f f1 21 22 f1 ff 7f ff 27 1e 11 f2 ff
    00000130: af ff 27 1e f1 ff df ff 27 1f ff ff fd 8f e2 ff
    00000140: ff fe ff f9 ff ef ff 9f ff ff fe ff f8 ff ff f0
    00000150: ff 19 f1 ff cf ff 8f 13 ff ff fb ff 1a f1 ff bf
    00000160: ff 9f ff ff fe ff 29 f1 ff bf ff df ff ff fa ff
    00000170: fb ff cf ff bf 14 ff ff f7 ff fc ff bf ff cf ff
    00000180: ff fb ff fd ff af ff ff f1 ff 7f ff ff 12 f3 ff
    00000190: 2f ff ff 12 f3 ff 2f ff ff 12 22 f1 ff 0f ff ff
    000001a0: 25 11 21 f1 ff fa ff af ff df ff ff 16 23 31 f1
    000001b0: ff f6 ff 9f 11 21 12 ff 6f ff ff 39 f3 ff f8 ff
    000001c0: bf 31 ff 8f ff ff 19 f1 ff fc ff 9f ff ef ff ff
    000001d0: 19 51 f1 ff f6 ff bf 12 ff 9f ff ff 39 f2 ff f9
    000001e0: ff 9f 21 ff bf ff ff 19 32 f3 ff f5 ff cf 12 ff
    000001f0: 8f ff 17 ff 8f ff
  UrbLink              = 00000000
[547311 ms] UsbSnoop - DispatchAny(b5572610) : IRP_MJ_INTERNAL_DEVICE_CONTROL
[547311 ms] UsbSnoop - MyDispatchInternalIOCTL(b5573e80) : fdo=88b11400, Irp=889b46b0, IRQL=2
[547311 ms]  >>>  URB 526 going down  >>> 
-- URB_FUNCTION_BULK_OR_INTERRUPT_TRANSFER:
  PipeHandle           = 88a69984 [endpoint 0x00000082]
  TransferFlags        = 00000003 (USBD_TRANSFER_DIRECTION_IN, USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 0000041c
  TransferBuffer       = 88be9be0
  TransferBufferMDL    = 00000000
  UrbLink              = 00000000
[547319 ms] UsbSnoop - MyInternalIOCTLCompletion(b5573db0) : fido=00000000, Irp=889b46b0, Context=889f1268, IRQL=2
[547319 ms]  <<<  URB 526 coming back  <<< 
-- URB_FUNCTION_BULK_OR_INTERRUPT_TRANSFER:
  PipeHandle           = 88a69984 [endpoint 0x00000082]
  TransferFlags        = 00000003 (USBD_TRANSFER_DIRECTION_IN, USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 000001fa
  TransferBuffer       = 88be9be0
  TransferBufferMDL    = 889b77a8
    00000000: 02 01 08 01 00 20 2a d1 b8 20 00 00 00 00 80 00
    00000010: 50 00 03 00 e4 01 80 ff 3f 41 21 bf ff ff ff 14
    00000020: 21 f4 fb ff ff 4f 22 11 df ff ff ff f6 2f ff ff
    00000030: df 61 ff f3 ff ff 1d 12 f2 4f ff ff ff 11 f2 4f
    00000040: ff ff cf 61 ff f4 ff ff 1d 65 f1 fc ff ff 3f ff
    00000050: f5 ff ff 0f 31 ff f4 ff ff 1e f4 4f ff ff ef 41
    00000060: ff f4 ff ff 1e f2 6f ff ff cf 11 14 ff f4 ff ff
    00000070: 4b f2 6f ff ff ff 12 f1 4f ff ff bf 23 11 ff f5
    00000080: ff ff fb cf ff ff bf 11 11 ff f8 ff ff fd af ff
    00000090: ff 4f 31 21 12 ff f9 ff ff 15 42 41 f1 5f ff ff
    000000a0: 8f 21 11 ff fa ff ff 23 f6 cf ff ff 1f 11 22 11
    000000b0: 11 ff fc ff ff 35 f1 ef ff ff 0f 21 11 21 ff 0f
    000000c0: ff ff 17 12 15 f3 ff f4 ff ef 21 11 ff 4f ff 18
    000000d0: ff 13 12 f1 ff f5 8f f1 4f 22 ff 6f ff ff 1f 11
    000000e0: ff 5f ff 18 ff 23 11 f1 ff f7 ff 7f 31 22 ff 8f
    000000f0: ff 27 ef 12 ff cf ff 4f b1 41 ff ff f2 ff 0f 51
    00000100: ff ff f2 ff 1d 12 13 f3 ff fe 9f f1 26 f2 ff 3f
    00000110: ff 17 14 1c f5 ff 7f ff 17 8f 12 ff ff f4 ff fd
    00000120: ff af ff 17 1f 31 12 ff ff f7 7f f2 11 f2 ff af
    00000130: ff 27 fe ff ff f0 7f f2 f2 ff cf ff 28 0f ff ff
    00000140: fd ff 29 f1 ff bf ff af ff ff fd ff f8 ff ff f0
    00000150: ff 19 f1 ff cf ff 8f 11 21 ff ff fa ff 18 11 f1
    00000160: ff bf ff 9f ff ff fe ff fe ff 9f ff df ff ff fa
    00000170: ff fb ff cf ff bf 11 12 ff ff f7 ff fc ff bf ff
    00000180: cf ff ff fb ff fc ff bf ff ff f1 ff 7f ff ff 12
    00000190: 11 f1 ff 2f ff ff 12 13 f1 ff 0f ff ff 11 13 f1
    000001a0: ff 1f ff ff 25 f2 ff fe ff bf 12 12 ff 6f ff ff
    000001b0: 16 23 21 f2 ff f6 ff 9f 31 11 ff 8f ff ff 19 11
    000001c0: 11 11 f1 ff f6 ff af 12 11 11 ff 6f ff ff 19 f1
    000001d0: ff fc ff 9f 14 ff 9f ff ff fb ff fc ff bf 12 11
    000001e0: ff 7f ff ff 49 21 f1 ff f6 ff cf 31 ff 7f ff ff
    000001f0: 1e f3 ff f5 ff ff f2 ff f6 7f
  UrbLink              = 00000000
[547319 ms] UsbSnoop - DispatchAny(b5572610) : IRP_MJ_INTERNAL_DEVICE_CONTROL
[547319 ms] UsbSnoop - MyDispatchInternalIOCTL(b5573e80) : fdo=88b11400, Irp=889b46b0, IRQL=2
[547319 ms]  >>>  URB 527 going down  >>> 
-- URB_FUNCTION_BULK_OR_INTERRUPT_TRANSFER:
  PipeHandle           = 88a69984 [endpoint 0x00000082]
  TransferFlags        = 00000003 (USBD_TRANSFER_DIRECTION_IN, USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 0000041c
  TransferBuffer       = 88be9be0
  TransferBufferMDL    = 00000000
  UrbLink              = 00000000
[547328 ms] UsbSnoop - MyInternalIOCTLCompletion(b5573db0) : fido=00000000, Irp=889b46b0, Context=88a02730, IRQL=2
[547328 ms]  <<<  URB 527 coming back  <<< 
-- URB_FUNCTION_BULK_OR_INTERRUPT_TRANSFER:
  PipeHandle           = 88a69984 [endpoint 0x00000082]
  TransferFlags        = 00000003 (USBD_TRANSFER_DIRECTION_IN, USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 000001ee
  TransferBuffer       = 88be9be0
  TransferBufferMDL    = 889b77a8
    00000000: 02 01 08 01 00 20 f4 f0 b8 20 00 00 00 00 80 00
    00000010: 50 00 03 00 d8 01 80 ff 3f 23 21 bf ff ff ff fc
    00000020: fb ff ff 1f 21 21 12 df ff ff ff 14 f1 2f ff ff
    00000030: ff f4 4f ff ff bf 11 51 ff f4 ff ff 1d f5 4f ff
    00000040: ff ff 44 f1 fe ff ff 4f 16 cf ff ff ff f4 4f ff
    00000050: ff ff 12 f1 4f ff ff ef 31 ff f5 ff ff 1d f5 4f
    00000060: ff ff bf 21 31 ff f5 ff ff 3b f2 7f ff ff bf 14
    00000070: ff f7 ff ff 1b 12 21 f1 4f ff ff 8f 21 16 ff f5
    00000080: ff ff 17 53 f1 6f ff ff df 12 ff f7 ff ff 1c 31
    00000090: f1 5f ff ff 3f 41 21 12 ff f9 ff ff 24 22 11 f1
    000000a0: af ff ff 5f 41 ff fd ff ff 13 13 f3 cf ff ff 3f
    000000b0: 13 11 11 ff fc ff ff 19 f1 cf ff ff 1e 33 f2 ff
    000000c0: f0 ff df 51 12 ff 1f ff ff 1f 11 11 ff 4f ff ff
    000000d0: 1a 23 f1 ff f5 ff df 21 21 ff 4f ff ff 1e f1 ff
    000000e0: f7 ff cf 12 12 ff 5f ff ff 2c f2 ff f7 ff 9f 12
    000000f0: ff bf ff ff f8 ff 0f ff 5f f1 f1 ff 1f ff ff 11
    00000100: 23 f1 ff 0f ff ff f1 ff 7f ff cf 41 ff ff f6 ff
    00000110: 1b 25 f1 ff 3f ff ef ff ff f9 ff 1a 23 f1 ff 6f
    00000120: ff 18 5f ff ff f9 8f e2 13 ff ff fb 7f e2 ff ff
    00000130: fe 8f f2 f2 ff bf ff af ff ff fd ff fa ff df ff
    00000140: bf ff ff fc ff 29 f1 ff cf ff 9f 21 ff ff fb ff
    00000150: 18 f3 ff af ff af 12 ff ff fb ff fa ff cf ff bf
    00000160: 21 ff ff f9 ff fc ff cf ff af 22 ff ff f8 ff 2d
    00000170: f1 ff 7f ff cf ff ff fb ff fd ff af ff ff f1 ff
    00000180: 7f ff ff 13 f3 ff 1f ff ff 23 22 f1 ff fd ff 7f
    00000190: 12 11 ff bf ff ff 17 f2 ff fd ff 6f 31 11 11 13
    000001a0: ff 5f ff ff 1c f1 ff f9 ff af 11 21 ff 8f ff ff
    000001b0: 1f ff 7f ff ff 1b 11 11 f1 ff f6 ff af 14 ff 8f
    000001c0: ff ff 2b f1 ff f9 ff bf 11 11 ff 8f ff ff 2c f1
    000001d0: ff f8 ff bf 13 ff 8f ff ff 1d 11 f2 ff f5 ff ff
    000001e0: 10 f1 ff f6 ff cf 11 22 ff 5f ff 28 ff 5f
  UrbLink              = 00000000
[547328 ms] UsbSnoop - DispatchAny(b5572610) : IRP_MJ_INTERNAL_DEVICE_CONTROL
[547328 ms] UsbSnoop - MyDispatchInternalIOCTL(b5573e80) : fdo=88b11400, Irp=889b46b0, IRQL=2
[547328 ms]  >>>  URB 528 going down  >>> 
-- URB_FUNCTION_BULK_OR_INTERRUPT_TRANSFER:
  PipeHandle           = 88a69984 [endpoint 0x00000082]
  TransferFlags        = 00000003 (USBD_TRANSFER_DIRECTION_IN, USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 0000041c
  TransferBuffer       = 88be9be0
  TransferBufferMDL    = 00000000
  UrbLink              = 00000000
[547337 ms] UsbSnoop - MyInternalIOCTLCompletion(b5573db0) : fido=00000000, Irp=889b46b0, Context=889ebab0, IRQL=2
[547337 ms]  <<<  URB 528 coming back  <<< 
-- URB_FUNCTION_BULK_OR_INTERRUPT_TRANSFER:
  PipeHandle           = 88a69984 [endpoint 0x00000082]
  TransferFlags        = 00000003 (USBD_TRANSFER_DIRECTION_IN, USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 000001de
  TransferBuffer       = 88be9be0
  TransferBufferMDL    = 889b77a8
    00000000: 02 01 08 01 00 20 aa 10 b9 20 00 00 00 00 80 00
    00000010: 50 00 03 00 c8 01 80 ff 4f 61 af ff ff ff 18 f4
    00000020: fa ff ff cf bf ff ff ff 29 f1 fb ff ff 5f 12 14
    00000030: af ff ff ff 15 f2 0f ff ff ff f5 3f ff ff cf 11
    00000040: 51 13 ef ff ff ff 65 f2 fa ff ff 5f 13 13 af ff
    00000050: ff ff f5 3f ff ff ff f5 3f ff ff ff 12 f1 4f ff
    00000060: ff ff f5 3f ff ff ff f4 4f ff ff cf 33 ff f5 ff
    00000070: ff 1e 13 f1 3f ff ff ef 21 11 ff f4 ff ff 3c 21
    00000080: f2 3f ff ff cf 41 ff f6 ff ff 3d 11 f2 3f ff ff
    00000090: df 11 ff f8 ff ff 0f 13 ff f4 ff ff 18 12 f2 9f
    000000a0: ff ff 8f 22 11 ff f9 ff ff fd af ff ff 5f 61 ff
    000000b0: fb ff ff 17 11 f2 bf ff ff 1e 38 f1 bf ff ff 8f
    000000c0: 13 ff fb ff 7f 71 41 ff 3f ff ff 0f 41 ff 3f ff
    000000d0: ff 1f 41 ff 2f ff ff 1e f4 ff f4 ff bf 51 13 ff
    000000e0: 2f ff ff 2c f2 ff f7 ff df 13 ff 6f ff ff 19 f3
    000000f0: ff fa ff 5f 11 13 ff cf ff ff 16 f1 ff 0f ff ff
    00000100: 11 25 f1 ff fd ff 2f ff ff f6 ff 3f ff ff f5 ff
    00000110: 2f 12 ff ff f3 ff 0f ff ff f8 ff 1d f3 ff 6f ff
    00000120: 19 1f 21 12 ff ff f6 9f f1 f3 ff af ff 19 2f ff
    00000130: ff fb 9f f1 12 f1 ff 9f ff af 31 ff ff f9 ff 2c
    00000140: f1 ff 8f ff ff f0 ff 8f ff ef ff ff f9 ff 1f ff
    00000150: ff f7 ff 1f ff ff f7 ff 1d f2 ff 7f ff ff f2 ff
    00000160: 6f ff ff f1 ff 7f ff ff f3 ff 5f ff ff f5 ff 3f
    00000170: ff ff f6 ff 2f ff ff f7 ff 1f ff ff 29 f1 ff fb
    00000180: ff 8f 22 ff bf ff ff fc ff fb ff cf 12 13 ff 4f
    00000190: ff ff 4c 42 f1 ff f0 ff ff 10 f2 ff f5 ff ff 12
    000001a0: f1 ff f4 ff ff f4 ff f4 ff cf 41 11 ff 4f ff ff
    000001b0: 1c 23 f1 ff f4 ff ff f3 ff f5 ff ff f0 ff f8 ff
    000001c0: ff 11 f2 ff f4 ff ff 11 f2 ff f4 ff ff f4 ff f4
    000001d0: ff ff 54 f1 df ff ff 2f 11 ff 4f ff 19 ff
  UrbLink              = 00000000
[547337 ms] UsbSnoop - DispatchAny(b5572610) : IRP_MJ_INTERNAL_DEVICE_CONTROL
[547337 ms] UsbSnoop - MyDispatchInternalIOCTL(b5573e80) : fdo=88b11400, Irp=889b46b0, IRQL=2
[547337 ms]  >>>  URB 529 going down  >>> 
-- URB_FUNCTION_BULK_OR_INTERRUPT_TRANSFER:
  PipeHandle           = 88a69984 [endpoint 0x00000082]
  TransferFlags        = 00000003 (USBD_TRANSFER_DIRECTION_IN, USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 0000041c
  TransferBuffer       = 88be9be0
  TransferBufferMDL    = 00000000
  UrbLink              = 00000000
[547345 ms] UsbSnoop - MyInternalIOCTLCompletion(b5573db0) : fido=00000000, Irp=889b46b0, Context=899e8388, IRQL=2
[547345 ms]  <<<  URB 529 coming back  <<< 
-- URB_FUNCTION_BULK_OR_INTERRUPT_TRANSFER:
  PipeHandle           = 88a69984 [endpoint 0x00000082]
  TransferFlags        = 00000003 (USBD_TRANSFER_DIRECTION_IN, USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 000001d2
  TransferBuffer       = 88be9be0
  TransferBufferMDL    = 889b77a8
    00000000: 02 01 08 01 00 20 36 30 b9 20 00 00 00 00 80 00
    00000010: 50 00 03 00 bc 01 80 ff 6f 11 12 9f ff ff ff 1a
    00000020: f3 17 f1 ff ff 7f 11 21 11 9f ff ff ff 26 12 f1
    00000030: fb ff ff 6f 17 9f ff ff ff 16 f1 0f ff ff ff f6
    00000040: 2f ff ff ff 16 f1 0f ff ff ff 37 11 f1 fa ff ff
    00000050: 7f 16 9f ff ff ff f6 2f ff ff ff f6 2f ff ff ff
    00000060: 66 f1 fa ff ff 6f ff f2 ff ff 4f 11 ff f2 ff ff
    00000070: 6f ff f2 ff ff 6f ff f2 ff ff 2f 11 ff f4 ff ff
    00000080: 0f 24 ff f2 ff ff 1d 34 f1 1f ff ff ff 21 f3 2f
    00000090: ff ff df 12 21 ff f4 ff ff 6d f1 3f ff ff ff 50
    000000a0: f1 2f ff ff ff f0 8f ff ff 5f 21 32 ff fa ff ff
    000000b0: fd af ff ff 8f 41 ff fa ff ff fd af ff ff df ff
    000000c0: fa ff ff 26 f1 ef ff ff 5f 11 ff 1f ff ff 7f 11
    000000d0: ff fe ff ff 27 f1 df ff ff 5f 11 ff 1f ff ff 2f
    000000e0: 12 ff 3f ff ff 3f 12 ff 2f ff ff 1a 13 f1 ff f7
    000000f0: ff ef 11 12 ff 4f ff ff 29 f1 ff fb ff 9f ff ef
    00000100: ff ff 28 f1 ff fc ff 9f ff ef ff ff f6 ff 2f ff
    00000110: ff f6 ff 2f ff ff f6 ff 2f ff ff f6 ff 2f ff ff
    00000120: f5 ff 3f ff 1a 8f ff ff f4 af f1 f8 ff 4f ff ff
    00000130: f4 ff 4f ff ff f3 ff 5f ff ff f4 ff 4f ff ff f4
    00000140: ff 4f ff ff 23 f1 ff 2f ff ff 13 f4 ff 0f ff ff
    00000150: f7 ff 1f ff ff f7 ff 1f ff ff 18 f1 ff fd ff af
    00000160: ff df ff ff fa ff fd ff bf ff cf ff ff fe ff f9
    00000170: ff df 16 13 ff fe ff ff 10 f2 ff f5 ff ff 11 f2
    00000180: ff f4 ff ff 15 33 f1 af ff ff 5f ff 3f ff ff 5f
    00000190: 13 ff fe ff ff 35 31 f1 af ff ff 5f ff 3f ff ff
    000001a0: 5f 12 12 ff fc ff ff f5 ff f3 ff ff 14 f1 ff f2
    000001b0: ff ff 14 31 f1 df ff ff 5f ff 3f ff ff 5f ff 3f
    000001c0: ff ff 7f ff 1f ff ff 7f ff 1f ff ff 6f 16 ff fa
    000001d0: af 16
  UrbLink              = 00000000
[547345 ms] UsbSnoop - DispatchAny(b5572610) : IRP_MJ_INTERNAL_DEVICE_CONTROL
[547345 ms] UsbSnoop - MyDispatchInternalIOCTL(b5573e80) : fdo=88b11400, Irp=889b46b0, IRQL=2
[547345 ms]  >>>  URB 530 going down  >>> 
-- URB_FUNCTION_BULK_OR_INTERRUPT_TRANSFER:
  PipeHandle           = 88a69984 [endpoint 0x00000082]
  TransferFlags        = 00000003 (USBD_TRANSFER_DIRECTION_IN, USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 0000041c
  TransferBuffer       = 88be9be0
  TransferBufferMDL    = 00000000
  UrbLink              = 00000000
[547353 ms] UsbSnoop - MyInternalIOCTLCompletion(b5573db0) : fido=00000000, Irp=889b46b0, Context=88b3f208, IRQL=2
[547353 ms]  <<<  URB 530 coming back  <<< 
-- URB_FUNCTION_BULK_OR_INTERRUPT_TRANSFER:
  PipeHandle           = 88a69984 [endpoint 0x00000082]
  TransferFlags        = 00000003 (USBD_TRANSFER_DIRECTION_IN, USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 000001ea
  TransferBuffer       = 88be9be0
  TransferBufferMDL    = 889b77a8
    00000000: 02 01 08 01 00 20 f5 4f b9 20 00 00 00 00 80 00
    00000010: 50 00 03 00 d4 01 80 ff ff 14 12 34 11 ff ff ff
    00000020: ff 24 ff ff ff cf 11 51 f4 ff ff ff 1b 11 55 ff
    00000030: ff ff af 12 11 f8 ff ff ff 15 24 14 51 ff ff ff
    00000040: 7f 31 13 11 f6 ff ff ff da ff ff ff 6f 31 11 fa
    00000050: ff ff ff 4b 72 ff ff ff 4f 24 fe ff ff ff 22 11
    00000060: f2 f0 ff ff ff 61 f1 f0 ff ff ff 11 12 21 e1 ff
    00000070: ff ff 1f 11 12 2f ff ff ff 2f 6f ff ff ff 1f 7f
    00000080: ff ff ff 1f 14 2f ff ff ff 1f 7f ff ff ff 1f 7f
    00000090: ff ff ff 1f 7f ff ff ff 1f 7f ff ff ff 1f 7f ff
    000000a0: ff ff 1f 7f ff ff ff 1a f5 f7 ff ff ff 11 f1 f5
    000000b0: ff ff cf 31 7f ff ff ff 1b f3 f8 ff ff 8f 13 21
    000000c0: 8f ff ff ff 18 11 31 f1 f7 ff ff 8f ff f0 ff ff
    000000d0: 8f ff f0 ff ff 8f ff f0 ff ff 8f ff f0 ff ff 7f
    000000e0: 21 df ff ff ff 24 12 f1 fd ff ff 0f 22 11 ff f2
    000000f0: ff ff 0f ff f8 ff ff 0f ff f8 ff ff 1c f2 8f ff
    00000100: ff bf 11 ff fa ff ff 17 11 11 f1 af ff ff 4f 11
    00000110: 11 ff 0f ff ff 6f ff 2f ff ff 5f 11 ff 1f ff ff
    00000120: 2f ff 6f ff ff 2f 11 ff 4f ff ff 2f 13 ff 2f ff
    00000130: ff 1f ff 7f ff ff 1f 15 ff 1f ff ff 1f 12 ff 4f
    00000140: ff ff 0f 11 11 ff 4f ff ff 1f 21 11 ff 2f ff ff
    00000150: 6f ff 2f ff ff 2f 12 ff 3f ff ff 7f ff 1f ff ff
    00000160: 5f 11 ff 1f ff ff 7f 12 12 ff fa ff ff 3b f1 8f
    00000170: ff ff cf ff fb ff ff 0f ff f8 ff ff 0f ff f8 ff
    00000180: ff 0f 32 11 ff f1 ff ff 1f 31 21 ff f0 ff ff 8f
    00000190: ff f0 ff ff 8f ff f0 ff ff 8f ff f0 ff ff 8f 13
    000001a0: 12 8f ff ff ff f9 fe ff ff 8f ff f0 ff ff 9f 12
    000001b0: bf ff ff ff 28 f2 fb ff ff 5f 21 13 bf ff ff ff
    000001c0: 38 f1 fb ff ff 5f 21 ff f0 ff ff 9f 13 af ff ff
    000001d0: ff f8 0f ff ff ff 38 f2 fa ff ff 6f 11 11 11 13
    000001e0: 7f ff ff ff 28 12 f2 f8 cf 12
  UrbLink              = 00000000
[547353 ms] UsbSnoop - DispatchAny(b5572610) : IRP_MJ_INTERNAL_DEVICE_CONTROL
[547353 ms] UsbSnoop - MyDispatchInternalIOCTL(b5573e80) : fdo=88b11400, Irp=889b46b0, IRQL=2
[547353 ms]  >>>  URB 531 going down  >>> 
-- URB_FUNCTION_BULK_OR_INTERRUPT_TRANSFER:
  PipeHandle           = 88a69984 [endpoint 0x00000082]
  TransferFlags        = 00000003 (USBD_TRANSFER_DIRECTION_IN, USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 0000041c
  TransferBuffer       = 88be9be0
  TransferBufferMDL    = 00000000
  UrbLink              = 00000000
[547354 ms] UsbSnoop - MyInternalIOCTLCompletion(b5573db0) : fido=00000000, Irp=889b46b0, Context=889f1268, IRQL=2
[547354 ms]  <<<  URB 531 coming back  <<< 
-- URB_FUNCTION_BULK_OR_INTERRUPT_TRANSFER:
  PipeHandle           = 88a69984 [endpoint 0x00000082]
  TransferFlags        = 00000003 (USBD_TRANSFER_DIRECTION_IN, USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000007
  TransferBuffer       = 88be9be0
  TransferBufferMDL    = 889b77a8
    00000000: 02 01 08 01 00 30 00
  UrbLink              = 00000000
[547354 ms] UsbSnoop - DispatchAny(b5572610) : IRP_MJ_INTERNAL_DEVICE_CONTROL
[547354 ms] UsbSnoop - MyDispatchInternalIOCTL(b5573e80) : fdo=88b11400, Irp=889b46b0, IRQL=2
[547354 ms]  >>>  URB 532 going down  >>> 
-- URB_FUNCTION_BULK_OR_INTERRUPT_TRANSFER:
  PipeHandle           = 88a69984 [endpoint 0x00000082]
  TransferFlags        = 00000003 (USBD_TRANSFER_DIRECTION_IN, USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 0000041c
  TransferBuffer       = 88be9be0
  TransferBufferMDL    = 00000000
  UrbLink              = 00000000
[547362 ms] UsbSnoop - MyInternalIOCTLCompletion(b5573db0) : fido=00000000, Irp=889b46b0, Context=89b05130, IRQL=2
[547362 ms]  <<<  URB 532 coming back  <<< 
-- URB_FUNCTION_BULK_OR_INTERRUPT_TRANSFER:
  PipeHandle           = 88a69984 [endpoint 0x00000082]
  TransferFlags        = 00000003 (USBD_TRANSFER_DIRECTION_IN, USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 000001d6
  TransferBuffer       = 88be9be0
  TransferBufferMDL    = 889b77a8
    00000000: 02 01 08 01 00 20 b9 6f b9 20 00 00 00 00 80 00
    00000010: 50 00 03 00 c0 01 80 ff ff 24 a1 ff ff ff af 16
    00000020: f6 ff ff ff da ff ff ff af fd ff ff ff 15 d4 ff
    00000030: ff ff 5f 41 fd ff ff ff 12 11 12 e1 ff ff ff 4f
    00000040: 42 fd ff ff ff 12 13 d3 ff ff ff 3f 22 21 fd ff
    00000050: ff ff 12 11 f2 f1 ff ff ff f2 f6 ff ff ff f2 f6
    00000060: ff ff ff f3 f5 ff ff ff f3 f5 ff ff ff 10 41 f1
    00000070: f1 ff ff ff f1 f7 ff ff ff f2 f6 ff ff ff 10 f1
    00000080: f6 ff ff ff f0 f8 ff ff ef 21 6f ff ff ff 39 13
    00000090: f1 f6 ff ff bf 12 11 7f ff ff ff f9 fe ff ff bf
    000000a0: 15 6f ff ff ff 3b f1 f8 ff ff 9f 15 8f ff ff ff
    000000b0: 12 56 f1 f8 ff ff 9f ef ff ff ff 17 f1 fe ff ff
    000000c0: 1f 31 22 ef ff ff ff 11 11 f2 2f ff ff ff 14 f3
    000000d0: 0f ff ff ff 11 22 21 f1 fd ff ff 1f ff f7 ff ff
    000000e0: 1a f5 7f ff ff ff f0 8f ff ff 8f 61 ff f8 ff ff
    000000f0: 1c f1 9f ff ff ef ff f9 ff ff 1b f2 9f ff ff af
    00000100: ff fd ff ff f9 ef ff ff 8f ff 0f ff ff 8f ff 0f
    00000110: ff ff 9f 11 ff fc ff ff f9 ef ff ff 9f 11 ff fc
    00000120: ff ff 18 f1 df ff ff af ff fd ff ff fb cf ff ff
    00000130: 9f 12 13 ff f7 ff ff 1c f1 9f ff ff cf 11 ff f9
    00000140: ff ff 1f ff f7 ff ff 0f ff f8 ff ff 1f ff f7 ff
    00000150: ff 1f ff f7 ff ff 1f ff f7 ff ff 1f 17 ef ff ff
    00000160: ff 21 13 f1 0f ff ff ff 21 11 f3 0f ff ff ff f9
    00000170: fe ff ff 2f 51 ff f0 ff ff 2f 41 ff f1 ff ff 1f
    00000180: 13 22 ef ff ff ff 13 22 f1 fe ff ff 1f 41 12 11
    00000190: cf ff ff ff f4 4f ff ff ff 35 f1 fe ff ff 7f 11
    000001a0: ef ff ff ff 14 11 f1 0f ff ff ff 26 f1 fe ff ff
    000001b0: 8f ff f0 ff ff 6f 11 ff f0 ff ff 7f ff f1 ff ff
    000001c0: 8f ff f0 ff ff 9f ef ff ff ff f9 fd ff ff 8f 11
    000001d0: ef ff 8d 11 ef ff
  UrbLink              = 00000000
[547362 ms] UsbSnoop - DispatchAny(b5572610) : IRP_MJ_INTERNAL_DEVICE_CONTROL
[547362 ms] UsbSnoop - MyDispatchInternalIOCTL(b5573e80) : fdo=88b11400, Irp=889b46b0, IRQL=2
[547362 ms]  >>>  URB 533 going down  >>> 
-- URB_FUNCTION_BULK_OR_INTERRUPT_TRANSFER:
  PipeHandle           = 88a69984 [endpoint 0x00000082]
  TransferFlags        = 00000003 (USBD_TRANSFER_DIRECTION_IN, USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 0000041c
  TransferBuffer       = 88be9be0
  TransferBufferMDL    = 00000000
  UrbLink              = 00000000
[547363 ms] UsbSnoop - MyInternalIOCTLCompletion(b5573db0) : fido=00000000, Irp=889b46b0, Context=899e8388, IRQL=2
[547363 ms]  <<<  URB 533 coming back  <<< 
-- URB_FUNCTION_BULK_OR_INTERRUPT_TRANSFER:
  PipeHandle           = 88a69984 [endpoint 0x00000082]
  TransferFlags        = 00000003 (USBD_TRANSFER_DIRECTION_IN, USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000006
  TransferBuffer       = 88be9be0
  TransferBufferMDL    = 889b77a8
    00000000: 02 01 08 01 02 20
  UrbLink              = 00000000
[547363 ms] UsbSnoop - DispatchAny(b5572610) : IRP_MJ_INTERNAL_DEVICE_CONTROL
[547363 ms] UsbSnoop - MyDispatchInternalIOCTL(b5573e80) : fdo=88b11400, Irp=889b46b0, IRQL=2
[547363 ms]  >>>  URB 534 going down  >>> 
-- URB_FUNCTION_BULK_OR_INTERRUPT_TRANSFER:
  PipeHandle           = 88a69984 [endpoint 0x00000082]
  TransferFlags        = 00000003 (USBD_TRANSFER_DIRECTION_IN, USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 0000041c
  TransferBuffer       = 88be9be0
  TransferBufferMDL    = 00000000
  UrbLink              = 00000000

--------------020509090700040105020603--
