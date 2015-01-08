Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17738 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755461AbbAHLt0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Jan 2015 06:49:26 -0500
Date: Thu, 8 Jan 2015 14:49:00 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: walter harms <wharms@bfs.de>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Grant Likely <grant.likely@linaro.org>,
	Rob Herring <robh+dt@kernel.org>, linux-media@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: Re: [patch] [media] coda: improve safety in coda_register_device()
Message-ID: <20150108114900.GL15033@mwanda>
References: <20150108100708.GA10597@mwanda>
 <54AE6434.4070805@bfs.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54AE6434.4070805@bfs.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jan 08, 2015 at 12:04:20PM +0100, walter harms wrote:
> > @@ -1844,10 +1844,11 @@ static int coda_register_device(struct coda_dev *dev, int i)
> >  {
> >  	struct video_device *vfd = &dev->vfd[i];
> >  
> > -	if (i > ARRAY_SIZE(dev->vfd))
> > +	if (i >= dev->devtype->num_vdevs)
> >  		return -EINVAL;
> 
> hi,
>  just a minor question. if i can not be trusted, i feel you should move the
>  array access:
>    struct video_device *vfd = &dev->vfd[i];
>  after the check
>    i >= dev->devtype->num_vdevs
> at least that would improve the readability by not trigger my internal alarm
> "check after access"

The "access" is just taking the address, not dereferencing so it's ok.
This kind of code is fairly common and CodingStyle doesn't have an
opinion here so I left it how the original author wrote it.

regards,
dan carpenter

