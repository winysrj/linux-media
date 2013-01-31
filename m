Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f176.google.com ([209.85.214.176]:43464 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570Ab3AaRi2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Jan 2013 12:38:28 -0500
Received: by mail-ob0-f176.google.com with SMTP id v19so3144223obq.21
        for <linux-media@vger.kernel.org>; Thu, 31 Jan 2013 09:38:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <510A78D8.7030602@iki.fi>
References: <50F05C09.3010104@iki.fi>
	<CAHsu+b8UAh5VD_V4Ub6g7z_5LC=NH1zuY77Yv5nBefnrEwUHMw@mail.gmail.com>
	<510A78D8.7030602@iki.fi>
Date: Thu, 31 Jan 2013 18:38:27 +0100
Message-ID: <CAHsu+b9Nc85JwKCnV91WnBpdUi3W6udeF1xWe8u1HhHWaBM-qw@mail.gmail.com>
Subject: Re: af9035 test needed!
From: Andre Heider <a.heider@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Jose Alberto Reguero <jareguero@telefonica.net>,
	Gianluca Gennari <gennarone@gmail.com>,
	LMML <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Thu, Jan 31, 2013 at 2:59 PM, Antti Palosaari <crope@iki.fi> wrote:
> Thank you for the report! There was someone else who reported it working
> too. Do you want to your name as tester for the changelog?

if I didn't mess up my way of testing feel free to add

Tested-by: Andre Heider <a.heider@gmail.com>

to these patches:
af9035: merge af9035 and it9135 eeprom read routines
af9035: USB1.1 support (== PID filters)
af9035: constify clock tables
af9035: [0ccd:0099] TerraTec Cinergy T Stick Dual RC (rev. 2)
af9015: reject device TerraTec Cinergy T Stick Dual RC (rev. 2)
af9035: fix af9033 demod sampling frequency
af9035: add auto configuration heuristic for it9135
af9035: add support for 1st gen it9135
af9033: support for it913x tuners
ITE IT913X silicon tuner driver

I didn't use any media trees before, and the whole media_build.git
shebang seems a little, well, unusual...
So I rebased media_tree.git/staging/for_v3.9 on Linus' master and then
cherry-picked the patches mentioned above.

That gives me:
usb 2-1.5: new high-speed USB device number 3 using ehci-pci
usb 2-1.5: New USB device found, idVendor=0ccd, idProduct=0099
usb 2-1.5: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 2-1.5: Product: DVB-T TV Stick
usb 2-1.5: Manufacturer: ITE Technologies, Inc.
input: ITE Technologies, Inc. DVB-T TV Stick as
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.5/2-1.5:1.1/input/input20
usb 2-1.5: af9035_identify_state: prechip_version=83 chip_version=01
chip_type=9135
hid-generic 0003:0CCD:0099.0007: input,hidraw4: USB HID v1.01 Keyboard
[ITE Technologies, Inc. DVB-T TV Stick] on usb-0000:00:1d.0-1.5/input1
usb 2-1.5: dvb_usb_v2: found a 'TerraTec Cinergy T Stick Dual RC (rev.
2)' in cold state
usb 2-1.5: dvb_usb_v2: downloading firmware from file 'dvb-usb-it9135-01.fw'
usb 2-1.5: dvb_usb_af9035: firmware version=12.54.14.0
usb 2-1.5: dvb_usb_v2: found a 'TerraTec Cinergy T Stick Dual RC (rev.
2)' in warm state
usb 2-1.5: dvb_usb_af9035: driver does not support 2nd tuner and will disable it
usb 2-1.5: dvb_usb_v2: will pass the complete MPEG2 transport stream
to the software demuxer
DVB: registering new adapter (TerraTec Cinergy T Stick Dual RC (rev. 2))
i2c i2c-18: af9033: firmware version: LINK=255.255.255.255 OFDM=2.47.14.0
usb 2-1.5: DVB: registering adapter 0 frontend 0 (Afatech AF9033 (DVB-T))...
Tuner LNA type :38
it913x: ITE Tech IT913X attached
usb 2-1.5: dvb_usb_v2: 'TerraTec Cinergy T Stick Dual RC (rev. 2)'
successfully initialized and connected

> I just yesterday got that TerraTec device too and I am going to add dual
> tuner support. Also, for some reason IT9135 v2 devices are not working -
> only v1. That is one thing I should fix before merge that stuff.

Nice, feel free to CC me if you need any testing.

Regards,
Andre
