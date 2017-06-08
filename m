Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f176.google.com ([209.85.192.176]:33489 "EHLO
        mail-pf0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750725AbdFHNN3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Jun 2017 09:13:29 -0400
Received: by mail-pf0-f176.google.com with SMTP id 83so17142505pfr.0
        for <linux-media@vger.kernel.org>; Thu, 08 Jun 2017 06:13:29 -0700 (PDT)
Received: from ubuntu.windy (c122-106-153-7.carlnfd1.nsw.optusnet.com.au. [122.106.153.7])
        by smtp.gmail.com with ESMTPSA id v3sm11157251pfi.3.2017.06.08.06.13.25
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Jun 2017 06:13:26 -0700 (PDT)
Date: Thu, 8 Jun 2017 23:13:42 +1000
From: Vincent McIntyre <vincent.mcintyre@gmail.com>
To: linux-media@vger.kernel.org
Subject: [media_build] regression at 3a17e11 "update v4.10_sched_signal.patch"
Message-ID: <20170608131339.GA11167@ubuntu.windy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

I think the build was broken by this commit.

  3a17e11 "update v4.10_sched_signal.patch"

It's been fun learning about git bisect.

$ cat /etc/lsb-release 
DISTRIB_ID=Ubuntu
DISTRIB_RELEASE=16.04
DISTRIB_CODENAME=xenial
DISTRIB_DESCRIPTION="Ubuntu 16.04.2 LTS"

The build script falls over on these kernels, in the same way

 4.4.0-77-generic x86_64
 4.8.0-53-generic x86_64


$ ./build --main-git --depth 1 -v 1
...<elided>
******************
* Start building *
* ******************
* $ make allyesconfig
* make -C /home/me/git/clones/media_build/v4l allyesconfig
* make[1]: Entering directory '/home/me/git/clones/media_build/v4l'
* make[2]: Entering directory '/home/me/git/clones/media_build/linux'
* Syncing with dir ../media/
* Applying patches for kernel 4.4.0-77-generic
* patch -s -f -N -p1 -i ../backports/api_version.patch
* patch -s -f -N -p1 -i ../backports/pr_fmt.patch
* patch -s -f -N -p1 -i ../backports/debug.patch
* patch -s -f -N -p1 -i ../backports/drx39xxj.patch
* patch -s -f -N -p1 -i ../backports/v4.10_sched_signal.patch
* 1 out of 1 hunk FAILED
* Makefile:137: recipe for target 'apply_patches' failed
* make[2]: *** [apply_patches] Error 1
* make[2]: Leaving directory '/home/me/git/clones/media_build/linux'
* Makefile:383: recipe for target 'allyesconfig' failed
* make[1]: *** [allyesconfig] Error 2
* make[1]: Leaving directory '/home/me/git/clones/media_build/v4l'
* Makefile:26: recipe for target 'allyesconfig' failed
* make: *** [allyesconfig] Error 2
* can't select all drivers at ./build.new line 521
*

Hopefully this of some use to someone
Vince
