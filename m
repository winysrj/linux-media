Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:32944 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756572Ab2EJPfN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 May 2012 11:35:13 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>,
	Hans de Goede <hdegoede@redhat.com>
Subject: Re: [GIT PULL FOR v3.5] Update v4l2-dev/ioctl.c to add gspca locking requirements
Date: Thu, 10 May 2012 17:35:16 +0200
Message-ID: <1517975.APt9bbvSEu@avalon>
In-Reply-To: <201205101359.34819.hverkuil@xs4all.nl>
References: <201205101359.34819.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Thursday 10 May 2012 13:59:34 Hans Verkuil wrote:
> Hi Mauro,
> 
> Here is the pull request for this. HdG's gspca work depends on this and he
> likes to get this in for 3.5. I think these are pretty good improvements
> and for 3.6 I intend to build on it, basically getting rid of the whole
> huge switch statement in v4l2-ioctl.c and replace it with table look-ups
> and callbacks.
> 
> But for now this is primarily to support the gspca work.

The patches have been posted as RFCs early today and the pull request is 
already here... I'd like to review them first if you don't mind :-)

-- 
Regards,

Laurent Pinchart

