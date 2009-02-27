Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f176.google.com ([209.85.220.176]:62942 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753203AbZB0IvE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Feb 2009 03:51:04 -0500
Received: by fxm24 with SMTP id 24so930104fxm.37
        for <linux-media@vger.kernel.org>; Fri, 27 Feb 2009 00:51:02 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 27 Feb 2009 10:51:01 +0200
Message-ID: <45108b180902270051p35c88b05nf6ca754123b5f953@mail.gmail.com>
Subject: DViCO FusionHDTV driver/firmware problem
From: Serg Gulko <s.gulko@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello!

I am using DViCO FusionHDTV DVB-T Dual Express with latest drivers and
kernel 2.6.27-7.
After system reboot or combination rmmod/modprobe cx23885 getstream(or
any another application) working with card do his job well. Once it
terminated(by Ctrl+C) or even simply stopped(when job is finished,
e.g. scan) I cant make any DVB related tools work. In
/var/log/messages i have lots of messages like this:

Feb 27 19:31:01 iptv-dvbt kernel: [39261.670228] xc2028 0-0061:
Loading firmware for type=D2633 DTV7 (90), id 0000000000000000.
Feb 27 19:31:01 iptv-dvbt kernel: [39261.685084] xc2028 0-0061:
Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE
HAS_IF_4760 (620003e0), id 0000000000000000.
Feb 27 19:31:01 iptv-dvbt kernel: [39261.980032] xc2028 0-0061:
Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Feb 27 19:31:03 iptv-dvbt kernel: [39263.250229] xc2028 0-0061:
Loading firmware for type=D2633 DTV7 (90), id 0000000000000000.
Feb 27 19:31:03 iptv-dvbt kernel: [39263.265086] xc2028 0-0061:
Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE
HAS_IF_4760 (620003e0), id 0000000000000000.
I have xc3028-v27.fw placed in /lib/firmware.
After rmmod/modprobe I can perform new try. Maybe someone here has
same problem in the past(and more important successfully solved it:))?

Thansk,
Serg Gulko
