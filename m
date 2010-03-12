Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:56624 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932164Ab0CLJ6X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Mar 2010 04:58:23 -0500
Date: Fri, 12 Mar 2010 10:58:31 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?=
	<u.kleine-koenig@pengutronix.de>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Antonio Ospite <ospite@studenti.unina.it>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] V4L/DVB: mx1-camera: compile fix
In-Reply-To: <20100312094148.GA15123@pengutronix.de>
Message-ID: <Pine.LNX.4.64.1003121057090.4385@axis700.grange>
References: <20100304194241.GG19843@pengutronix.de>
 <1267785924-16167-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <Pine.LNX.4.64.1003121016480.4385@axis700.grange> <20100312094148.GA15123@pengutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 12 Mar 2010, Uwe Kleine-König wrote:

> >                       Or maybe even we shall remap those registers?
> Well, they are remapped, don't they?  Otherwise IO_ADDRESS wouldn't
> work.

Yes, they are (statically, I presume), but not in _this_ driver...

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
