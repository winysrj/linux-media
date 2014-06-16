Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:3355 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754598AbaFPIgL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Jun 2014 04:36:11 -0400
Message-ID: <539EAC3E.3040102@xs4all.nl>
Date: Mon, 16 Jun 2014 10:35:10 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>, linux-media@vger.kernel.org
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	kernel@pengutronix.de
Subject: Re: [PATCH 00/30] Initial CODA960 (i.MX6 VPU) support
References: <1402675736-15379-1-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1402675736-15379-1-git-send-email-p.zabel@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

I went through this patch series and replied with some comments.

I have two more general questions:

1) can you post the output of 'v4l2-compliance'?
2) what would be needed for 'v4l2-compliance -s' to work?

For the encoder 'v4l2-compliance -s' will probably work OK, but for
the decoder you need to feed v4l2-compliance -s some compressed
stream. I assume each buffer should contain a single P/B/I frame?

The v4l2-ctl utility has already support for writing captured data
to a file, but it has no support to store the image sizes as well.
So if the captured buffers do not all have the same size you cannot
'index' the captured file. If I would add support for that, then I
can add support for it to v4l2-compliance as well, allowing you to
playback an earlier captured compressed video stream and use that
as the compliance test input.

Does this makes sense?

Regards,

	Hans

On 06/13/2014 06:08 PM, Philipp Zabel wrote:
> Hi,
> 
> the following series adds initial support for the CODA960 Video
> Processing Unit on i.MX6Q/D/DL/S SoCs to the coda driver.
> 
> This series contains a few fixes and preparations, the CODA960
> support patch, a rework of the hardware access serialization
> into a single threaded workqueue, some cleanups to use more
> infrastructure that is available in the meantime, runtime PM
> support, a few h.264 related v4l2 controls and fixes, support
> for hard resets via the i.MX system reset controller, and a
> patch that exports internal buffers to debugfs.
> 
> regards
> Philipp
> 
> Michael Olbrich (2):
>   [media] v4l2-mem2mem: export v4l2_m2m_try_schedule
>   [media] coda: try to schedule a decode run after a stop command
> 
> Philipp Zabel (28):
>   [media] coda: fix decoder I/P/B frame detection
>   [media] coda: fix readback of CODA_RET_DEC_SEQ_FRAME_NEED
>   [media] coda: fix h.264 quantization parameter range
>   [media] coda: fix internal framebuffer allocation size
>   [media] coda: simplify IRAM setup
>   [media] coda: Add encoder/decoder support for CODA960
>   [media] coda: add selection API support for h.264 decoder
>   [media] coda: add support for frame size enumeration
>   [media] coda: add workqueue to serialize hardware commands
>   [media] coda: Use mem-to-mem ioctl helpers
>   [media] coda: use ctx->fh.m2m_ctx instead of ctx->m2m_ctx
>   [media] coda: Add runtime pm support
>   [media] coda: split firmware version check out of coda_hw_init
>   [media] coda: select GENERIC_ALLOCATOR
>   [media] coda: add h.264 min/max qp controls
>   [media] coda: add h.264 deblocking filter controls
>   [media] coda: add cyclic intra refresh control
>   [media] coda: let userspace force IDR frames by enabling the keyframe
>     flag in the source buffer
>   [media] coda: add decoder timestamp queue
>   [media] coda: alert userspace about macroblock errors
>   [media] coda: add sequence counter offset
>   [media] coda: use prescan_failed variable to stop stream after a
>     timeout
>   [media] coda: add reset control support
>   [media] coda: add bytesperline to queue data
>   [media] coda: allow odd width, but still round up bytesperline
>   [media] coda: round up internal frames to multiples of macroblock size
>     for h.264
>   [media] coda: increase frame stride to 16 for h.264
>   [media] coda: export auxiliary buffers via debugfs
> 
>  drivers/media/platform/Kconfig         |    1 +
>  drivers/media/platform/coda.c          | 1505 +++++++++++++++++++++++---------
>  drivers/media/platform/coda.h          |  115 ++-
>  drivers/media/v4l2-core/v4l2-mem2mem.c |    3 +-
>  include/media/v4l2-mem2mem.h           |    2 +
>  5 files changed, 1197 insertions(+), 429 deletions(-)
> 

