Return-path: <linux-media-owner@vger.kernel.org>
Received: from dub004-omc4s10.hotmail.com ([157.55.2.85]:51774 "EHLO
	DUB004-OMC4S10.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753068AbcDJP27 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Apr 2016 11:28:59 -0400
From: Christian Steiner <christian.steiner@outlook.de>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "olli.salonen@iki.fi" <olli.salonen@iki.fi>
Subject: Re: [PATCH] em28xx: add support for Hauppauge WinTV-dualHD DVB tuner
Date: Sun, 10 Apr 2016 15:23:49 +0000
Message-ID: <AM2PR05MB0689ADF0BC65F4BAA4FD4DD091930@AM2PR05MB0689.eurprd05.prod.outlook.com>
References: <1459782772-21451-1-git-send-email-olli.salonen@iki.fi>
In-Reply-To: <1459782772-21451-1-git-send-email-olli.salonen@iki.fi>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-ID: <DCAA6FC2BCAA0F499034F36EF80A48E4@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04.04.2016 17:12, Olli Salonen wrote:
> Hauppauge WinTV-dualHD is a USB 2.0 dual DVB-T/T2/C tuner with
> following components:
> 
> USB bridge: Empia EM28274 (chip id is the same as EM28174)
> Demodulator: 2x Silicon Labs Si2168-B40
> Tuner: 2x Silicon Labs Si2157-A30
> 
> This patch adds support only for the first tuner.
> 
> [...]

Thank you very much!
Works fine for me:

> [  419.413188] em28xx: New device HCW dualHD @ 480 Mbps (2040:0265, interface 0, class 0)
> [  419.413195] em28xx: DVB interface 0 found: isoc
> [  419.413265] em28xx: chip ID is em28174
> [  420.529619] em28174 #0: EEPROM ID = 26 00 01 00, EEPROM hash = 0x7addc1c8
> [  420.529626] em28174 #0: EEPROM info:
> [  420.529630] em28174 #0:      microcode start address = 0x0004, boot configuration = 0x01
> [  420.536077] em28174 #0:      AC97 audio (5 sample rates)
> [  420.536084] em28174 #0:      500mA max power
> [  420.536089] em28174 #0:      Table at offset 0x27, strings=0x0e6a, 0x1888, 0x087e
> [  420.536188] em28174 #0: Identified as Hauppauge WinTV-dualHD DVB (card=98)
> [  420.537974] tveeprom 8-0050: Hauppauge model 204109, rev B2I6, serial# 11XXXXXX
> [  420.537981] tveeprom 8-0050: tuner model is SiLabs Si2157 (idx 186, type 4)
> [  420.537986] tveeprom 8-0050: TV standards PAL(B/G) NTSC(M) PAL(I) SECAM(L/L') PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xfc)
> [  420.537989] tveeprom 8-0050: audio processor is None (idx 0)
> [  420.537993] tveeprom 8-0050: has no radio, has IR receiver, has no IR transmitter
> [  420.537997] em28174 #0: dvb set to isoc mode.
> [  420.538056] usbcore: registered new interface driver em28xx
> [  420.541087] em28174 #0: Binding DVB extension
> [  420.544008] i2c i2c-8: Added multiplexed i2c bus 9
> [  420.544016] si2168 8-0064: Silicon Labs Si2168 successfully attached
> [  420.548372] si2157 9-0060: Silicon Labs Si2147/2148/2157/2158 successfully attached
> [  420.548389] DVB: registering new adapter (em28174 #0)
> [  420.548396] usb 2-2: DVB: registering adapter 0 frontend 0 (Silicon Labs Si2168)...
> [  420.549737] em28174 #0: DVB extension successfully initialized
> [  420.549743] em28xx: Registered (Em28xx dvb Extension) extension
> [  435.418798] si2168 8-0064: found a 'Silicon Labs Si2168-B40'
> [  435.418823] si2168 8-0064: downloading firmware from file 'dvb-demod-si2168-b40-01.fw'
> [  435.617181] si2168 8-0064: firmware version: 4.0.11
> [  435.619791] si2157 9-0060: found a 'Silicon Labs Si2157-A30'
> [  435.642006] si2157 9-0060: firmware version: 3.0.5

(I have replaced the last digits of the serial number with X)

Is there any chance to add support for the second tuner, too?
This would be awesome.

Best,
Christian
