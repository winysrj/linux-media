Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:52924 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754747Ab0BGW5f (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 7 Feb 2010 17:57:35 -0500
Message-ID: <4B6F455D.1050203@gmx.net>
Date: Sun, 07 Feb 2010 23:57:33 +0100
From: "P. van Gaans" <w3ird_n3rd@gmx.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: saa7134 noise on composite input
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everyone,

My problem is actually quite similar and likely the same as 
http://www.spinics.net/lists/linux-media/msg11186.html ("Re: kworld 
studio terminator (saa7134) noise on capture").

I have an Asus My Cinema-P7131 Hybrid and am trying to use the composite 
input. I run something like:

mplayer -tv driver=v4l2:norm=pal:input=1:width=720:height=576 tv://

The first time running mplayer (or mencoder) after booting the system 
the picture is usually OK. The second time it is often noisy. At random 
the picture is sometimes OK again if I just retry a few times. Also, if 
I unplug the composite cable while mplayer is running and plug it back 
in, the picture gets fixed and the noise goes away.

My noise looks similar to the noise from asko. I also made a screencap 
from the menu of my DVB-box: 
http://www.glowfoto.com/viewimage.php?y=2010&m=02&img=07-144928L&t=jpg&rand=8718&srv=img6

Top shows noisy image, bottom after replugging the composite cable. 
TVtime doesn't seem to suffer, so TVtime might init the card differently 
somehow?

I hope someone has a clue.

P. van  Gaans
