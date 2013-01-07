Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:52785 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752294Ab3AGAFa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 6 Jan 2013 19:05:30 -0500
Message-ID: <1357517060.1851.16.camel@palomino.walls.org>
Subject: Re: [PATCH] [media] ivtv: ivtv-driver: Replace 'flush_work_sync()'
From: Andy Walls <awalls@md.metrocast.net>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media ML <linux-media@vger.kernel.org>
Date: Sun, 06 Jan 2013 19:04:20 -0500
In-Reply-To: <20121220151845.4e92f056@redhat.com>
References: <20121121152809.51c780a6@redhat.com>
	 <20121220151845.4e92f056@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2012-12-20 at 15:18 -0200, Mauro Carvalho Chehab wrote:
> Em Wed, 21 Nov 2012 15:28:09 -0200
> Mauro Carvalho Chehab <mchehab@redhat.com> escreveu:
> 
> > Hi Andy,
> > 
> > I'm understanding that you'll be reviewing this patch. So, I'm marking it as
> > under_review at patchwork.
> 
> -ENOANSWER. Let me apply it, in order to fix the warning.

Ooops.  Sorry about that.

Strictly speaking, I think the patch introduces a race condition that is
extremely unlikely to be encountered, and it likely wouldn't have
terrible consequences anyway.

For the normal end-user, it will never be a problem.

FWIW:
Acked-by: Andy Walls <awalls@md.metrocast.net>

Regards,
Andy
> > 
> > Thanks,
> > Mauro
> > 
> > Forwarded message:
> > 
> > Date: Wed, 24 Oct 2012 10:14:16 -0200
> > From: Fabio Estevam <festevam@gmail.com>
> > To: awalls@md.metrocast.net
> > Cc: mchehab@infradead.org, linux-media@vger.kernel.org, tj@kernel.org, Fabio Estevam <fabio.estevam@freescale.com>
> > Subject: [PATCH] [media] ivtv: ivtv-driver: Replace 'flush_work_sync()'
> > 
> > 
> > From: Fabio Estevam <fabio.estevam@freescale.com>
> > 
> > Since commit 43829731d (workqueue: deprecate flush[_delayed]_work_sync()),
> > flush_work() should be used instead of flush_work_sync().
> > 
> > Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> > ---
> >  drivers/media/pci/ivtv/ivtv-driver.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/media/pci/ivtv/ivtv-driver.c b/drivers/media/pci/ivtv/ivtv-driver.c
> > index 74e9a50..5d0a5df 100644
> > --- a/drivers/media/pci/ivtv/ivtv-driver.c
> > +++ b/drivers/media/pci/ivtv/ivtv-driver.c
> > @@ -304,7 +304,7 @@ static void request_modules(struct ivtv *dev)
> >  
> >  static void flush_request_modules(struct ivtv *dev)
> >  {
> > -	flush_work_sync(&dev->request_module_wk);
> > +	flush_work(&dev->request_module_wk);
> >  }
> >  #else
> >  #define request_modules(dev)
> 
> 


