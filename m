Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-3.cisco.com ([173.38.203.53]:16662 "EHLO
        aer-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725898AbeIUNyX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Sep 2018 09:54:23 -0400
Subject: Re: [PATCH 03/18] video/hdmi: Constify infoframe passed to the log
 functions
To: Ville Syrjala <ville.syrjala@linux.intel.com>,
        dri-devel@lists.freedesktop.org
Cc: intel-gfx@lists.freedesktop.org,
        Thierry Reding <thierry.reding@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org
References: <20180920185145.1912-1-ville.syrjala@linux.intel.com>
 <20180920185145.1912-4-ville.syrjala@linux.intel.com>
From: Hans Verkuil <hansverk@cisco.com>
Message-ID: <2bb731e1-e42a-2016-cd66-bd1757ae8489@cisco.com>
Date: Fri, 21 Sep 2018 10:06:39 +0200
MIME-Version: 1.0
In-Reply-To: <20180920185145.1912-4-ville.syrjala@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/20/18 20:51, Ville Syrjala wrote:
> From: Ville Syrjälä <ville.syrjala@linux.intel.com>
> 
> The log functions don't modify the passed in infoframe so make it const.
> 
> Cc: Thierry Reding <thierry.reding@gmail.com>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks,

	Hans


> Cc: linux-media@vger.kernel.org
> Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
> ---
>  drivers/video/hdmi.c | 22 +++++++++++-----------
>  include/linux/hdmi.h |  2 +-
>  2 files changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/video/hdmi.c b/drivers/video/hdmi.c
> index b5d491014b0b..53e7ee2c83fc 100644
> --- a/drivers/video/hdmi.c
> +++ b/drivers/video/hdmi.c
> @@ -471,7 +471,7 @@ static const char *hdmi_infoframe_type_get_name(enum hdmi_infoframe_type type)
>  
>  static void hdmi_infoframe_log_header(const char *level,
>  				      struct device *dev,
> -				      struct hdmi_any_infoframe *frame)
> +				      const struct hdmi_any_infoframe *frame)
>  {
>  	hdmi_log("HDMI infoframe: %s, version %u, length %u\n",
>  		hdmi_infoframe_type_get_name(frame->type),
> @@ -673,10 +673,10 @@ hdmi_content_type_get_name(enum hdmi_content_type content_type)
>   */
>  static void hdmi_avi_infoframe_log(const char *level,
>  				   struct device *dev,
> -				   struct hdmi_avi_infoframe *frame)
> +				   const struct hdmi_avi_infoframe *frame)
>  {
>  	hdmi_infoframe_log_header(level, dev,
> -				  (struct hdmi_any_infoframe *)frame);
> +				  (const struct hdmi_any_infoframe *)frame);
>  
>  	hdmi_log("    colorspace: %s\n",
>  			hdmi_colorspace_get_name(frame->colorspace));
> @@ -750,12 +750,12 @@ static const char *hdmi_spd_sdi_get_name(enum hdmi_spd_sdi sdi)
>   */
>  static void hdmi_spd_infoframe_log(const char *level,
>  				   struct device *dev,
> -				   struct hdmi_spd_infoframe *frame)
> +				   const struct hdmi_spd_infoframe *frame)
>  {
>  	u8 buf[17];
>  
>  	hdmi_infoframe_log_header(level, dev,
> -				  (struct hdmi_any_infoframe *)frame);
> +				  (const struct hdmi_any_infoframe *)frame);
>  
>  	memset(buf, 0, sizeof(buf));
>  
> @@ -886,10 +886,10 @@ hdmi_audio_coding_type_ext_get_name(enum hdmi_audio_coding_type_ext ctx)
>   */
>  static void hdmi_audio_infoframe_log(const char *level,
>  				     struct device *dev,
> -				     struct hdmi_audio_infoframe *frame)
> +				     const struct hdmi_audio_infoframe *frame)
>  {
>  	hdmi_infoframe_log_header(level, dev,
> -				  (struct hdmi_any_infoframe *)frame);
> +				  (const struct hdmi_any_infoframe *)frame);
>  
>  	if (frame->channels)
>  		hdmi_log("    channels: %u\n", frame->channels - 1);
> @@ -949,12 +949,12 @@ hdmi_3d_structure_get_name(enum hdmi_3d_structure s3d_struct)
>  static void
>  hdmi_vendor_any_infoframe_log(const char *level,
>  			      struct device *dev,
> -			      union hdmi_vendor_any_infoframe *frame)
> +			      const union hdmi_vendor_any_infoframe *frame)
>  {
> -	struct hdmi_vendor_infoframe *hvf = &frame->hdmi;
> +	const struct hdmi_vendor_infoframe *hvf = &frame->hdmi;
>  
>  	hdmi_infoframe_log_header(level, dev,
> -				  (struct hdmi_any_infoframe *)frame);
> +				  (const struct hdmi_any_infoframe *)frame);
>  
>  	if (frame->any.oui != HDMI_IEEE_OUI) {
>  		hdmi_log("    not a HDMI vendor infoframe\n");
> @@ -984,7 +984,7 @@ hdmi_vendor_any_infoframe_log(const char *level,
>   */
>  void hdmi_infoframe_log(const char *level,
>  			struct device *dev,
> -			union hdmi_infoframe *frame)
> +			const union hdmi_infoframe *frame)
>  {
>  	switch (frame->any.type) {
>  	case HDMI_INFOFRAME_TYPE_AVI:
> diff --git a/include/linux/hdmi.h b/include/linux/hdmi.h
> index a577d4ae2570..bce1abb1fe57 100644
> --- a/include/linux/hdmi.h
> +++ b/include/linux/hdmi.h
> @@ -335,6 +335,6 @@ hdmi_infoframe_pack(union hdmi_infoframe *frame, void *buffer, size_t size);
>  int hdmi_infoframe_unpack(union hdmi_infoframe *frame,
>  			  const void *buffer, size_t size);
>  void hdmi_infoframe_log(const char *level, struct device *dev,
> -			union hdmi_infoframe *frame);
> +			const union hdmi_infoframe *frame);
>  
>  #endif /* _DRM_HDMI_H */
> 
