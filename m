Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:59220 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932431AbdCGJMX (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Mar 2017 04:12:23 -0500
Subject: Re: [Patch v2 07/11] Documentation: v4l: Documentation for HEVC v4l2
 definition
To: Smitha T Murthy <smitha.t@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: pankaj.dubey@samsung.com, kamil@wypas.org, krzk@kernel.org,
        jtp.park@samsung.com, kyungmin.park@samsung.com,
        s.nawrocki@samsung.com, mchehab@kernel.org,
        m.szyprowski@samsung.com
From: Andrzej Hajda <a.hajda@samsung.com>
Message-id: <bcc5e437-917a-3593-3047-67fc06dfde9c@samsung.com>
Date: Tue, 07 Mar 2017 09:39:55 +0100
MIME-version: 1.0
In-reply-to: <1488532036-13044-8-git-send-email-smitha.t@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
References: <1488532036-13044-1-git-send-email-smitha.t@samsung.com>
 <CGME20170303090459epcas5p4498e5a633739ef3829ba1fccd79f6821@epcas5p4.samsung.com>
 <1488532036-13044-8-git-send-email-smitha.t@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03.03.2017 10:07, Smitha T Murthy wrote:
> Add V4L2 definition for HEVC compressed format
> 
> Signed-off-by: Smitha T Murthy <smitha.t@samsung.com>

Reviewed-by: Andrzej Hajda <a.hajda@samsung.com>



> ---
>  Documentation/media/uapi/v4l/pixfmt-013.rst |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/media/uapi/v4l/pixfmt-013.rst b/Documentation/media/uapi/v4l/pixfmt-013.rst
> index 728d7ed..ff4cac2 100644
> --- a/Documentation/media/uapi/v4l/pixfmt-013.rst
> +++ b/Documentation/media/uapi/v4l/pixfmt-013.rst
> @@ -90,3 +90,8 @@ Compressed Formats
>        - ``V4L2_PIX_FMT_VP9``
>        - 'VP90'
>        - VP9 video elementary stream.
> +    * .. _V4L2-PIX-FMT-HEVC:
> +
> +      - ``V4L2_PIX_FMT_HEVC``
> +      - 'HEVC'
> +      - HEVC video elementary stream.
> 
