Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41951 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932524Ab1AMDFX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Jan 2011 22:05:23 -0500
Received: by wyb28 with SMTP id 28so1282323wyb.19
        for <linux-media@vger.kernel.org>; Wed, 12 Jan 2011 19:05:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4D2DF7A9.2070103@redhat.com>
References: <4D21FDC1.7000803@samsung.com> <4D2CBB3F.5050904@redhat.com>
 <000001cbb243$1051cb60$30f56220$%szyprowski@samsung.com> <4D2DF7A9.2070103@redhat.com>
From: Pawel Osciak <pawel@osciak.com>
Date: Wed, 12 Jan 2011 19:05:01 -0800
Message-ID: <AANLkTikt69vKoiMkVjxi877GTLjwmbw=i07Abts6G+-9@mail.gmail.com>
Subject: Re: [GIT PATCHES FOR 2.6.38] Videbuf2 framework, NOON010PC30 sensor
 driver and s5p-fimc updates
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	"Andrzej Pietrasiewicz/Poland R&D Center-Linux/./????"
	<andrzej.p@samsung.com>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

On Wed, Jan 12, 2011 at 10:49, Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
> Em 12-01-2011 08:25, Marek Szyprowski escreveu:
>> Hello Mauro,
>>
>> I've rebased our fimc and saa patches onto http://linuxtv.org/git/mchehab/experimental.git
>> vb2_test branch.
>
> Thanks!
>
> As before, I'll be commenting the patches as I'll be seeing any issues.
>
>> Pawel Osciak (2):
>>       Fix mmap() example in the V4L2 API DocBook
>
> In fact, the check for retval < 0 instead of retval == -1 is not a fix. According with
> mmap man pages:
>        RETURN VALUE
>               On  success,  mmap() returns a pointer to the mapped area.  On error, the value MAP_FAILED (that is, (void *) -1) is returned, and errno
>               is set appropriately.  On success, munmap() returns 0, on failure -1, and errno is set (probably to EINVAL).
>
> The change is not wrong, as -1 is lower than 0, but using -1 is more compliant with
> libc. So, I'll be applying just the CodingStyle fixes on it.

Sorry, but I think you got it wrong. The example is called "mmap()
example". But I did not change return value checking of mmap() calls.
I changed return value checking of ioctl() calls. So I believe the
patch is correct.


-- 
Best regards,
Pawel Osciak
