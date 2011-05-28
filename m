Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:59436 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753535Ab1E1Oj7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 28 May 2011 10:39:59 -0400
Message-ID: <4DE1093A.6070003@redhat.com>
Date: Sat, 28 May 2011 11:39:54 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?R=E9mi_Denis-Courmont?= <remi@remlab.net>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [ANNOUNCE] experimental alsa stream support at xawtv3
References: <4DDAC0C2.7090508@redhat.com> <4DDB5C6B.6000608@redhat.com> <4DDBBC29.80009@infradead.org> <201105281555.28285.remi@remlab.net>
In-Reply-To: <201105281555.28285.remi@remlab.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 28-05-2011 09:55, Rémi Denis-Courmont escreveu:
> Le mardi 24 mai 2011 17:09:45 Mauro Carvalho Chehab, vous avez écrit :
>> If we do that, then all other places where the association between an alsa
>> device and a video4linux node is needed will need to copy it, and we'll
>> have a fork. Also, we'll keep needing it at v4l-utils, as it is now needed
>> by the new version of v4l2-sysfs-path tool.
>>
>> Btw, this lib were created due to a request from the vlc maintainer that
>> something like that would be needed. After finishing it, I decided to add
>> it at xawtv in order to have an example about how to use it.
> 
> Hmm errm, I said VLC would need to be able to match a V4L2 device to an ALSA 
> input (where applicable). Currently, V4L2 devices are enumerated with 
> (lib)udev though. I am not very clear how v4l2-utils fits there (and oh, ALSA 
> is a bitch for udev-hotplugging but I'm getting side tracked).

Once you have a V4L2 device, it will use something similar to (lib)udev to get
the associated alsa device for that video input.

> I guess I misunderstood that /dev/media would logically group related devices.  
> Now I guess it is _solely_ intended to plug DSPs together à la OpenMAX IL. 
> Sorry about that.

Although people is thinking and discussing about using it also on other subsystems, 
it is currently limited to video4linux only. As you said, the current focus
is to plug DSPs.

>>> Mauro, I plan to do a new v4l-utils release soon (*), maybe even today. I
>>> consider it unpolite to revert other peoples commits, so I would prefer
>>> for you to revert the install libv4l2util.a patch yourself. But if you
>>> don't (or don't get around to doing it before I do the release), I will
>>> revert it, as this clearly needs more discussion before making it into
>>> an official release tarbal (we can always re-introduce the patch after
>>> the release).
>>
>> I'm not a big fan or exporting the rest of stuff at libv4l2util.a either,
>> but I think that at least the get_media_devices stuff should be exported
>> somewhere, maybe as part of libv4l.
> 
> Should it be exposed as a udev device attribute instead then?

An udev attribute can be added to allow such association on devices where both
audio and video are handled by a driver at /drivers/media (I'm actually thinking
on using udev uevent instead, as there's nothing that you can control with it).

This won't cover 100% of the cases, as some devices just provide a standard Usb 
Audio Class for audio. So, the standard driver (snd-usb-audio) will handle the 
audio part without knowing anything about the video part of the device.

The current library will handle such case by detecting that both audio and video
nodes belong to the same physical device.

Cheers,
Mauro
