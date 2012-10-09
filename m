Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:60809 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754392Ab2JIKcp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Oct 2012 06:32:45 -0400
Date: Tue, 9 Oct 2012 12:32:40 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Anatolij Gustschin <agust@denx.de>
cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v2 1/3] mt9v022: add v4l2 controls for blanking
In-Reply-To: <20121006130017.2f95b740@wker>
Message-ID: <Pine.LNX.4.64.1210091231470.21518@axis700.grange>
References: <1345799431-29426-2-git-send-email-agust@denx.de>
 <1348783425-22934-1-git-send-email-agust@denx.de> <20121006130017.2f95b740@wker>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 6 Oct 2012, Anatolij Gustschin wrote:

> Hi Guennadi,
> 
> On Fri, 28 Sep 2012 00:03:45 +0200
> Anatolij Gustschin <agust@denx.de> wrote:
> 
> > Add controls for horizontal and vertical blanking. Also add an error
> > message for case that the control handler init failed. Since setting
> > the blanking registers is done by controls now, we shouldn't change
> > these registers outside of the control function. Use v4l2_ctrl_s_ctrl()
> > to set them.
> > 
> > Signed-off-by: Anatolij Gustschin <agust@denx.de>
> > ---
> > Changes since first version:
> >  - drop analog and reg32 setting controls
> >  - use more descriptive error message for handler init error
> >  - revise commit log
> >  - rebase on staging/for_v3.7 branch
> > 
> >  drivers/media/i2c/soc_camera/mt9v022.c |   49 +++++++++++++++++++++++++++++--
> >  1 files changed, 45 insertions(+), 4 deletions(-)
> 
> Can these mt9v022 patches be queued for mainlining, please?

Sure, so far I'm collecting patches to be queued for 3.8.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
