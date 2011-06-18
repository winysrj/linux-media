Return-path: <mchehab@pedra>
Received: from 5571f1ba.dsl.concepts.nl ([85.113.241.186]:37195 "EHLO
	his10.thuis.hoogenraad.info" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752028Ab1FRSnQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Jun 2011 14:43:16 -0400
Received: from his10.thuis.hoogenraad.info (unknown [IPv6:::1])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by his10.thuis.hoogenraad.info (Postfix) with ESMTPS id 18D7C34E0087
	for <linux-media@vger.kernel.org>; Sat, 18 Jun 2011 20:43:14 +0200 (CEST)
Message-ID: <4DFCF1C1.6090509@hoogenraad.net>
Date: Sat, 18 Jun 2011 20:43:13 +0200
From: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: dvb_usb symbols from media_build disagree on Linux 2.6.32-32
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Trying to compile and install media_build on an Ubuntu Lucid computer
Linux 2.6.32-32-generic-pae #62-Ubuntu SMP Wed Apr 20 22:10:33 UTC 2011 
i686 GNU/Linux

I can compile, but cannot use dvb-usb. With the snapshot of june 11th, I 
was able to do this with no problem.
Can somebody help me ?

sudo modprobe dvb-usb
yields
FATAL: Error inserting dvb_usb 
(/lib/modules/2.6.32-32-generic-pae/kernel/drivers/media/dvb/dvb-usb/dvb-usb.ko): 
Unknown symbol in module, or unknown parameter (see dmesg)


dmesg

[678605.646889] WARNING: You are using an experimental version of the 
media stack.
[678605.646891]     As the driver is backported to an older kernel, it 
doesn't offer
[678605.646892]     enough quality for its usage in production.
[678605.646893]     Use it with care.
[678605.646893] Latest git patches (needed if you report a bug to 
linux-media@vger.kernel.org):
[678605.646894]     5b5c6e080e7d3b484536fa5c96b78ff53df83e84 [media] 
marvell-cam: Basic working MMP camera driver
[678605.646895]     7788a403987b5557e124f4cd76bfde5ffb804960 [media] 
marvell-cam: Allocate the i2c adapter in the platform driver
[678605.646896]     dc10bc206b121fcc6308438826a0c9c147fe5051 [media] 
marvell-cam: Right-shift i2c slave ID's in the cafe driver
[678605.647853] dvb_usb: disagrees about version of symbol 
rc_register_device
[678605.647855] dvb_usb: Unknown symbol rc_register_device
[678605.648167] dvb_usb: disagrees about version of symbol rc_free_device
[678605.648169] dvb_usb: Unknown symbol rc_free_device
[678605.648398] dvb_usb: disagrees about version of symbol 
rc_allocate_device
[678605.648400] dvb_usb: Unknown symbol rc_allocate_device
[678605.648862] dvb_usb: disagrees about version of symbol 
rc_unregister_device
[678605.648863] dvb_usb: Unknown symbol rc_unregister_device


-- 
Jan Hoogenraad
Hoogenraad Interface Services
Postbus 2717
3500 GS Utrecht

