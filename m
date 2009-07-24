Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:4086 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826AbZGXI2Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jul 2009 04:28:25 -0400
Message-ID: <45562.62.70.2.252.1248424102.squirrel@webmail.xs4all.nl>
Date: Fri, 24 Jul 2009 10:28:22 +0200 (CEST)
Subject: Re: New tree with final (?) string control implementation
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: eduardo.valentin@nokia.com
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> Hi Hans,
>
> On Thu, Jul 23, 2009 at 11:54:46PM +0200, ext Hans Verkuil wrote:
>> Hi Eduardo,
>>
>> I've prepared a new tree:
>>
>> http://www.linuxtv.org/hg/~hverkuil/v4l-dvb-strctrl
>
> good.
>
>>
>> This contains the full string control implementation, including updates
>> to
>> the v4l2-spec, based on the RFC that I posted on Monday.
>
> Right.
>
>>
>> Can you prepare your si4713 patches against this tree and verify that
>> everything is working well?
>
> Sure, I've been off work last two weeks. But now I'm back and will get
> this
> task soon.
>
>>
>> If it is, then I can make a pull request for this tree and soon after
>> that
>> you should be able to merge your si4713 driver as well. If I'm not
>> mistaken
>> the string controls API is the only missing bit that prevents your
>> driver
>> from being merged.
>
> Yeah. There use to have three dependencies: subdev changes (i2c),
> modulator
> capabilities and ext ctl string support. I recall now that subdev is
> already
> merged. I'm not sure about the modulator support.

That was also merged about a week ago. So this is now the only missing piece.

Two things to keep in mind when preparing the new patches:

1) The v4l2-spec documentation on the new string controls must also
specify what character encoding is used. In this case you can refer to the
RDS standard.

2) In media/video/v4l2-common.c there is a function
v4l2_ctrl_is_pointer(). This should return 1 for all string controls. It
is needed to ensure that string controls are converted correctly in
v4l2-compat-ioctl32.c. Not really an issue on most embedded systems, but
on intel platforms it is important to get this right.

Regards,

       Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

