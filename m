Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr17.xs4all.nl ([194.109.24.37]:3035 "EHLO
	smtp-vbr17.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205AbZFKLvk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jun 2009 07:51:40 -0400
Message-ID: <61298.62.70.2.252.1244721072.squirrel@webmail.xs4all.nl>
Date: Thu, 11 Jun 2009 13:51:12 +0200 (CEST)
Subject: Re: [PATCH] ov511.c: video_register_device() return zero on success
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Mauro Carvalho Chehab" <mchehab@infradead.org>
Cc: "Figo.zhang" <figo1802@gmail.com>, linux-media@vger.kernel.org,
	mark@alpha.dyndns.org, cpbotha@ieee.org, kraxel@bytesex.org,
	claudio@conectiva.com
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> Em Thu, 11 Jun 2009 08:36:00 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
>
>
>> Since I made that change I'm willing to look at this. Some comments
>> definitely
>> need improving at the least.
>
> Thanks! Since the behavior changed, it is important to better document it.
>
>> Also ivtv and cx18 rely on the current behavior,
>> so any changes need to be done carefully.
>>
>> But one question first: isn't the current approach not better anyway
>> than the
>> old approach? In the past device creation would fail if you specified an
>> explicit device kernel number that was already in use. Now it will
>> attempt
>> to fulfill the request and skip to the next free number otherwise. Seems
>> a
>> pretty good approach to me.
>
> Well, the idea of not failing due to that is interesting. Yet, those force
> parameters are provided to avoid that a different modprobe order would
> change
> the device nodes. By doing something different than requested by the users
> without
> even warning them about that doesn't sound nice. At least a KERN_ERR log
> should be printed if the selected nr is different than the requested one.

KERN_WARNING would be better, I think. It is not an error after all.

> In the specific case of ov511, however, it caused a regression, since the
> used
> logic to get the next value of the array were based on the failure of
> video_register_device(). As it doesn't fail anymore, the current logic is
> broken.
>
>> There haven't been any complaints about this (probably also because
>> nobody is
>> using it).
>>
>> Let me know what you want and I can implement it. It's not that hard.
>
> IMO, what should be done:
>
> 1) better comment the function;
> 2) generate a KERN_ERR at v4l2-dev, if the requested nr is not available;
> 3) replace ov511 logic to restore the old behavior (or improve it a little
> bit);
> 4) double check if similar regressions are present on other drivers. Since
> ov511 is an old driver, I don't doubt that its logic is duplicated on
> other
> devices.

I've just double checked all video_register_device calls and ov511.c is
the only one with this behavior.

Regards,

        Hans

>
> Since ov511 is used for an usb device, extra care should be taken, since
> it
> should be considered the possibility of successive hot plug/unplug. I
> wrote an
> interesting logic for this at em28xx driver, that can be used as an
> alternative
> to the current logic



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

