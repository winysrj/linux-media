Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:33522 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753590Ab3IOVlB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Sep 2013 17:41:01 -0400
Message-ID: <52362967.1030806@gmail.com>
Date: Sun, 15 Sep 2013 23:40:55 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Shaik Ameer Basha <shaik.samsung@gmail.com>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>, kyungmin.park@samsung.com,
	pawel@osciak.com, javier.martin@vista-silicon.com,
	m.szyprowski@samsung.com,
	Shaik Ameer Basha <shaik.ameer@samsung.com>,
	Arun Kumar K <arun.kk@samsung.com>, k.debski@samsung.com,
	linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH RFC 6/7] exynos-gsc: Use mem-to-mem ioctl helpers
References: <1379076986-10446-1-git-send-email-s.nawrocki@samsung.com> <1379076986-10446-7-git-send-email-s.nawrocki@samsung.com> <CAOD6AToYrpdQtEs7qDkfDG63Dg4kZZNCjeCA+u5UDNdjgUtDvA@mail.gmail.com>
In-Reply-To: <CAOD6AToYrpdQtEs7qDkfDG63Dg4kZZNCjeCA+u5UDNdjgUtDvA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Shaik,

On 09/13/2013 04:12 PM, Shaik Ameer Basha wrote:
[...]
>> -static int gsc_m2m_streamon(struct file *file, void *fh,
>> -                          enum v4l2_buf_type type)
>> -{
>> -       struct gsc_ctx *ctx = fh_to_ctx(fh);
>> -
>> -       /* The source and target color format need to be set */
>> -       if (V4L2_TYPE_IS_OUTPUT(type)) {
>> -               if (!gsc_ctx_state_is_set(GSC_SRC_FMT, ctx))
>> -                       return -EINVAL;
>> -       } else if (!gsc_ctx_state_is_set(GSC_DST_FMT, ctx)) {
>> -               return -EINVAL;
>> -       }
>> -
>> -       return v4l2_m2m_streamon(file, ctx->m2m_ctx, type);
>> -}
>> -
>> -static int gsc_m2m_streamoff(struct file *file, void *fh,
>> -                           enum v4l2_buf_type type)
>> -{
>> -       struct gsc_ctx *ctx = fh_to_ctx(fh);
>> -       return v4l2_m2m_streamoff(file, ctx->m2m_ctx, type);
>> -}
>> -
>>   /* Return 1 if rectangle a is enclosed in rectangle b, or 0 otherwise. */
>>   static int is_rectangle_enclosed(struct v4l2_rect *a, struct v4l2_rect *b)
>>   {
>> @@ -563,13 +512,15 @@ static const struct v4l2_ioctl_ops gsc_m2m_ioctl_ops = {
>>          .vidioc_try_fmt_vid_out_mplane  = gsc_m2m_try_fmt_mplane,
>>          .vidioc_s_fmt_vid_cap_mplane    = gsc_m2m_s_fmt_mplane,
>>          .vidioc_s_fmt_vid_out_mplane    = gsc_m2m_s_fmt_mplane,
>> -       .vidioc_reqbufs                 = gsc_m2m_reqbufs,
>> -       .vidioc_expbuf                  = gsc_m2m_expbuf,
>> -       .vidioc_querybuf                = gsc_m2m_querybuf,
>> -       .vidioc_qbuf                    = gsc_m2m_qbuf,
>> -       .vidioc_dqbuf                   = gsc_m2m_dqbuf,
>> -       .vidioc_streamon                = gsc_m2m_streamon,
>> -       .vidioc_streamoff               = gsc_m2m_streamoff,
>> +
>> +       .vidioc_reqbufs                 = v4l2_m2m_ioctl_reqbufs,
>
> I think your intention was not to replace gsc_m2m_reqbufs() with
> v4l2_m2m_ioctl_reqbufs().
> you didn't remove the gsc_m2m_reqbufs() function :)
>
> On top of that,  gsc_m2m_reqbufs() has some buffer count related checks.

Thanks for the review. Sorry, I actually left this patch halfway done.
There is some clean up required before we can actually benefit from those
m2m helpers. First of all the driver should have set valid default format
right when the video device is opened. Then the hack with *{SRC, DST}_FMT
flags should be removed.

The fact that the selection API on mem-to-mem video nodes and its
interaction with VIDIOC_S_FMT is not well defined doesn't of course help
here.

I thought I'd drop exynos-gsc from this series but I had a look at it and
it didn't take much time to make those cleanups, so there will be two more
patches for exynos-gsc, unfortunately not tested yet.

Regarding gsc_m2m_reqbufs(), it currently behaves incorrectly. It should
adjust reqbufs->count to a supported value, rather than returning EINVAL.

Moreover, the buffer count limit is currently 32 for both CAPTURE and OUTPUT
queue. I don't know when this number comes from, the driver always uses
DMA buffer descriptor 0 for all transactions (GSC_M2M_BUF_NUM). Maybe this
code was inherited from the initial BSP gsc-capture driver, where the buffer
masking feature was actually used.

Besides that, the number of requested buffer per vb2 buffer queue is
always being limited to VIDEO_MAX_FRAME in videobuf2, which is also 32.

So I think gsc_m2m_reqbufs() can be pretty much optimized, including
removal of an unused 'frame' variable, and we can safely replace it with
v4l2_m2m_ioctl_reqbufs().

--
Regards,
Sylwester
