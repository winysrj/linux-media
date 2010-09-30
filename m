Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:21407 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932138Ab0I3Pik (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Sep 2010 11:38:40 -0400
Message-ID: <4CA4AEFD.7090806@redhat.com>
Date: Thu, 30 Sep 2010 12:38:37 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org
Subject: Re: [GIT PATCHES FOR 2.6.37] fix long-standing tm6000 compile warning
References: <4f06d6c22359c65faa965a4924a06d0d.squirrel@webmail.xs4all.nl>
In-Reply-To: <4f06d6c22359c65faa965a4924a06d0d.squirrel@webmail.xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 30-09-2010 11:32, Hans Verkuil escreveu:
> The following changes since commit e847bbbf9273533c15c6e8aab204ba62c238cf42:
>   Hans Verkuil (1):
>         V4L/DVB: v4l2-common: Move v4l2_find_nearest_format from
> videodev2.h to v4l2-common.h
> 
> are available in the git repository at:
> 
>   ssh://linuxtv.org/git/hverkuil/v4l-dvb.git fixes
> 
> Hans Verkuil (1):
>       tm6000-core.c: fix compile warning

That warning is there for a purpose: it shouldn't be required to re-initialize
the frequency every time analog mode is selected, especially since it takes
some time to set a frequency on tm6000, as the chipset has a broken i2c
implementation and requires some milisseconds after each url sent, otherwise
the device becomes unresponsive.

What happens with tm5600/tm6000 devices (not sure if this affects tm6010) is that,
if the channel has a weak signal, the chip goes to some sleep state, where it
stops receiving the stream. Unfortunately, even after signal return, the stream
doesn't return. So, we need to call the function that changes the channel frequency
just as a way to wake up the device.

This is an ugly hack, and eventually there are some other ways of doing that that
would be faster than what this routine does, but we never discovered.

My hope on keeping this warning is that one day during the driver development,
we would discover the root cause and provide a better fix for it (or when moving
it from staging to drivers/media).

I don't object to remove the warning though, but the better would be to move the
frequency declaration to the beginning of the function, avoiding to have the
block under { }.

> 
>  drivers/staging/tm6000/tm6000-core.c |   13 ++++++++-----
>  1 files changed, 8 insertions(+), 5 deletions(-)
> 
> 

