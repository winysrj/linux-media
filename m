Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:53131 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753991AbdJILbt (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 9 Oct 2017 07:31:49 -0400
Date: Mon, 9 Oct 2017 08:31:34 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        maxime.ripard@free-electrons.com, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, pavel@ucw.cz, sre@kernel.org
Subject: Re: [PATCH v15 07/32] v4l: async: Add V4L2 async documentation to
 the documentation build
Message-ID: <20171009083134.4a751b0d@vento.lan>
In-Reply-To: <20171004215051.13385-8-sakari.ailus@linux.intel.com>
References: <20171004215051.13385-1-sakari.ailus@linux.intel.com>
        <20171004215051.13385-8-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu,  5 Oct 2017 00:50:26 +0300
Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:

> The V4L2 async wasn't part of the documentation build. Fix this.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Reviewed-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

It doesn't make sense to keep rebasing this patch or to delay
merging it: just add it at the next git pull request you send me,
as this is actually independent of the rest :-)


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



Thanks,
Mauro
