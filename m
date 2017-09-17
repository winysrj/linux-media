Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:38564 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750995AbdIQPv7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 17 Sep 2017 11:51:59 -0400
Received: by mail-qt0-f195.google.com with SMTP id f24so4317354qte.5
        for <linux-media@vger.kernel.org>; Sun, 17 Sep 2017 08:51:58 -0700 (PDT)
MIME-Version: 1.0
From: Laurent Caumont <lcaumont2@gmail.com>
Date: Sun, 17 Sep 2017 17:51:57 +0200
Message-ID: <CACG2uryMkGmekDPD0X9JwdLQrxxBCp9AczkGyy4_Q684RRLNUA@mail.gmail.com>
Subject: 'LITE-ON USB2.0 DVB-T Tune' not working with kernel 4.10 / ubuntu 17.04
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

The hardware was working with kernel 4.4.
I'm trying to make my DVB-T to work with my Ubuntu 17.04 and kernel 4.10.
The complied version installed didn't work (with error:
dvb_usb_dibusb_mc_common: Unknown symbol __symbol_get (err 0))
So I'm trying to make it work with the latest code version.
It works a little better but fail to create the frontend.(see below)

I'm software developer, so I can help you identify what goes wrong but
I really don't know how this code works.
I didn't find what the -11 error code from usb_bulk_msg means.

Regards,
Laurent

uname -a
Linux bureau 4.10.0-33-generic #37-Ubuntu SMP Fri Aug 11 10:55:28 UTC
2017 x86_64 x86_64 x86_64 GNU/Linux


[ 2731.415087] usb 1-8: new high-speed USB device number 14 using xhci_hcd
[ 2731.555379] usb 1-8: New USB device found, idVendor=04ca, idProduct=f000
[ 2731.555383] usb 1-8: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[ 2731.565107] media: Linux media interface: v0.10
[ 2731.565934] WARNING: You are using an experimental version of the
media stack.
                   As the driver is backported to an older kernel, it
doesn't offer
                   enough quality for its usage in production.
                   Use it with care.
               Latest git patches (needed if you report a bug to
linux-media@vger.kernel.org):
                   1efdf1776e2253b77413c997bed862410e4b6aaf media:
leds: as3645a: add V4L2_FLASH_LED_CLASS dependency
                   4cd7d6c957b085d319bcf97814f95854375da0a6 media: get
rid of removed DMX_GET_CAPS and DMX_SET_SOURCE leftovers
                   12f92866f13f9ca12e158c07978246ed83d52ed0 media:
Revert [media] v4l: async: make v4l2 coexist with devicetree nodes in
a dt overlay
[ 2731.566963] WARNING: You are using an experimental version of the
media stack.
                   As the driver is backported to an older kernel, it
doesn't offer
                   enough quality for its usage in production.
                   Use it with care.
               Latest git patches (needed if you report a bug to
linux-media@vger.kernel.org):
                   1efdf1776e2253b77413c997bed862410e4b6aaf media:
leds: as3645a: add V4L2_FLASH_LED_CLASS dependency
                   4cd7d6c957b085d319bcf97814f95854375da0a6 media: get
rid of removed DMX_GET_CAPS and DMX_SET_SOURCE leftovers
                   12f92866f13f9ca12e158c07978246ed83d52ed0 media:
Revert [media] v4l: async: make v4l2 coexist with devicetree nodes in
a dt overlay
[ 2731.568725] dvb-usb: found a 'LITE-ON USB2.0 DVB-T Tuner' in cold
state, will try to load a firmware
[ 2731.568741] dvb-usb: downloading firmware from file
'dvb-usb-dibusb-6.0.0.8.fw'
[ 2731.585694] usbcore: registered new interface driver dvb_usb_dibusb_mc
[ 2731.588259] usb 1-8: USB disconnect, device number 14
[ 2731.588275] dvb-usb: generic DVB-USB module successfully
deinitialized and disconnected.
[ 2733.367133] usb 1-8: new high-speed USB device number 15 using xhci_hcd
[ 2733.515454] usb 1-8: New USB device found, idVendor=04ca, idProduct=f001
[ 2733.515457] usb 1-8: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[ 2733.515460] usb 1-8: Product: TvTUNER
[ 2733.515462] usb 1-8: Manufacturer: SKGZ
[ 2733.516489] dvb-usb: found a 'LITE-ON USB2.0 DVB-T Tuner' in warm state.
[ 2733.516760] dvb-usb: will pass the complete MPEG2 transport stream
to the software demuxer.
[ 2733.520673] dvbdev: DVB: registering new adapter (LITE-ON USB2.0 DVB-T Tuner)
[ 2733.520680] usb 1-8: media controller created
[ 2733.521231] dvbdev: dvb_create_media_entity: media entity
'dvb-demux' registered.
[ 2738.631185] dvb-usb: recv bulk message failed: -11
[ 2738.631510] dvb-usb: recv bulk message failed: -11
[ 2738.631522] dvb-usb: no frontend was attached by 'LITE-ON USB2.0 DVB-T Tuner'
[ 2748.871180] input: IR-receiver inside an USB DVB receiver as
/devices/pci0000:00/0000:00:14.0/usb1/1-8/input/input18
[ 2748.871390] dvb-usb: schedule remote query interval to 150 msecs.
[ 2748.871394] dvb-usb: LITE-ON USB2.0 DVB-T Tuner successfully
initialized and connected.
[ 2751.046991] dvb-usb: bulk message failed: -110 (1/0)
[ 2751.046998] dvb-usb: error while querying for an remote control event.
[ 2753.222966] dvb-usb: bulk message failed: -110 (1/0)
[ 2753.222973] dvb-usb: error while querying for an remote control event.
[ 2755.398971] dvb-usb: bulk message failed: -110 (1/0)
[ 2755.398978] dvb-usb: error while querying for an remote control event.
