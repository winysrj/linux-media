Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1-a.eqx.gridhost.co.uk ([95.142.156.16]:56620 "EHLO
	mail1-a.eqx.gridhost.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751295AbbKIIJG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Nov 2015 03:09:06 -0500
Received: from [209.85.220.173] (helo=mail-qk0-f173.google.com)
	by mail1.eqx.gridhost.co.uk with esmtpsa (UNKNOWN:AES128-GCM-SHA256:128)
	(Exim 4.72)
	(envelope-from <olli.salonen@iki.fi>)
	id 1ZvhV4-0007zh-1F
	for linux-media@vger.kernel.org; Mon, 09 Nov 2015 08:08:26 +0000
Received: by qkcl124 with SMTP id l124so67863074qkc.3
        for <linux-media@vger.kernel.org>; Mon, 09 Nov 2015 00:08:25 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 9 Nov 2015 10:08:25 +0200
Message-ID: <CAAZRmGwzsqFYtSNDCCCwFR4vCRgtz9CrixsZyc0xJzb=S6OEsw@mail.gmail.com>
Subject: Re: DVBSky T330 DVB-C regression Linux 4.1.12 to 4.3
From: Olli Salonen <olli.salonen@iki.fi>
To: Stephan Eisvogel <eisvogel@seitics.de>
Cc: Antti Palosaari <crope@iki.fi>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Stephan,

I had a look at recent changes to si2168 and dvb-usb-dvbsky drivers
that are the ones most relevant here. si2157 is probably not the issue
here as your demod does lock.

si2168:

2015-08-11    [media] dvb-frontends: Drop owner assignment from i2c_driver
2015-06-09    [media] dvb: Get rid of typedev usage for enums
2015-06-05    [media] si2168: Implement own I2C adapter locking

dvb-usb-dvbsky:

2015-10-03    [media] Add Terratec H7 Revision 4 to DVBSky driver
2015-06-10    [media] TS2020: Calculate tuner gain correctly
2015-06-09    [media] dvb: Get rid of typedev usage for enums

All these changes seem rather innocent. I've got the same tuner (sold
as a TechnoTrend device) and I could try the 4.3 kernel to confirm
it's still ok for DVB-T/T2 broadcasts that I've got available here,
but it'll be a while as I'm travelling at the moment. Hopefully
someone else can confirm before that.

Cheers,
-olli


On 8 November 2015 at 02:37, Stephan Eisvogel <eisvogel@seitics.de> wrote:
> Hi Antti, hi Olli,
>
> I'm a Raspberry Pi 2 + TVHeadend + DVBSky T330 clone owner/user and am
> observing
> a regression from Linux 4.1.12 to 4.3. TVheadend is delivering this error:
>
> Nov 04 19:32:17 RPI2 tvheadend[714]: mpegts: 450MHz in Kabel Deutschland -
> scan no data, failed
>
> Basically EPG and TV is full dead. I saw the
>
>   "9cd700e m88ds3103: use own update_bits() implementation"
>   "a8e2219 m88ds3103: use regmap for I2C register access"
>
> bits that went into 4.3 recently. Anything like that applicable to the
> Si2168/Si2157 USB varieties?
>
> Device:
>
> Bus 001 Device 005: ID 0572:0320 Conexant Systems (Rockwell), Inc. DVBSky
> T330 DVB-T2/C tuner
>
> Relevant dmesg:
>
> [    2.063240] usb 1-1.2: new high-speed USB device number 5 using dwc_otg
> [    2.157399] usb 1-1.2: New USB device found, idVendor=0572,
> idProduct=0320
> [    2.157422] usb 1-1.2: New USB device strings: Mfr=1, Product=2,
> SerialNumber=3
> [    2.157433] usb 1-1.2: Product: DVB-T2/C USB-Stick
> [    2.157443] usb 1-1.2: Manufacturer: Bestunar Inc
> [    2.157453] usb 1-1.2: SerialNumber: 20140126
> [    6.273255] usb 1-1.2: dvb_usb_v2: found a 'DVBSky T330' in warm state
> [    6.273832] usb 1-1.2: dvb_usb_v2: will pass the complete MPEG2 transport
> stream to the software demuxer
> [    6.273921] DVB: registering new adapter (DVBSky T330)
> [    6.275286] usb 1-1.2: dvb_usb_v2: MAC address: 00:cc:10:a5:33:0c
> [    6.474110] i2c i2c-3: Added multiplexed i2c bus 4
> [    6.474138] si2168 3-0064: Silicon Labs Si2168 successfully attached
> [    6.680772] si2157 4-0060: Silicon Labs Si2147/2148/2157/2158
> successfully attached
> [    6.680835] usb 1-1.2: DVB: registering adapter 0 frontend 0 (Silicon
> Labs Si2168)...
> [    6.933236] Registered IR keymap rc-dvbsky
> [    6.933705] input: DVBSky T330 as
> /devices/platform/soc/3f980000.usb/usb1/1-1/1-1.2/rc/rc0/input4
> [    6.933972] rc0: DVBSky T330 as
> /devices/platform/soc/3f980000.usb/usb1/1-1/1-1.2/rc/rc0
> [    6.933998] usb 1-1.2: dvb_usb_v2: schedule remote query interval to 300
> msecs
> [    6.934013] usb 1-1.2: dvb_usb_v2: 'DVBSky T330' successfully initialized
> and connected
> [    6.934146] usbcore: registered new interface driver dvb_usb_dvbsky
> [   15.066829] si2168 3-0064: found a 'Silicon Labs Si2168-B40'
> [   15.086772] si2168 3-0064: downloading firmware from file
> 'dvb-demod-si2168-b40-01.fw'
> [   16.568679] si2168 3-0064: firmware version: 4.0.19
> [   16.579069] si2157 4-0060: found a 'Silicon Labs Si2158-A20'
> [   16.599232] si2157 4-0060: downloading firmware from file
> 'dvb-tuner-si2158-a20-01.fw'
> [   17.581060] si2157 4-0060: firmware version: 2.1.6
> [   17.581145] usb 1-1.2: DVB: adapter 0 frontend 0 frequency 0 out of range
> (55000000..862000000)
>
>
> Thanks for any insight!
>
> Best regards from Nuremberg/Germany,
> Stephan
>
