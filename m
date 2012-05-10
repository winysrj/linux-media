Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27802 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760323Ab2EJR5v (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 10 May 2012 13:57:51 -0400
Message-ID: <4FAC01A0.2050105@redhat.com>
Date: Thu, 10 May 2012 19:57:52 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL FOR v3.5] Update v4l2-dev/ioctl.c to add gspca locking
 requirements
References: <201205101359.34819.hverkuil@xs4all.nl> <1517975.APt9bbvSEu@avalon>
In-Reply-To: <1517975.APt9bbvSEu@avalon>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 05/10/2012 05:35 PM, Laurent Pinchart wrote:
> Hi Hans,
>
> On Thursday 10 May 2012 13:59:34 Hans Verkuil wrote:
>> Hi Mauro,
>>
>> Here is the pull request for this. HdG's gspca work depends on this and he
>> likes to get this in for 3.5. I think these are pretty good improvements
>> and for 3.6 I intend to build on it, basically getting rid of the whole
>> huge switch statement in v4l2-ioctl.c and replace it with table look-ups
>> and callbacks.
>>
>> But for now this is primarily to support the gspca work.
>
> The patches have been posted as RFCs early today and the pull request is
> already here... I'd like to review them first if you don't mind :-)

I reviewed and acked them (Hans V. has addressed my one concern on irc),
of course having multiple reviewers is good, so go ahead. Note that there
is not a real lot of interesting stuff inside though wrt potential locking
issues as the old behavior is preserved.

This patch just allows for drivers to selective opt out of the video_device
/ v4l2-dev.c lock for certain ioctls and for all non ioctl fops.

Regards,

Hans
