Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:3230 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760150Ab2FUUKv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jun 2012 16:10:51 -0400
Message-ID: <4FE37F8D.8080704@xs4all.nl>
Date: Thu, 21 Jun 2012 22:09:49 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Ezequiel Garcia <elezegarcia@gmail.com>
CC: linux-media <linux-media@vger.kernel.org>,
	Greg KH <gregkh@suse.de>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	bcollins@bluecherry.net
Subject: Re: [Q] What's preventing solo6x10 driver from moving out of staging
References: <CALF0-+U9_g64bekEDpjJwkKZrCjbXwArSRxGamG0XR1JN6qG4w@mail.gmail.com>
In-Reply-To: <CALF0-+U9_g64bekEDpjJwkKZrCjbXwArSRxGamG0XR1JN6qG4w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 21/06/12 17:08, Ezequiel Garcia wrote:
> Hi all,
>
> solo6x10 TODO file says this:
>
> TODO (staging =>  main):
>
>          * Motion detection flags need to be moved to v4l2
>          * Some private CIDs need to be moved to v4l2
>
> But I could not find any v4l2 motion detection flag. I guess it's a
> new kind of flag that needs to be added.

I don't know about the motion detection part, but I do know that any ioctls
and/or controls relating to video compression need to be reviewed in light of
the support for H264 etc. that was added some time ago.

I actually have a device, but I haven't had time to play with it and clean it
up.

> Also, what happened with the mainline effort? (Assuming there was one :-)

Well, when the new compression API was discussed I made sure that bluecherry
was CC-ed, but no action was taken from their side.

In other words, it seems unmaintained at the moment. Which is a shame, since
the code is actually fairly clean.

I've just scanned through the code and it looks like it wouldn't take too much
work to get it out of staging.

Regards,

	Hans
