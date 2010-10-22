Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35673 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838Ab0JVILj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Oct 2010 04:11:39 -0400
Date: Fri, 22 Oct 2010 10:11:28 +0200
From: Dan Carpenter <error27@gmail.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: 'Mauro Carvalho Chehab' <mchehab@infradead.org>,
	'Kyungmin Park' <kyungmin.park@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch 2/3] V4L/DVB: s5p-fimc: make it compile
Message-ID: <20101022081128.GP5985@bicker>
References: <20101021192400.GK5985@bicker> <000b01cb71ba$58902ad0$09b08070$%nawrocki@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000b01cb71ba$58902ad0$09b08070$%nawrocki@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri, Oct 22, 2010 at 09:25:47AM +0200, Sylwester Nawrocki wrote:
> 
> This code is properly removed in my original patch. But it has been added
> again during a merge conflict solving. Unfortunately I cannot identify the
> merge commit today in linux-next. 
> As for sched.h, it needs a separate patch so I could handle it and add you
> as reported by it is OK.
> 

I thought it was probably a merge conflict.  Thanks for taking care of
this.

regards,
dan carpenter

> Regards,
> Sylwester
> 
> >  	ret = fimc_register_m2m_device(fimc);
> >  	if (ret)
> >  		goto err_irq;
