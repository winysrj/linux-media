Return-path: <mchehab@gaivota>
Received: from arroyo.ext.ti.com ([192.94.94.40]:38464 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752531Ab0KSQHQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Nov 2010 11:07:16 -0500
From: "Aguirre, Sergio" <saaguirre@ti.com>
To: David Cohen <david.cohen@nokia.com>,
	ext Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: ext Lane Brooks <lane@brooks.nu>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Fri, 19 Nov 2010 10:07:09 -0600
Subject: [omap3isp] Prefered patch base for latest code? (was: "RE:
 Translation faults with OMAP ISP")
Message-ID: <A24693684029E5489D1D202277BE8944850C085C@dlee02.ent.ti.com>
References: <4CE16AA2.3000208@brooks.nu> <4CE686C9.6070902@brooks.nu>
 <20101119150620.GB11586@esdhcp04381.research.nokia.com>
 <201011191607.27568.laurent.pinchart@ideasonboard.com>
 <20101119151219.GC11586@esdhcp04381.research.nokia.com>
In-Reply-To: <20101119151219.GC11586@esdhcp04381.research.nokia.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi David and Laurent,

<snip>

> >
> > Don't forget that Lane is using an older version of the OMAP3 ISP
> driver. The
> > bug might have been fixed in the latest code.
> 
> Hm. We did fix some iommu faults.
> Maybe it's better to test a newer version instead.
> If you still see that bug using an up-to-date version, please report it
> and I can try to help you. :)

How close is this tree from the latest internal version you guys work with?

http://meego.gitorious.com/maemo-multimedia/omap3isp-rx51/commits/devel

I have been basing my patches on top of this tree:

http://git.linuxtv.org/pinchartl/media.git?h=refs/heads/media-0004-omap3isp

Would it be better to be based on the gitorious tree instead?

What do you think?

Regards,
Sergio

> 
> Regards,
> 
> David
> 
> >
> > --
> > Regards,
> >
> > Laurent Pinchart
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
