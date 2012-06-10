Return-path: <linux-media-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:22442 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497Ab2FJU6b (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jun 2012 16:58:31 -0400
Date: Sun, 10 Jun 2012 23:58:04 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Ben Collins <bcollins@bluecherry.net>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
	kernel-janitors@vger.kernel.org
Subject: Re: [patch RFC] [media] staging: solo6x10: fix | vs &
Message-ID: <20120610205804.GG13539@mwanda>
References: <20120609074732.GA30709@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120609074732.GA30709@elgon.mountain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jun 09, 2012 at 10:47:32AM +0300, Dan Carpenter wrote:
> The test here is never true because '&' was used instead of '|'.  It was
> the same as:
> 
> 	if (status & ((1<<16) & (1<<17)) ...
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> I don't have this hardware and this one really should be tested or
> checked by someone who knows the spec.  It could be that the intent was
> to do:
> 
> 	if ((status & SOLO_IIC_STATE_TRNS) &&
> 	    (status & SOLO_IIC_STATE_SIG_ERR) || ...
> 

It should be this, yes?  For other similar mistakes it was meant to
be this way.

regards,
dan carpenter

