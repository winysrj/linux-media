Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:52175 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752552Ab1E3LhU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 30 May 2011 07:37:20 -0400
Message-ID: <4DE3816B.6050204@redhat.com>
Date: Mon, 30 May 2011 08:37:15 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans De Goede <hdegoede@redhat.com>
Subject: Re: [RFCv2] Add a library to retrieve associated media devices -
 was: Re: [ANNOUNCE] experimental alsa stream support at xawtv3
References: <4DDAC0C2.7090508@redhat.com> <201105291319.47207.hverkuil@xs4all.nl> <4DE237D9.8090306@redhat.com> <201105300834.32362.hverkuil@xs4all.nl>
In-Reply-To: <201105300834.32362.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 30-05-2011 03:34, Hans Verkuil escreveu:
> On Sunday, May 29, 2011 14:11:05 Mauro Carvalho Chehab wrote:
>> In other words, for event/input devices, if someone needs to have more than
>> one IR, each directed to a different set of windows/applications, he will 
>> need to manually configure what he needs. So, grouping RC with video apps
>> doesn't make sense.
> 
> I'm not so sure about that. Wouldn't it be at least useful that an application
> can discover that an IR exists? That may exist elsewhere already, though. I'm
> no IR expert.

ir-keytable does that. We may move part of its code to a library later.

>>>>
>>>> All discovered devices can be displayed by calling:
>>>>
>>>> 	void display_media_devices(void *opaque);
>>>
>>> This would be much more useful if a callback is provided.
>>
>> I can't see any usecase for a callback. Can you explain it better?
> 
> Right now display_media_devices outputs to stdout. But what if the apps wants
> to output to stderr? To some special console? To a GUI?

Good point.

If all userspace wants is to redirect it, fdup() may be used. Another option
would be to just pass the file descriptor as a parameter.

Passing a printf-like callback may require some work. I'm not sure if this
is the proper way for doing it.

Could you please propose a patch for it?

Thanks,
Mauro
