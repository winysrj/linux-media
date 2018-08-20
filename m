Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:37043 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726455AbeHTWQt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Aug 2018 18:16:49 -0400
Received: by mail-qk0-f195.google.com with SMTP id f17-v6so4329469qkh.4
        for <linux-media@vger.kernel.org>; Mon, 20 Aug 2018 12:00:01 -0700 (PDT)
Message-ID: <85407132acc51cf749f8087128d4ebe326db6af2.camel@redhat.com>
Subject: Re: [PATCH (repost) 3/5] drm_dp_mst_topology: fix broken
 drm_dp_sideband_parse_remote_dpcd_read()
From: Lyude Paul <lyude@redhat.com>
Reply-To: lyude@redhat.com
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: nouveau@lists.freedesktop.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Date: Mon, 20 Aug 2018 14:59:59 -0400
In-Reply-To: <20180817141122.9541-4-hverkuil@xs4all.nl>
References: <20180817141122.9541-1-hverkuil@xs4all.nl>
         <20180817141122.9541-4-hverkuil@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reviewed-by: Lyude Paul <lyude@redhat.com>

We really need to add support for using this into the MST helpers. A good way to
test this would probably be to hook up an aux device to the DP AUX adapters we
create for each MST topology

On Fri, 2018-08-17 at 16:11 +0200, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> When parsing the reply of a DP_REMOTE_DPCD_READ DPCD command the
> result is wrong due to a missing idx increment.
> 
> This was never noticed since DP_REMOTE_DPCD_READ is currently not
> used, but if you enable it, then it is all wrong.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/gpu/drm/drm_dp_mst_topology.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c
> b/drivers/gpu/drm/drm_dp_mst_topology.c
> index 7780567aa669..5ff1d79b86c4 100644
> --- a/drivers/gpu/drm/drm_dp_mst_topology.c
> +++ b/drivers/gpu/drm/drm_dp_mst_topology.c
> @@ -439,6 +439,7 @@ static bool drm_dp_sideband_parse_remote_dpcd_read(struct
> drm_dp_sideband_msg_rx
>  	if (idx > raw->curlen)
>  		goto fail_len;
>  	repmsg->u.remote_dpcd_read_ack.num_bytes = raw->msg[idx];
> +	idx++;
>  	if (idx > raw->curlen)
>  		goto fail_len;
>  
