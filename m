Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:50194 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752005AbdIAKqH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 1 Sep 2017 06:46:07 -0400
Subject: Re: [PATCH v6 2/5] v4l: async: Add V4L2 async documentation to the
 documentation build
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
References: <20170830114946.17743-1-sakari.ailus@linux.intel.com>
 <20170830114946.17743-3-sakari.ailus@linux.intel.com>
Cc: niklas.soderlund@ragnatech.se, robh@kernel.org,
        laurent.pinchart@ideasonboard.com, devicetree@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <19202cd6-c2fd-36c9-ae04-7cdee541c5f7@xs4all.nl>
Date: Fri, 1 Sep 2017 12:46:05 +0200
MIME-Version: 1.0
In-Reply-To: <20170830114946.17743-3-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 30/08/17 13:49, Sakari Ailus wrote:
> The V4L2 async wasn't part of the documentation build. Fix this.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans


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
> 
