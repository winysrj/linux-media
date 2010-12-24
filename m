Return-path: <mchehab@gaivota>
Received: from smtp13.mail.ru ([94.100.176.90]:59774 "EHLO smtp13.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752813Ab0LXTVv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Dec 2010 14:21:51 -0500
Received: from [78.36.181.16] (port=57115 helo=localhost.localdomain)
	by smtp13.mail.ru with asmtp
	id 1PWDD3-0007ta-00
	for linux-media@vger.kernel.org; Fri, 24 Dec 2010 22:21:50 +0300
Date: Fri, 24 Dec 2010 22:28:45 +0300
From: Goga777 <goga777@bk.ru>
To: linux-media@vger.kernel.org
Subject: Re: [PATCH] cx88-dvb.c: DVB net latency using Hauppauge HVR4000
Message-ID: <20101224222845.47edf47d@bk.ru>
In-Reply-To: <4D14325E.9000505@sfc.wide.ad.jp>
References: <4D14325E.9000505@sfc.wide.ad.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

will your patch useful for dvb sat tv ?

>      We are from School On Internet Asia (SOI Asia) project that uses satellite communication to deliver
> educational content. We used Hauppauge HVR 4000 to carry IP traffic over ULE. However, there is an issue
> with high latency jitter. My boss, Husni, identified the problem and provided a patch for this problem.
> We have tested this patch since kernel 2.6.30 on our partner sites and it hasn't cause any issue. The
> default buffer size of 32 TS frames on cx88 causes the high latency, so our deployment changes that to 6
> TS frames. This patch made the buffer size tunable, while keeping the default buffer size of 32 TS
> frames unchanged. Sorry, I have to use attachment for the patch. I couldn't figure out how to copy and
> paste the patch without converting the tab to spaces in thunderbird.
