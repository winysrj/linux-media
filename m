Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:61425 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759126AbdKPOgW (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 16 Nov 2017 09:36:22 -0500
Subject: Re: [PATCH 01/10] video/hdmi: Allow "empty" HDMI infoframes
To: Ville Syrjala <ville.syrjala@linux.intel.com>,
        dri-devel@lists.freedesktop.org
References: <20171113170427.4150-1-ville.syrjala@linux.intel.com>
 <20171113170427.4150-2-ville.syrjala@linux.intel.com>
Cc: intel-gfx@lists.freedesktop.org,
        Andrzej Hajda <a.hajda@samsung.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org
From: "Sharma, Shashank" <shashank.sharma@intel.com>
Message-ID: <6e738687-62f2-c803-a64c-7364bae3eacf@intel.com>
Date: Thu, 16 Nov 2017 20:06:18 +0530
MIME-Version: 1.0
In-Reply-To: <20171113170427.4150-2-ville.syrjala@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Regards

Shashank


On 11/13/2017 10:34 PM, Ville Syrjala wrote:
> From: Ville Syrjälä <ville.syrjala@linux.intel.com>
>
> HDMI 2.0 Appendix F suggest that we should keep sending the infoframe
> when switching from 3D to 2D mode, even if the infoframe isn't strictly
> necessary (ie. not needed to transmit the VIC or stereo information).
> This is a workaround against some sinks that fail to realize that they
> should switch from 3D to 2D mode when the source stop transmitting
> the infoframe.
>
> v2: Handle unpack() as well
>      Pull the length calculation into a helper
>
> Cc: Shashank Sharma <shashank.sharma@intel.com>
> Cc: Andrzej Hajda <a.hajda@samsung.com>
> Cc: Thierry Reding <thierry.reding@gmail.com>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: linux-media@vger.kernel.org
> Reviewed-by: Andrzej Hajda <a.hajda@samsung.com> #v1
> Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
> ---
>   drivers/video/hdmi.c | 51 +++++++++++++++++++++++++++++++--------------------
>   1 file changed, 31 insertions(+), 20 deletions(-)
>
> diff --git a/drivers/video/hdmi.c b/drivers/video/hdmi.c
> index 1cf907ecded4..111a0ab6280a 100644
> --- a/drivers/video/hdmi.c
> +++ b/drivers/video/hdmi.c
> @@ -321,6 +321,17 @@ int hdmi_vendor_infoframe_init(struct hdmi_vendor_infoframe *frame)
>   }
>   EXPORT_SYMBOL(hdmi_vendor_infoframe_init);
>   
> +static int hdmi_vendor_infoframe_length(const struct hdmi_vendor_infoframe *frame)
> +{
> +	/* for side by side (half) we also need to provide 3D_Ext_Data */
> +	if (frame->s3d_struct >= HDMI_3D_STRUCTURE_SIDE_BY_SIDE_HALF)
> +		return 6;
> +	else if (frame->vic != 0 || frame->s3d_struct != HDMI_3D_STRUCTURE_INVALID)
> +		return 5;
> +	else
> +		return 4;
> +}
> +
>   /**
>    * hdmi_vendor_infoframe_pack() - write a HDMI vendor infoframe to binary buffer
>    * @frame: HDMI infoframe
> @@ -341,19 +352,11 @@ ssize_t hdmi_vendor_infoframe_pack(struct hdmi_vendor_infoframe *frame,
>   	u8 *ptr = buffer;
>   	size_t length;
>   
> -	/* empty info frame */
> -	if (frame->vic == 0 && frame->s3d_struct == HDMI_3D_STRUCTURE_INVALID)
> -		return -EINVAL;
> -
>   	/* only one of those can be supplied */
>   	if (frame->vic != 0 && frame->s3d_struct != HDMI_3D_STRUCTURE_INVALID)
>   		return -EINVAL;
>   
> -	/* for side by side (half) we also need to provide 3D_Ext_Data */
> -	if (frame->s3d_struct >= HDMI_3D_STRUCTURE_SIDE_BY_SIDE_HALF)
> -		frame->length = 6;
> -	else
> -		frame->length = 5;
> +	frame->length = hdmi_vendor_infoframe_length(frame);
>   
>   	length = HDMI_INFOFRAME_HEADER_SIZE + frame->length;
>   
> @@ -372,14 +375,16 @@ ssize_t hdmi_vendor_infoframe_pack(struct hdmi_vendor_infoframe *frame,
>   	ptr[5] = 0x0c;
>   	ptr[6] = 0x00;
>   
> -	if (frame->vic) {
> -		ptr[7] = 0x1 << 5;	/* video format */
> -		ptr[8] = frame->vic;
> -	} else {
> +	if (frame->s3d_struct != HDMI_3D_STRUCTURE_INVALID) {
>   		ptr[7] = 0x2 << 5;	/* video format */
>   		ptr[8] = (frame->s3d_struct & 0xf) << 4;
>   		if (frame->s3d_struct >= HDMI_3D_STRUCTURE_SIDE_BY_SIDE_HALF)
>   			ptr[9] = (frame->s3d_ext_data & 0xf) << 4;
> +	} else if (frame->vic) {
Please correct me if I dint understand this properly, but for a HDMI 2.0 
sink + 3D transmission, wouldn't I be sending
HDMI 2.0 VIC = 94 as well as some valid s3d flag (like side by side) ?

- Shashank
> +		ptr[7] = 0x1 << 5;	/* video format */
> +		ptr[8] = frame->vic;
> +	} else {
> +		ptr[7] = 0x0 << 5;	/* video format */
>   	}
>   
>   	hdmi_infoframe_set_checksum(buffer, length);
> @@ -1165,7 +1170,7 @@ hdmi_vendor_any_infoframe_unpack(union hdmi_vendor_any_infoframe *frame,
>   
>   	if (ptr[0] != HDMI_INFOFRAME_TYPE_VENDOR ||
>   	    ptr[1] != 1 ||
> -	    (ptr[2] != 5 && ptr[2] != 6))
> +	    (ptr[2] != 4 && ptr[2] != 5 && ptr[2] != 6))
>   		return -EINVAL;
>   
>   	length = ptr[2];
> @@ -1193,16 +1198,22 @@ hdmi_vendor_any_infoframe_unpack(union hdmi_vendor_any_infoframe *frame,
>   
>   	hvf->length = length;
>   
> -	if (hdmi_video_format == 0x1) {
> -		hvf->vic = ptr[4];
> -	} else if (hdmi_video_format == 0x2) {
> +	if (hdmi_video_format == 0x2) {
> +		if (length != 5 && length != 6)
> +			return -EINVAL;
>   		hvf->s3d_struct = ptr[4] >> 4;
>   		if (hvf->s3d_struct >= HDMI_3D_STRUCTURE_SIDE_BY_SIDE_HALF) {
> -			if (length == 6)
> -				hvf->s3d_ext_data = ptr[5] >> 4;
> -			else
> +			if (length != 6)
>   				return -EINVAL;
> +			hvf->s3d_ext_data = ptr[5] >> 4;
>   		}
> +	} else if (hdmi_video_format == 0x1) {
> +		if (length != 5)
> +			return -EINVAL;
> +		hvf->vic = ptr[4];
> +	} else {
> +		if (length != 4)
> +			return -EINVAL;
>   	}
>   
>   	return 0;
