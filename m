Return-path: <linux-media-owner@vger.kernel.org>
Received: from service1.sh.cvut.cz ([147.32.127.214]:45709 "EHLO
	service1.sh.cvut.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755400Ab0BFUPy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Feb 2010 15:15:54 -0500
From: =?utf-8?q?Luk=C3=A1=C5=A1_Karas?= <lukas.karas@centrum.cz>
To: erik.andren@gmail.com
Subject: New kernel failed suspend ro ram with m5602 camera
Date: Sat, 6 Feb 2010 20:54:55 +0100
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201002062055.02032.lukas.karas@centrum.cz>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Erik and others. 

New kernel (2.6.33-rc*) failed suspend to ram with camera m5602 on my machine. 
At first, I thought that it's a kernel bug (see 
http://bugzilla.kernel.org/show_bug.cgi?id=15189) - suspend failed after 
unload gspca_m5602 module too. But it is more probably a hardware bug, that we 
can evade with simple udev rule

ATTR{idVendor}=="0402", ATTR{idProduct}=="5602", ATTR{power/wakeup}="disabled"

I sent this rule to linux-hotplug (udev) mailing list, but answer is 
(http://www.spinics.net/lists/hotplug/msg03353.html) that this quirk should be 
in camera driver or should be send to udev from v4l developers...

What do you thing about it? It is a general m5602 chip problem or only my 
hardware combination problem? How we can put rule into udev userspace library? 
What I know, in v4l repository isn't directory with general v4l rules. This 
problem can affect many users with this hardware...

Best regards, 
Lukas
