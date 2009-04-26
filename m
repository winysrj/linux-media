Return-path: <linux-media-owner@vger.kernel.org>
Received: from woodbine.london.02.net ([87.194.255.145]:46402 "EHLO
	woodbine.london.02.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbZDZVER (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Apr 2009 17:04:17 -0400
Received: from [192.168.0.6] (78.86.110.75) by woodbine.london.02.net (8.5.016.1)
        id 49D39EA9012ED54E for linux-media@vger.kernel.org; Sun, 26 Apr 2009 21:58:05 +0100
Message-ID: <49F4CADD.7040001@archifishal.co.uk>
Date: Sun, 26 Apr 2009 21:58:05 +0100
From: Alex Macfarlane Smith <nospam@archifishal.co.uk>
Reply-To: alex@archifishal.co.uk
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: dib0700: Any known issues with CPU usage?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I've been wondering about this for a while, and am reasonably convinced 
there may be a problem in the linuxtv version of the dib0700 (or one of 
its submodules).

I've got a Hauppauge WinTV-NOVA-TD-500 (84xxx) PCI card 
(http://www.linuxtv.org/wiki/index.php/Hauppauge_WinTV-NOVA-T-500 - 
which seems to have been hacked incidentally).

Today I installed a 2.6.29.1 kernel with the dib0700 module etc. 
installed (and it all works fine, barring the remote control), which 
shows in top:

top - 21:25:03 up  4:06,  2 users,  load average: 0.00, 0.00, 0.00
Tasks: 144 total,   1 running, 143 sleeping,   0 stopped,   0 zombie


However, if I do nothing else except install the latest linuxtv drivers 
from mercurial and then reboot:

top - 21:54:45 up 30 min,  3 users,  load average: 0.50, 0.53, 0.43
Tasks: 147 total,   1 running, 146 sleeping,   0 stopped,   0 zombie


You can see the load average is significantly higher. (and if I forcibly 
remove the module, the load average will eventually drop to 0)

The only user-facing difference I'm aware of is that the linuxtv version 
supports the remote control, whereas the kernel version doesn't - would 
this cause a big jump in CPU usage, or is there something else going on 
here?

If there's any more info needed to get to the bottom of this, don't 
hesitate to ask :)

Thanks for your help,

Alex.
