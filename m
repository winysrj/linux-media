Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:59683 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572Ab2IKIzg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Sep 2012 04:55:36 -0400
Date: Tue, 11 Sep 2012 10:55:31 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Anatolij Gustschin <agust@denx.de>
cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>, dzu@denx.de
Subject: Re: [PATCH 3/3] mt9v022: set y_skip_top field to zero
In-Reply-To: <20120824153420.66806bf1@wker>
Message-ID: <Pine.LNX.4.64.1209111047410.22084@axis700.grange>
References: <1345799431-29426-1-git-send-email-agust@denx.de>
 <1345799431-29426-4-git-send-email-agust@denx.de>
 <Pine.LNX.4.64.1208241323030.20710@axis700.grange> <20120824153420.66806bf1@wker>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 24 Aug 2012, Anatolij Gustschin wrote:

> On Fri, 24 Aug 2012 13:23:22 +0200 (CEST)
> Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> 
> > On Fri, 24 Aug 2012, Anatolij Gustschin wrote:
> > 
> > > Set "y_skip_top" to zero and remove comment as I do not see this
> > > line corruption on two different mt9v022 setups. The first read-out
> > > line is perfectly fine.
> > 
> > On what systems have you checked this?
> 
> On camera systems from ifm, both using mt9v022.

Ok, I agree, this was a hack in the beginning, and, probably, there was a 
reason for the problem, that we've seen, that we didn't find a proper 
solution to, but I wouldn't like to punish those systems now. The 
y_skip_top field is only taken into account by the pxa driver, and there 
is only one pxa270 system, using mt9v022: pcm990-baseboard.c. Could you, 
please, add platform data to mt9v022 with only one parameter to initialise 
y_skip_top, use 0 as default and set it to 1 on pcm990-baseboard.c?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
