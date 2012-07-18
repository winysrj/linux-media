Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39747 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753067Ab2GRIfu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Jul 2012 04:35:50 -0400
Subject: Re: [PATCH v3] media: coda: Add driver for Coda video codec.
From: Philipp Zabel <p.zabel@pengutronix.de>
To: javier Martin <javier.martin@vista-silicon.com>
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com, laurent.pinchart@ideasonboard.com,
	mchehab@infradead.org, s.hauer@pengutronix.de
In-Reply-To: <CACKLOr3rOPgwMCRdj3ARR+0655Qp=BfEXq0TsB7TU-hO4NSsqg@mail.gmail.com>
References: <1342077100-8629-1-git-send-email-javier.martin@vista-silicon.com>
	 <1342459273.2535.665.camel@pizza.hi.pengutronix.de>
	 <CACKLOr3rOPgwMCRdj3ARR+0655Qp=BfEXq0TsB7TU-hO4NSsqg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 Jul 2012 10:35:46 +0200
Message-ID: <1342600546.2542.101.camel@pizza.hi.pengutronix.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier,

Am Mittwoch, den 18.07.2012, 09:12 +0200 schrieb javier Martin:
[...]
> > I see there is a comment about the expected register setting not working
> > for CODA_REG_BIT_STREAM_CTRL in start_streaming(). Could this be
> > related?
> 
> I don't think so. This means that the following line:
> 
> coda_write(dev, (3 << 3), CODA_REG_BIT_STREAM_CTRL);
> 
> should be:
> 
> coda_write(dev, (CODADX6_STREAM_BUF_PIC_RESET |
> CODADX6_STREAM_BUF_PIC_FLUSH), CODA_REG_BIT_STREAM_CTRL);
> 
> But the latter does not work.

Looks to me like (3 << 3) == (CODA7_STREAM_BUF_PIC_RESET |
CODA7_STREAM_BUF_PIC_FLUSH) could be the explanation.

Maybe the documentation about CODADX6_STREAM_BUF_PIC_RESET |
CODADX6_STREAM_BUF_PIC_FLUSH was outdated?

> > Also, I've missed two problems with platform device removal and module
> > autoloading before, see below.
> 
> Fine.
[...]
> I will send a new v4 with the 'platform' and 'bytesused' issues fixed.
> Regarding your i.MX53 problems I suppose they should be addressed
> conditionally in a patch on top of this one where i.MX53 support is
> added too.
> What do you think?

Agreed. After fixing the issues in vidioc_try_fmt, MODULE_DEVICE_TABLE,
and coda_remove, feel free to add a
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>

regards
Philipp


