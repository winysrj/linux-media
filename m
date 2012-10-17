Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:52079 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756423Ab2JQJOP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Oct 2012 05:14:15 -0400
Received: by mail-bk0-f46.google.com with SMTP id jk13so3435465bkc.19
        for <linux-media@vger.kernel.org>; Wed, 17 Oct 2012 02:14:14 -0700 (PDT)
Date: Wed, 17 Oct 2012 11:14:06 +0200
From: Christoph Fritz <chf.fritz@googlemail.com>
To: =?iso-8859-1?Q?Beno=EEt_Th=E9baudeau?=
	<benoit.thebaudeau@advansee.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Chris MacGregor <chris@cybermato.com>,
	linux-media@vger.kernel.org, Liu Ying <Ying.liu@freescale.com>,
	"Hans J. Koch" <hjk@hansjkoch.de>, Daniel Mack <daniel@zonque.org>
Subject: Re: hacking MT9P031 for i.mx
Message-ID: <20121017091406.GA5064@mars>
References: <2180583.3hl5tPmpSx@avalon>
 <135335921.6991961.1350421476631.JavaMail.root@advansee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <135335921.6991961.1350421476631.JavaMail.root@advansee.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Oct 16, 2012 at 11:04:36PM +0200, Benoît Thébaudeau wrote:
> On Tuesday, October 16, 2012 10:04:57 PM, Laurent Pinchart wrote:
> > > Is there a current (kernel ~3.6) git tree which shows how to add
> > > mt9p031
> > > to platform code?
> > 
> > Yes, at
> > http://git.linuxtv.org/pinchartl/media.git/shortlog/refs/heads/omap3isp-
> > sensors-board

Thanks!

> > > I'm also curious if it's possible to glue mt9p031 to a freescale
> > > i.mx35
> > > platform. As far as I can see,
> > > drivers/media/platform/soc_camera/mx3_camera.c would need
> > > v4l2_subdev
> > > support?
> 
> I have not followed this thread, so I don't know exactly your
> issue, but FYI I have an MT9M131 (of which the driver should
> hopefully be close to the MT9P031's) working on i.MX35 with Linux
> 3.4.

I have here a mt9p031-testing-board with an i.MX35 interface. So I'm
pretty interested in soc_camera support for mt9p031.

Laurent is already fixing this but haven't finished due to lack
of time.  When there is anything to test, I would be glad to do so.


Best regards
 -- Christoph
