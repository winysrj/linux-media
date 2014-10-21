Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:60499 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752915AbaJUPjq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Oct 2014 11:39:46 -0400
Received: by mail-oi0-f45.google.com with SMTP id i138so1163013oig.18
        for <linux-media@vger.kernel.org>; Tue, 21 Oct 2014 08:39:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <54466471.8050607@xs4all.nl>
References: <CAL8zT=j2STDuLHW3ONw1+cOfePZceBN7yTsV1WxDjFo0bZMBaA@mail.gmail.com>
 <54465F34.1000400@xs4all.nl> <CAL8zT=herYZ9d3TKrx_5Nre0_RRRXK3Az9-NvmqGE7_SkHLzHg@mail.gmail.com>
 <54466471.8050607@xs4all.nl>
From: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
Date: Tue, 21 Oct 2014 17:39:30 +0200
Message-ID: <CAL8zT=jykeu33QRvj9JxhuSxV2Cg8La2J8KxVJpu+GsaE9wZnA@mail.gmail.com>
Subject: Re: [media] CODA960: Fails to allocate memory
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Steve Longerbeam <slongerbeam@gmail.com>,
	Robert Schwebel <r.schwebel@pengutronix.de>,
	Fabio Estevam <fabio.estevam@freescale.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2014-10-21 15:49 GMT+02:00 Hans Verkuil <hverkuil@xs4all.nl>:
