Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38586 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669AbaEHKlA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 May 2014 06:41:00 -0400
Date: Thu, 8 May 2014 13:40:34 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>
Cc: devel@driverdev.osuosl.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] staging: lirc: Fix sparse warnings
Message-ID: <20140508104034.GE26890@mwanda>
References: <1399543908-31900-1-git-send-email-tuomas.tynkkynen@iki.fi>
 <20140508103028.GD26890@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140508103028.GD26890@mwanda>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, May 08, 2014 at 01:30:28PM +0300, Dan Carpenter wrote:
> On Thu, May 08, 2014 at 01:11:48PM +0300, Tuomas Tynkkynen wrote:
> > Fix sparse warnings by adding __user and __iomem annotations where
> > necessary and removing certain unnecessary casts.
> > 
> > Signed-off-by: Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>
> 
> This patch adds spaces between the cast and the variable.  There
> shouldn't be a cast.
                 ^^^^
I meant space.  There shouldn't be a space.

regards,
dan carpenter

