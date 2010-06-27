Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36799 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753086Ab0F0Beu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Jun 2010 21:34:50 -0400
Message-ID: <4C26AAAC.1020803@redhat.com>
Date: Sat, 26 Jun 2010 22:34:36 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Correct way to do s_ctrl ioctl taking into account subdev 	framework?
References: <AANLkTim9TfITmvy7nEuSVJnCxRwCkpbmgRc2FIIIWHGF@mail.gmail.com>	<201006262051.52754.hverkuil@xs4all.nl> <AANLkTikPKv6iCQmV14JSiR61AUMswsOoTB7i-eSHAwH4@mail.gmail.com>
In-Reply-To: <AANLkTikPKv6iCQmV14JSiR61AUMswsOoTB7i-eSHAwH4@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 26-06-2010 16:04, Devin Heitmueller escreveu:
> On Sat, Jun 26, 2010 at 2:51 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> There really is no good way at the moment to handle cases like this, or at
>> least not without a lot of work.
> 
> Ok, it's good to know I'm not missing something obvious.
> 
>> The plan is to have the framework merged in time for 2.6.36. My last patch
>> series for the framework already converts a bunch of subdevs to use it. Your
>> best bet is to take the patch series and convert any remaining subdevs used
>> by em28xx and em28xx itself. I'd be happy to add those patches to my patch
>> series, so that when I get the go ahead the em28xx driver will be fixed
>> automatically.
>>
>> It would be useful for me anyway to have someone else use it: it's a good
>> check whether my documentation is complete.
> 
> Sure, could you please point me to the tree in question and I'll take a look?
> 
> Given I've got applications failing, for the short term I will likely
> just submit a patch which makes the s_ctrl always return zero
> regardless of the subdev response, instead of returning 1.

Yeah, something like:

if (rc = 1) {
	rc = 0;
...

would do the trick. Yet, the application is broken, as it is considering a positive
return as an error. A positive code should never be considered as an error. So, we
need to fix v4l2-ctl as well (ok, returning 1 is wrong as well, as this is a non-v4l2
compliance in this case).

We might add a new handler at subdev, but, as Laurent is reworking
it, the above trick would be an acceptable workaround.

Cheers,
Mauro.
