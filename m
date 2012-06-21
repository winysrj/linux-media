Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:46302 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754291Ab2FUVST convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jun 2012 17:18:19 -0400
Received: by gglu4 with SMTP id u4so981523ggl.19
        for <linux-media@vger.kernel.org>; Thu, 21 Jun 2012 14:18:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FE37F8D.8080704@xs4all.nl>
References: <CALF0-+U9_g64bekEDpjJwkKZrCjbXwArSRxGamG0XR1JN6qG4w@mail.gmail.com>
	<4FE37F8D.8080704@xs4all.nl>
Date: Thu, 21 Jun 2012 18:18:19 -0300
Message-ID: <CALF0-+UafKjKYCsUQXwkBkwY7r0azFhkn3Xn1nn3FrZvmrW-0A@mail.gmail.com>
Subject: Re: [Q] What's preventing solo6x10 driver from moving out of staging
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	bcollins@bluecherry.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Dropped Greg from Cc since it's not relevant (and that suse.de address
is broken).

On Thu, Jun 21, 2012 at 5:09 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On 21/06/12 17:08, Ezequiel Garcia wrote:
>>
>> Hi all,
>>
>> solo6x10 TODO file says this:
>>
>> TODO (staging =>  main):
>>
>>         * Motion detection flags need to be moved to v4l2
>>         * Some private CIDs need to be moved to v4l2
>>
>> But I could not find any v4l2 motion detection flag. I guess it's a
>> new kind of flag that needs to be added.
>
>
> I don't know about the motion detection part, but I do know that any ioctls
> and/or controls relating to video compression need to be reviewed in light
> of
> the support for H264 etc. that was added some time ago.
>
> I actually have a device, but I haven't had time to play with it and clean
> it
> up.
>
>
>> Also, what happened with the mainline effort? (Assuming there was one :-)
>
>
> Well, when the new compression API was discussed I made sure that bluecherry
> was CC-ed, but no action was taken from their side.

Do you mean this api?

http://linuxtv.org/downloads/v4l-dvb-apis/extended-controls.html#mpeg-controls

>
> In other words, it seems unmaintained at the moment. Which is a shame, since
> the code is actually fairly clean.
>
> I've just scanned through the code and it looks like it wouldn't take too
> much
> work to get it out of staging.

Yes, does was my impression.

Regards,
Ezequiel.
