Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46036 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752515Ab0CTXLQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Mar 2010 19:11:16 -0400
Message-ID: <4BA55652.40304@redhat.com>
Date: Sun, 21 Mar 2010 00:12:18 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	David Ellingsworth <david@identd.dyndns.org>
Subject: Re: RFC: Phase 1: Proposal to convert V4L1 drivers
References: <201003200958.49649.hverkuil@xs4all.nl> <201003202253.04191.hverkuil@xs4all.nl>
In-Reply-To: <201003202253.04191.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 03/20/2010 10:53 PM, Hans Verkuil wrote:
> On Saturday 20 March 2010 09:58:49 Hans Verkuil wrote:
>>
>> Kconfig mistakes:
>>
>> I found four errors in drivers/media/video/Kconfig: the saa7191, meye, mxb
>> and cpia2 drivers are all marked as V4L1 only, while all support V4L2!
>> The cpia2 driver supports both v4l1 and v4l2. I can test this driver and
>> will look at removing the V4L1 support from that driver.
>
> The pwc driver also depends on V4L1, but also contains V4L2 support.
> Can someone test this driver? It is easy to remove the V4L1 code, but I'm
> not sure how well the V4L2 code works.
>

I've a pwc using device. Actually I've 3 identical ones (all
logitech quickcam pro 4000's).

The pwc driver could indeed use some love from someone, but I've not
yet found / made the time to look at it.

It is working with the cams I have, but gets some corner cases
(like unplug while streaming) wrong.

Regards,

Hans


