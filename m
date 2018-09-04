Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:41890 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725992AbeIDMCS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 4 Sep 2018 08:02:18 -0400
Subject: Re: cron job: media_tree daily build: ERRORS
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org, "Jasmin J." <jasmin@anw.at>
References: <a9f6b54c1e44b080026f417896cc0b2e@smtp-cloud9.xs4all.net>
Message-ID: <9e160819-cb5f-bc4c-0f36-1879aa08ce32@xs4all.nl>
Date: Tue, 4 Sep 2018 09:38:20 +0200
MIME-Version: 1.0
In-Reply-To: <a9f6b54c1e44b080026f417896cc0b2e@smtp-cloud9.xs4all.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jasmin,

On 09/04/2018 08:33 AM, Hans Verkuil wrote:
> This message is generated daily by a cron job that builds media_tree for
> the kernels and architectures in the list below.
> 
> Results of the daily build of media_tree:

Thank you for all your work, it looks much better now.

It seems a lot of the remaining errors are due to a missing dev_warn_once.
I've added compat code for that and will do another build run, hopefully
the result will be posted here later today.

Regards,

	Hans

> 
> date:			Tue Sep  4 04:00:14 CEST 2018
> media-tree git hash:	d842a7cf938b6e0f8a1aa9f1aec0476c9a599310
> media_build git hash:	1cd94ce3d513f211dffc576698a5be347352e3cb
> v4l-utils git hash:	f44f00e8b4ac6e9aa05bac8953e3fcc89e1fe198
> edid-decode git hash:	b2da1516df3cc2756bfe8d1fa06d7bf2562ba1f4
> gcc version:		i686-linux-gcc (GCC) 8.2.0
> sparse version:		0.5.2 (Debian: 0.5.2-1+b1)
> smatch version:		v0.5.0-3428-gdfe27cf
> host hardware:		x86_64
> host os:		4.17.0-1-amd64
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
> linux-git-sh: OK
> linux-git-x86_64: OK
> Check COMPILE_TEST: OK
> linux-2.6.36.4-i686: ERRORS
> linux-2.6.36.4-x86_64: ERRORS
> linux-2.6.37.6-i686: ERRORS
> linux-2.6.37.6-x86_64: ERRORS
> linux-2.6.38.8-i686: ERRORS
> linux-2.6.38.8-x86_64: ERRORS
> linux-2.6.39.4-i686: ERRORS
> linux-2.6.39.4-x86_64: ERRORS
> linux-3.0.101-i686: ERRORS
> linux-3.0.101-x86_64: ERRORS
> linux-3.1.10-i686: ERRORS
> linux-3.1.10-x86_64: ERRORS
> linux-3.2.102-i686: ERRORS
> linux-3.2.102-x86_64: ERRORS
> linux-3.3.8-i686: ERRORS
> linux-3.3.8-x86_64: ERRORS
> linux-3.4.113-i686: ERRORS
> linux-3.4.113-x86_64: ERRORS
> linux-3.5.7-i686: ERRORS
> linux-3.5.7-x86_64: ERRORS
> linux-3.6.11-i686: ERRORS
> linux-3.6.11-x86_64: ERRORS
> linux-3.7.10-i686: ERRORS
> linux-3.7.10-x86_64: ERRORS
> linux-3.8.13-i686: ERRORS
> linux-3.8.13-x86_64: ERRORS
> linux-3.9.11-i686: ERRORS
> linux-3.9.11-x86_64: ERRORS
> linux-3.10.108-i686: ERRORS
> linux-3.10.108-x86_64: ERRORS
> linux-3.11.10-i686: ERRORS
> linux-3.11.10-x86_64: ERRORS
> linux-3.12.74-i686: ERRORS
> linux-3.12.74-x86_64: ERRORS
> linux-3.13.11-i686: ERRORS
> linux-3.13.11-x86_64: ERRORS
> linux-3.14.79-i686: ERRORS
> linux-3.14.79-x86_64: ERRORS
> linux-3.15.10-i686: ERRORS
> linux-3.15.10-x86_64: ERRORS
> linux-3.16.57-i686: ERRORS
> linux-3.16.57-x86_64: ERRORS
> linux-3.17.8-i686: ERRORS
> linux-3.17.8-x86_64: ERRORS
> linux-3.18.119-i686: ERRORS
> linux-3.18.119-x86_64: ERRORS
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
> linux-4.16-rc7-i686: OK
> linux-4.16-rc7-x86_64: OK
> linux-4.16.18-i686: OK
> linux-4.16.18-x86_64: OK
> linux-4.17.19-i686: OK
> linux-4.17.19-x86_64: OK
> linux-4.18-rc1-i686: OK
> linux-4.18-rc1-x86_64: OK
> linux-4.18.5-i686: OK
> linux-4.18.5-x86_64: OK
> linux-4.19-rc1-i686: OK
> linux-4.19-rc1-x86_64: OK
> apps: OK
> spec-git: OK
> sparse: WARNINGS
> 
> Logs weren't copied as they are too large (580 kB)
> 
> The Media Infrastructure API from this daily build is here:
> 
> http://www.xs4all.nl/~hverkuil/spec/index.html
> 
