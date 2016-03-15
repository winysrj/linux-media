Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:44743 "EHLO
	metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932719AbcCOK00 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Mar 2016 06:26:26 -0400
Message-ID: <1458037582.3829.16.camel@pengutronix.de>
Subject: Re: [PATCH v3 3/9] [media] tvp5150: determine BT.656 or YUV 4:2:2
 mode from device tree
From: Lucas Stach <l.stach@pengutronix.de>
To: Javier Martinez Canillas <javier@dowhile0.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	patchwork-lst@pengutronix.de, Sascha Hauer <kernel@pengutronix.de>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Date: Tue, 15 Mar 2016 11:26:22 +0100
In-Reply-To: <CABxcv==SYJGw76U7HRn_SsNrTHQa+Ewp0jio+Z94qEC5Fd2WYQ@mail.gmail.com>
References: <1457969017-4088-1-git-send-email-l.stach@pengutronix.de>
	 <1457969017-4088-3-git-send-email-l.stach@pengutronix.de>
	 <CABxcv==SYJGw76U7HRn_SsNrTHQa+Ewp0jio+Z94qEC5Fd2WYQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Montag, den 14.03.2016, 15:19 -0300 schrieb Javier Martinez Canillas:
> Hello Lucas,
> 
> On Mon, Mar 14, 2016 at 12:23 PM, Lucas Stach <l.stach@pengutronix.de> wrote:
> > From: Philipp Zabel <p.zabel@pengutronix.de>
> >
> > By looking at the endpoint flags, it can be determined whether the link
> > should be of V4L2_MBUS_PARALLEL or V4L2_MBUS_BT656 type. Disable the
> > dedicated HSYNC/VSYNC outputs in BT.656 mode.
> >
> > For devices that are not instantiated through DT the current behavior
> > is preserved.
> >
> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
> > ---
> 
> Similar to Mauro's comment on patch 2/9, the current driver already
> supports configuring the interface output format using DT.

Sorry about that. I've lost touch with the current media tree, will look
into what is already there. Sorry for the noise.


