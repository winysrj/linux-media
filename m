Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns1.tyldum.com ([91.189.178.231]:42934 "EHLO ns1.tyldum.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753453Ab1LMQ4I (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Dec 2011 11:56:08 -0500
Received: from tyldum.com (unknown [192.168.168.50])
	by ns1.tyldum.com (Postfix) with ESMTP
	for <linux-media@vger.kernel.org>; Tue, 13 Dec 2011 17:56:02 +0100 (CET)
Received: from [192.168.168.92] (unknown [192.168.168.92])
	by tyldum.com (Postfix) with ESMTP id 9B17428377
	for <linux-media@vger.kernel.org>; Tue, 13 Dec 2011 17:56:00 +0100 (CET)
Message-ID: <4EE7839A.6040507@tyldum.com>
Date: Tue, 13 Dec 2011 17:55:54 +0100
From: Vidar Tyldum <vidar@tyldum.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: Multiple Mantis devices gives me glitches
References: <4EE682B3.4090301@tyldum.com>
In-Reply-To: <4EE682B3.4090301@tyldum.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(sorry for breaking the threading, the reply came faster than my
subscription to the list :)

>From Ninja <Ninja15@xxxxxx>,
> Hi, I noticed some SMP problems with the mantis driver as well (see my
> post "Mantis CAM not SMP safe / Activating CAM on Technisat Skystar HD2
> (DVB-S2)"). One workaround for me is to limit the CPU to one core (to be
> sure disable the hyperthreading cores as well). That can be done via BIOS
> *or* adding maxcpus=1 as kernel parameter *or* you can disable the cores
> one by one via "|echo 0 > /sys/devices/system/cpu/cpuX/online|" where X
> is the core to disable. Since you need to be root for this, I did "sudo
> su" first. But of course our problems might be completely unrelated and
> limiting to one core won't change a thing ;)
> 
> Manuel

I doubt I'll revert back to the stock mantis module to test right now, but
your suggestion and observations might certainly be of interest. If/when
Ubuntu releases a new kernel which overwrites my current driver I will give
it a go.
However, instead of disabling SMP completely I hope adjusting IRQ affinity
could be sufficient:
  http://kernel.org/doc/Documentation/IRQ-affinity.txt

Couple this with increased PCI latency might work, however with three
devices connected I think the only solution is to reduce the number of
interrupts (though I am by no means any expert on this subject).

-- 
Vidar Tyldum
                              vidar@tyldum.com               PGP: 0x3110AA98
