Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk1-f196.google.com ([209.85.222.196]:40860 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725806AbeKRLwt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 18 Nov 2018 06:52:49 -0500
Received: by mail-qk1-f196.google.com with SMTP id y16so43608448qki.7
        for <linux-media@vger.kernel.org>; Sat, 17 Nov 2018 17:34:11 -0800 (PST)
Message-ID: <dae0211b3bc01423f1e9de63e9b4ef0aee44c086.camel@ndufresne.ca>
Subject: Re: [PATCH v2 2/2] media: docs-rst: Document memory-to-memory video
 encoder interface
From: Nicolas Dufresne <nicolas@ndufresne.ca>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Tomasz Figa <tfiga@chromium.org>, linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        =?UTF-8?Q?Pawe=C5=82_O=C5=9Bciak?= <posciak@chromium.org>,
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
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        dave.stevenson@raspberrypi.org,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Maxime Jourdan <maxi.jourdan@wanadoo.fr>
Date: Sat, 17 Nov 2018 20:34:08 -0500
In-Reply-To: <d853eb91-c05d-fb10-f154-bc24e4ebb89d@xs4all.nl>
References: <20181022144901.113852-1-tfiga@chromium.org>
         <20181022144901.113852-3-tfiga@chromium.org>
         <4cd223f0-b09c-da07-f26c-3b3f7a8868d7@xs4all.nl>
         <5fb0f2db44ba7aa3788b61f2aa9a30d4f4984de5.camel@ndufresne.ca>
         <d853eb91-c05d-fb10-f154-bc24e4ebb89d@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le samedi 17 novembre 2018 à 12:37 +0100, Hans Verkuil a écrit :
> > > Does V4L2_CID_MIN_BUFFERS_FOR_CAPTURE make any sense for encoders?
> > 
> > We do account for it in GStreamer (the capture/output handling is
> > generic), but I don't know if it's being used anywhere. 
> 
> Do you use this value directly for REQBUFS, or do you use it as the minimum
> value but in practice use more buffers?

We add more buffers to that value. We assume this value is what will be
held by the driver, hence without adding some buffers, the driver would
go idle as soon as one is dequeued. We also need to allocate for the
importing driver.

In general, if we have a pipeline with Driver A sending to Driver B,
both driver will require a certain amount of buffers to operate. E.g.
with DRM display, the driver will hold on 1 buffer (the scannout
buffer).

In GStreamer, it's implemented generically, so we do:

  MIN_BUFFERS_FOR + remote_min + 1

If only MIN_BUFFERS_FOR was allocated, ignoring remote driver
requirement, the streaming will likely get stuck.

regards,
Nicolas
