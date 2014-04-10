Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:37931 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965484AbaDJJtN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Apr 2014 05:49:13 -0400
Date: Thu, 10 Apr 2014 12:48:50 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Vitaly Osipov <vitaly.osipov@gmail.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH 2/2] staging: media: omap24xx: fix up a checkpatch.pl
 warning
Message-ID: <20140410094850.GF26890@mwanda>
References: <20140410090234.GA8654@witts-MacBook-Pro.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140410090234.GA8654@witts-MacBook-Pro.local>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The two subjects are really close to being the same.  You should choose
better subjects.  Like:

[PATCH 2/2] staging: media: omap24xx: use pr_info() instead of KERN_INFO


(All the checkpatch.pl people use the exact same subject for everything
though, so you're not alone in this).

regards,
dan carpenter

