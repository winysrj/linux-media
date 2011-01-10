Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:56950 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753197Ab1AJMdO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Jan 2011 07:33:14 -0500
Message-ID: <4D2AFC85.40709@redhat.com>
Date: Mon, 10 Jan 2011 10:33:09 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Vincent McIntyre <vincent.mcintyre@gmail.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org
Subject: Re: Debug code in HG repositories
References: <201101072053.37211@orion.escape-edv.de>	<AANLkTinj2NcOcVUPifsNcvbs=Mivwe89+hg8XLsCJnQ7@mail.gmail.com>	<201101072206.30323.hverkuil@xs4all.nl> <AANLkTik0-n-KBrTQa4kjahLXyqLagMp+A77zcV3hVAx5@mail.gmail.com>
In-Reply-To: <AANLkTik0-n-KBrTQa4kjahLXyqLagMp+A77zcV3hVAx5@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 07-01-2011 23:02, Vincent McIntyre escreveu:
> On 1/8/11, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> 
>> Have you tried Mauro's media_build tree? I had to use it today to test a
>> driver from git on a 2.6.35 kernel. Works quite nicely. Perhaps we should
>> promote this more. I could add backwards compatibility builds to my daily
>> build script that uses this in order to check for which kernel versions
>> this compiles if there is sufficient interest.
>>
> 
> As an end-user I would be interested in seeing this added, since it
> will allow faster detection of breakage in the older versions. For
> instance building against 2.6.32 fails like this:
> 
>   CC [M]  /home/vjm/git/clones/linuxtv.org/new_build/v4l/hdpvr-i2c.o
> /home/vjm/git/clones/linuxtv.org/new_build/v4l/hdpvr-i2c.c: In
> function 'hdpvr_new_i2c_ir':
> /home/vjm/git/clones/linuxtv.org/new_build/v4l/hdpvr-i2c.c:62: error:
> too many arguments to function 'i2c_new_probed_device'
> make[4]: *** [/home/vjm/git/clones/linuxtv.org/new_build/v4l/hdpvr-i2c.o]
> Error 1
> make[3]: *** [_module_/home/vjm/git/clones/linuxtv.org/new_build/v4l] Error 2
> make[3]: Leaving directory `/usr/src/linux-headers-2.6.32-26-ec297b-generic'
> make[2]: *** [default] Error 2
> make[2]: Leaving directory `/home/vjm/git/clones/linuxtv.org/new_build/v4l'
> make[1]: *** [all] Error 2
> make[1]: Leaving directory `/home/vjm/git/clones/linuxtv.org/new_build'
> make: *** [default] Error 2
> 
> It's unclear that adding this would cause a lot of extra work; the
> patches that need to be applied are quite few - a tribute to the
> design work!

That's weird. Here, it compiles fine against my 2.6.32 kernel, as there's a
patch that removes the extra parameter. I'll double check and add a fix
if I found something wrong.

> For what it's worth, I've attached the shell script I use to pull
> updates and do a new build.
> Doing the initial setup is well explained by the
> linuxtv.org/media_tree.git page,
> but this script may be of use to end users wanting to track development.

Thanks for your script, but it seems specific to your environment. Could you
please make it more generic and perhaps patch the existing build.sh script?
It would be nice to have some optional parameters there, to make life easier
for end-users.

Thanks!
Mauro
