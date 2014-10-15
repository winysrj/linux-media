Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47904 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbaJOQPm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Oct 2014 12:15:42 -0400
Date: Wed, 15 Oct 2014 19:15:21 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Shuah Khan <shuah.kh@samsung.com>,
	Fabian Frederick <fabf@skynet.be>, linux-media@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: Re: [patch] [media] xc5000: use after free in release()
Message-ID: <20141015161521.GC23154@mwanda>
References: <20140925114008.GC3708@mwanda>
 <20141015134008.GO26918@mwanda>
 <543E8EEE.7080404@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <543E8EEE.7080404@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Oct 15, 2014 at 09:12:46AM -0600, Shuah Khan wrote:
> On 10/15/2014 07:40 AM, Dan Carpenter wrote:
> > On Thu, Sep 25, 2014 at 02:40:08PM +0300, Dan Carpenter wrote:
> >> I moved the call to hybrid_tuner_release_state(priv) after
> >> "priv->firmware" dereference.
> >>
> >> Fixes: 5264a522a597 ('[media] media: tuner xc5000 - release firmwware from xc5000_release()')
> > 
> > We still need this patch.
> > 
> 
> I didn't see it in media pull request for 3.18. Mauro probably
> has this on his list for next round.
> 

It's not in linux-next.

regards,
dan carpenter

