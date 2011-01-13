Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:57751 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932722Ab1AMMS1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Jan 2011 07:18:27 -0500
Message-ID: <4D2EED89.9090900@redhat.com>
Date: Thu, 13 Jan 2011 10:18:17 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Pawel Osciak <pawel@osciak.com>
CC: Marek Szyprowski <m.szyprowski@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	"Andrzej Pietrasiewicz/Poland R&D Center-Linux/./????"
	<andrzej.p@samsung.com>, linux-media@vger.kernel.org
Subject: Re: [GIT PATCHES FOR 2.6.38] Videbuf2 framework, NOON010PC30 sensor
 driver and s5p-fimc updates
References: <4D21FDC1.7000803@samsung.com> <4D2CBB3F.5050904@redhat.com> <000001cbb243$1051cb60$30f56220$%szyprowski@samsung.com> <4D2DF7A9.2070103@redhat.com> <AANLkTikt69vKoiMkVjxi877GTLjwmbw=i07Abts6G+-9@mail.gmail.com>
In-Reply-To: <AANLkTikt69vKoiMkVjxi877GTLjwmbw=i07Abts6G+-9@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 13-01-2011 01:05, Pawel Osciak escreveu:
> Hi Mauro,
> 
> On Wed, Jan 12, 2011 at 10:49, Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
>> Em 12-01-2011 08:25, Marek Szyprowski escreveu:
>>> Hello Mauro,
>>>
>>> I've rebased our fimc and saa patches onto http://linuxtv.org/git/mchehab/experimental.git
>>> vb2_test branch.
>>
>> Thanks!
>>
>> As before, I'll be commenting the patches as I'll be seeing any issues.
>>
>>> Pawel Osciak (2):
>>>       Fix mmap() example in the V4L2 API DocBook
>>
>> In fact, the check for retval < 0 instead of retval == -1 is not a fix. According with
>> mmap man pages:
>>        RETURN VALUE
>>               On  success,  mmap() returns a pointer to the mapped area.  On error, the value MAP_FAILED (that is, (void *) -1) is returned, and errno
>>               is set appropriately.  On success, munmap() returns 0, on failure -1, and errno is set (probably to EINVAL).
>>
>> The change is not wrong, as -1 is lower than 0, but using -1 is more compliant with
>> libc. So, I'll be applying just the CodingStyle fixes on it.
> 
> Sorry, but I think you got it wrong. The example is called "mmap()
> example". But I did not change return value checking of mmap() calls.
> I changed return value checking of ioctl() calls. So I believe the
> patch is correct.

>From ioctl man page:

RETURN VALUE
       Usually, on success zero is returned.  A few ioctl() requests  use  the
       return  value as an output parameter and return a non-negative value on
       success.  On error, -1 is returned, and errno is set appropriately.

So, at least on glibc, it will return -1 for errors, storing the error code at errno
var, and 0 for OK.

Several V4L2 applications do error checks with -1. So, if some non-glibc implementation
is returning a different return value, that means that several V4L applications will
not work properly. Do you know any case where ioctl is implemented on a different way?

Cheers,
Mauro.
