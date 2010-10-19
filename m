Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:56141 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247Ab0JSVl1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Oct 2010 17:41:27 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Bastian Hecht <hechtb@googlemail.com>
Subject: Re: OMAP 3530 ISP driver segfaults
Date: Tue, 19 Oct 2010 23:41:42 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <AANLkTikq8pmOpGn1N4xbiB2nmsNzrC4wzcD0_HUJpZ1J@mail.gmail.com> <201010151417.38508.laurent.pinchart@ideasonboard.com> <AANLkTi=Lck0P+YS3qX+aTK-g+jPmg3BkhHNoWOVXZcX9@mail.gmail.com>
In-Reply-To: <AANLkTi=Lck0P+YS3qX+aTK-g+jPmg3BkhHNoWOVXZcX9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010192341.42556.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Bastian,

On Monday 18 October 2010 10:58:02 Bastian Hecht wrote:
> 2010/10/15 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
> > Hi Bastian,
> > 
> > On Friday 15 October 2010 13:59:24 Bastian Hecht wrote:
> >> Hello ISP driver developers,
> >> 
> >> after the lastest pull of branch 'devel' of
> >> git://gitorious.org/maemo-multimedia/omap3isp-rx51 I get a segfault
> >> when I register my ISP_device.
> >> The segfault happens in isp.c in line
> >>      isp->iommu = iommu_get("isp");
> >> 
> >> I noticed that with the new kernel the module iommu is loaded
> >> automatically after booting while it wasn't in before my pull (my old
> >> pull is about 3 days old).
> >> Tell me what kind of further info you need. Btw, I run an Igepv2.
> > 
> > Can you make sure that both the omap-iommu and iommu2 modules are loaded
> > before omap3-isp.ko ?
> 
> Hello Laurent,
> 
> that did the trick! Don't get dependencies checked at load time? I mean
> undefined functions lead to load errors. I just want to learn to be prepared
> next time. So was it some data structure that gets properly initilized by
> iommu2 so that insmod cannot see the error?

Direct dependencies are handled at load time, but the IOMMU seems to need 
runtime dependencies as well. I haven't checked what happens in details yet. 
That's somewhere in my todo list :-)

> Thanks for enlightenment,

You're welcome.

-- 
Regards,

Laurent Pinchart
