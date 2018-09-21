Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-2.cisco.com ([173.38.203.52]:28164 "EHLO
        aer-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727795AbeIUO3g (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Sep 2018 10:29:36 -0400
Subject: Re: [PATCH 05/18] video/hdmi: Add an enum for HDMI packet types
To: Ville Syrjala <ville.syrjala@linux.intel.com>,
        dri-devel@lists.freedesktop.org
Cc: intel-gfx@lists.freedesktop.org,
        Thierry Reding <thierry.reding@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org
References: <20180920185145.1912-1-ville.syrjala@linux.intel.com>
 <20180920185145.1912-6-ville.syrjala@linux.intel.com>
From: Hans Verkuil <hansverk@cisco.com>
Message-ID: <cc758a1b-acab-caf1-a374-1f58c48e3e98@cisco.com>
Date: Fri, 21 Sep 2018 10:41:46 +0200
MIME-Version: 1.0
In-Reply-To: <20180920185145.1912-6-ville.syrjala@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/20/18 20:51, Ville Syrjala wrote:
> From: Ville Syrjälä <ville.syrjala@linux.intel.com>
> 
> We'll be wanting to send more than just infoframes over HDMI. So add an
> enum for other packet types.
> 
> TODO: Maybe just include the infoframe types in the packet type enum
>       and get rid of the infoframe type enum?

I think that's better, IMHO. With a comment that the types starting with
0x81 are defined in CTA-861-G.

It's really the same byte that is being checked, so having two enums is
a bit misleading. The main difference is really which standard defines
the packet types.

Regards,

	Hans

> 
> Cc: Thierry Reding <thierry.reding@gmail.com>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: linux-media@vger.kernel.org
> Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
> ---
>  include/linux/hdmi.h | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/include/linux/hdmi.h b/include/linux/hdmi.h
> index c76b50a48e48..80521d9591a1 100644
> --- a/include/linux/hdmi.h
> +++ b/include/linux/hdmi.h
> @@ -27,6 +27,21 @@
>  #include <linux/types.h>
>  #include <linux/device.h>
>  
> +enum hdmi_packet_type {
> +	HDMI_PACKET_TYPE_NULL = 0x00,
> +	HDMI_PACKET_TYPE_AUDIO_CLOCK_REGEN = 0x01,
> +	HDMI_PACKET_TYPE_AUDIO_SAMPLE = 0x02,
> +	HDMI_PACKET_TYPE_GENERAL_CONTROL = 0x03,
> +	HDMI_PACKET_TYPE_AUDIO_CP = 0x04,
> +	HDMI_PACKET_TYPE_ISRC1 = 0x05,
> +	HDMI_PACKET_TYPE_ISRC2 = 0x06,
> +	HDMI_PACKET_TYPE_ONE_BIT_AUDIO_SAMPLE = 0x07,
> +	HDMI_PACKET_TYPE_DST_AUDIO = 0x08,
> +	HDMI_PACKET_TYPE_HBR_AUDIO_STREAM = 0x09,
> +	HDMI_PACKET_TYPE_GAMUT_METADATA = 0x0a,
> +	/* + enum hdmi_infoframe_type */
> +};
> +
>  enum hdmi_infoframe_type {
>  	HDMI_INFOFRAME_TYPE_VENDOR = 0x81,
>  	HDMI_INFOFRAME_TYPE_AVI = 0x82,
> 
