Return-path: <mchehab@gaivota>
Received: from perceval.ideasonboard.com ([95.142.166.194]:37898 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753596Ab0KUXfu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Nov 2010 18:35:50 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [RFC/PATCH v5 01/12] media: Media device node support
Date: Mon, 22 Nov 2010 00:35:54 +0100
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
References: <1285241696-16826-1-git-send-email-laurent.pinchart@ideasonboard.com> <1285241696-16826-2-git-send-email-laurent.pinchart@ideasonboard.com> <20101116173115.0723af74@bike.lwn.net>
In-Reply-To: <20101116173115.0723af74@bike.lwn.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011220035.55615.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Jonathan,

I forgot to answer one of your comments.

On Wednesday 17 November 2010 01:31:15 Jonathan Corbet wrote:

[snip]

> > +static unsigned int media_poll(struct file *filp,
> > +			       struct poll_table_struct *poll)
> > +{
> > +	struct media_devnode *mdev = media_devnode_data(filp);
> > +
> > +	if (!mdev->fops->poll || !media_devnode_is_registered(mdev))
> > +		return DEFAULT_POLLMASK;
> > +	return mdev->fops->poll(filp, poll);
> > +}
> 
> If it's not registered, I would expect poll() to return an error.

Agreed. I'll return POLLERR | POLLHUP in that case. Is that fine with you ?

-- 
Regards,

Laurent Pinchart
