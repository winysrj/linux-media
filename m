Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:36980 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070Ab1EALu0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 May 2011 07:50:26 -0400
Received: by eyx24 with SMTP id 24so1515371eyx.19
        for <linux-media@vger.kernel.org>; Sun, 01 May 2011 04:50:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTim9vtBAE1dbOXAwW2Crh7aiMucD3w@mail.gmail.com>
References: <BANLkTikBm0gmNd8oQ6CN+cAEbYhWEGvWPA@mail.gmail.com>
	<BANLkTim9vtBAE1dbOXAwW2Crh7aiMucD3w@mail.gmail.com>
Date: Sun, 1 May 2011 21:50:23 +1000
Message-ID: <BANLkTin65u2oGhJczSkwNxnRDovWOw4X+A@mail.gmail.com>
Subject: Re: Build Failure
From: Vincent McIntyre <vincent.mcintyre@gmail.com>
To: Colin Minihan <colin.minihan@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 5/1/11, Colin Minihan <colin.minihan@gmail.com> wrote:
> On Ubuntu 10.04 attempting to run
>
> git clone git://linuxtv.org/media_build.git
> cd media_build
> ./check_needs.pl
> make -C linux/ download
> make -C linux/ untar
> make stagingconfig
> make
>
>  results in the following failure
> ...

I see this too (platform details below) but only if I do the 'make
stagingconfig' step
which I don't usually need to. The patch Mauro supplied worked for me;
I just edited
the two files involved and reran 'make' at the point at which the
build had failed.
v4l/config-compat.h had the expected extra #define in it and the build
completed ok.
I haven't tested the resulting module as I don't have the relevant hardware.

Cheers
Vince

platform details:

$ cat /etc/issue
Ubuntu 10.04.2 LTS \n \l
$ uname -a
Linux ubuntu 2.6.32-31-generic #61-Ubuntu SMP Fri Apr 8 18:24:35 UTC
2011 i686 GNU/Linux
$ cat v4l/.version
VERSION=2
PATCHLEVEL:=6
SUBLEVEL:=32
KERNELRELEASE:=2.6.32-31-generic
