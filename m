Return-path: <linux-media-owner@vger.kernel.org>
Received: from ftp.meprolight.com ([194.90.149.17]:41949 "EHLO meprolight.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750941Ab1LJRJi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Dec 2011 12:09:38 -0500
From: Alex Gershgorin <alexg@meprolight.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Sakari Ailus <sakari.ailus@iki.fi>,
	"Hiroshi.DOYU@nokia.com" <Hiroshi.DOYU@nokia.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Sat, 10 Dec 2011 19:10:06 +0200
Subject: RE: OMAP3ISP boot problem
Message-ID: <4875438356E7CA4A8F2145FCD3E61C0B2C8989924A@MEP-EXCH.meprolight.com>
References: <4875438356E7CA4A8F2145FCD3E61C0B2C8989923C@MEP-EXCH.meprolight.com>
	<4EE32299.5000006@iki.fi>
	<4875438356E7CA4A8F2145FCD3E61C0B2C89899246@MEP-EXCH.meprolight.com>,<201112101545.40059.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201112101545.40059.laurent.pinchart@ideasonboard.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi Alex,

On Saturday 10 December 2011 14:36:17 Alex Gershgorin wrote:
> > Hi Sakari,
> >
> > Thank you for your quick response and sorry for stupid question.
> > Yes CONFIG_OMAP_IOMMU and CONFIG_OMAP_IOVMM enabled,
> > because OMAP 3 camera controller depends on the CONFIG_OMAP_IOVMM  and
> > CONFIG_OMAP_IOMMU. Please tell me how I can use dmabuf instead of the
> > IOMMU/IOVMM API.
> >
> >Unfortunately that real fix isn't available yet and won't be for some
> >time. Still, it should be fully functional currently.
> >
> >Looking at the backtrace again, it seems to crash in
> >driver_find_device(). That looks fishy.
> >
> >Do you have the ISP driver compiled into the kernel? I might try it as a
> >module, albeit it of course should work when it's linked to the kernel
> >as well.
>
> Yes ISP driver compiled into kernel, but if I back to previos version of
> the Linux kernel  3.0.0, that works well. Here part of kernel boot
> message...
>
> > [    2.063354] Linux media interface: v0.10
> > [    2.068298] Linux video capture interface: v2.00
> > [    2.075561] omap3isp omap3isp: Revision 2.0 found
> > [    2.080932] omap-iommu omap-iommu.0: isp: version 1.1
> > [    2.099365] Camera Video probed
> > [    2.115997] vivi-000: V4L2 device registered as video7
>
> Now I plan to start  using a newer version of the Linux kernel 3.2.0-rc4,
> but unfortunately faced with the problem. That suggest?

I'm quite surprised. I've just tested 3.2-rc2 here, and got no oops when
loading the omap3-isp driver. I've tried compiling the driver in the kernel
and as a module, and both succeeded. I've pushed my code to
http://git.linuxtv.org/pinchartl/media.git/shortlog/refs/heads/omap3isp-
sensors-board if you want to give it a try.

Thanks Laurent,

Tomorrow I'll try to test on Hardware that I have with using kernel 3.2-rc2
and Tell you about my results.

Regards,
Alex Gershgorin