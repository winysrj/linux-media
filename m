Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:3032 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757470Ab3DSK31 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Apr 2013 06:29:27 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 00/24] V4L2: subdevice pad-level API wrapper
Date: Fri, 19 Apr 2013 12:29:16 +0200
Cc: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <1366320945-21591-1-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1366320945-21591-1-git-send-email-g.liakhovetski@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201304191229.16233.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu April 18 2013 23:35:21 Guennadi Liakhovetski wrote:
> This is the first very crude shot at the subdevice pad-level API wrapper.
> The actual wrapper is added in patch #21, previous 20 patches are
> preparation... They apply on top of the last version of my async / clock
> patch series, respectively, on top of the announced branch of my linuxtv
> git-tree. Patches 2 and 4 from this series should actually be merged into
> respective patches from the async series.
> 
> I'm publishing this patch-series now, because I don't know when and how
> much time I'll have to improve it... Maybe you don't want to spend too much
> time reviewing implementation details, but comments to general concepts
> would be appreciated.
> 
> Further note, that patches 8-12 aren't really required. We can keep the
> deprecated struct soc_camera_link for now, or use a more gentle and slow
> way to remove it.

I just wanted to say that there is much here that I like very a lot. I
would suggest splitting the patch series in two: first the struct
v4l2_subdev_platform_data & soc_camera_link removal, then the patches
dealing with the pad-level API.

The first part looks very nice, really the only problem I have there is
with the host_priv field, which should be easy enough to fix.

Regards,

	Hans
