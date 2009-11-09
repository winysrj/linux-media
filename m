Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:46599 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbZKILNi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Nov 2009 06:13:38 -0500
Received: by bwz27 with SMTP id 27so3314499bwz.21
        for <linux-media@vger.kernel.org>; Mon, 09 Nov 2009 03:13:42 -0800 (PST)
MIME-Version: 1.0
From: Valerio Bontempi <valerio.bontempi@gmail.com>
Date: Mon, 9 Nov 2009 12:13:22 +0100
Message-ID: <ad6681df0911090313t17652362v2e92c465b60a92e4@mail.gmail.com>
Subject: [XC3028] Terretec Cinergy T XS wrong firmware xc3028-v27.fw
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I have a problem trying to user Terratec Cinergy T XS (usb dvb only
adapter) with XC3028 tuner:
v4l dvb driver installed in last kernel versions (actually I am using
2.6.31 from ubuntu 9.10) detects this device but then looks for the
wrong firmware xc3028-v27.fw, and, moreover, seems to not contain
correct device firmware at all.
This makes the device to be detected but dvb device /dev/dvb is not
created by the kernel.

Is there a way to make this device to work with last kernel versions
and last v4l-dvb driver versions?


Thanks and regards in advance

Valerio Bontempi
