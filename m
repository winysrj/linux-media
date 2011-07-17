Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53113 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752130Ab1GQICG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2011 04:02:06 -0400
Message-ID: <4E2296F3.8040809@redhat.com>
Date: Sun, 17 Jul 2011 05:01:55 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: =?UTF-8?B?UsOpbWkgRGVuaXMtQ291cm1vbnQ=?= <remi@remlab.net>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 0/5] Driver support for cards based on Digital Devices
 bridge (ddbridge)
References: <201107032321.46092@orion.escape-edv.de> <4E21B3EC.9060709@linuxtv.org> <4E223344.1080109@redhat.com> <201107171039.18383.remi@remlab.net>
In-Reply-To: <201107171039.18383.remi@remlab.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 17-07-2011 04:39, Rémi Denis-Courmont escreveu:
> Le dimanche 17 juillet 2011 03:56:36 Mauro Carvalho Chehab, vous avez écrit :
>>>>> After all, you cannot connect both a DVB-C cable and a DVB-T antenna at
>>>>> the same time, so the vast majority of users won't ever want to switch
>>>>> modes at all.
>>>>
>>>> You are wrong, actually you can. At least here in Finland some cable
>>>> networks offers DVB-T too.
>>
>> As Antti and Rémi pointed, there are issues with some cable operators. Not
>> sure how critical is that, but an userspace application changing it via
>> sysfs might work while the applications are not ported to support both
>> ways.
> 
> Telling applications to use sysfs... I can see many ways that you might regret 
> that in the future...

I'm expressed it badly. What I meant to say is to have some sort of script
or a specific application to allow users to change the delivery system, 
by changing the modprobe parameter, for the MFE drivers supported on <= 3.0 Kernel 
that won't fit in the agreed approach, while applications don't support 
the adopted approach directly.

> Accessing sysfs directly from an application is against all the good practices 
> I thought I had learnt regarding Linux. There is the theoretical possibility 
> that udev gets "explicit" support for Linux DVB and exposes the properties 
> nicely. But that would be rather inconvenient, and cannot be used to change 
> properties.
> 
>> Antti/Rémi, how the current applications work with one physical frontend
>> supporting both DVB-T and DVB-C? Do they allow to change channels from one
>> to the other mode on a transparent way?
> 
> I don't know. VLC does not care if you switch from DVB-T to DVB-C, to the DVD 
> drive or to YouTube. Each channel (or at least each multiplex) is a different 
> playlist item. So it'll close the all device nodes and (re)open them. There 
> are obviously other applications at stake.

