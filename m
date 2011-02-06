Return-path: <mchehab@pedra>
Received: from cain.gsoft.com.au ([203.31.81.10]:44353 "EHLO cain.gsoft.com.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752002Ab1BFXPO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Feb 2011 18:15:14 -0500
Subject: Re: Tuning channels with DViCO FusionHDTV7 Dual Express
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
From: "Daniel O'Connor" <darius@dons.net.au>
In-Reply-To: <AANLkTin8Rjch6o7aU-9S9m8f5aBYVeSwxSaVhyEfM5q9@mail.gmail.com>
Date: Mon, 7 Feb 2011 09:44:37 +1030
Cc: v4l-dvb Mailing List <linux-media@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <13C07B8A-BF22-4863-8C91-590F8683B5E1@dons.net.au>
References: <AANLkTin8Rjch6o7aU-9S9m8f5aBYVeSwxSaVhyEfM5q9@mail.gmail.com>
To: Dave Johansen <davejohansen@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


On 07/02/2011, at 9:16, Dave Johansen wrote:
> Here's the output from scan:
> 
> scan /usr/share/dvb/atsc/us-ATSC-
> center-frequencies-8VSB
> scanning us-ATSC-center-frequencies-8VSB
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
>>>> tune to: 189028615:8VSB
> WARNING: filter timeout pid 0x0000
> WARNING: filter timeout pid 0x1ffb
> 
> Any ideas/suggestions on how I can get this to work?

You could try the latest DVB drivers, although on my DViCo (which looks like the DVB-T version of yours) they aren't any better.

However the drivers in Ubuntu at least work for 1 tuner, if I try and use both in mythtv one tends to lock up after a while :-/

--
Daniel O'Connor software and network engineer
for Genesis Software - http://www.gsoft.com.au
"The nice thing about standards is that there
are so many of them to choose from."
  -- Andrew Tanenbaum
GPG Fingerprint - 5596 B766 97C0 0E94 4347 295E E593 DC20 7B3F CE8C






