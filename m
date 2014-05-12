Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:1583 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132AbaELIKO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 May 2014 04:10:14 -0400
Message-ID: <537081CF.40703@xs4all.nl>
Date: Mon, 12 May 2014 10:09:51 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>,
	m.chehab@samsung.com
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 06/19] em28xx: move video_device structs from struct em28xx
 to struct v4l2
References: <1395689605-2705-1-git-send-email-fschaefer.oss@googlemail.com> <1395689605-2705-7-git-send-email-fschaefer.oss@googlemail.com> <536C9D85.10504@xs4all.nl> <536FE27F.1080504@googlemail.com>
In-Reply-To: <536FE27F.1080504@googlemail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/11/2014 10:50 PM, Frank Schäfer wrote:
> 
> Am 09.05.2014 11:19, schrieb Hans Verkuil:
>> On 03/24/2014 08:33 PM, Frank Schäfer wrote:
>>> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
>>> ---
>>>  drivers/media/usb/em28xx/em28xx-video.c | 120 ++++++++++++++------------------
>>>  drivers/media/usb/em28xx/em28xx.h       |   7 +-
>>>  2 files changed, 56 insertions(+), 71 deletions(-)
>>>
>>> diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
>>> index a4d26bf..88d0589 100644
>>> --- a/drivers/media/usb/em28xx/em28xx.h
>>> +++ b/drivers/media/usb/em28xx/em28xx.h
>>> @@ -504,6 +504,10 @@ struct em28xx_v4l2 {
>>>  	struct v4l2_device v4l2_dev;
>>>  	struct v4l2_ctrl_handler ctrl_handler;
>>>  	struct v4l2_clk *clk;
>>> +
>>> +	struct video_device *vdev;
>>> +	struct video_device *vbi_dev;
>>> +	struct video_device *radio_dev;
>> Think about embedding these structs. That way you don't have to allocate them which
>> removes the complexity of checking for ENOMEM errors.
> 
> Yes, but consider that only em286x and em288x devices provide VBI
> support and we have even less devices with radio support (~ 3 of 100).
> So with most devices, we would waste memory.

The problem with v4l drivers is always complexity, never performance or memory.
Anything that reduces complexity is always a good thing. The extra memory used
is negligible. Since kmalloc rounds up the requested memory to the next power
of two you might even end up with allocating more memory instead of less, but
you'd have to calculate that to see if it is true.

Simplification is always key to media drivers.

Regards,

	Hans
