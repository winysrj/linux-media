Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns1.tyldum.com ([91.189.178.231]:33259 "EHLO ns1.tyldum.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756259Ab1LNSXx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Dec 2011 13:23:53 -0500
Message-ID: <4EE8E9AD.30002@tyldum.com>
Date: Wed, 14 Dec 2011 19:23:41 +0100
From: Vidar Tyldum <vidar@tyldum.com>
MIME-Version: 1.0
To: Marko Ristola <marko.ristola@kolumbus.fi>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Multiple Mantis devices gives me glitches
References: <4EE6FF6F.5050901@kolumbus.fi> <4EE79543.2080802@tyldum.com> <4EE7CA0C.200@kolumbus.fi>
In-Reply-To: <4EE7CA0C.200@kolumbus.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

13.12.2011 22:56, Marko Ristola:
> Here is another patch that I wrote for my DVB HDTV network delivery glitches
> problem.
> It might help you a bit also:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commit;h=38e009aac9e02d2c30fd9a5e979ab31433e7d578

I started seeing glitches again after a day, so I decided to give this a go.
With 'perf top' I see that the activity dvb_dmxdev_init was somewhat
reduced, but I still have some glitches.

perf top:
615.00 16.4% dvb_dmxdev_init

380 irqs/sec  kernel:49.5%

> That patch doesn't guarantee glitch free data delivery either.
> Next question is, which buffer overruns now? Mantis 64K DMA buffer?
> DVB-CORE's 128K buffer?
> VDR reads from DVB-CORE's 128K buffer.

I'll keep these two patches running for a while and see how it goes. Things
are definately better, but eventually I get glitches.
I am unable to locate anything else on the system causing load, but of
course, that does not mean there isn't any.

Thanks for the help. I'm always open for testing new patches. Sadly I am not
capable of diving into the code to help.

-- 
Vidar Tyldum
                              vidar@tyldum.com               PGP: 0x3110AA98
