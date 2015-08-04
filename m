Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:34889 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbbHDWHd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Aug 2015 18:07:33 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Josh Wu <josh.wu@atmel.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 0/4] atmel-isi: Remove platform data support
Date: Wed, 05 Aug 2015 01:08:19 +0300
Message-ID: <11161489.E6W8tYM4a4@avalon>
In-Reply-To: <55BED85D.4090905@atmel.com>
References: <1438420976-7899-1-git-send-email-laurent.pinchart@ideasonboard.com> <55BED85D.4090905@atmel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Josh,

On Monday 03 August 2015 10:56:29 Josh Wu wrote:
> On 8/1/2015 5:22 PM, Laurent Pinchart wrote:
> > Hello,
> > 
> > While reviewing patches for the atmel-isi I noticed a couple of small
> > issues with the driver. Here's a patch series to fix them, the main
> > change being the removal of platform data support now that all users have
> > migrated to DT.
>
> Thanks for the patches. It's perfectly make sense.
> 
> > The patches have been compile-tested only. Josh, would you be able to test
> > them on hardware ?
> 
> For the whole series, here is my:
> 
> Acked-by: Josh Wu <josh.wu@atmel.com>
> Tested-by: Josh Wu <josh.wu@atmel.com>

Thank you.

Do you plan to take those four patches in your tree and include them in your 
next pull request ?

> > Laurent Pinchart (4):
> >    v4l: atmel-isi: Simplify error handling during DT parsing
> >    v4l: atmel-isi: Remove unused variable
> >    v4l: atmel-isi: Remove support for platform data
> >    v4l: atmel-isi: Remove unused platform data fields
> >   
> >   drivers/media/platform/soc_camera/atmel-isi.c |  40 ++------
> >   drivers/media/platform/soc_camera/atmel-isi.h | 126 ++++++++++++++++++++
> >   include/media/atmel-isi.h                     | 131 --------------------
> >   3 files changed, 136 insertions(+), 161 deletions(-)
> >   create mode 100644 drivers/media/platform/soc_camera/atmel-isi.h
> >   delete mode 100644 include/media/atmel-isi.h

-- 
Regards,

Laurent Pinchart

