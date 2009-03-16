Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:1447 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618AbZCPKrz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2009 06:47:55 -0400
Message-ID: <29389.62.70.2.252.1237200462.squirrel@webmail.xs4all.nl>
Date: Mon, 16 Mar 2009 11:47:42 +0100 (CET)
Subject: Re: REVIEW: bttv conversion to v4l2_subdev
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Mauro Carvalho Chehab" <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> On Sun, 15 Mar 2009 13:24:00 +0100
> Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
>> Hi Mauro,
>>
>> Can you review my ~hverkuil/v4l-dvb-bttv2 tree?
>>
>> It converts this driver to v4l2_subdev, and as far as I can see it works
>> and
>> should probe all the different audio devices in the correct and safe
>> order.
>>
>> I kept things as simple as possible in order to make a review easy.
>
> Could you please break this changeset even more:
> 	http://linuxtv.org/hg/~hverkuil/v4l-dvb-bttv2/rev/583981be1a4d
>
> The reason is that it not just add support to tda9875, but also changes
> the
> behaviour of mute and input selection. Had you find a bug with the old
> way?

Oops, I'd forgotten about that. That was indeed a bug and should be put in
as a separate change. The MUTE support is related to INPUTSEL in tvaudio.
But it didn't always test for INPUTSEL.

Thanks for catching this.

Regards,

       Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

