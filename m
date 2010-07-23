Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53014 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877Ab0GWNZq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Jul 2010 09:25:46 -0400
Date: Fri, 23 Jul 2010 09:16:04 -0400
From: Jarod Wilson <jarod@redhat.com>
To: Dan Carpenter <error27@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Arnd Bergmann <arnd@arndb.de>, linux-media@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: Re: [patch -next] V4L: media/IR: testing the wrong variable
Message-ID: <20100723131604.GA20916@redhat.com>
References: <20100723100826.GB26313@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100723100826.GB26313@bicker>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jul 23, 2010 at 12:08:26PM +0200, Dan Carpenter wrote:
> There is a typo here.  We meant to test "rbuf" instead of "drv".  We
> already tested "drv" earlier.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>

Gah. I swear that got fixed once already... Thanks!

Acked-by: Jarod Wilson <jarod@redhat.com>


-- 
Jarod Wilson
jarod@redhat.com

