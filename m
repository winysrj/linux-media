Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34452 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932910AbaHYPN0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Aug 2014 11:13:26 -0400
Message-ID: <1408979594.3191.68.camel@paszta.hi.pengutronix.de>
Subject: Re: [PATCH v2 2/3] usb: gadget/uvc: also handle v4l2 ioctl ENUM_FMT
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Michael Grzeschik <mgr@pengutronix.de>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Michael Grzeschik <m.grzeschik@pengutronix.de>,
	linux-usb@vger.kernel.org, balbi@ti.com, kernel@pengutronix.de,
	linux-media@vger.kernel.org, hans.verkuil@cisco.com
Date: Mon, 25 Aug 2014 17:13:14 +0200
In-Reply-To: <1558910.c27BVhDgdW@avalon>
References: <1407512339-8433-1-git-send-email-m.grzeschik@pengutronix.de>
	 <7518802.YGX5leEVlJ@avalon> <20140825135957.GG22481@pengutronix.de>
	 <1558910.c27BVhDgdW@avalon>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Am Montag, den 25.08.2014, 16:48 +0200 schrieb Laurent Pinchart:
[...]
> > > > > Format descriptions are currently duplicated in every driver, causing
> > > > > higher memory usage and different descriptions for the same format
> > > > > depending on the driver. Hans, should we try to fix this ?
> > > > 
> > > > Yes, we should. It's been on my todo list for ages, but at a very low
> > > > priority. I'm not planning to work on this in the near future, but if
> > > > someone else wants to work on this, then just go ahead.
> > > 
> > > Michael, would you like to give this a try, or should I do it ?
> > 
> > It seems Philipp is already taking the chance! :)
> 
> Perfect timing, I wonder if that's just a coincidence ;-)

It felt like my own idea this weekend, but I strongly suspect that I
took up enough information to trigger it, when scanning mail last week.

I shouldn't be so fast to dismiss uvc/gadget mails as "Michael's
business"...

regards
Philipp

