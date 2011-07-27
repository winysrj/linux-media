Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44444 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754205Ab1G0JTt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jul 2011 05:19:49 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: Camera Support
Date: Wed, 27 Jul 2011 11:19:47 +0200
Cc: Sriram V <vshrirama@gmail.com>, linux-media@vger.kernel.org
References: <CAH9_wRMO_xhmgbBDT1c6Cft8-R=+PSHnYjxjdUpe50_=-1M22g@mail.gmail.com> <20110726194338.GG32629@valkosipuli.localdomain>
In-Reply-To: <20110726194338.GG32629@valkosipuli.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107271119.48085.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 26 July 2011 21:43:38 Sakari Ailus wrote:
> On Wed, Jul 27, 2011 at 12:53:44AM +0530, Sriram V wrote:
> > Hi,
> > 
> >   OMAP3 ISP Supports 2 camera ports (csi and parallel) Does the
> > 
> > existing ISP drivers
> > 
> >   support both of them at the same time.
> 
> As far as I can see, the answer is yes. However, the CCDC block implements
> the parallel receiver, so the image processing functions of the ISP
> wouldn't be available for the data received from the CSI(2) receiver when
> the parallel interface is in use.

Don't the parallel and serial interfaces share some pins ?

Please also note that serial receivers are not available on the 
OMAP35x/DM37xx. They're only available (at least according to TI) on the 
OMAP34xx/OMAP36xx.

-- 
Regards,

Laurent Pinchart
