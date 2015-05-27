Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:35548 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307AbbE0NNN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 May 2015 09:13:13 -0400
Received: by wgme6 with SMTP id e6so9159989wgm.2
        for <linux-media@vger.kernel.org>; Wed, 27 May 2015 06:13:11 -0700 (PDT)
Date: Wed, 27 May 2015 15:15:39 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	kvm-ppc@vger.kernel.org, dri-devel@lists.freedesktop.org,
	sparclinux@vger.kernel.org, linux-metag@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] treewide: Fix typo compatability -> compatibility
Message-ID: <20150527131539.GQ8341@phenom.ffwll.local>
References: <1432728342-32748-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1432728342-32748-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, May 27, 2015 at 03:05:42PM +0300, Laurent Pinchart wrote:
> Even though 'compatability' has a dedicated entry in the Wiktionary,
> it's listed as 'Mispelling of compatibility'. Fix it.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  arch/metag/include/asm/elf.h             | 2 +-
>  arch/powerpc/kvm/book3s.c                | 2 +-
>  arch/sparc/include/uapi/asm/pstate.h     | 2 +-
>  drivers/gpu/drm/drm_atomic_helper.c      | 4 ++--
>  drivers/media/dvb-frontends/au8522_dig.c | 2 +-
>  drivers/net/wireless/ipw2x00/ipw2100.h   | 2 +-
>  6 files changed, 7 insertions(+), 7 deletions(-)
> 
> I can split this into one patch per subsystem, but that seems a bit overkill.
> Can someone take it ?

Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch> for the atomic_helper.c
part.
-Daniel

> 
> diff --git a/arch/metag/include/asm/elf.h b/arch/metag/include/asm/elf.h
> index d2baf6961794..87b0cf1e0acb 100644
> --- a/arch/metag/include/asm/elf.h
> +++ b/arch/metag/include/asm/elf.h
> @@ -11,7 +11,7 @@
>  #define R_METAG_RELBRANCH                4
>  #define R_METAG_GETSETOFF                5
>  
> -/* Backward compatability */
> +/* Backward compatibility */
>  #define R_METAG_REG32OP1                 6
>  #define R_METAG_REG32OP2                 7
>  #define R_METAG_REG32OP3                 8
> diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
> index 453a8a47a467..cb14dd78a2e7 100644
> --- a/arch/powerpc/kvm/book3s.c
> +++ b/arch/powerpc/kvm/book3s.c
> @@ -901,7 +901,7 @@ int kvmppc_core_check_processor_compat(void)
>  {
>  	/*
>  	 * We always return 0 for book3s. We check
> -	 * for compatability while loading the HV
> +	 * for compatibility while loading the HV
>  	 * or PR module
>  	 */
>  	return 0;
> diff --git a/arch/sparc/include/uapi/asm/pstate.h b/arch/sparc/include/uapi/asm/pstate.h
> index 4b6b998afd99..cf832e14aa05 100644
> --- a/arch/sparc/include/uapi/asm/pstate.h
> +++ b/arch/sparc/include/uapi/asm/pstate.h
> @@ -88,7 +88,7 @@
>  #define VERS_MAXTL	_AC(0x000000000000ff00,UL) /* Max Trap Level.	*/
>  #define VERS_MAXWIN	_AC(0x000000000000001f,UL) /* Max RegWindow Idx.*/
>  
> -/* Compatability Feature Register (%asr26), SPARC-T4 and later  */
> +/* Compatibility Feature Register (%asr26), SPARC-T4 and later  */
>  #define CFR_AES		_AC(0x0000000000000001,UL) /* Supports AES opcodes     */
>  #define CFR_DES		_AC(0x0000000000000002,UL) /* Supports DES opcodes     */
>  #define CFR_KASUMI	_AC(0x0000000000000004,UL) /* Supports KASUMI opcodes  */
> diff --git a/drivers/gpu/drm/drm_atomic_helper.c b/drivers/gpu/drm/drm_atomic_helper.c
> index b82ef6262469..12c5b79b0e8f 100644
> --- a/drivers/gpu/drm/drm_atomic_helper.c
> +++ b/drivers/gpu/drm/drm_atomic_helper.c
> @@ -751,7 +751,7 @@ crtc_set_mode(struct drm_device *dev, struct drm_atomic_state *old_state)
>   * This function shuts down all the outputs that need to be shut down and
>   * prepares them (if required) with the new mode.
>   *
> - * For compatability with legacy crtc helpers this should be called before
> + * For compatibility with legacy crtc helpers this should be called before
>   * drm_atomic_helper_commit_planes(), which is what the default commit function
>   * does. But drivers with different needs can group the modeset commits together
>   * and do the plane commits at the end. This is useful for drivers doing runtime
> @@ -776,7 +776,7 @@ EXPORT_SYMBOL(drm_atomic_helper_commit_modeset_disables);
>   * This function enables all the outputs with the new configuration which had to
>   * be turned off for the update.
>   *
> - * For compatability with legacy crtc helpers this should be called after
> + * For compatibility with legacy crtc helpers this should be called after
>   * drm_atomic_helper_commit_planes(), which is what the default commit function
>   * does. But drivers with different needs can group the modeset commits together
>   * and do the plane commits at the end. This is useful for drivers doing runtime
> diff --git a/drivers/media/dvb-frontends/au8522_dig.c b/drivers/media/dvb-frontends/au8522_dig.c
> index 5d06c99b0e97..edadcc7eea6c 100644
> --- a/drivers/media/dvb-frontends/au8522_dig.c
> +++ b/drivers/media/dvb-frontends/au8522_dig.c
> @@ -922,7 +922,7 @@ module_param(debug, int, 0644);
>  MODULE_PARM_DESC(debug, "Enable verbose debug messages");
>  
>  module_param(zv_mode, int, 0644);
> -MODULE_PARM_DESC(zv_mode, "Turn on/off ZeeVee modulator compatability mode (default:on).\n"
> +MODULE_PARM_DESC(zv_mode, "Turn on/off ZeeVee modulator compatibility mode (default:on).\n"
>  	"\t\ton - modified AU8522 QAM256 initialization.\n"
>  	"\t\tProvides faster lock when using ZeeVee modulator based sources");
>  
> diff --git a/drivers/net/wireless/ipw2x00/ipw2100.h b/drivers/net/wireless/ipw2x00/ipw2100.h
> index c6d78790cb0d..193947865efd 100644
> --- a/drivers/net/wireless/ipw2x00/ipw2100.h
> +++ b/drivers/net/wireless/ipw2x00/ipw2100.h
> @@ -746,7 +746,7 @@ struct ipw2100_priv {
>  #define IPW_REG_GPIO			IPW_REG_DOMAIN_0_OFFSET + 0x0030
>  #define IPW_REG_FW_TYPE                 IPW_REG_DOMAIN_1_OFFSET + 0x0188
>  #define IPW_REG_FW_VERSION 		IPW_REG_DOMAIN_1_OFFSET + 0x018C
> -#define IPW_REG_FW_COMPATABILITY_VERSION IPW_REG_DOMAIN_1_OFFSET + 0x0190
> +#define IPW_REG_FW_COMPATIBILITY_VERSION IPW_REG_DOMAIN_1_OFFSET + 0x0190
>  
>  #define IPW_REG_INDIRECT_ADDR_MASK	0x00FFFFFC
>  
> -- 
> Regards,
> 
> Laurent Pinchart
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
