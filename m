Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:33594 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756636Ab1CCJa1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Mar 2011 04:30:27 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [GIT PULL FOR 2.6.39] Media controller and OMAP3 ISP driver
Date: Thu, 3 Mar 2011 10:29:41 +0100
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	alsa-devel@alsa-project.org,
	Sakari Ailus <sakari.ailus@retiisi.org.uk>,
	Pawel Osciak <pawel@osciak.com>
References: <201102171606.58540.laurent.pinchart@ideasonboard.com> <4D6EA4EB.9070607@redhat.com>
In-Reply-To: <4D6EA4EB.9070607@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103031029.44957.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

On Wednesday 02 March 2011 21:13:31 Mauro Carvalho Chehab wrote:
> Em 17-02-2011 13:06, Laurent Pinchart escreveu:
> >       v4l: Share code between video_usercopy and video_ioctl2
> 
> Two hunks failed on this patch:
> 
> $ quilt push
> Applying patch
> patches/0951-v4l-Share-code-between-video_usercopy-and-video_ioct.patch
> patching file drivers/media/video/v4l2-ioctl.c
> Hunk #1 FAILED at 325.
> Hunk #2 succeeded at 332 (offset -33 lines).
> Hunk #3 succeeded at 368 (offset -33 lines).
> Hunk #4 succeeded at 397 (offset -33 lines).
> Hunk #5 FAILED at 1982.
> 2 out of 5 hunks FAILED -- rejects in file drivers/media/video/v4l2-ioctl.c
> Patch
> patches/0951-v4l-Share-code-between-video_usercopy-and-video_ioct.patch
> does not apply (enforce with -f)
> 
> Basically, the code for video_ioctl2 suffered some recent changes. I
> suspect that the blamed patch is this one:
> 
> cff7fbc6 (Pawel Osciak           2010-12-23 04:15:27 -0300 2342)       
> bool    has_array_args; cff7fbc6 (Pawel Osciak           2010-12-23
> 04:15:27 -0300 2343)        size_t  array_size = 0;
> 
> Could you please fix the merge conflicts?

Sure. I'm working on that right now, I'll send a new pull request.

-- 
Regards,

Laurent Pinchart
