Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:42541 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733149AbeKMXCR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Nov 2018 18:02:17 -0500
Message-ID: <766230a305f54a37e9d881779a0d81ec439f8bd8.camel@hadess.net>
Subject: Re: [PATCH v2] Input: Add missing event codes for common IR remote
 buttons
From: Bastien Nocera <hadess@hadess.net>
To: Derek Kelly <user.vdr@gmail.com>, linux-input@vger.kernel.org
Cc: sean@mess.org, mchehab+samsung@kernel.org,
        linux-media@vger.kernel.org
Date: Tue, 13 Nov 2018 14:04:10 +0100
In-Reply-To: <20181103145532.9323-1-user.vdr@gmail.com>
References: <20181103145532.9323-1-user.vdr@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2018-11-03 at 07:55 -0700, Derek Kelly wrote:
> The following patch adds event codes for common buttons found on
> various
> provider and universal remote controls. They represent functions not
> covered by existing event codes. Once added, rc_keymaps can be
> updated
> accordingly where applicable.

Would be great to have more than "those are used", such as knowing how
they are labeled, both with text and/or icons, and an explanation as to
why a particular existing key isn't usable.

> v2 changes:
> Renamed KEY_SYSTEM to KEY_SYSTEM_MENU to avoid conflict with powerpc
> KEY_SYSTEM define.
> 
> Signed-off-by: Derek Kelly <user.vdr@gmail.com>
> ---
>  include/uapi/linux/input-event-codes.h | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/include/uapi/linux/input-event-codes.h
> b/include/uapi/linux/input-event-codes.h
> index 53fbae27b280..a15fd3c944d2 100644
> --- a/include/uapi/linux/input-event-codes.h
> +++ b/include/uapi/linux/input-event-codes.h
> @@ -689,6 +689,19 @@
>  #define BTN_TRIGGER_HAPPY39		0x2e6
>  #define BTN_TRIGGER_HAPPY40		0x2e7
>  
> +/* Remote control buttons found across provider & universal remotes */
> +#define KEY_LIVE_TV			0x2e8	/* Jump to live tv viewing */

KEY_TV?

> +#define KEY_OPTIONS			0x2e9	/* Jump to options */

KEY_OPTION?

> +#define KEY_INTERACTIVE			0x2ea	/* Jump to interactive system/menu/item */
> +#define KEY_MIC_INPUT			0x2eb	/* Trigger MIC input/listen mode */

KEY_MICMUTE?

> +#define KEY_SCREEN_INPUT		0x2ec	/* Open on-screen input system */

KEY_SWITCHVIDEOMODE?

> +#define KEY_SYSTEM_MENU			0x2ed	/* Open systems menu/display */

KEY_MENU?

> +#define KEY_SERVICES			0x2ee	/* Access services */
> +#define KEY_DISPLAY_FORMAT		0x2ef	/* Cycle display formats */

KEY_CONTEXT_MENU?

> +#define KEY_PIP				0x2f0	/* Toggle Picture-in-Picture on/off */
> +#define KEY_PIP_SWAP			0x2f1	/* Swap contents between main view and PIP window */
> +#define KEY_PIP_POSITION		0x2f2	/* Cycle PIP window position */
> +
>  /* We avoid low common keys in module aliases so they don't get huge. */
>  #define KEY_MIN_INTERESTING	KEY_MUTE
>  #define KEY_MAX			0x2ff
