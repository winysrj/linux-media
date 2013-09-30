Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50902 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755283Ab3I3NYL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Sep 2013 09:24:11 -0400
Message-ID: <1380547428.3959.13.camel@pizza.hi.pengutronix.de>
Subject: Re: [PATCH 07/10] [media] coda: prefix v4l2_ioctl_ops with coda_
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Javier Martin <javier.martin@vista-silicon.com>,
	Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de
Date: Mon, 30 Sep 2013 15:23:48 +0200
In-Reply-To: <5249657E.1010607@xs4all.nl>
References: <1379582036-4840-1-git-send-email-p.zabel@pengutronix.de>
	 <1379582036-4840-8-git-send-email-p.zabel@pengutronix.de>
	 <5249657E.1010607@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Montag, den 30.09.2013, 13:50 +0200 schrieb Hans Verkuil:
> On 09/19/2013 11:13 AM, Philipp Zabel wrote:
> > Moving the ioctl handler callbacks into the coda namespace helps
> > tremendously to make sense of backtraces.
> 
> I like the idea, but I would just use the coda_ prefix, not coda_vidioc_. In general
> the prefix is either vidioc_ or the name of the driver, not both.

Thank you, I'll change this patch (and the following patches)
accordingly.

regards
Philipp

