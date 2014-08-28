Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:7684 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932210AbaH1BMx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Aug 2014 21:12:53 -0400
Date: Thu, 28 Aug 2014 09:12:43 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, kbuild-all@01.org
Subject: [linuxtv-media:devel 497/499]
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c:1775:3: warning: format '%zx'
 expects argument of type 'size_t', but argument 6 has type 'dma_addr_t'
Message-ID: <53fe820b.qZUyTLDwQXbQv431%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="=_53fe820b.1/LRG7eCrOiLIQh5WNMAadTevdntD/9TihblG51DsFharuAV"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.

--=_53fe820b.1/LRG7eCrOiLIQh5WNMAadTevdntD/9TihblG51DsFharuAV
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

tree:   git://linuxtv.org/media_tree.git devel
head:   38a0731165250a0a77eff7b90ea3156d44cc7d66
commit: 7155043c2d027c9c848c3d09badb5af2894ed652 [497/499] [media] enable COMPILE_TEST for media drivers
config: make ARCH=x86_64 allmodconfig

All warnings:

   drivers/media/platform/s5p-mfc/s5p_mfc_enc.c:803:17: sparse: incompatible types in conditional expression (different base types)
   drivers/media/platform/s5p-mfc/s5p_mfc_enc.c:828:9: sparse: incompatible types in conditional expression (different base types)
   drivers/media/platform/s5p-mfc/s5p_mfc_enc.c:861:17: sparse: incompatible types in conditional expression (different base types)
   drivers/media/platform/s5p-mfc/s5p_mfc_enc.c:1127:17: sparse: incompatible types in conditional expression (different base types)
   drivers/media/platform/s5p-mfc/s5p_mfc_enc.c:1704:25: sparse: incompatible types in conditional expression (different base types)
   drivers/media/platform/s5p-mfc/s5p_mfc_enc.c:1948:9: sparse: incompatible types in conditional expression (different base types)
   drivers/media/platform/s5p-mfc/s5p_mfc_enc.c:1969:17: sparse: incompatible types in conditional expression (different base types)
   drivers/media/platform/s5p-mfc/s5p_mfc_enc.c:1976:17: sparse: incompatible types in conditional expression (different base types)
   drivers/media/platform/s5p-mfc/s5p_mfc_enc.c:2017:9: sparse: incompatible types in conditional expression (different base types)
   drivers/media/platform/s5p-mfc/s5p_mfc_enc.c: In function 'check_vb_with_fmt':
