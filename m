Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:35225 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbbDCDfE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Apr 2015 23:35:04 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [GIT PULL FOR v4.1] Xilinx video pipeline drivers
Date: Fri, 03 Apr 2015 06:35:24 +0300
Message-ID: <7891878.7iJW7C1edu@avalon>
In-Reply-To: <20150403001522.50874cc1@recife.lan>
References: <5245308.M2sog0XFbh@avalon> <20150403001522.50874cc1@recife.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Friday 03 April 2015 00:15:22 Mauro Carvalho Chehab wrote:
> Em Wed, 11 Mar 2015 22:47:37 +0200 Laurent Pinchart escreveu:
> > Hi Mauro,
> > 
> > The following changes since commit 
ae3da40179c66001afad608f972bdb57d50d1e66:
> >   v4l2-subdev: remove enum_framesizes/intervals (2015-03-06 10:01:44
> >   +0100)
> > 
> > are available in the git repository at:
> >   git://linuxtv.org/pinchartl/media.git xilinx
> > 
> > for you to fetch changes up to 5fc7561dba773afd95169aba32f53a01facaf22a:
> >   v4l: xilinx: Add Test Pattern Generator driver (2015-03-11 22:43:48
> >   +0200)
> > 
> > Please note that the series depends and is based on Hans' for-v4.1g branch
> > for which he has sent a pull request.
> 
> This didn't merge ok. Not sure if "for-v4.1g" branch was merged or not, but
> I merged already all pending requests from Hans, leaving this one to the
> end.

Weird. I've rebased my branch on top of linuxtv master and got no conflict.

> Could you please check if what you need is already there and rebase your
> work?

Done, and pushed to

	git://linuxtv.org/pinchartl/media.git xilinx

-- 
Regards,

Laurent Pinchart

