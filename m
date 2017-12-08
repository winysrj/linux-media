Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:33903 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753727AbdLHOH6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Dec 2017 09:07:58 -0500
Date: Fri, 8 Dec 2017 12:07:51 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Stefani Seibold <stefani@seibold.net>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Sean Young <sean@mess.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH v3 26/26] kfifo: DECLARE_KIFO_PTR(fifo, u64) does not
 work on arm 32 bit
Message-ID: <20171208120751.5c3d3165@vento.lan>
In-Reply-To: <1512045250.2568.1.camel@seibold.net>
References: <cover.1507618840.git.sean@mess.org>
        <1507622382.6064.2.camel@seibold.net>
        <20171130102946.7168e93c@vento.lan>
        <1512045250.2568.1.camel@seibold.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 30 Nov 2017 13:34:10 +0100
Stefani Seibold <stefani@seibold.net> escreveu:

> On Thu, 2017-11-30 at 10:29 -0200, Mauro Carvalho Chehab wrote:
> > Em Tue, 10 Oct 2017 09:59:42 +0200
> > Sean Young <sean@mess.org> escreveu:
> >   
> > > If you try to store u64 in a kfifo (or a struct with u64 members),
> > > then the buf member of __STRUCT_KFIFO_PTR will cause 4 bytes
> > > padding due to alignment (note that struct __kfifo is 20 bytes
> > > on 32 bit).
> > > 
> > > That in turn causes the __is_kfifo_ptr() to fail, which is caught
> > > by kfifo_alloc(), which now returns EINVAL.
> > > 
> > > So, ensure that __is_kfifo_ptr() compares to the right structure.
> > > 
> > > Signed-off-by: Sean Young <sean@mess.org>
> > > Acked-by: Stefani Seibold <stefani@seibold.net>  
> > 
> > Hi Stefani/Andrew,
> > 
> > As this patch is required for the LIRC rework, would be ok if I would
> > merge it via the media tree?
> >   
> 
> It is okay by me. But the question remains why this patch wasn't
> already merged?
> 
> Andrew: Any objections against this patch?


I'm assuming that merging via media tree is ok for Andrew. So, I guess
I'll just go ahead and merge it via my tree.


Thanks,
Mauro
