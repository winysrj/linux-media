Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f52.google.com ([209.85.213.52]:39960 "EHLO
        mail-vk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750716AbeAOTfi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 15 Jan 2018 14:35:38 -0500
MIME-Version: 1.0
In-Reply-To: <cover.30aaad9a6abac5e92d4a1a0e6634909d97cc54d8.1515748369.git-series.kieran.bingham@ideasonboard.com>
References: <cover.30aaad9a6abac5e92d4a1a0e6634909d97cc54d8.1515748369.git-series.kieran.bingham@ideasonboard.com>
From: Philipp Zabel <philipp.zabel@gmail.com>
Date: Mon, 15 Jan 2018 20:35:36 +0100
Message-ID: <CA+gwMcfh0Oc53TZLc=_xtFJrqfw8s0gjD9mfPFZ_Cp9=vMAMDQ@mail.gmail.com>
Subject: Re: [RFT PATCH v3 0/6] Asynchronous UVC
To: Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Olivier BRAUN <olivier.braun@stereolabs.com>,
        Troy Kisky <troy.kisky@boundarydevices.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

On Fri, Jan 12, 2018 at 10:19 AM, Kieran Bingham
<kieran.bingham@ideasonboard.com> wrote:
> This series has been tested on both the ZED and BRIO cameras on arm64
> platforms, however due to the intrinsic changes in the driver I would like to
> see it tested with other devices and other platforms, so I'd appreciate if
> anyone can test this on a range of USB cameras.

FWIW,

Tested-by: Philipp Zabel <philipp.zabel@gmail.com>

with a Lite-On internal Laptop Webcam, Logitech C910 (USB2 isoc),
Oculus Sensor (USB3 isoc), and Microsoft HoloLens Sensors (USB3 bulk).

regards
Philipp
