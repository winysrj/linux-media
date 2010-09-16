Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:35308 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497Ab0IPJEW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Sep 2010 05:04:22 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [RFC/PATCH v4 08/11] media: Links setup
Date: Thu, 16 Sep 2010 11:04:23 +0200
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
References: <1282318153-18885-1-git-send-email-laurent.pinchart@ideasonboard.com> <1282318153-18885-9-git-send-email-laurent.pinchart@ideasonboard.com> <4C883504.50804@redhat.com>
In-Reply-To: <4C883504.50804@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009161104.24138.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

On Thursday 09 September 2010 03:14:44 Mauro Carvalho Chehab wrote:
> Em 20-08-2010 12:29, Laurent Pinchart escreveu:
> > Create the following ioctl and implement it at the media device level to
> > setup links.
> > 
> > - MEDIA_IOC_SETUP_LINK: Modify the properties of a given link
> > 
> > The only property that can currently be modified is the ACTIVE link flag
> > to activate/deactivate a link. Links marked with the IMMUTABLE link flag
> > can not be activated or deactivated.
> > 
> > Activating and deactivating a link has effects on entities' use count.
> > Those changes are automatically propagated through the graph.
> 
> You need to address here the release() call: if the userspace application
> dies or just exits, the device should be set into a sane state, e. g.
> devices powered on should be turned off,

That's already handled, as media_entity_put() is called in the vdev and subdev 
release() functions.

> and links activated by the application should be de-activated.

I don't think that's required. When an application exits with a video device 
node open, we don't reset all controls and formats. Power needs to be turned 
off and resources need to be released on exit, but configuration doesn't need 
to be reset.

-- 
Regards,

Laurent Pinchart
