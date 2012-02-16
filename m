Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailfe06.c2i.net ([212.247.154.162]:34463 "EHLO swip.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751588Ab2BPTSN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Feb 2012 14:18:13 -0500
From: Hans Petter Selasky <hselasky@c2i.net>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: Division by zero in UVC driver
Date: Thu, 16 Feb 2012 20:16:21 +0100
Cc: "linux-media" <linux-media@vger.kernel.org>
References: <201202151827.29929.hselasky@c2i.net> <12311511.XtqQ6s9rAx@avalon>
In-Reply-To: <12311511.XtqQ6s9rAx@avalon>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201202162016.21987.hselasky@c2i.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 16 February 2012 07:30:17 Laurent Pinchart wrote:
> Hi Hans,
> 
> On Wednesday 15 February 2012 18:27:29 Hans Petter Selasky wrote:
> > Hi,
> > 
> > After getting through the compilation issues regarding the uvc_debugfs, I
> > am now facing another problem, which I think is more generic.
> > 
> > The FreeBSD port of the Linux UVC driver, webcamd, gives a division by
> > zero inside the UVC driver, because it does not properly check if the
> > returned SOF counter is the same like the previous one. This can also
> > happen on Linux if the UVC capable device is plugged exactly when the
> > EHCI/OHCI/UHCI SOF counter is equal to zero!
> 
> It's a know bug (at least to me :-)). Does
> http://git.linuxtv.org/pinchartl/uvcvideo.git/commit/5c97eb2eb9c45dad8825de
> 7754ceb33699451978 fix your problem ? I've queued that patch in my tree for
> v3.4.

Your patch works! Thanks!

--HPS