>> drivers/media/platform/s5p-mfc/s5p_mfc_enc.c:1775:3: warning: format '%zx' expects argument of type 'size_t', but argument 6 has type 'dma_addr_t' [-Wformat=]
      mfc_debug(2, "index: %d, plane[%d] cookie: 0x%08zx\n",
      ^
   drivers/media/platform/s5p-mfc/s5p_mfc_enc.c: In function 's5p_mfc_buf_prepare':
   drivers/media/platform/s5p-mfc/s5p_mfc_enc.c:1897:3: warning: format '%d' expects argument of type 'int', but argument 5 has type 'size_t' [-Wformat=]
      mfc_debug(2, "plane size: %ld, dst size: %d\n",
      ^

sparse warnings: (new ones prefixed by >>)

>> drivers/media/rc/st_rc.c:107:38: sparse: incorrect type in argument 1 (different address spaces)
   drivers/media/rc/st_rc.c:107:38:    expected void const volatile [noderef] <asn:2>*addr
   drivers/media/rc/st_rc.c:107:38:    got void *
>> drivers/media/rc/st_rc.c:110:53: sparse: incorrect type in argument 1 (different address spaces)
   drivers/media/rc/st_rc.c:110:53:    expected void const volatile [noderef] <asn:2>*addr
   drivers/media/rc/st_rc.c:110:53:    got void *
>> drivers/media/rc/st_rc.c:116:54: sparse: incorrect type in argument 2 (different address spaces)
   drivers/media/rc/st_rc.c:116:54:    expected void volatile [noderef] <asn:2>*addr
   drivers/media/rc/st_rc.c:116:54:    got void *
>> drivers/media/rc/st_rc.c:120:45: sparse: incorrect type in argument 1 (different address spaces)
   drivers/media/rc/st_rc.c:120:45:    expected void const volatile [noderef] <asn:2>*addr
   drivers/media/rc/st_rc.c:120:45:    got void *
>> drivers/media/rc/st_rc.c:121:43: sparse: incorrect type in argument 1 (different address spaces)
   drivers/media/rc/st_rc.c:121:43:    expected void const volatile [noderef] <asn:2>*addr
   drivers/media/rc/st_rc.c:121:43:    got void *
>> drivers/media/rc/st_rc.c:150:46: sparse: incorrect type in argument 1 (different address spaces)
   drivers/media/rc/st_rc.c:150:46:    expected void const volatile [noderef] <asn:2>*addr
   drivers/media/rc/st_rc.c:150:46:    got void *
>> drivers/media/rc/st_rc.c:153:42: sparse: incorrect type in argument 2 (different address spaces)
   drivers/media/rc/st_rc.c:153:42:    expected void volatile [noderef] <asn:2>*addr
   drivers/media/rc/st_rc.c:153:42:    got void *
>> drivers/media/rc/st_rc.c:174:32: sparse: incorrect type in argument 2 (different address spaces)
   drivers/media/rc/st_rc.c:174:32:    expected void volatile [noderef] <asn:2>*addr
   drivers/media/rc/st_rc.c:174:32:    got void *
>> drivers/media/rc/st_rc.c:177:48: sparse: incorrect type in argument 2 (different address spaces)
   drivers/media/rc/st_rc.c:177:48:    expected void volatile [noderef] <asn:2>*addr
   drivers/media/rc/st_rc.c:177:48:    got void *
>> drivers/media/rc/st_rc.c:187:48: sparse: incorrect type in argument 2 (different address spaces)
   drivers/media/rc/st_rc.c:187:48:    expected void volatile [noderef] <asn:2>*addr
   drivers/media/rc/st_rc.c:187:48:    got void *
>> drivers/media/rc/st_rc.c:204:42: sparse: incorrect type in argument 2 (different address spaces)
   drivers/media/rc/st_rc.c:204:42:    expected void volatile [noderef] <asn:2>*addr
   drivers/media/rc/st_rc.c:204:42:    got void *
>> drivers/media/rc/st_rc.c:205:35: sparse: incorrect type in argument 2 (different address spaces)
   drivers/media/rc/st_rc.c:205:35:    expected void volatile [noderef] <asn:2>*addr
   drivers/media/rc/st_rc.c:205:35:    got void *
>> drivers/media/rc/st_rc.c:215:35: sparse: incorrect type in argument 2 (different address spaces)
   drivers/media/rc/st_rc.c:215:35:    expected void volatile [noderef] <asn:2>*addr
   drivers/media/rc/st_rc.c:215:35:    got void *
>> drivers/media/rc/st_rc.c:216:35: sparse: incorrect type in argument 2 (different address spaces)
   drivers/media/rc/st_rc.c:216:35:    expected void volatile [noderef] <asn:2>*addr
   drivers/media/rc/st_rc.c:216:35:    got void *
>> drivers/media/rc/st_rc.c:269:22: sparse: incorrect type in assignment (different address spaces)
   drivers/media/rc/st_rc.c:269:22:    expected void *base
   drivers/media/rc/st_rc.c:269:22:    got void [noderef] <asn:2>*
>> drivers/media/rc/st_rc.c:349:46: sparse: incorrect type in argument 2 (different address spaces)
   drivers/media/rc/st_rc.c:349:46:    expected void volatile [noderef] <asn:2>*addr
   drivers/media/rc/st_rc.c:349:46:    got void *
>> drivers/media/rc/st_rc.c:350:46: sparse: incorrect type in argument 2 (different address spaces)
   drivers/media/rc/st_rc.c:350:46:    expected void volatile [noderef] <asn:2>*addr
   drivers/media/rc/st_rc.c:350:46:    got void *
>> drivers/media/rc/st_rc.c:371:61: sparse: incorrect type in argument 2 (different address spaces)
   drivers/media/rc/st_rc.c:371:61:    expected void volatile [noderef] <asn:2>*addr
   drivers/media/rc/st_rc.c:371:61:    got void *
>> drivers/media/rc/st_rc.c:372:54: sparse: incorrect type in argument 2 (different address spaces)
   drivers/media/rc/st_rc.c:372:54:    expected void volatile [noderef] <asn:2>*addr
   drivers/media/rc/st_rc.c:372:54:    got void *
--
   drivers/media/platform/davinci/vpif.c:66:31: sparse: unknown field name in initializer
   drivers/media/platform/davinci/vpif.c:83:31: sparse: unknown field name in initializer
   drivers/media/platform/davinci/vpif.c:100:31: sparse: unknown field name in initializer
   drivers/media/platform/davinci/vpif.c:117:31: sparse: unknown field name in initializer
   drivers/media/platform/davinci/vpif.c:137:31: sparse: unknown field name in initializer
   drivers/media/platform/davinci/vpif.c:157:31: sparse: unknown field name in initializer
   drivers/media/platform/davinci/vpif.c:174:31: sparse: unknown field name in initializer
>> drivers/media/platform/davinci/vpif.c:221:43: sparse: cannot size expression
--
>> drivers/media/platform/davinci/vpfe_capture.c:128:28: sparse: symbol 'vpfe_standards' was not declared. Should it be static?
--
>> drivers/media/platform/davinci/vpss.c:516:25: sparse: incorrect type in argument 1 (different address spaces)
   drivers/media/platform/davinci/vpss.c:516:25:    expected void volatile [noderef] <asn:2>*addr
   drivers/media/platform/davinci/vpss.c:516:25:    got unsigned long long [usertype] *static [toplevel] [assigned] vpss_regs_base2
>> drivers/media/platform/davinci/vpss.c:526:34: sparse: incorrect type in assignment (different address spaces)
   drivers/media/platform/davinci/vpss.c:526:34:    expected unsigned long long [usertype] *static [toplevel] [assigned] vpss_regs_base2
   drivers/media/platform/davinci/vpss.c:526:34:    got void [noderef] <asn:2>*
>> drivers/media/platform/davinci/vpss.c:528:54: sparse: incorrect type in argument 2 (different address spaces)
   drivers/media/platform/davinci/vpss.c:528:54:    expected void volatile [noderef] <asn:2>*addr
   drivers/media/platform/davinci/vpss.c:528:54:    got unsigned long long [usertype] *static [toplevel] [assigned] vpss_regs_base2
--
>> drivers/media/platform/davinci/dm644x_ccdc.c:936:31: sparse: incorrect type in initializer (incompatible argument 1 (different address spaces))
   drivers/media/platform/davinci/dm644x_ccdc.c:936:31:    expected int ( *set_params )( ... )
   drivers/media/platform/davinci/dm644x_ccdc.c:936:31:    got int ( static [toplevel] *<noident> )( ... )
--
>> drivers/media/platform/davinci/dm355_ccdc.c:946:31: sparse: incorrect type in initializer (incompatible argument 1 (different address spaces))
   drivers/media/platform/davinci/dm355_ccdc.c:946:31:    expected int ( *set_params )( ... )
   drivers/media/platform/davinci/dm355_ccdc.c:946:31:    got int ( static [toplevel] *<noident> )( ... )
--
>> drivers/media/platform/s5p-mfc/s5p_mfc.c:153:17: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc.c:155:17: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc.c:330:17: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc.c:335:17: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc.c:403:9: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc.c:412:17: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc.c:438:25: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc.c:441:25: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc.c:455:9: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc.c:479:17: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc.c:506:9: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc.c:511:9: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc.c:526:9: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc.c:553:17: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc.c:594:9: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc.c:631:25: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc.c:636:25: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc.c:666:17: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc.c:688:17: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc.c:693:9: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc.c:702:9: sparse: incompatible types in conditional expression (different base types)
--
>> drivers/media/platform/s5p-mfc/s5p_mfc_dec.c:546:17: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_dec.c:574:17: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_dec.c:849:25: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_dec.c:1047:9: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_dec.c:1068:17: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_dec.c:1079:25: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_dec.c:1087:17: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_dec.c:1127:9: sparse: incompatible types in conditional expression (different base types)
   In file included from drivers/media/platform/s5p-mfc/s5p_mfc_dec.c:29:0:
   drivers/media/platform/s5p-mfc/s5p_mfc_dec.c: In function 's5p_mfc_dec_init':
   drivers/media/platform/s5p-mfc/s5p_mfc_dec.c:1224:4: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
       (unsigned int)ctx->src_fmt, (unsigned int)ctx->dst_fmt);
       ^
   drivers/media/platform/s5p-mfc/s5p_mfc_debug.h:27:27: note: in definition of macro 'mfc_debug'
        __func__, __LINE__, ##args); \
                              ^
   drivers/media/platform/s5p-mfc/s5p_mfc_dec.c:1224:32: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
       (unsigned int)ctx->src_fmt, (unsigned int)ctx->dst_fmt);
                                   ^
   drivers/media/platform/s5p-mfc/s5p_mfc_debug.h:27:27: note: in definition of macro 'mfc_debug'
        __func__, __LINE__, ##args); \
                              ^
