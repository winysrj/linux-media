Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:63018 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751155AbdKTOwD (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Nov 2017 09:52:03 -0500
Date: Mon, 20 Nov 2017 16:51:54 +0200
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Thierry Reding <thierry.reding@gmail.com>,
        Hans Verkuil <hansverk@cisco.com>
Subject: Re: [PATCH 1/2] drivers/video/hdmi: allow for larger-than-needed
 vendor IF
Message-ID: <20171120145154.GW10981@intel.com>
References: <20171120134129.26161-1-hverkuil@xs4all.nl>
 <20171120134129.26161-2-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20171120134129.26161-2-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Nov 20, 2017 at 02:41:28PM +0100, Hans Verkuil wrote:
> From: Hans Verkuil <hansverk@cisco.com>
> 
> Some devices (Windows Intel driver!) send a Vendor InfoFrame that
> uses a payload length of 0x1b instead of the length of 5 or 6
> that the unpack code expects. The InfoFrame is padded with 0 by
> the source.

So it doesn't put any 3D_Metadata stuff in there? We don't see to
have code to parse/generate any of that.

Sadly the spec doesn't seem to forbid sending an overly long infoframe
as long it's padded with 0. Would have been nicer for extending it if
that sort of thing was forbidden. But I guess everything can be solved
with flags. Not that I expect anyone to extend it anymore now that
HDMI 2.0 has specified a totally new infoframe.

> 
> The current code thinks anything other than 5 or 6 is an error,
> but larger values are allowed by the specification. So support
> that here as well.
> 
> Signed-off-by: Hans Verkuil <hansverk@cisco.com>
> ---
>  drivers/video/hdmi.c | 3 +--
>  include/linux/hdmi.h | 1 +
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/video/hdmi.c b/drivers/video/hdmi.c
> index 1cf907ecded4..61f803f75a47 100644
> --- a/drivers/video/hdmi.c
> +++ b/drivers/video/hdmi.c
> @@ -1164,8 +1164,7 @@ hdmi_vendor_any_infoframe_unpack(union hdmi_vendor_any_infoframe *frame,
>  	struct hdmi_vendor_infoframe *hvf = &frame->hdmi;
>  
>  	if (ptr[0] != HDMI_INFOFRAME_TYPE_VENDOR ||
> -	    ptr[1] != 1 ||
> -	    (ptr[2] != 5 && ptr[2] != 6))
> +	    ptr[1] != 1 || ptr[2] < 5 || ptr[2] > HDMI_VENDOR_INFOFRAME_SIZE)
>  		return -EINVAL;
>  
>  	length = ptr[2];
> diff --git a/include/linux/hdmi.h b/include/linux/hdmi.h
> index d271ff23984f..14d3531a0eda 100644
> --- a/include/linux/hdmi.h
> +++ b/include/linux/hdmi.h
> @@ -40,6 +40,7 @@ enum hdmi_infoframe_type {
>  #define HDMI_AVI_INFOFRAME_SIZE    13
>  #define HDMI_SPD_INFOFRAME_SIZE    25
>  #define HDMI_AUDIO_INFOFRAME_SIZE  10
> +#define HDMI_VENDOR_INFOFRAME_SIZE 31
>  
>  #define HDMI_INFOFRAME_SIZE(type)	\
>  	(HDMI_INFOFRAME_HEADER_SIZE + HDMI_ ## type ## _INFOFRAME_SIZE)
> -- 
> 2.14.1

-- 
Ville Syrjälä
Intel OTC
