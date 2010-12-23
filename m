Return-path: <mchehab@gaivota>
Received: from perceval.ideasonboard.com ([95.142.166.194]:56820 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021Ab0LWIeR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Dec 2010 03:34:17 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [GIT PULL FOR 2.6.37] uvcvideo: BKL removal
Date: Thu, 23 Dec 2010 09:34:27 +0100
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
References: <201011291115.11061.laurent.pinchart@ideasonboard.com> <201012201328.06493.hverkuil@xs4all.nl> <4D108B1A.6060004@redhat.com>
In-Reply-To: <4D108B1A.6060004@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012230934.28933.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Mauro,

On Tuesday 21 December 2010 12:10:18 Mauro Carvalho Chehab wrote:
>
> You didn't understand me: uvcvideo is returning -EBUSY to format changes
> with buffers freed.

As explained in my answer to Hans, that's on purpose.

The uvcvideo driver releases buffers when calling REQBUFS(0). However, the 
file handle is still marked as owning the device for streaming purpose, so 
other applications can't change the format or request buffers.

The reason for that is to avoid race conditions when an application wants to 
change the resolution during capture. As the application has to stop capture, 
call REQBUFS(0), change the format, request buffers  and restart capture, it 
prevents another application from racing it after REQBUFS(0).

As Hans correctly pointed out, this should be implemented using the priority 
ioctls. I will fix that.

-- 
Regards,

Laurent Pinchart
