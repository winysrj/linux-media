Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:31707 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755510Ab3HRO7O (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Aug 2013 10:59:14 -0400
Date: Sun, 18 Aug 2013 11:59:06 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: g.liakhovetski@gmx.de, linux-media@vger.kernel.org,
	magnus.damm@gmail.com, linux-sh@vger.kernel.org,
	phil.edworthy@renesas.com, matsu@igel.co.jp,
	vladimir.barinov@cogentembedded.com
Subject: Re: [PATCH v9] V4L2: soc_camera: Renesas R-Car VIN driver
Message-id: <20130818115906.6010a695@samsung.com>
In-reply-to: <5204063E.7050707@cogentembedded.com>
References: <201307260023.11460.sergei.shtylyov@cogentembedded.com>
 <5204063E.7050707@cogentembedded.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 09 Aug 2013 00:57:34 +0400
Sergei Shtylyov <sergei.shtylyov@cogentembedded.com> escreveu:

> Hello.
> 
> On 07/26/2013 12:23 AM, Sergei Shtylyov wrote:
> 
> > From: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
> 
> > Add Renesas R-Car VIN (Video In) V4L2 driver.
> 
> > Based on the patch by Phil Edworthy <phil.edworthy@renesas.com>.
> 
> > Signed-off-by: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
> > [Sergei: removed deprecated IRQF_DISABLED flag, reordered/renamed 'enum chip_id'
> > values, reordered rcar_vin_id_table[] entries,  removed senseless parens from
> > to_buf_list() macro, used ALIGN() macro in rcar_vin_setup(), added {} to the
> > *if* statement  and used 'bool' values instead of 0/1 where necessary, removed
> > unused macros, done some reformatting and clarified some comments.]
> > Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
> 
>     Guennadi, Mauro, if you don't have issues with this version, perhaps we 
> still can merge it to 3.11 using "the new drivers can't cause regressions, so 
> mergeable any time" rule?

AFAICT, while sometimes that happens, this is not a rule. The rule is to
merge new drivers during the merge window. What we during -rc is to accept
fix patches and even some updates for the new drivers merged at the very
latest merge window, as those won't cause regressions.

Anyway, IMO, we're too late at -rc cycle to propose this as an exception.

Regards,
Mauro

> 
> WBR, Sergei
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 

Cheers,
Mauro
