Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:30857 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751269Ab3FZP3V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Jun 2013 11:29:21 -0400
Message-ID: <1372260552.24799.59.camel@smile>
Subject: Re: [PATCH v2] staging: lirc: clean error handling in probe()
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Jarod Wilson <jarod@wilsonet.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	YAMANE Toshiaki <yamanetoshi@gmail.com>,
	linux-media@vger.kernel.org
Date: Wed, 26 Jun 2013 18:29:12 +0300
In-Reply-To: <20130626151001.GM5714@mwanda>
References: <1372257456-19212-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <20130626151001.GM5714@mwanda>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2013-06-26 at 18:10 +0300, Dan Carpenter wrote: 
> On Wed, Jun 26, 2013 at 05:37:36PM +0300, Andy Shevchenko wrote:
> > From: Dan Carpenter <dan.carpenter@oracle.com>
> > 
> > We have reorganized the error handling into a simpler and more canonical
> > format.
> > 
> > Additionally we removed extra empty lines, switched to devm_kzalloc(), and
> > substitute 'minor' by 'ret' in the igorplugusb_remote_probe() function.
> > 
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> 
> I don't want credit for this, because I didn't do the work.
> Signed-off-by is a legal thing like signing a document...  

I took your patch and modified it, so, you have done some work too.
But I could resend a version with my authorship.

> But I
> have reviewed it and it looks good.
> 
> Acked-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> regards,
> dan carpenter
> 

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
