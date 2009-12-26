Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:57049 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675AbZLZTqM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Dec 2009 14:46:12 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: uvcvideo Logitech patch
Date: Sat, 26 Dec 2009 20:48:53 +0100
Cc: Mitar <mitar@tnode.com>, linux-uvc-devel@lists.berlios.de,
	linux-media@vger.kernel.org
References: <4B27DD88.3090900@tnode.com> <200912152215.21467.linux@rainbow-software.org>
In-Reply-To: <200912152215.21467.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200912262048.53769.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mitar,

On Tuesday 15 December 2009 22:15:19 Ondrej Zary wrote:
> On Tuesday 15 December 2009 20:03:36 Mitar wrote:
> > Hi!
> >
> > I have Logitech QuickCam Pro 9000 webcam and I had the same problems
> > described here:
> >
> > http://patchwork.kernel.org/patch/52261/
> >
> > I have applied the patch and it did not help. But it helped when I
> > increased UVC_CTRL_CONTROL_TIMEOUT to 1000 and UVC_CTRL_STREAMING_TIMEOUT
> > 5000. So 300 and 3000 values were not enough.
> > I do not know if it was really necessary to increase
> > UVC_CTRL_CONTROL_TIMEOUT or if it would be enough something between 3000
> > and 5000 for UVC_CTRL_STREAMING_TIMEOUT as I did not have more time to
> > test it.
> >
> > So maybe 5000 would be a good default for UVC_CTRL_STREAMING_TIMEOUT?

Could be, but I'd like to know if increasing the control streaming timeout is 
required as well.

-- 
Regards,

Laurent Pinchart
