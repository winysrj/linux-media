Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:53702 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751114AbaIUOii (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Sep 2014 10:38:38 -0400
Message-ID: <541EE2EB.4000802@iki.fi>
Date: Sun, 21 Sep 2014 17:38:35 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: JPT <j-p-t@gmx.net>, linux-media@vger.kernel.org
Subject: Re: Running Technisat DVB-S2 on ARM-NAS
References: <541EE016.9030504@gmx.net>
In-Reply-To: <541EE016.9030504@gmx.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 09/21/2014 05:26 PM, JPT wrote:
> Hi,
>
> I want to turn my Netgear ReadyNAS RN104 into a VDR.
> I already run a self made kernel 3.16.3) and plain debian on it.
> For hardware and software details see http://natisbad.org/NAS3/
>
> I recently compiled those DVB modules into the kernel.
> And after a lot of struggle to get a clean build, I succeeded in loading
> the modules:
> dvb_usb_technisat_usb2, dvb_usb, dvb_core, stv090x, rc_core
>
> but device recognition somehow does not fully work.
>
> usb 2-1: new high-speed USB device number 3 using xhci_hcd
> usb 2-1: New USB device found, idVendor=14f7, idProduct=0500
> usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> usb 2-1: Product: TechniSat USB device
> usb 2-1: Manufacturer: TechniSat Digital
> usb 2-1: SerialNumber: ************
> technisat-usb2: set alternate setting
> technisat-usb2: firmware version: 17.63
> dvb-usb: found a 'Technisat SkyStar USB HD (DVB-S/S2)' in warm state.
> dvb-usb: will pass the complete MPEG2 transport stream to the software
> demuxer.
> dvb-usb: Technisat SkyStar USB HD (DVB-S/S2) error while loading driver
> (-12)
> usbcore: registered new interface driver dvb_usb_technisat_usb2
>
>
> How my I find out more about the error -12? It's a lot of wrapped
> "return ret" in the code...
> Is there any way of enabling more logging?
>
> I believe it comes from the dvb-usb-technisat-usb2 module, but there is
> no c file?

http://www.virtsync.com/c-error-codes-include-errno

#define ENOMEM      12  /* Out of memory */

Likely allocating USB stream buffers fails. You could try request 
smaller buffers. Drop count to 1 and test. Drop framesperurb to 1 and 
test. Drop framesize to 1 and test. Surely streaming will not work if 
all buffers are totally wrong and too small, but you will see if it is 
due to big usb buffers. Then you could try optimize buffers smaller.

			.stream = {
				.type = USB_ISOC,
				.count = 8,
				.endpoint = 0x2,
				.u = {
					.isoc = {
						.framesperurb = 32,
						.framesize = 2048,
						.interval = 1,
					}
				}
			},

regards
Antti

-- 
http://palosaari.fi/
