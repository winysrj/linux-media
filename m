Return-path: <mchehab@pedra>
Received: from fb1.tech.numericable.fr ([82.216.111.51]:54929 "EHLO
	fb1.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532Ab0JCKBN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Oct 2010 06:01:13 -0400
Received: from smtp6.tech.numericable.fr (smtp6.nc.sdv.fr [10.0.0.83])
	by fb1.tech.numericable.fr (Postfix) with ESMTP id 7F2859FCCD
	for <linux-media@vger.kernel.org>; Sun,  3 Oct 2010 11:55:06 +0200 (CEST)
Received: from [192.168.2.1] (abo-159-1-69.bdx.modulonet.fr [85.69.1.159])
	by smtp6.tech.numericable.fr (Postfix) with ESMTP id 86D2B144016
	for <linux-media@vger.kernel.org>; Sun,  3 Oct 2010 11:53:48 +0200 (CEST)
Message-ID: <4CA852B1.1040207@libertysurf.fr>
Date: Sun, 03 Oct 2010 11:53:53 +0200
From: Catimimi <catimimi@libertysurf.fr>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Terratec Cinergy Hybrid T USB XS FR is no longer working
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

  Hi,

I upgraded my opensuse kernel to version 2.6.31.14-0.1 and compiled v4l-dvd downloaded from Mercurial and
now my device Terratec Cinergy Hybrid T USB XS FR doesn't work.

Here is my dmesg :

[  845.348066] usb 2-3: new high speed USB device using ehci_hcd and address 4
[  845.490641] usb 2-3: New USB device found, idVendor=0ccd, idProduct=004c
[  845.490659] usb 2-3: New USB device strings: Mfr=2, Product=1, SerialNumber=0
[  845.490671] usb 2-3: Product: Cinergy Hybrid T USB XS FR
[  845.490681] usb 2-3: Manufacturer: TerraTec Electronic GmbH
[  845.490850] usb 2-3: configuration #1 chosen from 1 choice
[  845.515209] v4l2_common: disagrees about version of symbol v4l2_device_register_subdev
[  845.515221] v4l2_common: Unknown symbol v4l2_device_register_subdev
[  845.515342] v4l2_common: disagrees about version of symbol v4l2_device_unregister_subdev
[  845.515350] v4l2_common: Unknown symbol v4l2_device_unregister_subdev
[  845.584812] v4l2_common: disagrees about version of symbol v4l2_device_register_subdev
[  845.584825] v4l2_common: Unknown symbol v4l2_device_register_subdev
[  845.584946] v4l2_common: disagrees about version of symbol v4l2_device_unregister_subdev
[  845.584954] v4l2_common: Unknown symbol v4l2_device_unregister_subdev
[  845.690309] v4l2_common: disagrees about version of symbol v4l2_device_register_subdev
[  845.690328] v4l2_common: Unknown symbol v4l2_device_register_subdev
[  845.690524] v4l2_common: disagrees about version of symbol v4l2_device_unregister_subdev
[  845.690537] v4l2_common: Unknown symbol v4l2_device_unregister_subdev
[  845.706641] usbcore: registered new interface driver snd-usb-audio

What can I do in order to solve the problem.

Thanks in advance.
Regards.
Michel.

