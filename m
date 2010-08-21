Return-path: <mchehab@pedra>
Received: from mailout07.t-online.de ([194.25.134.83]:36497 "EHLO
	mailout07.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451Ab0HUSBW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Aug 2010 14:01:22 -0400
Date: Sat, 21 Aug 2010 20:01:16 +0200
From: Halim Sahin <halim.sahin@t-online.de>
To: linux-media@vger.kernel.org
Subject: tda8261: produces unnecessary big debug logs
Message-ID: <20100821180116.GA2627@gentoo.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hi Folks,
/var/log/warn growed to several mb in two days.
Most of the contents is the output of tda8261.


Aug 21 19:52:10 vdr kernel: [181504.252173] tda8261_get_frequency:
Frequency=2033000
Aug 21 19:51:49 vdr kernel: [181483.256031] tda8261_get_bandwidth:
Bandwidth=40000000
.....
After every channelswitch the module logs something like that.

I tried to add verbose=0 but this didn't help.
What can I do to reduce these messages.
Regards
halim

