Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43352 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751275Ab3JWRAF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Oct 2013 13:00:05 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1VZ1mt-0005ud-3D
	for linux-media@vger.kernel.org; Wed, 23 Oct 2013 19:00:03 +0200
Received: from static-031-187-124-092.ewe-ip-backbone.de ([31.187.124.92])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 23 Oct 2013 19:00:03 +0200
Received: from linux by static-031-187-124-092.ewe-ip-backbone.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 23 Oct 2013 19:00:03 +0200
To: linux-media@vger.kernel.org
From: Christoph Schwerdtfeger <linux@baka0815.de>
Subject: Re: Hauppauge HVR-4400
Date: Wed, 23 Oct 2013 16:58:14 +0000 (UTC)
Message-ID: <loom.20131023T184229-891@post.gmane.org>
References: <201005041400.10530.jan_moebius@web.de> <z2q829197381005040636vbd2d7254n4674dcc21cc751f4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Devin Heitmueller <dheitmueller <at> kernellabs.com> writes:

> 
> On Tue, May 4, 2010 at 8:00 AM, Jan Möbius <jan_moebius <at> web.de> wrote:
> > Hi,
> >
> > im trying to get a Hauppauge HVR-4400 working on a Debian squeeze. It
seems to
> > be unsopported yet. Is there any driver which i don't know about?
> 
> There is no support currently for that card, and since it uses a
> demodulator for which there is not currently a driver, much more work
> will be required than simply adding a new board profile.
> 
> Devin
> 

Well, DVB-S/S2 seems to be finally supported using a current kernel (3.11).

I get the following files under /dev/dvb/adapter0:

demux0
dvr0
frontend0
net0

w_scan also works (as described here[1]).

But the card has multiple tuners (DVB-T/C and analogue as well) which are
not recognized.

Is there any information I can give you to help support this card?

I have little experience in C but no experience in programming hardware, but
am willing to help in anyway needed.

Kind regards
Christoph

[1] http://www.linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR-4400

