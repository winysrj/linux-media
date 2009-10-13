Return-path: <linux-media-owner@vger.kernel.org>
Received: from lider.pardus.org.tr ([193.140.100.216]:44517 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbZJMGvI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Oct 2009 02:51:08 -0400
Message-ID: <4AD42453.20103@pardus.org.tr>
Date: Tue, 13 Oct 2009 09:55:15 +0300
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
MIME-Version: 1.0
To: linux-media@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-usb@vger.kernel.org
Subject: uvcvideo causes ehci_hcd to halt
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Some recent netbooks (Some MSI winds and LG X110's) equipped with an
integrated webcam have non-working USB ports unless the uvcvideo module
is blacklisted. I've found some bug reports in launchpad:

https://bugs.launchpad.net/ubuntu/+source/linux/+bug/435352

I have an LG X110 on which I can reproduce the problem with 2.6.30.8.
Here's the interesting part in dmesg:

Oct 13 08:46:32 x110 kernel: [  261.048312] uvcvideo: Found UVC 1.00
device BisonCam, NB Pro (5986:0203)
Oct 13 08:46:32 x110 kernel: [  261.053592] input: BisonCam, NB Pro as
/devices/pci0000:00/0000:00:1d.7/usb1/1-5/1-5:1.0/input/input10
Oct 13 08:46:32 x110 kernel: [  261.053891] usbcore: registered new
interface driver uvcvideo
Oct 13 08:46:32 x110 kernel: [  261.054755] USB Video Class driver (v0.1.0)
Oct 13 08:46:32 x110 kernel: [  261.091014] ehci_hcd 0000:00:1d.7: force
halt; handhake f807c024 00004000 00000000 -> -110
Oct 13 08:46:33 x110 kernel: [  261.742335] hub 1-0:1.0: cannot reset
port 6 (err = -108)
Oct 13 08:46:33 x110 kernel: [  261.742360] hub 1-0:1.0: cannot reset
port 6 (err = -108)
Oct 13 08:46:33 x110 kernel: [  261.742381] hub 1-0:1.0: cannot reset
port 6 (err = -108)
Oct 13 08:46:33 x110 kernel: [  261.742400] hub 1-0:1.0: cannot reset
port 6 (err = -108)
Oct 13 08:46:33 x110 kernel: [  261.742419] hub 1-0:1.0: cannot reset
port 6 (err = -108)
Oct 13 08:46:33 x110 kernel: [  261.742433] hub 1-0:1.0: Cannot enable
port 6.  Maybe the USB cable is bad?
Oct 13 08:46:33 x110 kernel: [  261.742454] hub 1-0:1.0: cannot disable
port 6 (err = -108)
Oct 13 08:46:33 x110 kernel: [  261.742478] hub 1-0:1.0: cannot reset
port 6 (err = -108)
Oct 13 08:46:33 x110 kernel: [  261.742496] hub 1-0:1.0: cannot reset
port 6 (err = -108)
Oct 13 08:46:33 x110 kernel: [  261.742514] hub 1-0:1.0: cannot reset
port 6 (err = -108)
Oct 13 08:46:33 x110 kernel: [  261.742532] hub 1-0:1.0: cannot reset
port 6 (err = -108)
Oct 13 08:46:33 x110 kernel: [  261.742550] hub 1-0:1.0: cannot reset
port 6 (err = -108)
Oct 13 08:46:33 x110 kernel: [  261.742564] hub 1-0:1.0: Cannot enable
port 6.  Maybe the USB cable is bad?
Oct 13 08:46:33 x110 kernel: [  261.742582] hub 1-0:1.0: cannot disable
port 6 (err = -108)
Oct 13 08:46:33 x110 kernel: [  261.742597] hub 1-0:1.0: cannot reset
port 6 (err = -108)
Oct 13 08:46:33 x110 kernel: [  261.742609] hub 1-0:1.0: cannot reset
port 6 (err = -108)
Oct 13 08:46:33 x110 kernel: [  261.742622] hub 1-0:1.0: cannot reset
port 6 (err = -108)
Oct 13 08:46:33 x110 kernel: [  261.742634] hub 1-0:1.0: cannot reset
port 6 (err = -108)
Oct 13 08:46:33 x110 kernel: [  261.742647] hub 1-0:1.0: cannot reset
port 6 (err = -108)
Oct 13 08:46:33 x110 kernel: [  261.742657] hub 1-0:1.0: Cannot enable
port 6.  Maybe the USB cable is bad?
Oct 13 08:46:33 x110 kernel: [  261.742670] hub 1-0:1.0: cannot disable
port 6 (err = -108)
Oct 13 08:46:33 x110 kernel: [  261.742684] hub 1-0:1.0: cannot reset
port 6 (err = -108)
Oct 13 08:46:33 x110 kernel: [  261.742697] hub 1-0:1.0: cannot reset
port 6 (err = -108)
Oct 13 08:46:33 x110 kernel: [  261.742709] hub 1-0:1.0: cannot reset
port 6 (err = -108)
Oct 13 08:46:33 x110 kernel: [  261.742722] hub 1-0:1.0: cannot reset
port 6 (err = -108)
Oct 13 08:46:33 x110 kernel: [  261.742734] hub 1-0:1.0: cannot reset
port 6 (err = -108)
Oct 13 08:46:33 x110 kernel: [  261.742744] hub 1-0:1.0: Cannot enable
port 6.  Maybe the USB cable is bad?
Oct 13 08:46:33 x110 kernel: [  261.742758] hub 1-0:1.0: cannot disable
port 6 (err = -108)
Oct 13 08:46:33 x110 kernel: [  261.742771] hub 1-0:1.0: cannot disable
port 6 (err = -108)
Oct 13 08:46:33 x110 kernel: [  261.742839] hub 1-0:1.0: hub_port_status
failed (err = -108)
Oct 13 08:46:33 x110 kernel: [  261.742902] hub 1-0:1.0: cannot reset
port 2 (err = -108)
Oct 13 08:46:33 x110 kernel: [  261.742923] hub 1-0:1.0: cannot reset
port 2 (err = -108)
Oct 13 08:46:33 x110 kernel: [  261.742943] hub 1-0:1.0: cannot reset
port 2 (err = -108)
Oct 13 08:46:33 x110 kernel: [  261.742963] hub 1-0:1.0: cannot reset
port 2 (err = -108)
Oct 13 08:46:33 x110 kernel: [  261.742983] hub 1-0:1.0: cannot reset
port 2 (err = -108)
Oct 13 08:46:33 x110 kernel: [  261.742997] hub 1-0:1.0: Cannot enable
port 2.  Maybe the USB cable is bad?
Oct 13 08:46:33 x110 kernel: [  261.743018] hub 1-0:1.0: cannot disable
port 2 (err = -108)
Oct 13 08:46:33 x110 kernel: [  261.743041] hub 1-0:1.0: cannot reset
port 2 (err = -108)
Oct 13 08:46:33 x110 kernel: [  261.743059] hub 1-0:1.0: cannot reset
port 2 (err = -108)
Oct 13 08:46:33 x110 kernel: [  261.743076] hub 1-0:1.0: cannot reset
port 2 (err = -108)
Oct 13 08:46:33 x110 kernel: [  261.743092] hub 1-0:1.0: cannot reset
port 2 (err = -108)
Oct 13 08:46:33 x110 kernel: [  261.743108] hub 1-0:1.0: cannot reset
port 2 (err = -108)
Oct 13 08:46:33 x110 kernel: [  261.743121] hub 1-0:1.0: Cannot enable
port 2.  Maybe the USB cable is bad?
Oct 13 08:46:33 x110 kernel: [  261.743139] hub 1-0:1.0: cannot disable
port 2 (err = -108)
Oct 13 08:46:33 x110 kernel: [  261.743158] hub 1-0:1.0: cannot reset
port 2 (err = -108)
Oct 13 08:46:33 x110 kernel: [  261.743174] hub 1-0:1.0: cannot reset
port 2 (err = -108)
Oct 13 08:46:33 x110 kernel: [  261.743190] hub 1-0:1.0: cannot reset
port 2 (err = -108)
Oct 13 08:46:33 x110 kernel: [  261.743207] hub 1-0:1.0: cannot reset
port 2 (err = -108)
Oct 13 08:46:33 x110 kernel: [  261.743223] hub 1-0:1.0: cannot reset
port 2 (err = -108)
Oct 13 08:46:33 x110 kernel: [  261.743236] hub 1-0:1.0: Cannot enable
port 2.  Maybe the USB cable is bad?
Oct 13 08:46:33 x110 kernel: [  261.743253] hub 1-0:1.0: cannot disable
port 2 (err = -108)
Oct 13 08:46:33 x110 kernel: [  261.743294] hub 1-0:1.0: cannot reset
port 2 (err = -108)
Oct 13 08:46:33 x110 kernel: [  261.743311] hub 1-0:1.0: cannot reset
port 2 (err = -108)
Oct 13 08:46:33 x110 kernel: [  261.743327] hub 1-0:1.0: cannot reset
port 2 (err = -108)
Oct 13 08:46:33 x110 kernel: [  261.743343] hub 1-0:1.0: cannot reset
port 2 (err = -108)
Oct 13 08:46:33 x110 kernel: [  261.743359] hub 1-0:1.0: cannot reset
port 2 (err = -108)
Oct 13 08:46:33 x110 kernel: [  261.743372] hub 1-0:1.0: Cannot enable
port 2.  Maybe the USB cable is bad?
Oct 13 08:46:33 x110 kernel: [  261.743390] hub 1-0:1.0: cannot disable
port 2 (err = -108)
Oct 13 08:46:33 x110 kernel: [  261.743407] hub 1-0:1.0: cannot disable
port 2 (err = -108)
Oct 13 08:46:33 x110 kernel: [  261.748008] hub 1-0:1.0: hub_port_status
failed (err = -108)
Oct 13 08:46:33 x110 kernel: [  261.748032] hub 1-0:1.0: hub_port_status
failed (err = -108)

After that, plugging a USB device doesn't have any effect on the system,
dmesg is intact.
