Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:41424 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729371AbeKMA5v (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Nov 2018 19:57:51 -0500
Received: by mail-wr1-f68.google.com with SMTP id v18-v6so9723273wrt.8
        for <linux-media@vger.kernel.org>; Mon, 12 Nov 2018 07:04:12 -0800 (PST)
Subject: Re: [PATCH v2 1/2] media: docs-rst: Document memory-to-memory video
 decoder interface
To: Tomasz Figa <tfiga@chromium.org>, linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        =?UTF-8?B?UGF3ZcWCIE/Fm2NpYWs=?= <posciak@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Kamil Debski <kamil@wypas.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Jeongtae Park <jtp.park@samsung.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Tiffany Lin <tiffany.lin@mediatek.com>,
        Andrew-CT Chen <andrew-ct.chen@mediatek.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Todor Tomov <todor.tomov@linaro.org>,
        Nicolas Dufresne <nicolas@ndufresne.ca>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        dave.stevenson@raspberrypi.org,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Maxime Jourdan <maxi.jourdan@wanadoo.fr>
References: <20181022144901.113852-1-tfiga@chromium.org>
 <20181022144901.113852-2-tfiga@chromium.org>
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <95f49917-5051-4604-63ea-ba3966d5179e@linaro.org>
Date: Mon, 12 Nov 2018 17:04:06 +0200
MIME-Version: 1.0
In-Reply-To: <20181022144901.113852-2-tfiga@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

On 10/22/18 5:48 PM, Tomasz Figa wrote:
> Due to complexity of the video decoding process, the V4L2 drivers of
> stateful decoder hardware require specific sequences of V4L2 API calls
> to be followed. These include capability enumeration, initialization,
> decoding, seek, pause, dynamic resolution change, drain and end of
> stream.
> 
> Specifics of the above have been discussed during Media Workshops at
> LinuxCon Europe 2012 in Barcelona and then later Embedded Linux
> Conference Europe 2014 in Düsseldorf. The de facto Codec API that
> originated at those events was later implemented by the drivers we already
> have merged in mainline, such as s5p-mfc or coda.
> 
> The only thing missing was the real specification included as a part of
> Linux Media documentation. Fix it now and document the decoder part of
> the Codec API.
> 
> Signed-off-by: Tomasz Figa <tfiga@chromium.org>
> ---
>  Documentation/media/uapi/v4l/dev-decoder.rst  | 1082 +++++++++++++++++
>  Documentation/media/uapi/v4l/devices.rst      |    1 +
>  Documentation/media/uapi/v4l/pixfmt-v4l2.rst  |    5 +
>  Documentation/media/uapi/v4l/v4l2.rst         |   10 +-
>  .../media/uapi/v4l/vidioc-decoder-cmd.rst     |   40 +-
>  Documentation/media/uapi/v4l/vidioc-g-fmt.rst |   14 +
>  6 files changed, 1137 insertions(+), 15 deletions(-)
>  create mode 100644 Documentation/media/uapi/v4l/dev-decoder.rst
> 
> diff --git a/Documentation/media/uapi/v4l/dev-decoder.rst b/Documentation/media/uapi/v4l/dev-decoder.rst
> new file mode 100644
> index 000000000000..09c7a6621b8e
> --- /dev/null
> +++ b/Documentation/media/uapi/v4l/dev-decoder.rst


> +State machine
> +=============
> +
> +.. kernel-render:: DOT
> +   :alt: DOT digraph of decoder state machine
> +   :caption: Decoder state machine
> +
> +   digraph decoder_state_machine {
> +       node [shape = doublecircle, label="Decoding"] Decoding;
> +
> +       node [shape = circle, label="Initialization"] Initialization;
> +       node [shape = circle, label="Capture\nsetup"] CaptureSetup;
> +       node [shape = circle, label="Dynamic\nresolution\nchange"] ResChange;
> +       node [shape = circle, label="Stopped"] Stopped;
> +       node [shape = circle, label="Drain"] Drain;
> +       node [shape = circle, label="Seek"] Seek;
> +       node [shape = circle, label="End of stream"] EoS;
> +
> +       node [shape = point]; qi
> +       qi -> Initialization [ label = "open()" ];
> +
> +       Initialization -> CaptureSetup [ label = "CAPTURE\nformat\nestablished" ];
> +
> +       CaptureSetup -> Stopped [ label = "CAPTURE\nbuffers\nready" ];
> +
> +       Decoding -> ResChange [ label = "Stream\nresolution\nchange" ];
> +       Decoding -> Drain [ label = "V4L2_DEC_CMD_STOP" ];
> +       Decoding -> EoS [ label = "EoS mark\nin the stream" ];
> +       Decoding -> Seek [ label = "VIDIOC_STREAMOFF(OUTPUT)" ];
> +       Decoding -> Stopped [ label = "VIDIOC_STREAMOFF(CAPTURE)" ];
> +       Decoding -> Decoding;
> +
> +       ResChange -> CaptureSetup [ label = "CAPTURE\nformat\nestablished" ];
> +       ResChange -> Seek [ label = "VIDIOC_STREAMOFF(OUTPUT)" ];
> +
> +       EoS -> Drain [ label = "Implicit\ndrain" ];
> +
> +       Drain -> Stopped [ label = "All CAPTURE\nbuffers dequeued\nor\nVIDIOC_STREAMOFF(CAPTURE)" ];
> +       Drain -> Seek [ label = "VIDIOC_STREAMOFF(OUTPUT)" ];
> +
> +       Seek -> Decoding [ label = "VIDIOC_STREAMON(OUTPUT)" ];
> +       Seek -> Initialization [ label = "VIDIOC_REQBUFS(OUTPUT, 0)" ];

Shouldn't this be [ label = "VIDIOC_STREAMOFF(CAPTURE)" ], for me it is
looks more natural for v4l2?

For example I want to exit immediately from decoding state with calls to
streamoff(OUTPUT) and streamoff(CAPTURE). This could be when you press
ctrl-c while playing video, in this case I don't expect EoS nor buffers
draining.

> +
> +       Stopped -> Decoding [ label = "V4L2_DEC_CMD_START\nor\nVIDIOC_STREAMON(CAPTURE)" ];
> +       Stopped -> Seek [ label = "VIDIOC_STREAMOFF(OUTPUT)" ];
> +   }
> +


-- 
regards,
Stan
