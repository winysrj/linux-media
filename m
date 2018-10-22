Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:34211 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728172AbeJWAAs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 Oct 2018 20:00:48 -0400
Subject: Re: [PATCH v2 0/2] Document memory-to-memory video codec interfaces
To: Tomasz Figa <tfiga@chromium.org>, linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
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
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <6621f3b9-a5a0-d33f-306f-d405db34da2c@xs4all.nl>
Date: Mon, 22 Oct 2018 16:41:33 +0100
MIME-Version: 1.0
In-Reply-To: <20181022144901.113852-1-tfiga@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz, Alexandre,

Thank you for all your work! Much appreciated.

I've applied both the stateful and stateless patches on top of the request_api branch
and made the final result available here:

https://hverkuil.home.xs4all.nl/request-api/

Tomasz, I got two warnings when building the doc tree, the patch below fixes it.

Regards,

	Hans

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/Documentation/media/uapi/v4l/dev-decoder.rst b/Documentation/media/uapi/v4l/dev-decoder.rst
index 09c7a6621b8e..5522453ac39f 100644
--- a/Documentation/media/uapi/v4l/dev-decoder.rst
+++ b/Documentation/media/uapi/v4l/dev-decoder.rst
@@ -972,11 +972,11 @@ sequence was started.

    .. warning::

-   The sentence can be only initiated if both ``OUTPUT`` and ``CAPTURE`` queues
-   are streaming. For compatibility reasons, the call to
-   :c:func:`VIDIOC_DECODER_CMD` will not fail even if any of the queues is not
-   streaming, but at the same time it will not initiate the `Drain` sequence
-   and so the steps described below would not be applicable.
+      The sentence can be only initiated if both ``OUTPUT`` and ``CAPTURE`` queues
+      are streaming. For compatibility reasons, the call to
+      :c:func:`VIDIOC_DECODER_CMD` will not fail even if any of the queues is not
+      streaming, but at the same time it will not initiate the `Drain` sequence
+      and so the steps described below would not be applicable.

 2. Any ``OUTPUT`` buffers queued by the client before the
    :c:func:`VIDIOC_DECODER_CMD` was issued will be processed and decoded as
diff --git a/Documentation/media/uapi/v4l/dev-encoder.rst b/Documentation/media/uapi/v4l/dev-encoder.rst
index 41139e5e48eb..7f49a7149067 100644
--- a/Documentation/media/uapi/v4l/dev-encoder.rst
+++ b/Documentation/media/uapi/v4l/dev-encoder.rst
@@ -448,11 +448,11 @@ sequence was started.

    .. warning::

-   The sentence can be only initiated if both ``OUTPUT`` and ``CAPTURE`` queues
-   are streaming. For compatibility reasons, the call to
-   :c:func:`VIDIOC_ENCODER_CMD` will not fail even if any of the queues is not
-   streaming, but at the same time it will not initiate the `Drain` sequence
-   and so the steps described below would not be applicable.
+      The sentence can be only initiated if both ``OUTPUT`` and ``CAPTURE`` queues
+      are streaming. For compatibility reasons, the call to
+      :c:func:`VIDIOC_ENCODER_CMD` will not fail even if any of the queues is not
+      streaming, but at the same time it will not initiate the `Drain` sequence
+      and so the steps described below would not be applicable.

 2. Any ``OUTPUT`` buffers queued by the client before the
    :c:func:`VIDIOC_ENCODER_CMD` was issued will be processed and encoded as
