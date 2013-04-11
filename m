Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f177.google.com ([209.85.223.177]:46395 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106Ab3DKSba (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Apr 2013 14:31:30 -0400
Received: by mail-ie0-f177.google.com with SMTP id 9so2133492iec.36
        for <linux-media@vger.kernel.org>; Thu, 11 Apr 2013 11:31:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201304112009.50586.hverkuil@xs4all.nl>
References: <1365699247-32351-1-git-send-email-tjlee@ambarella.com>
	<1365703621-7783-1-git-send-email-tjlee@ambarella.com>
	<201304112009.50586.hverkuil@xs4all.nl>
Date: Fri, 12 Apr 2013 02:31:29 +0800
Message-ID: <CAEvN+1hnK3ZoghqA0a7gxFj+T2gqxyrpTQp54D=dqmYj5aU=ZA@mail.gmail.com>
Subject: Re: [PATCH] v4l2-ctl: add is_compressed_format() helper
From: Tzu-Jung Lee <roylee17@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, hans.verkuil@cisco.com,
	Kamil Debski <k.debski@samsung.com>,
	Tzu-Jung Lee <tjlee@ambarella.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Apr 12, 2013 at 2:09 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On Thu April 11 2013 20:07:01 Tzu-Jung Lee wrote:
>> It is used to:
>>
>>   bypass precalculate_bars() for OUTPUT device
>>   that takes encoded bitstreams.
>>
>>   handle the last chunk of input file that has
>>   non-buffer-aligned size.
>
> This seems to be the third version of this patch. When you post a new
> version, can you 1) add a version number after 'PATCH' (e.g. [PATCHv3])
> and 2) mention the differences since the previous version.
>
> That makes a reviewer's life a lot easier.

Sorry about that, I tried to use the in-reply-to with git-send-email.
But it didn't work as intended. Next time I'll try it with my own email first.

The difference is the logic of fill_buffer_from_file().
In v3, I realized that compressed formats are not for multiplane anyway.
So I split the logic to only handle single plane case, and leave
multiplane untouched.

I'll break the patch into two. One for is_compressed().
And the other one for handling the input file that has the non-buffer
aligned size.

Thanks.

Roy


