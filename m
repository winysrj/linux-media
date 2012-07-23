Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2.matrix-vision.com ([85.214.244.251]:38259 "EHLO
	mail2.matrix-vision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753700Ab2GWPJ4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jul 2012 11:09:56 -0400
Message-ID: <500D69EB.6000008@matrix-vision.de>
Date: Mon, 23 Jul 2012 17:12:43 +0200
From: Michael Jones <michael.jones@matrix-vision.de>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] Documentation: DocBook DRM framework documentation
References: <1342137623-7628-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1342137623-7628-1-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

At a quick glance I noticed a couple of things:

On 07/13/2012 02:00 AM, Laurent Pinchart wrote:

[snip]

> +    <para>
> +      The <structname>drm_driver</structname> structure contains static
> +      information that describe the driver and features it supports, and

s/describe/describes/

> +      pointers to methods that the DRM core will call to implement the DRM API.
> +      We will first go through the <structname>drm_driver</structname> static
> +      information fields, and will then describe individual operations in
> +      details as they get used in later sections.
>       </para>
> -
>       <sect2>
> -      <title>Driver private &amp; performance counters</title>
> -      <para>
> -	The driver private hangs off the main drm_device structure and
> -	can be used for tracking various device-specific bits of
> -	information, like register offsets, command buffer status,
> -	register state for suspend/resume, etc.  At load time, a
> -	driver may simply allocate one and set drm_device.dev_priv
> -	appropriately; it should be freed and drm_device.dev_priv set
> -	to NULL when the driver is unloaded.
> -      </para>
> +      <title>Driver Information</title>
> +      <sect3>
> +        <title>Driver Features</title>
> +        <para>
> +          Drivers inform the DRM core about their requirements and supported
> +          features by setting appropriate flags in the
> +          <structfield>driver_features</structfield> field. Since those flags
> +          influence the DRM core behaviour since registration time, most of them

Elsewhere you use the American spelling "behavior".

[snip]

> +      <sect3>
> +        <title>Major, Minor and Patchlevel</title>
> +        <synopsis>int major;
> +  int minor;
> +  int patchlevel;</synopsis>

In my browser, "int minor" and "int patchlevel" look indented, whereas 
"int major" does not.  Looks like they _should_ be indented identically. 
Don't know how you fix this or if you even see the same problem.

> +        <para>
> +          The DRM core identifies driver versions by a major, minor and patch
> +          level triplet. The information is printed to the kernel log at
> +          initialization time and passed to userspace through the
> +          DRM_IOCTL_VERSION ioctl.
> +        </para>
> +        <para>
> +          The major and minor numbers are also used to verify the requested driver
> +          API version passed to DRM_IOCTL_SET_VERSION. When the driver API changes
> +          between minor versions, applications can call DRM_IOCTL_SET_VERSION to
> +          select a specific version of the API. If the requested major isn't equal
> +          to the driver major, or the requested minor is larger than the driver
> +          minor, the DRM_IOCTL_SET_VERSION call will return an error. Otherwise
> +          the driver's set_version() method will be called with the requested
> +          version.
> +        </para>
> +      </sect3>
> +      <sect3>
> +        <title>Name, Description and Date</title>
> +        <synopsis>char *name;
> +  char *desc;
> +  char *date;</synopsis>

Same indentation issue here.

[snip]

> +          <para>
> +            The <methodname>mode_fixup</methodname> operation should reject the
> +            mode if it can't reasonably use it. The definition of "reasonable"
> +            is currently fuzzy in this context. One possible behaviour would be

maybe s/behaviour/behavior/ again



MATRIX VISION GmbH, Talstrasse 16, DE-71570 Oppenweiler
Registergericht: Amtsgericht Stuttgart, HRB 271090
Geschaeftsfuehrer: Gerhard Thullner, Werner Armingeon, Uwe Furtner, Erhard Meier
