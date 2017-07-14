Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:20241 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753472AbdGNKG1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Jul 2017 06:06:27 -0400
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        VMware Graphics <linux-graphics-maintainer@vmware.com>,
        Sinclair Yeh <syeh@vmware.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        David Airlie <airlied@linux.ie>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        dri-devel@lists.freedesktop.org, linux-ide@vger.kernel.org,
        Brian Paul <brianp@vmware.com>, Tejun Heo <tj@kernel.org>,
        akpm@linux-foundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>, linux-media@vger.kernel.org
Subject: Re: [PATCH, RESEND 03/14] drm/vmwgfx: avoid gcc-7 parentheses warning
In-Reply-To: <20170714092540.1217397-4-arnd@arndb.de>
References: <20170714092540.1217397-1-arnd@arndb.de> <20170714092540.1217397-4-arnd@arndb.de>
Date: Fri, 14 Jul 2017 13:11:24 +0300
Message-ID: <87tw2fjpkj.fsf@nikula.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 14 Jul 2017, Arnd Bergmann <arnd@arndb.de> wrote:
> gcc-7 warns about slightly suspicious code in vmw_cmd_invalid:
>
> drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c: In function 'vmw_cmd_invalid':
> drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c:522:23: error: the omitted middle operand in ?: will always be 'true', suggest explicit middle operand [-Werror=parentheses]
>
> The problem is that it is mixing boolean and integer values here.
> I assume that the code actually works correctly, so making it use
> a literal '1' instead of the implied 'true' makes it more readable
> and avoids the warning.
>
> The code has been in this file since the start, but it could
> make sense to backport this patch to stable to make it build cleanly
> with gcc-7.
>
> Fixes: fb1d9738ca05 ("drm/vmwgfx: Add DRM driver for VMware Virtual GPU")
> Reviewed-by: Sinclair Yeh <syeh@vmware.com>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> Originally submitted on Nov 16, but for some reason it never appeared
> upstream. The patch is still needed as of v4.11-rc2

See also the thread starting at
http://lkml.kernel.org/r/CA+55aFwZV-QirBTY8y4y+h796V2CzpWdL=tWB27rJ1u3rojXYQ@mail.gmail.com

BR,
Jani.


> ---
>  drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
> index c7b53d987f06..3f343e55972a 100644
> --- a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
> +++ b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
> @@ -519,7 +519,7 @@ static int vmw_cmd_invalid(struct vmw_private *dev_priv,
>  			   struct vmw_sw_context *sw_context,
>  			   SVGA3dCmdHeader *header)
>  {
> -	return capable(CAP_SYS_ADMIN) ? : -EINVAL;
> +	return capable(CAP_SYS_ADMIN) ? 1 : -EINVAL;
>  }
>  
>  static int vmw_cmd_ok(struct vmw_private *dev_priv,

-- 
Jani Nikula, Intel Open Source Technology Center
