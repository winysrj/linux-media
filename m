Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52663 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753686Ab2ENQCI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 May 2012 12:02:08 -0400
Message-ID: <4FB12C74.8000306@redhat.com>
Date: Mon, 14 May 2012 13:01:56 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com
Subject: Re: [GIT PULL FOR v3.5] Implement V4L2_CID_PIXEL_RATE in various
 drivers
References: <20120514155622.GJ3373@valkosipuli.retiisi.org.uk>
In-Reply-To: <20120514155622.GJ3373@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sakari,

Em 14-05-2012 12:56, Sakari Ailus escreveu:
> Hi all,
> 
> Here are a few patches that implement V4L2_CID_PIXEL_RATE in a couple of
> drivers. The control is soon required by some CSI-2 receivers to configure
> the hardware, such as the OMAP 3 ISP one.

Before spreading this everywhere, let me understand a little bit better about
V4L2_CID_PIXEL_RATE and the other ioctl's that handle the image rate, as changing
one affects the other.

Regards,
Mauro
> 
> ---
> 
> The following changes since commit e89fca923f32de26b69bf4cd604f7b960b161551:
> 
>   [media] gspca - ov534: Add Hue control (2012-05-14 09:48:00 -0300)
> 
> are available in the git repository at:
>   ssh://linuxtv.org/git/sailus/media_tree.git media-for-3.5
> 
> Laurent Pinchart (3):
>       mt9t001: Implement V4L2_CID_PIXEL_RATE control
>       mt9p031: Implement V4L2_CID_PIXEL_RATE control
>       mt9m032: Implement V4L2_CID_PIXEL_RATE control
> 
>  drivers/media/video/mt9m032.c |   13 +++++++++++--
>  drivers/media/video/mt9p031.c |    5 ++++-
>  drivers/media/video/mt9t001.c |   13 +++++++++++--
>  include/media/mt9t001.h       |    1 +
>  4 files changed, 27 insertions(+), 5 deletions(-)
> 
> 
> 

