Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.9]:54752 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756521Ab0KRNTe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Nov 2010 08:19:34 -0500
Received: from localhost (localhost [127.0.0.1])
	by tyrex.lisa.loc (Postfix) with ESMTP id D36629596919
	for <linux-media@vger.kernel.org>; Thu, 18 Nov 2010 14:19:30 +0100 (CET)
From: "Hans-Peter Jansen" <hpj@urpla.net>
To: linux-media@vger.kernel.org
Subject: cx24116_cmd_execute() Firmware not responding
Date: Thu, 18 Nov 2010 14:19:25 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201011181419.25737.hpj@urpla.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi, 

sorry to bother you again, but I'm still in the course to get DVB/VDR
going _again_. 

Hardware: 2 * Hauppauge WinTV-HVR4000(Lite), 
          1 * Hauppauge WinTV Nexus-S

Software: openSUSE 11.1/i586 with Kernel:HEAD 2.6.36-94.1
          VDR 1.6.0-2 

VDR is limited operational, some recordings stutter, and the logs are 
flodded with:

Nov 18 13:09:03 tyrex kernel: [14180.392584] cx24116_cmd_execute() Firmware not responding
Nov 18 13:09:10 tyrex kernel: [14186.959970] cx24116_cmd_execute() Firmware not responding
Nov 18 13:09:19 tyrex kernel: [14196.433715] cx24116_cmd_execute() Firmware not responding
Nov 18 13:09:24 tyrex kernel: [14201.364116] cx24116_cmd_execute() Firmware not responding
Nov 18 13:09:31 tyrex kernel: [14207.927543] cx24116_cmd_execute() Firmware not responding
Nov 18 13:09:40 tyrex kernel: [14217.409232] cx24116_cmd_execute() Firmware not responding
Nov 18 13:09:50 tyrex kernel: [14226.886942] cx24116_cmd_execute() Firmware not responding
Nov 18 13:09:52 tyrex kernel: [14228.887018] cx24116_cmd_execute() Firmware not responding

Nov 18 13:09:02 tyrex vdr: [24392] buffer stats: 0 (0%) used
Nov 18 13:09:02 tyrex vdr: [24384] ERROR (dvbdevice.c,263): Die Wartezeit für die Verbindung ist abgelaufen
Nov 18 13:09:09 tyrex vdr: [24384] ERROR (dvbdevice.c,263): Die Wartezeit für die Verbindung ist abgelaufen
Nov 18 13:09:18 tyrex vdr: [24384] frontend 1 timed out while tuning to channel 2, tp 111954
Nov 18 13:09:18 tyrex vdr: [24384] ERROR (dvbdevice.c,263): Die Wartezeit für die Verbindung ist abgelaufen
Nov 18 13:09:23 tyrex vdr: [24392] buffer stats: 0 (0%) used
Nov 18 13:09:23 tyrex vdr: [24384] ERROR (dvbdevice.c,263): Die Wartezeit für die Verbindung ist abgelaufen
Nov 18 13:09:30 tyrex vdr: [24384] ERROR (dvbdevice.c,263): Die Wartezeit für die Verbindung ist abgelaufen
Nov 18 13:09:38 tyrex vdr: [24392] streamdev-server: Detaching current receiver
Nov 18 13:09:38 tyrex vdr: [24392] streamdev-server: Detaching current receiver
Nov 18 13:09:38 tyrex vdr: [24392] streamdev-server: Detaching current receiver
Nov 18 13:09:39 tyrex vdr: [24384] frontend 1 timed out while tuning to channel 1330, tp 111992
Nov 18 13:09:39 tyrex vdr: [24384] ERROR (dvbdevice.c,263): Die Wartezeit für die Verbindung ist abgelaufen
Nov 18 13:09:44 tyrex vdr: [24392] streamdev-server: Detaching current receiver
Nov 18 13:09:44 tyrex vdr: [24392] streamdev-server: Detaching current receiver
Nov 18 13:09:44 tyrex vdr: [24392] streamdev-server: Detaching current receiver
Nov 18 13:09:49 tyrex vdr: [24384] ERROR (dvbdevice.c,263): Die Wartezeit für die Verbindung ist abgelaufen
Nov 18 13:09:51 tyrex vdr: [24384] ERROR (dvbdevice.c,263): Die Wartezeit für die Verbindung ist abgelaufen
Nov 18 13:09:59 tyrex vdr: [24392] streamdev-server: Detaching current receiver
Nov 18 13:09:59 tyrex vdr: [24392] streamdev-server: Detaching current receiver
Nov 18 13:09:59 tyrex vdr: [24392] streamdev-server: Detaching current receiver

