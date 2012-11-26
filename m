Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:61325 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756569Ab2KZRuH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Nov 2012 12:50:07 -0500
Received: by mail-vb0-f46.google.com with SMTP id ff1so5902877vbb.19
        for <linux-media@vger.kernel.org>; Mon, 26 Nov 2012 09:50:06 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 26 Nov 2012 18:50:06 +0100
Message-ID: <CAK02SCLV3677t1UQe56aWA7qBwoLna2=UREq1GAfS9PqT2deEA@mail.gmail.com>
Subject: Tuning problems with em28xx-dvb & tda10071 on MIPS-based router board
From: Ingo Kofler <ingo.kofler@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I am trying to get my PCTV DVB-S2 stick running on my TP-Link
TL-WR1043ND that runs OpenWrt (Attitude Adjustment Beta, Kernel
3.3.8). I have cross-compiled the corresponding kernel modules and
deployed them on the router. I have also deployed the firmware on the
device.

After loading the corresponding modules the /dev/dvb/... devices show
up and the dmesg output seems to be fine. Then I tried to test the
device using szap and a channels.conf file. Unfortunately, the device
cannot tune to most of the transponders except of two. Both are
located in the vertical high band of the Astra 19E. For all other
transponders I do not get a lock of the frontend.

Tuning works fine on my PC using kernel verions 3.2 and 3.5 (the ones
that ship with Ubuntu) and using the same channels.conf file and
stick. So I conclude that both the stick, the satellite dish and the
channels.conf is working. I've also tested it on the router board with
an external powered USB Hub (I though that maybe the power of the
router's USB port wasn't good enough).

Now I have no further ideas. Before I start to debug the C code and
try to figure out the difference between the PC and the router - Are
there any known issues with this driver? Does it work on MIPS and
different endianess?

Best regards,
Ingo
