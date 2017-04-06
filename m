Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.133]:55901 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932797AbdDFIr6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 6 Apr 2017 04:47:58 -0400
Received: from aragorn2 ([84.150.11.152]) by mrelayeu.kundenserver.de
 (mreue004 [212.227.15.130]) with ESMTPA (Nemesis) id 0MaG3Y-1cgj8y3AHQ-00Jqlt
 for <linux-media@vger.kernel.org>; Thu, 06 Apr 2017 10:47:20 +0200
Reply-To: <klaus@eicheler.de>
From: "Klaus Eicheler" <klaus@eicheler.de>
To: <linux-media@vger.kernel.org>
Subject: Unknown symbol problem; em28xx (WinTV-soloHD)
Date: Thu, 6 Apr 2017 10:47:20 +0200
Message-ID: <GCEIIGDJBAPBFIDFCCMBIEAICNAA.klaus@eicheler.de>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

compiling media_build on my openSUSE 13.1 machine worked without errors, but
issued some warnings, finally leading to (dmesg):

[97792.189678] usb 2-1.6: new high-speed USB device number 10 using ehci-pci
[97792.276140] usb 2-1.6: New USB device found, idVendor=2040,
idProduct=0264
[97792.276147] usb 2-1.6: New USB device strings: Mfr=3, Product=1,
SerialNumber=2
[97792.276151] usb 2-1.6: Product: soloHD
[97792.276154] usb 2-1.6: Manufacturer: HCW
[97792.276157] usb 2-1.6: SerialNumber: 0013813833
[97792.445273] em28xx: Unknown symbol v4l2_clk_unregister_fixed (err 0)
[97792.445319] em28xx: Unknown symbol __v4l2_clk_register_fixed (err 0)

The DVB stick seems to be well recognized (-> em28xx). The only reference to
v4l2_clk_unregister_fixed I could find was inside em28xx-camera.c.

modprobe em28xx yields the same results.

Do you have any hints how to solve the problem?

Cheers
Mit freundlichen Grüßen
Klaus Eicheler
