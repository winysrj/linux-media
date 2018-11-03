Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:52351 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726849AbeKCTX4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 3 Nov 2018 15:23:56 -0400
MIME-Version: 1.0
Message-ID: <trinity-ca86e9e5-75b4-4c41-8330-00a10bc93393-1541239986803@3c-app-mailcom-bs16>
From: daggs <daggs@gmx.com>
To: linux-media@vger.kernel.org
Subject: Mygica T230 DVB-T/T2/C usb fails constantly with bulk errors
Content-Type: text/plain; charset=UTF-8
Date: Sat, 3 Nov 2018 11:13:06 +0100
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Greetings,

I ave a Mygica T230 DVB-T/T2/C usb dongle which I use to view dvb broadcasting.
it seems that after a sometime, the device stops working and fills dmesg with the following errors:
bulk message failed: -110 (1/0)

only tvheadend stop + device removal resets the device but the issue resurfaces later on.
I've tried the device on two different systems and three kernels, all shows the same issue.
x64 debian with kernels 4.15 and 4.18 and rpi2 with 4.14.70-v7+

is there any known solution for this issue?

thanks,

Dagg.
