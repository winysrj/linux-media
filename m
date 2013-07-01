Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50579 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417Ab3GARdj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Jul 2013 13:33:39 -0400
Date: Mon, 1 Jul 2013 14:33:26 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	"linux-media" <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: Question: interaction between selection API, ENUM_FRAMESIZES
 and S_FMT?
Message-ID: <20130701143326.12c0f819@infradead.org>
In-Reply-To: <201307011456.58788.hverkuil@xs4all.nl>
References: <201306241448.15187.hverkuil@xs4all.nl>
	<51D09507.80501@gmail.com>
	<20130630175524.0b3fda91@infradead.org>
	<201307011456.58788.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 1 Jul 2013 14:56:58 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

...

> PS: this discussion works much better in person with a nice whiteboard to
> draw on!

Well, let's then postpone it to either LinuxCon NA or EU. 

>From this threadt, it seems that new selection API failed to fix the issues 
we had with the crop API, as we're still noticing the same issues that 
motivated the new API. So, we need to go one step back, and try to have
a bigger picture of the issues.

Cheers,
Mauro
