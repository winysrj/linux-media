Return-path: <mchehab@pedra>
Received: from yop.chewa.net ([91.121.105.214]:52869 "EHLO yop.chewa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933861Ab1ETPzz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 May 2011 11:55:55 -0400
From: "=?iso-8859-1?q?R=E9mi?= Denis-Courmont" <remi@remlab.net>
To: linux-media@vger.kernel.org
Subject: Re: [GIT PATCH FOR 2.6.40] uvcvideo patches
Date: Fri, 20 May 2011 18:55:52 +0300
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
References: <201105150948.24956.laurent.pinchart@ideasonboard.com> <4DD6899D.5020004@redhat.com>
In-Reply-To: <4DD6899D.5020004@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201105201855.53240.remi@remlab.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Le vendredi 20 mai 2011 18:32:45 Mauro Carvalho Chehab, vous avez écrit :
> However, I have serious concerns about media_controller API usage on
> generic drivers, as it is required that all drivers should be fully
> configurable via V4L2 API alone, otherwise we'll have regressions, as no
> generic applications use the media_controller.

If VLC counts as a generic application, I'd be more than API to use the 
media_controller (or whatever else) if only to find which ALSA (sub)device, if 
any, corresponds to the V4L2 node of a given USB webcam or such.

I don't know any solution at the moment, and this is a major inconvenience on 
Linux desktop compared to DirectShow.

-- 
Rémi Denis-Courmont
http://www.remlab.info/
http://fi.linkedin.com/in/remidenis