>
>
> On 10/21/2014 03:42 PM, Jean-Michel Hautbois wrote:
>>
>> Hi Hans,
>>
>> 2014-10-21 15:27 GMT+02:00 Hans Verkuil <hverkuil@xs4all.nl>:
>>>
>>>
>>>
>>> On 10/21/2014 03:16 PM, Jean-Michel Hautbois wrote:
>>>>
>>>>
>>>> Hi,
>>>>
>>>> I am trying to use the CODA960 driver on a 3.18 kernel.
>>>> It seems pretty good when the module is probed (appart from the
>>>> unsupported firmware version) but when I try using the encoder, it
>>>> fails allocating dma buffers.
>>>>
>>>> Here is the DT part I added :
>>>> &vpu {
>>>>       compatible = "fsl,imx6q-vpu";
>>>>       clocks = <&clks 168>, <&clks 140>, <&clks 142>;
>>>>       clock-names = "per", "ahb", "ocram";
>>>>       iramsize = <0x21000>;
>>>>       iram = <&ocram>;
>>>>       resets = <&src 1>;
>>>>       status = "okay";
>>>> };
>>>>
>>>> When booting, I see :
>>>> [    4.410645] coda 2040000.vpu: Firmware code revision: 46056
>>>> [    4.416312] coda 2040000.vpu: Initialized CODA960.
>>>> [    4.421123] coda 2040000.vpu: Unsupported firmware version: 3.1.1
>>>> [    4.483577] coda 2040000.vpu: codec registered as /dev/video[0-1]
>>>>
>>>> I can start v4l2-ctl and it shows that the device seems to be ok :
>>>>    v4l2-ctl --all -d /dev/video1
>>>> Driver Info (not using libv4l2):
>>>>           Driver name   : coda
>>>>           Card type     : CODA960
>>>>           Bus info      : platform:coda
>>>>           Driver version: 3.18.0
>>>>           Capabilities  : 0x84208000
>>>>                   Video Memory-to-Memory
>>>>                   Streaming
>>>>                   Extended Pix Format
>>>>                   Device Capabilities
>>>>           Device Caps   : 0x04208000
>>>>                   Video Memory-to-Memory
>>>>                   Streaming
>>>>                   Extended Pix Format
>>>> Priority: 2
>>>> Format Video Capture:
>>>>           Width/Height  : 1920/1088
>>>>           Pixel Format  : 'YU12'
>>>>           Field         : None
>>>>           Bytes per Line: 1920
>>>>           Size Image    : 3133440
>>>>           Colorspace    : HDTV and modern devices (ITU709)
>>>>           Flags         :
>>>> Format Video Output:
>>>>           Width/Height  : 1920/1088
>>>>           Pixel Format  : 'H264'
>>>>           Field         : None
>>>>           Bytes per Line: 0
>>>>           Size Image    : 1048576
>>>>           Colorspace    : HDTV and modern devices (ITU709)
>>>>           Flags         :
>>>> Selection: compose, Left 0, Top 0, Width 1920, Height 1088
>>>> Selection: compose_default, Left 0, Top 0, Width 1920, Height 1088
>>>> Selection: compose_bounds, Left 0, Top 0, Width 1920, Height 1088
>>>> Selection: compose_padded, Left 0, Top 0, Width 1920, Height 1088
>>>> Selection: crop, Left 0, Top 0, Width 1920, Height 1088
>>>> Selection: crop_default, Left 0, Top 0, Width 1920, Height 1088
>>>> Selection: crop_bounds, Left 0, Top 0, Width 1920, Height 1088
>>>>
>>>> User Controls
>>>>
>>>>                   horizontal_flip (bool)   : default=0 value=0
>>>>                     vertical_flip (bool)   : default=0 value=0
>>>>
>>>> Codec Controls
>>>>
>>>>                    video_gop_size (int)    : min=1 max=60 step=1
>>>> default=16 value=16
>>>>                     video_bitrate (int)    : min=0 max=32767000 step=1
>>>> default=0 value=0
>>>>       number_of_intra_refresh_mbs (int)    : min=0 max=8160 step=1
>>>> default=0 value=0
>>>>              sequence_header_mode (menu)   : min=0 max=1 default=1
>>>> value=1
>>>>          maximum_bytes_in_a_slice (int)    : min=1 max=1073741823 step=1
>>>> default=500 value=500
>>>>          number_of_mbs_in_a_slice (int)    : min=1 max=1073741823 step=1
>>>> default=1 value=1
>>>>         slice_partitioning_method (menu)   : min=0 max=2 default=0
>>>> value=0
>>>>             h264_i_frame_qp_value (int)    : min=0 max=51 step=1
>>>> default=25 value=25
>>>>             h264_p_frame_qp_value (int)    : min=0 max=51 step=1
>>>> default=25 value=25
>>>>             h264_maximum_qp_value (int)    : min=0 max=51 step=1
>>>> default=51 value=51
>>>>     h264_loop_filter_alpha_offset (int)    : min=0 max=15 step=1
>>>> default=0
>>>> value=0
>>>>      h264_loop_filter_beta_offset (int)    : min=0 max=15 step=1
>>>> default=0
>>>> value=0
>>>>             h264_loop_filter_mode (menu)   : min=0 max=1 default=0
>>>> value=0
>>>>            mpeg4_i_frame_qp_value (int)    : min=1 max=31 step=1
>>>> default=2
>>>> value=2
>>>>            mpeg4_p_frame_qp_value (int)    : min=1 max=31 step=1
>>>> default=2
>>>> value=2
>>>>                   horizontal_flip (bool)   : default=0 value=0
>>>>                     vertical_flip (bool)   : default=0 value=0
>>>>
>>>>
>>>>
>>>>
>>>> But when I try to get a file outputed, it fails :
>>>>
>>>> v4l2-ctl -d1 --stream-out-mmap --stream-mmap --stream-to x.raw
>>>> [ 1197.292256] coda 2040000.vpu: dma_alloc_coherent of size 1048576
>>>> failed
>>>> VIDIOC_REQBUFS: failed: Cannot allocate memory
>>>>
>>>> Did I forget to do something ?
>>>
>>>
>>>
>>> I assume this is physically contiguous memory. Do you have that much
>>> phys.
>>> cont. memory
>>> available at all? If the memory is fragmented you won't be able to get
>>> it.
>>>
>>> Use cma (contiguous memory allocator). You probably have to do very
>>> little
>>> expect add
>>> a kernel option to assign enough memory for these buffers.
>>
>>
>> I added a cma=128M in order to reserve some meory, and it fails...
>> well, differently :).
>>
>> ~# v4l2-ctl -d1 --stream-out-mmap --stream-mmap --stream-to x.raw
>> [   56.372023] alloc_contig_range test_pages_isolated(48400, 486fd) failed
>> [   56.459627] ------------[ cut here ]------------
>> [   56.464273] WARNING: CPU: 1 PID: 838 at
>> drivers/media/v4l2-core/videobuf2-core.c:1181
>> vb2_buffer_done+0x120/0x158()
>
>
> That looks like a driver bug. You are returning buffers in
> coda_start_streaming
> with a wrong state. Check the WARN_ON at that line.
>
> Regards,
>
>         Hans

