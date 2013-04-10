Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f176.google.com ([209.85.223.176]:47785 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728Ab3DJIiO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Apr 2013 04:38:14 -0400
Received: by mail-ie0-f176.google.com with SMTP id x12so213494ief.35
        for <linux-media@vger.kernel.org>; Wed, 10 Apr 2013 01:38:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201304100848.30682.hverkuil@xs4all.nl>
References: <1365572135-2311-1-git-send-email-tjlee@ambarella.com>
	<1365572135-2311-2-git-send-email-tjlee@ambarella.com>
	<201304100848.30682.hverkuil@xs4all.nl>
Date: Wed, 10 Apr 2013 16:38:13 +0800
Message-ID: <CAEvN+1gmv9N9e897NvqCQ2o2LCqMUDfob2T_DQ_ehZLWkjAZEA@mail.gmail.com>
Subject: Re: [PATCH 2/2] v4l2-ctl: initial attempt to support M2M device streaming
From: Tzu-Jung Lee <roylee17@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, hans.verkuil@cisco.com,
	Kamil Debski <k.debski@samsung.com>,
	Tzu-Jung Lee <tjlee@ambarella.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Apr 10, 2013 at 2:48 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On Wed April 10 2013 07:35:35 Tzu-Jung Lee wrote:
>> ---
>>  utils/v4l2-ctl/v4l2-ctl-streaming.cpp | 189 +++++++++++++++++++++++++++++++++-
>>  1 file changed, 188 insertions(+), 1 deletion(-)
>>
>> diff --git a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
>> index f8e782d..b86c467 100644
>> --- a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
>> +++ b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
>> @@ -1058,12 +1058,199 @@ void streaming_set_out(int fd)
>>               fclose(fin);
>>  }
>>
>> +enum stream_type {
>> +     CAP,
>> +     OUT,
>> +};
>> +
>> +void streaming_set_m2m(int fd)
>> +{
>> +     int fd_flags = fcntl(fd, F_GETFL);
>> +     bool use_poll = options[OptStreamPoll];
>> +
>> +     bool is_mplane = capabilities &
>> +                     (V4L2_CAP_VIDEO_CAPTURE_MPLANE |
>> +                              V4L2_CAP_VIDEO_OUTPUT_MPLANE |
>> +                              V4L2_CAP_VIDEO_M2M_MPLANE);
>
> This should only check for V4L2_CAP_VIDEO_M2M_MPLANE. Only if that is set is M2M
> valid. I think it is probably a good idea to add some capability checks to each
> streaming_set_*() function checking up front whether the device supports that
> particular streaming option.
>
>> +     unsigned num_planes = 1;
>
> num_planes may differ between capture and output, so this should be num_planes[2] = { 1, 1 }
>

Sure.

>> +     bool is_mmap = options[OptStreamMmap];
>> +
>> +     __u32 type[2];
>> +     FILE *file[2] = {NULL, NULL};
>> +     struct v4l2_requestbuffers reqbufs[2];
>> +
>> +     type[CAP] = is_mplane ?
>> +             V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE : V4L2_BUF_TYPE_VIDEO_CAPTURE;
>> +
>> +     type[OUT] = is_mplane ?
>> +             V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE : V4L2_BUF_TYPE_VIDEO_OUTPUT;
>> +
>> +     memset(&reqbufs, 0, sizeof(reqbufs));
>> +
>> +     reqbufs[CAP].count = reqbufs_count;
>
> Capture and output can have different reqbufs_count values. That static needs to be
> split up in a capture and output variant.
>
>> +     reqbufs[CAP].type = type[CAP];
>> +     reqbufs[CAP].memory = is_mmap ? V4L2_MEMORY_MMAP : V4L2_MEMORY_USERPTR;
>> +
>> +     reqbufs[OUT].count = reqbufs_count;
>> +     reqbufs[OUT].type = type[OUT];
>> +     reqbufs[OUT].memory = is_mmap ? V4L2_MEMORY_MMAP : V4L2_MEMORY_USERPTR;
>> +
>> +     struct v4l2_event_subscription sub;
>> +
>> +     memset(&sub, 0, sizeof(sub));
>> +     sub.type = V4L2_EVENT_EOS;
>> +     ioctl(fd, VIDIOC_SUBSCRIBE_EVENT, &sub);
>> +
>> +     if (file_cap) {
>> +             if (!strcmp(file_cap, "-"))
>> +                     file[CAP] = stdout;
>> +             else
>> +                     file[CAP] = fopen(file_cap, "w+");
>> +     }
>> +
>> +     if (file_out) {
>> +             if (!strcmp(file_out, "-"))
>> +                     file[OUT] = stdin;
>> +             else
>> +                     file[OUT] = fopen(file_out, "r");
>> +     }
>> +
>> +     if (doioctl(fd, VIDIOC_REQBUFS, &reqbufs[CAP]) ||
>> +         doioctl(fd, VIDIOC_REQBUFS, &reqbufs[OUT]))
>> +             return;
>> +
>> +     void *buffers[2][reqbufs_count * VIDEO_MAX_PLANES];
>> +     unsigned buffer_lengths[2][reqbufs_count * VIDEO_MAX_PLANES];
>> +
>> +     do_setup_cap_buffers(fd, &reqbufs[CAP], is_mplane, num_planes,
>> +                          is_mmap, buffers[CAP], buffer_lengths[CAP]);
>> +
>> +     do_setup_out_buffers(fd, &reqbufs[OUT], is_mplane, num_planes,
>> +                          is_mmap, buffers[OUT], buffer_lengths[OUT],
>> +                          file[OUT]);
>> +
>> +     if (doioctl(fd, VIDIOC_STREAMON, &type[CAP]) ||
>> +         doioctl(fd, VIDIOC_STREAMON, &type[OUT]))
>> +             return;
>> +
>> +     if (use_poll)
>> +             fcntl(fd, F_SETFL, fd_flags | O_NONBLOCK);
>> +
>> +     unsigned count[2] = { 0, 0 };
>> +     unsigned last[2] = { 0, 0 };
>> +     struct timeval tv_last[2];
>> +     bool eos[2] = { false, false};
>
> No. eos is valid for the capture only. There is no eos[OUT].
>
>> +     fd_set read_fds;
>> +     fd_set write_fds;
>> +     fd_set exception_fds;
>> +
>> +     while (!eos[CAP] || !eos[OUT]) {
>> +
>> +             int r;
>> +
>> +             if (use_poll) {
>> +                     struct timeval tv;
>> +
>> +                     FD_ZERO(&read_fds);
>> +                     FD_SET(fd, &read_fds);
>> +
>> +                     FD_ZERO(&write_fds);
>> +                     FD_SET(fd, &write_fds);
>> +
>> +                     FD_ZERO(&exception_fds);
>> +                     FD_SET(fd, &exception_fds);
>> +
>> +                     /* Timeout. */
>> +                     tv.tv_sec = 2;
>> +                     tv.tv_usec = 0;
>> +
>> +                     r = select(fd + 1, &read_fds, &write_fds, &exception_fds, &tv);
>> +
>> +                     if (r == -1) {
>> +                             if (EINTR == errno)
>> +                                     continue;
>> +                             fprintf(stderr, "select error: %s\n",
>> +                                     strerror(errno));
>> +                             return;
>> +                     }
>> +
>> +                     if (r == 0) {
>> +                             fprintf(stderr, "select timeout\n");
>> +                             return;
>> +                     }
>> +             }
>> +
>> +             if (FD_ISSET(fd, &exception_fds)) {
>> +                     struct v4l2_event ev;
>> +
>> +                     while (!ioctl(fd, VIDIOC_DQEVENT, &ev)) {
>> +
>> +                             if (ev.type != V4L2_EVENT_EOS)
>> +                                     continue;
>> +
>> +                             eos[CAP] = true;
>> +                             doioctl(fd, VIDIOC_STREAMOFF, &type[CAP]);
>> +                             break;
>> +                     }
>> +             }
>> +
>> +             if (!eos[CAP]) {
>> +                     if (FD_ISSET(fd, &read_fds)) {
>> +                             r  = do_handle_cap(fd, &reqbufs[CAP], is_mplane, num_planes,
>> +                                                buffers[CAP], buffer_lengths[CAP], file[CAP],
>> +                                                &count[CAP], &last[CAP], &tv_last[CAP]);
>> +                             if (r < 0) {
>> +                                     eos[CAP] = true;
>> +                                     doioctl(fd, VIDIOC_STREAMOFF, &type[CAP]);
>> +                             }
>> +                     }
>> +             }
>> +
>> +             if (!eos[OUT]) {
>> +                     if (FD_ISSET(fd, &write_fds)) {
>> +                             r  = do_handle_out(fd, &reqbufs[OUT], is_mplane, num_planes,
>> +                                                buffers[OUT], buffer_lengths[OUT], file[OUT],
>> +                                                &count[OUT], &last[OUT], &tv_last[OUT]);
>> +                             if (r < 0)  {
>> +                                     eos[OUT] = true;
>> +
>> +                                     if (options[OptDecoderCmd]) {
>> +                                             doioctl(fd, VIDIOC_DECODER_CMD, &dec_cmd);
>> +                                             options[OptDecoderCmd] = false;
>> +                                     }
>> +
>> +                                     doioctl(fd, VIDIOC_STREAMOFF, &type[OUT]);
>> +
>
> Rather than using eos[OUT], just 'break' out of the loop here.

If we break out here, the unfinished captured stream will also be left
out, isn't it?

Oh, I'm working on a M2M device, which works with bitstreams only, and
no frames on Linux.
So we keep feeding input streams via the OUTPUT path, and get
transcoded bitstream from
CAPTURE path. In this case, we need to keep pulling out the transcoded
bitstreams in the loop.
I think this is also only relevant to compressed formats again.

>> +                             }
>> +                     }
>> +
>> +             }
>> +     }
>> +
>> +     fcntl(fd, F_SETFL, fd_flags);
>> +     fprintf(stderr, "\n");
>> +
>> +     do_release_buffers(&reqbufs[CAP], num_planes, is_mmap,
>> +                        buffers[CAP], buffer_lengths[CAP]);
>> +
>> +     do_release_buffers(&reqbufs[OUT], num_planes, is_mmap,
>> +                        buffers[OUT], buffer_lengths[OUT]);
>> +
>> +     if (file[CAP] && file[CAP] != stdout)
>> +             fclose(file[CAP]);
>> +
>> +     if (file[OUT] && file[OUT] != stdin)
>> +             fclose(file[OUT]);
>> +}
>> +
>>  void streaming_set(int fd)
>>  {
>>       bool do_cap = options[OptStreamMmap] || options[OptStreamUser];
>>       bool do_out = options[OptStreamOutMmap] || options[OptStreamOutUser];
>>
>> -     if (do_cap)
>> +     if (do_cap && do_out)
>> +             streaming_set_m2m(fd);
>> +     else if (do_cap)
>>               streaming_set_cap(fd);
>>       else if (do_out)
>>               streaming_set_out(fd);
>>
>
> Regards,
>
>         Hans
