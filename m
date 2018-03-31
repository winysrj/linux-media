Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f45.google.com ([74.125.83.45]:40517 "EHLO
        mail-pg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752858AbeCaPay (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 31 Mar 2018 11:30:54 -0400
Received: by mail-pg0-f45.google.com with SMTP id h3so2709099pgq.7
        for <linux-media@vger.kernel.org>; Sat, 31 Mar 2018 08:30:54 -0700 (PDT)
Subject: Re: [PATCH v4] dvb-usb/friio, dvb-usb-v2/gl861: decompose friio and
 merge with gl861
To: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com
References: <20180327174730.1887-1-tskd08@gmail.com>
 <f1ce1268-e918-a12f-959e-98644cafb2fe@iki.fi>
 <e861a533-5517-2089-52af-ce720174e3ae@gmail.com>
 <db8f370c-20f5-e9fe-9d2e-d12c1475dc33@iki.fi>
 <30d0270b-852a-39df-14e5-4c12d59aeac7@gmail.com>
 <25d4e91f-454f-bac7-125b-dd1ae5c77d9e@iki.fi>
From: Akihiro TSUKADA <tskd08@gmail.com>
Message-ID: <f047a680-436b-bf40-ae0a-68279366b668@gmail.com>
Date: Sun, 1 Apr 2018 00:30:49 +0900
MIME-Version: 1.0
In-Reply-To: <25d4e91f-454f-bac7-125b-dd1ae5c77d9e@iki.fi>
Content-Type: text/plain; charset=utf-8
Content-Language: en_US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> I don't understand those control message parts and it is bit too hard to
> read i2c adapter implementation to get understanding. Could you offer
> simple 2 sniff examples, register write to demod and register write to
> tuner.

Here is the part of a packet log.

1. write to demod (addr:0x18)

reg:0x76 val:0c
===============
[46264 ms]  >>>  URB 146 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT, ~USBD_SHORT_TR
ANSFER_OK)
  TransferBufferLength = 00000000
  TransferBuffer       = 8609d21e
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000001
  Value                   = 0000300c
  Index                   = 00000076
[46266 ms] UsbSnoop - MyInternalIOCTLCompletion(f79b7db0) : fido=00000000, Irp=8
58f2938, Context=858c4ed8, IRQL=2
[46266 ms]  <<<  URB 146 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 86239260
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT, USBD_SHORT_TRANS
FER_OK)
  TransferBufferLength = 00000000
  TransferBuffer       = 8609d21e
  TransferBufferMDL    = 00000000
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 01 0c 30 76 00 00 00
===============


2. write to tuner (addr:0x60)

write [0f 7b b2 08] to addr 0x60
===============
[47267 ms]  >>>  URB 147 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT, ~USBD_SHORT_TR
ANSFER_OK)
  TransferBufferLength = 00000005
  TransferBuffer       = 8581c7d6
  TransferBufferMDL    = 00000000
    00000000: c0 0f 7b b2 08
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000003
  Value                   = 00003000
  Index                   = 000000fe
[47270 ms] UsbSnoop - MyInternalIOCTLCompletion(f79b7db0) : fido=00000000, Irp=8
58f2008, Context=86275258, IRQL=2
[47270 ms]  <<<  URB 147 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 86239260
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT, USBD_SHORT_TRANS
FER_OK)
  TransferBufferLength = 00000005
  TransferBuffer       = 8581c7d6
  TransferBufferMDL    = 855f7760
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 03 00 30 fe 00 05 00
===============

3. read from tuner

read one byte from addr 0x60
(2 USB packets)
===============
[46036 ms]  >>>  URB 26 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT, ~USBD_SHORT_TR
ANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = 8609d21e
  TransferBufferMDL    = 00000000
    00000000: c1
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000003
  Value                   = 00003000
  Index                   = 000000fe
[46038 ms] UsbSnoop - MyInternalIOCTLCompletion(f79b7db0) : fido=00000000, Irp=8
58f2938, Context=858ccea0, IRQL=2
[46038 ms]  <<<  URB 26 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 86239260
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT, USBD_SHORT_TRANS
FER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = 8609d21e
  TransferBufferMDL    = 855f7760
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 03 00 30 fe 00 01 00


[46038 ms]  >>>  URB 27 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN, ~USBD_SHORT_TRA
NSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = 8609d21e
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00003000
  Index                   = 00000100
[46040 ms] UsbSnoop - MyInternalIOCTLCompletion(f79b7db0) : fido=00000000, Irp=8
58f2938, Context=86366778, IRQL=2
[46040 ms]  <<<  URB 27 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 86239260
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN, USBD_SHORT_TRANSF
ER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = 8609d21e
  TransferBufferMDL    = 855f7760
    00000000: 7c
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 02 00 30 00 01 01 00
============

Note: In log 2 & 3, "Request" parameter value is different from log 1. 

regards,
Akihiro
