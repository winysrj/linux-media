Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:40594 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932120AbeCKLXB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 11 Mar 2018 07:23:01 -0400
Subject: Re: cron job: media_tree daily build: ERRORS
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
References: <9ee0f18544d9bc6deb764114b3cd29b6@smtp-cloud7.xs4all.net>
From: "Jasmin J." <jasmin@anw.at>
Message-ID: <a56b1d83-e033-af63-cf52-6bd9ffc91f05@anw.at>
Date: Sun, 11 Mar 2018 12:22:57 +0100
MIME-Version: 1.0
In-Reply-To: <9ee0f18544d9bc6deb764114b3cd29b6@smtp-cloud7.xs4all.net>
Content-Type: text/plain; charset=utf-8
Content-Language: de-AT
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

Sorry, my fault!
Will fix that soon.

BR,
   Jasmin

On 03/11/2018 05:36 AM, Hans Verkuil wrote:
> This message is generated daily by a cron job that builds media_tree for
> the kernels and architectures in the list below.
> 
> Results of the daily build of media_tree:
> 
> date:			Sun Mar 11 05:00:11 CET 2018
> media-tree git hash:	e68854a2588a923b31eebce348f8020374843f8e
> media_build git hash:	8b244766d710a8687ae6156abde9d6f377a168ad
> v4l-utils git hash:	14ce03c18ef67aa7a3d5781f015be855fd43839c
> gcc version:		i686-linux-gcc (GCC) 7.3.0
> sparse version:		v0.5.0-3994-g45eb2282
> smatch version:		v0.5.0-3994-g45eb2282
> host hardware:		x86_64
> host os:		4.14.0-3-amd64
> 
> linux-git-arm-at91: OK
> linux-git-arm-davinci: OK
> linux-git-arm-multi: WARNINGS
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
> linux-2.6.36.4-i686: ERRORS
> linux-2.6.36.4-x86_64: ERRORS
> linux-2.6.37.6-i686: ERRORS
> linux-2.6.37.6-x86_64: ERRORS
> linux-2.6.38.8-i686: ERRORS
> linux-2.6.38.8-x86_64: ERRORS
> linux-2.6.39.4-i686: ERRORS
> linux-2.6.39.4-x86_64: ERRORS
> linux-3.0.60-i686: ERRORS
> linux-3.0.60-x86_64: ERRORS
> linux-3.1.10-i686: ERRORS
> linux-3.1.10-x86_64: ERRORS
> linux-3.2.98-i686: ERRORS
> linux-3.2.98-x86_64: ERRORS
> linux-3.3.8-i686: ERRORS
> linux-3.3.8-x86_64: ERRORS
> linux-3.4.27-i686: ERRORS
> linux-3.4.27-x86_64: ERRORS
> linux-3.5.7-i686: WARNINGS
> linux-3.5.7-x86_64: WARNINGS
> linux-3.6.11-i686: WARNINGS
> linux-3.6.11-x86_64: WARNINGS
> linux-3.7.4-i686: WARNINGS
> linux-3.7.4-x86_64: WARNINGS
> linux-3.8-i686: WARNINGS
> linux-3.8-x86_64: WARNINGS
> linux-3.9.2-i686: ERRORS
> linux-3.9.2-x86_64: ERRORS
> linux-3.10.1-i686: ERRORS
> linux-3.10.1-x86_64: ERRORS
> linux-3.11.1-i686: ERRORS
> linux-3.11.1-x86_64: ERRORS
> linux-3.12.67-i686: ERRORS
> linux-3.12.67-x86_64: ERRORS
> linux-3.13.11-i686: ERRORS
> linux-3.13.11-x86_64: ERRORS
> linux-3.14.9-i686: ERRORS
> linux-3.14.9-x86_64: ERRORS
> linux-3.15.2-i686: ERRORS
> linux-3.15.2-x86_64: ERRORS
> linux-3.16.53-i686: ERRORS
> linux-3.16.53-x86_64: ERRORS
> linux-3.17.8-i686: ERRORS
> linux-3.17.8-x86_64: ERRORS
> linux-3.18.93-i686: ERRORS
> linux-3.18.93-x86_64: ERRORS
> linux-3.19-i686: ERRORS
> linux-3.19-x86_64: ERRORS
> linux-4.0.9-i686: ERRORS
> linux-4.0.9-x86_64: ERRORS
> linux-4.1.49-i686: ERRORS
> linux-4.1.49-x86_64: ERRORS
> linux-4.2.8-i686: ERRORS
> linux-4.2.8-x86_64: ERRORS
> linux-4.3.6-i686: ERRORS
> linux-4.3.6-x86_64: ERRORS
> linux-4.4.115-i686: ERRORS
> linux-4.4.115-x86_64: ERRORS
> linux-4.5.7-i686: ERRORS
> linux-4.5.7-x86_64: ERRORS
> linux-4.6.7-i686: ERRORS
> linux-4.6.7-x86_64: ERRORS
> linux-4.7.5-i686: ERRORS
> linux-4.7.5-x86_64: ERRORS
> linux-4.8-i686: ERRORS
> linux-4.8-x86_64: ERRORS
> linux-4.9.80-i686: ERRORS
> linux-4.9.80-x86_64: ERRORS
> linux-4.10.14-i686: ERRORS
> linux-4.10.14-x86_64: ERRORS
> linux-4.11-i686: ERRORS
> linux-4.11-x86_64: ERRORS
> linux-4.12.1-i686: ERRORS
> linux-4.12.1-x86_64: ERRORS
> linux-4.13-i686: ERRORS
> linux-4.13-x86_64: ERRORS
> linux-4.14.17-i686: ERRORS
> linux-4.14.17-x86_64: ERRORS
> linux-4.15.2-i686: ERRORS
> linux-4.15.2-x86_64: ERRORS
> linux-4.16-rc1-i686: ERRORS
> linux-4.16-rc1-x86_64: ERRORS
> apps: WARNINGS
> spec-git: OK
> sparse: WARNINGS
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
