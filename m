Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:40051 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935733AbdEZIga (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 26 May 2017 04:36:30 -0400
From: Jani Nikula <jani.nikula@intel.com>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        Clint Taylor <clinton.a.taylor@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>
Subject: Re: [RFC PATCH 5/7] drm/cec: Add CEC over Aux register definitions
In-Reply-To: <20170525150626.29748-6-hverkuil@xs4all.nl>
References: <20170525150626.29748-1-hverkuil@xs4all.nl> <20170525150626.29748-6-hverkuil@xs4all.nl>
Date: Fri, 26 May 2017 11:39:53 +0300
Message-ID: <87wp94m2p2.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 25 May 2017, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> From: Clint Taylor <clinton.a.taylor@intel.com>
>
> Adding DPCD register definitions from the DP 1.3 specification for CEC
> over AUX support.
>
> V2: Add DP_ prefix to all defines.
> V3: missed prefixes from the ESI1 defines
>
> Cc: Jani Nikula <jani.nikula@linux.intel.com>
>
> Reviewed-by: Jani Nikula <jani.nikula@intel.com>
> Signed-off-by: Clint Taylor <clinton.a.taylor@intel.com>
> Signed-off-by: Jani Nikula <jani.nikula@intel.com>
> Link: http://patchwork.freedesktop.org/patch/msgid/1492703263-11494-1-git-send-email-clinton.a.taylor@intel.com

This one's already in drm-next as

commit d753e41d475421543eaaea5f0feadba827f5fa01
Author: Clint Taylor <clinton.a.taylor@intel.com>
Date:   Thu Apr 20 08:47:43 2017 -0700

    drm/cec: Add CEC over Aux register definitions

BR,
Jani.


> ---
>  include/drm/drm_dp_helper.h | 59 +++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 59 insertions(+)
>
> diff --git a/include/drm/drm_dp_helper.h b/include/drm/drm_dp_helper.h
> index c0bd0d7651a9..3f4ad709534e 100644
> --- a/include/drm/drm_dp_helper.h
> +++ b/include/drm/drm_dp_helper.h
> @@ -603,6 +603,9 @@
>  #define DP_DEVICE_SERVICE_IRQ_VECTOR_ESI0   0x2003   /* 1.2 */
>  
>  #define DP_DEVICE_SERVICE_IRQ_VECTOR_ESI1   0x2004   /* 1.2 */
> +# define DP_RX_GTC_MSTR_REQ_STATUS_CHANGE    (1 << 0)
> +# define DP_LOCK_ACQUISITION_REQUEST         (1 << 1)
> +# define DP_CEC_IRQ                          (1 << 2)
>  
>  #define DP_LINK_SERVICE_IRQ_VECTOR_ESI0     0x2005   /* 1.2 */
>  
> @@ -636,6 +639,62 @@
>  # define DP_VSC_EXT_CEA_SDP_SUPPORTED			(1 << 6)  /* DP 1.4 */
>  # define DP_VSC_EXT_CEA_SDP_CHAINING_SUPPORTED		(1 << 7)  /* DP 1.4 */
>  
> +/* HDMI CEC tunneling over AUX DP 1.3 section 5.3.3.3.1 DPCD 1.4+ */
> +#define DP_CEC_TUNNELING_CAPABILITY            0x3000
> +# define DP_CEC_TUNNELING_CAPABLE               (1 << 0)
> +# define DP_CEC_SNOOPING_CAPABLE                (1 << 1)
> +# define DP_CEC_MULTIPLE_LA_CAPABLE             (1 << 2)
> +
> +#define DP_CEC_TUNNELING_CONTROL               0x3001
> +# define DP_CEC_TUNNELING_ENABLE                (1 << 0)
> +# define DP_CEC_SNOOPING_ENABLE                 (1 << 1)
> +
> +#define DP_CEC_RX_MESSAGE_INFO                 0x3002
> +# define DP_CEC_RX_MESSAGE_LEN_MASK             (0xf << 0)
> +# define DP_CEC_RX_MESSAGE_LEN_SHIFT            0
> +# define DP_CEC_RX_MESSAGE_HPD_STATE            (1 << 4)
> +# define DP_CEC_RX_MESSAGE_HPD_LOST             (1 << 5)
> +# define DP_CEC_RX_MESSAGE_ACKED                (1 << 6)
> +# define DP_CEC_RX_MESSAGE_ENDED                (1 << 7)
> +
> +#define DP_CEC_TX_MESSAGE_INFO                 0x3003
> +# define DP_CEC_TX_MESSAGE_LEN_MASK             (0xf << 0)
> +# define DP_CEC_TX_MESSAGE_LEN_SHIFT            0
> +# define DP_CEC_TX_RETRY_COUNT_MASK             (0x7 << 4)
> +# define DP_CEC_TX_RETRY_COUNT_SHIFT            4
> +# define DP_CEC_TX_MESSAGE_SEND                 (1 << 7)
> +
> +#define DP_CEC_TUNNELING_IRQ_FLAGS             0x3004
> +# define DP_CEC_RX_MESSAGE_INFO_VALID           (1 << 0)
> +# define DP_CEC_RX_MESSAGE_OVERFLOW             (1 << 1)
> +# define DP_CEC_TX_MESSAGE_SENT                 (1 << 4)
> +# define DP_CEC_TX_LINE_ERROR                   (1 << 5)
> +# define DP_CEC_TX_ADDRESS_NACK_ERROR           (1 << 6)
> +# define DP_CEC_TX_DATA_NACK_ERROR              (1 << 7)
> +
> +#define DP_CEC_LOGICAL_ADDRESS_MASK            0x300E /* 0x300F word */
> +# define DP_CEC_LOGICAL_ADDRESS_0               (1 << 0)
> +# define DP_CEC_LOGICAL_ADDRESS_1               (1 << 1)
> +# define DP_CEC_LOGICAL_ADDRESS_2               (1 << 2)
> +# define DP_CEC_LOGICAL_ADDRESS_3               (1 << 3)
> +# define DP_CEC_LOGICAL_ADDRESS_4               (1 << 4)
> +# define DP_CEC_LOGICAL_ADDRESS_5               (1 << 5)
> +# define DP_CEC_LOGICAL_ADDRESS_6               (1 << 6)
> +# define DP_CEC_LOGICAL_ADDRESS_7               (1 << 7)
> +#define DP_CEC_LOGICAL_ADDRESS_MASK_2          0x300F /* 0x300E word */
> +# define DP_CEC_LOGICAL_ADDRESS_8               (1 << 0)
> +# define DP_CEC_LOGICAL_ADDRESS_9               (1 << 1)
> +# define DP_CEC_LOGICAL_ADDRESS_10              (1 << 2)
> +# define DP_CEC_LOGICAL_ADDRESS_11              (1 << 3)
> +# define DP_CEC_LOGICAL_ADDRESS_12              (1 << 4)
> +# define DP_CEC_LOGICAL_ADDRESS_13              (1 << 5)
> +# define DP_CEC_LOGICAL_ADDRESS_14              (1 << 6)
> +# define DP_CEC_LOGICAL_ADDRESS_15              (1 << 7)
> +
> +#define DP_CEC_RX_MESSAGE_BUFFER               0x3010
> +#define DP_CEC_TX_MESSAGE_BUFFER               0x3020
> +#define DP_CEC_MESSAGE_BUFFER_LENGTH             0x10
> +
>  /* DP 1.2 Sideband message defines */
>  /* peer device type - DP 1.2a Table 2-92 */
>  #define DP_PEER_DEVICE_NONE		0x0

-- 
Jani Nikula, Intel Open Source Technology Center
