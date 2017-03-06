Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f47.google.com ([209.85.215.47]:33680 "EHLO
        mail-lf0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752767AbdCFN3T (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 6 Mar 2017 08:29:19 -0500
Received: by mail-lf0-f47.google.com with SMTP id a6so72435041lfa.0
        for <linux-media@vger.kernel.org>; Mon, 06 Mar 2017 05:29:18 -0800 (PST)
MIME-Version: 1.0
From: =?UTF-8?Q?Fran=C3=A7ois_M?= <f.menning@gmail.com>
Date: Mon, 6 Mar 2017 14:21:19 +0100
Message-ID: <CADska5perycsLrjE8mZPFgAbnw_xhjbHDqa5bv0mftDouK_ApA@mail.gmail.com>
Subject: Mygica T230 Rev. <2016 not working on Linux 4.9 - 2016 model not
 working at all
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Using Mygica T230 <2016 model on (Arch) Linux 4.9.11 with latest
openelec-firmware installed.:
[ 1950.636574] usb 1-1: new high-speed USB device number 7 using xhci_hcd
[ 1950.770804] usb 1-1: language id specifier not provided by device,
defaulting to English
[ 1950.773837] dvb-usb: found a 'Mygica T230 DVB-T/T2/C' in warm state.
[ 1950.909942] dvb-usb: recv bulk message failed: -11
[ 1951.016674] dvb-usb: will pass the complete MPEG2 transport stream
to the software demuxer.
[ 1951.016920] DVB: registering new adapter (Mygica T230 DVB-T/T2/C)
[ 1951.021056] dvb-usb: recv bulk message failed: -11
[ 1951.021071] si2168: probe of 10-0064 failed with error -121
[ 1951.021077] dvb-usb: no frontend was attached by 'Mygica T230 DVB-T/T2/C'
[ 1951.021316] input: IR-receiver inside an USB DVB receiver as
/devices/pci0000:00/0000:00:14.0/usb1/1-1/input/input29
[ 1951.021687] dvb-usb: schedule remote query interval to 100 msecs.

Working state on Linux 4.8.14:
[ 7999.575183] dvb-usb: will pass the complete MPEG2 transport stream
to the software demuxer.
[ 7999.575233] DVB: registering new adapter (Mygica T230 DVB-T/T2/C)
[ 7999.583571] i2c i2c-5: Added multiplexed i2c bus 6
[ 7999.583573] si2168 5-0064: Silicon Labs Si2168-B40 successfully identified
[ 7999.583574] si2168 5-0064: firmware version: B 4.0.2
[ 7999.585032] media: Linux media interface: v0.10
[ 7999.587312] si2157 6-0060: Silicon Labs Si2147/2148/2157/2158
successfully attached
[ 7999.587317] usb 1-7: DVB: registering adapter 0 frontend 0 (Silicon
Labs Si2168)...
[ 7999.587453] input: IR-receiver inside an USB DVB receiver as
/devices/pci0000:00/0000:00:14.0/usb1/1-7/input/input16
[ 7999.587529] dvb-usb: schedule remote query interval to 100 msecs.
[ 7999.587563] dvb-usb: Mygica T230 DVB-T/T2/C successfully
initialized and connected.
[ 7999.587578] usbcore: registered new interface driver dvb_usb_cxusb
[ 8006.865027] si2168 5-0064: downloading firmware from file
'dvb-demod-si2168-b40-01.fw'
[ 8007.577512] si2168 5-0064: firmware version: B 4.0.11
[ 8007.591030] si2157 6-0060: found a 'Silicon Labs Si2158-A20'
[ 8007.591587] si2157 6-0060: downloading firmware from file
'dvb-tuner-si2158-a20-01.fw'
[ 8008.793732] si2157 6-0060: firmware version: 2.1.9

The latest released model (with serial 2016) doesn't start at all on
Linux 4.9.11.

I don't know if this is because of the module changes in si2168 or
other changes in dvb-usb.

Thanks and let me know if more info is needed.
