Return-path: <linux-media-owner@vger.kernel.org>
Received: from fep17.mx.upcmail.net ([62.179.121.37]:59622 "EHLO
	fep17.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071Ab2LVVZW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Dec 2012 16:25:22 -0500
Received: from edge04.upcmail.net ([192.168.13.239])
          by viefep17-int.chello.at
          (InterMail vM.8.01.05.05 201-2260-151-110-20120111) with ESMTP
          id <20121222212516.MOKL7658.viefep17-int.chello.at@edge04.upcmail.net>
          for <linux-media@vger.kernel.org>;
          Sat, 22 Dec 2012 22:25:16 +0100
Message-ID: <50D62544.5060708@hispeed.ch>
Date: Sat, 22 Dec 2012 22:25:24 +0100
From: Roland Scheidegger <rscheidegger_lists@hispeed.ch>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: terratec h5 rev. 3?
References: <50D3F5A8.5010903@hispeed.ch>
In-Reply-To: <50D3F5A8.5010903@hispeed.ch>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 21.12.2012 06:38, schrieb linux-media-owner@vger.kernel.org:
> Hi,
> 
> I've recently got a terratec h5 for dvb-c and thought it would be
> supported but it looks like it's a newer revision not recognized by em28xx.
> After using the new_id hack it gets recognized and using various htc
> cards (notably h5 or cinergy htc stick, cards 79 and 82 respectively) it
> seems to _nearly_ work but not quite (I was using h5 firmware for the
> older version). Tuning, channel scan works however tv (or dvb radio)
> does not, since it appears the error rate is going through the roof
> (with some imagination it is possible to see some parts of the picture
> sometimes and hear some audio pieces). femon tells something like this:

<snip>
Hmm actually it doesn't work any better at all with windows neither, so
I guess it doesn't like my cable signal (I do have another mantis-based
pci dvb-c card which works without issue). Maybe the tuner is just crappy.
So I guess it wouldn't hurt to simply add the usb id of this card
(0ccd:10b6) as another terratec h5 (this doesn't get you the IR but it's
a start I guess).
The dvb-t part though works without issue on windows, and I could not
get that to work in linux (I've used kaffeine and dvb-fe-tool to force
the dvbt delivery system if that's supposed to work). When scanning the
right frequency it spew out some error messages though:
DvbScanFilter::timerEvent: timeout while reading section; type = 0 pid = 0
kaffeine(7527) DvbScanFilter::timerEvent: timeout while reading section;
type = 2 pid = 17

Roland

