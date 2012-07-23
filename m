Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:50722 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675Ab2GWMZg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jul 2012 08:25:36 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL FOR v3.6] Add adv7604/ad9389b drivers
Date: Mon, 23 Jul 2012 14:25:38 +0200
Message-ID: <2229729.zs2QQjUUOH@avalon>
In-Reply-To: <201207231336.15392.hverkuil@xs4all.nl>
References: <201207231336.15392.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Monday 23 July 2012 13:36:15 Hans Verkuil wrote:
> Hi all!
> 
> There haven't been any comments since either RFCv1 or RFCv2.
> 
> (http://www.spinics.net/lists/linux-media/msg48529.html and
> http://www.spinics.net/lists/linux-media/msg50413.html)
> 
> So I'm making this pull request now.
> 
> The only changes since RFCv2 are some documentation fixes:
> 
> - Add a note that the SUBDEV_G/S_EDID ioctls are experimental
> - Add the proper revision/experimental references.
> - Update the spec version to 3.6.

Jumping a bit late on this. Wouldn't it be good to submit the RFCs to the dri-
devel mailing list before pushing them upstream ? They have been dealing with 
EDID for ages and might offer good advices.

-- 
Regards,

Laurent Pinchart

