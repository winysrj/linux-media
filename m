Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:33911 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764342AbZAULfq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Jan 2009 06:35:46 -0500
Message-ID: <4977088F.5080505@iki.fi>
Date: Wed, 21 Jan 2009 13:35:43 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] getting started with msi tv card
References: <20090120091952.GB6792@debian-hp.lan> <4975B5F1.7000306@iki.fi>	<20090120220701.GB4150@debian-hp.lan> <49765448.8060108@iki.fi> <20090121003915.GA6120@debian-hp.lan>
In-Reply-To: <20090121003915.GA6120@debian-hp.lan>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Daniel Dalton wrote:
> On Wed, Jan 21, 2009 at 12:46:32AM +0200, Antti Palosaari wrote:
>> Yes, should work out of the box. No need to install any driver, driver 
>> is included in your Kernel.
> 
> /dev/dvb/adapter0/ is created. so does this mean the right modules have
> been loaded?

Yes, drivers and firmware loaded. It should be all functional.

> I've been googling, and have played with w_scan and me-tv.
> Kaffeine unfortunately is qt and won't work with braille/speech, but
> me-tv does. So I got sighted help to scan for channels in kaffeine, the
> scan didn't find any channels.
> Next, I ran the w_scan program, and that as well failed to find any
> channels. Finally, I ran me-tv and that as well failed. (I selected my
> location for me-tv).
> 
> So, how do I get w_scan or me-tv to find some channels? It's probably
> not worth talking about kaffeine as I won't be able to use this. I'm
> plugging my usb receiver into a tv connection in my home which a
> standard tv would plug into.
> 
> Any ideas?

I think the problem is poor QT1010 tuning performance. You cannot do 
much for that now. I recommended to get other stick.

regards
Antti
