Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:45022 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754405Ab0HSTMQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Aug 2010 15:12:16 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Aguirre, Sergio" <saaguirre@ti.com>
Subject: Re: [RFC/PATCH v3 00/10] Media controller (core and V4L2)
Date: Thu, 19 Aug 2010 21:12:12 +0200
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"sakari.ailus@maxwell.research.nokia.com"
	<sakari.ailus@maxwell.research.nokia.com>
References: <1280419616-7658-1-git-send-email-laurent.pinchart@ideasonboard.com> <A24693684029E5489D1D202277BE89445718FC0B@dlee02.ent.ti.com>
In-Reply-To: <A24693684029E5489D1D202277BE89445718FC0B@dlee02.ent.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008192112.12673.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hi Sergio,

On Thursday 19 August 2010 21:09:30 Aguirre, Sergio wrote:
> > -----Original Message-----
> > From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> > owner@vger.kernel.org] On Behalf Of Laurent Pinchart
> > Sent: Thursday, July 29, 2010 11:07 AM
> > To: linux-media@vger.kernel.org
> > Cc: sakari.ailus@maxwell.research.nokia.com
> > Subject: [RFC/PATCH v3 00/10] Media controller (core and V4L2)
> > 
> > Hi everybody,
> > 
> > Here's the third version of the media controller patches. All comments
> > received on the first and second versions have (hopefully) been
> > incorporated.
> > 
> > The rebased V4L2 API additions and OMAP3 ISP patches will follow. Once
> > again please consider them as sample code only.
> > 
> > Laurent Pinchart (8):
> >   media: Media device node support
> >   media: Media device
> >   media: Entities, pads and links
> >   media: Entities, pads and links enumeration
> >   media: Links setup
> >   v4l: Add a media_device pointer to the v4l2_device structure
> >   v4l: Make video_device inherit from media_entity
> >   v4l: Make v4l2_subdev inherit from media_entity
> 
> This patch (#0010) doesn't apply to mainline, after this commit:
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h
> =b74c0aac357e5c71ee6de98b9887fe478bc73cf4
> 
> Am I missing something here?

Yes, you're missing the next version of the patches :-) I'll probably send 
them tomorrow.

-- 
Regards,

Laurent Pinchart