> Thanks!
>
>         Hans
>
>>
>> Signed-off-by: Tzu-Jung Lee <tjlee@ambarella.com>
>> ---
>>  utils/v4l2-ctl/v4l2-ctl-streaming.cpp | 132 ++++++++++++++++++++++++++++------
>>  1 file changed, 112 insertions(+), 20 deletions(-)
>>
>> diff --git a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
>> index 9e361af..44643e8 100644
>> --- a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
>> +++ b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
>> @@ -115,6 +115,29 @@ static const flag_def tc_flags_def[] = {
>>       { 0, NULL }
>>  };
>>
>> +static bool is_compressed_format(__u32 pixfmt)
>> +{
>> +     switch (pixfmt) {
>> +     case V4L2_PIX_FMT_MJPEG:
>> +     case V4L2_PIX_FMT_JPEG:
>> +     case V4L2_PIX_FMT_DV:
>> +     case V4L2_PIX_FMT_MPEG:
>> +     case V4L2_PIX_FMT_H264:
>> +     case V4L2_PIX_FMT_H264_NO_SC:
>> +     case V4L2_PIX_FMT_H263:
>> +     case V4L2_PIX_FMT_MPEG1:
>> +     case V4L2_PIX_FMT_MPEG2:
>> +     case V4L2_PIX_FMT_MPEG4:
>> +     case V4L2_PIX_FMT_XVID:
>> +     case V4L2_PIX_FMT_VC1_ANNEX_G:
>> +             return true;
>> +     default:
>> +             return false;
>> +     }
>> +
>> +     return false;
>> +}
>> +
>>  static void print_buffer(FILE *f, struct v4l2_buffer &buf)
>>  {
>>       fprintf(f, "\tIndex    : %d\n", buf.index);
>> @@ -223,25 +246,60 @@ void streaming_cmd(int ch, char *optarg)
>>  }
>>
>>  static bool fill_buffer_from_file(void *buffers[], unsigned buffer_lengths[],
>> -             unsigned buf_index, unsigned num_planes, FILE *fin)
>> +                               unsigned buffer_bytesused[], unsigned buf_index,
>> +                               unsigned num_planes, bool is_compressed, FILE *fin)
>>  {
>> +     if (num_planes == 1) {
>> +             unsigned i = buf_index;
>> +             unsigned sz = fread(buffers[i], 1,
>> +                                 buffer_lengths[i], fin);
>> +
>> +             buffer_bytesused[i] = sz;
>> +             if (sz == 0 && stream_loop) {
>> +                     fseek(fin, 0, SEEK_SET);
>> +                     sz = fread(buffers[i], 1,
>> +                                buffer_lengths[i], fin);
>> +
>> +                     buffer_bytesused[i] = sz;
>> +             }
>> +
>> +             if (!sz)
>> +                     return false;
>> +
>> +             if (sz == buffer_lengths[i])
>> +                     return true;
>> +
>> +             if (is_compressed)
>> +                     return true;
>> +
>> +             fprintf(stderr, "%u != %u\n", sz, buffer_lengths[i]);
>> +
>> +             return false;
>> +     }
>> +
>>       for (unsigned j = 0; j < num_planes; j++) {
>>               unsigned p = buf_index * num_planes + j;
>>               unsigned sz = fread(buffers[p], 1,
>> -                             buffer_lengths[p], fin);
>> +                                 buffer_lengths[p], fin);
>>
>> +             buffer_bytesused[j] = sz;
>>               if (j == 0 && sz == 0 && stream_loop) {
>>                       fseek(fin, 0, SEEK_SET);
>>                       sz = fread(buffers[p], 1,
>> -                                     buffer_lengths[p], fin);
>> +                                buffer_lengths[p], fin);
>> +
>> +                     buffer_bytesused[j] = sz;
>>               }
>>               if (sz == buffer_lengths[p])
>>                       continue;
>> +
>> +             // Bail out if we get weird buffer sizes.
>>               if (sz)
>>                       fprintf(stderr, "%u != %u\n", sz, buffer_lengths[p]);
>> -             // Bail out if we get weird buffer sizes.
>> +
>>               return false;
>>       }
>> +
>>       return true;
>>  }
>>
>> @@ -312,16 +370,22 @@ static void do_setup_out_buffers(int fd, struct v4l2_requestbuffers *reqbufs,
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
>> +     is_compressed = is_compressed_format(fmt.fmt.pix.pixelformat);
>> +     if (!is_compressed &&
>> +         !precalculate_bars(fmt.fmt.pix.pixelformat, stream_pat)) {
>>               fprintf(stderr, "unsupported pixelformat\n");
>>               return;
>>       }
>>
>> +     unsigned buffer_bytesused[reqbufs->count * VIDEO_MAX_PLANES];
>> +
>>       for (unsigned i = 0; i < reqbufs->count; i++) {
>>               struct v4l2_plane planes[VIDEO_MAX_PLANES];
>>               struct v4l2_buffer buf;
>> @@ -363,11 +427,11 @@ static void do_setup_out_buffers(int fd, struct v4l2_requestbuffers *reqbufs,
>>                       // TODO fill_buffer_mp(buffers[i], &fmt.fmt.pix_mp);
>>                       if (fin)
>>                               fill_buffer_from_file(buffers, buffer_lengths,
>> -                                                   buf.index, num_planes, fin);
>> +                                                   buffer_bytesused, buf.index,
>> +                                                   num_planes, is_compressed, fin);
>>               }
>>               else {
>>                       buffer_lengths[i] = buf.length;
>> -                     buf.bytesused = buf.length;
>>                       if (is_mmap) {
>>                               buffers[i] = mmap(NULL, buf.length,
>>                                                 PROT_READ | PROT_WRITE, MAP_SHARED, fd, buf.m.offset);
>> @@ -381,9 +445,16 @@ static void do_setup_out_buffers(int fd, struct v4l2_requestbuffers *reqbufs,
>>                               buffers[i] = calloc(1, buf.length);
>>                               buf.m.userptr = (unsigned long)buffers[i];
>>                       }
>> -                     if (!fin || !fill_buffer_from_file(buffers, buffer_lengths,
>> -                                                        buf.index, num_planes, fin))
>> +
>> +                     if (fin && fill_buffer_from_file(buffers, buffer_lengths,
>> +                                                      buffer_bytesused, buf.index,
>> +                                                      num_planes, is_compressed,
>> +                                                      fin)) {
>> +                             buf.bytesused = buffer_bytesused[buf.index];
>> +                     }
>> +                     else {
>>                               fill_buffer(buffers[i], &fmt.fmt.pix);
>> +                     }
>>               }
>>               if (doioctl(fd, VIDIOC_QBUF, &buf))
>>                       return;
>> @@ -511,12 +582,13 @@ static int do_handle_cap(int fd, struct v4l2_requestbuffers *reqbufs,
>>  }
>>
>>  static int do_handle_out(int fd, struct v4l2_requestbuffers *reqbufs,
>> -                      bool is_mplane, unsigned num_planes,
>> +                      bool is_compressed, bool is_mplane, unsigned num_planes,
>>                        void *buffers[], unsigned buffer_lengths[], FILE *fin,
>>                        unsigned &count, unsigned &last, struct timeval &tv_last)
>>  {
>>       struct v4l2_plane planes[VIDEO_MAX_PLANES];
>>       struct v4l2_buffer buf;
>> +     unsigned buffer_bytesused[reqbufs->count * VIDEO_MAX_PLANES];
>>       int ret;
>>
>>       memset(&buf, 0, sizeof(buf));
>> @@ -535,14 +607,17 @@ static int do_handle_out(int fd, struct v4l2_requestbuffers *reqbufs,
>>               fprintf(stderr, "%s: failed: %s\n", "VIDIOC_DQBUF", strerror(errno));
>>               return -1;
>>       }
>> -     if (fin && !fill_buffer_from_file(buffers, buffer_lengths,
>> -                                       buf.index, num_planes, fin))
>> +     if (fin &&!fill_buffer_from_file(buffers, buffer_lengths,
>> +                                      buffer_bytesused, buf.index,
>> +                                      num_planes, is_compressed,
>> +                                      fin)) {
>>               return -1;
>> +     }
>>       if (is_mplane) {
>>               for (unsigned j = 0; j < buf.length; j++)
>> -                     buf.m.planes[j].bytesused = buf.m.planes[j].length;
>> +                     buf.m.planes[j].bytesused = buffer_bytesused[j];
>>       } else {
>> -             buf.bytesused = buf.length;
>> +             buf.bytesused = buffer_bytesused[buf.index];
>>       }
>>       if (test_ioctl(fd, VIDIOC_QBUF, &buf))
>>               return -1;
>> @@ -688,7 +763,9 @@ static void streaming_set_cap(int fd)
>>  static void streaming_set_out(int fd)
>>  {
>>       struct v4l2_requestbuffers reqbufs;
>> +     struct v4l2_format fmt;
>>       int fd_flags = fcntl(fd, F_GETFL);
>> +     bool is_compressed;
>>       bool is_mplane = capabilities &
>>                       (V4L2_CAP_VIDEO_OUTPUT_MPLANE |
>>                                V4L2_CAP_VIDEO_M2M_MPLANE);
>> @@ -710,6 +787,12 @@ static void streaming_set_out(int fd)
>>       reqbufs.type = type;
>>       reqbufs.memory = is_mmap ? V4L2_MEMORY_MMAP : V4L2_MEMORY_USERPTR;
>>
>> +     memset(&fmt, 0, sizeof(fmt));
>> +     fmt.type = reqbufs.type;
>> +     doioctl(fd, VIDIOC_G_FMT, &fmt);
>> +
>> +     is_compressed = is_compressed_format(fmt.fmt.pix.pixelformat);
>> +
>>       if (file_out) {
>>               if (!strcmp(file_out, "-"))
>>                       fin = stdin;
>> @@ -765,9 +848,9 @@ static void streaming_set_out(int fd)
>>                               return;
>>                       }
>>               }
>> -             r = do_handle_out(fd, &reqbufs, is_mplane, num_planes,
>> -                                buffers, buffer_lengths, fin,
>> -                                count, last, tv_last);
>> +             r = do_handle_out(fd, &reqbufs, is_compressed, is_mplane,
>> +                               num_planes, buffers, buffer_lengths,
>> +                               fin, count, last, tv_last);
>>               if (r == -1)
>>                       break;
>>
>> @@ -795,6 +878,9 @@ enum stream_type {
>>
>>  static void streaming_set_m2m(int fd)
>>  {
>> +     struct v4l2_format fmt;
>> +     bool is_compressed;
>> +
>>       int fd_flags = fcntl(fd, F_GETFL);
>>       bool use_poll = options[OptStreamPoll];
>>
>> @@ -864,6 +950,12 @@ static void streaming_set_m2m(int fd)
>>                            is_mmap, buffers_out, buffer_lengths_out,
>>                            file[OUT]);
>>
>> +     memset(&fmt, 0, sizeof(fmt));
>> +     fmt.type = reqbufs[OUT].type;
>> +     doioctl(fd, VIDIOC_G_FMT, &fmt);
>> +
>> +     is_compressed = is_compressed_format(fmt.fmt.pix.pixelformat);
>> +
>>       if (doioctl(fd, VIDIOC_STREAMON, &type[CAP]) ||
>>           doioctl(fd, VIDIOC_STREAMON, &type[OUT]))
>>               return;
>> @@ -927,9 +1019,9 @@ static void streaming_set_m2m(int fd)
>>               }
>>
>>               if (wr_fds && FD_ISSET(fd, wr_fds)) {
>> -                     r  = do_handle_out(fd, &reqbufs[OUT], is_mplane, num_planes[OUT],
>> -                                        buffers_out, buffer_lengths_out, file[OUT],
>> -                                        count[OUT], last[OUT], tv_last[OUT]);
>> +                     r  = do_handle_out(fd, &reqbufs[OUT], is_compressed, is_mplane,
>> +                                        num_planes[OUT], buffers_out, buffer_lengths_out,
>> +                                        file[OUT], count[OUT], last[OUT], tv_last[OUT]);
>>                       if (r < 0)  {
>>                               wr_fds = NULL;
>>
>>
