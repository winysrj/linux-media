Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:50222 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932750Ab2IUJaa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Sep 2012 05:30:30 -0400
Date: Fri, 21 Sep 2012 11:30:24 +0200
From: Anatolij Gustschin <agust@denx.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>, dzu@denx.de
Subject: Re: [PATCH 2/3] mt9v022: fix the V4L2_CID_EXPOSURE control
Message-ID: <20120921113024.52133cf0@wker>
In-Reply-To: <Pine.LNX.4.64.1208241632130.20710@axis700.grange>
References: <1345799431-29426-1-git-send-email-agust@denx.de>
	<1345799431-29426-3-git-send-email-agust@denx.de>
	<Pine.LNX.4.64.1208241320330.20710@axis700.grange>
	<20120824161756.5cedec79@wker>
	<Pine.LNX.4.64.1208241632130.20710@axis700.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 24 Aug 2012 16:32:57 +0200 (CEST)
Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
...
> > > But why do we have to write it here at all then? Autoexposure can be off 
> > > only if the user has set exposure manually, using V4L2_CID_EXPOSURE_AUTO. 
> > > In this case MT9V022_TOTAL_SHUTTER_WIDTH already contains the correct 
> > > value. Why do we have to set it again? Maybe just adding a comment, 
> > > explaining the above, would suffice?
> > 
> > Actually we do not have to write it here, yes. Should I remove the shutter
> > register setting here entirely? And add a comment explaining, why?
> 
> Remove it from the "else" clause, yes, please. And a comment would be 
> good!

Ok, I'll resubmit a reworked patch.

Thanks,
Anatolij
