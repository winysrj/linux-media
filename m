Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:48981 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727192AbeH1OjR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Aug 2018 10:39:17 -0400
Subject: Re: [PATCH] media: v4l2-subdev.h: allow V4L2_FRMIVAL_TYPE_CONTINUOUS
 & _STEPWISE
To: Philippe De Muyter <phdm@macqel.be>
Cc: linux-media@vger.kernel.org
References: <1535442907-8659-1-git-send-email-phdm@macqel.be>
 <7bfc83d5-92dd-a604-35a6-4dc659feb7b5@xs4all.nl>
 <20180828102610.GA31307@frolo.macqel>
 <e5379767-5bf4-e0bb-e952-1e7afd39e1a9@xs4all.nl>
 <20180828104004.GA5258@frolo.macqel>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <067c2ad9-6216-d2d3-6004-3c69289a0c5b@xs4all.nl>
Date: Tue, 28 Aug 2018 12:48:12 +0200
MIME-Version: 1.0
In-Reply-To: <20180828104004.GA5258@frolo.macqel>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 28/08/18 12:40, Philippe De Muyter wrote:
> Hi Hans,
> 
> On Tue, Aug 28, 2018 at 12:29:21PM +0200, Hans Verkuil wrote:
>> On 28/08/18 12:26, Philippe De Muyter wrote:
>>> Hi Hans,
>>>
>>> On Tue, Aug 28, 2018 at 12:03:25PM +0200, Hans Verkuil wrote:
>>>> This is a bit too magical for my tastes. I'd add a type field:
>>>>
>>>> #define V4L2_SUBDEV_FRMIVAL_TYPE_DISCRETE 0
>>>> #define V4L2_SUBDEV_FRMIVAL_TYPE_CONTINUOUS 1
>>>> #define V4L2_SUBDEV_FRMIVAL_TYPE_STEPWISE 2
> 
> Should I put that in an enum like 'enum v4l2_subdev_format_whence'
> or use simple define's ?

Use an enum for consistency with the existing framesize/ival APIs.

Regards,

	Hans
