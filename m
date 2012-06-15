Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:9655 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124Ab2FOQzL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jun 2012 12:55:11 -0400
From: Ralph Metzler <rjkm@metzlerbros.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <20443.26861.684841.155578@morden.metzler>
Date: Fri, 15 Jun 2012 18:55:09 +0200
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Ben Collins <bcollins@bluecherry.net>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
	kernel-janitors@vger.kernel.org
Subject: Re: [patch RFC] [media] staging: solo6x10: fix | vs &
In-Reply-To: <20120610205804.GG13539@mwanda>
References: <20120609074732.GA30709@elgon.mountain>
	<20120610205804.GG13539@mwanda>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dan Carpenter writes:
 > On Sat, Jun 09, 2012 at 10:47:32AM +0300, Dan Carpenter wrote:
 > > The test here is never true because '&' was used instead of '|'.  It was
 > > the same as:
 > > 
 > > 	if (status & ((1<<16) & (1<<17)) ...
 > > 
 > > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
 > > ---
 > > I don't have this hardware and this one really should be tested or
 > > checked by someone who knows the spec.  It could be that the intent was
 > > to do:
 > > 
 > > 	if ((status & SOLO_IIC_STATE_TRNS) &&
 > > 	    (status & SOLO_IIC_STATE_SIG_ERR) || ...
 > > 
 > 
 > It should be this, yes?  For other similar mistakes it was meant to
 > be this way.

Yes, looks ok.


Regards,
Ralph
