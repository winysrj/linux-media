Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:34529 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751711AbdLDJbw (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 4 Dec 2017 04:31:52 -0500
Received: by mail-lf0-f67.google.com with SMTP id x20so18359289lff.1
        for <linux-media@vger.kernel.org>; Mon, 04 Dec 2017 01:31:51 -0800 (PST)
Subject: Re: [PATCH 5/9] v4l: vsp1: Document the vsp1_du_atomic_config
 structure
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: linux-renesas-soc@vger.kernel.org
References: <20171203105735.10529-1-laurent.pinchart+renesas@ideasonboard.com>
 <20171203105735.10529-6-laurent.pinchart+renesas@ideasonboard.com>
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <9703309e-d841-f8dc-b37a-be7a96ce91ae@cogentembedded.com>
Date: Mon, 4 Dec 2017 12:31:49 +0300
MIME-Version: 1.0
In-Reply-To: <20171203105735.10529-6-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello!

On 12/3/2017 1:57 PM, Laurent Pinchart wrote:

> The structure is used in the API that the VSP1 driver exposes to the DU
> driver. Documenting it is thus important.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> ---
>   include/media/vsp1.h | 10 ++++++++++
>   1 file changed, 10 insertions(+)
> 
> diff --git a/include/media/vsp1.h b/include/media/vsp1.h
> index 68a8abe4fac5..7850f96fb708 100644
> --- a/include/media/vsp1.h
> +++ b/include/media/vsp1.h
> @@ -41,6 +41,16 @@ struct vsp1_du_lif_config {
>   int vsp1_du_setup_lif(struct device *dev, unsigned int pipe_index,
>   		      const struct vsp1_du_lif_config *cfg);
>   
> +/**
> + * struct vsp1_du_atomic_config - VSP atomic configuration parameters
> + * @pixelformat: plan pixel format (V4L2 4CC)

    s/plan/plane/?

[...]

MBR, Sergei
