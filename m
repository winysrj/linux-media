Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29215 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbaJONk0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Oct 2014 09:40:26 -0400
Date: Wed, 15 Oct 2014 16:40:08 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Shuah Khan <shuah.kh@samsung.com>
Cc: Fabian Frederick <fabf@skynet.be>, linux-media@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: Re: [patch] [media] xc5000: use after free in release()
Message-ID: <20141015134008.GO26918@mwanda>
References: <20140925114008.GC3708@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140925114008.GC3708@mwanda>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Sep 25, 2014 at 02:40:08PM +0300, Dan Carpenter wrote:
> I moved the call to hybrid_tuner_release_state(priv) after
> "priv->firmware" dereference.
> 
> Fixes: 5264a522a597 ('[media] media: tuner xc5000 - release firmwware from xc5000_release()')

We still need this patch.

regards,
dan carpenter

