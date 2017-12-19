Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:49517 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751462AbdLSLSB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Dec 2017 06:18:01 -0500
Message-ID: <1513682278.7538.6.camel@pengutronix.de>
Subject: Re: iMX6q/coda encoder failures with ffmpeg/gstreamer m2m encoders
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Neil Armstrong <narmstrong@baylibre.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Date: Tue, 19 Dec 2017 12:17:58 +0100
In-Reply-To: <8bfe88cc-28ec-fa07-5da3-614745ac125f@baylibre.com>
References: <8bfe88cc-28ec-fa07-5da3-614745ac125f@baylibre.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Neil,

On Tue, 2017-11-21 at 10:50 +0100, Neil Armstrong wrote:
> Hi,
> 
> I'm trying to make the coda960 h.264 encoder work on an i.MX6q SoC with Linux 4.14 and the 3.1.1 firmware.
> 
> # dmesg | grep coda
> [    4.846574] coda 2040000.vpu: Direct firmware load for vpu_fw_imx6q.bin failed with error -2
> [    4.901351] coda 2040000.vpu: Using fallback firmware vpu/vpu_fw_imx6q.bin
> [    4.916039] coda 2040000.vpu: Firmware code revision: 46072
> [    4.921641] coda 2040000.vpu: Initialized CODA960.
> [    4.926589] coda 2040000.vpu: Firmware version: 3.1.1
> [    4.932223] coda 2040000.vpu: codec registered as /dev/video[8-9]
> 
> Using gstreamer-plugins-good and the m2m v4l2 encoder, I have :
> 
> # gst-launch-1.0 videotestsrc num-buffers=1000 pattern=snow ! video/x-raw, framerate=30/1, width=1280, height=720 ! v4l2h264enc ! h264parse ! mp4mux ! filesink location=/dev/null
> Setting pipeline to PAUSED ...
> Pipeline is PREROLLING ...
> Redistribute latency...
> [ 1569.473717] coda 2040000.vpu: coda_s_fmt queue busy
> ERROR: from element /GstPipeline:pipeline0/v4l2h264enc:v4l2h264enc0: Device '/dev/video8' is busy
> Additional debug info:
> ../../../gst-plugins-good-1.12.3/sys/v4l2/gstv4l2object.c(3609): gst_v4l2_object_set_format_full (): /GstPipeline:pipeline0/v4l2h264enc:v4l2h264enc0:
> Call to S_FMT failed for YU12 @ 1280x720: Device or resource busy
> ERROR: pipeline doesn't want to preroll.
> Setting pipeline to NULL ...
> Freeing pipeline ...

The coda driver does not allow S_FMT anymore, as soon as the buffers are
allocated with REQBUFS:

https://bugzilla.gnome.org/show_bug.cgi?id=791338

regards
Philipp
