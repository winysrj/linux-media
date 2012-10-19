Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:45340 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752962Ab2JSOBU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Oct 2012 10:01:20 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Christoph Fritz <chf.fritz@googlemail.com>
Cc: =?ISO-8859-1?Q?Beno=EEt_Th=E9baudeau?=
	<benoit.thebaudeau@advansee.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Chris MacGregor <chris@cybermato.com>,
	linux-media@vger.kernel.org, Liu Ying <Ying.liu@freescale.com>,
	"Hans J. Koch" <hjk@hansjkoch.de>, Daniel Mack <daniel@zonque.org>
Subject: Re: hacking MT9P031 for i.mx
Date: Fri, 19 Oct 2012 16:02:05 +0200
Message-ID: <2206709.TsVZJRIWlG@avalon>
In-Reply-To: <20121017091406.GA5064@mars>
References: <2180583.3hl5tPmpSx@avalon> <135335921.6991961.1350421476631.JavaMail.root@advansee.com> <20121017091406.GA5064@mars>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Christoph,

On Wednesday 17 October 2012 11:14:06 Christoph Fritz wrote:
> On Tue, Oct 16, 2012 at 11:04:36PM +0200, Benoît Thébaudeau wrote:
> > On Tuesday, October 16, 2012 10:04:57 PM, Laurent Pinchart wrote:
> > > > Is there a current (kernel ~3.6) git tree which shows how to add
> > > > mt9p031 to platform code?
> > > 
> > > Yes, at
> > > http://git.linuxtv.org/pinchartl/media.git/shortlog/refs/heads/omap3isp-
> > > sensors-board
> 
> Thanks!
> 
> > > > I'm also curious if it's possible to glue mt9p031 to a freescale
> > > > i.mx35 platform. As far as I can see,
> > > > drivers/media/platform/soc_camera/mx3_camera.c would need
> > > > v4l2_subdev support?
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
> of time. When there is anything to test, I would be glad to do so.

Just to clarify the situation, I don't know when I'll have time to finish the 
patches, so if someone wants to take over please do (and CC me for review).

-- 
Regards,

Laurent Pinchart

