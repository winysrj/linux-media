Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:53172 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752398AbbGQIvX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jul 2015 04:51:23 -0400
Message-ID: <55A8C1C8.9040909@xs4all.nl>
Date: Fri, 17 Jul 2015 10:50:16 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>,
	horms@verge.net.au, magnus.damm@gmail.com
CC: laurent.pinchart@ideasonboard.com, j.anaszewski@samsung.com,
	kamil@wypas.org, sergei.shtylyov@cogentembedded.com,
	linux-media@vger.kernel.org, linux-sh@vger.kernel.org
Subject: Re: [PATCH v4 1/1] V4L2: platform: Add Renesas R-Car JPEG codec driver.
References: <1435318645-20565-1-git-send-email-mikhail.ulyanov@cogentembedded.com>
In-Reply-To: <1435318645-20565-1-git-send-email-mikhail.ulyanov@cogentembedded.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mikhail,

On 06/26/2015 01:37 PM, Mikhail Ulyanov wrote:
> Here's the driver for the Renesas R-Car JPEG processing unit.
> 
> The driver is implemented within the V4L2 framework as a memory-to-memory
> device.  It presents two video nodes to userspace, one for the encoding part,
> and one for the decoding part.
> 
> It was found that the only working mode for encoding is no markers output, so we
> generate markers with software. In the current version of driver we also use
> software JPEG header parsing because with hardware parsing performance is lower
> than desired.
> 
> From a userspace point of view the process is typical (S_FMT, REQBUF,
> optionally QUERYBUF, QBUF, STREAMON, DQBUF) for both the source and destination
> queues. STREAMON can return -EINVAL in case of mismatch of output and capture
> queues format. Also during decoding driver can return buffers if queued
> buffer with JPEG image contains image with inappropriate subsampling (e.g.
> 4:2:0 in JPEG and 4:2:2 in capture).  If JPEG image and queue format dimensions
> differ driver will return buffer on QBUF with VB2_BUF_STATE_ERROR flag.
> 
> During encoding the available formats are: V4L2_PIX_FMT_NV12M,
> V4L2_PIX_FMT_NV12, V4L2_PIX_FMT_NV16, V4L2_PIX_FMT_NV16M for source and
> V4L2_PIX_FMT_JPEG for destination.
> 
> During decoding the available formats are: V4L2_PIX_FMT_JPEG for source and
> V4L2_PIX_FMT_NV12M, V4L2_PIX_FMT_NV16M, V4L2_PIX_FMT_NV12, V4L2_PIX_FMT_NV16
> for destination.
> 
> Performance of current version:
> 1280x800 NV12 image encoding/decoding
> 	decoding ~122 FPS
> 	encoding ~191 FPS
> 
> Signed-off-by: Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>
> ---
>  Changes since v3:
>     - driver file renamed to rcar_jpu.c
>     - semiplanar formats NV12 and NV16 support
>     - new callbacks streamon, job_abort and stop_streaming
>     - extra processing error information printout irq handler
>     - fill in JPEG header for encoded buffer in buf_finish
>     - wrapped reading/writing to registers
>     - vb2_set_plane_payload only for necessary buffer in buf_prepare
>     - multiple buffers now supported
>     - removed format setup with parsed info; rely only on users info
>     - JPEG header parser redesigned
>     - video_device structs embedded
>     - video_device_alloc/release removed
>     - "name" filed in format description removed
>     - remove g_selection
>     - start_streaming removed
> 
> Changes since v2:
>     - Kconfig entry reordered
>     - unnecessary clk_disable_unprepare(jpu->clk) removed
>     - ref_count fixed in jpu_resume
>     - enable DMABUF in src_vq->io_modes
>     - remove jpu_s_priority jpu_g_priority
>     - jpu_g_selection fixed
>     - timeout in jpu_reset added and hardware reset reworked
>     - remove unused macros
>     - JPEG header parsing now is software because of performance issues
>       based on s5p-jpeg code
>     - JPEG header generation redesigned:
>       JPEG header(s) pre-generated and memcpy'ed on encoding
>       we only fill the necessary fields
>       more "transparent" header format description
>     - S_FMT, G_FMT and TRY_FMT hooks redesigned
>       partially inspired by VSP1 driver code
>     - some code was reformatted
>     - image formats handling redesigned
>     - multi-planar V4L2 API now in use
>     - now passes v4l2-compliance tool check
> 
> Cnanges since v1:
>     - s/g_fmt function simplified
>     - default format for queues added
>     - dumb vidioc functions added to be in compliance with standard api:
>         jpu_s_priority, jpu_g_priority
>     - standard v4l2_ctrl_subscribe_event and v4l2_event_unsubscribe
>       now in use by the same reason
> 
>  drivers/media/platform/Kconfig    |   11 +
>  drivers/media/platform/Makefile   |    1 +
>  drivers/media/platform/rcar_jpu.c | 1753 +++++++++++++++++++++++++++++++++++++
>  3 files changed, 1765 insertions(+)
>  create mode 100644 drivers/media/platform/rcar_jpu.c
> 

This patch looks good. There are a few small things checkpatch gave me:

WARNING: added, moved or deleted file(s), does MAINTAINERS need updating?
#82: 
new file mode 100644

WARNING: DT compatible string "renesas,jpu-r8a7790" appears un-documented -- check ./Documentation/devicetree/bindings/
#1645: FILE: drivers/media/platform/rcar_jpu.c:1559:
+       { .compatible = "renesas,jpu-r8a7790" }, /* H2 */

WARNING: DT compatible string "renesas,jpu-r8a7791" appears un-documented -- check ./Documentation/devicetree/bindings/
#1646: FILE: drivers/media/platform/rcar_jpu.c:1560:
+       { .compatible = "renesas,jpu-r8a7791" }, /* M2-W */

WARNING: DT compatible string "renesas,jpu-r8a7792" appears un-documented -- check ./Documentation/devicetree/bindings/
#1647: FILE: drivers/media/platform/rcar_jpu.c:1561:
+       { .compatible = "renesas,jpu-r8a7792" }, /* V2H */

WARNING: DT compatible string "renesas,jpu-r8a7793" appears un-documented -- check ./Documentation/devicetree/bindings/
#1648: FILE: drivers/media/platform/rcar_jpu.c:1562:
+       { .compatible = "renesas,jpu-r8a7793" }, /* M2-N */

So before I can commit I need a MAINTAINERS patch and DT documentation.

I also noticed that the Kconfig patch says that the driver module is called jpu,
but I think that should be rcar_jpu. If you can fix that?

I would also like to have the v4l2-compliance output for both encoder and decoder.

Try 'v4l2-compliance -s' for the encoder. This won't work for the decoder (v4l2-compliance
can't generate JPEG images), so just run 'v4l2-compliance' for that one.

Regards,

	Hans
