Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62725 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751002Ab2G3PzT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Jul 2012 11:55:19 -0400
Message-ID: <5016AE3B.7030108@redhat.com>
Date: Mon, 30 Jul 2012 12:54:35 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: htl10@users.sourceforge.net
CC: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Subject: Re: patches to media_build, and a few other things
References: <1342477272.58502.YahooMailClassic@web29403.mail.ird.yahoo.com> <50057829.206@iki.fi>
In-Reply-To: <50057829.206@iki.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hin-Tak,

Em 17-07-2012 11:35, Antti Palosaari escreveu:
> On 07/17/2012 01:21 AM, Hin-Tak Leung wrote:

It seems I lost your original email. Anyway:

>> I have a couple of patches to my local media_build repo, which do these:
>>
>> - a new option "--as-is" to the build script. It basically suppresses any git pull/rebase to both media_build and the ./media subdirectory (if used in combination with --main-git). In combination to --main-git, you are left on your own and be wholy responsible about what is inside ./media - I use that to check Antti's work (which is on a branch), and also since I have some interrim patches to media_build itself, I would prefer I can tell it not to  pull/merge .

Seems fine for me.
>>
>> - a small change to v4l/Makefile , to install under /lib/modules/$(KERNELRELEASE)/updates/... - recent fedora seems to have a modprobe preference to load from "../updates/..." (or at least, that's the case of having installed compat-wireless at some stage - one might want to steal some code from that?), when more than one kernel module of the same name exists. This is so as not to trash distro-shipped modules (and also if one cleans out ".../updates/..." and runs "depmod -a", one is back to distro as shipped behavior). Also trashing distro-shipped modules have the side-effect of making drpm not to work and whole kernel packages are downloaded in the next "yum upgrade".

This needs to be smart enough to detect if the system is Fedora and if it is a version compatible with "updates" (17 or upper ?).

It should be noticed that Ubuntu has a similar kind of preference, but it uses the modules on a separate place.


>>
>> I also have a suggestion to make:
>>
>> - How http://linux/linuxtv.org/downloads/drivers/linux-media-LATEST.tar.bz2
>> is generated, probably should be documented. Over the weekend I was playing with one with timestamp Jul 7, and it is quite broken with firstly header files not in the right place (linux/v4l2-common.h instead of media/v4l2-common.h), and also the following:

It does:
	$ run make -C linux todaytar DIR=~/tmp/media_build

The script should be updating the media_build to the very latest version.

I'll double check if this is happening fine.

Regards,
Mauro
