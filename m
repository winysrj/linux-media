Return-path: <mchehab@gaivota>
Received: from perceval.ideasonboard.com ([95.142.166.194]:42378 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453Ab0LWJCV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Dec 2010 04:02:21 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [GIT PULL FOR 2.6.37] uvcvideo: BKL removal
Date: Thu, 23 Dec 2010 10:02:33 +0100
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
References: <201011291115.11061.laurent.pinchart@ideasonboard.com> <201012201348.51845.laurent.pinchart@ideasonboard.com> <201012201409.40799.hverkuil@xs4all.nl>
In-Reply-To: <201012201409.40799.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012231002.34251.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Hans,

On Monday 20 December 2010 14:09:40 Hans Verkuil wrote:
> On Monday, December 20, 2010 13:48:51 Laurent Pinchart wrote:
> >
> > What if the application wants to change the resolution during capture ?
> > It will have to stop capture, call REQBUFS(0), change the format,
> > request buffers and restart capture. If filehandle ownership is dropped
> > after REQBUFS(0) that will open the door to a race condition.
> 
> That's why S_PRIORITY was invented.

Right, I should implement that. I think the documentation isn't clear though. 
What is the background priority for exactly ? And the "unset" priority ? Are 
other applications allowed to change controls when an application has the 
record priority ?

In general I find the priority ioctls underspecified, that's why I haven't 
implemented them yet.

On a side note, I've just tested the latest uvcvideo driver, and I've 
successfully captured video using a second application after calling 
REQBUFS(0) in a first application.

-- 
Regards,

Laurent Pinchart
