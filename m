Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:54495 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535AbbLXRds (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Dec 2015 12:33:48 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: hverkuil <hverkuil@xs4all.nl>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Aviv Greenberg <avivgr@gmail.com>,
	linux-media-owner@vger.kernel.org
Subject: Re: per-frame camera metadata (again)
Date: Thu, 24 Dec 2015 19:33:47 +0200
Message-ID: <1635284.ayChAxBmkc@avalon>
In-Reply-To: <86a64428cff3a4056742bb169de13e70@xs4all.nl>
References: <Pine.LNX.4.64.1512160901460.24913@axis700.grange> <4268557.IA99RCLRfS@avalon> <86a64428cff3a4056742bb169de13e70@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Thursday 24 December 2015 13:54:11 hverkuil wrote:
> On 2015-12-24 12:29, Laurent Pinchart wrote:
> >> Control classes are not deprecated, only the use of the control_class
> >> field in struct v4l2_ext_controls to limit the controls in the list to
> >> a single control class is deprecated. That old limitation was from pre-
> >> control-framework times to simplify driver design. With the creation
> >> of the control framework that limitation is no longer needed.
> > 
> > Doesn't that effectively deprecated control classes ? We can certainly
> > group controls in categories for documentation purposes, but the control
> > class as an API concept is quite useless nowadays.
> 
> No it's not. It is meant to be used by GUIs to group controls into tab
> pages or something similar. See qv4l2 or v4l2-ctl. It's very useful.

I guess I'll just keep disagreeing with you regarding whether the kernel 
should provide GUI hints then (cf. V4L2_CTRL_FLAG_SLIDER) :-)

-- 
Regards,

Laurent Pinchart

