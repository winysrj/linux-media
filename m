Return-path: <mchehab@pedra>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:42729 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170Ab1B1R0Q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Feb 2011 12:26:16 -0500
Received: by qyk7 with SMTP id 7so2486446qyk.19
        for <linux-media@vger.kernel.org>; Mon, 28 Feb 2011 09:26:15 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 28 Feb 2011 18:26:15 +0100
Message-ID: <AANLkTinfJiCpMOTx4-mc6jW3Bpe_3qduLYpqvRi8U+ga@mail.gmail.com>
Subject: Remote control not working for Terratec Cinergy C (2.6.37 Mantis driver)
From: Jonas Hanschke <jonas.hanschke@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

despite lots of time spent tinkering around and looking for help on
the web, I've had no success in getting to work the remote control of
my DVB-C card.

It is a Terratec Cinergy C:
http://linuxtv.org/wiki/index.php/TerraTec_Cinergy_C_DVB-C

and am using the Mantis driver. Since it was merged into the kernel
tree in 2.6.33, watching TV works without patches, but the remote
control does not, although it is supposed to be supported, according
to the link above.

Kernel is a vanilla 2.6.37.2 with custom configuration on an old AMD
Athlon XP machine, running debian Squeeze.


When I modprobe the Mantis driver, the following IR-modules are pulled
in automagically:
ir_lirc_codec
lirc_dev
ir_core

However, no input device is created during module loading. dmesg output:
Mantis 0000:01:0a.0: PCI INT A -> Link[APC1] -> GSI 16 (level, high) -> IRQ 16
DVB: registering new adapter (Mantis DVB adapter)
IR LIRC bridge handler initialized
DVB: registering adapter 0 frontend 0 (Philips TDA10023 DVB-C)...

Am I missing some additional modules? Are there any dependencies on
other kernel config options that are not handled automatically by make
menuconf?

If additional information is needed, I will be happy to provide it.
However, I am not sure what is useful and what is not and did not want
to bloat this message.

Thanks in advance,

Jonas
