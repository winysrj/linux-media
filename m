Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35529 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168Ab1JFWec (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Oct 2011 18:34:32 -0400
Received: by iakk32 with SMTP id k32so3450379iak.19
        for <linux-media@vger.kernel.org>; Thu, 06 Oct 2011 15:34:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAL9G6WXb9zkgu++__LzW4nBBoAQYBvWWNCJkm_nRqiJEg+VE1A@mail.gmail.com>
References: <4e83369f.5d6de30a.485b.ffffdc29@mx.google.com>
	<CAL9G6WWK-Fas4Yx2q2gPpLvo5T2SxVVNFtvSXeD7j07JbX2srw@mail.gmail.com>
	<CAATJ+fvHQgVMVp1uwxxci61qdCdxG89qK0ja-=jo4JRyGW52cw@mail.gmail.com>
	<4e8b8099.95d1e30a.4bee.0501@mx.google.com>
	<CAATJ+fvs5OXBS9VREpZM=tY+z+n97Pf42uJFqLXbh58GVZ_reA@mail.gmail.com>
	<CAL9G6WWUv+jKY7LkcJMpwMTvV+A-fzwHYJNgpbAkOiQfPoj5ng@mail.gmail.com>
	<CAATJ+fu2W=o_xhsoghK1756ZGCw2g0W_95iYC8OX04AK8jAHLg@mail.gmail.com>
	<CAL9G6WXX2eGmoT+ozv1F0JQdSV5JPwbB0vn70UL+ghgkLGsYQg@mail.gmail.com>
	<kQmOmyBaqgjOFweZ@echelon.upsilon.org.uk>
	<CAL9G6WXb9zkgu++__LzW4nBBoAQYBvWWNCJkm_nRqiJEg+VE1A@mail.gmail.com>
Date: Fri, 7 Oct 2011 09:34:31 +1100
Message-ID: <CAATJ+fuBSrnB5wAh=RrjRx53uYwhmZP5joTS-soZy0NnbB5oVg@mail.gmail.com>
Subject: Re: [PATCH] af9013 frontend tuner bus lock
From: Jason Hecker <jwhecker@gmail.com>
To: Josu Lazkano <josu.lazkano@gmail.com>
Cc: dave cunningham <ml@upsilon.org.uk>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Thanks Dave, I have a MCP79 nvidia USB controller:

I too have:

USB Controller: nVidia Corporation MCP78S [GeForce 8200] EHCI USB 2.0
Controller (rev a1)

BUT I have never had boot trouble if I plugged in a 4-port hub.

I think Dave means that you need to buy a USB to PCI or PCIe card.
Avoid VIA if you can and try to get an NEC or Intel based card.

> not change the system board. Need I some extra configuration on BIOS?

Do you have the latest BIOS installed?  Try that and reset to safe
defaults.  I think AMI Bios (if you have it) has hidden performance
menus if you type in CTRL-F1 or SHIFT-F1 in the BIOS menu.

My Afatech dual tuners are the Leadtek DS2000
(http://www.linuxtv.org/wiki/index.php/Leadtek_WinFast_DTV2000DS)
which are on a PCI card.  They have the same USB tuner parts you have
plus a VIA USB->PCI bus chip.

My next step is to once again try the PID filter and maybe disable USB
sleeping/powerdown.

Someone on another mailing list is having similar problems in
Windows(!) and found the errors were minimal if PCI latency was set to
96.

I am beginning to think Afatech is just crappy.

Jason
