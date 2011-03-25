Return-path: <mchehab@pedra>
Received: from mailrelay1.uni-rostock.de ([139.30.8.201]:19048 "EHLO
	mailrelay1.uni-rostock.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753861Ab1CYPGi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Mar 2011 11:06:38 -0400
Message-ID: <4D8CAE2C.2030301@uni-rostock.de>
Date: Fri, 25 Mar 2011 16:01:00 +0100
From: Paul Franke <paul.franke@uni-rostock.de>
MIME-Version: 1.0
To: <linux-media@vger.kernel.org>
Subject: Re: S2-3200 switching-timeouts on 2.6.38
Content-Type: text/plain; charset="ISO-8859-15"; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi list,

Follow up to: [1]

I did testing with a TechniSat SkyStar HD 2 (1ae4:0003).

- without a patch: card unuseable, gets locks only rarely
- with Manu's patch: card useable, gets locks, but sometimes this still 
needs some seconds
- with the mentioned stb0899 patch: card useable, gets locks, most time 
or nearly always fast (and faster as with Manu's patch)

In practice the stb0899 patch does a better job for zap frenzies, so I 
kindly ask to include this patch.

Thanks and best regards

Paul

[1] http://www.spinics.net/lists/linux-media/msg30537.html