"Die Wartezeit für die Verbindung ist abgelaufen" is an translated ioctl 
error from this call: 
	CHECK(ioctl(fd_frontend, FE_SET_TONE, tone));
It might be translated with: "timeout for idle time of connection".

Running cx24116 with debugging enabled results in:

	ftp://urpla.net/cx24116-debug.log [One minute, 540 kiB]

vdr log from the same period:

Nov 18 14:00:03 tyrex vdr: [31450] streamdev-server: Detaching current receiver
Nov 18 14:00:03 tyrex vdr: [31450] streamdev-server: Detaching current receiver
Nov 18 14:00:03 tyrex vdr: [31450] streamdev-server: Detaching current receiver
Nov 18 14:00:06 tyrex vdr: [31445] ERROR (dvbdevice.c,263): Die Wartezeit für die Verbindung ist abgelaufen
Nov 18 14:00:08 tyrex vdr: [31445] ERROR (dvbdevice.c,263): Die Wartezeit für die Verbindung ist abgelaufen
Nov 18 14:00:08 tyrex vdr: [31443] changing pids of channel 1331 from 151+151:160=hun,161=cze,162=eng,163=eng:0:170 to 1
51+151:160=hun,161=cze,162=eng,163=eng:171=hun,172=cze:170
Nov 18 14:00:09 tyrex vdr: [31443] changing pids of channel 1341 from 651+651:660=hun,661=cze:0:0 to 651+651:660=hun,661
=cze:670=cze,671=hun,672=cze:0
Nov 18 14:00:17 tyrex vdr: [31445] frontend 2 timed out while tuning to channel 62, tp 112031
Nov 18 14:00:17 tyrex vdr: [31445] ERROR (dvbdevice.c,263): Die Wartezeit für die Verbindung ist abgelaufen
Nov 18 14:00:20 tyrex vdr: [31450] streamdev-server: Detaching current receiver
Nov 18 14:00:20 tyrex vdr: [31450] streamdev-server: Detaching current receiver
Nov 18 14:00:20 tyrex vdr: [31450] streamdev-server: Detaching current receiver
Nov 18 14:00:24 tyrex vdr: [31450] streamdev-server: Detaching current receiver
Nov 18 14:00:24 tyrex vdr: [31450] streamdev-server: Detaching current receiver
Nov 18 14:00:24 tyrex vdr: [31450] streamdev-server: Detaching current receiver
Nov 18 14:00:27 tyrex vdr: [31445] ERROR (dvbdevice.c,263): Die Wartezeit für die Verbindung ist abgelaufen
Nov 18 14:00:29 tyrex vdr: [31445] ERROR (dvbdevice.c,263): Die Wartezeit für die Verbindung ist abgelaufen
Nov 18 14:00:29 tyrex vdr: [31443] changing name of channel 1293 from '404 - 12:30,;' to '404 - 14:30,;'
Nov 18 14:00:29 tyrex vdr: [31443] changing name of channel 1296 from '392 - 12:30,;' to '392 - 14:30,;'
Nov 18 14:00:29 tyrex vdr: [31443] changing name of channel 1299 from '409 - 12:30,;' to '409 - 14:30,;'
Nov 18 14:00:29 tyrex vdr: [31443] linking channel 702 from 1293 1300 1296 1298 1299 1297 1301 1294 1295 to 1300 1293 12
98 1296 1297 1299 1301 1294 1295
Nov 18 14:00:38 tyrex vdr: [31445] frontend 2 timed out while tuning to channel 17, tp 112109
Nov 18 14:00:38 tyrex vdr: [31445] ERROR (dvbdevice.c,263): Die Wartezeit für die Verbindung ist abgelaufen
Nov 18 14:00:45 tyrex vdr: [31450] buffer stats: 0 (0%) used
Nov 18 14:00:48 tyrex vdr: [31445] ERROR (dvbdevice.c,263): Die Wartezeit für die Verbindung ist abgelaufen
Nov 18 14:00:50 tyrex vdr: [31445] ERROR (dvbdevice.c,263): Die Wartezeit für die Verbindung ist abgelaufen
Nov 18 14:00:59 tyrex vdr: [31445] frontend 2 timed out while tuning to channel 5, tp 112188
Nov 18 14:00:59 tyrex vdr: [31445] ERROR (dvbdevice.c,263): Die Wartezeit für die Verbindung ist abgelaufen

Does this make some sense for somebody in the audience, and even more
important, can it be cured in some way?

Thanks in advance,
Pete
