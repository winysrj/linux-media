Return-path: <linux-media-owner@vger.kernel.org>
Received: from zose-mta15.web4all.fr ([176.31.217.11]:50517 "EHLO
	zose-mta15.web4all.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755859Ab2JQMaN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Oct 2012 08:30:13 -0400
Date: Wed, 17 Oct 2012 14:34:49 +0200 (CEST)
From: =?utf-8?Q?Beno=C3=AEt_Th=C3=A9baudeau?=
	<benoit.thebaudeau@advansee.com>
To: Christoph Fritz <chf.fritz@googlemail.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Chris MacGregor <chris@cybermato.com>,
	linux-media@vger.kernel.org, Liu Ying <Ying.liu@freescale.com>,
	"Hans J. Koch" <hjk@hansjkoch.de>, Daniel Mack <daniel@zonque.org>
Message-ID: <623798100.7042136.1350477289944.JavaMail.root@advansee.com>
In-Reply-To: <20121017091406.GA5064@mars>
Subject: Re: hacking MT9P031 for i.mx
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday, October 17, 2012 11:14:06 AM, Christoph Fritz wrote:
> On Tue, Oct 16, 2012 at 11:04:36PM +0200, Benoît Thébaudeau wrote:
> > On Tuesday, October 16, 2012 10:04:57 PM, Laurent Pinchart wrote:
> > > > Is there a current (kernel ~3.6) git tree which shows how to
> > > > add
> > > > mt9p031
> > > > to platform code?
> > > 
> > > Yes, at
> > > http://git.linuxtv.org/pinchartl/media.git/shortlog/refs/heads/omap3isp-
> > > sensors-board
> 
> Thanks!
> 
> > > > I'm also curious if it's possible to glue mt9p031 to a
> > > > freescale
> > > > i.mx35
> > > > platform. As far as I can see,
> > > > drivers/media/platform/soc_camera/mx3_camera.c would need
> > > > v4l2_subdev
> > > > support?
> > 
> > I have not followed this thread, so I don't know exactly your
> > issue, but FYI I have an MT9M131 (of which the driver should
> > hopefully be close to the MT9P031's) working on i.MX35 with Linux
> > 3.4.
> 
> I have here a mt9p031-testing-board with an i.MX35 interface. So I'm
> pretty interested in soc_camera support for mt9p031.
> 
> Laurent is already fixing this but haven't finished due to lack
> of time.  When there is anything to test, I would be glad to do so.

OK. I meant that if my changes work for MT9M131, they might as well work for
MT9P031, except if there is another issue with the latter. So it's worth a try.

Anyway, I will post my changes as an RFC in a few minutes.

Best regards,
Benoît
