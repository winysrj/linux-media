Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:57103 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387409AbeKFGOp (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Nov 2018 01:14:45 -0500
Date: Mon, 5 Nov 2018 20:53:11 +0000
From: Sean Young <sean@mess.org>
To: Derek Kelly <user.vdr@gmail.com>
Cc: linux-input@vger.kernel.org, mchehab+samsung@kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH v2] Input: Add missing event codes for common IR remote
 buttons
Message-ID: <20181105205310.cohtos5svy7l5j3q@gofer.mess.org>
References: <20181103145532.9323-1-user.vdr@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181103145532.9323-1-user.vdr@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Nov 03, 2018 at 07:55:32AM -0700, Derek Kelly wrote:
> The following patch adds event codes for common buttons found on various
> provider and universal remote controls. They represent functions not
> covered by existing event codes. Once added, rc_keymaps can be updated
> accordingly where applicable.
> 
> v2 changes:
> Renamed KEY_SYSTEM to KEY_SYSTEM_MENU to avoid conflict with powerpc
> KEY_SYSTEM define.
> 
> Signed-off-by: Derek Kelly <user.vdr@gmail.com>

Reviewed-by: Sean Young <sean@mess.org>

There are many remotes with these buttons, this is a very useful addition.

Thanks,

Sean

> ---
>  include/uapi/linux/input-event-codes.h | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/include/uapi/linux/input-event-codes.h b/include/uapi/linux/input-event-codes.h
> index 53fbae27b280..a15fd3c944d2 100644
> --- a/include/uapi/linux/input-event-codes.h
> +++ b/include/uapi/linux/input-event-codes.h
> @@ -689,6 +689,19 @@
>  #define BTN_TRIGGER_HAPPY39		0x2e6
>  #define BTN_TRIGGER_HAPPY40		0x2e7
>  
> +/* Remote control buttons found across provider & universal remotes */
> +#define KEY_LIVE_TV			0x2e8	/* Jump to live tv viewing */
> +#define KEY_OPTIONS			0x2e9	/* Jump to options */
> +#define KEY_INTERACTIVE			0x2ea	/* Jump to interactive system/menu/item */
> +#define KEY_MIC_INPUT			0x2eb	/* Trigger MIC input/listen mode */
> +#define KEY_SCREEN_INPUT		0x2ec	/* Open on-screen input system */
> +#define KEY_SYSTEM_MENU			0x2ed	/* Open systems menu/display */
> +#define KEY_SERVICES			0x2ee	/* Access services */
> +#define KEY_DISPLAY_FORMAT		0x2ef	/* Cycle display formats */
> +#define KEY_PIP				0x2f0	/* Toggle Picture-in-Picture on/off */
> +#define KEY_PIP_SWAP			0x2f1	/* Swap contents between main view and PIP window */
> +#define KEY_PIP_POSITION		0x2f2	/* Cycle PIP window position */
> +
>  /* We avoid low common keys in module aliases so they don't get huge. */
>  #define KEY_MIN_INTERESTING	KEY_MUTE
>  #define KEY_MAX			0x2ff
> -- 
> 2.19.1
