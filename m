Return-path: <mchehab@pedra>
Received: from devils.ext.ti.com ([198.47.26.153]:58125 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716Ab1FMEoC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jun 2011 00:44:02 -0400
Received: from dbdp20.itg.ti.com ([172.24.170.38])
	by devils.ext.ti.com (8.13.7/8.13.7) with ESMTP id p5D4hwLj022718
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sun, 12 Jun 2011 23:44:00 -0500
Received: from dbde70.ent.ti.com (localhost [127.0.0.1])
	by dbdp20.itg.ti.com (8.13.8/8.13.8) with ESMTP id p5D4hvP3007299
	for <linux-media@vger.kernel.org>; Mon, 13 Jun 2011 10:13:58 +0530 (IST)
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: "Taneja, Archit" <archit@ti.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Mon, 13 Jun 2011 10:13:56 +0530
Subject: RE: [PATCH 2/2] OMAP_VOUT: Create separate file for VRFB related
 API's
Message-ID: <19F8576C6E063C45BE387C64729E739404E2EEFCAA@dbde02.ent.ti.com>
References: <1306479677-23540-1-git-send-email-archit@ti.com>
 <1306479677-23540-3-git-send-email-archit@ti.com> <4DF59642.8020703@ti.com>
In-Reply-To: <4DF59642.8020703@ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


> -----Original Message-----
> From: Taneja, Archit
> Sent: Monday, June 13, 2011 10:17 AM
> To: Hiremath, Vaibhav
> Cc: linux-media@vger.kernel.org
> Subject: Re: [PATCH 2/2] OMAP_VOUT: Create separate file for VRFB related
> API's
> 
> Hi Vaibhav,
> 
> On Friday 27 May 2011 12:31 PM, Taneja, Archit wrote:
> > Introduce omap_vout_vrfb.c and omap_vout_vrfb.h, for all VRFB related
> API's,
> > making OMAP_VOUT driver independent from VRFB. This is required for
> OMAP4 DSS,
> > since OMAP4 doesn't have VRFB block.
> >
> > Added new enum vout_rotation_type and "rotation_type" member to
> omapvideo_info,
> > this is initialized based on the arch type in omap_vout_probe. The
> rotation_type
> > var is now used to choose between vrfb and non-vrfb calls.
> 
> Any comments on this patch?
> 
Archit,

Last week I had to park this due to some high priority issue, today I am going to validate these patches and will respond you. 
Code implementation point of view, this patch looks ok. And I believe you will incorporate my comments on first patch.

Thanks,
Vaibhav

> <snip>
> 
> Thanks,
> Archit
