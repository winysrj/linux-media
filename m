Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-12.arcor-online.net ([151.189.21.52]:34070 "EHLO
	mail-in-12.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756848Ab3IOA3X (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Sep 2013 20:29:23 -0400
Received: from mail-in-14-z2.arcor-online.net (mail-in-14-z2.arcor-online.net [151.189.8.31])
	by mx.arcor.de (Postfix) with ESMTP id F000526584
	for <linux-media@vger.kernel.org>; Sun, 15 Sep 2013 02:29:21 +0200 (CEST)
Received: from mail-in-05.arcor-online.net (mail-in-05.arcor-online.net [151.189.21.45])
	by mail-in-14-z2.arcor-online.net (Postfix) with ESMTP id E958A18742
	for <linux-media@vger.kernel.org>; Sun, 15 Sep 2013 02:29:21 +0200 (CEST)
Received: from [192.168.2.103] (dslb-088-066-058-225.pools.arcor-ip.net [88.66.58.225])
	(Authenticated sender: wessels.tobias@arcor.de)
	by mail-in-05.arcor-online.net (Postfix) with ESMTPA id C0655E3B96
	for <linux-media@vger.kernel.org>; Sun, 15 Sep 2013 02:29:21 +0200 (CEST)
Message-ID: <1379204963.4144.24.camel@debian>
Subject: Problems with TechniSat CableStar Combo HD CI
From: Tobias Wessels <wessels.tobias@arcor.de>
To: linux-media@vger.kernel.org
Date: Sun, 15 Sep 2013 02:29:23 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everyone on this list,

This is my first post in a mailing list and I'm not quite sure if this
is the right place seeking help for a technical problem with a specific
DVB-C card. But since I've searched everywhere on the net, this is my
last chance for now to resolve a problem with the DVB-T/C card
"TechniSat CableStar Combo HD CI".

I have this card since a long time ago, but it never worked (and still
doesn't). But just recently I've read on linuxtv.org that it is possible
to use that card with the latest kernels (from 3.9.2 on) and modified
drivers, so I decided to give it another try; following the instructions
from this post:
http://forum.ubuntuusers.de/topic/technisat-cablestar-combo-hd-benutzen/#post-5650497

At first, everything looked fine, since the card seems to be recognized
and the drivers are loaded; as shown by the dmesg output:

[ 1322.092805] DVB: registering new adapter (Technisat Combo HD CI)
[ 1322.095684] usb 1-2: dvb_usb_v2: MAC address: c2:f7:14:03:00:00
[ 1322.096525] drxk: frontend initialized.
[ 1322.096625] usb 1-2: firmware: agent loaded
dvb-usb-terratec-h7-drxk.fw into memory
[ 1322.096759] usb 1-2: DVB: registering adapter 0 frontend 0 (DRXK)...
[ 1322.096869] mt2063_attach: Attaching MT2063
[ 1322.096881] Registered IR keymap rc-nec-terratec-cinergy-xs
[ 1322.097128] input: Technisat Combo HD CI
as /devices/pci0000:00/0000:00:12.2/usb1/1-2/rc/rc1/input16
[ 1322.097338] rc1: Technisat Combo HD CI
as /devices/pci0000:00/0000:00:12.2/usb1/1-2/rc/rc1
[ 1322.097347] usb 1-2: dvb_usb_v2: schedule remote query interval to
400 msecs
[ 1322.097357] usb 1-2: dvb_usb_v2: 'Technisat Combo HD CI' successfully
initialized and connected
[ 1322.145024] drxk: status = 0x439130d9
[ 1322.145028] drxk: detected a drx-3913k, spin A2, xtal 27.000 MHz
[ 1324.410428] drxk: DRXK driver version 0.9.4300
[ 1403.954692] mt2063: detected a mt2063 B3


So I've tried to run a scan for TV channels with w_scan (run as root),
which runs through, but doesn't find any. And another look into the
dmesg shows why:

[ 1403.954692] mt2063: detected a mt2063 B3
[ 1404.621902] usb 1-2: dvb_frontend_ioctl_legacy: doesn't know how to
handle a DVBv3 call to delivery system 0
[ 1404.854807] mt2063: detected a mt2063 B3
[ 1405.523916] usb 1-2: dvb_frontend_ioctl_legacy: doesn't know how to
handle a DVBv3 call to delivery system 0
[ 1405.882456] drxk: SCU not ready
[ 1405.882470] drxk: Error -5 on qam_reset_qam
[ 1405.882477] drxk: Error -5 on set_qam_standard
[ 1405.882482] drxk: Error -5 on setoperation_mode
[ 1406.094010] drxk: SCU not ready
[ 1406.094023] drxk: Error -5 on qam_reset_qam
[ 1406.094028] drxk: Error -5 on set_qam
[ 1406.094033] drxk: Error -5 on start
[ 1406.727412] drxk: SCU not ready
[ 1406.727425] drxk: Error -5 on get_qam_lock_status
[ 1406.727430] drxk: Error -5 on get_lock_status
[ 1407.088033] drxk: SCU not ready
[ 1407.088046] drxk: Error -5 on get_qam_lock_status
[ 1407.088052] drxk: Error -5 on get_lock_status
<<[... and so on ...]>>


I've tried the newest drivers with two different kernels... the Wheezy
stock kernel (3.2) and the newest backport kernel both in a freshly
installed Debian Wheezy.

Before I give you the rest of the relevant info one more thing. Even if
you don't have the time now to help and fix this issue, I want to thank
you so far for your work to make linux such a great system.

So here comes the rest of the info, which hopefully helps you, and
greeting to all of you. For further questions feel free to contact me.

Tobias Wessels


$# uname -a
Linux debian 3.10-0.bpo.2-686-pae #1 SMP Debian 3.10.5-1~bpo70+1
(2013-08-11) i686 GNU/Linux

$# lsusb -v
Bus 001 Device 011: ID 14f7:0003 TechniSat Digital GmbH CableStar Combo
HD CI
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  idVendor           0x14f7 TechniSat Digital GmbH
  idProduct          0x0003 CableStar Combo HD CI
  bcdDevice            0.03
  iManufacturer           1 TechniSat Digital S.A.
  iProduct                2 CableStar Combo HD CI
  iSerial                 3 0008C9D90E19
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           32
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xc0
      Self Powered
    MaxPower              100mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0 
      bInterfaceProtocol      0 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval             100
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               1
Device Qualifier (for other device speed):
  bLength                10
  bDescriptorType         6
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  bNumConfigurations      1
Device Status:     0x0001
  Self Powered




