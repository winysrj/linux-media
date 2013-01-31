Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:33867 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752877Ab3AaSkN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Jan 2013 13:40:13 -0500
Received: by mail-ob0-f182.google.com with SMTP id va7so3177842obc.41
        for <linux-media@vger.kernel.org>; Thu, 31 Jan 2013 10:40:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <510A78D8.7030602@iki.fi>
References: <50F05C09.3010104@iki.fi>
	<CAHsu+b8UAh5VD_V4Ub6g7z_5LC=NH1zuY77Yv5nBefnrEwUHMw@mail.gmail.com>
	<510A78D8.7030602@iki.fi>
Date: Thu, 31 Jan 2013 19:40:12 +0100
Message-ID: <CAHsu+b-TdcBaM_JzsON40k+4sifL27xM-AV8M6bdMt9L3ZCpeA@mail.gmail.com>
Subject: Re: af9035 test needed!
From: Andre Heider <a.heider@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Jose Alberto Reguero <jareguero@telefonica.net>,
	Gianluca Gennari <gennarone@gmail.com>,
	LMML <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hey,

On Thu, Jan 31, 2013 at 2:59 PM, Antti Palosaari <crope@iki.fi> wrote:
>> On Fri, Jan 11, 2013 at 7:38 PM, Antti Palosaari <crope@iki.fi> wrote:
>>>
>>> Could you test that (tda18218 & mxl5007t):

only now I see you mentioned mxl5007t too, and with the same tree as I
used for my 'TerraTec Cinergy T Stick Dual RC (rev. 2)', a 'AVerMedia
HD Volar (A867)' with a mxl5007t (and an unkown rev) works too:

usb 3-3.1.4: new high-speed USB device number 7 using xhci_hcd
usb 3-3.1.4: New USB device found, idVendor=07ca, idProduct=1867
usb 3-3.1.4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 3-3.1.4: Product: A867
usb 3-3.1.4: Manufacturer: AVerMedia TECHNOLOGIES, Inc
usb 3-3.1.4: SerialNumber: 0305770200261
usb 3-3.1.4: af9035_identify_state: prechip_version=00 chip_version=03
chip_type=3802
usb 3-3.1.4: dvb_usb_v2: found a 'AVerMedia HD Volar (A867)' in cold state
usb 3-3.1.4: dvb_usb_v2: downloading firmware from file 'dvb-usb-af9035-02.fw'
usb 3-3.1.4: dvb_usb_af9035: firmware version=11.5.9.0
usb 3-3.1.4: dvb_usb_v2: found a 'AVerMedia HD Volar (A867)' in warm state
usb 3-3.1.4: dvb_usb_v2: will pass the complete MPEG2 transport stream
to the software demuxer
DVB: registering new adapter (AVerMedia HD Volar (A867))
i2c i2c-19: af9033: firmware version: LINK=11.5.9.0 OFDM=5.17.9.1
usb 3-3.1.4: DVB: registering adapter 1 frontend 0 (Afatech AF9033 (DVB-T))...
mxl5007t 19-0060: creating new instance
mxl5007t_get_chip_id: unknown rev (3f)
mxl5007t_get_chip_id: MxL5007T detected @ 19-0060
Registered IR keymap rc-empty
input: AVerMedia HD Volar (A867) as
/devices/pci0000:00/0000:00:14.0/usb3/3-3/3-3.1/3-3.1.4/rc/rc5/input29
rc5: AVerMedia HD Volar (A867) as
/devices/pci0000:00/0000:00:14.0/usb3/3-3/3-3.1/3-3.1.4/rc/rc5
usb 3-3.1.4: dvb_usb_v2: schedule remote query interval to 500 msecs
usb 3-3.1.4: dvb_usb_v2: 'AVerMedia HD Volar (A867)' successfully
initialized and connected

Regards,
Andre
