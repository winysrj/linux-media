Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:57263 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755285Ab0FNUQb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jun 2010 16:16:31 -0400
Message-ID: <4C168E17.8020001@nexgo.de>
Date: Mon, 14 Jun 2010 22:16:23 +0200
From: Martin Berndaner <martin.berndaner@nexgo.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Problems with Technisat Skystar HD S2 USB and VDR
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear Group,

i have a Technisat Skystar USB HD S2 Box working in my VDR.
But when tuning to channels in the lowband e.g. "Das Erste HD" or "TVP
Info" it seems that the driver gets no lock.

Jun 14 22:07:23 proykon vdr: [24686] TS buffer on device 1 thread
started (pid=24245, tid=24686)
......
Jun 14 22:07:30 proykon kernel: [115652.858425] stb6100_set_frequency:
Frequency=1023000
Jun 14 22:07:30 proykon kernel: [115652.894298] stb6100_get_frequency:
Frequency=1022994
Jun 14 22:07:30 proykon kernel: [115652.935547] stb6100_get_bandwidth:
Bandwidth=52000000
Jun 14 22:07:31 proykon kernel: [115653.915758] stb6100_set_bandwidth:
Bandwidth=51610000
Jun 14 22:07:31 proykon kernel: [115653.951506] stb6100_get_bandwidth:
Bandwidth=52000000
Jun 14 22:07:31 proykon kernel: [115654.030503] stb6100_get_bandwidth:
Bandwidth=52000000
Jun 14 22:07:31 proykon kernel: [115654.162495] stb6100_set_frequency:
Frequency=1023000
Jun 14 22:07:31 proykon kernel: [115654.198120] stb6100_get_frequency:
Frequency=1022994
Jun 14 22:07:31 proykon kernel: [115654.239870] stb6100_get_bandwidth:
Bandwidth=52000000
Jun 14 22:07:32 proykon vdr: [24251] frontend 0/0 timed out while tuning
to channel 673, tp 110773
Jun 14 22:07:32 proykon kernel: [115655.135586] stb6100_set_bandwidth:
Bandwidth=51610000
Jun 14 22:07:32 proykon kernel: [115655.171083] stb6100_get_bandwidth:
Bandwidth=52000000
.....

Linux proykon 2.6.34 #2 SMP Wed Jun 2 21:49:57 CEST 2010 i686 GNU/Linux
I use the DVB driver of the repository s2-liplianin

Does anybody know such a problem?

Regards
Martin Berndaner
