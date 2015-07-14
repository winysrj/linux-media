Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49263 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602AbbGNNAi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jul 2015 09:00:38 -0400
Message-ID: <1436878833.3793.32.camel@pengutronix.de>
Subject: Re: [PATCH 0/5] i.MX5/6 mem2mem scaler
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Fabio Estevam <festevam@gmail.com>
Cc: Kamil Debski <k.debski@samsung.com>,
	linux-media <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	DRI mailing list <dri-devel@lists.freedesktop.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sascha Hauer <kernel@pengutronix.de>,
	Steve Longerbeam <slongerbeam@gmail.com>,
	Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
Date: Tue, 14 Jul 2015 15:00:33 +0200
In-Reply-To: <CAOMZO5Do770FtGTTh-hwvpy4qCJAem21yzw+X0x++WsZVBq_=g@mail.gmail.com>
References: <1426607290-13380-1-git-send-email-p.zabel@pengutronix.de>
	 <03c101d0739c$71eeeb40$55ccc1c0$%debski@samsung.com>
	 <CAOMZO5Do770FtGTTh-hwvpy4qCJAem21yzw+X0x++WsZVBq_=g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Fabio,

Am Montag, den 13.07.2015, 09:57 -0300 schrieb Fabio Estevam:
> On Fri, Apr 10, 2015 at 11:41 AM, Kamil Debski <k.debski@samsung.com> wrote:
> > Hi,
> >
> > From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> > owner@vger.kernel.org] On Behalf Of Philipp Zabel
> > Sent: Tuesday, March 17, 2015 4:48 PM
> >>
> >> Hi,
> >>
> >> this series uses the IPU IC post-processing task, to implement a
> >> mem2mem device for scaling and colorspace conversion.
> >
> > This patchset makes changes in two subsystems - media and gpu.
> > It would be good to merge these patchset through a single subsystem.
> >
> > The media part of this patchset is good, are there any comments to
> > the gpu part of this patchset?
> >
> > I talked with Mauro on the IRC and he acked that this patchset could be
> > merged via the gpu subsystem.
> 
> Do you plan to resend this series?
> 
> It is still not applied.

Yes, thank you for the reminder.

regards
Philipp

