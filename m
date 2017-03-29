Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-ch2-09v.sys.comcast.net ([69.252.207.41]:40930 "EHLO
        resqmta-ch2-09v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932673AbdC2BkI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Mar 2017 21:40:08 -0400
Subject: Re: [PATCH 1/3] [media] mceusb: RX -EPIPE (urb status = -32) lockup
 failure fix
To: Sean Young <sean@mess.org>
References: <58D6A1DD.2030405@comcast.net>
 <20170326102748.GA1672@gofer.mess.org> <58D80838.8050809@comcast.net>
 <20170326203130.GA6070@gofer.mess.org> <58D8CAD9.80304@comcast.net>
 <20170328202516.GA27790@gofer.mess.org>
Cc: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>
From: A Sun <as1033x@comcast.net>
Message-ID: <58DB1075.60302@comcast.net>
Date: Tue, 28 Mar 2017 21:40:05 -0400
MIME-Version: 1.0
In-Reply-To: <20170328202516.GA27790@gofer.mess.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 3/28/2017 4:25 PM, Sean Young wrote:
<snip>
>  
>> The unused EVENT_TX_HALT and the apparently extra _kevent functions and kevent_flags are necessary for a later:
>>     [PATCH] [media] mceusb: TX -EPIPE lockup fix
>> ...not yet written, transmit side equivalent bug. I respectfully recommend keeping these hooks in place.
> 
> Have you observed this happening?
> 

Not yet for my Infrared Transceiver device only. USB halt/stall errors apparently are not USB device specific, and can occur with both TX and RX according to the Linux Urb errors documentation. Calling usb_clear_halt() is required for both cases to recover and restore operation of the stalled endpoint.

The TX -EPIPE error is already separated out by code in the mceusb driver, but with no error recovery handling.
In mce_async_callback()
        case -EPIPE:
        default:
                dev_err(ir->dev, "Error: request urb status = %d", urb->status);
                break;
        }

I believe I can trigger the condition by stress test flooding or otherwise misusing the device's TX end-point in the driver (like the RX case), but I haven't put much work into that yet.

> Speaking of which, how do you reproduce the original -EPIPE issue? I've
> tried to reproduce on my raspberry pi 3 with a very similar mceusb
> device, but I haven't had any luck.
> 

Reproduction of the RX -EPIPE is "hard" to get. I haven't found a consistent way to reproduce, other than inconsistently by:
   Bug trigger appears to be normal, but heavy, IR receiver use.
In particular, punch up a bunch of buttons at random on a remote control (I used a Sony TV remote) and include some long button presses in the process. Do for say about 1 minute at the time. The bug won't trigger for idle or occasional IR receiver activity.
Some mceusb devices may be more susceptible to the problem than others.

> What's the lsusb -vv for this device?

Here it is, on my raspberry pi 3:

...
Bus 001 Device 006: ID 2304:0225 Pinnacle Systems, Inc. Remote Kit Infrared Transceiver
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0         8
  idVendor           0x2304 Pinnacle Systems, Inc.
  idProduct          0x0225 Remote Kit Infrared Transceiver
  bcdDevice            0.01
  iManufacturer           1 Pinnacle Systems
  iProduct                2 PCTV Remote USB
  iSerial                 5 7FFFFFFFFFFFFFFF
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           32
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          3 StandardConfiguration
    bmAttributes         0xa0
      (Bus Powered)
      Remote Wakeup
    MaxPower              100mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0
      bInterfaceProtocol      0
      iInterface              4 StandardInterface
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval              10
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x02  EP 2 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval              10
Device Status:     0x0000
  (Bus Powered)
...

The most recent bug replication I got was while testing the fix methodology for [patch 1/3]. The fault, when it occurs, is between IR data blocks during receive.

