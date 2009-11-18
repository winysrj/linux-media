Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:42736 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753663AbZKRM4p (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Nov 2009 07:56:45 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Aguirre, Sergio" <saaguirre@ti.com>
Subject: Re: [PATCH/RFC] V4L core cleanups
Date: Wed, 18 Nov 2009 13:57:11 +0100
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"hverkuil@xs4all.nl" <hverkuil@xs4all.nl>,
	"mchehab@infradead.org" <mchehab@infradead.org>,
	"sakari.ailus@maxwell.research.nokia.com"
	<sakari.ailus@maxwell.research.nokia.com>
References: <1258504731-8430-1-git-send-email-laurent.pinchart@ideasonboard.com> <A24693684029E5489D1D202277BE89444D9BCA5A@dlee02.ent.ti.com>
In-Reply-To: <A24693684029E5489D1D202277BE89444D9BCA5A@dlee02.ent.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911181357.11459.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sergio,

On Wednesday 18 November 2009 02:31:23 Aguirre, Sergio wrote:
> Laurent,
> 
> > -----Original Message-----
> > From: linux-media-owner@vger.kernel.org
> > [mailto:linux-media-owner@vger.kernel.org] On Behalf Of
> > Laurent Pinchart
> > Sent: Tuesday, November 17, 2009 6:39 PM
> > To: linux-media@vger.kernel.org
> > Cc: hverkuil@xs4all.nl; mchehab@infradead.org;
> > sakari.ailus@maxwell.research.nokia.com
> > Subject: [PATCH/RFC] V4L core cleanups
> >
> > Hi everybody,
> >
> > this patch sets attemp to clean up the V4L core to remove the
> > video_device::minor and video_device::num references in most drivers.
> 
> I think you're missing usual subject prefix: [PATCH #/total]

The patches were sent using git send-email on a quilt series. It turns out git 
send-email doesn't add the usual subject prefix, I'll make sure I add it 
manually next time.

> Unless all patches are independent from eachother, which is something
> I'll hardly believe.

-- 
Regards,

Laurent Pinchart
