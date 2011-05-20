Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:56633 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934561Ab1ETQEW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 May 2011 12:04:22 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "=?iso-8859-1?q?R=E9mi?= Denis-Courmont" <remi@remlab.net>
Subject: Re: [GIT PATCH FOR 2.6.40] uvcvideo patches
Date: Fri, 20 May 2011 18:04:25 +0200
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
References: <201105150948.24956.laurent.pinchart@ideasonboard.com> <4DD6899D.5020004@redhat.com> <201105201855.53240.remi@remlab.net>
In-Reply-To: <201105201855.53240.remi@remlab.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201105201804.26348.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Rémi,

On Friday 20 May 2011 17:55:52 Rémi Denis-Courmont wrote:
> Le vendredi 20 mai 2011 18:32:45 Mauro Carvalho Chehab, vous avez écrit :
> > However, I have serious concerns about media_controller API usage on
> > generic drivers, as it is required that all drivers should be fully
> > configurable via V4L2 API alone, otherwise we'll have regressions, as no
> > generic applications use the media_controller.
> 
> If VLC counts as a generic application, I'd be more than API to use the
> media_controller (or whatever else) if only to find which ALSA (sub)device,
> if any, corresponds to the V4L2 node of a given USB webcam or such.

That feature is not available yet, but it's definitely something I want to 
fix. It might be a bit tricky for USB devices (as uvcvideo and usbaudio don't 
know about eachother), but we need to find a proper solution.

> I don't know any solution at the moment, and this is a major inconvenience
> on Linux desktop compared to DirectShow.

-- 
Regards,

Laurent Pinchart
