Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:49372 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757357Ab0F3WIX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Jun 2010 18:08:23 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Aguirre, Sergio" <saaguirre@ti.com>
Subject: Re: [media-ctl] [omap3camera:devel] How to use the app?
Date: Thu, 1 Jul 2010 00:08:44 +0200
Cc: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <A24693684029E5489D1D202277BE8944562E8B71@dlee02.ent.ti.com> <201006291222.47159.laurent.pinchart@ideasonboard.com> <A24693684029E5489D1D202277BE8944562E943A@dlee02.ent.ti.com>
In-Reply-To: <A24693684029E5489D1D202277BE8944562E943A@dlee02.ent.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201007010008.44537.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sergio,

On Wednesday 30 June 2010 00:13:43 Aguirre, Sergio wrote:
> > -----Original Message-----
> > From: Laurent Pinchart [mailto:laurent.pinchart@ideasonboard.com]
> > Sent: Tuesday, June 29, 2010 5:23 AM
> > On Tuesday 29 June 2010 01:34:01 Aguirre, Sergio wrote:

[snip]

> > You will find a set of patches that remove the legacy video nodes attached
> > to this e-mail. They haven't been applied to the omap3camera tree yet, as
> > we still haven't fixed all userspace components yet, but they should get
> > there in a few weeks hopefully. You should probably apply them to your
> > tree to make sure you don't start using the legacy video nodes by mistake.
> > They also remove a lot of code, which is always good, and remove the
> > hardcoded number of sensors.
> 
> I had following compilation error:
> 
> drivers/media/video/isp/ispvideo.c: In function 'isp_video_streamon':
> drivers/media/video/isp/ispvideo.c:780: error: 'const struct
> isp_video_operations' has no member named 'stream_off'
> drivers/media/video/isp/ispvideo.c:781: error: 'const struct
> isp_video_operations' has no member named 'stream_off' make[4]: ***
> [drivers/media/video/isp/ispvideo.o] Error 1
> make[3]: *** [drivers/media/video/isp] Error 2
> make[3]: *** Waiting for unfinished jobs....
> make[2]: *** [drivers/media/video] Error 2
> make[1]: *** [drivers/media] Error 2
> make: *** [drivers] Error 2
> 
> Which I solved with the attached patch. You might want to squash it with
> your patch "omap3isp: video: Remove the init, cleanup and stream_off
> operations"

Thanks for the patch. The fix was already in my tree, I suppose the patches 
I've sent were not in sync. Sorry about that.

-- 
Regards,

Laurent Pinchart
