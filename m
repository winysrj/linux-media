Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:49462 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815Ab1CGWEF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Mar 2011 17:04:05 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [GIT PULL FOR 2.6.39] Media controller and OMAP3 ISP driver
Date: Mon, 7 Mar 2011 23:04:22 +0100
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	alsa-devel@alsa-project.org,
	Sakari Ailus <sakari.ailus@retiisi.org.uk>,
	Pawel Osciak <pawel@osciak.com>
References: <201102171606.58540.laurent.pinchart@ideasonboard.com> <201103052148.06603.laurent.pinchart@ideasonboard.com> <4D74C82A.9050406@redhat.com>
In-Reply-To: <4D74C82A.9050406@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103072304.23846.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

On Monday 07 March 2011 12:57:30 Mauro Carvalho Chehab wrote:
> Em 05-03-2011 17:48, Laurent Pinchart escreveu:
> > On Saturday 05 March 2011 19:22:28 Mauro Carvalho Chehab wrote:
> >> Em 05-03-2011 10:02, Laurent Pinchart escreveu:

[snip]

> >>> - private ioctls
> >>> 
> >>> As already explained by David, the private ioctls are used to control
> >>> advanced device features that can't be handled by V4L2 controls at the
> >>> moment (such as setting a gamma correction table). Using those ioctls
> >>> is not mandatory, and the device will work correctly without them
> >>> (albeit with a non optimal image quality).
> >>> 
> >>> David said he will submit a patch to document the ioctls.
> >> 
> >> Ok.
> > 
> > Working on that.
> 
> Laurent/David, any news on that?

"omap3isp: Add documentation" in
http://git.linuxtv.org/pinchartl/media.git?a=shortlog;h=refs/heads/media-2.6.39-0005-
omap3isp

You can take all the OMAP3 ISP patches from that branch.

-- 
Regards,

Laurent Pinchart
