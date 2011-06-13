Return-path: <mchehab@pedra>
Received: from arroyo.ext.ti.com ([192.94.94.40]:40315 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750716Ab1FMEjt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jun 2011 00:39:49 -0400
Received: from dbdp20.itg.ti.com ([172.24.170.38])
	by arroyo.ext.ti.com (8.13.7/8.13.7) with ESMTP id p5D4dkXi019518
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sun, 12 Jun 2011 23:39:48 -0500
Received: from dbde70.ent.ti.com (localhost [127.0.0.1])
	by dbdp20.itg.ti.com (8.13.8/8.13.8) with ESMTP id p5D4djJL006455
	for <linux-media@vger.kernel.org>; Mon, 13 Jun 2011 10:09:45 +0530 (IST)
Message-ID: <4DF59642.8020703@ti.com>
Date: Mon, 13 Jun 2011 10:16:58 +0530
From: Archit Taneja <archit@ti.com>
MIME-Version: 1.0
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/2] OMAP_VOUT: Create separate file for VRFB related
 API's
References: <1306479677-23540-1-git-send-email-archit@ti.com> <1306479677-23540-3-git-send-email-archit@ti.com>
In-Reply-To: <1306479677-23540-3-git-send-email-archit@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Vaibhav,

On Friday 27 May 2011 12:31 PM, Taneja, Archit wrote:
> Introduce omap_vout_vrfb.c and omap_vout_vrfb.h, for all VRFB related API's,
> making OMAP_VOUT driver independent from VRFB. This is required for OMAP4 DSS,
> since OMAP4 doesn't have VRFB block.
>
> Added new enum vout_rotation_type and "rotation_type" member to omapvideo_info,
> this is initialized based on the arch type in omap_vout_probe. The rotation_type
> var is now used to choose between vrfb and non-vrfb calls.

Any comments on this patch?

<snip>

Thanks,
Archit
