Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f53.google.com ([209.85.215.53]:36053 "EHLO
        mail-lf0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751286AbdH2Mwi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Aug 2017 08:52:38 -0400
Received: by mail-lf0-f53.google.com with SMTP id z12so12938281lfd.3
        for <linux-media@vger.kernel.org>; Tue, 29 Aug 2017 05:52:37 -0700 (PDT)
Date: Tue, 29 Aug 2017 14:52:35 +0200
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, robh@kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, devicetree@vger.kernel.org
Subject: Re: [PATCH v5 2/5] v4l: async: Add V4L2 async documentation to the
 documentation build
Message-ID: <20170829125235.GF12099@bigcity.dyn.berto.se>
References: <20170829110313.19538-1-sakari.ailus@linux.intel.com>
 <20170829110313.19538-3-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170829110313.19538-3-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for your patch.

On 2017-08-29 14:03:10 +0300, Sakari Ailus wrote:
> The V4L2 async wasn't part of the documentation build. Fix this.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

> ---
>  Documentation/media/kapi/v4l2-async.rst | 3 +++
>  Documentation/media/kapi/v4l2-core.rst  | 1 +
>  2 files changed, 4 insertions(+)
>  create mode 100644 Documentation/media/kapi/v4l2-async.rst
> 
> diff --git a/Documentation/media/kapi/v4l2-async.rst b/Documentation/media/kapi/v4l2-async.rst
> new file mode 100644
> index 000000000000..523ff9eb09a0
> --- /dev/null
> +++ b/Documentation/media/kapi/v4l2-async.rst
> @@ -0,0 +1,3 @@
> +V4L2 async kAPI
> +^^^^^^^^^^^^^^^
> +.. kernel-doc:: include/media/v4l2-async.h
> diff --git a/Documentation/media/kapi/v4l2-core.rst b/Documentation/media/kapi/v4l2-core.rst
> index c7434f38fd9c..5cf292037a48 100644
> --- a/Documentation/media/kapi/v4l2-core.rst
> +++ b/Documentation/media/kapi/v4l2-core.rst
> @@ -19,6 +19,7 @@ Video4Linux devices
>      v4l2-mc
>      v4l2-mediabus
>      v4l2-mem2mem
> +    v4l2-async
>      v4l2-fwnode
>      v4l2-rect
>      v4l2-tuner
> -- 
> 2.11.0
> 

-- 
Regards,
Niklas Söderlund
