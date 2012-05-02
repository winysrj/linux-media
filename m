Return-path: <linux-media-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:43402 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866Ab2EBHCF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 May 2012 03:02:05 -0400
Date: Wed, 2 May 2012 10:05:07 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] [media] gspca: passing wrong length parameter to reg_w()
Message-ID: <20120502070507.GO6447@mwanda>
References: <20120502061525.GC28894@elgon.mountain>
 <20120502084758.1a08823f@tele>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120502084758.1a08823f@tele>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, May 02, 2012 at 08:47:58AM +0200, Jean-Francois Moine wrote:
> Thanks for the patch. The bug is very very old (6 years, at least -
> neither have I such a webcam).
> 

My guess is that it's harmless to write a few extra garbage bits,
but it's still worth fixing as a cleanup.

> Maybe the fix could have been
> 
> 	reg_w(gspca_dev, 0x0010, reg10, sizeof reg10);
> 
> but it is OK for me.
> 
> Acked-by: Jean-Francois Moine <http://moinejf.free.fr>

Thanks.

regards,
dan carpenter

