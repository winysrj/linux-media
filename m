Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:52571 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751420Ab1H1QWR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Aug 2011 12:22:17 -0400
Received: by gwj20 with SMTP id 20so5474180gwj.12
        for <linux-media@vger.kernel.org>; Sun, 28 Aug 2011 09:22:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <10799840.E2KM4cQAaW@wuerfel>
References: <10799840.E2KM4cQAaW@wuerfel>
Date: Sun, 28 Aug 2011 19:22:15 +0300
Message-ID: <CAP16SskCCQctOpsKthYN_hBOOB_5h=a4LH7-2w=DNxCQDE9vLQ@mail.gmail.com>
Subject: Re: VIDEO_OMAP2_VOUT broken
From: "Valkeinen, Tomi" <tomi.valkeinen@ti.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-media@vger.kernel.org, Amber Jain <amber@ti.com>,
	Vaibhav Hiremath <hvaibhav@ti.com>,
	Archit Taneja <archit@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arnd,

On Sat, Aug 27, 2011 at 11:58 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> Hi Tomi,
>
> Apparently your patch 8cff88c5d "OMAP: DSS2: remove update_mode from omapdss"
> broke building the omap_vout driver:

Yes, I didn't realize it affects v4l2, and I didn't have v4l2 enabled
in the kernel. I have it now enabled by default =).

There was a patch posted to linux-omap and to linux-media by Archit
some weeks ago which fixes the issue. I guess it hasn't gotten into
mainline yet:

[PATCH] [media] OMAP_VOUT: Fix build break caused by update_mode removal in DSS2

 Tomi
