Return-path: <mchehab@pedra>
Received: from lo.gmane.org ([80.91.229.12]:47411 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754050Ab0JRRZP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Oct 2010 13:25:15 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1P7tSL-0000cA-Pb
	for linux-media@vger.kernel.org; Mon, 18 Oct 2010 19:25:05 +0200
Received: from 69.red-80-32-146.staticip.rima-tde.net ([80.32.146.69])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 18 Oct 2010 19:25:05 +0200
Received: from javier by 69.red-80-32-146.staticip.rima-tde.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 18 Oct 2010 19:25:05 +0200
To: linux-media@vger.kernel.org
From: "Javier S. Pedro" <javier@javispedro.com>
Subject: A16D (XC3028) FM radio regression -- constant 2.75Mhz offset
Date: Mon, 18 Oct 2010 17:07:27 +0000 (UTC)
Message-ID: <i9husf$77l$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

Since upgrading to a 2.6.35 kernel I've found out that all FM radio 
stations have been offset by 2.75Mhz . Card is AVERMEDIA A16D, using 
XC3028 tuner (firmware v27). 

I've bisected the issue to commit:
7f2199c03b4946f1b79514b3411e3dbf130a6bba
V4L/DVB: tuner-xc2028: fix tuning logic to solve a regression in Australia

Seems that the code is not properly handling anything other than 
T_ANALOG_TV, T_DIGITAL_TV. Thus, when new_mode is T_RADIO, it blindly 
offsets freq by 2.75Mhz assuming it's DTV8 or DTV78. I'm worried why 
nobody has complained yet about this, though.

Javier.

