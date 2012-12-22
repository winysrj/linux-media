Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17847 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752260Ab2LVXmw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Dec 2012 18:42:52 -0500
Date: Sat, 22 Dec 2012 21:42:24 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Roland Scheidegger <rscheidegger_lists@hispeed.ch>
Cc: linux-media@vger.kernel.org
Subject: Re: terratec h5 rev. 3?
Message-ID: <20121222214224.409ed60a@redhat.com>
In-Reply-To: <50D62544.5060708@hispeed.ch>
References: <50D3F5A8.5010903@hispeed.ch>
	<50D62544.5060708@hispeed.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 22 Dec 2012 22:25:24 +0100
Roland Scheidegger <rscheidegger_lists@hispeed.ch> escreveu:

> Am 21.12.2012 06:38, schrieb linux-media-owner@vger.kernel.org:
> > Hi,
> > 
> > I've recently got a terratec h5 for dvb-c and thought it would be
> > supported but it looks like it's a newer revision not recognized by em28xx.
> > After using the new_id hack it gets recognized and using various htc
> > cards (notably h5 or cinergy htc stick, cards 79 and 82 respectively) it
> > seems to _nearly_ work but not quite (I was using h5 firmware for the
> > older version). Tuning, channel scan works however tv (or dvb radio)
> > does not, since it appears the error rate is going through the roof
> > (with some imagination it is possible to see some parts of the picture
> > sometimes and hear some audio pieces). femon tells something like this:
> 
> <snip>
> Hmm actually it doesn't work any better at all with windows neither, so
> I guess it doesn't like my cable signal (I do have another mantis-based
> pci dvb-c card which works without issue). Maybe the tuner is just crappy.
> So I guess it wouldn't hurt to simply add the usb id of this card
> (0ccd:10b6) as another terratec h5 (this doesn't get you the IR but it's
> a start I guess).
> The dvb-t part though works without issue on windows, and I could not
> get that to work in linux (I've used kaffeine and dvb-fe-tool to force
> the dvbt delivery system if that's supposed to work). When scanning the
> right frequency it spew out some error messages though:
> DvbScanFilter::timerEvent: timeout while reading section; type = 0 pid = 0
> kaffeine(7527) DvbScanFilter::timerEvent: timeout while reading section;
> type = 2 pid = 17

If DVB-T is also not working, then I suspect that the device is different
than the previous revisions. There are two ways to connect the DRX-K with
em28xx: serial or parallel. Maybe you need to touch that.

The better would be to sniff the usb traffic using the tools at v4l-utils.git
and see what's happening there.
> 
> Roland
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 

Cheers,
Mauro
