Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42330 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727689AbeHNLQf (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Aug 2018 07:16:35 -0400
Subject: Re: [Xen-devel][PATCH 1/1] cameraif: add ABI for para-virtual camera
To: Oleksandr Andrushchenko <andr2000@gmail.com>,
        xen-devel@lists.xenproject.org, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, mchehab@kernel.org,
        linux-media@vger.kernel.org, sakari.ailus@linux.intel.com,
        koji.matsuoka.xm@renesas.com
Cc: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
References: <20180731093142.3828-1-andr2000@gmail.com>
 <20180731093142.3828-2-andr2000@gmail.com>
From: Juergen Gross <jgross@suse.com>
Message-ID: <99cd131d-85ae-bbfb-61ef-fdc0401727f6@suse.com>
Date: Tue, 14 Aug 2018 10:30:23 +0200
MIME-Version: 1.0
In-Reply-To: <20180731093142.3828-2-andr2000@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: de-DE
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 31/07/18 11:31, Oleksandr Andrushchenko wrote:
> From: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
> 
> This is the ABI for the two halves of a para-virtualized
> camera driver which extends Xen's reach multimedia capabilities even
> farther enabling it for video conferencing, In-Vehicle Infotainment,
> high definition maps etc.
> 
> The initial goal is to support most needed functionality with the
> final idea to make it possible to extend the protocol if need be:
> 
> 1. Provide means for base virtual device configuration:
>  - pixel formats
>  - resolutions
>  - frame rates
> 2. Support basic camera controls:
>  - contrast
>  - brightness
>  - hue
>  - saturation
> 3. Support streaming control
> 4. Support zero-copying use-cases
> 
> Signed-off-by: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>

Some style issues below...

> ---
>  xen/include/public/io/cameraif.h | 981 +++++++++++++++++++++++++++++++
>  1 file changed, 981 insertions(+)
>  create mode 100644 xen/include/public/io/cameraif.h
> 
> diff --git a/xen/include/public/io/cameraif.h b/xen/include/public/io/cameraif.h
> new file mode 100644
> index 000000000000..bdc6a1262fcf
> --- /dev/null
> +++ b/xen/include/public/io/cameraif.h

> +struct xencamera_config {
> +    uint32_t pixel_format;
> +    uint32_t width;
> +    uint32_t height;
> +    uint32_t frame_rate_nom;
> +    uint32_t frame_rate_denom;
> +    uint8_t num_bufs;

Add explicit padding?

> +};

> +struct xencamera_req {
> +    uint16_t id;
> +    uint8_t operation;
> +    uint8_t reserved[5];
> +    union {
> +        struct xencamera_config config;
> +        struct xencamera_buf_create_req buf_create;
> +	struct xencamera_buf_destroy_req buf_destroy;
> +	struct xencamera_set_ctrl_req set_ctrl;

No tabs, please.

> +        uint8_t reserved[56];
> +    } req;
> +};
> +
> +struct xencamera_resp {
> +    uint16_t id;
> +    uint8_t operation;
> +    uint8_t reserved;
> +    int32_t status;
> +    union {
> +        struct xencamera_config config;
> +        struct xencamera_buf_details_resp buf_details;
> +	struct xencamera_get_ctrl_details_resp ctrl_details;

Tab again.

> +        uint8_t reserved1[56];
> +    } resp;
> +};


Juergen
