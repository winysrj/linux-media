Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:52742 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752074AbZCYBLI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Mar 2009 21:11:08 -0400
Subject: Re: The right way to interpret the content of SNR, signal strength
 and BER from HVR 4000 Lite
From: Andy Walls <awalls@radix.net>
To: Steven Toth <stoth@linuxtv.org>
Cc: Devin Heitmueller <devin.heitmueller@gmail.com>,
	linux-media@vger.kernel.org, Trent Piepho <xyzzy@speakeasy.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Ang Way Chuang <wcang@nav6.org>,
	VDR User <user.vdr@gmail.com>,
	Manu Abraham <abraham.manu@gmail.com>
In-Reply-To: <49C959C3.3060402@linuxtv.org>
References: <49B9BC93.8060906@nav6.org>
	 <Pine.LNX.4.58.0903131649380.28292@shell2.speakeasy.net>
	 <20090319101601.2eba0397@pedra.chehab.org>
	 <Pine.LNX.4.58.0903191229370.28292@shell2.speakeasy.net>
	 <Pine.LNX.4.58.0903191457580.28292@shell2.speakeasy.net>
	 <412bdbff0903191536n525a2facp5bc9637ebea88ff4@mail.gmail.com>
	 <49C2D4DB.6060509@gmail.com> <49C33DE7.1050906@gmail.com>
	 <1237689919.3298.179.camel@palomino.walls.org>
	 <412bdbff0903221800j2f9e1137u7776191e2e75d9d2@mail.gmail.com>
	 <412bdbff0903241439u472be49mbc2588abfc1d675d@mail.gmail.com>
	 <49C959C3.3060402@linuxtv.org>
Content-Type: text/plain
Date: Tue, 24 Mar 2009 21:12:09 -0400
Message-Id: <1237943529.4448.95.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2009-03-24 at 18:08 -0400, Steven Toth wrote:
> >> Let me ask this rhetorical question: if we did nothing more than just
> >> normalize the SNR to provide a consistent value in dB, and did nothing
> >> more than normalize the existing strength field to be 0-100%, leaving
> >> it up to the driver author to decide the actual heuristic, what
> >> percentage of user's needs would be fulfilled?
> 
> We don't need a new API and more complexity and/or code confusion, just 
> standardize on the unit values for the existing APIs.
> 
> 1) SNR in either units of db or units of .1 db (I don't care which, although I 
> prefer the later).

Devin,

ETSI TR 101 290 v1.2.1

can provide some guidance and information on conversion of measurement
quantities.  For example, as part of a conversion from Es/No to S/N,
Annex G, G.2 and G.3 tells you the right factor to use to convert from
No to N.

Here's where to go to download the document:
http://pda.etsi.org/pda/queryform.asp
(Free registration required.  Downloads of DVB docs are free.)

The list of DVB standards is here:
http://www.dvb.org/technology/standards/index.xml

Regards,
Andy

> 2) Strength as a percentage.
> 
> The approach Devin outlined above has my support.
> 
> - Steve
> 

