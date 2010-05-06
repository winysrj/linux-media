Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54805 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750772Ab0EFNKf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 6 May 2010 09:10:35 -0400
Message-ID: <4BE2BFC1.1000701@redhat.com>
Date: Thu, 06 May 2010 10:10:25 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Pawel Osciak <p.osciak@samsung.com>
CC: "'Aguirre, Sergio'" <saaguirre@ti.com>,
	linux-media@vger.kernel.org, kyungmin.park@samsung.com
Subject: Re: [videobuf] Query: Condition bytesize limit in videobuf_reqbufs
 -> buf_setup() call?
References: <A24693684029E5489D1D202277BE894455257D13@dlee02.ent.ti.com> <000901caeceb$9ff6c5e0$dfe451a0$%osciak@samsung.com>
In-Reply-To: <000901caeceb$9ff6c5e0$dfe451a0$%osciak@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Pawel Osciak wrote:
> Hi,
> 
>> Aguirre, Sergio wrote:
>> Basically, when calling VIDIOC_REQBUFS with a certain buffer
>> Count, we had a software limit for total size, calculated depending on:
>>
>>  Total bytesize = bytesperline x height x count
>>
>> So, we had an arbitrary limit to, say 32 MB, which was generic.
>>
>> Now, we want to condition it ONLY when MMAP buffers will be used.
>> Meaning, we don't want to keep that policy when the kernel is not
>> allocating the space
>>
>> But the thing is that, according to videobuf documentation, buf_setup is
>> the one who should put a RAM usage limit. BUT the memory type passed to
>> reqbufs is not propagated to buf_setup, therefore forcing me to go to a
>> non-standard memory limitation in my reqbufs callback function, instead
>> of doing it properly inside buf_setup.
> 
> buf_setup is called during REQBUFS and is indeed the place to limit the
> size and actually allocate the buffers as well, or at least try to do so,
> as V4L2 API requires. This is not currently the case with videobuf, but
> right now we are working to change it. 

I can't see the problem you're mentioning. Drivers apply (or should apply)
the maximum size limit at buffer setup. For example bttv driver seems to do
the right thing:

static unsigned int gbuffers = 8;
static unsigned int gbufsize = 0x208000;
...
MODULE_PARM_DESC(gbuffers,"number of capture buffers. range 2-32, default 8");
MODULE_PARM_DESC(gbufsize,"size of the capture buffers, default is 0x208000");

...
static int
buffer_setup(struct videobuf_queue *q, unsigned int *count, unsigned int *size)
{
        struct bttv_fh *fh = q->priv_data;

        *size = fh->fmt->depth*fh->width*fh->height >> 3;
        if (0 == *count)
                *count = gbuffers;
        if (*size * *count > gbuffers * gbufsize)
                *count = (gbuffers * gbufsize) / *size;
        return 0;
}

> buf_prepare() is called on QBUF
> and it is definitely too late to do things like that then. It is the
> REQBUFS that should be failing if the requested number of buffers is too
> high.

Yes, it is too late. Restrictions like that should be done at REQBUFS.

-- 

Cheers,
Mauro
