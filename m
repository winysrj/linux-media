Return-path: <linux-media-owner@vger.kernel.org>
Received: from cnc.isely.net ([64.81.146.143]:40805 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282Ab0GGP5p (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 7 Jul 2010 11:57:45 -0400
Date: Wed, 7 Jul 2010 10:57:44 -0500 (CDT)
From: Mike Isely <isely@isely.net>
To: Sven Barth <pascaldragon@googlemail.com>
cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	LMML <linux-media@vger.kernel.org>, Mike Isely <isely@isely.net>
Subject: Re: Status of the patches under review at LMML (60 patches)
In-Reply-To: <4C3468DF.1030008@googlemail.com>
Message-ID: <alpine.DEB.1.10.1007071055310.821@cnc.isely.net>
References: <4C332A5F.4000706@redhat.com> <4C3468DF.1030008@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 7 Jul 2010, Sven Barth wrote:

> Hi!
> 
> Am 06.07.2010 15:06, schrieb Mauro Carvalho Chehab:
> > 		== Waiting for Mike Isely<isely@isely.net>  review ==
> >
> > Apr,25 2010: Problem with cx25840 and Terratec Grabster AV400
> http://patchwork.kernel.org/patch/94960
> 
> Is Mike really the maintainer of the cx25840 module and not only of the
> pvrusb2 one? If he's not the maintainer you should contact the real one, cause
> I don't think that Mike can help much regarding patches for the cx25840 in
> that case.
> 
> Also I might need to adjust the patch cause of the recent changes that
> happened there the last few months. (I don't know when I'll find time for
> this...)
> 
> Regards,
> Sven

No I am definitely not the maintainer of that module, and my knowledge 
of its inner workings (though improved a lot lately) is still not very 
good.

All I can do here is verify that it doesn't break the pvrusb2 driver 
(which is what I was planning on doing).

  -Mike


-- 

Mike Isely
isely @ isely (dot) net
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
