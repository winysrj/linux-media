Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:48950 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752203AbeDETcd (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Apr 2018 15:32:33 -0400
Date: Thu, 5 Apr 2018 16:32:26 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org
Subject: Re: [PATCH 15/16] media: omapfb_dss.h: add stubs to build with
 COMPILE_TEST
Message-ID: <20180405163226.0700c519@vento.lan>
In-Reply-To: <1527912.68v46ENJLK@avalon>
References: <cover.1522949748.git.mchehab@s-opensource.com>
        <d3517e25c2b37d3d5f2f61630048a184ce701c58.1522949748.git.mchehab@s-opensource.com>
        <1527912.68v46ENJLK@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 05 Apr 2018 21:41:18 +0300
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Mauro,
> 
> Thank you for the patch.
> 
> On Thursday, 5 April 2018 20:54:15 EEST Mauro Carvalho Chehab wrote:
> > Add stubs for omapfb_dss.h, in the case it is included by
> > some driver when CONFIG_FB_OMAP2 is not defined.  
> 
> The omapfb driver doesn't include any asm/ header, so it should probably build 
> fine on non-ARM architectures. Instead of adding stubs here, you can enable 
> compilation of the driver on all platforms, in which case the omap_vout driver 
> could keep depending on FB_OMAP2 as it should.

True. The patch for that is simple. 

Patch enclosed. Please notice that, now with W=1, several new warnings
will popup. I'll let to the others to touch there, as I don't have any
clue about what's there under omapfb.

Those are the new warnings:

drivers/video/fbdev/omap2/omapfb/omapfb-main.c: In function ‘omapfb_setup_overlay’:
drivers/video/fbdev/omap2/omapfb/omapfb-main.c:891:6: warning: this statement may fall through [-Wimplicit-fallthrough=]
   if (ofbi->rotation_type == OMAP_DSS_ROT_VRFB) {
      ^
drivers/video/fbdev/omap2/omapfb/omapfb-main.c:896:2: note: here
  default:
  ^~~~~~~
drivers/video/fbdev/omap2/omapfb/displays/encoder-tpd12s015.c: In function ‘tpd_probe’:
drivers/video/fbdev/omap2/omapfb/displays/encoder-tpd12s015.c:221:26: warning: variable ‘in’ set but not used [-Wunused-but-set-variable]
  struct omap_dss_device *in, *dssdev;
                          ^~
drivers/video/fbdev/omap2/omapfb/dss/dispc.c: In function ‘calc_vrfb_rotation_offset’:
drivers/video/fbdev/omap2/omapfb/dss/dispc.c:1905:6: warning: this statement may fall through [-Wimplicit-fallthrough=]
   if (color_mode == OMAP_DSS_COLOR_YUV2 ||
      ^
drivers/video/fbdev/omap2/omapfb/dss/dispc.c:1908:2: note: here
  case OMAP_DSS_ROT_90:
  ^~~~
drivers/video/fbdev/omap2/omapfb/dss/dispc.c:1927:6: warning: this statement may fall through [-Wimplicit-fallthrough=]
   if (color_mode == OMAP_DSS_COLOR_YUV2 ||
      ^
drivers/video/fbdev/omap2/omapfb/dss/dispc.c:1930:2: note: here
  case OMAP_DSS_ROT_90 + 4:
  ^~~~
drivers/video/fbdev/omap2/omapfb/dss/venc.c:223:33: warning: ‘venc_config_pal_bdghi’ defined but not used [-Wunused-const-variable=]
 static const struct venc_config venc_config_pal_bdghi = {
                                 ^~~~~~~~~~~~~~~~~~~~~
drivers/video/fbdev/omap2/omapfb/dss/dsi.c: In function ‘_dsi_print_reset_status’:
drivers/video/fbdev/omap2/omapfb/dss/dsi.c:1189:6: warning: variable ‘l’ set but not used [-Wunused-but-set-variable]
  u32 l;
      ^
drivers/video/fbdev/omap2/omapfb/dss/dsi.c: In function ‘dsi_proto_timings’:
drivers/video/fbdev/omap2/omapfb/dss/dsi.c:3638:42: warning: variable ‘tclk_trail’ set but not used [-Wunused-but-set-variable]
  unsigned tlpx, tclk_zero, tclk_prepare, tclk_trail;
                                          ^~~~~~~~~~
drivers/video/fbdev/omap2/omapfb/dss/dsi.c: In function ‘dsi_update’:
drivers/video/fbdev/omap2/omapfb/dss/dsi.c:4051:10: warning: variable ‘dh’ set but not used [-Wunused-but-set-variable]
  u16 dw, dh;
          ^~
drivers/video/fbdev/omap2/omapfb/dss/dsi.c:4051:6: warning: variable ‘dw’ set but not used [-Wunused-but-set-variable]
  u16 dw, dh;
      ^~
drivers/video/fbdev/omap2/omapfb/dss/hdmi4_core.c: In function ‘hdmi4_audio_config’:
drivers/video/fbdev/omap2/omapfb/dss/hdmi4_core.c:693:6: warning: variable ‘err’ set but not used [-Wunused-but-set-variable]
  int err, n, cts, channel_count;
      ^~~
drivers/video/fbdev/omap2/omapfb/dss/hdmi5_core.c: In function ‘hdmi5_audio_config’:
drivers/video/fbdev/omap2/omapfb/dss/hdmi5_core.c:804:6: warning: variable ‘err’ set but not used [-Wunused-but-set-variable]
  int err, n, cts, channel_count;
      ^~~

Thanks,
Mauro

---

[PATCH] omap2: omapfb: allow building it with COMPILE_TEST

This driver builds cleanly with COMPILE_TEST, and it is
needed in order to allow building drivers/media omap2
driver.

So, change the logic there to allow building it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

diff --git a/drivers/video/fbdev/omap2/Kconfig b/drivers/video/fbdev/omap2/Kconfig
index 0921c4de8407..82008699d253 100644
--- a/drivers/video/fbdev/omap2/Kconfig
+++ b/drivers/video/fbdev/omap2/Kconfig
@@ -1,4 +1,4 @@
-if ARCH_OMAP2PLUS
+if ARCH_OMAP2PLUS || COMPILE_TEST
 
 source "drivers/video/fbdev/omap2/omapfb/Kconfig"
 
