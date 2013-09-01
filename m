Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:61473 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751772Ab3IAFf1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 1 Sep 2013 01:35:27 -0400
Received: from [192.168.1.3] ([84.26.254.29]) by mail.gmx.com (mrgmx001) with
 ESMTPSA (Nemesis) id 0MXI5V-1VUX4D0vZN-00WEsK for
 <linux-media@vger.kernel.org>; Sun, 01 Sep 2013 07:35:24 +0200
Message-ID: <5222D21D.3020506@gmx.net>
Date: Sun, 01 Sep 2013 07:35:25 +0200
From: "P. van Gaans" <w3ird_n3rd@gmx.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: em28xx disabled when compiling on Debian wheezy?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I don't quite understand. When I follow instructions from 
http://linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_Device_Drivers 
I seem to have different results.

When I download/install the drivers on an Ubuntu 11.04 machine (it 
hasn't been updated in a while..) the em28xx driver is enabled in 
v4l/.config.

When I try the same on a Debian stable (wheezy, kernel 3.2.0-4-amd64) 
install, the em28xx driver gets outcommented and "not set" in 
v4l/.config. If I enable it anyway, the driver won't load and produce 
errors like "em28xx: Unknown symbol vb2_queue_init".

Seemingly em28xx is disabled for a reason, but why? I would think Debian 
wheezy is in every way better (and newer) than Ubuntu 11.04. Am I 
missing some package? How can I fix it?

Best regards,

P. van Gaans
