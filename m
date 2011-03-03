Return-path: <mchehab@pedra>
Received: from jabba.london.02.net ([82.132.130.169]:40398 "EHLO mail.o2.co.uk"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758196Ab1CCRlE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Mar 2011 12:41:04 -0500
Date: Thu, 3 Mar 2011 17:40:55 +0000
From: Tony Houghton <h@realh.co.uk>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: <linux-media@vger.kernel.org>
Subject: Re: Hauppauge "grey" remote not working in recent kernels
Message-ID: <20110303174055.553a8791@realh.co.uk>
In-Reply-To: <CC82695C-F23E-4569-AAF8-091372D2FFE9@wilsonet.com>
References: <20110302181404.6406a3d2@realh.co.uk>
	<3A464BCE-1E30-48D3-B275-99815E1A8983@wilsonet.com>
	<20110302204610.464785f5@toddler>
	<CC82695C-F23E-4569-AAF8-091372D2FFE9@wilsonet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, 2 Mar 2011 17:30:29 -0500
Jarod Wilson <jarod@wilsonet.com> wrote:

> On Mar 2, 2011, at 3:46 PM, Tony Houghton wrote:
> 
> > On Wed, 2 Mar 2011 13:39:32 -0500
> > Jarod Wilson <jarod@wilsonet.com> wrote:
> > 
> >> There's a pending patchset for ir-kbd-i2c and the hauppauge key tables
> >> that should get you back in working order.
> > 
> > OK, thanks. Is it possible to download the patch(es) and apply it to a
> > current kernel or is that a bit complicated?
> 
> Not sure how doable it is, don't recall if they're dependent on other
> changes going into 2.6.38 or not. The patches are still in the
> linux-media patchwork db (I'm actually merging and testing them in my
> own tree tonight or tomorrow).
> 
> https://patchwork.kernel.org/project/linux-media/list/

Thanks. I think I'll have to leave it to the experts. I tried applying
all the patches from Mauro Carvalho Chehab's set of 13, using the guide
at <http://wiki.debian.org/HowToRebuildAnOfficialDebianKernelPackage>
but the guide is slightly out of date and I'm not sure if I even got the
patches applied. If they did apply they din't work :-(.

On top of that the patches won't apply to 2.6.37 and there doesn't seem
to be a way to build a linux-kbuild deb for pre-release kernels, so I
can't easily build an nvidia module and nouveau fails to get the correct
resolutions on the target system :-(.
