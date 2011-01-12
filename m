Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:37816 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751404Ab1ALStX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Jan 2011 13:49:23 -0500
Message-ID: <4D2DF7A9.2070103@redhat.com>
Date: Wed, 12 Jan 2011 16:49:13 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Marek Szyprowski <m.szyprowski@samsung.com>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	"'Andrzej Pietrasiewicz/Poland R&D Center-Linux/./????'"
	<andrzej.p@samsung.com>, pawel@osciak.com,
	linux-media@vger.kernel.org
Subject: Re: [GIT PATCHES FOR 2.6.38] Videbuf2 framework, NOON010PC30 sensor
 driver and s5p-fimc updates
References: <4D21FDC1.7000803@samsung.com> <4D2CBB3F.5050904@redhat.com> <000001cbb243$1051cb60$30f56220$%szyprowski@samsung.com>
In-Reply-To: <000001cbb243$1051cb60$30f56220$%szyprowski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 12-01-2011 08:25, Marek Szyprowski escreveu:
> Hello Mauro,
> 
> I've rebased our fimc and saa patches onto http://linuxtv.org/git/mchehab/experimental.git
> vb2_test branch.

Thanks!

As before, I'll be commenting the patches as I'll be seeing any issues.

> Pawel Osciak (2):
>       Fix mmap() example in the V4L2 API DocBook

In fact, the check for retval < 0 instead of retval == -1 is not a fix. According with
mmap man pages:
	RETURN VALUE
	       On  success,  mmap() returns a pointer to the mapped area.  On error, the value MAP_FAILED (that is, (void *) -1) is returned, and errno
	       is set appropriately.  On success, munmap() returns 0, on failure -1, and errno is set (probably to EINVAL).

The change is not wrong, as -1 is lower than 0, but using -1 is more compliant with
libc. So, I'll be applying just the CodingStyle fixes on it.

Cheers,
mauro
