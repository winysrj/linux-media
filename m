Return-path: <linux-media-owner@vger.kernel.org>
Received: from exprod5og110.obsmtp.com ([64.18.0.20]:43578 "EHLO
	exprod5og110.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476Ab2EBNbZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 May 2012 09:31:25 -0400
Date: Wed, 2 May 2012 15:31:08 +0200
From: Karl Kiniger <karl.kiniger@med.ge.com>
To: Paulo Assis <pj.assis@gmail.com>
Cc: linux-media@vger.kernel.org, linux-uvc-devel@lists.sourceforge.net
Subject: Re: logitech quickcam 9000 uvcdynctrl broken since kernel 3.2 - PING
Message-ID: <20120502133108.GA19522@kipc2.localdomain>
References: <20120424122156.GA16769@kipc2.localdomain>
 <20120502084318.GA21181@kipc2.localdomain>
 <CAPueXH4-VSxHYjryO8kN5R-hG6seFrwCu3Kjrq4TXV=XFKLETg@mail.gmail.com>
 <20120502114430.GA4608@kipc2.localdomain>
 <CAPueXH7TjHo-Dx2wUCQEcDvn=5L_xobYVKrf+b6wnmLGwOSeRg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPueXH7TjHo-Dx2wUCQEcDvn=5L_xobYVKrf+b6wnmLGwOSeRg@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed 120502, Paulo Assis wrote:
> karl,
> I've run some tests under ubuntu 12.04 with kernel 3.2.0 and
> everything seems to be working fine.
> I know some changes were made to the uvcvideo module regarding XU
> controls, but I was under the impression that they wouldn't break
> userspace.
> 
> Logitech shutdown the quickcamteam site, so you won't be able to
> download libwebcam from there.
> I'm currently the debian mantainer of that package, so I'll try to
> test it on a newer kernel and patch it as necessary.
> I'll also fix guvcview if needed.

Very much appreciated, Paulo!

In the meantime I poked  around at Ubuntu and found
libwebcam_0.2.1.orig.tar.gz - will try to compiled it but they
have a couple of kernel patches to 3.2.x as well and perhaps there
is a depency.

Karl

> 
> Regards,
> Paulo

