Return-path: <mchehab@pedra>
Received: from lo.gmane.org ([80.91.229.12]:43117 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753348Ab1CJQAK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Mar 2011 11:00:10 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1PxiHW-0005Pb-2E
	for linux-media@vger.kernel.org; Thu, 10 Mar 2011 17:00:06 +0100
Received: from 79-133-11-156.bredband.aland.net ([79.133.11.156])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 10 Mar 2011 17:00:06 +0100
Received: from dennis.kurten by 79-133-11-156.bredband.aland.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 10 Mar 2011 17:00:06 +0100
To: linux-media@vger.kernel.org
From: Dennis Kurten <dennis.kurten@gmail.com>
Subject: Re: Well supported USB DVB-C device?
Date: Thu, 10 Mar 2011 15:46:51 +0000 (UTC)
Message-ID: <loom.20110310T155515-682@post.gmane.org>
References: <201102280102.17852.malte.gell@gmx.de> <4D6AEC35.8000202@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Antti Palosaari <crope <at> iki.fi> writes:

> 
> Anysee E30 C Plus is supported as far as I know.
> 
> Note that new revision of Anysee E30 Combo Plus is no longer supported 
> since they changed to new NXP silicon tuner. E30 Combo Plus and E30 C 
> Plus are different devices.
> 

I might have some useful info on this, since I bought a recent 
Anysee E30 C earlier this week.

The unit does not seem to work out of the box (tested on three different 
kernels (2.6.32, 2.6.33 & 2.6.35). It registers as having a TDA10023 
frontend and also loads modules for zl10353 and mt352.

Tuning fails however and the device info indicates rev1.0 which means 
something might have changed. The funny thing is that in windows it shows 
up as a DVB-C/T device and you can tune to both cable and terrestrial!!

Could this mean that it is actually the same hardware as a Combo? 
I tried to check with a distributor and got a message that new devices 
could have the following components: DNOD44CDV086A, TDA18212.

I plan to return the unit unless somebody knows if there's any hope
of getting it to work with existing drivers.


