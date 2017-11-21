Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:43383 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751232AbdKUJuH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Nov 2017 04:50:07 -0500
Received: by mail-wm0-f50.google.com with SMTP id x63so1949264wmf.2
        for <linux-media@vger.kernel.org>; Tue, 21 Nov 2017 01:50:06 -0800 (PST)
To: Philipp Zabel <p.zabel@pengutronix.de>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
From: Neil Armstrong <narmstrong@baylibre.com>
Subject: iMX6q/coda encoder failures with ffmpeg/gstreamer m2m encoders
Message-ID: <8bfe88cc-28ec-fa07-5da3-614745ac125f@baylibre.com>
Date: Tue, 21 Nov 2017 10:50:03 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I'm trying to make the coda960 h.264 encoder work on an i.MX6q SoC with Linux 4.14 and the 3.1.1 firmware.

# dmesg | grep coda
[    4.846574] coda 2040000.vpu: Direct firmware load for vpu_fw_imx6q.bin failed with error -2
[    4.901351] coda 2040000.vpu: Using fallback firmware vpu/vpu_fw_imx6q.bin
[    4.916039] coda 2040000.vpu: Firmware code revision: 46072
[    4.921641] coda 2040000.vpu: Initialized CODA960.
[    4.926589] coda 2040000.vpu: Firmware version: 3.1.1
[    4.932223] coda 2040000.vpu: codec registered as /dev/video[8-9]

Using gstreamer-plugins-good and the m2m v4l2 encoder, I have :

# gst-launch-1.0 videotestsrc num-buffers=1000 pattern=snow ! video/x-raw, framerate=30/1, width=1280, height=720 ! v4l2h264enc ! h264parse ! mp4mux ! filesink location=/dev/null
Setting pipeline to PAUSED ...
Pipeline is PREROLLING ...
Redistribute latency...
[ 1569.473717] coda 2040000.vpu: coda_s_fmt queue busy
ERROR: from element /GstPipeline:pipeline0/v4l2h264enc:v4l2h264enc0: Device '/dev/video8' is busy
Additional debug info:
../../../gst-plugins-good-1.12.3/sys/v4l2/gstv4l2object.c(3609): gst_v4l2_object_set_format_full (): /GstPipeline:pipeline0/v4l2h264enc:v4l2h264enc0:
Call to S_FMT failed for YU12 @ 1280x720: Device or resource busy
ERROR: pipeline doesn't want to preroll.
Setting pipeline to NULL ...
Freeing pipeline ...

And with ffmpeg :

# ffmpeg -f lavfi -i nullsrc=s=1280x720:d=5 -vf "geq=random(1)*255:128:128" -vcodec h264_v4l2m2m -f null -
Input #0, lavfi, from 'nullsrc=s=1280x720:d=5':
  Duration: N/A, start: 0.000000, bitrate: N/A
    Stream #0:0: Video: rawvideo (I420 / 0x30323449), yuv420p, 1280x720 [SAR 1:1 DAR 16:9], 25 tbr, 25 tbn, 25 tbc
Stream mapping:
  Stream #0:0 -> #0:0 (rawvideo (native) -> h264 (h264_v4l2m2m))
Press [q] to stop, [?] for help
[h264_v4l2m2m @ 0x146f700] driver 'coda' on card 'CODA960'
    Last message repeated 1 times
[h264_v4l2m2m @ 0x146f700] Using device /dev/video8
[h264_v4l2m2m @ 0x146f700] driver 'coda' on card 'CODA960'
[h264_v4l2m2m @ 0x146f700] Failed to set number of B-frames
    Last message repeated 1 times
[h264_v4l2m2m @ 0x146f700] Failed to set header mode
[h264_v4l2m2m @ 0x146f700] h264 profile not found
[h264_v4l2m2m[  787.690832] coda 2040000.vpu: CODA_COMMAND_SEQ_INIT failed
 @ 0x146f700] Encoder adjusted: qmin (0), qmax (51)
[h264_v4l2m2m @ 0x146f700] Failed to set minimum video quantizer scale
Output #0, null, to 'pipe:':
  Metadata:
    encoder         : Lavf57.71.100
    Stream #0:0: Video: h264 (h264_v4l2m2m), yuv420p, 1280x720 [SAR 1:1 DAR 16:9], q=2-31, 200 kb/s, 25 fps, 25 tbn, 25 tbc
    Metadata:
      encoder         : Lavc57.89.100 h264_v4l2m2m
[h264_v4l2m2m @ 0x146f700] output  POLLERR
[h264_v4l2m2m @ 0x146f700] VIDIOC_STREAMON failed on capture context
Video encoding failed

Decoder iws working OK with gstreamer, but fails to allocate memory with ffmpeg (unrelated).

Is there missing patches to make encoder work, or some specific parameters  ?

Thanks,
Neil

-- 
Neil Armstrong
Embedded Linux Software Engineer
BayLibre - At the Heart of Embedded Linux
www.baylibre.com
