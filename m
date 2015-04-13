Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:35493 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184AbbDMFnk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Apr 2015 01:43:40 -0400
Received: by widdi4 with SMTP id di4so58404476wid.0
        for <linux-media@vger.kernel.org>; Sun, 12 Apr 2015 22:43:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1427219214-5368-2-git-send-email-p.zabel@pengutronix.de>
References: <1427219214-5368-1-git-send-email-p.zabel@pengutronix.de> <1427219214-5368-2-git-send-email-p.zabel@pengutronix.de>
From: Pawel Osciak <pawel@osciak.com>
Date: Mon, 13 Apr 2015 14:42:57 +0900
Message-ID: <CAMm-=zDTumuxqyfZh+dVTMXCX8k7aeD5CW1N7KrSQOhmWY4-7Q@mail.gmail.com>
Subject: Re: [PATCH v4 1/4] [media] videodev2: Add V4L2_BUF_FLAG_LAST
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Kamil Debski <k.debski@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	kernel@pengutronix.de, Peter Seiderer <ps.report@gmx.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
Thanks for working on this!

On Wed, Mar 25, 2015 at 2:46 AM, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> From: Peter Seiderer <ps.report@gmx.net>
>
> This v4l2_buffer flag can be used by drivers to mark a capture buffer
> as the last generated buffer, for example after a V4L2_DEC_CMD_STOP
> command was issued.
> The DocBook is updated to mention mem2mem codecs and the mem2mem draining flow
> signals in the VIDIOC_DECODER_CMD V4L2_DEC_CMD_STOP and VIDIOC_ENCODER_CMD
> V4L2_ENC_CMD_STOP documentation.
>
> Signed-off-by: Peter Seiderer <ps.report@gmx.net>
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
> Changes since v3:
>  - Added DocBook update mentioning V4L2_BUF_FLAG_LAST in the encoder/decoder
>    stop command documentation.
> ---
>  Documentation/DocBook/media/v4l/io.xml                 | 10 ++++++++++
>  Documentation/DocBook/media/v4l/vidioc-decoder-cmd.xml |  6 +++++-
>  Documentation/DocBook/media/v4l/vidioc-encoder-cmd.xml |  5 ++++-
>  include/trace/events/v4l2.h                            |  3 ++-
>  include/uapi/linux/videodev2.h                         |  2 ++
>  5 files changed, 23 insertions(+), 3 deletions(-)
>
> diff --git a/Documentation/DocBook/media/v4l/io.xml b/Documentation/DocBook/media/v4l/io.xml
> index 1c17f80..f3b8bc0 100644
> --- a/Documentation/DocBook/media/v4l/io.xml
> +++ b/Documentation/DocBook/media/v4l/io.xml
> @@ -1129,6 +1129,16 @@ in this buffer has not been created by the CPU but by some DMA-capable unit,
>  in which case caches have not been used.</entry>
>           </row>
>           <row>
> +           <entry><constant>V4L2_BUF_FLAG_LAST</constant></entry>
> +           <entry>0x00100000</entry>
> +           <entry>Last buffer produced by the hardware. mem2mem codec drivers
> +set this flag on the capture queue for the last buffer when the
> +<link linkend="vidioc-querybuf">VIDIOC_QUERYBUF</link> or
> +<link linkend="vidioc-qbuf">VIDIOC_DQBUF</link> ioctl is called. After the
> +queue is drained, the <link linkend="vidioc-qbuf">VIDIOC_DQBUF</link> ioctl will

Perhaps just s/After the queue is drained, the/Any subsequent/ ? This
would make it more clear I feel.
DQBUF of LAST is the end of draining.

> +not block anymore, but return an &EPIPE;.</entry>
> +         </row>
> +         <row>
>             <entry><constant>V4L2_BUF_FLAG_TIMESTAMP_MASK</constant></entry>
>             <entry>0x0000e000</entry>
>             <entry>Mask for timestamp types below. To test the
> diff --git a/Documentation/DocBook/media/v4l/vidioc-decoder-cmd.xml b/Documentation/DocBook/media/v4l/vidioc-decoder-cmd.xml
> index 9215627..cbb7135 100644
> --- a/Documentation/DocBook/media/v4l/vidioc-decoder-cmd.xml
> +++ b/Documentation/DocBook/media/v4l/vidioc-decoder-cmd.xml
> @@ -197,7 +197,11 @@ be muted when playing back at a non-standard speed.
>  this command does nothing. This command has two flags:
>  if <constant>V4L2_DEC_CMD_STOP_TO_BLACK</constant> is set, then the decoder will
>  set the picture to black after it stopped decoding. Otherwise the last image will
> -repeat. If <constant>V4L2_DEC_CMD_STOP_IMMEDIATELY</constant> is set, then the decoder
> +repeat. mem2mem decoders will stop producing new frames altogether. They will send
> +a <constant>V4L2_EVENT_EOS</constant> event after the last frame was decoded and

s/was decoded/has been decoded and all frames are ready to be dequeued/

> +will set the <constant>V4L2_BUF_FLAG_LAST</constant> buffer flag when there will
> +be no new buffers produced to dequeue.

To make the timing description more explicit, s/when there will be no
new buffers produced to dequeue./on the final buffer being dequeued/
perhaps?
EOS indicates "no more buffers will be produced and all are ready to
be dequeued", while LAST indicates "final buffer being dequeued".

> +If <constant>V4L2_DEC_CMD_STOP_IMMEDIATELY</constant> is set, then the decoder
>  stops immediately (ignoring the <structfield>pts</structfield> value), otherwise it
>  will keep decoding until timestamp >= pts or until the last of the pending data from
>  its internal buffers was decoded.
> diff --git a/Documentation/DocBook/media/v4l/vidioc-encoder-cmd.xml b/Documentation/DocBook/media/v4l/vidioc-encoder-cmd.xml
> index 0619ca5..e9cf601 100644
> --- a/Documentation/DocBook/media/v4l/vidioc-encoder-cmd.xml
> +++ b/Documentation/DocBook/media/v4l/vidioc-encoder-cmd.xml
> @@ -129,7 +129,10 @@ this command.</entry>
>  encoding will continue until the end of the current <wordasword>Group
>  Of Pictures</wordasword>, otherwise encoding will stop immediately.
>  When the encoder is already stopped, this command does
> -nothing.</entry>
> +nothing. mem2mem encoders will send a <constant>V4L2_EVENT_EOS</constant> event
> +after the last frame was encoded and will set the
> +<constant>V4L2_BUF_FLAG_LAST</constant> buffer flag on the capture queue when
> +there will be no new buffers produced to dequeue</entry>

I'd propose the same here.

-- 
Thanks,
Pawel
