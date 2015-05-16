Return-path: <linux-media-owner@vger.kernel.org>
Received: from pide.tip.net.au ([101.0.96.218]:41334 "EHLO pide.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751330AbbEPGrh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 16 May 2015 02:47:37 -0400
Received: from e4.eyal.emu.id.au (124-171-106-187.dyn.iinet.net.au [124.171.106.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by pide.tip.net.au (Postfix) with ESMTPSA id 2E7BA127407
	for <linux-media@vger.kernel.org>; Sat, 16 May 2015 16:37:47 +1000 (AEST)
Message-ID: <5556E5BB.5070009@eyal.emu.id.au>
Date: Sat, 16 May 2015 16:37:47 +1000
From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: rtl28xx Leadtek
References: <20150516032301.GA41435@shambles.windy>
In-Reply-To: <20150516032301.GA41435@shambles.windy>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 16/05/15 13:23, Vincent McIntyre wrote:
> Hi,
>
> I have been trying to get support going for a
> Leadtek WinFast DTV2000DS Plus (usbid 0413:6f12)

In case it matters here, I have these cards and am using the driver
built from
	git clone git://linuxtv.org/media_build.git
	git clone git@github.com:jaredquinn/DVB-Realtek-RTL2832U.git

I get rather reliable tuning with hardly any of the old problems of
zero length recordings of fails to tune  some channels.

I run old fedora 19 though, and things may have deteriorated since?
Last time I needed to build was Jan 31 for kernel 3.14.27-100.fc19.x86_64.
Is this driver included with the kernel these days?

cheers
	Eyal

> Christian Dale (cc:d) posted a patch a while ago
> and since that time there have been a few patches
> from Olle and others that have significantly improved things.
>
> However I am still having issues with the card;
> sometimes it does not scan any of the multiplexes
> I look at with it, sometimes it does some of them
> and sometimes it pulls out some program ids on one
> mulitplex but not the others in the scan.
> The behaviour is different between the two tuners
> on the card as well.
>
> I've written a test script that turns on various
> kernel dynamic debug entries and tries to scan,
> using the old dvb-apps 'scan' (1.1.1+rev1500)
> and the latest dvbv5-scan from git.
>
> Would anyone on the list interested in helping
> please take a look at the attached logs of the
> run I did? It includes the script output and
> what was happening in syslog at each step.
>
> There should be no signal issues, as the same
> test script on the same system with the same
> coax input works perfectly when I swap the Leadtek
> for a DVICO card using the cx23885 driver.
> Both drivers are built from the media_build git.
>
> My questions:
>   - are there debug items that could be turned on or off
>     to help diagnose the issues?
>   - are there some perf traces that could be run that
>     would be helpful?
>
> Kind regards
> Vince

-- 
Eyal Lebedinsky (eyal@eyal.emu.id.au)
