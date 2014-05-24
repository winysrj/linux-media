Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:1715 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbaEXIZJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 24 May 2014 04:25:09 -0400
Message-ID: <53805742.60206@xs4all.nl>
Date: Sat, 24 May 2014 10:24:34 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: linux-media@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: cron job: media_tree daily build: ERRORS
References: <20140524023204.702842A19A6@tschai.lan>
In-Reply-To: <20140524023204.702842A19A6@tschai.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

Can you look at this build error?

On 05/24/2014 04:32 AM, Hans Verkuil wrote:
> This message is generated daily by a cron job that builds media_tree for
> the kernels and architectures in the list below.
> 
> Results of the daily build of media_tree:
> 
> date:		Sat May 24 04:00:26 CEST 2014
> git branch:	test
> git hash:	12bd10c79bd8f65698660e992b8656e9a48eeca1
> gcc version:	i686-linux-gcc (GCC) 4.8.2
> sparse version:	v0.5.0-11-g38d1124
> host hardware:	x86_64
> host os:	3.14-1.slh.1-amd64
> 
> linux-git-arm-at91: OK
> linux-git-arm-davinci: OK
> linux-git-arm-exynos: ERRORS

/home/hans/work/build/media-git/drivers/media/i2c/m5mols/m5mols_capture.c:29:28: fatal error: media/s5p_fimc.h: No such file or directory
 #include <media/s5p_fimc.h>
                            ^
compilation terminated.
make[5]: *** [drivers/media/i2c/m5mols/m5mols_capture.o] Error 1
make[5]: *** Waiting for unfinished jobs....
make[4]: *** [drivers/media/i2c/m5mols] Error 2
make[4]: *** Waiting for unfinished jobs....
make[3]: *** [drivers/media/i2c] Error 2
make[3]: *** Waiting for unfinished jobs....
make[2]: *** [drivers/media/] Error 2
make[1]: *** [sub-make] Error 2
make: *** [all] Error 2
Sat May 24 04:01:06 CEST 2014

This seems to be caused by commit "exynos4-is: Remove support for non-dt platforms"
which removed the s5p_fimc.h header. My guess is that s5p_fimc.h has been renamed
by exynos-fimc.h and this header include was missed.

Regards,

	Hans
