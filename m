Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:52205 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916Ab2GPSch (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Jul 2012 14:32:37 -0400
Received: by vcbfk26 with SMTP id fk26so1070533vcb.19
        for <linux-media@vger.kernel.org>; Mon, 16 Jul 2012 11:32:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1342137623-7628-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1342137623-7628-1-git-send-email-laurent.pinchart@ideasonboard.com>
Date: Mon, 16 Jul 2012 13:32:36 -0500
Message-ID: <CAF6AEGsD41WJhcvVmR+Vw6BKrAWM+bMRuCi6OG-DnXdCPDVwBA@mail.gmail.com>
Subject: Re: [PATCH] Documentation: DocBook DRM framework documentation
From: Rob Clark <rob.clark@linaro.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jul 12, 2012 at 7:00 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  Documentation/DocBook/drm.tmpl | 2835 +++++++++++++++++++++++++++++++---------
>  1 files changed, 2226 insertions(+), 609 deletions(-)
>
> Hi everybody,
>
> Here's the DRM kernel framework documentation previously posted to the
> dri-devel mailing list. The documentation has been reworked, converted to
> DocBook and merged with the existing DocBook DRM documentation stub. The
> result doesn't cover the whole DRM API but should hopefully be good enough
> for a start.
>
> I've done my best to follow a natural flow starting at initialization and
> covering the major DRM internal topics. As I'm not a native English speaker
> I'm not totally happy with the result, so if anyone wants to edit the text
> please feel free to do so. Review will as usual be appreciated, and acks will
> be even more welcome (I've been working on this document for longer than I
> feel comfortable with).

btw, thanks for this!

One minor typo below.. with that,

Reviewed-by: Rob Clark <rob.clark@linaro.org>

> diff --git a/Documentation/DocBook/drm.tmpl b/Documentation/DocBook/drm.tmpl
> index 196b8b9..44a2c66 100644
[snip]
> +    <sect2>
> +      <title>Output Polling</title>
> +      <synopsis>void (*output_poll_changed)(struct drm_device *dev);</synopsis>
> +      <para>
> +        This operation notifies the driver that the status of one or more
> +        connectors has changed. Drivers that use the fbdev helper can just call

s/fbdev/fb/

> +        the <function>drm_fb_helper_hotplug_event</function> function to handle
> +        this operation.



BR,
-R
