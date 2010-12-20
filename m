Return-path: <mchehab@gaivota>
Received: from alia.ip-minds.de ([84.201.38.2]:38568 "EHLO alia.ip-minds.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932905Ab0LTRyR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Dec 2010 12:54:17 -0500
Received: from localhost (pD9E1B901.dip.t-dialin.net [217.225.185.1])
	by alia.ip-minds.de (Postfix) with ESMTPA id 5DDD71BE8973
	for <linux-media@vger.kernel.org>; Mon, 20 Dec 2010 18:54:52 +0100 (CET)
Date: Mon, 20 Dec 2010 18:54:14 +0100
From: Jean-Michel Bruenn <jean.bruenn@ip-minds.de>
To: linux-media@vger.kernel.org
Subject: Re: General Question regarding SNR
Message-Id: <20101220185414.060ae70b.jean.bruenn@ip-minds.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hello,

"crope" on #linuxtv irc helped me to understand the stuff in my
previous mail. So for other people who might want to understand that
also:

dvbsnoop reports snr without lock/antenna:

	If there is no Lock, unc, ber and snr _aren't_ valid. So check
	first whether you have a lock, if yes okay, if no ignore those
	values.

215 db SNR makes no sense:

	<crope> wdp: but most newer drivers report SNR as dB x 10

	0144 -> 324 -> 32,4 dB

... :-)
Jean
