Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:39588 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991AbbI0UI4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Sep 2015 16:08:56 -0400
Date: Sun, 27 Sep 2015 17:08:26 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	linux-media@vger.kernel.org
Subject: Re: [git:media_tree/master] [media] rcar_vin: call g_std() instead
 of querystd()
Message-ID: <20150927170826.5063f729@recife.lan>
In-Reply-To: <Pine.LNX.4.64.1509272120240.14212@axis700.grange>
References: <E1ZfZpS-0004ra-EU@www.linuxtv.org>
	<5605BF3C.5040309@cogentembedded.com>
	<Pine.LNX.4.64.1509272120240.14212@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 27 Sep 2015 21:23:29 +0200
Guennadi Liakhovetski <g.liakhovetski@gmx.de> escreveu:

> On Sat, 26 Sep 2015, Sergei Shtylyov wrote:
> 
> > Hello.
> > 
> > On 09/25/2015 11:32 PM, Mauro Carvalho Chehab wrote:
> > 
> > > This is an automatic generated email to let you know that the following
> > > patch were queued at the
> > > http://git.linuxtv.org/cgit.cgi/media_tree.git tree:
> > > 
> > > Subject: [media] rcar_vin: call g_std() instead of querystd()
> > > Author:  Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
> > > Date:    Thu Sep 3 20:18:05 2015 -0300
> > > 
> > > Hans Verkuil says: "The only place querystd can be called  is in the
> > > QUERYSTD
> > > ioctl, all other ioctls should use the last set standard." So call the
> > > g_std()
> > > subdevice method instead of querystd() in the driver's set_fmt() method.
> > > 
> > > Reported-by: Hans Verkuil <hverkuil@xs4all.nl>
> > > Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
> > > Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> > > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> > 
> >    Note that merging this patch without the 2 patches preceding it in the the
> > series will break the frame capture.
> 
> Ouch, the other 2 patches were not for me, I wasn't even CC'ed on them, 
> but I guess I should have read patch 0/3, on which I was indeed CC'ed and 
> just have acked this patch instead of pushing it... Mauro, I guess the 
> only two possibilities to fix this now is to also push the other two 
> patches or to revert this one. Sorry about this.

Well, if the other two patches are OK, then send me a pull request,
and I'll merge them.

> 
> Thanks
> Guennadi
