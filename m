Return-path: <linux-media-owner@vger.kernel.org>
Received: from mxweblb05fl.versatel.de ([89.246.255.248]:43657 "EHLO
	mxweblb05fl.versatel.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755949Ab0DHR6G (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Apr 2010 13:58:06 -0400
Received: from ens28fl.versatel.de (ens28fl.versatel.de [82.140.32.10])
	by mxweblb05fl.versatel.de (8.13.1/8.13.1) with ESMTP id o38Hvw0H021798
	for <linux-media@vger.kernel.org>; Thu, 8 Apr 2010 19:57:58 +0200
Received: from cinnamon-sage.de (i577A4B01.versanet.de [87.122.75.1])
	(authenticated bits=0)
	by ens28fl.versatel.de (8.12.11.20060308/8.12.11) with SMTP id o38HvwD4031239
	for <linux-media@vger.kernel.org>; Thu, 8 Apr 2010 19:57:59 +0200
Received: from 192.168.23.2:49542 by cinnamon-sage.de for <isely@isely.net>,<hermann-pitton@arcor.de>,<hverkuil@xs4all.nl>,<linux-media@vger.kernel.org> ; 08.04.2010 19:57:58
Message-ID: <4BBE1926.1010207@cinnamon-sage.de>
Date: Thu, 08 Apr 2010 19:57:58 +0200
From: Lars Hanisch <dvb@cinnamon-sage.de>
MIME-Version: 1.0
To: Mike Isely <isely@isely.net>
CC: hermann pitton <hermann-pitton@arcor.de>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: Re: RFC: exposing controls in sysfs
References: <201004052347.10845.hverkuil@xs4all.nl>  <alpine.DEB.1.10.1004060848540.27169@cnc.isely.net>  <4BBCD3F9.1070207@cinnamon-sage.de> <1270678528.6429.35.camel@pc07.localdom.local> <alpine.DEB.1.10.1004071939510.5518@ivanova.isely.net>
In-Reply-To: <alpine.DEB.1.10.1004071939510.5518@ivanova.isely.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 08.04.2010 02:47, schrieb Mike Isely:
> On Thu, 8 Apr 2010, hermann pitton wrote:
>
>> Hi,
>>
>> Am Mittwoch, den 07.04.2010, 20:50 +0200 schrieb Lars Hanisch:
>>> Am 06.04.2010 16:33, schrieb Mike Isely:
>> [snip]
>>>>>
>>>>> Mike, do you know of anyone actively using that additional information?
>>>>
>>>> Yes.
>>>>
>>>> The VDR project at one time implemented a plugin to directly interface
>>>> to the pvrusb2 driver in this manner.  I do not know if it is still
>>>> being used since I don't maintain that plugin.
>>>
>>>    Just FYI:
>>>    The PVR USB2 device is now handled by the pvrinput-plugin, which uses only ioctls. The "old" pvrusb2-plugin is obsolete.
>>>
>>>    http://projects.vdr-developer.org/projects/show/plg-pvrinput
>
> Lars:
>
> Thanks for letting me know about that - until this message I had no idea
> if VDR was still using that interface.
>
>
>>>
>>> Regards,
>>> Lars.
>>
>> [snip]
>>
>> thanks Lars.
>>
>> Mike is really caring and went out for even any most obscure tuner bit
>> to help to improve such stuff in the past, when we have been without any
>> data sheets.
>
> Hermann:
>
> You might have me confused with Mike Krufky there - he's the one who did
> so much of the tuner driver overhauling in v4l-dvb in the past.
>
>
>>
>> To open second, maybe third and even forth ways for apps to use a
>> device, likely going out of sync soon, does only load maintenance work
>> without real gain.
>
> Well it was an experiment at the time to see how well such a concept
> would work.  I had done it in a way to minimize maintenance load going
> forward.  On both counts I feel the interface actually has done very
> well, nonstandard though it may be.
>
> I still get the general impression that the user community really has
> liked the sysfs interface, but the developers never really got very fond
> of it :-(

  From my point of view as an application developer I never tried to use
sysfs at all. I admit that it's nice to use from a shell script in "known
environments" (like setting up a card for recording with cat etc.) but what
about error handling? How will I (the script) know, if setting a control is
successful or not? Currently I don't know if v4l2-ctl returns some useful
exit code, but with ioctls it's a lot easier to track errors.
  I never liked to handle with directories and files, reading and writing if
there's a function which is doing the same thing in a much easier way. :-)

  But all this might be related to my not-really-present knowledge of using
sysfs in the right way.

  And reading other posts debugfs seems to be the better choice (just read
some articles on it to get a general survey of it).

Regards,
Lars.

>
>
>>
>> We should stay sharp to discover something others don't want to let us
>> know about. All other ideas about markets are illusions. Or?
>>
>> So, debugfs sounds much better than sysfs for my taste.
>>
>> Any app and any driver, going out of sync on the latter, will remind us
>> that backward compat _must always be guaranteed_  ...
>>
>> Or did change anything on that and is sysfs excluded from that rule?
>
> Backwards compatibility is very important and thus any kind of new
> interface deserves a lot of forethought to ensure that choices are made
> in the present that people will regret in the future.  Making an
> interface self-describing is one way that helps with compatibility: if
> the app can discover on its own how to use the interface then it can
> adapt to interface changes in the future.  I think a lot of people get
> their brains so wrapped around the "ioctl-way" of doing things and then
> they try to map that concept into a sysfs-like (or debugfs-like)
> abstraction that they don't see how to naturally take advantage of what
> is possible there.
>
>    -Mike
>
