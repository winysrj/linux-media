Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:34317 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727265AbeIYNtS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Sep 2018 09:49:18 -0400
Subject: Re: cron job: media_tree daily build: ERRORS
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org, "Jasmin J." <jasmin@anw.at>
References: <42f7eee6c92076f081331f865defe5aa@smtp-cloud7.xs4all.net>
Message-ID: <e2aa8823-7755-0cb4-aa0f-3b6f0531c7cf@xs4all.nl>
Date: Tue, 25 Sep 2018 09:42:59 +0200
MIME-Version: 1.0
In-Reply-To: <42f7eee6c92076f081331f865defe5aa@smtp-cloud7.xs4all.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The git-spec ERRORS were due to a missing package on the build server, nothing
to do with errors in our code/documentation.

Should be fixed now.

Regards,

	Hans

On 09/25/2018 05:50 AM, Hans Verkuil wrote:
> This message is generated daily by a cron job that builds media_tree for
> the kernels and architectures in the list below.
> 
> Results of the daily build of media_tree:
> 
> date:			Tue Sep 25 05:00:38 CEST 2018
> media-tree git hash:	4158757395b300b6eb308fc20b96d1d231484413
> media_build git hash:	44385b9c61ecc27059a651885895c8ea09cd4179
> v4l-utils git hash:	4890391b5d9e25ddd933e29c8f812a138e77919b
> edid-decode git hash:	5eeb151a748788666534d6ea3da07f90400d24c2
> gcc version:		i686-linux-gcc (GCC) 8.1.0
> sparse version:		0.5.2
> smatch version:		0.5.1
> host hardware:		x86_64
> host os:		4.18.0-1-amd64
> 
> linux-git-arm-at91: OK
> linux-git-arm-davinci: OK
> linux-git-arm-multi: OK
> linux-git-arm-pxa: OK
> linux-git-arm-stm32: OK
> linux-git-arm64: OK
> linux-git-i686: OK
> linux-git-mips: OK
> linux-git-powerpc64: OK
> linux-git-sh: WARNINGS
> linux-git-x86_64: OK
> Check COMPILE_TEST: OK
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
> linux-3.16.57-i686: OK
> linux-3.16.57-x86_64: OK
> linux-3.17.8-i686: OK
> linux-3.17.8-x86_64: OK
> linux-3.18.119-i686: OK
> linux-3.18.119-x86_64: OK
> linux-3.19.8-i686: OK
> linux-3.19.8-x86_64: OK
> linux-4.0.9-i686: OK
> linux-4.0.9-x86_64: OK
> linux-4.1.52-i686: OK
> linux-4.1.52-x86_64: OK
> linux-4.2.8-i686: OK
> linux-4.2.8-x86_64: OK
> linux-4.3.6-i686: OK
> linux-4.3.6-x86_64: OK
> linux-4.4.152-i686: OK
> linux-4.4.152-x86_64: OK
> linux-4.5.7-i686: OK
> linux-4.5.7-x86_64: OK
> linux-4.6.7-i686: OK
> linux-4.6.7-x86_64: OK
> linux-4.7.10-i686: OK
> linux-4.7.10-x86_64: OK
> linux-4.8.17-i686: OK
> linux-4.8.17-x86_64: OK
> linux-4.9.124-i686: OK
> linux-4.9.124-x86_64: OK
> linux-4.10.17-i686: OK
> linux-4.10.17-x86_64: OK
> linux-4.11.12-i686: OK
> linux-4.11.12-x86_64: OK
> linux-4.12.14-i686: OK
> linux-4.12.14-x86_64: OK
> linux-4.13.16-i686: OK
> linux-4.13.16-x86_64: OK
> linux-4.14.67-i686: OK
> linux-4.14.67-x86_64: OK
> linux-4.15.18-i686: OK
> linux-4.15.18-x86_64: OK
> linux-4.16.18-i686: OK
> linux-4.16.18-x86_64: OK
> linux-4.17.19-i686: OK
> linux-4.17.19-x86_64: OK
> linux-4.18.5-i686: OK
> linux-4.18.5-x86_64: OK
> linux-4.19-rc1-i686: OK
> linux-4.19-rc1-x86_64: OK
> apps: OK
> spec-git: ERRORS
> sparse: WARNINGS
> 
> Detailed results are available here:
> 
> http://www.xs4all.nl/~hverkuil/logs/Tuesday.log
> 
> Full logs are available here:
> 
> http://www.xs4all.nl/~hverkuil/logs/Tuesday.tar.bz2
> 
> The Media Infrastructure API from this daily build is here:
> 
> http://www.xs4all.nl/~hverkuil/spec/index.html
> 
