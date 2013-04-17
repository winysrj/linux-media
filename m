Return-path: <linux-media-owner@vger.kernel.org>
Received: from service87.mimecast.com ([91.220.42.44]:38927 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160Ab3DQPSU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Apr 2013 11:18:20 -0400
From: Pawel Moll <pawel.moll@arm.com>
To: linux-fbdev@vger.kernel.org, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	devicetree-discuss@lists.ozlabs.org,
	linux-arm-kernel@lists.infradead.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Pawel Moll <pawel.moll@arm.com>
Subject: [RFC 06/10] video: ARM CLCD: Add DT & CDF support
Date: Wed, 17 Apr 2013 16:17:18 +0100
Message-Id: <1366211842-21497-7-git-send-email-pawel.moll@arm.com>
In-Reply-To: <1366211842-21497-1-git-send-email-pawel.moll@arm.com>
References: <1366211842-21497-1-git-send-email-pawel.moll@arm.com>
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds basic DT bindings for the PL11x CLCD cells
and make their fbdev driver use them, together with the
Common Display Framework.

The DT provides information about the hardware configuration
and limitations (eg. the largest supported resolution)
but the video modes come exclusively from the Common
Display Framework drivers, referenced to by the standard CDF
binding.

Signed-off-by: Pawel Moll <pawel.moll@arm.com>
---
 .../devicetree/bindings/video/arm,pl11x.txt        |   35 +++
 drivers/video/Kconfig                              |    1 +
 drivers/video/amba-clcd.c                          |  244 ++++++++++++++++=
++++
 include/linux/amba/clcd.h                          |    2 +
 4 files changed, 282 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/video/arm,pl11x.txt

diff --git a/Documentation/devicetree/bindings/video/arm,pl11x.txt b/Docume=
ntation/devicetree/bindings/video/arm,pl11x.txt
new file mode 100644
index 0000000..ee9534a
--- /dev/null
+++ b/Documentation/devicetree/bindings/video/arm,pl11x.txt
@@ -0,0 +1,35 @@
+* ARM PrimeCell Color LCD Controller (CLCD) PL110/PL111
+
+Required properties:
+
+- compatible : must be one of:
+=09=09=09"arm,pl110", "arm,primecell"
+=09=09=09"arm,pl111", "arm,primecell"
+- reg : base address and size of the control registers block
+- interrupts : the combined interrupt
+- clocks : phandles to the CLCD (pixel) clock and the APB clocks
+- clock-names : "clcdclk", "apb_pclk"
+- display : phandle to the display entity connected to the controller
+
+Optional properties:
+
+- label : string describing the controller location and/or usage
+- video-ram : phandle to DT node of the specialized video RAM to be used
+- max-hactive : maximum frame buffer width in pixels
+- max-vactive : maximum frame buffer height in pixels
+- max-bpp : maximum number of bits per pixel
+- big-endian-pixels : defining this property makes the pixel bytes being
+=09=09=09accessed in Big Endian organization
+
+Example:
+
+=09=09=09clcd@1f0000 {
+=09=09=09=09compatible =3D "arm,pl111", "arm,primecell";
+=09=09=09=09reg =3D <0x1f0000 0x1000>;
+=09=09=09=09interrupts =3D <14>;
+=09=09=09=09clocks =3D <&v2m_oscclk1>, <&smbclk>;
+=09=09=09=09clock-names =3D "clcdclk", "apb_pclk";
+=09=09=09=09label =3D "IOFPGA CLCD";
+=09=09=09=09video-ram =3D <&v2m_vram>;
+=09=09=09=09display =3D <&v2m_muxfpga>;
+=09=09=09};
diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index 281e548..bad8166 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -340,6 +340,7 @@ config FB_ARMCLCD
 =09select FB_CFB_FILLRECT
 =09select FB_CFB_COPYAREA
 =09select FB_CFB_IMAGEBLIT
+=09select FB_MODE_HELPERS if OF
 =09help
 =09  This framebuffer device driver is for the ARM PrimeCell PL110
 =09  Colour LCD controller.  ARM PrimeCells provide the building
diff --git a/drivers/video/amba-clcd.c b/drivers/video/amba-clcd.c
index 0a2cce7..778dc03 100644
--- a/drivers/video/amba-clcd.c
+++ b/drivers/video/amba-clcd.c
@@ -25,6 +25,11 @@
 #include <linux/amba/clcd.h>
 #include <linux/clk.h>
 #include <linux/hardirq.h>
+#include <linux/dma-mapping.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <video/display.h>
+#include <video/videomode.h>
=20
 #include <asm/sizes.h>
=20
@@ -62,6 +67,10 @@ static void clcdfb_disable(struct clcd_fb *fb)
 {
 =09u32 val;
=20
+=09if (fb->panel->display)
+=09=09display_entity_set_state(fb->panel->display,
+=09=09=09=09DISPLAY_ENTITY_STATE_OFF);
+
 =09if (fb->board->disable)
 =09=09fb->board->disable(fb);
=20
@@ -115,6 +124,11 @@ static void clcdfb_enable(struct clcd_fb *fb, u32 cntl=
)
 =09 */
 =09if (fb->board->enable)
 =09=09fb->board->enable(fb);
+
+=09if (fb->panel->display)
+=09=09display_entity_set_state(fb->panel->display,
+=09=09=09=09DISPLAY_ENTITY_STATE_ON);
+
 }
=20
 static int
@@ -304,6 +318,13 @@ static int clcdfb_set_par(struct fb_info *info)
=20
 =09clcdfb_enable(fb, regs.cntl);
=20
+=09if (fb->panel->display) {
+=09=09struct videomode mode;
+
+=09=09videomode_from_fb_var_screeninfo(&fb->fb.var, &mode);
+=09=09display_entity_update(fb->panel->display, &mode);
+=09}
+
 #ifdef DEBUG
 =09printk(KERN_INFO
 =09       "CLCD: Registers set to\n"
@@ -542,6 +563,226 @@ static int clcdfb_register(struct clcd_fb *fb)
 =09return ret;
 }
=20
+#if defined(CONFIG_OF)
+static int clcdfb_of_get_tft_parallel_panel(struct clcd_panel *panel,
+=09=09struct display_entity_interface_params *params)
+{
+=09int r =3D params->p.tft_parallel.r_bits;
+=09int g =3D params->p.tft_parallel.g_bits;
+=09int b =3D params->p.tft_parallel.b_bits;
+
+=09/* Bypass pixel clock divider, data output on the falling edge */
+=09panel->tim2 =3D TIM2_BCD | TIM2_IPC;
+
+=09/* TFT display, vert. comp. interrupt at the start of the back porch */
+=09panel->cntl |=3D CNTL_LCDTFT | CNTL_LCDVCOMP(1);
+
+=09if (params->p.tft_parallel.r_b_swapped)
+=09=09panel->cntl |=3D CNTL_BGR;
+
+=09if (r >=3D 4 && g >=3D 4 && b >=3D 4)
+=09=09panel->caps |=3D CLCD_CAP_444;
+=09if (r >=3D 5 && g >=3D 5 && b >=3D 5)
+=09=09panel->caps |=3D CLCD_CAP_5551;
+=09if (r >=3D 5 && g >=3D 6 && b >=3D 5)
+=09=09panel->caps |=3D CLCD_CAP_565;
+=09if (r >=3D 8 && g >=3D 8 && b >=3D 8)
+=09=09panel->caps |=3D CLCD_CAP_888;
+
+=09return 0;
+}
+
+static int clcdfb_of_init_display(struct clcd_fb *fb)
+{
+=09struct device_node *node =3D fb->dev->dev.of_node;
+=09struct display_entity_interface_params params;
+=09const struct videomode *modes;
+=09int modes_num;
+=09int best_mode =3D -1;
+=09u32 max_bpp =3D 32;
+=09u32 max_hactive =3D (u32)~0UL;
+=09u32 max_vactive =3D (u32)~0UL;
+=09unsigned int width, height;
+=09char *mode_name;
+=09int i, err;
+
+=09fb->panel =3D devm_kzalloc(&fb->dev->dev, sizeof(*fb->panel), GFP_KERNE=
L);
+=09if (!fb->panel)
+=09=09return -ENOMEM;
+
+=09fb->panel->display =3D of_display_entity_get(node, 0);
+=09if (!fb->panel->display)
+=09=09return -EPROBE_DEFER;
+
+=09modes_num =3D display_entity_get_modes(fb->panel->display, &modes);
+=09if (modes_num < 0)
+=09=09return modes_num;
+
+=09/* Pick the "best" (the widest, then the highest) mode from the list */
+=09of_property_read_u32(node, "max-hactive", &max_hactive);
+=09of_property_read_u32(node, "max-vactive", &max_vactive);
+=09for (i =3D 0; i < modes_num; i++) {
+=09=09if (modes[i].hactive > max_hactive ||
+=09=09=09=09modes[i].vactive > max_vactive)
+=09=09=09continue;
+=09=09if (best_mode < 0 ||
+=09=09=09=09(modes[i].hactive >=3D modes[best_mode].hactive &&
+=09=09=09=09modes[i].vactive > modes[best_mode].vactive))
+=09=09=09best_mode =3D i;
+=09}
+=09if (best_mode < 0)
+=09=09return -ENODEV;
+
+=09err =3D fb_videomode_from_videomode(&modes[best_mode], &fb->panel->mode=
);
+=09if (err)
+=09=09return err;
+
+=09i =3D snprintf(NULL, 0, "%ux%u@%u", fb->panel->mode.xres,
+=09=09=09fb->panel->mode.yres, fb->panel->mode.refresh);
+=09mode_name =3D devm_kzalloc(&fb->dev->dev, i + 1, GFP_KERNEL);
+=09snprintf(mode_name, i + 1, "%ux%u@%u", fb->panel->mode.xres,
+=09=09=09fb->panel->mode.yres, fb->panel->mode.refresh);
+=09fb->panel->mode.name =3D mode_name;
+
+=09of_property_read_u32(node, "max-bpp", &max_bpp);
+=09fb->panel->bpp =3D max_bpp;
+
+=09if (of_property_read_bool(node, "big-endian-pixels"))
+=09=09fb->panel->cntl |=3D CNTL_BEBO;
+
+=09if (display_entity_get_size(fb->panel->display, &width, &height) !=3D 0=
)
+=09=09width =3D height =3D -1;
+=09fb->panel->width =3D width;
+=09fb->panel->height =3D height;
+
+=09err =3D display_entity_get_params(fb->panel->display, &params);
+=09if (err)
+=09=09return err;
+
+=09switch (params.type) {
+=09case DISPLAY_ENTITY_INTERFACE_TFT_PARALLEL:
+=09=09return clcdfb_of_get_tft_parallel_panel(fb->panel, &params);
+=09default:
+=09=09return -EINVAL;
+=09}
+}
+
+static int clcdfb_of_vram_setup(struct clcd_fb *fb)
+{
+=09const __be32 *prop =3D of_get_property(fb->dev->dev.of_node, "video-ram=
",
+=09=09=09NULL);
+=09struct device_node *node =3D of_find_node_by_phandle(be32_to_cpup(prop)=
);
+=09u64 size;
+=09int err;
+
+=09if (!node)
+=09=09return -ENODEV;
+
+=09err =3D clcdfb_of_init_display(fb);
+=09if (err)
+=09=09return err;
+
+=09fb->fb.screen_base =3D of_iomap(node, 0);
+=09if (!fb->fb.screen_base)
+=09=09return -ENOMEM;
+
+=09fb->fb.fix.smem_start =3D of_translate_address(node,
+=09=09=09of_get_address(node, 0, &size, NULL));
+=09fb->fb.fix.smem_len =3D size;
+
+=09return 0;
+}
+
+static int clcdfb_of_vram_mmap(struct clcd_fb *fb, struct vm_area_struct *=
vma)
+{
+=09unsigned long off, user_size, kernel_size;
+
+=09off =3D vma->vm_pgoff << PAGE_SHIFT;
+=09user_size =3D vma->vm_end - vma->vm_start;
+=09kernel_size =3D fb->fb.fix.smem_len;
+
+=09if (off >=3D kernel_size || user_size > (kernel_size - off))
+=09=09return -ENXIO;
+
+=09return remap_pfn_range(vma, vma->vm_start,
+=09=09=09__phys_to_pfn(fb->fb.fix.smem_start) + vma->vm_pgoff,
+=09=09=09user_size,
+=09=09=09pgprot_writecombine(vma->vm_page_prot));
+}
+
+static void clcdfb_of_vram_remove(struct clcd_fb *fb)
+{
+=09iounmap(fb->fb.screen_base);
+}
+
+static int clcdfb_of_dma_setup(struct clcd_fb *fb)
+{
+=09unsigned long framesize;
+=09dma_addr_t dma;
+=09int err;
+
+=09err =3D clcdfb_of_init_display(fb);
+=09if (err)
+=09=09return err;
+
+=09framesize =3D fb->panel->mode.xres * fb->panel->mode.yres *
+=09=09=09fb->panel->bpp / 8;
+=09fb->fb.screen_base =3D dma_alloc_writecombine(&fb->dev->dev, framesize,
+=09=09=09&dma, GFP_KERNEL);
+=09if (!fb->fb.screen_base)
+=09=09return -ENOMEM;
+
+=09fb->fb.fix.smem_start =3D dma;
+=09fb->fb.fix.smem_len =3D framesize;
+
+=09return 0;
+}
+
+static int clcdfb_of_dma_mmap(struct clcd_fb *fb, struct vm_area_struct *v=
ma)
+{
+=09return dma_mmap_writecombine(&fb->dev->dev, vma, fb->fb.screen_base,
+=09=09=09fb->fb.fix.smem_start, fb->fb.fix.smem_len);
+}
+
+static void clcdfb_of_dma_remove(struct clcd_fb *fb)
+{
+=09dma_free_writecombine(&fb->dev->dev, fb->fb.fix.smem_len,
+=09=09=09fb->fb.screen_base, fb->fb.fix.smem_start);
+}
+
+static struct clcd_board *clcdfb_of_get_board(struct amba_device *dev)
+{
+=09struct clcd_board *board =3D devm_kzalloc(&dev->dev, sizeof(*board),
+=09=09=09GFP_KERNEL);
+=09struct device_node *node =3D dev->dev.of_node;
+
+=09if (!board)
+=09=09return NULL;
+
+=09board->name =3D of_get_property(node, "label", NULL);
+=09if (!board->name)
+=09=09board->name =3D of_node_full_name(node);
+=09board->check =3D clcdfb_check;
+=09board->decode =3D clcdfb_decode;
+=09if (of_find_property(node, "video-ram", NULL)) {
+=09=09board->setup =3D clcdfb_of_vram_setup;
+=09=09board->mmap =3D clcdfb_of_vram_mmap;
+=09=09board->remove =3D clcdfb_of_vram_remove;
+=09} else {
+=09=09board->setup =3D clcdfb_of_dma_setup;
+=09=09board->mmap =3D clcdfb_of_dma_mmap;
+=09=09board->remove =3D clcdfb_of_dma_remove;
+=09}
+
+=09return board;
+}
+#else
+static struct clcd_board *clcdfb_of_get_board(struct amba_dev *dev)
+{
+=09return NULL;
+}
+#endif
+
 static int clcdfb_probe(struct amba_device *dev, const struct amba_id *id)
 {
 =09struct clcd_board *board =3D dev->dev.platform_data;
@@ -549,6 +790,9 @@ static int clcdfb_probe(struct amba_device *dev, const =
struct amba_id *id)
 =09int ret;
=20
 =09if (!board)
+=09=09board =3D clcdfb_of_get_board(dev);
+
+=09if (!board)
 =09=09return -EINVAL;
=20
 =09ret =3D amba_request_regions(dev, NULL);
diff --git a/include/linux/amba/clcd.h b/include/linux/amba/clcd.h
index e82e3ee..73b199b 100644
--- a/include/linux/amba/clcd.h
+++ b/include/linux/amba/clcd.h
@@ -10,6 +10,7 @@
  * for more details.
  */
 #include <linux/fb.h>
+#include <video/display.h>
=20
 /*
  * CLCD Controller Internal Register addresses
@@ -105,6 +106,7 @@ struct clcd_panel {
 =09=09=09=09fixedtimings:1,
 =09=09=09=09grayscale:1;
 =09unsigned int=09=09connector;
+=09struct display_entity=09*display;
 };
=20
 struct clcd_regs {
--=20
1.7.10.4


