Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:36461 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863Ab0HTPbz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Aug 2010 11:31:55 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Aguirre, Sergio" <saaguirre@ti.com>
Subject: Re: [RFC/PATCH v3 00/10] Media controller (core and V4L2)
Date: Fri, 20 Aug 2010 17:31:54 +0200
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"sakari.ailus@maxwell.research.nokia.com"
	<sakari.ailus@maxwell.research.nokia.com>
References: <1280419616-7658-1-git-send-email-laurent.pinchart@ideasonboard.com> <201008201725.09455.laurent.pinchart@ideasonboard.com> <A24693684029E5489D1D202277BE89445719027D@dlee02.ent.ti.com>
In-Reply-To: <A24693684029E5489D1D202277BE89445719027D@dlee02.ent.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008201731.55959.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hi Sergio,

On Friday 20 August 2010 17:26:49 Aguirre, Sergio wrote:
> > -----Original Message-----
> > From: Laurent Pinchart [mailto:laurent.pinchart@ideasonboard.com]
> > Sent: Friday, August 20, 2010 10:25 AM

[snip]

> > On second thought, you're probably missing the V4L2 subdev device node
> > patches. b74c0aac357e5c71ee6de98b9887fe478bc73cf4 is very old (between
> > 2.6.29 and 2.6.30) and isn't related.
> 
> Ok..
> 
> But where can I find those? In what tree?
> 
> Sorry for the ignorance.

They have been posted to the linux-media list on 2010-07-12 under the subject 
"[RFC/PATCH v3 0/7] V4L2 subdev userspace API".

I will prepare a tree based on mainline with the media controller patches and 
the ISP driver.

-- 
Regards,

Laurent Pinchart
