Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:54591 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728158AbeIQUTp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Sep 2018 16:19:45 -0400
Subject: Re: [PATCH v2 0/3] Add Amlogic video decoder driver
To: Maxime Jourdan <mjourdan@baylibre.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org
References: <20180911150938.3844-1-mjourdan@baylibre.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <9c33c57e-2ce2-8752-b851-f85c03a7d761@xs4all.nl>
Date: Mon, 17 Sep 2018 16:51:56 +0200
MIME-Version: 1.0
In-Reply-To: <20180911150938.3844-1-mjourdan@baylibre.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/11/2018 05:09 PM, Maxime Jourdan wrote:
> Hi everyone,
> 
> This patch series adds support for the Amlogic video decoder,
> as well as the corresponding dt bindings for GXBB/GXL/GXM chips.
> 
> It features decoding for the following formats:
> - MPEG 1
> - MPEG 2
> 
> The following formats will be added in future patches:
> - MJPEG
> - MPEG 4 (incl. Xvid, H.263)
> - H.264
> - HEVC (incl. 10-bit)
> 
> The following formats' development has still not started, but they are
> supported by the hardware:
> - VC1
> - VP9
> 
> The code was made in such a way to allow easy inclusion of those formats
> in the future.
> 
> The decoder is single instance.
> 
> Files:
>  - vdec.c handles the V4L2 M2M logic
>  - esparser.c manages the hardware bitstream parser
>  - vdec_helpers.c provides helpers to DONE the dst buffers as well as
>  various common code used by the codecs
>  - vdec_1.c manages the VDEC_1 block of the vdec IP
>  - codec_mpeg12.c enables decoding for MPEG 1/2.
>  - vdec_platform.c links codec units with vdec units
>  (e.g vdec_1 with codec_mpeg12) and lists all the available
>  src/dst formats and requirements (max width/height, etc.),
>  per compatible chip.
> 
> Firmwares are necessary to run the vdec. They can currently be found at:
> https://github.com/chewitt/meson-firmware
> 
> It was tested primarily with ffmpeg's v4l2-m2m implementation. For instance:
> $ ffmpeg -c:v mpeg2_v4l2m2m -i sample_mpeg2.mkv -f null -
> 
> Note: This patch series depends on
> "[PATCH v3 0/3] soc: amlogic: add meson-canvas"
> https://patchwork.kernel.org/cover/10573763/
> 
> The v4l2-compliance results are available below the patch diff.
> 
> Changes since v1 [0]:
>  - use named interrupts in the bindings
>  - rewrite description in the bindings doc
>  - don't include the dts changes in the patch series
>  - fill the vb2 queues locks
>  - fill the video_device lock
>  - use helpers for wait_prepare and wait_finish vb2_ops
>  - remove unnecessary usleep in between esparser writes.
>  Extensive testing of every codec on GXBB/GXL didn't reveal
>  any fails without it, so just remove it.
>  - compile v4l2_compliance inside the git repo
>  - Check for plane number/plane size to pass the latest v4l2-compliance test
>  - Moved the single instance check (returning -EBUSY) to start/stop streaming
>  The check was previously in queue_setup but there was no great location to
>  clear it except for .close().

Actually, you can clear it by called VIDIOC_REQBUFS with count set to 0. That
freed all buffers and clears this.

Now, the difference between queue_setup and start/stop streaming is that if you
do this in queue_setup you'll know early on that the device is busy. It is
reasonable to assume that you only allocate buffers when you also want to start
streaming, so that it a good place to know this quickly.

Whereas with start_streaming you won't know until you call STREAMON, or even later
if you start streaming with no buffers queued, since start_streaming won't
be called until you have at least 'min_buffers_needed' buffers queued (1 for this
driver). So in that case EBUSY won't be returned until the first VIDIOC_QBUF.

My preference is to check this in queue_setup, but it is up to you to decide.
Just be aware of the difference between the two options.

Regards,

	Hans
