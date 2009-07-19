Return-path: <linux-media-owner@vger.kernel.org>
Received: from ozgw.promptu.com ([203.144.27.9]:4925 "EHLO
	surfers.oz.promptu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751995AbZGSXtT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Jul 2009 19:49:19 -0400
Received: from pacific.oz.agile.tv (pacific.oz.promptu.com [192.168.16.16])
	by surfers.oz.promptu.com (Postfix) with SMTP id 7292CA65E6
	for <linux-media@vger.kernel.org>; Mon, 20 Jul 2009 09:49:03 +1000 (EST)
Date: Mon, 20 Jul 2009 09:49:03 +1000
From: Bob Hepple <bhepple@promptu.com>
To: linux-media@vger.kernel.org
Subject: Re: DViCO FusionHDTV DVB-T Dual Digital 4 gives
 "bulk message failed"
Message-Id: <20090720094903.7a6a849c.bhepple@promptu.com>
In-Reply-To: <20090615113315.0fdfbe62.bhepple@promptu.com>
References: <20090615113315.0fdfbe62.bhepple@promptu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 15 Jun 2009 11:33:15 +1000
Bob Hepple <bhepple@promptu.com> wrote:

> To add another data-point, I am also getting this error with the same
> board ... as far as I have been able to test, it's something that was
> OK in 2.6.27, regressed in 2.6.28 and is still a problem in 2.6.30.
> 
> Note that this is the rev.1 DViCO
> 
> lsb_release -rd
> Description:    Ubuntu karmic (development branch)
> Release:        9.10
> 
> uname -a
> Linux nina 2.6.30-8-generic #9-Ubuntu SMP Wed Jun 3 15:23:55 UTC 2009 i686 GNU/Linux
> 
> I get spammed by this console message every 1 second and the board does not operate:
> [ 375.385180] dvb-usb: bulk message failed: -110 (4/0)
> 
> I see the same problem with mythbuntu-9.04 (2.6.28)
> 
> So I put in a new disc and installed Fedora-10 (2.6.27) with the same
> firmware: /lib/firmware/xc3028-v27.fw
> ... and it's working fine now.
> 

Slight update:

I tried again this past weekend with a fresh hg clone of v4l-dvb on
2.6.27 but had the same "bulk message failed" messages even after a
cold start (ie remove power cord).

Has anyone else seen/fixed this? Is it possible that the gold version
of these drivers need merging to the head?

I was able to revert to the default 2.6.27 drivers and it works again
although there is a remaining problems - mythtv isn't able to tune some
channels - particularly channel 7 here in Brisbane. 

scandvd and tzap run fine - although the channels.conf file needs a
hand-edit as documented in the livetv wiki for missing audio PIDs. 

I have been able to import the channels.conf file into mythtv and then
all is well there. Hope that helps someone else struggling with this!!

So I'm able to work with 2.6.27 fedora-10 kernel for now but fear for
the future of the driver ... and this will hit others trying to use this
popular card with more up-to-date kernels.


Thanks


Bob


-- 
Bob Hepple <bhepple@promptu.com>
ph: 07-5584-5908 Fx: 07-5575-9550
