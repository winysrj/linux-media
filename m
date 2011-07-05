Return-path: <mchehab@pedra>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:4822 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753759Ab1GEGq2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Jul 2011 02:46:28 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFC] DV timings spec fixes at V4L2 API - was: [PATCH 1/8] v4l: add macro for 1080p59_54 preset
Date: Tue, 5 Jul 2011 08:46:18 +0200
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com
References: <1309351877-32444-1-git-send-email-t.stanislaws@samsung.com> <4E11E5AE.30304@redhat.com> <201107050047.44275.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201107050047.44275.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201107050846.18443.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tuesday, July 05, 2011 00:47:43 Laurent Pinchart wrote:
> Hi Mauro,
> 
> On Monday 04 July 2011 18:09:18 Mauro Carvalho Chehab wrote:
> 
> [snip]
> 
> > 1) PRESET STANDARDS
> >    ====== =========
> > 
> > There are 3 specs involved with DV presets: ITU-R BT 709 and BT 1120 and
> > CEA 861.
> > 
> > At ITU-R BT.709, both 60Hz and 60/1.001 Hz are equally called as "60 Hz".
> > BT.1120 follows the same logic, as it uses BT.709 as a reference for video
> > timings.
> > 
> > The CEA-861-E spec says at item 4, that:
> 
> [snip]
> 
> > At the same item, the table 2 describes several video parameters for each
> > preset, associating the Video Identification Codes (VIC) for each preset.
> 
> This might be a bit out of scope, but why aren't we using the VICs as DV 
> presets ?

The VIC does more than just set the timings. It also determines the pixel
aspect ratio. So exactly the same video timings may have two VICs, the only
difference being the pixel aspect which is *not* part of the timings. The VIC
is part of the AVI InfoFrame, however.

So VIC != timings.

Regards,

	Hans
