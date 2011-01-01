Return-path: <mchehab@gaivota>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:46081 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726Ab1AAKoL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 1 Jan 2011 05:44:11 -0500
Received: by iwn9 with SMTP id 9so12176148iwn.19
        for <linux-media@vger.kernel.org>; Sat, 01 Jan 2011 02:44:11 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 1 Jan 2011 11:44:10 +0100
Message-ID: <AANLkTi=ocOpZ+3hi+PTuR_cHVe7ixQdTGEHVeS84ZYry@mail.gmail.com>
Subject: dvb_usb_dib0700 driver woes with Pinnacle 72e stick
From: Alfredo Braunstein <abraunst@lyx.org>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi & happy new year,

I recently bought a Pinnacle 72e USB stick, (lsusb says: Bus 002
Device 011: ID 2304:0236 Pinnacle Systems, Inc. [hex]. The stick says
"pinnacle" on front
and "72e" and  "1100" on the back) which seemed to be supported by the
dvb_usb_dib0700 driver. Indeed, the module seems to load correctly,
e.g.  this is the output of dmesg after sticking it in:

[10729.192683] usb 2-3: new high speed USB device using ehci_hcd and address 11
[10729.341288] usb 2-3: configuration #1 chosen from 1 choice
[10729.341674] dvb-usb: found a 'Pinnacle PCTV 72e' in cold state,
will try to load a firmware
[10729.341685] usb 2-3: firmware: requesting dvb-usb-dib0700-1.20.fw
[10729.355056] dvb-usb: downloading firmware from file 'dvb-usb-dib0700-1.20.fw'
[10729.588139] dib0700: firmware started successfully.
[10730.090185] dvb-usb: found a 'Pinnacle PCTV 72e' in warm state.
[10730.090245] dvb-usb: will pass the complete MPEG2 transport stream
to the software demuxer.
[10730.090711] DVB: registering new adapter (Pinnacle PCTV 72e)
[10730.340445] DVB: registering adapter 0 frontend 0 (DiBcom 7000PC)...
[10730.577782] DiB0070: successfully identified
[10730.577989] input: IR-receiver inside an USB DVB receiver as
/devices/pci0000:00/0000:00:1d.7/usb2/2-3/input/input28
[10730.578146] dvb-usb: schedule remote query interval to 50 msecs.
[10730.578156] dvb-usb: Pinnacle PCTV 72e successfully initialized and
connected.

However, scanning channels only finds a small subset of them (Always
the same set. I didn't find an identifying characteristic of this set,
I could look again with some pointers) and it is not possible to tune
to the others (tuning parameters obtained with another card)

If I install the provided driver in windows under virtualbox, the
stick works fine. Moreover, after exiting virtualbox (virtualbox
removes the dvb_usb_dib0700 module on start and reloads on exit) the
cards works fine under linux also!

This is both with shipped kernel/v4l from ubuntu lucid
(2.6.32-27-generic) and latest v4l hg.

Any clues on how can this be debugged / investigated? I can of course
look at usb trafic during the correct initialization.

Please ask me if you need further info or I forgot something (likely).

Thanks!

A/
