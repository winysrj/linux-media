Return-path: <mchehab@pedra>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:56296 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755606Ab1AKKr0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Jan 2011 05:47:26 -0500
Received: by gyb11 with SMTP id 11so7683423gyb.19
        for <linux-media@vger.kernel.org>; Tue, 11 Jan 2011 02:47:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4D2AFC85.40709@redhat.com>
References: <201101072053.37211@orion.escape-edv.de>
	<AANLkTinj2NcOcVUPifsNcvbs=Mivwe89+hg8XLsCJnQ7@mail.gmail.com>
	<201101072206.30323.hverkuil@xs4all.nl>
	<AANLkTik0-n-KBrTQa4kjahLXyqLagMp+A77zcV3hVAx5@mail.gmail.com>
	<4D2AFC85.40709@redhat.com>
Date: Tue, 11 Jan 2011 21:47:25 +1100
Message-ID: <AANLkTi=f-KBMROg1zWzUXyXoBUY3b=ksh8r=uSbbzoue@mail.gmail.com>
Subject: Re: Debug code in HG repositories
From: Vincent McIntyre <vincent.mcintyre@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 1/10/11, Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
> Em 07-01-2011 23:02, Vincent McIntyre escreveu:
>> On 1/8/11, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>
>>> Have you tried Mauro's media_build tree? I had to use it today to test a
>>> driver from git on a 2.6.35 kernel. Works quite nicely. Perhaps we should
>>> promote this more. I could add backwards compatibility builds to my daily
>>> build script that uses this in order to check for which kernel versions
>>> this compiles if there is sufficient interest.
>>>
>>
>> As an end-user I would be interested in seeing this added, since it
>> will allow faster detection of breakage in the older versions. For
>> instance building against 2.6.32 fails like this:
>>
>>   CC [M]  /home/vjm/git/clones/linuxtv.org/new_build/v4l/hdpvr-i2c.o
>> /home/vjm/git/clones/linuxtv.org/new_build/v4l/hdpvr-i2c.c: In
>> function 'hdpvr_new_i2c_ir':
>> /home/vjm/git/clones/linuxtv.org/new_build/v4l/hdpvr-i2c.c:62: error:
>> too many arguments to function 'i2c_new_probed_device'
>> make[4]: *** [/home/vjm/git/clones/linuxtv.org/new_build/v4l/hdpvr-i2c.o]
>> Error 1
>> make[3]: *** [_module_/home/vjm/git/clones/linuxtv.org/new_build/v4l]
>> Error 2
>> make[3]: Leaving directory
>> `/usr/src/linux-headers-2.6.32-26-ec297b-generic'
>> make[2]: *** [default] Error 2
>> make[2]: Leaving directory
>> `/home/vjm/git/clones/linuxtv.org/new_build/v4l'
>> make[1]: *** [all] Error 2
>> make[1]: Leaving directory `/home/vjm/git/clones/linuxtv.org/new_build'
>> make: *** [default] Error 2
>>
>> It's unclear that adding this would cause a lot of extra work; the
>> patches that need to be applied are quite few - a tribute to the
>> design work!
>
> That's weird. Here, it compiles fine against my 2.6.32 kernel, as there's a
> patch that removes the extra parameter. I'll double check and add a fix
> if I found something wrong.

I think a couple of modules may have been missed;
$ cd media_build
$ grep -rl i2c_new_probed_device v4l | grep -v .o
v4l/cx23885-i2c.c
v4l/bttv-input.c
v4l/cx88-input.c
v4l/ivtv-i2c.c
v4l/hdpvr-i2c.c
v4l/v4l2-common.c
v4l/cx18-i2c.c
v4l/em28xx-cards.c

$ grep +++ backports/v2.6.35_i2c_new_probed_device.patch
+++ b/drivers/media/video/bt8xx/bttv-input.c    Tue Oct 26 14:17:09 2010 -0200
+++ b/drivers/media/video/cx18/cx18-i2c.c       Tue Oct 26 14:17:09 2010 -0200
+++ b/drivers/media/video/cx23885/cx23885-i2c.c Tue Oct 26 14:17:09 2010 -0200
+++ b/drivers/media/video/em28xx/em28xx-cards.c Tue Oct 26 14:17:09 2010 -0200
+++ b/drivers/media/video/ivtv/ivtv-i2c.c       Tue Oct 26 14:17:09 2010 -0200
+++ b/drivers/media/video/v4l2-common.c Tue Oct 26 14:17:09 2010 -0200
+++ b/drivers/media/video/ivtv/ivtv-i2c.c       Tue Oct 26 23:18:52 2010 -0200

which on the face of it suggests
  btty-input.c
  cx88-input.c
  hdpvr-i2c.c
need looking at.

I get the same result whether building from a git clone of media-tree
or via media_build/build.sh.

I am building against ubuntu 2.6.32-26-generic aka 2.6.32.24+drm33.11, on i386.
I am using just their kernel-headers package for the build. Usually it works ok.

Cheers
Vince
