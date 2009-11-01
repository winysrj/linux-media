Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:39592 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815AbZKAP72 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Nov 2009 10:59:28 -0500
Received: by bwz27 with SMTP id 27so5367519bwz.21
        for <linux-media@vger.kernel.org>; Sun, 01 Nov 2009 07:59:32 -0800 (PST)
Message-ID: <4AEDB05E.1090704@googlemail.com>
Date: Sun, 01 Nov 2009 16:59:26 +0100
From: e9hack <e9hack@googlemail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: johann.friedrichs@web.de, hunold@linuxtv.org, mchehab@redhat.com
Subject: bug in changeset 13239:54535665f94b ?
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

something is wrong in changeset 13239:54535665f94b. After applying it, I get page faults
in various applications:
...
Oct 31 17:36:35 vdr dhcpcd[3280]: wlan1: adding default route via 192.168.23.1 metric 0
Oct 31 17:36:35 vdr dhcpcd[3280]: wlan1: adding route to 169.254.0.0/16 metric 0
Oct 31 17:36:36 vdr kernel: [   25.759549] DEBI rx: 0(0)kB/s size=188/188/188 cnt=0/s, tx:
0(0)kB/s size=0/0/0 cnt=0/s
Oct 31 17:36:36 vdr kernel: [   25.787398] video directory[3249]: segfault at 7f8e8be1139d
ip 00007f8e8be125ce sp 0000000042312280 error 7 in libc-2.8.so[7f8e8bdbb000+14f000]
Oct 31 17:36:36 vdr modify_resolvconf: Service dhcpcd modified /etc/resolv.conf. See info
block in this file
Oct 31 17:36:36 vdr dhcpcd[3280]: wlan1: exiting
Oct 31 17:36:36 vdr kernel: [   25.858000] killproc[3380]: segfault at a18 ip
00007f2441b1b0b7 sp 00007fffbee296c0 error 6 in libc-2.8.so[7f2441ac4000+14f000]
Oct 31 17:36:36 vdr kernel: [   25.860567] killproc[3381]: segfault at a15 ip
00007fc02b4ad0b7 sp 00007fff554387e0 error 6 in libc-2.8.so[7fc02b456000+14f000]
Oct 31 17:36:36 vdr kernel: [   25.862552] killproc[3382]: segfault at a18 ip
00007f2016d9f0b7 sp 00007fff6e366b90 error 6 in libc-2.8.so[7f2016d48000+14f000]
Oct 31 17:36:36 vdr kernel: [   25.864523] killproc[3383]: segfault at a18 ip
00007f91d85df0b7 sp 00007fff8b13f2c0 error 6 in libc-2.8.so[7f91d8588000+14f000]
Oct 31 17:36:36 vdr ifdown:     wlan1
Oct 31 17:36:36 vdr kernel: [   25.942528] killproc[3416]: segfault at 1 ip
00007fdcdeccb0b7 sp 00007fff33c2ff00 error 6 in libc-2.8.so[7fdcdec74000+14f000]
Oct 31 17:36:36 vdr kernel: [   25.965127] ip[3423]: segfault at 0 ip 00007fb0dc50b47e sp
00007fffbf6d2790 error 6 in libc-2.8.so[7fb0dc4b4000+14f000]
Oct 31 17:36:36 vdr ifup:     wlan1
Oct 31 17:36:36 vdr SuSEfirewall2: /var/lock/SuSEfirewall2.booting exists which means
system boot in progress, exit.
Oct 31 17:36:36 vdr ifup-dhcp: IP/Netmask: '192.168.23.6'
Oct 31 17:36:36 vdr ifup-dhcp:  / '255.255.255.0'
Oct 31 17:36:36 vdr ifup-dhcp:  ('vdr')
Oct 31 17:36:36 vdr ifup-dhcp:
Oct 31 17:36:36 vdr kernel: [   26.567896] ip[3551]: segfault at 0 ip 00007f8c9b00f47e sp
00007fff71063240 error 6 in libc-2.8.so[7f8c9afb8000+14f000]
Oct 31 17:36:36 vdr kernel: [   26.664260] startproc[3587]: segfault at 99f ip
00007fa6c35790b7 sp 00007fffc6d713c0 error 6 in libc-2.8.so[7fa6c3522000+14f000]
...


If I remove the call to release_all_pagetables() in buffer_release(), I don't see this
page faults.

Regards,
Hartmut
