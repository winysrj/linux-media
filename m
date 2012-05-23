Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:35333 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756128Ab2EXBuJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 23 May 2012 21:50:09 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1SXNBm-00051u-Rq
	for linux-media@vger.kernel.org; Thu, 24 May 2012 03:50:07 +0200
Received: from rrcs-70-63-158-198.midsouth.biz.rr.com ([70.63.158.198])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 24 May 2012 03:50:06 +0200
Received: from bmullan.mail by rrcs-70-63-158-198.midsouth.biz.rr.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 24 May 2012 03:50:06 +0200
To: linux-media@vger.kernel.org
From: bmullan <bmullan.mail@gmail.com>
Subject: Re: 3.1/3.2 uvcvideo and Creative Live! Cam Optia AF
Date: Wed, 23 May 2012 18:17:52 +0000 (UTC)
Message-ID: <loom.20120523T201530-315@post.gmane.org>
References: <20120229225851.GB14135@zod.bos.redhat.com> <1525016.a7S65ueJTd@avalon>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent Pinchart <laurent.pinchart <at> ideasonboard.com> writes:

> 
> Hi Josh,
> 
> On Wednesday 29 February 2012 17:58:52 Josh Boyer wrote:
> > Hi Laurent,
> > 
> > We've had a bug report [1] in Fedora for a while now that the uvcvideo
> > driver no longer works on the Creative Live! Cam Optia AF (ID 041e:4058)
> > in the 3.1 and 3.2 kernels.  The bug has all the various output from
> > dmesg, lsusb, etc.
> > 
> > I'm wondering if there is anything further we can do to help diagnose
> > what might be going wrong here.
> > 
> > josh
> > 
> > [1] https://bugzilla.redhat.com/show_bug.cgi?id=739448
> 
> I've asked for more information directly in the bug report.
> 

I'm using Ubuntu 12.04 x64, kernel 3.2.0.24
and the Optia AF has the same problem
uvcvideo, cheese etc all show the device and that its using /dev/video0 but
there is no data being received/displayed.



