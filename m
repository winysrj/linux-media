Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:51634 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751941AbdHUKPf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Aug 2017 06:15:35 -0400
Subject: Re: [PATCH v2 2/2] docs-rst: media: Document broken frame handling in
 stream stop for CSI-2
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com
References: <1502886018-31488-1-git-send-email-sakari.ailus@linux.intel.com>
 <1502886018-31488-3-git-send-email-sakari.ailus@linux.intel.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <095907b0-51f0-b74f-544c-66e57a97f3a3@xs4all.nl>
Date: Mon, 21 Aug 2017 12:15:31 +0200
MIME-Version: 1.0
In-Reply-To: <1502886018-31488-3-git-send-email-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/16/2017 02:20 PM, Sakari Ailus wrote:
> Some CSI-2 transmitters will finish an ongoing frame whereas others will
> not. Document that receiver drivers should not assume a particular
> behaviour but to work in both cases.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  Documentation/media/kapi/csi2.rst | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/Documentation/media/kapi/csi2.rst b/Documentation/media/kapi/csi2.rst
> index e33fcb9..0560100 100644
> --- a/Documentation/media/kapi/csi2.rst
> +++ b/Documentation/media/kapi/csi2.rst
> @@ -51,6 +51,16 @@ not active. Some transmitters do this automatically but some have to
>  be explicitly programmed to do so, and some are unable to do so
>  altogether due to hardware constraints.
>  
> +Stopping the transmitter
> +^^^^^^^^^^^^^^^^^^^^^^^^
> +
> +A transmitter stops sending the stream of images as a result of
> +calling the ``.s_stream()`` callback. Some transmitters may stop the
> +stream at a frame boundary whereas others stop immediately,
> +effectively leaving the current frame unfinished. The receiver driver
> +should not make assumptions either way, but function properly in both
> +cases.
> +
>  Receiver drivers
>  ----------------
>  
> 

Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks,

	Hans
