Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:41095 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972Ab2IUJ2X (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Sep 2012 05:28:23 -0400
Date: Fri, 21 Sep 2012 11:28:03 +0200
From: Anatolij Gustschin <agust@denx.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>, dzu@denx.de
Subject: Re: [PATCH 3/3] mt9v022: set y_skip_top field to zero
Message-ID: <20120921112803.166fea4d@wker>
In-Reply-To: <Pine.LNX.4.64.1209111047410.22084@axis700.grange>
References: <1345799431-29426-1-git-send-email-agust@denx.de>
	<1345799431-29426-4-git-send-email-agust@denx.de>
	<Pine.LNX.4.64.1208241323030.20710@axis700.grange>
	<20120824153420.66806bf1@wker>
	<Pine.LNX.4.64.1209111047410.22084@axis700.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Tue, 11 Sep 2012 10:55:31 +0200 (CEST)
Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
...
> > > On what systems have you checked this?
> > 
> > On camera systems from ifm, both using mt9v022.
> 
> Ok, I agree, this was a hack in the beginning, and, probably, there was a 
> reason for the problem, that we've seen, that we didn't find a proper 
> solution to, but I wouldn't like to punish those systems now. The 
> y_skip_top field is only taken into account by the pxa driver, and there 
> is only one pxa270 system, using mt9v022: pcm990-baseboard.c. Could you, 
> please, add platform data to mt9v022 with only one parameter to initialise 
> y_skip_top, use 0 as default and set it to 1 on pcm990-baseboard.c?

Yes, I've reworked this patch as suggested and will resubmit.

Thanks,
Anatolij
