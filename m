Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:32836 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726778AbeGLUYX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Jul 2018 16:24:23 -0400
Received: by mail-wm0-f67.google.com with SMTP id z6-v6so2891854wma.0
        for <linux-media@vger.kernel.org>; Thu, 12 Jul 2018 13:13:15 -0700 (PDT)
From: Peter Korsgaard <peter@korsgaard.com>
To: Baruch Siach <baruch@tkos.co.il>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH] libv4l: fixup lfs mismatch in preload libraries
References: <20180711132251.13172-1-ezequiel@collabora.com>
        <20180711115505.5b93de93@coco.lan> <878t6h5zqn.fsf@tkos.co.il>
        <20180712055428.0d853914@coco.lan> <87tvp4fery.fsf@tkos.co.il>
Date: Thu, 12 Jul 2018 22:13:11 +0200
In-Reply-To: <87tvp4fery.fsf@tkos.co.il> (Baruch Siach's message of "Thu, 12
        Jul 2018 22:13:53 +0300")
Message-ID: <87r2k8usa0.fsf@dell.be.48ers.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>>>>> "Baruch" == Baruch Siach <baruch@tkos.co.il> writes:

Hi,

 >> The link Peter provided seems to be specific to glibc. The main
 >> point I want to bring is: would this change affect users with
 >> other setups? There are some users that compile it against FreeBSD
 >> and Android. Some compile using dietlibc or uclibc. Also, people
 >> build it against 32-bits and 64-bits on x86, arm and other archs.
 >> 
 >> So, the question is: are you sure that the above change is also valid for
 >> *all* other environments? If not, I would be expecting it to be
 >> attached to some automake test, to be sure that it will be applied
 >> only to the affected setups.

 > Buildroot has been carrying this patch since 2012[1] with no one
 > complaining. Buildroot supports glibc, uClibc, and musl libc on a wide
 > range of architectures (x86, ARM, MIPS, PowerPC, Sparc, xtensa, arc, and
 > more) both 32-bit and 64-bit.

Indeed. I believe these comes from the single UNIX specification:

http://www.unix.org/version2/whatsnew/lfs20mar.html#3.3

And these defines are what the AC_SYS_LARGEFILE autoconf macro uses:

https://www.gnu.org/software/autoconf/manual/autoconf-2.65/html_node/System-Services.html

-- 
Bye, Peter Korsgaard
