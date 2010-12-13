Return-path: <mchehab@gaivota>
Received: from smtpout17.ngs.ru ([195.93.186.223]:56591 "EHLO smtpout17.ngs.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757797Ab0LMNwb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Dec 2010 08:52:31 -0500
Received: from smtpout.ngs.ru (imx2.in.ngs.ru [172.16.0.5])
	by smtpout17.ngs.ru (smtpout17.ngs.ru) with ESMTP id 454B071D8C42
	for <linux-media@vger.kernel.org>; Mon, 13 Dec 2010 19:37:25 +0600 (NOVT)
Received: from [192.168.12.34] (unknown [192.168.12.34])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: aptem@ngs.ru)
	by mail.ngs.ru (smtp) with ESMTP id 21CE1957CDA6F
	for <linux-media@vger.kernel.org>; Mon, 13 Dec 2010 19:46:42 +0600 (NOVT)
Message-ID: <4D062370.8070303@ngs.ru>
Date: Mon, 13 Dec 2010 19:45:20 +0600
From: Artem Bokhan <aptem@ngs.ru>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: problems with several saa7134 cards
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

  I use several (from three to five) saa7134-based cards on single PC. Currently 
I'm trying to migrate from 2.6.22 to 2.6.32 (ubuntu lts).

I've got problems which I did not have with 2.6.22 kernel:

1. Depending on configuration load average holds 1 or 2 when saa7134 module is 
loaded. The reason is kernel process "events/".

   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
    16 root      20   0     0    0    0 S    3  0.0   9:36.89 events/1
    15 root      20   0     0    0    0 D    3  0.0   9:35.81 events/0

2. Sound and video are not synced when recording with mencoder.


The same problem with 2.6.36 kernel except "events" process have different name 
(can't remember exact name, sorry)
