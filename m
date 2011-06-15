Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33852 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232Ab1FOG07 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jun 2011 02:26:59 -0400
Received: by fxm17 with SMTP id 17so167951fxm.19
        for <linux-media@vger.kernel.org>; Tue, 14 Jun 2011 23:26:58 -0700 (PDT)
From: Artem Pastukhov <artem.pastukhov@gmail.com>
To: linux-media@vger.kernel.org
Subject: xc4000 and analog tv
Date: Wed, 15 Jun 2011 10:26:35 +0400
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201106151026.36509.past@biztrend.ru>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

It's possible to get analog tv from xc4000?

I have Pinnacle PCTV Hybrid Stick Solo

Vanilla kernel 2.6.39.1

part of dmesg:

[   95.416504] usb 1-2.2: new high speed USB device number 6 using ehci_hcd
[   97.214204] WARNING: You are using an experimental version of the media 
stack.
[   97.214205]  As the driver is backported to an older kernel, it doesn't 
offer
[   97.214206]  enough quality for its usage in production.
[   97.214206]  Use it with care.
[   97.214207] Latest git patches (needed if you report a bug to linux-
media@vger.kernel.org):
[   97.214207]  f49c454fe981d955d7c3d620f6baa04fb9876adc [media] Correct and 
add some parameter descriptions
[   97.214208]  845070f310dfa1e7242d5e8b332c36adce242cc5 [media] Remove unused 
definitions which can cause conflict with definitions in usb/ch9.h
[   97.214209]  657e262ed0ce6c4f0f1447025d8272b3acbce93f [media] Correct error 
code from -ENOMEM to -EINVAL.
[   97.218342] IR NEC protocol handler initialized
[   97.298823] WARNING: You are using an experimental version of the media 
stack.
[   97.298824]  As the driver is backported to an older kernel, it doesn't 
offer
[   97.298826]  enough quality for its usage in production.
[   97.298827]  Use it with care.
[   97.298827] Latest git patches (needed if you report a bug to linux-
media@vger.kernel.org):
[   97.298829]  f49c454fe981d955d7c3d620f6baa04fb9876adc [media] Correct and 
add some parameter descriptions
[   97.298830]  845070f310dfa1e7242d5e8b332c36adce242cc5 [media] Remove unused 
definitions which can cause conflict with definitions in usb/ch9.h
[   97.298832]  657e262ed0ce6c4f0f1447025d8272b3acbce93f [media] Correct error 
code from -ENOMEM to -EINVAL.
[   97.631587] IR RC5(x) protocol handler initialized
[   97.870637] dib0700: loaded with support for 21 different device-types
[   97.871038] dvb-usb: found a 'Pinnacle PCTV Hybrid Stick Solo' in cold 
state, will try to load a firmware
[   97.987701] IR RC6 protocol handler initialized
[   98.450775] IR JVC protocol handler initialized
[   98.834765] dvb-usb: downloading firmware from file 'dvb-usb-dib0700-1.20.fw'
[   98.881134] IR Sony protocol handler initialized
[   98.954752] lirc_dev: IR Remote Control driver registered, major 249 
[   98.963420] IR LIRC bridge handler initialized
[   99.337416] dib0700: firmware started successfully.
[   99.844123] dvb-usb: found a 'Pinnacle PCTV Hybrid Stick Solo' in warm 
state.
[   99.844167] dvb-usb: will pass the complete MPEG2 transport stream to the 
software demuxer.
[   99.844680] DVB: registering new adapter (Pinnacle PCTV Hybrid Stick Solo)
[  100.713774] DVB: registering adapter 0 frontend 0 (DiBcom 7000PC)...
[  100.831608] xc4000 9-0061: creating new instance
[  100.836750] xc4000: Successfully identified at address 0x61
[  100.836751] xc4000: Firmware has not been loaded previously
[  100.980808] Registered IR keymap rc-dib0700-rc5
[  100.980904] input: IR-receiver inside an USB DVB receiver as 
/devices/pci0000:00/0000:00:1a.7/usb1/1-2/1-2.2/rc/rc0/input6
[  100.980983] rc0: IR-receiver inside an USB DVB receiver as 
/devices/pci0000:00/0000:00:1a.7/usb1/1-2/1-2.2/rc/rc0
[  100.981123] dvb-usb: schedule remote query interval to 50 msecs.
[  100.981126] dvb-usb: Pinnacle PCTV Hybrid Stick Solo successfully 
initialized and connected.
[  100.981389] usbcore: registered new interface driver dvb_usb_dib0700
