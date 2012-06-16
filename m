Return-path: <linux-media-owner@vger.kernel.org>
Received: from matrix.voodoobox.net ([75.127.97.206]:34742 "EHLO
	matrix.voodoobox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758903Ab2FPAwp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jun 2012 20:52:45 -0400
Received: from shed.thedillows.org ([IPv6:2001:470:8:bf8::2])
	by matrix.voodoobox.net (8.13.8/8.13.8) with ESMTP id q5G0fuwT028386
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Fri, 15 Jun 2012 20:41:57 -0400
Received: from [192.168.0.10] (obelisk.thedillows.org [192.168.0.10])
	by shed.thedillows.org (8.14.4/8.14.4) with ESMTP id q5G0fudF003906
	for <linux-media@vger.kernel.org>; Fri, 15 Jun 2012 20:41:56 -0400
Message-ID: <1339807316.32360.26.camel@obelisk.thedillows.org>
Subject: Flaky init for HVR850 (cx231xx, 2040:b140)
From: David Dillow <dave@thedillows.org>
To: linux-media@vger.kernel.org
Date: Fri, 15 Jun 2012 20:41:56 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'm trying to track down the root cause of my HVR850 failing to reliably
initialize on the 3.4 kernel. The issue does not seem to be new, as the
same behavior appears under CentOS 2.6.32-220.17.1. Both kernels are
running on x86_64. The HVR850 is a recent model 1230 from NewEgg.

Upon being plugged in, or after a reboot, the card ends up in one of
three states:
(a) working (rare)
(b) temporarily broken
(c) fully broken

State (b) is characterized by not initially finding the TDA18271 tuner
chip on the I2C bus, followed later by it being detected by dvb_init():
        All bytes are equal. It is not a TEA5767
        tuner 13-0060: Tuner -1 found with type(s) Radio TV.
        tda18271 13-0060: creating new instance
        Unknown device (0) detected @ 13-0060, device not supported.
        [snip]
        dvb_init: looking for tuner / demod on i2c bus: 13
        tda18271 13-0060: creating new instance
        TDA18271HD/C2 detected @ 13-0060
        cx231xx #0: UsbInterface::sendCommand, failed with status --32
        tda18271_write_regs: [13-0060|M] ERROR: idx = 0x0, len = 39, i2c_transfer returned: -32

Turning on tuner.i2c_debug shows that we get all zeros during the
initial tuner probe. If I then rmmod/modprobe the module, we detect the
tuner properly during the initial scan, and the device appears to work
-- DVB scan works, anyways.

State (c) looks similar to state (b), but instead of getting EPIPE (32),
we get an EPROTO (71):
        cx231xx #0: EndPoint Addr 0x81, Alternate settings: 6
        cx231xx #0: Alternate setting 0, max size= 512
        cx231xx #0: Alternate setting 1, max size= 64
        cx231xx #0: Alternate setting 2, max size= 128
        cx231xx #0: Alternate setting 3, max size= 316
        cx231xx #0: Alternate setting 4, max size= 712
        cx231xx #0: Alternate setting 5, max size= 1424
        usbcore: registered new interface driver cx231xx
        cx231xx #0:  setPowerMode::mode = 32, No Change req.
        cx231xx #0: UsbInterface::sendCommand, failed with status --71
        
Once we arrive in state (c), rmmod/modprobe doesn't help, as we hit the
EPROTO errors early on:
        cx231xx #0: New device Hauppauge Hauppauge Device @ 480 Mbps (2040:b140) with 6 interfaces
        cx231xx #0: registering interface 1
        cx231xx #0: bad senario!!!!!
        cx231xx #0: config_info=0
        cx231xx #0: Identified as Hauppauge EXETER (card=8)
        cx231xx #0: UsbInterface::sendCommand, failed with status --71
        [snip]
        cx231xx #0: cx231xx_dev_init: Failed to set Power - errCode
        [-71]!

EPROTO seems to be coming from the EHCI (in my case) host driver;
turning on debugging there gives:

        ehci_hcd 0000:00:1d.0: detected XactErr len 0/255 retry 31
        ehci_hcd 0000:00:1d.0: devpath 1.2 ep0in 3strikes
        ehci_hcd 0000:00:1d.0: dev3 ep0in qtd token 80ff0148 --> status -71
        
which comes from drivers/usb/host/ehci-q.c, qh_completions() and
qtd_copy_status(). The comment above the "3strikes" indicates a timeout,
CRC error, or wrong PID as among the possible causes. I suspect we've
tickled something to cause the bridge chip to go out to lunch.

I think there is some sort of race condition that we're running into,
but I don't know enough about the internal structure of the device to
know where to start looking. Turning on all debugging output doesn't
show obvious differences, both by eye and by filtering things through
diff. I did add a 1 second sleep after loading the firmware and starting
the microcontroller, but that did nothing to help.

Does anyone have suggestions on how to proceed? I hope to have the box
running MythTV later this weekend as I can cycle the driver/device and
eventually get it working, but I'd like to nail this bug so I should be
able to collect debug data for interested folks.

Thanks,
Dave



