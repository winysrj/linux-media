Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54898 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753027AbdI1MuL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Sep 2017 08:50:11 -0400
Date: Thu, 28 Sep 2017 15:50:08 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v2 00/17] V4L cleanups and documentation improvements
Message-ID: <20170928125008.f6h4rfirqgjwhjd5@valkosipuli.retiisi.org.uk>
References: <cover.1506548682.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1506548682.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Wed, Sep 27, 2017 at 06:46:43PM -0300, Mauro Carvalho Chehab wrote:
> This patch series is meant to improve V4L documentation. It touches
> some files at the tree doing some cleanup, in order to simplify
> the source code.
> 
> Mauro Carvalho Chehab (17):
>   media: tuner-types: add kernel-doc markups for struct tunertype
>   media: v4l2-common: get rid of v4l2_routing dead struct
>   media: v4l2-common: get rid of struct v4l2_discrete_probe
>   media: v4l2-common.h: document ancillary functions
>   media: v4l2-device.h: document ancillary macros
>   media: v4l2-dv-timings.h: convert comment into kernel-doc markup
>   media: v4l2-event.rst: improve events description
>   media: v4l2-ioctl.h: convert debug macros into enum and document
>   media: cec-pin.h: convert comments for cec_pin_state into kernel-doc
>   media: rc-core.rst: add an introduction for RC core
>   media: rc-core.h: minor adjustments at rc_driver_type doc
>   media: v4l2-fwnode.h: better describe bus union at fwnode endpoint
>     struct
>   media: v4l2-async: simplify v4l2_async_subdev structure
>   media: v4l2-async: better describe match union at async match struct
>   media: v4l2-ctrls: document nested members of structs
>   media: videobuf2-core: improve kernel-doc markups
>   media: media-entity.h: add kernel-doc markups for nested structs

For patches apart form 7 and 13 (see my comments to them):

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