I added some instrumentation, and modified the state returned from
VB2_BUF_STATE_DEQUEUED to VB2_BUF_STATE_QUEUED and it fails when
getting bitstream payload...

Here are the modifications :

diff --git a/drivers/media/platform/coda/coda-common.c
b/drivers/media/platform/coda/coda-common.c
index ced4760..b958668 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -1033,17 +1033,21 @@ static int coda_start_streaming(struct
vb2_queue *q, unsigned int count)
        q_data_src = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
        if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
                if (q_data_src->fourcc == V4L2_PIX_FMT_H264) {
+                       v4l2_err(v4l2_dev, "fill bitstream\n");
                        /* copy the buffers that where queued before streamon */
                        mutex_lock(&ctx->bitstream_mutex);
                        coda_fill_bitstream(ctx);
                        mutex_unlock(&ctx->bitstream_mutex);

                        if (coda_get_bitstream_payload(ctx) < 512) {
+                               v4l2_err(v4l2_dev, "fill bitstream
payload : %d\n", coda_get_bitstream_payload(ctx));
                                ret = -EINVAL;
                                goto err;
                        }
                } else {
+                       v4l2_err(v4l2_dev, "Not H264 pix fmt\n");
                        if (count < 1) {
+                               v4l2_err(v4l2_dev, "count: %d\n", count);
                                ret = -EINVAL;
                                goto err;
                        }
@@ -1051,7 +1055,9 @@ static int coda_start_streaming(struct vb2_queue
*q, unsigned int count)

                ctx->streamon_out = 1;
        } else {
+               v4l2_err(v4l2_dev, "Not output type\n");
                if (count < 1) {
+                       v4l2_err(v4l2_dev, "count: %d\n", count);
                        ret = -EINVAL;
                        goto err;
                }
@@ -1060,8 +1066,10 @@ static int coda_start_streaming(struct
vb2_queue *q, unsigned int count)
        }

        /* Don't start the coda unless both queues are on */
-       if (!(ctx->streamon_out & ctx->streamon_cap))
+       if (!(ctx->streamon_out & ctx->streamon_cap)) {
+               v4l2_err(v4l2_dev, "streamon_out (%s), streamon_cap
(%s)\n", (ctx->streamon_out)?"Y":"N",(ctx->streamon_cap)?"Y":"N");
                return 0;
+       }

        /* Allow decoder device_run with no new buffers queued */
        if (ctx->inst_type == CODA_INST_DECODER)
@@ -1083,8 +1091,10 @@ static int coda_start_streaming(struct
vb2_queue *q, unsigned int count)
        if (ctx->inst_type == CODA_INST_DECODER) {
                if (ret == -EAGAIN)
                        return 0;
-               else if (ret < 0)
+               else if (ret < 0) {
+                       v4l2_err(v4l2_dev, "Decoder instance error: %d\n", ret);
                        goto err;
+               }
        }

        ctx->initialized = 1;
@@ -1093,10 +1103,10 @@ static int coda_start_streaming(struct
vb2_queue *q, unsigned int count)
 err:
        if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
                while ((buf = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx)))
-                       v4l2_m2m_buf_done(buf, VB2_BUF_STATE_DEQUEUED);
+                       v4l2_m2m_buf_done(buf, VB2_BUF_STATE_QUEUED);
        } else {
                while ((buf = v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx)))
-                       v4l2_m2m_buf_done(buf, VB2_BUF_STATE_DEQUEUED);
+                       v4l2_m2m_buf_done(buf, VB2_BUF_STATE_QUEUED);
        }
        return ret;
 }


And the output is now :
v4l2-ctl -d1 --stream-out-mmap --stream-mmap --stream-to x.raw
[ 6208.240919] coda 2040000.vpu: Not output type
[ 6208.245316] coda 2040000.vpu: streamon_out (N), streamon_cap (Y)
[ 6208.251353] coda 2040000.vpu: fill bitstream
[ 6208.255653] coda 2040000.vpu: fill bitstream payload : 0
VIDIOC_STREAMON: failed: Invalid argument

Any idea ?
JM
