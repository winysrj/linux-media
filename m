Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:51505 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758058AbZIOU1q (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Sep 2009 16:27:46 -0400
Received: from list by lo.gmane.org with local (Exim 4.50)
	id 1Mnecu-0004EF-P7
	for linux-media@vger.kernel.org; Tue, 15 Sep 2009 22:27:48 +0200
Received: from host-78-14-97-22.cust-adsl.tiscali.it ([78.14.97.22])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 15 Sep 2009 22:27:48 +0200
Received: from avljawrowski by host-78-14-97-22.cust-adsl.tiscali.it with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 15 Sep 2009 22:27:48 +0200
To: linux-media@vger.kernel.org
From: Avl Jawrowski <avljawrowski@gmail.com>
Subject: Re: Problems with Pinnacle 310i (saa7134) and recent kernels
Date: Tue, 15 Sep 2009 20:27:34 +0000 (UTC)
Message-ID: <loom.20090915T215753-102@post.gmane.org>
References: <loom.20090718T135733-267@post.gmane.org>  <1248033581.3667.40.camel@pc07.localdom.local>  <loom.20090720T224156-477@post.gmane.org>  <1248146456.3239.6.camel@pc07.localdom.local>  <loom.20090722T123703-889@post.gmane.org>  <1248338430.3206.34.camel@pc07.localdom.local>  <loom.20090910T234610-403@post.gmane.org>  <1252630820.3321.14.camel@pc07.localdom.local>  <loom.20090912T211959-273@post.gmane.org>  <1252815178.3259.39.camel@pc07.localdom.local>  <loom.20090913T115105-855@post.gmane.org>  <1252881736.4318.48.camel@pc07.localdom.local>  <loom.20090914T150511-456@post.gmane.org> <1252968793.3250.23.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

hermann pitton <hermann-pitton <at> arcor.de> writes:

> mplayer works on all my cards including the 310i for DVB-T and DVB-S
> since years. Guess you miss something or have a broken checkout.

I've just compiled another checkout, but it's the same.
With some channels I can see even something like this:

TS file format detected.
dvb_streaming_read, attempt N. 6 failed with errno 0 when reading 816 bytes
dvb_streaming_read, attempt N. 6 failed with errno 0 when reading 1736 bytes
dvb_streaming_read, attempt N. 6 failed with errno 0 when reading 1148 bytes

or like this:

dvb_streaming_read, attempt N. 6 failed with errno 0 when reading 2048 bytes
dvb_streaming_read, attempt N. 5 failed with errno 0 when reading 2048 bytes
dvb_streaming_read, attempt N. 4 failed with errno 0 when reading 2048 bytes
dvb_streaming_read, attempt N. 3 failed with errno 0 when reading 2048 bytes
dvb_streaming_read, attempt N. 2 failed with errno 0 when reading 2048 bytes
dvb_streaming_read, attempt N. 1 failed with errno 0 when reading 2048 bytes
dvb_streaming_read, return 0 bytes

But I can't see any video.
With Kaffeine I can see the same channels as well.

> Best is to add them to the wiki, else upload somewhere else or post off
> list.

Then I'm going to sign me up to the wiki.
Do you think it's better to create a "Pinnacle PCTV Hybrid Pro PCI" page or to
add the photos to the 310i page?

> > saa7133[0]: i2c xfer: < 8e ERROR: NO_DEVICE
> 
> Here is the problem. The supported cards do have the i2c chip at 0x47 or
> 0x8e in 8bit notation. Needs closer investigation.

If can be useful, I can attach the entire log.

> Cheers,
> Hermann

Thank you!

