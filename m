Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:41256 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751926Ab1H2E56 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Aug 2011 00:57:58 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: "Valkeinen, Tomi" <tomi.valkeinen@ti.com>,
	Arnd Bergmann <arnd@arndb.de>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"JAIN, AMBER" <amber@ti.com>, "Taneja, Archit" <archit@ti.com>
Date: Mon, 29 Aug 2011 10:27:45 +0530
Subject: RE: VIDEO_OMAP2_VOUT broken
Message-ID: <19F8576C6E063C45BE387C64729E739404EC4CBA61@dbde02.ent.ti.com>
References: <10799840.E2KM4cQAaW@wuerfel>
 <CAP16SskCCQctOpsKthYN_hBOOB_5h=a4LH7-2w=DNxCQDE9vLQ@mail.gmail.com>
In-Reply-To: <CAP16SskCCQctOpsKthYN_hBOOB_5h=a4LH7-2w=DNxCQDE9vLQ@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> -----Original Message-----
> From: Valkeinen, Tomi
> Sent: Sunday, August 28, 2011 9:52 PM
> To: Arnd Bergmann
> Cc: linux-media@vger.kernel.org; JAIN, AMBER; Hiremath, Vaibhav; Taneja,
> Archit
> Subject: Re: VIDEO_OMAP2_VOUT broken
> 
> Hi Arnd,
> 
> On Sat, Aug 27, 2011 at 11:58 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > Hi Tomi,
> >
> > Apparently your patch 8cff88c5d "OMAP: DSS2: remove update_mode from
> omapdss"
> > broke building the omap_vout driver:
> 
> Yes, I didn't realize it affects v4l2, and I didn't have v4l2 enabled
> in the kernel. I have it now enabled by default =).
> 
> There was a patch posted to linux-omap and to linux-media by Archit
> some weeks ago which fixes the issue. I guess it hasn't gotten into
> mainline yet:
> 
> [PATCH] [media] OMAP_VOUT: Fix build break caused by update_mode removal
> in DSS2
> 
[Hiremath, Vaibhav] It's because of me.... I have already queued it in my branch but could not able to give pull request in time. 

Sorry for that, doing it now...

Thanks,
Vaibhav


>  Tomi
