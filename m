Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:54264 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753297AbeDAKOv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 1 Apr 2018 06:14:51 -0400
Subject: Congratulations! Was: cron job: media_tree daily build: WARNINGS
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
References: <b1d4e108add55b05fe6549b6794b301d@smtp-cloud8.xs4all.net>
Cc: "Jasmin J." <jasmin@anw.at>
Message-ID: <1e1a580e-d077-a4d0-f074-2884b987c16f@xs4all.nl>
Date: Sun, 1 Apr 2018 12:14:49 +0200
MIME-Version: 1.0
In-Reply-To: <b1d4e108add55b05fe6549b6794b301d@smtp-cloud8.xs4all.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

Many thanks go to Jasmin who managed to fix media_build so all kernels now
give an 'OK' result. The only remaining warning is for v4l-utils, which I just
fixed.

So if all goes well we should have an 'OK' tomorrow when the next build runs.

Thank you!

	Hans

On 01/04/18 11:49, Hans Verkuil wrote:
> This message is generated daily by a cron job that builds media_tree for
> the kernels and architectures in the list below.
> 
> Results of the daily build of media_tree:
> 
> date:			Sun Apr  1 10:54:56 CEST 2018
> media-tree git hash:	6ccd228e0cfce2a4f44558422d25c60fcb1a6710
> media_build git hash:	541653bb52fcf7c34b8b83a4c8cc66b09c68ac37
> v4l-utils git hash:	3dc9af2b54eddb531823b99e77f3f212bdcc9cca
> gcc version:		i686-linux-gcc (GCC) 7.3.0
> sparse version:		v0.5.0-3994-g45eb2282
> smatch version:		v0.5.0-3994-g45eb2282
> host hardware:		x86_64
> host os:		4.14.0-3-amd64
> 
> linux-git-arm-at91: OK
> linux-git-arm-davinci: OK
> linux-git-arm-multi: OK
> linux-git-arm-pxa: OK
> linux-git-arm-stm32: OK
> linux-git-arm64: OK
> linux-git-blackfin-bf561: OK
> linux-git-i686: OK
> linux-git-m32r: OK
> linux-git-mips: OK
> linux-git-powerpc64: OK
> linux-git-sh: OK
> linux-git-x86_64: OK
> linux-2.6.36.4-i686: OK
> linux-2.6.36.4-x86_64: OK
> linux-2.6.37.6-i686: OK
> linux-2.6.37.6-x86_64: OK
> linux-2.6.38.8-i686: OK
> linux-2.6.38.8-x86_64: OK
> linux-2.6.39.4-i686: OK
> linux-2.6.39.4-x86_64: OK
> linux-3.0.101-i686: OK
> linux-3.0.101-x86_64: OK
> linux-3.1.10-i686: OK
> linux-3.1.10-x86_64: OK
> linux-3.2.101-i686: OK
> linux-3.2.101-x86_64: OK
> linux-3.3.8-i686: OK
> linux-3.3.8-x86_64: OK
> linux-3.4.113-i686: OK
> linux-3.4.113-x86_64: OK
> linux-3.5.7-i686: OK
> linux-3.5.7-x86_64: OK
> linux-3.6.11-i686: OK
> linux-3.6.11-x86_64: OK
> linux-3.7.10-i686: OK
> linux-3.7.10-x86_64: OK
> linux-3.8.13-i686: OK
> linux-3.8.13-x86_64: OK
> linux-3.9.11-i686: OK
> linux-3.9.11-x86_64: OK
> linux-3.10.108-i686: OK
> linux-3.10.108-x86_64: OK
> linux-3.11.10-i686: OK
> linux-3.11.10-x86_64: OK
> linux-3.12.74-i686: OK
> linux-3.12.74-x86_64: OK
> linux-3.13.11-i686: OK
> linux-3.13.11-x86_64: OK
> linux-3.14.79-i686: OK
> linux-3.14.79-x86_64: OK
> linux-3.15.10-i686: OK
> linux-3.15.10-x86_64: OK
> linux-3.16.56-i686: OK
> linux-3.16.56-x86_64: OK
> linux-3.17.8-i686: OK
> linux-3.17.8-x86_64: OK
> linux-3.18.102-i686: OK
> linux-3.18.102-x86_64: OK
> linux-3.19.8-i686: OK
> linux-3.19.8-x86_64: OK
> linux-4.0.9-i686: OK
> linux-4.0.9-x86_64: OK
> linux-4.1.51-i686: OK
> linux-4.1.51-x86_64: OK
> linux-4.2.8-i686: OK
> linux-4.2.8-x86_64: OK
> linux-4.3.6-i686: OK
> linux-4.3.6-x86_64: OK
> linux-4.4.109-i686: OK
> linux-4.4.109-x86_64: OK
> linux-4.5.7-i686: OK
> linux-4.5.7-x86_64: OK
> linux-4.6.7-i686: OK
> linux-4.6.7-x86_64: OK
> linux-4.7.10-i686: OK
> linux-4.7.10-x86_64: OK
> linux-4.8.17-i686: OK
> linux-4.8.17-x86_64: OK
> linux-4.9.91-i686: OK
> linux-4.9.91-x86_64: OK
> linux-4.14.31-i686: OK
> linux-4.14.31-x86_64: OK
> linux-4.15.14-i686: OK
> linux-4.15.14-x86_64: OK
> apps: WARNINGS
> spec-git: OK
> smatch: OK
> 
> Detailed results are available here:
> 
> http://www.xs4all.nl/~hverkuil/logs/Sunday.log
> 
> Full logs are available here:
> 
> http://www.xs4all.nl/~hverkuil/logs/Sunday.tar.bz2
> 
> The Media Infrastructure API from this daily build is here:
> 
> http://www.xs4all.nl/~hverkuil/spec/index.html
> 
