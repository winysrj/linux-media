Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:40517 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764Ab1LLR1g (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Dec 2011 12:27:36 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=UTF-8
Date: Mon, 12 Dec 2011 18:27:33 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [GIT PULL for 3.2-rc5] media fixes
In-reply-to: <4EE63039.4040004@redhat.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <4EE63985.30001@samsung.com>
References: <4EE63039.4040004@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On 12/12/2011 05:47 PM, Mauro Carvalho Chehab wrote:
> Hi Linus,
> 
> Please pull from:
>   git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus
> 
> For a couple fixes for media drivers.
> The changes are:
>     - ati_remote (new driver for 3.2): Fix the scancode tables;
>     - af9015: fix some issues with firmware load;
>     - au0828: (trivial) add device ID's for some devices;
>     - omap3 and s5p: several small fixes;
>     - Update MAINTAINERS entry to cover /drivers/staging/media and
>       media DocBook;
>     - a few other small trivial fixes.
> 
> Thanks!
> Mauro
[...]

> 
> Sylwester Nawrocki (10):
>       [media] s5p-fimc: Fix wrong pointer dereference when unregistering sensors
>       [media] s5p-fimc: Fix error in the capture subdev deinitialization
>       [media] s5p-fimc: Fix initialization for proper system suspend support
>       [media] s5p-fimc: Fix buffer dequeue order issue
>       [media] s5p-fimc: Allow probe() to succeed with null platform data
>       [media] s5p-fimc: Adjust pixel height alignments according to the IP
> revision
>       [media] s5p-fimc: Fail driver probing when sensor configuration is wrong
>       [media] s5p-fimc: Use correct fourcc for RGB565 colour format
>       [media] m5mols: Fix set_fmt to return proper pixel format code
>       [media] s5p-fimc: Fix camera input configuration in subdev operations

There is one more quite important patch left out:

http://git.infradead.org/users/kmpark/linux-2.6-samsung/commitdiff/817069678ab57150b21cd0705e2f3a3b2b6509f4

It was included in my recent pull request. It would be good to have in v3.2
too. Are you planning to add it to a next pull request to Linus ?

--

Thanks,
Sylwester
