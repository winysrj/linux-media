Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35656 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388925AbeKGB7N (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Nov 2018 20:59:13 -0500
Received: by mail-wr1-f65.google.com with SMTP id z16-v6so14274879wrv.2
        for <linux-media@vger.kernel.org>; Tue, 06 Nov 2018 08:33:11 -0800 (PST)
Subject: Re: [PATCH v4 0/3] Add Amlogic video decoder driver
To: Maxime Jourdan <mjourdan@baylibre.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org
References: <20181106075926.19269-1-mjourdan@baylibre.com>
From: Neil Armstrong <narmstrong@baylibre.com>
Message-ID: <d248b541-d9f4-a4fc-2b9a-cd8eac377fb0@baylibre.com>
Date: Tue, 6 Nov 2018 17:33:09 +0100
MIME-Version: 1.0
In-Reply-To: <20181106075926.19269-1-mjourdan@baylibre.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/11/2018 08:59, Maxime Jourdan wrote:
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
> There is an ongoing effort to bring those firmwares to linux-firmware
> but they're not in yet, currently blocked by licensing issues.
> 
> It was tested primarily with ffmpeg's v4l2-m2m implementation. For instance:
> $ ffmpeg -c:v mpeg2_v4l2m2m -i sample_mpeg2.mkv -f null -

Testing on Linux 4.20-rc1 with the proper DT patches using :
- gstreamer 1.10.4 V4L2 Video Decoder support from gst-plugins-good
- v4l2-compliance

Tested-by: Neil Armstrong <narmstrong@baylibre.com>

> 
> The v4l2-compliance results are available below the patch diff.
> 

[...]
