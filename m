Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f41.google.com ([74.125.83.41]:46872 "EHLO
        mail-pg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752730AbdLHXQU (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Dec 2017 18:16:20 -0500
Received: by mail-pg0-f41.google.com with SMTP id b11so7793586pgu.13
        for <linux-media@vger.kernel.org>; Fri, 08 Dec 2017 15:16:20 -0800 (PST)
Date: Sat, 9 Dec 2017 10:16:08 +1100
From: Vincent McIntyre <vincent.mcintyre@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: "Jasmin J." <jasmin@anw.at>, linux-media@vger.kernel.org,
        d.scheller@gmx.net
Subject: Re: [PATCH] build: Added missing timer_setup_on_stack
Message-ID: <20171208231606.GA5540@shambles.windy>
References: <1512766859-7667-1-git-send-email-jasmin@anw.at>
 <3343c1fd-d0f0-46b1-fd3f-150f36de6fa4@anw.at>
 <21ccbddb-eada-fa44-93ea-f0b80e17d409@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21ccbddb-eada-fa44-93ea-f0b80e17d409@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Dec 08, 2017 at 10:12:05PM +0100, Hans Verkuil wrote:
...
> 
> I've applied all your patches. Thank you very much for working on this.
> 
> Let's see what the result of the nightly build will be.
> 
> In general reverting kernel patches to make a driver compile is something of a
> last resort. It tends to be painful to maintain in the long run, at least, that's
> been my experience.
> 

Hi,

thanks both for your work on this. Not quite there yet however.

$ make allyesconfig
make -C /home/me/git/clones/media_build/v4l allyesconfig
make[1]: Entering directory '/home/me/git/clones/media_build/v4l'
No version yet, using 4.4.0-103-generic
make[2]: Entering directory '/home/me/git/clones/media_build/linux'
Syncing with dir ../media/
Applying patches for kernel 4.4.0-103-generic
patch -s -f -N -p1 -i ../backports/api_version.patch
patch -s -f -N -p1 -i ../backports/pr_fmt.patch
1 out of 1 hunk FAILED
Makefile:130: recipe for target 'apply_patches' failed
make[2]: *** [apply_patches] Error 1
make[2]: Leaving directory '/home/me/git/clones/media_build/linux'
Makefile:374: recipe for target 'allyesconfig' failed
make[1]: *** [allyesconfig] Error 2
make[1]: Leaving directory '/home/me/git/clones/media_build/v4l'
Makefile:26: recipe for target 'allyesconfig' failed
make: *** [allyesconfig] Error 2
can't select all drivers at ./build line 525
+ status=29

FWIW I also get the same failure on a 4.10 machine:
+ cat /proc/version_signature
Ubuntu 4.10.0-38.42~16.04.1-generic 4.10.17

I will have a look to see if I can spot this one.
Cheers
Vince
