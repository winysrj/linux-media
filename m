Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f50.google.com ([209.85.212.50]:49670 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758388Ab3DQH1a (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Apr 2013 03:27:30 -0400
Received: by mail-vb0-f50.google.com with SMTP id w15so1032333vbb.37
        for <linux-media@vger.kernel.org>; Wed, 17 Apr 2013 00:27:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201304170909.20207.hverkuil@xs4all.nl>
References: <1365709615-17399-1-git-send-email-tjlee@ambarella.com>
	<201304170909.20207.hverkuil@xs4all.nl>
Date: Wed, 17 Apr 2013 15:27:29 +0800
Message-ID: <CAEvN+1gySrw65t1JviLVCg7z8OegUkFG8QHa30TVCU-yHHNUVw@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] v4l2-ctl: add is_compressed_format() helper
From: Tzu-Jung Lee <roylee17@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, hans.verkuil@cisco.com,
	Kamil Debski <k.debski@samsung.com>,
	Tzu-Jung Lee <tjlee@ambarella.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Apr 17, 2013 at 3:09 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On Thu April 11 2013 21:46:54 Tzu-Jung Lee wrote:
>> To bypass precalculate_bars() for OUTPUT device
>> that takes encoded bitstreams.
>
> I haven't forgotten your patches, but I want to clean up the streaming code
> some more first. I hope to have finished with that this weekend.

One more thing about streaming code:

I just realized that the non-polling case for M2M isn't working, at
least for bitstreams to bitstreams case.
Without timeout, it can be blocked indefinitely by DQBUF of either
CAPTURE or OUTPUT queues.
QUERYBUF for any available buffers before issuing DQBUF might work,
but it seems to be overkill.
And it just degenerates to another form of polling mode...

Thanks.

Roy

>
>>
>> Signed-off-by: Tzu-Jung Lee <tjlee@ambarella.com>
>> ---
>>  utils/v4l2-ctl/v4l2-ctl-streaming.cpp | 40 ++++++++++++++++++++++++++++++++++-
>>  1 file changed, 39 insertions(+), 1 deletion(-)
>>
>> diff --git a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
>> index 9e361af..035c3c7 100644
>> --- a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
>> +++ b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
>> @@ -115,6 +115,23 @@ static const flag_def tc_flags_def[] = {
>>       { 0, NULL }
>>  };
>>
>> +static bool is_compressed_format(int fd, struct v4l2_format *f)
>> +{
>> +     struct v4l2_fmtdesc fmt;
>> +
>> +     memset(&fmt, 0, sizeof(fmt));
>> +     fmt.type = f->type;
>> +
>> +     while (test_ioctl(fd, VIDIOC_ENUM_FMT, &fmt) >= 0) {
>> +             if (fmt.pixelformat == f->fmt.pix.pixelformat)
>> +                     return fmt.flags & V4L2_FMT_FLAG_COMPRESSED;
>> +
>> +             fmt.index++;
>> +     }
>> +
>> +     return false;
>> +}
>> +
>>  static void print_buffer(FILE *f, struct v4l2_buffer &buf)
>>  {
>>       fprintf(f, "\tIndex    : %d\n", buf.index);
>> @@ -312,12 +329,16 @@ static void do_setup_out_buffers(int fd, struct v4l2_requestbuffers *reqbufs,
>>                                bool is_mplane, unsigned &num_planes, bool is_mmap,
>>                                void *buffers[], unsigned buffer_lengths[], FILE *fin)
>>  {
>> +     bool is_compressed;
>> +
>>       struct v4l2_format fmt;
>>       memset(&fmt, 0, sizeof(fmt));
>>       fmt.type = reqbufs->type;
>>       doioctl(fd, VIDIOC_G_FMT, &fmt);
>>
>> -     if (!precalculate_bars(fmt.fmt.pix.pixelformat, stream_pat)) {
>> +     is_compressed = is_compressed_format(fd, &fmt);
>> +     if (!is_compressed &&
>> +         !precalculate_bars(fmt.fmt.pix.pixelformat, stream_pat)) {
>>               fprintf(stderr, "unsupported pixelformat\n");
>>               return;
>>       }
>> @@ -688,7 +709,9 @@ static void streaming_set_cap(int fd)
>>  static void streaming_set_out(int fd)
>>  {
>>       struct v4l2_requestbuffers reqbufs;
>> +     struct v4l2_format fmt;
>>       int fd_flags = fcntl(fd, F_GETFL);
>> +     bool is_compressed;
>>       bool is_mplane = capabilities &
>>                       (V4L2_CAP_VIDEO_OUTPUT_MPLANE |
>>                                V4L2_CAP_VIDEO_M2M_MPLANE);
>> @@ -710,6 +733,12 @@ static void streaming_set_out(int fd)
>>       reqbufs.type = type;
>>       reqbufs.memory = is_mmap ? V4L2_MEMORY_MMAP : V4L2_MEMORY_USERPTR;
>>
>> +     memset(&fmt, 0, sizeof(fmt));
>> +     fmt.type = reqbufs.type;
>> +     doioctl(fd, VIDIOC_G_FMT, &fmt);
>> +
>> +     is_compressed = is_compressed_format(fd, &fmt);
>> +
>>       if (file_out) {
>>               if (!strcmp(file_out, "-"))
>>                       fin = stdin;
>> @@ -795,6 +824,9 @@ enum stream_type {
>>
>>  static void streaming_set_m2m(int fd)
>>  {
>> +     struct v4l2_format fmt;
>> +     bool is_compressed;
>> +
>>       int fd_flags = fcntl(fd, F_GETFL);
>>       bool use_poll = options[OptStreamPoll];
>>
>> @@ -864,6 +896,12 @@ static void streaming_set_m2m(int fd)
>>                            is_mmap, buffers_out, buffer_lengths_out,
>>                            file[OUT]);
>>
>> +     memset(&fmt, 0, sizeof(fmt));
>> +     fmt.type = reqbufs[OUT].type;
>> +     doioctl(fd, VIDIOC_G_FMT, &fmt);
>> +
>> +     is_compressed = is_compressed_format(fd, &fmt);
>> +
>>       if (doioctl(fd, VIDIOC_STREAMON, &type[CAP]) ||
>>           doioctl(fd, VIDIOC_STREAMON, &type[OUT]))
>>               return;
>>
