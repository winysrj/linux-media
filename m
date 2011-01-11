Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53959 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932209Ab1AKQnS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Jan 2011 11:43:18 -0500
Received: by wwa36 with SMTP id 36so1968124wwa.1
        for <linux-media@vger.kernel.org>; Tue, 11 Jan 2011 08:43:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4D2CA021.5080001@redhat.com>
References: <4D21FDC1.7000803@samsung.com> <4D2CA021.5080001@redhat.com>
From: Pawel Osciak <pawel@osciak.com>
Date: Tue, 11 Jan 2011 08:42:55 -0800
Message-ID: <AANLkTimovx-bhpV-1bRn=KvvH4ZtvAsSmnJB5_bjn6xX@mail.gmail.com>
Subject: Re: [GIT PATCHES FOR 2.6.38] Videbuf2 framework, NOON010PC30 sensor
 driver and s5p-fimc updates
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

On Tue, Jan 11, 2011 at 10:23, Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
>> Pawel Osciak (8):
>>       v4l: Add multi-planar API definitions to the V4L2 API
>>       v4l: Add multi-planar ioctl handling code
>
>>       v4l: Add compat functions for the multi-planar API
>>       v4l: fix copy sizes in compat32 for ext controls
>
> Are you sure that we need to add compat32 stuff for the multi-planar definitions?
> Had you test if the compat32 code is actually working? Except if you use things
> that have different sizes on 32 and 64 bit architectures, there's no need to add
> anything for compat.
>

v4l2_buffer and v4l2_plane contain pointers to buffers and/or arrays
of planes. In fact buffer conversion was already there, I only added
the new planes field. I believe those additions to the compat code are
needed...

> Anyway, I'll be merging the two compat functions into just one patch, as it will
> help to track any regressions there, if ever needed. They are at my temporary
> branch, but, if they are not needed, I'll drop when merging upstream.
>
>>       v4l: v4l2-ioctl: add buffer type conversion for multi-planar-aware ioctls
>
> NACK.
>
> We shouldn't be doing those videobuf memcpy operations inside the kernel.
> If you want such feature, please implement it on libv4l.
>

I can see your point. We don't really use it. It was to prevent
applications from using two versions of API and thus being
overcomplicated. It allowed using old drivers with the new API. If you
think it is a bad idea, the patch can just be dropped without
affecting anything else. I will fix the documentation if you decide to
do so.

-- 
Best regards,
Pawel Osciak
