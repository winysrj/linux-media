Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:51725 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751802AbbI0TXr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Sep 2015 15:23:47 -0400
Date: Sun, 27 Sep 2015 21:23:29 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
cc: mchehab@osg.samsung.com, linux-media@vger.kernel.org
Subject: Re: [git:media_tree/master] [media] rcar_vin: call g_std() instead
 of querystd()
In-Reply-To: <5605BF3C.5040309@cogentembedded.com>
Message-ID: <Pine.LNX.4.64.1509272120240.14212@axis700.grange>
References: <E1ZfZpS-0004ra-EU@www.linuxtv.org> <5605BF3C.5040309@cogentembedded.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 26 Sep 2015, Sergei Shtylyov wrote:

> Hello.
> 
> On 09/25/2015 11:32 PM, Mauro Carvalho Chehab wrote:
> 
> > This is an automatic generated email to let you know that the following
> > patch were queued at the
> > http://git.linuxtv.org/cgit.cgi/media_tree.git tree:
> > 
> > Subject: [media] rcar_vin: call g_std() instead of querystd()
> > Author:  Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
> > Date:    Thu Sep 3 20:18:05 2015 -0300
> > 
> > Hans Verkuil says: "The only place querystd can be called  is in the
> > QUERYSTD
> > ioctl, all other ioctls should use the last set standard." So call the
> > g_std()
> > subdevice method instead of querystd() in the driver's set_fmt() method.
> > 
> > Reported-by: Hans Verkuil <hverkuil@xs4all.nl>
> > Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
> > Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> 
>    Note that merging this patch without the 2 patches preceding it in the the
> series will break the frame capture.

Ouch, the other 2 patches were not for me, I wasn't even CC'ed on them, 
but I guess I should have read patch 0/3, on which I was indeed CC'ed and 
just have acked this patch instead of pushing it... Mauro, I guess the 
only two possibilities to fix this now is to also push the other two 
patches or to revert this one. Sorry about this.

Thanks
Guennadi
