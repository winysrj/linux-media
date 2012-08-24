Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:52425 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895Ab2HXLs6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Aug 2012 07:48:58 -0400
Date: Fri, 24 Aug 2012 13:48:55 +0200
From: Anatolij Gustschin <agust@denx.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>, dzu@denx.de
Subject: Re: [PATCH v2] V4L: soc_camera: allow reading from video device if
 supported
Message-ID: <20120824134855.1026c417@wker>
In-Reply-To: <Pine.LNX.4.64.1208241331550.20710@axis700.grange>
References: <1345290335-12980-1-git-send-email-agust@denx.de>
	<1345799604-29608-1-git-send-email-agust@denx.de>
	<Pine.LNX.4.64.1208241331550.20710@axis700.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Fri, 24 Aug 2012 13:37:20 +0200 (CEST)
Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
...
> How about a slightly simpler
> 
> > +	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
> > -	int err = -EINVAL;
> >  
> > -	dev_err(icd->pdev, "camera device read not implemented\n");
> > +	dev_dbg(icd->pdev, "read called, buf %p\n", buf);
> >  
> > -	return err;
> > +	if (ici->ops->init_videobuf2 && icd->vb2_vidq.io_modes & VB2_READ)
> > +		return vb2_read(&icd->vb2_vidq, buf, count, ppos,
> > +				file->f_flags & O_NONBLOCK);
> > +
> > +	dev_err(icd->pdev, "camera device read not implemented\n");
> > +	return -EINVAL;

Ok, I'll simplify as suggested and resubmit.

Thanks,

Anatolij
