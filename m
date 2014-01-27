Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:65060 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753194AbaA0DUs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Jan 2014 22:20:48 -0500
Received: from minime.bse ([77.20.120.199]) by mail.gmx.com (mrgmx001) with
 ESMTPSA (Nemesis) id 0MMkDH-1WDOiH0j9z-008X9u for
 <linux-media@vger.kernel.org>; Mon, 27 Jan 2014 04:20:46 +0100
Date: Mon, 27 Jan 2014 04:20:44 +0100
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Robert Longbottom <rongblor@googlemail.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: Conexant PCI-8604PW 4 channel BNC Video capture card (bttv)
Message-ID: <20140127032044.GA27541@minime.bse>
References: <20140122115334.GA14710@minime.bse>
 <52DFC300.8010508@googlemail.com>
 <20140122135036.GA14871@minime.bse>
 <52E00AD0.2020402@googlemail.com>
 <20140123132741.GA15756@minime.bse>
 <52E1273F.90207@googlemail.com>
 <20140125152339.GA18168@minime.bse>
 <52E4EFBB.7070504@googlemail.com>
 <20140126125552.GA26918@minime.bse>
 <52E5366A.807@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52E5366A.807@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Jan 26, 2014 at 04:23:06PM +0000, Robert Longbottom wrote:
> 000 000000D7 DSTATUS
> 114 32734000 RISC_STRT_ADD
> 120 32734000 RISC_COUNT

Video is present and locked but the RISC counter is stuck at the start
address. My best guess is that the CPLD is not forwarding the REQ signal
to the PCI bridge, so the BT878A can't fetch the RISC instructions.
But then there is also this persistent ADC overflow...

As for the CPLD, there is not much we can do. I count 23 GPIOs going
to that chip. And we don't know if some of these are outputs of the
CPLD, making it a bit risky to just randomly drive values on those
pins.

If we had the original software, we could analyze what it is doing.
There is someone on ebay.com selling two of those cards and a cd
labled "Rescue Disk Version 1.14 for Linux DVR".

  Daniel
