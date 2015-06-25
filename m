Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out-241.synserver.de ([212.40.185.241]:1070 "EHLO
	smtp-out-241.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226AbbFYJWH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Jun 2015 05:22:07 -0400
Message-ID: <558BC83A.1070308@metafoo.de>
Date: Thu, 25 Jun 2015 11:22:02 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>,
	Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] v4l2-event: v4l2_event_queue: do nothing if vdev == NULL
References: <558924D7.4010904@xs4all.nl> <20150625091236.GH5904@valkosipuli.retiisi.org.uk>
In-Reply-To: <20150625091236.GH5904@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/25/2015 11:12 AM, Sakari Ailus wrote:
> Hi Hans,
>
> On Tue, Jun 23, 2015 at 11:20:23AM +0200, Hans Verkuil wrote:
>> If the vdev pointer == NULL, then just return.
>>
>> This makes it easier for subdev drivers to use this function without having to
>> check if the sd->devnode pointer is NULL or not.
>
> Do you have an example of when this would be useful? Isn't it a rather
> fundamental question to a driver whether or not it exposes a device node,
> i.e. why would a driver use v4l2_event_queue() in the first place if it does
> not expose a device node, and so the event interface?

The device node will only be created if the subdev driver supports it and if 
the bridge driver requests it. So if the subdev driver supports it, but the 
bridge driver does not request it there will be no devnode. The patch is to 
handle that case.

This patch is a requirement for this series which adds support for direct 
event notification to some subdev drivers. Why this is necessary and useful 
can be found in the series patch description. 
http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/92808

- Lars
