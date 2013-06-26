Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:16741 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591Ab3FZP7B (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Jun 2013 11:59:01 -0400
Date: Wed, 26 Jun 2013 18:58:45 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Jarod Wilson <jarod@wilsonet.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	YAMANE Toshiaki <yamanetoshi@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v2] staging: lirc: clean error handling in probe()
Message-ID: <20130626155845.GO5714@mwanda>
References: <1372257456-19212-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <20130626151001.GM5714@mwanda>
 <1372260552.24799.59.camel@smile>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372260552.24799.59.camel@smile>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jun 26, 2013 at 06:29:12PM +0300, Andy Shevchenko wrote:
> On Wed, 2013-06-26 at 18:10 +0300, Dan Carpenter wrote: 
> > On Wed, Jun 26, 2013 at 05:37:36PM +0300, Andy Shevchenko wrote:
> > > From: Dan Carpenter <dan.carpenter@oracle.com>
> > > 
> > > We have reorganized the error handling into a simpler and more canonical
> > > format.
> > > 
> > > Additionally we removed extra empty lines, switched to devm_kzalloc(), and
> > > substitute 'minor' by 'ret' in the igorplugusb_remote_probe() function.
> > > 
> > > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > 
> > I don't want credit for this, because I didn't do the work.
> > Signed-off-by is a legal thing like signing a document...  
> 
> I took your patch and modified it, so, you have done some work too.
> But I could resend a version with my authorship.

I don't think any of my work survived the re-write, but I'm happy
enough to take credit for other people's work.  :)  Don't bother
resending.

Signed-off-by:  Dan Carpenter <dan.carpenter@oracle.com>

regards,
dan carpenter

