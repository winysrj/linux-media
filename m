Return-path: <mchehab@pedra>
Received: from cmsout02.mbox.net ([165.212.64.32]:60802 "EHLO
	cmsout02.mbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087Ab1DELAS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Apr 2011 07:00:18 -0400
Received: from cmsout02.mbox.net (co02-lo [127.0.0.1])
	by cmsout02.mbox.net (Postfix) with ESMTP id 6B7F21342E3
	for <linux-media@vger.kernel.org>; Tue,  5 Apr 2011 11:00:18 +0000 (GMT)
Date: Tue, 05 Apr 2011 13:00:14 +0200
From: "Issa Gorissen" <flop.m@usa.net>
To: <linux-media@vger.kernel.org>
Subject: TT-budget S2-3200 cannot tune on HB13E DVBS2 transponder
Mime-Version: 1.0
Message-ID: <632PDek8o1744S03.1302001214@web03.cms.usa.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

Eutelsat made a recent migration from DVB-S to DVB-S2 (since 31/3/2011) on two
transponders on HB13E

- HOT BIRD 6 13° Est TP 159 Freq 11,681 Ghz DVB-S2 FEC 3/4 27500 Msymb/s 0.2
Pilot off Polar H

- HOT BIRD 9 13° Est TP 99 Freq 12,692 Ghz DVB-S2 FEC 3/4 27500 Msymb/s 0.2
Pilot off Polar H


Before those changes, with my TT S2 3200, I was able to watch TV on those
transponders. Now, I cannot even tune on those transponders. I have tried with
scan-s2 and w_scan and the latest drivers from git. They both find the
transponders but cannot tune onto it.

Something noteworthy is that my other card, a DuoFlex S2 can tune fine on
those transponders.

My question is; can someone try this as well with a TT S2 3200 and post the
results ?

Thank you a lot,
--
Issa

