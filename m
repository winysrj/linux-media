Return-path: <mchehab@pedra>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:38771 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198Ab1AQXeX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Jan 2011 18:34:23 -0500
Received: by qyk12 with SMTP id 12so6336785qyk.19
        for <linux-media@vger.kernel.org>; Mon, 17 Jan 2011 15:34:22 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 17 Jan 2011 21:34:19 -0200
Message-ID: <AANLkTik_xyzN_pNov1KbjAxAriZJk0yhEy6mnr+M9VN2@mail.gmail.com>
Subject: Detecting remote control of Hauppauge WinTV-HVR-1150 (saa7134)
From: Fernando Laudares Camargos <fernando.laudares.camargos@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

we've a set of Hauppauge WinTV-HVR-1150 that works very well on
analogic mode on Ubuntu 10.10, but we don't seem to get the remote
control input to work. Apparently it's not detected by the kernel (no
reference in /proc/bus/input/devices, no eventX under /dev/input ).
