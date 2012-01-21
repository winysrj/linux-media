Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:37686 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345Ab2AUMzQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Jan 2012 07:55:16 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1RoaTT-0002qz-9c
	for linux-media@vger.kernel.org; Sat, 21 Jan 2012 13:55:15 +0100
Received: from 93-97-197-17.zone5.bethere.co.uk ([93.97.197.17])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sat, 21 Jan 2012 13:55:15 +0100
Received: from steve.myatt.2009 by 93-97-197-17.zone5.bethere.co.uk with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sat, 21 Jan 2012 13:55:15 +0100
To: linux-media@vger.kernel.org
From: Steve Myatt <steve.myatt.2009@gmail.com>
Subject: Re: No video0, /dev/dvb/adapter0 present
Date: Sat, 21 Jan 2012 12:38:42 +0000 (UTC)
Message-ID: <loom.20120121T132944-762@post.gmane.org>
References: <4BEE6B30.30303@ii.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Cliffe <cliffe <at> ii.net> writes:

> 
> Hello I would really appreciate some help.
> 
[...cropped...]
> [    9.079590] af9013: found a 'Afatech AF9013 DVB-T' in warm state.
> [    9.082319] af9013: firmware version:4.95.0
> [    9.094043] DVB: registering adapter 1 frontend 0 (Afatech AF9013 
> DVB-T)...
> [    9.094211] tda18271 1-00c0: creating new instance
> [    9.096393] af9015: command failed:2
> [    9.098032] tda18271_read_regs: [1-00c0|M] ERROR: i2c_transfer 
> returned: -1
> [    9.098046] Unknown device detected @ 1-00c0, device not supported.
> [    9.100368] af9015: command failed:2
[...cropped...]
> Thanks,
> 
> Cliffe.
> 
> 


Hi Cliffe

Have you checked to see if there's a different report after a completely cold
(power plug out) boot, compared to a warm reboot?

I'm chasing what appears to me to be a similar problem, different card, same
chips (by the look of it) and I found the same report in my syslog:

Unknown device detected @ 1-00c0, device not supported.

I see you haven't had any responses here; did you get any further with this?

Symptoms in my system: got a dual tuner card (PEAK 221544AGPK PCI) which,
following warm boot, doesn't see the second tuner. Suspect firmware not being
loaded due to warm state. I'm documenting this at

http://www.slm.dnsdojo.net/content/tech/myth/index.php#begin_peak.html

Cheers
Steve Myatt