--
>> drivers/media/platform/s5p-mfc/s5p_mfc_enc.c:803:17: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_enc.c:828:9: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_enc.c:861:17: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_enc.c:1127:17: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_enc.c:1704:25: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_enc.c:1948:9: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_enc.c:1969:17: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_enc.c:1976:17: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_enc.c:2017:9: sparse: incompatible types in conditional expression (different base types)
   drivers/media/platform/s5p-mfc/s5p_mfc_enc.c: In function 'check_vb_with_fmt':
   drivers/media/platform/s5p-mfc/s5p_mfc_enc.c:1775:3: warning: format '%zx' expects argument of type 'size_t', but argument 6 has type 'dma_addr_t' [-Wformat=]
      mfc_debug(2, "index: %d, plane[%d] cookie: 0x%08zx\n",
      ^
   drivers/media/platform/s5p-mfc/s5p_mfc_enc.c: In function 's5p_mfc_buf_prepare':
   drivers/media/platform/s5p-mfc/s5p_mfc_enc.c:1897:3: warning: format '%d' expects argument of type 'int', but argument 5 has type 'size_t' [-Wformat=]
      mfc_debug(2, "plane size: %ld, dst size: %d\n",
      ^
--
>> drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c:297:9: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c:400:9: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c:414:17: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c:416:9: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c:426:9: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c:433:9: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c:434:9: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c:436:17: sparse: incompatible types in conditional expression (different base types)
   drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c: In function 's5p_mfc_init_memctrl':
   drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c:192:3: warning: format '%x' expects argument of type 'unsigned int', but argument 4 has type 'dma_addr_t' [-Wformat=]
      mfc_debug(2, "Base Address : %08x\n", dev->bank1);
      ^
   drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c:196:3: warning: format '%x' expects argument of type 'unsigned int', but argument 4 has type 'dma_addr_t' [-Wformat=]
      mfc_debug(2, "Bank1: %08x, Bank2: %08x\n",
      ^
   drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c:196:3: warning: format '%x' expects argument of type 'unsigned int', but argument 5 has type 'dma_addr_t' [-Wformat=]
--
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c:265:37: sparse: incorrect type in argument 2 (different address spaces)
   drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c:265:37:    expected void volatile [noderef] <asn:2>*addr
   drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c:265:37:    got void *
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c:273:36: sparse: incorrect type in argument 1 (different address spaces)
   drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c:273:36:    expected void const volatile [noderef] <asn:2>*addr
   drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c:273:36:    got void *
   drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c: In function 's5p_mfc_set_dec_frame_buffer_v5':
   drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c:475:3: warning: format '%x' expects argument of type 'unsigned int', but argument 5 has type 'size_t' [-Wformat=]
      mfc_debug(2, "Luma %d: %x\n", i,
      ^
   drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c:479:3: warning: format '%x' expects argument of type 'unsigned int', but argument 5 has type 'size_t' [-Wformat=]
      mfc_debug(2, "\tChroma %d: %x\n", i,
      ^
   drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c:484:4: warning: format '%x' expects argument of type 'unsigned int', but argument 4 has type 'size_t' [-Wformat=]
       mfc_debug(2, "\tBuf2: %x, size: %d\n",
       ^
   drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c:492:2: warning: format '%u' expects argument of type 'unsigned int', but argument 4 has type 'size_t' [-Wformat=]
     mfc_debug(2, "Buf1: %u, buf_size1: %d\n", buf_addr1, buf_size1);
     ^
   drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c: In function 's5p_mfc_set_enc_ref_buffer_v5':
   drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c:569:2: warning: format '%d' expects argument of type 'int', but argument 4 has type 'size_t' [-Wformat=]
     mfc_debug(2, "buf_size1: %d, buf_size2: %d\n", buf_size1, buf_size2);
     ^
   drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c:569:2: warning: format '%d' expects argument of type 'int', but argument 5 has type 'size_t' [-Wformat=]
   drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c:608:3: warning: format '%d' expects argument of type 'int', but argument 4 has type 'size_t' [-Wformat=]
      mfc_debug(2, "buf_size1: %d, buf_size2: %d\n",
      ^
   drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c:608:3: warning: format '%d' expects argument of type 'int', but argument 5 has type 'size_t' [-Wformat=]
   drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c:639:3: warning: format '%d' expects argument of type 'int', but argument 4 has type 'size_t' [-Wformat=]
      mfc_debug(2, "buf_size1: %d, buf_size2: %d\n",
      ^
   drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c:639:3: warning: format '%d' expects argument of type 'int', but argument 5 has type 'size_t' [-Wformat=]
   drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c:665:3: warning: format '%d' expects argument of type 'int', but argument 4 has type 'size_t' [-Wformat=]
      mfc_debug(2, "buf_size1: %d, buf_size2: %d\n",
      ^
   drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c:665:3: warning: format '%d' expects argument of type 'int', but argument 5 has type 'size_t' [-Wformat=]
--
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:419:9: sparse: incorrect type in argument 2 (different address spaces)
   drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:419:9:    expected void volatile [noderef] <asn:2>*addr
   drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:419:9:    got void *const d_stream_data_size
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:419:9: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:420:9: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:421:9: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:422:9: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:446:9: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:447:9: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:448:9: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:450:9: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:451:9: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:454:17: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:456:17: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:465:17: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:466:17: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:479:17: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:483:17: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:497:25: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:510:9: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:525:9: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:526:9: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:540:9: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:541:9: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:580:17: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:582:17: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:584:17: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:590:9: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:591:9: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:595:9: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:597:9: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:608:9: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:624:9: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:626:17: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:629:17: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:631:17: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:632:17: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:648:9: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:650:9: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:653:9: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:655:9: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:657:9: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:662:9: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:670:17: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:674:17: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:678:17: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:684:9: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:690:9: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:695:9: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:702:17: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:704:17: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:709:17: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:711:17: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:716:17: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:718:17: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:725:9: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:728:9: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:739:17: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:746:9: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:750:17: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:753:17: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:758:25: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:760:25: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:771:9: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:776:9: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:780:9: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:783:9: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:785:9: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:786:9: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:787:9: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:788:9: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:789:9: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:791:9: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:792:9: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:793:9: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:795:9: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:796:9: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:820:9: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:828:9: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:835:9: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:840:9: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:848:9: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:851:9: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:857:17: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:865:17: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:871:17: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:875:25: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:881:9: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:885:17: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:888:17: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:896:9: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:906:9: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:916:9: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:922:9: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:928:9: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:934:9: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:937:9: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:948:17: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:955:9: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:957:9: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:958:9: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:963:17: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:969:25: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:978:9: sparse: incompatible types in conditional expression (different base types)
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:981:9: sparse: too many errors
   drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c: In function 's5p_mfc_alloc_codec_buffers_v6':
   drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:108:3: warning: format '%d' expects argument of type 'int', but argument 4 has type 'size_t' [-Wformat=]
      mfc_debug(2, "recon luma size: %d chroma size: %d\n",
      ^
   drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:108:3: warning: format '%d' expects argument of type 'int', but argument 5 has type 'size_t' [-Wformat=]
   drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c: In function 's5p_mfc_set_dec_frame_buffer_v6':
   drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:477:3: warning: format '%x' expects argument of type 'unsigned int', but argument 5 has type 'size_t' [-Wformat=]
      mfc_debug(2, "Luma %d: %x\n", i,
      ^
   drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:481:3: warning: format '%x' expects argument of type 'unsigned int', but argument 5 has type 'size_t' [-Wformat=]
      mfc_debug(2, "\tChroma %d: %x\n", i,
      ^
   drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:495:4: warning: format '%x' expects argument of type 'unsigned int', but argument 4 has type 'size_t' [-Wformat=]
       mfc_debug(2, "\tBuf1: %x, size: %d\n",
       ^
   drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:503:2: warning: format '%u' expects argument of type 'unsigned int', but argument 4 has type 'size_t' [-Wformat=]
     mfc_debug(2, "Buf1: %u, buf_size1: %d (frames %d)\n",
     ^
   drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c: In function 's5p_mfc_set_enc_ref_buffer_v6':
   drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:601:2: warning: format '%u' expects argument of type 'unsigned int', but argument 4 has type 'size_t' [-Wformat=]
     mfc_debug(2, "Buf1: %u, buf_size1: %d (ref frames %d)\n",
     ^
   In file included from arch/x86/include/asm/bug.h:35:0,
                    from include/linux/bug.h:4,
                    from include/linux/thread_info.h:11,
                    from arch/x86/include/asm/preempt.h:6,
                    from include/linux/preempt.h:18,
                    from include/linux/spinlock.h:50,
                    from include/linux/mmzone.h:7,
                    from include/linux/gfp.h:5,
                    from include/linux/mm.h:9,
                    from drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:18:
   drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c: In function 's5p_mfc_write_info_v6':
   drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:1888:15: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
     WRITEL(data, (void *)ofs);
                  ^
   include/asm-generic/bug.h:111:27: note: in definition of macro 'WARN_ON_ONCE'
     int __ret_warn_once = !!(condition);   \
                              ^
   drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:1888:2: note: in expansion of macro 'WRITEL'
     WRITEL(data, (void *)ofs);
     ^
   drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:1888:15: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
     WRITEL(data, (void *)ofs);
                  ^
   drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:49:46: note: in definition of macro 'WRITEL'
     (WARN_ON_ONCE(!(reg)) ? 0 : writel((data), (reg)))
                                                 ^
   In file included from arch/x86/include/asm/bug.h:35:0,
                    from include/linux/bug.h:4,
                    from include/linux/thread_info.h:11,
                    from arch/x86/include/asm/preempt.h:6,
                    from include/linux/preempt.h:18,
                    from include/linux/spinlock.h:50,
                    from include/linux/mmzone.h:7,
                    from include/linux/gfp.h:5,
                    from include/linux/mm.h:9,
                    from drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:18:
   drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c: In function 's5p_mfc_read_info_v6':
   drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:1898:14: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
     ret = READL((void *)ofs);
                 ^
   include/asm-generic/bug.h:111:27: note: in definition of macro 'WARN_ON_ONCE'
     int __ret_warn_once = !!(condition);   \
                              ^
   drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:1898:8: note: in expansion of macro 'READL'
     ret = READL((void *)ofs);
           ^
   drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:1898:14: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
     ret = READL((void *)ofs);
                 ^
   drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:47:36: note: in definition of macro 'READL'
     (WARN_ON_ONCE(!(reg)) ? 0 : readl(reg))
                                       ^
   drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c: In function 's5p_mfc_get_pic_type_top_v6':
   drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:2027:3: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
      (unsigned int) ctx->dev->mfc_regs->d_ret_picture_tag_top);
      ^
   drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c: In function 's5p_mfc_get_pic_type_bot_v6':
   drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:2033:3: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
      (unsigned int) ctx->dev->mfc_regs->d_ret_picture_tag_bot);
      ^
   drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c: In function 's5p_mfc_get_crop_info_h_v6':
   drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:2039:3: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
      (unsigned int) ctx->dev->mfc_regs->d_display_crop_info1);
      ^
   drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c: In function 's5p_mfc_get_crop_info_v_v6':
   drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:2045:3: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
      (unsigned int) ctx->dev->mfc_regs->d_display_crop_info2);
      ^

Please consider folding the attached diff :-)

vim +1775 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c

f9f715a95 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c Andrzej Hajda         2012-08-21  1698  		if (list_empty(&ctx->src_queue)) {
4130eabc5 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c Andrzej Hajda         2013-05-28  1699  			mfc_debug(2, "EOS: empty src queue, entering finishing state\n");
f9f715a95 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c Andrzej Hajda         2012-08-21  1700  			ctx->state = MFCINST_FINISHING;
eb3620929 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c Kamil Debski          2013-01-11  1701  			if (s5p_mfc_ctx_ready(ctx))
eb3620929 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c Kamil Debski          2013-01-11  1702  				set_work_bit_irqsave(ctx);
f9f715a95 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c Andrzej Hajda         2012-08-21  1703  			spin_unlock_irqrestore(&dev->irqlock, flags);
43a1ea1f9 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c Arun Kumar K          2012-10-03 @1704  			s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
f9f715a95 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c Andrzej Hajda         2012-08-21  1705  		} else {
4130eabc5 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c Andrzej Hajda         2013-05-28  1706  			mfc_debug(2, "EOS: marking last buffer of stream\n");
f9f715a95 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c Andrzej Hajda         2012-08-21  1707  			buf = list_entry(ctx->src_queue.prev,
f9f715a95 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c Andrzej Hajda         2012-08-21  1708  						struct s5p_mfc_buf, list);
f9f715a95 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c Andrzej Hajda         2012-08-21  1709  			if (buf->flags & MFC_BUF_FLAG_USED)
f9f715a95 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c Andrzej Hajda         2012-08-21  1710  				ctx->state = MFCINST_FINISHING;
f9f715a95 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c Andrzej Hajda         2012-08-21  1711  			else
f9f715a95 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c Andrzej Hajda         2012-08-21  1712  				buf->flags |= MFC_BUF_FLAG_EOS;
f9f715a95 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c Andrzej Hajda         2012-08-21  1713  			spin_unlock_irqrestore(&dev->irqlock, flags);
f9f715a95 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c Andrzej Hajda         2012-08-21  1714  		}
f9f715a95 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c Andrzej Hajda         2012-08-21  1715  		break;
f9f715a95 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c Andrzej Hajda         2012-08-21  1716  	default:
f9f715a95 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c Andrzej Hajda         2012-08-21  1717  		return -EINVAL;
f9f715a95 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c Andrzej Hajda         2012-08-21  1718  
f9f715a95 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c Andrzej Hajda         2012-08-21  1719  	}
f9f715a95 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c Andrzej Hajda         2012-08-21  1720  	return 0;
f9f715a95 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c Andrzej Hajda         2012-08-21  1721  }
f9f715a95 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c Andrzej Hajda         2012-08-21  1722  
f9f715a95 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c Andrzej Hajda         2012-08-21  1723  static int vidioc_subscribe_event(struct v4l2_fh *fh,
e1393b599 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c Sachin Kamat          2012-10-13  1724  				  const struct v4l2_event_subscription *sub)
f9f715a95 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c Andrzej Hajda         2012-08-21  1725  {
f9f715a95 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c Andrzej Hajda         2012-08-21  1726  	switch (sub->type) {
f9f715a95 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c Andrzej Hajda         2012-08-21  1727  	case V4L2_EVENT_EOS:
f9f715a95 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c Andrzej Hajda         2012-08-21  1728  		return v4l2_event_subscribe(fh, sub, 2, NULL);
f9f715a95 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c Andrzej Hajda         2012-08-21  1729  	default:
f9f715a95 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c Andrzej Hajda         2012-08-21  1730  		return -EINVAL;
f9f715a95 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c Andrzej Hajda         2012-08-21  1731  	}
f9f715a95 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c Andrzej Hajda         2012-08-21  1732  }
f9f715a95 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c Andrzej Hajda         2012-08-21  1733  
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1734  static const struct v4l2_ioctl_ops s5p_mfc_enc_ioctl_ops = {
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1735  	.vidioc_querycap = vidioc_querycap,
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1736  	.vidioc_enum_fmt_vid_cap = vidioc_enum_fmt_vid_cap,
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1737  	.vidioc_enum_fmt_vid_cap_mplane = vidioc_enum_fmt_vid_cap_mplane,
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1738  	.vidioc_enum_fmt_vid_out = vidioc_enum_fmt_vid_out,
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1739  	.vidioc_enum_fmt_vid_out_mplane = vidioc_enum_fmt_vid_out_mplane,
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1740  	.vidioc_g_fmt_vid_cap_mplane = vidioc_g_fmt,
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1741  	.vidioc_g_fmt_vid_out_mplane = vidioc_g_fmt,
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1742  	.vidioc_try_fmt_vid_cap_mplane = vidioc_try_fmt,
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1743  	.vidioc_try_fmt_vid_out_mplane = vidioc_try_fmt,
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1744  	.vidioc_s_fmt_vid_cap_mplane = vidioc_s_fmt,
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1745  	.vidioc_s_fmt_vid_out_mplane = vidioc_s_fmt,
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1746  	.vidioc_reqbufs = vidioc_reqbufs,
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1747  	.vidioc_querybuf = vidioc_querybuf,
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1748  	.vidioc_qbuf = vidioc_qbuf,
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1749  	.vidioc_dqbuf = vidioc_dqbuf,
6fa9dd069 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c Tomasz Stanislawski   2012-06-14  1750  	.vidioc_expbuf = vidioc_expbuf,
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1751  	.vidioc_streamon = vidioc_streamon,
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1752  	.vidioc_streamoff = vidioc_streamoff,
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1753  	.vidioc_s_parm = vidioc_s_parm,
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1754  	.vidioc_g_parm = vidioc_g_parm,
f9f715a95 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c Andrzej Hajda         2012-08-21  1755  	.vidioc_encoder_cmd = vidioc_encoder_cmd,
f9f715a95 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c Andrzej Hajda         2012-08-21  1756  	.vidioc_subscribe_event = vidioc_subscribe_event,
f9f715a95 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c Andrzej Hajda         2012-08-21  1757  	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1758  };
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1759  
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1760  static int check_vb_with_fmt(struct s5p_mfc_fmt *fmt, struct vb2_buffer *vb)
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1761  {
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1762  	int i;
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1763  
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1764  	if (!fmt)
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1765  		return -EINVAL;
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1766  	if (fmt->num_planes != vb->num_planes) {
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1767  		mfc_err("invalid plane number for the format\n");
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1768  		return -EINVAL;
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1769  	}
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1770  	for (i = 0; i < fmt->num_planes; i++) {
ba7fcb0c9 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Marek Szyprowski      2011-08-29  1771  		if (!vb2_dma_contig_plane_dma_addr(vb, i)) {
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1772  			mfc_err("failed to get plane cookie\n");
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1773  			return -EINVAL;
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1774  		}
4130eabc5 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c Andrzej Hajda         2013-05-28 @1775  		mfc_debug(2, "index: %d, plane[%d] cookie: 0x%08zx\n",
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1776  			  vb->v4l2_buf.index, i,
ba7fcb0c9 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Marek Szyprowski      2011-08-29  1777  			  vb2_dma_contig_plane_dma_addr(vb, i));
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1778  	}
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1779  	return 0;
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1780  }
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1781  
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1782  static int s5p_mfc_queue_setup(struct vb2_queue *vq,
fc714e70d drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Guennadi Liakhovetski 2011-08-24  1783  			const struct v4l2_format *fmt,
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1784  			unsigned int *buf_count, unsigned int *plane_count,
035aa1475 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Marek Szyprowski      2011-08-24  1785  			unsigned int psize[], void *allocators[])
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1786  {
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1787  	struct s5p_mfc_ctx *ctx = fh_to_ctx(vq->drv_priv);
f96f3cfa0 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c Jeongtae Park         2012-10-03  1788  	struct s5p_mfc_dev *dev = ctx->dev;
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1789  
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1790  	if (ctx->state != MFCINST_GOT_INST) {
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1791  		mfc_err("inavlid state: %d\n", ctx->state);
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1792  		return -EINVAL;
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1793  	}
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1794  	if (vq->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1795  		if (ctx->dst_fmt)
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1796  			*plane_count = ctx->dst_fmt->num_planes;
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1797  		else
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1798  			*plane_count = MFC_ENC_CAP_PLANE_COUNT;
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1799  		if (*buf_count < 1)
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1800  			*buf_count = 1;
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1801  		if (*buf_count > MFC_MAX_BUFFERS)
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1802  			*buf_count = MFC_MAX_BUFFERS;
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1803  		psize[0] = ctx->enc_dst_buf_size;
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1804  		allocators[0] = ctx->dev->alloc_ctx[MFC_BANK1_ALLOC_CTX];
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1805  	} else if (vq->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1806  		if (ctx->src_fmt)
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1807  			*plane_count = ctx->src_fmt->num_planes;
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1808  		else
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1809  			*plane_count = MFC_ENC_OUT_PLANE_COUNT;
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1810  
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1811  		if (*buf_count < 1)
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1812  			*buf_count = 1;
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1813  		if (*buf_count > MFC_MAX_BUFFERS)
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1814  			*buf_count = MFC_MAX_BUFFERS;
722b979e5 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c Arun Kumar K          2013-07-09  1815  
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1816  		psize[0] = ctx->luma_size;
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1817  		psize[1] = ctx->chroma_size;
debe6267b drivers/media/platform/s5p-mfc/s5p_mfc_enc.c Arun Kumar K          2013-07-09  1818  
722b979e5 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c Arun Kumar K          2013-07-09  1819  		if (IS_MFCV6_PLUS(dev)) {
f96f3cfa0 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c Jeongtae Park         2012-10-03  1820  			allocators[0] =
f96f3cfa0 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c Jeongtae Park         2012-10-03  1821  				ctx->dev->alloc_ctx[MFC_BANK1_ALLOC_CTX];
f96f3cfa0 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c Jeongtae Park         2012-10-03  1822  			allocators[1] =
f96f3cfa0 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c Jeongtae Park         2012-10-03  1823  				ctx->dev->alloc_ctx[MFC_BANK1_ALLOC_CTX];
f96f3cfa0 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c Jeongtae Park         2012-10-03  1824  		} else {
f96f3cfa0 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c Jeongtae Park         2012-10-03  1825  			allocators[0] =
f96f3cfa0 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c Jeongtae Park         2012-10-03  1826  				ctx->dev->alloc_ctx[MFC_BANK2_ALLOC_CTX];
f96f3cfa0 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c Jeongtae Park         2012-10-03  1827  			allocators[1] =
f96f3cfa0 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c Jeongtae Park         2012-10-03  1828  				ctx->dev->alloc_ctx[MFC_BANK2_ALLOC_CTX];
f96f3cfa0 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c Jeongtae Park         2012-10-03  1829  		}
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1830  	} else {
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1831  		mfc_err("inavlid queue type: %d\n", vq->type);
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1832  		return -EINVAL;
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1833  	}
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1834  	return 0;
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1835  }
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1836  
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1837  static void s5p_mfc_unlock(struct vb2_queue *q)
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1838  {
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1839  	struct s5p_mfc_ctx *ctx = fh_to_ctx(q->drv_priv);
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1840  	struct s5p_mfc_dev *dev = ctx->dev;
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1841  
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1842  	mutex_unlock(&dev->mfc_mutex);
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1843  }
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1844  
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1845  static void s5p_mfc_lock(struct vb2_queue *q)
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1846  {
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1847  	struct s5p_mfc_ctx *ctx = fh_to_ctx(q->drv_priv);
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1848  	struct s5p_mfc_dev *dev = ctx->dev;
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1849  
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1850  	mutex_lock(&dev->mfc_mutex);
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1851  }
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1852  
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1853  static int s5p_mfc_buf_init(struct vb2_buffer *vb)
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1854  {
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1855  	struct vb2_queue *vq = vb->vb2_queue;
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1856  	struct s5p_mfc_ctx *ctx = fh_to_ctx(vq->drv_priv);
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1857  	unsigned int i;
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1858  	int ret;
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1859  
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1860  	if (vq->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1861  		ret = check_vb_with_fmt(ctx->dst_fmt, vb);
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1862  		if (ret < 0)
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1863  			return ret;
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1864  		i = vb->v4l2_buf.index;
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1865  		ctx->dst_bufs[i].b = vb;
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1866  		ctx->dst_bufs[i].cookie.stream =
ba7fcb0c9 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Marek Szyprowski      2011-08-29  1867  					vb2_dma_contig_plane_dma_addr(vb, 0);
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1868  		ctx->dst_bufs_cnt++;
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1869  	} else if (vq->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1870  		ret = check_vb_with_fmt(ctx->src_fmt, vb);
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1871  		if (ret < 0)
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1872  			return ret;
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1873  		i = vb->v4l2_buf.index;
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1874  		ctx->src_bufs[i].b = vb;
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1875  		ctx->src_bufs[i].cookie.raw.luma =
ba7fcb0c9 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Marek Szyprowski      2011-08-29  1876  					vb2_dma_contig_plane_dma_addr(vb, 0);
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1877  		ctx->src_bufs[i].cookie.raw.chroma =
ba7fcb0c9 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Marek Szyprowski      2011-08-29  1878  					vb2_dma_contig_plane_dma_addr(vb, 1);
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1879  		ctx->src_bufs_cnt++;
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1880  	} else {
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1881  		mfc_err("inavlid queue type: %d\n", vq->type);
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1882  		return -EINVAL;
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1883  	}
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1884  	return 0;
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1885  }
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1886  
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1887  static int s5p_mfc_buf_prepare(struct vb2_buffer *vb)
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1888  {
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1889  	struct vb2_queue *vq = vb->vb2_queue;
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1890  	struct s5p_mfc_ctx *ctx = fh_to_ctx(vq->drv_priv);
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1891  	int ret;
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1892  
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1893  	if (vq->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1894  		ret = check_vb_with_fmt(ctx->dst_fmt, vb);
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1895  		if (ret < 0)
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1896  			return ret;
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1897  		mfc_debug(2, "plane size: %ld, dst size: %d\n",
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1898  			vb2_plane_size(vb, 0), ctx->enc_dst_buf_size);
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1899  		if (vb2_plane_size(vb, 0) < ctx->enc_dst_buf_size) {
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1900  			mfc_err("plane size is too small for capture\n");
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1901  			return -EINVAL;
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1902  		}
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1903  	} else if (vq->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1904  		ret = check_vb_with_fmt(ctx->src_fmt, vb);
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1905  		if (ret < 0)
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1906  			return ret;
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1907  		mfc_debug(2, "plane size: %ld, luma size: %d\n",
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1908  			vb2_plane_size(vb, 0), ctx->luma_size);
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1909  		mfc_debug(2, "plane size: %ld, chroma size: %d\n",
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1910  			vb2_plane_size(vb, 1), ctx->chroma_size);
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1911  		if (vb2_plane_size(vb, 0) < ctx->luma_size ||
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1912  		    vb2_plane_size(vb, 1) < ctx->chroma_size) {
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1913  			mfc_err("plane size is too small for output\n");
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1914  			return -EINVAL;
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1915  		}
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1916  	} else {
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1917  		mfc_err("inavlid queue type: %d\n", vq->type);
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1918  		return -EINVAL;
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1919  	}
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1920  	return 0;
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1921  }
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1922  
bd323e28b drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Marek Szyprowski      2011-08-29  1923  static int s5p_mfc_start_streaming(struct vb2_queue *q, unsigned int count)
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1924  {
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1925  	struct s5p_mfc_ctx *ctx = fh_to_ctx(q->drv_priv);
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1926  	struct s5p_mfc_dev *dev = ctx->dev;
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1927  
722b979e5 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c Arun Kumar K          2013-07-09  1928  	if (IS_MFCV6_PLUS(dev) &&
722b979e5 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c Arun Kumar K          2013-07-09  1929  			(q->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)) {
e9d98ddc0 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c Arun Kumar K          2013-04-24  1930  
e9d98ddc0 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c Arun Kumar K          2013-04-24  1931  		if ((ctx->state == MFCINST_GOT_INST) &&
e9d98ddc0 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c Arun Kumar K          2013-04-24  1932  			(dev->curr_ctx == ctx->num) && dev->hw_lock) {
e9d98ddc0 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c Arun Kumar K          2013-04-24  1933  			s5p_mfc_wait_for_done_ctx(ctx,
e9d98ddc0 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c Arun Kumar K          2013-04-24  1934  						S5P_MFC_R2H_CMD_SEQ_DONE_RET,
e9d98ddc0 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c Arun Kumar K          2013-04-24  1935  						0);
e9d98ddc0 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c Arun Kumar K          2013-04-24  1936  		}
e9d98ddc0 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c Arun Kumar K          2013-04-24  1937  
e9d98ddc0 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c Arun Kumar K          2013-04-24  1938  		if (ctx->src_bufs_cnt < ctx->pb_count) {
e9d98ddc0 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c Arun Kumar K          2013-04-24  1939  			mfc_err("Need minimum %d OUTPUT buffers\n",
e9d98ddc0 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c Arun Kumar K          2013-04-24  1940  					ctx->pb_count);
79aeb3f30 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c Hans Verkuil          2013-12-13  1941  			return -ENOBUFS;
e9d98ddc0 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c Arun Kumar K          2013-04-24  1942  		}
e9d98ddc0 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c Arun Kumar K          2013-04-24  1943  	}
e9d98ddc0 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c Arun Kumar K          2013-04-24  1944  
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1945  	/* If context is ready then dev = work->data;schedule it to run */
7fb89eca0 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c Andrzej Hajda         2012-08-14  1946  	if (s5p_mfc_ctx_ready(ctx))
7fb89eca0 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c Andrzej Hajda         2012-08-14  1947  		set_work_bit_irqsave(ctx);
43a1ea1f9 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c Arun Kumar K          2012-10-03 @1948  	s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
e9d98ddc0 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c Arun Kumar K          2013-04-24  1949  
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1950  	return 0;
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1951  }
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1952  
e37559b22 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c Hans Verkuil          2014-04-17  1953  static void s5p_mfc_stop_streaming(struct vb2_queue *q)
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1954  {
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1955  	unsigned long flags;
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1956  	struct s5p_mfc_ctx *ctx = fh_to_ctx(q->drv_priv);
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1957  	struct s5p_mfc_dev *dev = ctx->dev;
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1958  
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1959  	if ((ctx->state == MFCINST_FINISHING ||
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1960  		ctx->state == MFCINST_RUNNING) &&
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1961  		dev->curr_ctx == ctx->num && dev->hw_lock) {
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1962  		ctx->state = MFCINST_ABORT;
43a1ea1f9 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c Arun Kumar K          2012-10-03  1963  		s5p_mfc_wait_for_done_ctx(ctx, S5P_MFC_R2H_CMD_FRAME_DONE_RET,
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1964  					  0);
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1965  	}
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1966  	ctx->state = MFCINST_FINISHED;
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1967  	spin_lock_irqsave(&dev->irqlock, flags);
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1968  	if (q->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
43a1ea1f9 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c Arun Kumar K          2012-10-03 @1969  		s5p_mfc_hw_call(dev->mfc_ops, cleanup_queue, &ctx->dst_queue,
43a1ea1f9 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c Arun Kumar K          2012-10-03  1970  				&ctx->vq_dst);
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1971  		INIT_LIST_HEAD(&ctx->dst_queue);
af9357467 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    Kamil Debski          2011-06-21  1972  		ctx->dst_queue_cnt = 0;

:::::: The code at line 1775 was first introduced by commit
:::::: 4130eabc55f4d4d1510d2e1c556fe3e0237c5ba5 [media] s5p-mfc: added missing end-of-lines in debug messages

:::::: TO: Andrzej Hajda <a.hajda@samsung.com>
:::::: CC: Mauro Carvalho Chehab <mchehab@redhat.com>

---
0-DAY kernel build testing backend              Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation

--=_53fe820b.1/LRG7eCrOiLIQh5WNMAadTevdntD/9TihblG51DsFharuAV
Content-Type: text/x-diff;
 charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="make-it-static-7155043c2d027c9c848c3d09badb5af2894ed652.diff"

From: Fengguang Wu <fengguang.wu@intel.com>
Subject: [PATCH linuxtv-media] vpfe_standards[] can be static
TO: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: linux-media@vger.kernel.org
CC: linux-media@vger.kernel.org 
CC: davinci-linux-open-source@linux.davincidsp.com 
CC: linux-kernel@vger.kernel.org 

CC: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: linux-media@vger.kernel.org
Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 vpfe_capture.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/davinci/vpfe_capture.c b/drivers/media/platform/davinci/vpfe_capture.c
index ed9dd27..28ddf5e 100644
--- a/drivers/media/platform/davinci/vpfe_capture.c
+++ b/drivers/media/platform/davinci/vpfe_capture.c
@@ -125,7 +125,7 @@ static DEFINE_MUTEX(ccdc_lock);
 /* ccdc configuration */
 static struct ccdc_config *ccdc_cfg;
 
-const struct vpfe_standard vpfe_standards[] = {
+static const struct vpfe_standard vpfe_standards[] = {
 	{V4L2_STD_525_60, 720, 480, {11, 10}, 1},
 	{V4L2_STD_625_50, 720, 576, {54, 59}, 1},
 };

--=_53fe820b.1/LRG7eCrOiLIQh5WNMAadTevdntD/9TihblG51DsFharuAV--
