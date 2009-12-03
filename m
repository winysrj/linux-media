Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f182.google.com ([209.85.211.182]:36638 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857AbZLCWMe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Dec 2009 17:12:34 -0500
Date: Thu, 3 Dec 2009 14:12:31 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Christoph Bartelmus <lirc@bartelmus.de>
Cc: mchehab@redhat.com, awalls@radix.net, j@jannau.net,
	jarod@redhat.com, jarod@wilsonet.com, jonsmirl@gmail.com,
	khc@pm.waw.pl, kraxel@redhat.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
	IR  system?
Message-ID: <20091203221231.GE776@core.coreip.homeip.net>
References: <4B18292C.6070303@redhat.com> <BEBfoS11qgB@lirc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BEBfoS11qgB@lirc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Dec 03, 2009 at 10:51:00PM +0100, Christoph Bartelmus wrote:
> Hi Mauro,
> 
> on 03 Dec 09 at 19:10, Mauro Carvalho Chehab wrote:
> [...]
> >>> So the lirc_imon I submitted supports all device types, with the
> >>> onboard decode devices defaulting to operating as pure input devices,
> >>> but an option to pass hex values out via the lirc interface (which is
> >>> how they've historically been used -- the pure input stuff I hacked
> >>> together just a few weeks ago), to prevent functional setups from
> >>> being broken for those who prefer the lirc way.
> >>
> >> Hmm.  I'd tend to limit the lirc interface to the 'raw samples' case.
> 
> >> Historically it has also been used to pass decoded data (i.e. rc5) from
> >> devices with onboard decoding, but for that in-kernel mapping + input
> >> layer really fits better.
> 
> > I agree.
> 
> Consider passing the decoded data through lirc_dev.
> - there's a large user base already that uses this mode through lirc and  
> would be forced to switch to input layer if it disappears.

I believe it was agreed that lirc-dev should be used mainly for decoding
protocols that are more conveniently decoded in userspace and the
results would be looped back into input layer through evdev which will
be the main interface for consumer applications to use.

-- 
Dmitry