...
Mar 22 12:16:35 raspberrypi kernel: [ 4863.489177] mceusb 1-1.2:1.0: rx data: 90 7f 7f 7f 7f 7f 7f 7f 7f 7f 7f 7f 7f 7f 7f 7f 7f (length=17)
Mar 22 12:16:35 raspberrypi kernel: [ 4863.489184] mceusb 1-1.2:1.0: Raw IR data, 16 pulse/space samples
Mar 22 12:16:35 raspberrypi kernel: [ 4863.489189] mceusb 1-1.2:1.0: Storing space with duration 6350000
Mar 22 12:16:35 raspberrypi kernel: [ 4863.489195] mceusb 1-1.2:1.0: Storing space with duration 6350000
Mar 22 12:16:35 raspberrypi kernel: [ 4863.489199] mceusb 1-1.2:1.0: Storing space with duration 6350000
Mar 22 12:16:35 raspberrypi kernel: [ 4863.489203] mceusb 1-1.2:1.0: Storing space with duration 6350000
Mar 22 12:16:35 raspberrypi kernel: [ 4863.489207] mceusb 1-1.2:1.0: Storing space with duration 6350000
Mar 22 12:16:35 raspberrypi kernel: [ 4863.489211] mceusb 1-1.2:1.0: Storing space with duration 6350000
Mar 22 12:16:35 raspberrypi kernel: [ 4863.489216] mceusb 1-1.2:1.0: Storing space with duration 6350000
Mar 22 12:16:35 raspberrypi kernel: [ 4863.489220] mceusb 1-1.2:1.0: Storing space with duration 6350000
Mar 22 12:16:35 raspberrypi kernel: [ 4863.489224] mceusb 1-1.2:1.0: Storing space with duration 6350000
Mar 22 12:16:35 raspberrypi kernel: [ 4863.489228] mceusb 1-1.2:1.0: Storing space with duration 6350000
Mar 22 12:16:35 raspberrypi kernel: [ 4863.489232] mceusb 1-1.2:1.0: Storing space with duration 6350000
Mar 22 12:16:35 raspberrypi kernel: [ 4863.489236] mceusb 1-1.2:1.0: Storing space with duration 6350000
Mar 22 12:16:35 raspberrypi kernel: [ 4863.489240] mceusb 1-1.2:1.0: Storing space with duration 6350000
Mar 22 12:16:35 raspberrypi kernel: [ 4863.489246] mceusb 1-1.2:1.0: Storing space with duration 6350000
Mar 22 12:16:35 raspberrypi kernel: [ 4863.489250] mceusb 1-1.2:1.0: Storing space with duration 6350000
Mar 22 12:16:35 raspberrypi kernel: [ 4863.489254] mceusb 1-1.2:1.0: Storing space with duration 6350000
Mar 22 12:16:35 raspberrypi kernel: [ 4863.489257] mceusb 1-1.2:1.0: processed IR data
Mar 22 12:16:35 raspberrypi kernel: [ 4863.589429] mceusb 1-1.2:1.0: Error: urb status = -32 (RX HALT)
Mar 22 12:16:35 raspberrypi kernel: [ 4863.589452] mceusb 1-1.2:1.0: kevent 1 scheduled
Mar 22 12:16:35 raspberrypi kernel: [ 4863.590203] mceusb 1-1.2:1.0: unhalt usb_submit_urb, status 0
Mar 22 12:16:36 raspberrypi kernel: [ 4864.614325] mceusb 1-1.2:1.0: rx data: 90 0b 98 0c 8c 0c 8c 0c 98 0c 98 0c 98 0c 8c 0c 8c (length=17)
Mar 22 12:16:36 raspberrypi kernel: [ 4864.614338] mceusb 1-1.2:1.0: Raw IR data, 16 pulse/space samples
Mar 22 12:16:36 raspberrypi kernel: [ 4864.614346] mceusb 1-1.2:1.0: Storing space with duration 550000
Mar 22 12:16:36 raspberrypi kernel: [ 4864.614355] mceusb 1-1.2:1.0: Storing pulse with duration 1200000
Mar 22 12:16:36 raspberrypi kernel: [ 4864.614363] mceusb 1-1.2:1.0: Storing space with duration 600000
Mar 22 12:16:36 raspberrypi kernel: [ 4864.614370] mceusb 1-1.2:1.0: Storing pulse with duration 600000
Mar 22 12:16:36 raspberrypi kernel: [ 4864.614377] mceusb 1-1.2:1.0: Storing space with duration 600000
Mar 22 12:16:36 raspberrypi kernel: [ 4864.614384] mceusb 1-1.2:1.0: Storing pulse with duration 600000
Mar 22 12:16:36 raspberrypi kernel: [ 4864.614391] mceusb 1-1.2:1.0: Storing space with duration 600000
Mar 22 12:16:36 raspberrypi kernel: [ 4864.614399] mceusb 1-1.2:1.0: Storing pulse with duration 1200000
Mar 22 12:16:36 raspberrypi kernel: [ 4864.614405] mceusb 1-1.2:1.0: Storing space with duration 600000
Mar 22 12:16:36 raspberrypi kernel: [ 4864.614414] mceusb 1-1.2:1.0: Storing pulse with duration 1200000
Mar 22 12:16:36 raspberrypi kernel: [ 4864.614421] mceusb 1-1.2:1.0: Storing space with duration 600000
Mar 22 12:16:36 raspberrypi kernel: [ 4864.614428] mceusb 1-1.2:1.0: Storing pulse with duration 1200000
Mar 22 12:16:36 raspberrypi kernel: [ 4864.614435] mceusb 1-1.2:1.0: Storing space with duration 600000
Mar 22 12:16:36 raspberrypi kernel: [ 4864.614443] mceusb 1-1.2:1.0: Storing pulse with duration 600000
Mar 22 12:16:36 raspberrypi kernel: [ 4864.614450] mceusb 1-1.2:1.0: Storing space with duration 600000
Mar 22 12:16:36 raspberrypi kernel: [ 4864.614458] mceusb 1-1.2:1.0: Storing pulse with duration 600000
Mar 22 12:16:36 raspberrypi kernel: [ 4864.614463] mceusb 1-1.2:1.0: processed IR data
Mar 22 12:16:36 raspberrypi kernel: [ 4864.648331] mceusb 1-1.2:1.0: rx data: 90 0b 8d 0b 8d 7f 7f 7f 72 b0 0c 98 0c 8c 0c 98 0c (length=17)
...

Thanks, ..A Sun
