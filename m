Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.topaz.synacor.com ([69.168.108.19]:12268 "EHLO
	mail.tesco.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752658AbbADPzO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 4 Jan 2015 10:55:14 -0500
Message-ID: <54A9608F.9000801@tesco.net>
Date: Sun, 04 Jan 2015 15:47:27 +0000
From: John Pilkington <J.Pilk@tesco.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: DVB-T regressions in recent kernels for el7
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi:  It's a long time since I posted to this list.  I'm a long-time user 
of MythTV, using DVB-T in the UK.

My current Mythbox is running myth-master under Scientific Linux 7, a 
near-clone of RHEL7, an x86_64 distro.  I know that long-lived distros 
like this are not a prime target for linux-media, but they have some 
attractions.

I'm currently running a recent but not current stock kernel; it works 
for me.  Later stock kernels don't see the Hauppauge pci DVB-T card and 
don't identify separately the two tuners in the Kworld usb device. I've 
also tried later kernels from elrepo, with similar lack of success.

So, I do have a working box, but updating kernels is broken.  I'd 
appreciate suggestions.

I have posted earlier on the MythTV and SL lists, without getting 
suggestions leading to a solution.

Thanks,

John Pilkington

-----------------
This one works:

[john@HP_Box ~]$ uname -r
3.10.0-123.9.3.el7.x86_64
[john@HP_Box ~]$ dmesg | grep adapter
[   12.319211] DVB: registering new adapter (Kworld UB499-2T T09(IT9137))
[   12.939916] usb 2-2: DVB: registering adapter 0 frontend 0 (Kworld 
UB499-2T T09(IT9137)_1)...
[   12.941371] DVB: registering new adapter (Kworld UB499-2T T09(IT9137))
[   13.584187] usb 2-2: DVB: registering adapter 1 frontend 0 (Kworld 
UB499-2T T09(IT9137)_2)...
[   16.764033] DVB: registering new adapter (saa7133[0])
[   16.764043] saa7134 0000:07:04.0: DVB: registering adapter 2 frontend 
0 (Philips TDA10046H DVB-T)...

-----------------
This one, a later stock el7 kernel, doesn't work.

[john@HP_Box ~]$ uname -r
3.10.0-123.13.1.el7.x86_64
john@HP_Box ~]$ dmesg | grep DVB
[    1.556887] saa7133[0]: subsystem: 0070:6700, board: Hauppauge 
WinTV-HVR1110 DVB-T/Hybrid [card=104,autodetected]
[    1.695217] tveeprom 0-0050: TV standards PAL(B/G) NTSC(M) PAL(I) 
SECAM(L/L') PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xfc)
[    1.708443] DVB: Unable to find symbol tda10046_attach()  ******
[    1.736049] usb 2-2: Product: DVB-T TV Stick
[    1.845944] DVB: registering new adapter (Kworld UB499-2T T09(IT9137))
[    1.848465] DVB: Unable to find symbol it913x_fe_attach()  ******

-----------------------
.. and this, a 'testing' kernel, doesn't see the Hauppauge pci device.

[john@HP_Box ~]$ uname -r
3.18.0-1.el7.elrepo.x86_64
[john@HP_Box ~]$ dmesg | grep adapter
[   11.707221] DVB: registering new adapter (Kworld UB499-2T T09)
[   12.054409] usb 2-2: DVB: registering adapter 0 frontend 0 (Afatech 
AF9033 (DVB-T))...
[   12.343371] DVB: registering new adapter (Kworld UB499-2T T09)
[   12.352152] usb 2-2: DVB: registering adapter 1 frontend 0 (Afatech 
AF9033 (DVB-T))...

-----------------
End

