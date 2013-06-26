Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:44943 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680Ab3FZKh1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Jun 2013 06:37:27 -0400
Date: Wed, 26 Jun 2013 13:37:09 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Jarod Wilson <jarod@wilsonet.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	YAMANE Toshiaki <yamanetoshi@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: [patch] [media] staging: lirc: clean error handling in probe()
Message-ID: <20130626103709.GL5714@mwanda>
References: <20130626075358.GC1895@elgon.mountain>
 <1372233640.24799.52.camel@smile>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372233640.24799.52.camel@smile>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jun 26, 2013 at 11:00:40AM +0300, Andy Shevchenko wrote:
> On Wed, 2013-06-26 at 10:53 +0300, Dan Carpenter wrote: 
> > I have reorganized the error handling into a simpler and more canonical
> > format.
> 
> Since you reorganize error handling, might be worth to convert it to
> devm_*? 
> 
> If you want I could do the patch.

Yeah.  Using devm_kzalloc() would make it a lot simpler.  That would
be great if you could re-write it that way.  Thanks!

Please drop my patch in that case.

regards,
dan carpenter

