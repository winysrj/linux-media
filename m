Return-path: <linux-media-owner@vger.kernel.org>
Received: from cnc.isely.net ([64.81.146.143]:45905 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756673Ab0GDCyg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 3 Jul 2010 22:54:36 -0400
Date: Sat, 3 Jul 2010 21:54:35 -0500 (CDT)
From: Mike Isely <isely@isely.net>
To: Douglas Schilling Landgraf <dougsland@redhat.com>
cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Julia Lawall <julia@diku.dk>, Mike Isely <isely@isely.net>
Subject: Re: [git:v4l-dvb/other] V4L/DVB: drivers/media/video/pvrusb2: Add
 missing mutex_unlock
In-Reply-To: <4C2FC0B6.9040407@redhat.com>
Message-ID: <alpine.DEB.1.10.1007032150240.25068@cnc.isely.net>
References: <E1OV9yX-0006Dg-H2@www.linuxtv.org> <alpine.DEB.1.10.1007031733360.19299@cnc.isely.net> <4C2FC0B6.9040407@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 3 Jul 2010, Douglas Schilling Landgraf wrote:

> Hello Mike,
> 
> Mike Isely wrote:
> > Mauro:
> > 
> > FYI, I posted an "Acked-By: Mike Isely <isely@pobox.com>" weeks ago, back on
> > 27-May, immediately after the patch was posted.  It's a great catch, and the
> > bug has been there since basically the beginning of the driver.  Was I ever
> > supposed to see any kind of reaction to that ack (e.g. having the "Acked-By"
> > added to the patch)?  I had posted it in reply to the original patch, copied
> > back to the patch author, to lkml, to linux-media, kernel-janitors, and
> > Mauro.
> > 
> >   -Mike
> 
> It seems my mistake since I have added CC instead of Acked-by, sorry.
> This happened because usually I add CC to the authors of drivers when I took
> patches from patchwork and I wanna notify them. In your case, I missed the
> acked-by.
> 
> Mauro, if possible, could you please replace CC to the correct Acked-by before
> submit this patch to Linus?
> 

Hmm, going through my old e-mail now I can see that the patch was picked 
up for -mm on 1-Jun.  At that time I was marked as a CC: for the patch - 
which I'd expect as the driver maintainer.  But no Acked-By: was 
showing.  Maybe that's when the ack got missed.

Obviously I have no issue with this patch.  My only real concern is that 
nobody thinks I might have been ignoring it.  Thanks for following up.

  -Mike


-- 

Mike Isely
isely @ isely (dot) net
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
