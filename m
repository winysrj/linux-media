Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:49708 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752002AbaL3M7Y (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Dec 2014 07:59:24 -0500
Received: from [192.168.178.20] ([79.215.154.191]) by mail.gmx.com (mrgmx103)
 with ESMTPSA (Nemesis) id 0MSMr9-1YGi2L1xdL-00TSxW for
 <linux-media@vger.kernel.org>; Tue, 30 Dec 2014 13:59:22 +0100
Message-ID: <54A2A1A9.9090008@gmx.net>
Date: Tue, 30 Dec 2014 13:59:21 +0100
From: JPT <j-p-t@gmx.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: How to access DVB-onboard RC? (Technisat)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I currently try to make my Technisat IR-RC work.
But nothing happens when I press a key.
What's wrong?

I checked the RC using a photo camera: at least it emits IR.


triggerhappy config:

DAEMON_OPTS="--triggers /etc/triggerhappy/triggers.d/ /dev/input/event0
/dev/input/event1"

KEY_1           1       logger thd recieved KEY_1 from Technisat RC
KEY_2           1       logger thd recieved KEY_2 from Technisat RC
KEY_3           1       logger thd recieved KEY_3 from Technisat RC
...
(keys from rc-technisat-usb2.c see syslog below)

Triggerhappy works fine with events from event0
but not from event1

$ inputeventdaemon -l
/dev/input/event0:
  name     : gpio-keys
  phys     : gpio-keys/input0
  features : syn keys

/dev/input/event1:
  name     : IR-receiver inside an USB DVB receiver
  phys     : usb-0000:01:00.0-1/ir0
  features : syn keys reserved repeat

/dev/input/event2:
  name     : MCE IR Keyboard/Mouse (technisat-usb2)
  phys     : /input0
  features : syn keys relative reserved repeat


$ lsusb -t
...
/:  Bus 01.Port 1: Dev 1, Class=root_hub, Driver=xhci_hcd/2p, 480M
    |__ Port 1: Dev 3, If 0, Class=vend., Driver=dvb_usb_technisat_usb2,
480M


syslog:
dvb-usb: found a 'Technisat SkyStar USB HD (DVB-S/S2)' in warm state.
dvb-usb: will pass the complete MPEG2 transport stream to the software
demuxer.
DVB: registering new adapter (Technisat SkyStar USB HD (DVB-S/S2))
dvb-usb: MAC address: xxxxx
stv6110x_attach: Attaching STV6110x
technisat-usb2: i2c-error: 60 = 7
usb 1-1: DVB: registering adapter 0 frontend 0 (Technisat SkyStar USB HD
(DVB-S/S2))...
Registered IR keymap rc-technisat-usb2
input: IR-receiver inside an USB DVB receiver as
/devices/soc/soc:pcie-controller/pci0000:00/0000:00:01.0/0000:01:00.0/usb1/1-1/rc/rc0/input1
evbug: Connected device: input1 (IR-receiver inside an USB DVB receiver
at usb-0000:01:00.0-1/ir0)
rc0: IR-receiver inside an USB DVB receiver as
/devices/soc/soc:pcie-controller/pci0000:00/0000:00:01.0/0000:01:00.0/usb1/1-1/rc/rc0
IR NEC protocol handler initialized
IR RC5(x/sz) protocol handler initialized
IR RC6 protocol handler initialized
IR JVC protocol handler initialized
IR Sony protocol handler initialized
IR SANYO protocol handler initialized
IR Sharp protocol handler initialized
dvb-usb: schedule remote query interval to 100 msecs.

do I need those protocol handlers?

do I need lirc?


thanks,

Jan
