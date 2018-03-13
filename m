Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f65.google.com ([209.85.160.65]:40309 "EHLO
        mail-pl0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751984AbeCMSbs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Mar 2018 14:31:48 -0400
Received: by mail-pl0-f65.google.com with SMTP id ay1-v6so300235plb.7
        for <linux-media@vger.kernel.org>; Tue, 13 Mar 2018 11:31:48 -0700 (PDT)
Subject: Re: [PATCH] imx.rst: fix typo
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Philipp Zabel <p.zabel@pengutronix.de>
References: <0b24f8eb-1d07-9fd9-8168-7986b40aadb2@xs4all.nl>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <6b31531d-63b7-8d1c-9ea3-d6cd95219d78@gmail.com>
Date: Tue, 13 Mar 2018 11:31:45 -0700
MIME-Version: 1.0
In-Reply-To: <0b24f8eb-1d07-9fd9-8168-7986b40aadb2@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Acked-by: Steve Longerbeam <steve_longerbeam@mentor.com>


On 03/13/2018 11:29 AM, Hans Verkuil wrote:
> Multpiple -> Multiple
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
> diff --git a/Documentation/media/v4l-drivers/imx.rst b/Documentation/media/v4l-drivers/imx.rst
> index 18e3141304bb..65d3d15eb159 100644
> --- a/Documentation/media/v4l-drivers/imx.rst
> +++ b/Documentation/media/v4l-drivers/imx.rst
> @@ -109,7 +109,7 @@ imx6-mipi-csi2
>   This is the MIPI CSI-2 receiver entity. It has one sink pad to receive
>   the MIPI CSI-2 stream (usually from a MIPI CSI-2 camera sensor). It has
>   four source pads, corresponding to the four MIPI CSI-2 demuxed virtual
> -channel outputs. Multpiple source pads can be enabled to independently
> +channel outputs. Multiple source pads can be enabled to independently
>   stream from multiple virtual channels.
>
>   This entity actually consists of two sub-blocks. One is the MIPI CSI-2
