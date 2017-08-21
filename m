Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:46438 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751245AbdHUHsj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Aug 2017 03:48:39 -0400
Subject: Re: [v4l-utils PATCH 1/1] v4l2-compliance: Add support for metadata
 output
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Cc: tfiga@chromium.org, yong.zhi@intel.com
References: <20170821073849.20487-1-sakari.ailus@linux.intel.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <1257cee2-63fb-23ce-fc81-908b660467c0@xs4all.nl>
Date: Mon, 21 Aug 2017 09:48:31 +0200
MIME-Version: 1.0
In-Reply-To: <20170821073849.20487-1-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the patch, but it is not complete. Most importantly the V4L2_BUF_TYPE_LAST
define in v4l2-compliance.h isn't updated to V4L2_BUF_TYPE_META_OUTPUT.

It's best to just do a 'git grep META_CAPTURE' in v4l-utils and check each place it
is used whether META_OUTPUT support should also be added.

Note for v4l2-ctl-meta.cpp: interestingly the usage help for meta formats already
includes support for meta output, but no where else in v4l2-ctl is there meta output
support.

It appears to be unintentional that this was committed.

Regards,

	Hans

On 08/21/2017 09:38 AM, Sakari Ailus wrote:
> Add support for metadata output video nodes, in other words,
> V4L2_CAP_META_OUTPUT and V4L2_BUF_TYPE_META_OUTPUT.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
> Hi all,
> 
> This patch adds support for metadata output in v4l2-compliance.
> 
> It depends on the metadata output patch:
> 
> <URL:https://patchwork.linuxtv.org/patch/43308/>
> 
>  include/linux/videodev2.h                   |  3 ++-
>  utils/v4l2-compliance/v4l2-compliance.cpp   | 11 ++++++++---
>  utils/v4l2-compliance/v4l2-test-formats.cpp |  8 +++++++-
>  3 files changed, 17 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> index 49fe06c97..101be86c0 100644
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h
> @@ -142,6 +142,7 @@ enum v4l2_buf_type {
>  	V4L2_BUF_TYPE_SDR_CAPTURE          = 11,
>  	V4L2_BUF_TYPE_SDR_OUTPUT           = 12,
>  	V4L2_BUF_TYPE_META_CAPTURE         = 13,
> +	V4L2_BUF_TYPE_META_OUTPUT          = 14,
>  	/* Deprecated, do not use */
>  	V4L2_BUF_TYPE_PRIVATE              = 0x80,
>  };
> @@ -453,7 +454,7 @@ struct v4l2_capability {
>  #define V4L2_CAP_READWRITE              0x01000000  /* read/write systemcalls */
>  #define V4L2_CAP_ASYNCIO                0x02000000  /* async I/O */
>  #define V4L2_CAP_STREAMING              0x04000000  /* streaming I/O ioctls */
> -
> +#define V4L2_CAP_META_OUTPUT           0x08000000
>  #define V4L2_CAP_TOUCH                  0x10000000  /* Is a touch device */
>  
>  #define V4L2_CAP_DEVICE_CAPS            0x80000000  /* sets device capabilities field */
> diff --git a/utils/v4l2-compliance/v4l2-compliance.cpp b/utils/v4l2-compliance/v4l2-compliance.cpp
> index c40e3bd78..539c8c34b 100644
> --- a/utils/v4l2-compliance/v4l2-compliance.cpp
> +++ b/utils/v4l2-compliance/v4l2-compliance.cpp
> @@ -216,6 +216,8 @@ std::string cap2s(unsigned cap)
>  		s += "\t\tSDR Output\n";
>  	if (cap & V4L2_CAP_META_CAPTURE)
>  		s += "\t\tMetadata Capture\n";
> +	if (cap & V4L2_CAP_META_OUTPUT)
> +		s += "\t\tMetadata Output\n";
>  	if (cap & V4L2_CAP_TOUCH)
>  		s += "\t\tTouch Device\n";
>  	if (cap & V4L2_CAP_TUNER)
> @@ -283,6 +285,8 @@ std::string buftype2s(int type)
>  		return "SDR Output";
>  	case V4L2_BUF_TYPE_META_CAPTURE:
>  		return "Metadata Capture";
> +	case V4L2_BUF_TYPE_META_OUTPUT:
> +		return "Metadata Output";
>  	case V4L2_BUF_TYPE_PRIVATE:
>  		return "Private";
>  	default:
> @@ -525,7 +529,7 @@ static int testCap(struct node *node)
>  	const __u32 output_caps = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_VIDEO_OUTPUT_MPLANE |
>  			V4L2_CAP_VIDEO_OUTPUT_OVERLAY | V4L2_CAP_VBI_OUTPUT |
>  			V4L2_CAP_SDR_OUTPUT | V4L2_CAP_SLICED_VBI_OUTPUT |
> -			V4L2_CAP_MODULATOR;
> +			V4L2_CAP_MODULATOR | V4L2_CAP_META_OUTPUT;
>  	const __u32 overlay_caps = V4L2_CAP_VIDEO_OVERLAY | V4L2_CAP_VIDEO_OUTPUT_OVERLAY;
>  	const __u32 m2m_caps = V4L2_CAP_VIDEO_M2M | V4L2_CAP_VIDEO_M2M_MPLANE;
>  	const __u32 io_caps = V4L2_CAP_STREAMING | V4L2_CAP_READWRITE;
> @@ -1005,12 +1009,13 @@ int main(int argc, char **argv)
>  	if (node.g_caps() & (V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_VBI_OUTPUT |
>  			 V4L2_CAP_VIDEO_OUTPUT_MPLANE | V4L2_CAP_VIDEO_M2M_MPLANE |
>  			 V4L2_CAP_VIDEO_M2M | V4L2_CAP_SLICED_VBI_OUTPUT |
> -			 V4L2_CAP_RDS_OUTPUT | V4L2_CAP_SDR_OUTPUT))
> +			 V4L2_CAP_RDS_OUTPUT | V4L2_CAP_SDR_OUTPUT |
> +			 V4L2_CAP_META_OUTPUT))
>  		node.can_output = true;
>  	if (node.g_caps() & (V4L2_CAP_VIDEO_CAPTURE_MPLANE | V4L2_CAP_VIDEO_OUTPUT_MPLANE |
>  			 V4L2_CAP_VIDEO_M2M_MPLANE))
>  		node.is_planar = true;
> -	if (node.g_caps() & V4L2_CAP_META_CAPTURE) {
> +	if (node.g_caps() & (V4L2_CAP_META_CAPTURE | V4L2_CAP_META_OUTPUT)) {
>  		node.is_video = false;
>  		node.is_meta = true;
>  	}
> diff --git a/utils/v4l2-compliance/v4l2-test-formats.cpp b/utils/v4l2-compliance/v4l2-test-formats.cpp
> index b7a32fe38..9da7436e8 100644
> --- a/utils/v4l2-compliance/v4l2-test-formats.cpp
> +++ b/utils/v4l2-compliance/v4l2-test-formats.cpp
> @@ -46,7 +46,7 @@ static const __u32 buftype2cap[] = {
>  	V4L2_CAP_VIDEO_OUTPUT_MPLANE | V4L2_CAP_VIDEO_M2M_MPLANE,
>  	V4L2_CAP_SDR_CAPTURE,
>  	V4L2_CAP_SDR_OUTPUT,
> -	V4L2_CAP_META_CAPTURE,
> +	V4L2_CAP_META_CAPTURE | V4L2_CAP_META_OUTPUT,
>  };
>  
>  static int testEnumFrameIntervals(struct node *node, __u32 pixfmt,
> @@ -298,6 +298,7 @@ int testEnumFormats(struct node *node)
>  		case V4L2_BUF_TYPE_SDR_CAPTURE:
>  		case V4L2_BUF_TYPE_SDR_OUTPUT:
>  		case V4L2_BUF_TYPE_META_CAPTURE:
> +		case V4L2_BUF_TYPE_META_OUTPUT:
>  			if (ret && (node->g_caps() & buftype2cap[type]))
>  				return fail("%s cap set, but no %s formats defined\n",
>  						buftype2s(type).c_str(), buftype2s(type).c_str());
> @@ -546,6 +547,7 @@ static int testFormatsType(struct node *node, int ret,  unsigned type, struct v4
>  		fail_on_test(check_0(sdr.reserved, sizeof(sdr.reserved)));
>  		break;
>  	case V4L2_BUF_TYPE_META_CAPTURE:
> +	case V4L2_BUF_TYPE_META_OUTPUT:
>  		if (map.find(meta.dataformat) == map.end())
>  			return fail("dataformat %08x (%s) for buftype %d not reported by ENUM_FMT\n",
>  					meta.dataformat, fcc2s(meta.dataformat).c_str(), type);
> @@ -585,6 +587,7 @@ int testGetFormats(struct node *node)
>  		case V4L2_BUF_TYPE_SDR_CAPTURE:
>  		case V4L2_BUF_TYPE_SDR_OUTPUT:
>  		case V4L2_BUF_TYPE_META_CAPTURE:
> +		case V4L2_BUF_TYPE_META_OUTPUT:
>  			if (ret && (node->g_caps() & buftype2cap[type]))
>  				return fail("%s cap set, but no %s formats defined\n",
>  					buftype2s(type).c_str(), buftype2s(type).c_str());
> @@ -641,6 +644,7 @@ static bool matchFormats(const struct v4l2_format &f1, const struct v4l2_format
>  	case V4L2_BUF_TYPE_SDR_OUTPUT:
>  		return !memcmp(&f1.fmt.sdr, &f2.fmt.sdr, sizeof(f1.fmt.sdr));
>  	case V4L2_BUF_TYPE_META_CAPTURE:
> +	case V4L2_BUF_TYPE_META_OUTPUT:
>  		return !memcmp(&f1.fmt.meta, &f2.fmt.meta, sizeof(f1.fmt.meta));
>  
>  	}
> @@ -718,6 +722,7 @@ int testTryFormats(struct node *node)
>  				pixelformat = fmt.fmt.sdr.pixelformat;
>  				break;
>  			case V4L2_BUF_TYPE_META_CAPTURE:
> +			case V4L2_BUF_TYPE_META_OUTPUT:
>  				pixelformat = fmt.fmt.meta.dataformat;
>  				break;
>  			case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
> @@ -970,6 +975,7 @@ int testSetFormats(struct node *node)
>  
>  			switch (type) {
>  			case V4L2_BUF_TYPE_META_CAPTURE:
> +			case V4L2_BUF_TYPE_META_OUTPUT:
>  				pixelformat = fmt_set.fmt.meta.dataformat;
>  				break;
>  			case V4L2_BUF_TYPE_SDR_CAPTURE:
> 
