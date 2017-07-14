Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.13]:54810 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753272AbdGNJ2D (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Jul 2017 05:28:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org,
        VMware Graphics <linux-graphics-maintainer@vmware.com>,
        Sinclair Yeh <syeh@vmware.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        David Airlie <airlied@linux.ie>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>, Guenter Roeck <linux@roeck-us.net>,
        linux-ide@vger.kernel.org, linux-media@vger.kernel.org,
        akpm@linux-foundation.org, dri-devel@lists.freedesktop.org,
        Arnd Bergmann <arnd@arndb.de>, Brian Paul <brianp@vmware.com>
Subject: [PATCH, RESEND 03/14] drm/vmwgfx: avoid gcc-7 parentheses warning
Date: Fri, 14 Jul 2017 11:25:15 +0200
Message-Id: <20170714092540.1217397-4-arnd@arndb.de>
In-Reply-To: <20170714092540.1217397-1-arnd@arndb.de>
References: <20170714092540.1217397-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

gcc-7 warns about slightly suspicious code in vmw_cmd_invalid:

drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c: In function 'vmw_cmd_invalid':
drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c:522:23: error: the omitted middle operand in ?: will always be 'true', suggest explicit middle operand [-Werror=parentheses]

The problem is that it is mixing boolean and integer values here.
I assume that the code actually works correctly, so making it use
a literal '1' instead of the implied 'true' makes it more readable
and avoids the warning.

The code has been in this file since the start, but it could
make sense to backport this patch to stable to make it build cleanly
with gcc-7.

Fixes: fb1d9738ca05 ("drm/vmwgfx: Add DRM driver for VMware Virtual GPU")
Reviewed-by: Sinclair Yeh <syeh@vmware.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
Originally submitted on Nov 16, but for some reason it never appeared
upstream. The patch is still needed as of v4.11-rc2
---
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
index c7b53d987f06..3f343e55972a 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
@@ -519,7 +519,7 @@ static int vmw_cmd_invalid(struct vmw_private *dev_priv,
 			   struct vmw_sw_context *sw_context,
 			   SVGA3dCmdHeader *header)
 {
-	return capable(CAP_SYS_ADMIN) ? : -EINVAL;
+	return capable(CAP_SYS_ADMIN) ? 1 : -EINVAL;
 }
 
 static int vmw_cmd_ok(struct vmw_private *dev_priv,
-- 
2.9.0
