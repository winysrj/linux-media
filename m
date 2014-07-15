Return-path: <linux-media-owner@vger.kernel.org>
Received: from dd19416.kasserver.com ([85.13.139.185]:50154 "EHLO
	dd19416.kasserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758008AbaGOKFC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Jul 2014 06:05:02 -0400
Message-ID: <53C4FC99.9050308@herbrechtsmeier.net>
Date: Tue, 15 Jul 2014 12:04:09 +0200
From: Stefan Herbrechtsmeier <stefan@herbrechtsmeier.net>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Problems with the omap3isp
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

I have some problems with the omap3isp driver. At the moment I use a 
linux-stable 3.14.5 with your fixes for omap3xxx-clocks.dtsi.

1. If I change the clock rate to 24 MHz in my camera driver the whole 
system freeze at the clk_prepare_enable. The first enable and disable 
works without any problem. The system freeze during a systemd / udev 
call of media-ctl.

2. If I enable the streaming I get a  "omap3isp omap3isp: CCDC won't 
become idle!" and if I disable streaming I get a "omap3isp omap3isp: 
Unable to stop OMAP3 ISP CCDC". I think the problem is, that I can't 
disable the camera output. Do you change the order of the stream enable 
/ disable after Linux 3.4?

Kind regards,
   Stefan

