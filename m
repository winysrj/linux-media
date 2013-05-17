Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:50624 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755380Ab3EQVEx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 May 2013 17:04:53 -0400
Date: Fri, 17 May 2013 23:04:45 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
cc: mchehab@redhat.com, linux-media@vger.kernel.org,
	magnus.damm@gmail.com, linux-sh@vger.kernel.org,
	phil.edworthy@renesas.com, matsu@igel.co.jp,
	vladimir.barinov@cogentembedded.com
Subject: Re: [PATCH v4] V4L2: soc_camera: Renesas R-Car VIN driver
In-Reply-To: <519698D8.7050107@cogentembedded.com>
Message-ID: <Pine.LNX.4.64.1305172259500.5515@axis700.grange>
References: <201305150256.36966.sergei.shtylyov@cogentembedded.com>
 <Pine.LNX.4.64.1305150742470.10596@axis700.grange> <519698D8.7050107@cogentembedded.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 18 May 2013, Sergei Shtylyov wrote:

> Hello.
> 
> On 05/15/2013 09:44 AM, Guennadi Liakhovetski wrote:
> 
> > 
> > > From: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
> > > 
> > > Add Renesas R-Car VIN (Video In) V4L2 driver.
> > > 
> > > Based on the patch by Phil Edworthy <phil.edworthy@renesas.com>.
> > > 
> > > Signed-off-by: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
> > > [Sergei: removed deprecated IRQF_DISABLED flag, reordered/renamed 'enum
> > > chip_id'
> > > values, reordered rcar_vin_id_table[] entries,  removed senseless parens
> > > from
> > > to_buf_list() macro, used ALIGN() macro in rcar_vin_setup(), added {} to
> > > the
> > > *if* statement  and  used 'bool' values instead of 0/1 where necessary,
> > > done
> > > some reformatting and clarified some comments.]
> > > Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
> > > 
> > > ---
> > > This patch is against the 'media_tree.git' repo.
> > > 
> > > Changes since version 3:
> > Why aren't you using this:
> > 
> > http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/63820
> > 
> > ?
> > 
> > Thanks
> > Guennadi
> 
>     We have now incorporated the needed changes and I will post the updated
> patch.
> I must note that you haven't managed to get rid of all CEU references in the
> shared
> soc_scale_crop.c module, both in the variable names and in the comments.

Ok, I'll try to remember this and prepare an improved v2. Otherwise you're 
welcome to suggest an improvement. As long as those "ceu" occurrences 
aren't exposed in the API, it shouldn't affect users though.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
