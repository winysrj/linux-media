Return-path: <mchehab@gaivota>
Received: from ns210619.ovh.net ([188.165.206.83]:59277 "EHLO ns210619.ovh.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753783Ab0LVQUs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Dec 2010 11:20:48 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
	by ns210619.ovh.net (Postfix) with ESMTP id 502513D1E35E
	for <linux-media@vger.kernel.org>; Wed, 22 Dec 2010 17:21:56 +0100 (CET)
Received: from ns210619.ovh.net ([127.0.0.1])
	by localhost (ns210619.ovh.net [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MiGyyUEqJOrB for <linux-media@vger.kernel.org>;
	Wed, 22 Dec 2010 17:21:54 +0100 (CET)
Received: from [192.168.1.4] (31.9.18.95.dynamic.jazztel.es [95.18.9.31])
	by ns210619.ovh.net (Postfix) with ESMTPA id 4A2F43D1E03E
	for <linux-media@vger.kernel.org>; Wed, 22 Dec 2010 17:21:54 +0100 (CET)
Message-ID: <4D122557.8080401@linos.es>
Date: Wed, 22 Dec 2010 17:20:39 +0100
From: Linos <info@linos.es>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Fwd: bttv problem
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Any possible fix for this problem please?

-------- Mensaje original --------
Asunto: bttv problem
Fecha: Sun, 19 Dec 2010 13:54:00 +0100
De: Linos <info@linos.es>
Para: linux-media@vger.kernel.org

Hi,
	i have 2 Provideo PV150 multi-capture PCI board video cards  (4 bt878 chipsets
in every board), i have the four ports of the first multi-capture boards used in
a xorg session with 4 instances of tvtime application showing the realtime of
the four ports, and the other one recording with Helix producer.

Many times a day i have this errors in kernel:

[447547.296022] bttv7: timeout: drop=3276 irq=1957469/35501901, risc=204bb9ac,
bits: HSYNC OFLOW
[447547.836020] bttv7: timeout: drop=3287 irq=1957508/35501981, risc=2a9a89ac,
bits: HSYNC OFLOW
[448114.536016] bttv6: timeout: drop=4747 irq=26301665/59788770, risc=2050c998,
bits: HSYNC OFLOW
[449923.196018] bttv1: timeout: drop=57206 irq=33728690/35680137, risc=19d83acc,
bits: HSYNC OFLOW FBUS
[449923.736024] bttv1: timeout: drop=57217 irq=33728729/35680176, risc=344faf20,
bits: HSYNC OFLOW FBUS

Tvtime seems to survive but the helix producer processess die with this error,
if i don't load the xorg session with tvtime and at the same time I disable acpi
in linux i don't get this erros, i have tried to disable acpi because i have
read about other people having the same problem and fixing this way, but if i
use tvtime at the same time the problem remains regardless of the acpi status, i
have now gbuffers at 16 but still the same result.

My system it is using debian squeeze with 2.6.32 kernel in a Asus P5E-V HDMI
with an intel G-35 chipset.

Any ideas on how i could fix this problem please?

Regards,
Miguel Angel.
--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
