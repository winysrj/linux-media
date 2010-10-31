Return-path: <mchehab@gaivota>
Received: from mout.perfora.net ([74.208.4.195]:58097 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756486Ab0JaRw1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 31 Oct 2010 13:52:27 -0400
Date: Sun, 31 Oct 2010 13:47:21 -0400
From: Kevin Foss <kevin@fppcs.com>
Subject: Success on Analog signal: Yuan MPC788
To: linux-media@vger.kernel.org
Message-Id: <1288547241.11724.1@work2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

I thought I would report the success on had on the Yuan MPC788 Mini-PCI 
card.

I can only verify the analog signal as it is a DVB-T digital card and 
I'm in Canada, so no signal to check it against, though kaffeine sees 
it clearly and does scan for channels although it doesn't find 
anything.

As for the drivers, it is correctly detected against the cx88xx module, 
however I had to use the "options cx88xx card=81" in the "/etc/
modprobe.d/video4linux" file.  This along with using the 
"xc3028_v27.fw" file, I have the analog NTSC working perfectly.

This card has the same components as the Leadtek Winfast DTV1800 card.

Hope this helps others.

Kevin Foss
Ottawa, Canada

