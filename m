Return-path: <mchehab@pedra>
Received: from mailout2.samsung.com ([203.254.224.25]:36142 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981Ab1CJKKX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Mar 2011 05:10:23 -0500
Received: from epmmp1 (mailout2.samsung.com [203.254.224.25])
 by mailout2.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LHU00M636AL12C0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 10 Mar 2011 18:56:45 +0900 (KST)
Received: from jtppark ([12.23.103.64])
 by mmp1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LHU00FLI6AKSJ@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 10 Mar 2011 18:56:45 +0900 (KST)
Date: Thu, 10 Mar 2011 18:56:40 +0900
From: Jeongtae Park <jtp.park@samsung.com>
Subject: RE: [PATCH/RFC 0/2] Support controls at the subdev file handler level
In-reply-to: <1299706041-21589-1-git-send-email-laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Reply-to: jtp.park@samsung.com
Message-id: <000601cbdf09$76be8c10$643ba430$%park@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ks_c_5601-1987
Content-language: ko
Content-transfer-encoding: 7BIT
References: <1299706041-21589-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi, all.

Some hardware need to handle per-filehandle level controls.
Hans suggests add a v4l2_ctrl_handler struct v4l2_fh. It will be work fine.
Although below patch series are for subdev, but it's great start point.
I will try to make a patch.

If v4l2 control framework can be handle per-filehandle controls,
a driver could be handle per-buffer level controls also. (with VB2 callback
operation)

Best Regards,

/jtpark

> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Laurent Pinchart
> Sent: Thursday, March 10, 2011 6:27 AM
> To: linux-media@vger.kernel.org
> Cc: hverkuil@xs4all.nl; jaeryul.oh@samsung.com
> Subject: [PATCH/RFC 0/2] Support controls at the subdev file handler level
> 
> Hi everybody,
> 
> Here's a patch set that adds support for per-file-handle controls on V4L2
> subdevs. The patches are work in progress, but I'm still sending them as
> Samsung expressed interest in a similar feature on V4L2 device nodes.
> 
> Laurent Pinchart (2):
>   v4l: subdev: Move file handle support to drivers
>   v4l: subdev: Add support for file handler control handler
> 
>  drivers/media/video/v4l2-subdev.c |  144 +++++++++++++++++++-------------
----
>  include/media/v4l2-subdev.h       |   10 ++-
>  2 files changed, 84 insertions(+), 70 deletions(-)
> 
> --
> Regards,
> 
> Laurent Pinchart
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

