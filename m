Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:59492
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752852AbdDKNeP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Apr 2017 09:34:15 -0400
Date: Tue, 11 Apr 2017 10:34:09 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Subject: Re: [PATCHv4 04/15] v4l: vsp1: Add histogram support
Message-ID: <20170411103409.18a4df98@vento.lan>
In-Reply-To: <a95e3ae3-de87-5ce4-cc68-4cda449d2fe3@xs4all.nl>
References: <20170410192651.18486-1-hverkuil@xs4all.nl>
        <20170410192651.18486-5-hverkuil@xs4all.nl>
        <20170411081728.4df93852@vento.lan>
        <a95e3ae3-de87-5ce4-cc68-4cda449d2fe3@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 11 Apr 2017 15:27:12 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 04/11/17 13:17, Mauro Carvalho Chehab wrote:
> > Em Mon, 10 Apr 2017 21:26:40 +0200
> > Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> >   
> >> From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> >>
> >> The histogram common code will be used to implement support for both the
> >> HGO and HGT histogram computation engines.
> >>
> >> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> >> ---
> >>  drivers/media/platform/Kconfig           |   1 +
> >>  drivers/media/platform/vsp1/Makefile     |   1 +
> >>  drivers/media/platform/vsp1/vsp1_histo.c | 646 +++++++++++++++++++++++++++++++
> >>  drivers/media/platform/vsp1/vsp1_histo.h |  84 ++++
> >>  4 files changed, 732 insertions(+)
> >>  create mode 100644 drivers/media/platform/vsp1/vsp1_histo.c
> >>  create mode 100644 drivers/media/platform/vsp1/vsp1_histo.h  
> >   
> >> diff --git a/drivers/media/platform/vsp1/vsp1_histo.c b/drivers/media/platform/vsp1/vsp1_histo.c
> >> new file mode 100644
> >> index 000000000000..afab77cf4fa5
> >> --- /dev/null
> >> +++ b/drivers/media/platform/vsp1/vsp1_histo.c  
> > 
> > ...
> >   
> >> +	crop = vsp1_entity_get_pad_selection(&histo->entity, config, sel->pad,
> >> +					     V4L2_SEL_TGT_CROP);
> >> +
> >> +	/*
> >> +	 * Clamp the width and height to acceptable values first and then
> >> +	 * compute the closest rounded dividing ratio.
> >> +	 *
> >> +	 * Ratio	Rounded ratio
> >> +	 * --------------------------
> >> +	 * [1.0 1.5[	1  
> > 
> > Nitpick:
> > 
> > 	1.0 1.5]	1  
> 
> No, the notation [a b[ means the range 'a to, but not including, b'.
> 
> So this is correct.
> 
> I'm used to writing this as [a b), but according to wikipedia both notations
> are allowed.

Ah! Yeah, it occurred to me that it could be using such notation from
set theory, but as all the other ranges there were using [a b], I
assumed it was a typo.

> 
> Regards,
> 
> 	Hans
> 
> > 
> > Thanks,
> > Mauro
> >   
> 



Thanks,
Mauro
