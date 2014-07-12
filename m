Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailsec112.isp.belgacom.be ([195.238.20.108]:40237 "EHLO
	mailsec112.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750900AbaGLM0k convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Jul 2014 08:26:40 -0400
Date: Sat, 12 Jul 2014 14:26:38 +0200 (CEST)
From: Fabian Frederick <fabf@skynet.be>
Reply-To: Fabian Frederick <fabf@skynet.be>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sumit Semwal <sumit.semwal@linaro.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <408123556.600278.1405167998799.open-xchange@webmail.nmp.skynet.be>
In-Reply-To: <20140710003428.GA22113@kroah.com>
References: <1403901130-8156-1-git-send-email-fabf@skynet.be> <20140710003428.GA22113@kroah.com>
Subject: Re: [PATCH 1/1] drivers/base/dma-buf.c: replace
 dma_buf_uninit_debugfs by debugfs_remove_recursive
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



> On 10 July 2014 at 02:34 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> wrote:
>
>
> On Fri, Jun 27, 2014 at 10:32:10PM +0200, Fabian Frederick wrote:
> > null test before debugfs_remove_recursive is not needed so one line function
> > dma_buf_uninit_debugfs can be removed.
> >
> > This patch calls debugfs_remove_recursive under CONFIG_DEBUG_FS
> >
> > Cc: Sumit Semwal <sumit.semwal@linaro.org>
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Cc: linux-media@vger.kernel.org
> > Signed-off-by: Fabian Frederick <fabf@skynet.be>
> > ---
> >
> > This is untested.
> >
> >  drivers/base/dma-buf.c | 13 +++----------
> >  1 file changed, 3 insertions(+), 10 deletions(-)
> >
> > diff --git a/drivers/base/dma-buf.c b/drivers/base/dma-buf.c
> > index 840c7fa..184c0cb 100644
> > --- a/drivers/base/dma-buf.c
> > +++ b/drivers/base/dma-buf.c
> > @@ -701,12 +701,6 @@ static int dma_buf_init_debugfs(void)
> >     return err;
> >  }
> > 
> > -static void dma_buf_uninit_debugfs(void)
> > -{
> > -   if (dma_buf_debugfs_dir)
> > -           debugfs_remove_recursive(dma_buf_debugfs_dir);
> > -}
> > -
> >  int dma_buf_debugfs_create_file(const char *name,
> >                             int (*write)(struct seq_file *))
> >  {
> > @@ -722,9 +716,6 @@ static inline int dma_buf_init_debugfs(void)
> >  {
> >     return 0;
> >  }
> > -static inline void dma_buf_uninit_debugfs(void)
> > -{
> > -}
> >  #endif
> > 
> >  static int __init dma_buf_init(void)
> > @@ -738,6 +729,8 @@ subsys_initcall(dma_buf_init);
> > 
> >  static void __exit dma_buf_deinit(void)
> >  {
> > -   dma_buf_uninit_debugfs();
> > +#ifdef CONFIG_DEBUG_FS
> > +   debugfs_remove_recursive(dma_buf_debugfs_dir);
> > +#endif
>
> That ifdef should not be needed at all, right?  No ifdefs should be
> needed for debugfs code, if it is written correctly :)
>

Hello Greg,

        Current dma_buf_init_debugfs and dma_buf_init_uninit_debugfs and
related functions in drivers/base/dma-buf.c are only defined
under #ifdef CONFIG_DEBUG_FS ; reason for that #ifdef in the patch.
I'll send you a fixed version.

Thanks,
Fabian

> thanks,
>
> greg k-h
