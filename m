Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:41958 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751176Ab3GBEIb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Jul 2013 00:08:31 -0400
Date: Mon, 1 Jul 2013 22:08:29 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Libin Yang <lbyang@marvell.com>
Cc: <g.liakhovetski@gmx.de>, <linux-media@vger.kernel.org>,
	<albert.v.wang@gmail.com>, Albert Wang <twang13@marvell.com>
Subject: Re: [PATCH v2 1/7] marvell-ccic: add MIPI support for marvell-ccic
 driver
Message-ID: <20130701220829.73c9c202@lwn.net>
In-Reply-To: <1372735868-15880-2-git-send-email-lbyang@marvell.com>
References: <1372735868-15880-1-git-send-email-lbyang@marvell.com>
	<1372735868-15880-2-git-send-email-lbyang@marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

For future reference, it's nice to summarize the changes made since the
previous posting.

In a really quick scan, I immediately stumbled across this:

> @@ -1816,7 +1884,9 @@ int mccic_resume(struct mcam_camera *cam)
>  
>  	mutex_lock(&cam->s_mutex);
>  	if (cam->users > 0) {
> -		mcam_ctlr_power_up(cam);
> +		ret = mcam_ctlr_power_up(cam);
> +		if (ret)
> +			return ret;

You do see the problem here, right?  Can I ask you to please audit *all*
of your changes to be sure they don't leak locks?  This isn't the sort of
problem that should need to be pointed out twice.

Don't get me wrong, I very much appreciate the effort you have put into
getting these patches ready for merging, and things are quite close.  But
it's important to get details like this right.

Thanks,

jon
