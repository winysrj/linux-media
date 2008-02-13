Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <hfvogt@gmx.net>) id 1JPMY1-0007Od-1I
	for linux-dvb@linuxtv.org; Wed, 13 Feb 2008 19:41:33 +0100
From: Hans-Frieder Vogt <hfvogt@gmx.net>
To: "Albert Comerma" <albert.comerma@gmail.com>
Date: Wed, 13 Feb 2008 19:40:55 +0100
References: <200802112223.11129.hfvogt@gmx.net>
	<ea4209750802121454v385d58edt162445379daddca4@mail.gmail.com>
In-Reply-To: <ea4209750802121454v385d58edt162445379daddca4@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802131940.55526.hfvogt@gmx.net>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] support Cinergy HT USB XE (0ccd:0058)
Reply-To: hfvogt@gmx.net
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Albert,

your dmesg output looks quite good. In fact, the only line that irritates me is the line with
xc2028 4-0061: Error on line 1063: -5
This line indicates an i2c-communication problem with the tuner.
As it happens BEFORE the XC3028  firmware is loaded, it cannot have anything to do with the xc3028 firmware.
Therefore, I suspect something either with the general setup of the Expresscard or a DiB firmware that does not
100% support your device. Have you tried a later firmware?

For comparison, I list here what is output in kernel.log for my Cinergy HT USB XE:

Feb 13 19:13:31: usb 1-5: new high speed USB device using ehci_hcd and address 6
Feb 13 19:13:31: usb 1-5: configuration #1 chosen from 1 choice
Feb 13 19:13:31: dib0700: loaded with support for 7 different device-types
Feb 13 19:13:31: dvb-usb: found a 'Terratec Cinergy HT USB XE' in cold state, will try to load a firmware
Feb 13 19:13:31: dvb-usb: downloading firmware from file 'dvb-usb-dib0700-1.10.fw'
Feb 13 19:13:32: dib0700: firmware started successfully.
Feb 13 19:13:32: dvb-usb: found a 'Terratec Cinergy HT USB XE' in warm state.
Feb 13 19:13:32: dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
Feb 13 19:13:32: DVB: registering new adapter (Terratec Cinergy HT USB XE)
Feb 13 19:13:33: DVB: registering frontend 1 (DiBcom 7000PC)...
Feb 13 19:13:33: xc2028 7-0061: type set to XCeive xc2028/xc3028 tuner
Feb 13 19:13:33: input: IR-receiver inside an USB DVB receiver as /devices/pci0000:00/0000:00:02.1/usb1/1-5/input/input6
Feb 13 19:13:33: dvb-usb: schedule remote query interval to 150 msecs.
Feb 13 19:13:33: dvb-usb: Terratec Cinergy HT USB XE successfully initialized and connected.
Feb 13 19:13:33: usbcore: registered new interface driver dvb_usb_dib0700
Feb 13 19:14:43: xc2028 7-0061: Loading 80 firmware images from xc3028-v27.fw, type: xc2028 firmware, ver 2.7
Feb 13 19:14:43: dib0700: stk7700ph_xc3028_callback: XC2028_TUNER_RESET 0
Feb 13 19:14:43: 
Feb 13 19:14:43: xc2028 7-0061: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb 13 19:14:43: dib0700: stk7700ph_xc3028_callback: XC2028_TUNER_RESET 0
Feb 13 19:14:43: 
Feb 13 19:14:50: xc2028 7-0061: Loading firmware for type=D2620 DTV8 (208), id 0000000000000000.
Feb 13 19:14:50: xc2028 7-0061: Device is Xceive 3028 version 1.0, firmware version 2.7
Feb 13 19:14:50: dib0700: stk7700ph_xc3028_callback: XC2028_RESET_CLK 1
Feb 13 19:14:50: 

with regards to the firmware modification that I mentioned, see the comment below.

Regards,
Hans-Frieder

> Finally I got what you mean... you changed the extract_firmware.pl, but not
> only the comment I guess... also the values below. I tested both and the

I did not change the extract_firmware.pl file (in fact, it is not useable for the Mod7700.sys driver, but expects the driver
file hcw85bda.sys), but just used a hex editor to replace the ID 0x64000200 by 0x60000200.

> result is the same as described before, everything seems correct, but I have
> some errors on dmesg and nothing is detected on scan (I must try with an
> amplified antenna but I think it should detect something).

certainly a good idea to use an amplified antenna. Have you got another DVB-t device that works with a passive
antenna in the same area where you use your new device?

> 
> Albert
> 

-- 
--
Hans-Frieder Vogt             e-mail:  hfvogt <at> gmx .dot. net

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
