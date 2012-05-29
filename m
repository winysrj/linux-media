Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:35260 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395Ab2E2KWU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 May 2012 06:22:20 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Enrico <ebutera@users.berlios.de>
Cc: jean-philippe francois <jp.francois@cynove.com>,
	Alex Gershgorin <alexg@meprolight.com>,
	Ritesh <yuva_dashing@yahoo.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: FW: OMAP 3 ISP
Date: Tue, 29 May 2012 12:22:39 +0200
Message-ID: <12509952.dDkgsjd7gb@avalon>
In-Reply-To: <CA+2YH7s9F+4WQuQ9zioCetpJ5f8_3pihf5wcNVp5SjLuiq3k3g@mail.gmail.com>
References: <B9D34818-CE30-4125-997B-71C50CFC4F0D@yahoo.com> <CAGGh5h13ks+yN44OJvFogjj9jWr9HeN7_OzE2Aob9T2n3e9nMA@mail.gmail.com> <CA+2YH7s9F+4WQuQ9zioCetpJ5f8_3pihf5wcNVp5SjLuiq3k3g@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Enrico,

On Tuesday 29 May 2012 12:08:43 Enrico wrote:
> On Tue, May 29, 2012 at 10:15 AM, jean-philippe francois wrote:
> > 2012/5/29 Alex Gershgorin <alexg@meprolight.com>:
> >> Hi Ritesh,
> >> 
> >> Please send in the future CC to laurent.pinchart@ideasonboard.com and
> >> linux-media@vger.kernel.org>> 
> >>> Hi Alex,
> >>> I also started working with OMAP35x torpedo kit, I successful compile
> >>> Linux 3.0 and ported on the board. Device is booting correctly but
> >>> probe function in omap3isp module not getting called. Please help me
> >> 
> >> You have relevant Kernel boot messages?
> >> You can also find information in media archives OMAP 3 ISP thread.
> >> 
> >> Regards,
> >> Alex
> > 
> > Hi, I had a similar problem with a 2.6.39 kernel, that was solved with
> > a 3.2 kernel.
> > When compiled as a module, the probe function was called, but was failing
> > later.
> > 
> > The single message I would see was "ISP revision x.y found" [1]
> > 
> > When compiled in the kernel image, everything was fine.
> > 
> > 
> > [1]
> > http://lxr.linux.no/linux+v2.6.39.4/drivers/media/video/omap3isp/isp.c#L2
> > 103
> I think with kernel version 3.0 i had the same problem, i had to
> modprobe iommu2 before omap3isp, removing (if already loaded) iommu.
> Probably later on it was fixed and you don't need that anymore.

That's right. The OMAP3 ISP driver indirectly depended on the iommu2 module, 
which wasn't loaded automatically. Nowadays OMAP IOMMU support is a boolean 
option, so it will get compiled in the kernel directly.

-- 
Regards,

Laurent Pinchart

