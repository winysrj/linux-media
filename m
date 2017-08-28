Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:36623 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751200AbdH1KFJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Aug 2017 06:05:09 -0400
Subject: Re: [PATCH v4 7/7] media: open.rst: add a notice about subdev-API on
 vdev-centric
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
References: <cover.1503747774.git.mchehab@s-opensource.com>
 <a77ff374ebde22ea20e1cec7c94026db817ed89d.1503747774.git.mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Hans Verkuil <hans.verkuil@cisco.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <ac21c30e-1d41-881d-d22e-2244a3dcde2e@xs4all.nl>
Date: Mon, 28 Aug 2017 12:05:06 +0200
MIME-Version: 1.0
In-Reply-To: <a77ff374ebde22ea20e1cec7c94026db817ed89d.1503747774.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 26/08/17 13:53, Mauro Carvalho Chehab wrote:
> The documentation doesn't mention if vdev-centric hardware
> control would have subdev API or not.
> 
> Add a notice about that, reflecting the current status, where
> three drivers use it, in order to support some subdev-specific
> controls.

I posted a patch removing v4l-subdevX support for cobalt. It's only used
within Cisco, so this is safe to do and won't break any userspace support.

atmel-isc is another driver that creates subdev nodes. Like cobalt, this
is unnecessary. There are no sensors that use private controls.

This driver is not referenced anywhere (dts or board file) in the kernel.
It is highly unlikely anyone would use v4l-subdevX nodes when there is no
need to do so. My suggestion is to add a kernel option for this driver
to enable v4l-subdevX support, but set it to 'default n'. Perhaps with
a note in the Kconfig description and a message in the kernel log that
this will be removed in the future.

The final driver is rcar_drif that uses this to set the "I2S Enable"
private control of the max2175 driver.

I remember that there was a long discussion over this control. I still
think that there is no need to mark this private. This is a recent
driver addition and we can get away with changing this, possibly using
a Kconfig option as well as discussed for the atmel-isc driver.

This is actually the only driver using a private control. I am of the
opinion that private controls were a mistake. I think it is the
bridge driver that has to decide whether or not to make subdev controls
available through a video node.

So in summary:

- drop is_private controls
- apply the cobalt patch (safe to do)
- add a Kconfig option for atmel-isc & rcar_drif that has to be explicitly
  enabled to support subdev nodes, and add logging that this is deprecated.
- by 4.17 or so remove this altogether.

If we agree to this, then this patch can be dropped.

Regards,

	Hans

> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  Documentation/media/uapi/v4l/open.rst | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/Documentation/media/uapi/v4l/open.rst b/Documentation/media/uapi/v4l/open.rst
> index d0930fc170f0..48f628bbabc7 100644
> --- a/Documentation/media/uapi/v4l/open.rst
> +++ b/Documentation/media/uapi/v4l/open.rst
> @@ -46,6 +46,13 @@ the periferal can be used. For such devices, the sub-devices' configuration
>  can be controlled via the :ref:`sub-device API <subdev>`, which creates one
>  device node per sub-device.
>  
> +.. note::
> +
> +   A **vdev-centric** may also optionally expose V4L2 sub-devices via
> +   :ref:`sub-device API <subdev>`. In that case, it has to implement
> +   the :ref:`media controller API <media_controller>` as well.
> +
> +
>  .. attention::
>  
>     Devices that require **mc-centric** hardware peripheral control should
> 
