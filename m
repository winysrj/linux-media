Return-path: <mchehab@pedra>
Received: from mail.meprolight.com ([194.90.149.17]:39343 "EHLO meprolight.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756853Ab1F1Htx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jun 2011 03:49:53 -0400
From: Alex Gershgorin <alexg@meprolight.com>
To: "'Laurent Pinchart'" <laurent.pinchart@ideasonboard.com>
CC: "'Sakari Ailus'" <sakari.ailus@iki.fi>,
	Michael Jones <michael.jones@matrix-vision.de>,
	"'linux-media@vger.kernel.org'" <linux-media@vger.kernel.org>,
	"'agersh@rambler.ru'" <agersh@rambler.ru>
Date: Tue, 28 Jun 2011 10:47:07 +0300
Subject: RE: FW: OMAP 3 ISP
Message-ID: <4875438356E7CA4A8F2145FCD3E61C0B2A5D211E3D@MEP-EXCH.meprolight.com>
In-Reply-To: <201105251201.57902.laurent.pinchart@ideasonboard.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Laurent,

I recently got the Zoom OMAP35xx Torpedo and began testing OMAP3ISP.
Currently I have a problem I can't solve.
See Message from booting Kernel:

Linux media interface: v0.10
Linux video capture interface: v2.00
omap3isp omap3isp: Revision 2.0 found
omap-iommu omap-iommu.0: isp: version 1.1
isp_register_subdev_group: Unable to register subdev

What could be the problem, why sub device can't pass a registration?

Thanks,

Alex Gershgorin


-----Original Message-----
From: Laurent Pinchart [mailto:laurent.pinchart@ideasonboard.com] Sent: Wednesday, May 25, 2011 1:02 PM
To: Alex Gershgorin
Cc: 'Sakari Ailus'; Michael Jones; 'linux-media@vger.kernel.org'; 'agersh@rambler.ru'
Subject: Re: FW: OMAP 3 ISP

Hi Alex,

On Wednesday 25 May 2011 11:58:58 Alex Gershgorin wrote:
> Hi Laurent,
>
> Unfortunately, at this point I have no Hardware platforms, but in the
> next week we should get Zoom OMAP35 Torpedo evaluation kit
> and then I can test it.
>
> I have already applied this patch on the last main line
> Kernel version (2.6.39) and continue to work on the platform device for
> Zoom OMAP35xx Torpedo.
>
> Thanks for this patch :-)

You're welcome. Please let me know if it works for you when you'll receive the
hardware. I will then push the patch to mainline.

--
Regards,

Laurent Pinchart


__________ Information from ESET NOD32 Antivirus, version of virus signature database 6149 (20110524) __________

The message was checked by ESET NOD32 Antivirus.

http://www.eset.com



__________ Information from ESET NOD32 Antivirus, version of virus signature database 6245 (20110627) __________

The message was checked by ESET NOD32 Antivirus.

http://www.eset.com

