Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:65404 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757124Ab3CFO7t (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2013 09:59:49 -0500
Date: Wed, 6 Mar 2013 15:59:42 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Albert Wang <twang13@marvell.com>
cc: "corbet@lwn.net" <corbet@lwn.net>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Libin Yang <lbyang@marvell.com>
Subject: RE: [REVIEW PATCH V4 02/12] [media] marvell-ccic: add clock tree
 support for marvell-ccic driver
In-Reply-To: <477F20668A386D41ADCC57781B1F70430D9D8DAA88@SC-VEXCH1.marvell.com>
Message-ID: <Pine.LNX.4.64.1303061557350.7010@axis700.grange>
References: <1360238687-15768-1-git-send-email-twang13@marvell.com>
 <1360238687-15768-3-git-send-email-twang13@marvell.com>
 <Pine.LNX.4.64.1303051047120.25837@axis700.grange>
 <477F20668A386D41ADCC57781B1F70430D9D8DAA88@SC-VEXCH1.marvell.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Albert

On Wed, 6 Mar 2013, Albert Wang wrote:

> Hi, Guennadi
> 
> 
> >-----Original Message-----
> >From: Guennadi Liakhovetski [mailto:g.liakhovetski@gmx.de]
> >Sent: Tuesday, 05 March, 2013 17:51
> >To: Albert Wang
> >Cc: corbet@lwn.net; linux-media@vger.kernel.org; Libin Yang
> >Subject: Re: [REVIEW PATCH V4 02/12] [media] marvell-ccic: add clock tree support for
> >marvell-ccic driver

[snip]

> >> @@ -331,6 +374,10 @@ static int mmpcam_probe(struct platform_device *pdev)
> >>  		ret = -ENODEV;
> >>  		goto out_unmap1;
> >>  	}
> >> +
> >> +	ret = mcam_init_clk(mcam, pdata);
> >> +	if (ret)
> >> +		goto out_unmap2;
> >
> >Now, I'm confused again: doesn't this mean, that all existing users of
> >this driver will fail?
> >
> Sorry, I don't understand what's your concern?

I mean - wouldn't the above function fail for all existing users, because 
they don't provide the clocks, that you're requesting here?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
