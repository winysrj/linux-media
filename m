Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:41400 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851Ab0GZOp7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Jul 2010 10:45:59 -0400
Message-ID: <4C4D9F5F.3090908@maxwell.research.nokia.com>
Date: Mon, 26 Jul 2010 17:44:47 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Subject: Re: [RFC/PATCH v2 02/10] media: Media device
References: <1279722935-28493-1-git-send-email-laurent.pinchart@ideasonboard.com> <1279722935-28493-3-git-send-email-laurent.pinchart@ideasonboard.com> <201007241402.50974.hverkuil@xs4all.nl>
In-Reply-To: <201007241402.50974.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil wrote:
> On Wednesday 21 July 2010 16:35:27 Laurent Pinchart wrote:
>> The media_device structure abstracts functions common to all kind of
>> media devices (v4l2, dvb, alsa, ...). It manages media entities and
>> offers a userspace API to discover and configure the media device
>> internal topology.
>>
>> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>> ---
>>  Documentation/media-framework.txt |   68 ++++++++++++++++++++++++++++++++
>>  drivers/media/Makefile            |    2 +-
>>  drivers/media/media-device.c      |   77 +++++++++++++++++++++++++++++++++++++
>>  include/media/media-device.h      |   53 +++++++++++++++++++++++++
>>  4 files changed, 199 insertions(+), 1 deletions(-)
>>  create mode 100644 Documentation/media-framework.txt
>>  create mode 100644 drivers/media/media-device.c
>>  create mode 100644 include/media/media-device.h
>>
> 
> <snip>
> 
> As discussed on IRC: I would merge media-device and media-devnode. I see no
> benefit in separating them at this time.

I have to say I like the current separation of registration / node
handling and the actual implementation, as in V4L2. There's more code to
both files in the following patches. It think the result is easier to
understand the way it is.

You do have a point there that there's no need to separate them since
media_devnode is only used in media_device, at the moment at least. Or
is there a chance we would get different kind of control devices that
would use media_devnode in the future? I don't see a clear need for
such, though.

Could media_devnode and media_device be combined without breaking this
nice separation in the code too much?

Regards,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
