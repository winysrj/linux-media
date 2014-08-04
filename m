Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52691 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181AbaHDLyn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Aug 2014 07:54:43 -0400
Message-ID: <1407153257.3979.30.camel@paszta.hi.pengutronix.de>
Subject: Re: i.MX6 status for IPU/VPU/GPU
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Tim Harvey <tharvey@gateworks.com>
Cc: Robert Schwebel <r.schwebel@pengutronix.de>,
	Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>,
	linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	Steve Longerbeam <slongerbeam@gmail.com>
Date: Mon, 04 Aug 2014 13:54:17 +0200
In-Reply-To: <CAJ+vNU2EiTcXM-CWTLiC=4c9j-ovGFooz3Mr82Yq_6xX1u2gbA@mail.gmail.com>
References: <CAL8zT=jms4ZAvFE3UJ2=+sLXWDsgz528XUEdXBD9HtvOu=56-A@mail.gmail.com>
	 <20140728185949.GS13730@pengutronix.de> <53D6BD8E.7000903@gmail.com>
	 <CAJ+vNU2EiTcXM-CWTLiC=4c9j-ovGFooz3Mr82Yq_6xX1u2gbA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tim,

Am Sonntag, den 03.08.2014, 23:14 -0700 schrieb Tim Harvey:
> Philipp,
> 
> It is unfortunate that the lack of the media device framework is
> holding back acceptance of Steve's patches. Is this something that can
> be added later? Does your patchset which you posted for reference
> resolve this issue and perhaps is something that everyone could agree
> on for a starting point?

We should take this step by step. First I'd like to get Steve's ipu-v3
series in, those don't have any major issues and are a prerequisite for
the media patches anyway.

The capture patches had a few more issues than just missing media device
support. But this is indeed the biggest one, especially where it
involves a userspace interface that we don't want to have to support in
the future.
My RFC series wasn't without problems either. I'll work on the IPU this
week and then post another RFC.

regards
Philipp

