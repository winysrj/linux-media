Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:50774 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751281AbdLKLMf (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Dec 2017 06:12:35 -0500
Date: Mon, 11 Dec 2017 09:12:23 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL for v4.15-rc3] media fixes
Message-ID: <20171211091223.2ba10fb1@vento.lan>
In-Reply-To: <CA+55aFwBvXVQavgwDKVV3epFhd4MTaQvDktpDahkPhxweXnMmQ@mail.gmail.com>
References: <20171208135650.3f385c45@vento.lan>
        <CA+55aFwBvXVQavgwDKVV3epFhd4MTaQvDktpDahkPhxweXnMmQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Linus,

Em Fri, 8 Dec 2017 13:28:57 -0800
Linus Torvalds <torvalds@linux-foundation.org> escreveu:

> On Fri, Dec 8, 2017 at 7:56 AM, Mauro Carvalho Chehab
> <mchehab@osg.samsung.com> wrote:
> >
> > - The largest amount of fixes in this series is with regards to comments
> >   that aren't kernel-doc, but start with "/**". A new check added for
> >   4.15 makes it to produce a *huge* amount of new warnings (I'm compiling
> >   here with W=1). Most of the patches in this series fix those. No code
> >   changes - just comment changes at the source files;  
> 
> Guys, this was just pure garbage, and obviously noboduy actually
> looked at that shit-for-brains patch.
> 
> There were several idiotic things like this:
> 
>   -/******************************
>   +/*****************************
> 
> because part of it was apparently generated with some overly stupid
> search-and-replace. So when replacing "/**" with "/*", it also just
> removed a star from those boxed-in comments.
> 
> In the process that thing also made some of those boxes no longer aligned.
> 
> Now, box comments are stupid anyway, but they become truly
> mind-bogglingly pointless when they are then edited like this.

Sorry for that. On most patches, the regex was more smart than that,
but on a few I had to use a more stupid regex, and used git citool
to exclude the hunks like above. Clearly, I missed some such blocks at
dvb-frontends/drx* and stating/atomisp drivers.

The comments on both drivers need to be reviewed anyway. Both have
a large amount of comments using alien formats (doxygen, apparently),
like this (before this changeset):

/**
 * \def DRXJ_DEF_I2C_ADDR
 * \brief Default I2C address of a demodulator instance.
 */
#define DRXJ_DEF_I2C_ADDR (0x52)

Once I tried to cleanup those comments, but there are just too many
things there that would require manual fix, requiring a large amount
of time to do it manually. Maybe one day I may do it.

Also, on several of them (like the above), we don't even have a way
to convert to docbook, as docbook currently doesn't allow documenting
defines and static vars.

> I've pulled this, but dammit, show some amount of sense. We shouldn't
> have this kind of pointless noise in the rc series. That pointless
> noise may now be hiding the real changes.

Thanks for pulling it, and sorry for the noise.

Without this series, I was getting 809 lines of bogus warnings (see below),
with was preventing me to see new warnings on my incremental builds
while applying new patches at the media tree.

-- 
Thanks,
Mauro


$ make ARCH=i386  CF=-D__CHECK_ENDIAN__ CONFIG_DEBUG_SECTION_MISMATCH=y W=1 CHECK='' M=drivers/staging/media
drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/isys/src/isys_stream2mmio_rmgr.c:17: warning: Cannot understand Support for Intel Camera Imaging ISP subsystem.
 on line 17 - I thought it was a doc line
drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/eventq/src/eventq.c:41: warning: Cannot understand  * @brief The Host sends the event to the SP.
 on line 41 - I thought it was a doc line
drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/rmgr/src/rmgr.c:17: warning: Cannot understand Support for Intel Camera Imaging ISP subsystem.
 on line 17 - I thought it was a doc line
drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/rmgr/src/rmgr.c:48: warning: Cannot understand  * @brief Uninitialize resource pool (host)
 on line 48 - I thought it was a doc line
drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/isys/src/virtual_isys.c:17: warning: Cannot understand Support for Intel Camera Imaging ISP subsystem.
 on line 17 - I thought it was a doc line
drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/timer/src/timer.c:17: warning: Cannot understand Support for Intel Camera Imaging ISP subsystem.
 on line 17 - I thought it was a doc line
drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/isys/src/ibuf_ctrl_rmgr.c:40: warning: cannot understand function prototype: 'ibuf_rsrc_t	ibuf_rsrc; '
drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/isys/src/isys_init.c:17: warning: Cannot understand Support for Intel Camera Imaging ISP subsystem.
 on line 17 - I thought it was a doc line
drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/isys/src/isys_dma_rmgr.c:17: warning: Cannot understand Support for Intel Camera Imaging ISP subsystem.
 on line 17 - I thought it was a doc line
drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/isys/src/csi_rx_rmgr.c:17: warning: Cannot understand Support for Intel Camera Imaging ISP subsystem.
 on line 17 - I thought it was a doc line
drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/isys/src/rx.c:17: warning: Cannot understand Support for Intel Camera Imaging ISP subsystem.
 on line 17 - I thought it was a doc line
drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/inputfifo/src/inputfifo.c:17: warning: Cannot understand Support for Intel Camera Imaging ISP subsystem.
 on line 17 - I thought it was a doc line
drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/ifmtr/src/ifmtr.c:17: warning: Cannot understand Support for Intel Camera Imaging ISP subsystem.
 on line 17 - I thought it was a doc line
drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/bufq/src/bufq.c:156: warning: Cannot understand  * @brief Query the internal queue ID.
 on line 156 - I thought it was a doc line
drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_shared/host/tag.c:21: warning: Cannot understand  * @brief	Creates the tag description from the given parameters.
 on line 21 - I thought it was a doc line
drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_shared/host/tag.c:43: warning: Cannot understand  * @brief	Encodes the members of tag description into a 32-bit value.
 on line 43 - I thought it was a doc line
drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/spctrl/src/spctrl.c:17: warning: Cannot understand Support for Intel Camera Imaging ISP subsystem.
 on line 17 - I thought it was a doc line
drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/queue/src/queue_access.c:17: warning: Cannot understand Support for Intel Camera Imaging ISP subsystem.
 on line 17 - I thought it was a doc line
drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/isp_param/src/isp_param.c:17: warning: Cannot understand Support for Intel Camera Imaging ISP subsystem.
 on line 17 - I thought it was a doc line
drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/rmgr/src/rmgr_vbuf.c:24: warning: Cannot understand  * @brief VBUF resource handles
 on line 24 - I thought it was a doc line
drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/rmgr/src/rmgr_vbuf.c:30: warning: Cannot understand  * @brief VBUF resource pool - refpool
 on line 30 - I thought it was a doc line
drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/rmgr/src/rmgr_vbuf.c:41: warning: Cannot understand  * @brief VBUF resource pool - writepool
 on line 41 - I thought it was a doc line
drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/rmgr/src/rmgr_vbuf.c:52: warning: Cannot understand  * @brief VBUF resource pool - hmmbufferpool
 on line 52 - I thought it was a doc line
drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/rmgr/src/rmgr_vbuf.c:67: warning: Cannot understand  * @brief Initialize the reference count (host, vbuf)
 on line 67 - I thought it was a doc line
drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/rmgr/src/rmgr_vbuf.c:76: warning: Cannot understand  * @brief Retain the reference count for a handle (host, vbuf)
 on line 76 - I thought it was a doc line
drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/rmgr/src/rmgr_vbuf.c:113: warning: Cannot understand  * @brief Release the reference count for a handle (host, vbuf)
 on line 113 - I thought it was a doc line
drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/rmgr/src/rmgr_vbuf.c:135: warning: Cannot understand  * @brief Initialize the resource pool (host, vbuf)
 on line 135 - I thought it was a doc line
drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/rmgr/src/rmgr_vbuf.c:167: warning: Cannot understand  * @brief Uninitialize the resource pool (host, vbuf)
 on line 167 - I thought it was a doc line
drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/rmgr/src/rmgr_vbuf.c:201: warning: Cannot understand  * @brief Push a handle to the pool
 on line 201 - I thought it was a doc line
drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/rmgr/src/rmgr_vbuf.c:228: warning: Cannot understand  * @brief Pop a handle from the pool
 on line 228 - I thought it was a doc line
drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/rmgr/src/rmgr_vbuf.c:258: warning: Cannot understand  * @brief Acquire a handle from the pool (host, vbuf)
 on line 258 - I thought it was a doc line
drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/rmgr/src/rmgr_vbuf.c:306: warning: Cannot understand  * @brief Release a handle to the pool (host, vbuf)
 on line 306 - I thought it was a doc line
drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/event/src/event.c:17: warning: Cannot understand Support for Intel Camera Imaging ISP subsystem.
 on line 17 - I thought it was a doc line
drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/event/src/event.c:56: warning: Cannot understand  * @brief Encode the information into the software-event.
 on line 56 - I thought it was a doc line
drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/frame/src/frame.c:17: warning: Cannot understand Support for Intel Camera Imaging ISP subsystem.
 on line 17 - I thought it was a doc line
drivers/staging/media/atomisp/pci/atomisp2/css2400/memory_realloc.c:2: warning: Cannot understand Support for Intel Camera Imaging ISP subsystem.
 on line 2 - I thought it was a doc line
drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/pipeline/src/pipeline.c:17: warning: Cannot understand Support for Intel Camera Imaging ISP subsystem.
 on line 17 - I thought it was a doc line
drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/pipeline/src/pipeline.c:191: warning: Cannot understand  * @brief Query the SP thread ID.
 on line 191 - I thought it was a doc line
drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_sp.c:1433: warning: Cannot understand  * @brief Update the offline frame information in host_sp_communication.
 on line 1433 - I thought it was a doc line
drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_sp.c:1465: warning: Cannot understand  * @brief Update the mipi frame information in host_sp_communication.
 on line 1465 - I thought it was a doc line
drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_sp.c:1492: warning: Cannot understand  * @brief Update the mipi metadata information in host_sp_communication.
 on line 1492 - I thought it was a doc line
drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_sp.c:1739: warning: Cannot understand  * @brief Initialize the DMA software-mask in the debug mode.
 on line 1739 - I thought it was a doc line
drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_sp.c:1765: warning: Cannot understand  * @brief Set the DMA software-mask in the debug mode.
 on line 1765 - I thought it was a doc line
drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/ipu2_io_ls/bayer_io_ls/ia_css_bayer_io.host.c:3: warning: Cannot understand Support for Intel Camera Imaging ISP subsystem.
 on line 3 - I thought it was a doc line
drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/ipu2_io_ls/yuv444_io_ls/ia_css_yuv444_io.host.c:3: warning: Cannot understand Support for Intel Camera Imaging ISP subsystem.
 on line 3 - I thought it was a doc line
drivers/staging/media/atomisp/pci/atomisp2/css2400/base/circbuf/src/circbuf.c:25: warning: Cannot understand  * @brief Read the oldest element from the circular buffer.
 on line 25 - I thought it was a doc line
drivers/staging/media/atomisp/pci/atomisp2/css2400/base/circbuf/src/circbuf.c:38: warning: Cannot understand  * @brief Shift a chunk of elements in the circular buffer.
 on line 38 - I thought it was a doc line
drivers/staging/media/atomisp/pci/atomisp2/css2400/base/circbuf/src/circbuf.c:52: warning: Cannot understand  * @brief Get the "val" field in the element.
 on line 52 - I thought it was a doc line
drivers/staging/media/atomisp/pci/atomisp2/css2400/base/circbuf/src/circbuf.c:67: warning: Cannot understand  * @brief Create the circular buffer.
 on line 67 - I thought it was a doc line
drivers/staging/media/atomisp/pci/atomisp2/css2400/base/circbuf/src/circbuf.c:92: warning: Cannot understand  * @brief Destroy the circular buffer.
 on line 92 - I thought it was a doc line
drivers/staging/media/atomisp/pci/atomisp2/css2400/base/circbuf/src/circbuf.c:103: warning: Cannot understand  * @brief Pop a value out of the circular buffer.
 on line 103 - I thought it was a doc line
drivers/staging/media/atomisp/pci/atomisp2/css2400/base/circbuf/src/circbuf.c:120: warning: Cannot understand  * @brief Extract a value out of the circular buffer.
 on line 120 - I thought it was a doc line
drivers/staging/media/atomisp/pci/atomisp2/css2400/base/circbuf/src/circbuf.c:170: warning: Cannot understand  * @brief Peek an element from the circular buffer.
 on line 170 - I thought it was a doc line
drivers/staging/media/atomisp/pci/atomisp2/css2400/base/circbuf/src/circbuf.c:184: warning: Cannot understand  * @brief Get the value of an element from the circular buffer.
 on line 184 - I thought it was a doc line
drivers/staging/media/atomisp/pci/atomisp2/css2400/base/circbuf/src/circbuf.c:256: warning: Cannot understand  * @brief Get the "val" field in the element.
 on line 256 - I thought it was a doc line
drivers/staging/media/atomisp/pci/atomisp2/css2400/base/circbuf/src/circbuf.c:266: warning: Cannot understand  * @brief Read the oldest element from the circular buffer.
 on line 266 - I thought it was a doc line
drivers/staging/media/atomisp/pci/atomisp2/css2400/base/circbuf/src/circbuf.c:286: warning: Cannot understand  * @brief Shift a chunk of elements in the circular buffer.
 on line 286 - I thought it was a doc line
drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/debug/src/ia_css_debug.c:1626: warning: cannot understand function prototype: 'char const * const id2filename[8] = '
drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/debug/src/ia_css_debug.c:2530: warning: Cannot understand  * @brief Initialize the debug mode.
 on line 2530 - I thought it was a doc line
drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/debug/src/ia_css_debug.c:2541: warning: Cannot understand  * @brief Disable the DMA channel.
 on line 2541 - I thought it was a doc line
drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/debug/src/ia_css_debug.c:2556: warning: Cannot understand  * @brief Enable the DMA channel.
 on line 2556 - I thought it was a doc line
drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c:184: warning: No description found for parameter 'pipe'
drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c:191: warning: Cannot understand  * @brief Stop all "ia_css_pipe" instances in the target
 on line 191 - I thought it was a doc line
drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c:211: warning: Cannot understand  * @brief Check if all "ia_css_pipe" instances in the target
 on line 211 - I thought it was a doc line
drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c:5032: warning: Cannot understand  * @brief Stop all "ia_css_pipe" instances in the target
 on line 5032 - I thought it was a doc line
drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c:5187: warning: Cannot understand  * @brief Check if all "ia_css_pipe" instances in the target
 on line 5187 - I thought it was a doc line
drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c:5478: warning: Cannot understand  * @brief Check if a format is supported by the pipe.
 on line 5478 - I thought it was a doc line
drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c:8630: warning: Cannot understand  * @brief Tag a specific frame in continuous capture.
 on line 8630 - I thought it was a doc line
drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c:8670: warning: Cannot understand  * @brief Configure the continuous capture.
 on line 8670 - I thought it was a doc line
drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c:8829: warning: No description found for parameter 'pipe_config'
drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c:5199: warning: No description found for parameter 'asd'
drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c:5199: warning: No description found for parameter 'ffmt'
$ make ARCH=i386  CF=-D__CHECK_ENDIAN__ CONFIG_DEBUG_SECTION_MISMATCH=y W=1 CHECK='' M=drivers/media
drivers/media/common/siano/smscoreapi.c:533: warning: No description found for parameter 'hotplug'
drivers/media/common/siano/smscoreapi.c:572: warning: No description found for parameter 'hotplug'
drivers/media/common/siano/smscoreapi.c:652: warning: No description found for parameter 'params'
drivers/media/common/siano/smscoreapi.c:652: warning: No description found for parameter 'coredev'
drivers/media/common/siano/smscoreapi.c:652: warning: No description found for parameter 'mdev'
drivers/media/common/siano/smscoreapi.c:773: warning: No description found for parameter 'coredev'
drivers/media/common/siano/smscoreapi.c:824: warning: No description found for parameter 'coredev'
drivers/media/common/siano/smscoreapi.c:873: warning: No description found for parameter 'coredev'
drivers/media/common/siano/smscoreapi.c:1103: warning: No description found for parameter 'coredev'
drivers/media/common/siano/smscoreapi.c:1103: warning: No description found for parameter 'mode'
drivers/media/common/siano/smscoreapi.c:1141: warning: No description found for parameter 'coredev'
drivers/media/common/siano/smscoreapi.c:1141: warning: No description found for parameter 'mode'
drivers/media/common/siano/smscoreapi.c:1141: warning: No description found for parameter 'loadfirmware_handler'
drivers/media/common/siano/smscoreapi.c:1195: warning: No description found for parameter 'coredev'
drivers/media/common/siano/smscoreapi.c:1295: warning: No description found for parameter 'coredev'
drivers/media/common/siano/smscoreapi.c:1295: warning: No description found for parameter 'mode'
drivers/media/common/siano/smscoreapi.c:1329: warning: No description found for parameter 'coredev'
drivers/media/common/siano/smscoreapi.c:1329: warning: No description found for parameter 'mode'
drivers/media/common/siano/smscoreapi.c:1423: warning: No description found for parameter 'coredev'
drivers/media/common/siano/smscoreapi.c:1441: warning: No description found for parameter 'coredev'
drivers/media/common/siano/smscoreapi.c:1441: warning: No description found for parameter 'data_type'
drivers/media/common/siano/smscoreapi.c:1441: warning: No description found for parameter 'id'
drivers/media/common/siano/smscoreapi.c:1475: warning: No description found for parameter 'coredev'
drivers/media/common/siano/smscoreapi.c:1475: warning: No description found for parameter 'cb'
drivers/media/common/siano/smscoreapi.c:1628: warning: No description found for parameter 'coredev'
drivers/media/common/siano/smscoreapi.c:1660: warning: No description found for parameter 'coredev'
drivers/media/common/siano/smscoreapi.c:1660: warning: No description found for parameter 'cb'
drivers/media/common/siano/smscoreapi.c:1713: warning: No description found for parameter 'coredev'
drivers/media/common/siano/smscoreapi.c:1713: warning: No description found for parameter 'params'
drivers/media/common/siano/smscoreapi.c:1713: warning: No description found for parameter 'client'
drivers/media/common/siano/smscoreapi.c:1751: warning: No description found for parameter 'client'
drivers/media/common/siano/smscoreapi.c:1787: warning: No description found for parameter 'client'
drivers/media/common/siano/smscoreapi.c:1787: warning: No description found for parameter 'buffer'
drivers/media/common/siano/smscoreapi.c:1787: warning: No description found for parameter 'size'
drivers/media/platform/davinci/vpif.c:54: warning: cannot understand function prototype: 'const struct vpif_channel_config_params vpif_ch_params[] = '
drivers/media/rc/img-ir/img-ir-hw.c:351: warning: No description found for parameter 'reg_timings'
drivers/media/rc/img-ir/img-ir-hw.c:351: warning: Excess function parameter 'timings' description in 'img_ir_decoder_convert'
drivers/media/rc/rc-main.c:278: warning: No description found for parameter 'new_keycode'
drivers/media/rc/rc-main.c:278: warning: Excess function parameter 'keycode' description in 'ir_update_mapping'
drivers/media/rc/rc-main.c:387: warning: No description found for parameter 'ke'
drivers/media/rc/rc-main.c:387: warning: No description found for parameter 'old_keycode'
drivers/media/rc/rc-main.c:387: warning: Excess function parameter 'scancode' description in 'ir_setkeycode'
drivers/media/rc/rc-main.c:387: warning: Excess function parameter 'keycode' description in 'ir_setkeycode'
drivers/media/rc/rc-main.c:433: warning: Excess function parameter 'to' description in 'ir_setkeytable'
drivers/media/rc/rc-main.c:506: warning: No description found for parameter 'ke'
drivers/media/rc/rc-main.c:506: warning: Excess function parameter 'scancode' description in 'ir_getkeycode'
drivers/media/rc/rc-main.c:506: warning: Excess function parameter 'keycode' description in 'ir_getkeycode'
drivers/media/rc/rc-main.c:634: warning: No description found for parameter 't'
drivers/media/rc/rc-main.c:634: warning: Excess function parameter 'cookie' description in 'ir_timer_keyup'
drivers/media/dvb-core/dvb_ca_en50221.c:233: warning: No description found for parameter 'ca'
drivers/media/dvb-core/dvb_ca_en50221.c:233: warning: No description found for parameter 'slot'
drivers/media/dvb-core/dvb_ca_en50221.c:284: warning: No description found for parameter 'timeout_hz'
drivers/media/dvb-core/dvb_ca_en50221.c:284: warning: Excess function parameter 'timeout_ms' description in 'dvb_ca_en50221_wait_if_status'
drivers/media/dvb-core/dvb_ca_en50221.c:409: warning: No description found for parameter 'tuple_type'
drivers/media/dvb-core/dvb_ca_en50221.c:409: warning: No description found for parameter 'tuple_length'
drivers/media/dvb-core/dvb_ca_en50221.c:409: warning: Excess function parameter 'tupleType' description in 'dvb_ca_en50221_read_tuple'
drivers/media/dvb-core/dvb_ca_en50221.c:409: warning: Excess function parameter 'tupleLength' description in 'dvb_ca_en50221_read_tuple'
drivers/media/dvb-core/dvb_ca_en50221.c:795: warning: No description found for parameter 'buf'
drivers/media/dvb-core/dvb_ca_en50221.c:795: warning: No description found for parameter 'bytes_write'
drivers/media/dvb-core/dvb_ca_en50221.c:795: warning: Excess function parameter 'ebuf' description in 'dvb_ca_en50221_write_data'
drivers/media/dvb-core/dvb_ca_en50221.c:795: warning: Excess function parameter 'count' description in 'dvb_ca_en50221_write_data'
drivers/media/dvb-core/dvb_ca_en50221.c:942: warning: No description found for parameter 'pubca'
drivers/media/dvb-core/dvb_ca_en50221.c:942: warning: Excess function parameter 'ca' description in 'dvb_ca_en50221_camchange_irq'
drivers/media/dvb-core/dvb_ca_en50221.c:970: warning: No description found for parameter 'pubca'
drivers/media/dvb-core/dvb_ca_en50221.c:970: warning: Excess function parameter 'ca' description in 'dvb_ca_en50221_camready_irq'
drivers/media/dvb-core/dvb_ca_en50221.c:990: warning: No description found for parameter 'pubca'
drivers/media/dvb-core/dvb_ca_en50221.c:990: warning: Excess function parameter 'ca' description in 'dvb_ca_en50221_frda_irq'
drivers/media/dvb-core/dvb_ca_en50221.c:1304: warning: No description found for parameter 'data'
drivers/media/dvb-core/dvb_ca_en50221.c:1348: warning: No description found for parameter 'parg'
drivers/media/dvb-core/dvb_ca_en50221.c:1348: warning: Excess function parameter 'inode' description in 'dvb_ca_en50221_io_do_ioctl'
drivers/media/dvb-core/dvb_ca_en50221.c:1348: warning: Excess function parameter 'arg' description in 'dvb_ca_en50221_io_do_ioctl'
drivers/media/dvb-core/dvb_ca_en50221.c:1432: warning: Excess function parameter 'inode' description in 'dvb_ca_en50221_io_ioctl'
drivers/media/dvb-core/dvb_ca_en50221.c:1544: warning: No description found for parameter 'ca'
drivers/media/dvb-core/dvb_ca_en50221.c:1544: warning: No description found for parameter 'result'
drivers/media/dvb-core/dvb_ca_en50221.c:1544: warning: No description found for parameter '_slot'
drivers/media/dvb-core/dvb_ca_en50221.c:1849: warning: No description found for parameter 'pubca'
drivers/media/dvb-core/dvb_ca_en50221.c:1849: warning: Excess function parameter 'ca' description in 'dvb_ca_en50221_init'
drivers/media/dvb-core/dvb_ca_en50221.c:1936: warning: No description found for parameter 'pubca'
drivers/media/dvb-core/dvb_ca_en50221.c:1936: warning: Excess function parameter 'ca_dev' description in 'dvb_ca_en50221_release'
drivers/media/dvb-core/dvb_ca_en50221.c:1936: warning: Excess function parameter 'ca' description in 'dvb_ca_en50221_release'
drivers/media/i2c/m5mols/m5mols_core.c:124: warning: No description found for parameter 'data'
drivers/media/i2c/m5mols/m5mols_core.c:124: warning: No description found for parameter 'length'
drivers/media/i2c/m5mols/m5mols_core.c:124: warning: Excess function parameter 'size' description in 'm5mols_swap_byte'
drivers/media/i2c/m5mols/m5mols_core.c:142: warning: No description found for parameter 'sd'
drivers/media/i2c/m5mols/m5mols_core.c:241: warning: No description found for parameter 'sd'
drivers/media/i2c/m5mols/m5mols_core.c:299: warning: No description found for parameter 'sd'
drivers/media/i2c/m5mols/m5mols_core.c:324: warning: No description found for parameter 'sd'
drivers/media/i2c/m5mols/m5mols_core.c:324: warning: No description found for parameter 'reg'
drivers/media/i2c/m5mols/m5mols_core.c:357: warning: No description found for parameter 'sd'
drivers/media/i2c/m5mols/m5mols_core.c:357: warning: No description found for parameter 'mode'
drivers/media/i2c/m5mols/m5mols_core.c:374: warning: No description found for parameter 'info'
drivers/media/i2c/m5mols/m5mols_core.c:429: warning: No description found for parameter 'sd'
drivers/media/i2c/m5mols/m5mols_core.c:503: warning: No description found for parameter 'sd'
drivers/media/i2c/m5mols/m5mols_core.c:671: warning: No description found for parameter 'info'
drivers/media/i2c/m5mols/m5mols_core.c:694: warning: No description found for parameter 'info'
drivers/media/i2c/m5mols/m5mols_core.c:798: warning: No description found for parameter 'sd'
drivers/media/i2c/m5mols/m5mols_core.c:853: warning: No description found for parameter 'sd'
drivers/media/i2c/m5mols/m5mols_core.c:853: warning: No description found for parameter 'on'
drivers/media/rc/rc-ir-raw.c:141: warning: No description found for parameter 'ev'
drivers/media/rc/rc-ir-raw.c:141: warning: Excess function parameter 'type' description in 'ir_raw_event_store_with_filter'
drivers/media/platform/davinci/vpif_display.c:114: warning: No description found for parameter 'sizes'
drivers/media/platform/davinci/vpif_display.c:165: warning: No description found for parameter 'vq'
drivers/media/platform/davinci/vpif_display.c:165: warning: Excess function parameter 'vb' description in 'vpif_start_streaming'
drivers/media/platform/davinci/vpif_display.c:780: warning: No description found for parameter 'vpif_cfg'
drivers/media/platform/davinci/vpif_display.c:780: warning: No description found for parameter 'chan_cfg'
drivers/media/platform/davinci/vpif_display.c:780: warning: No description found for parameter 'index'
drivers/media/platform/davinci/vpif_display.c:813: warning: No description found for parameter 'vpif_cfg'
drivers/media/platform/davinci/vpif_display.c:813: warning: No description found for parameter 'ch'
drivers/media/platform/davinci/vpif_display.c:813: warning: No description found for parameter 'index'
drivers/media/rc/ir-nec-decoder.c:49: warning: No description found for parameter 'ev'
drivers/media/rc/ir-nec-decoder.c:49: warning: Excess function parameter 'duration' description in 'ir_nec_decode'
drivers/media/rc/ir-nec-decoder.c:189: warning: Excess function parameter 'raw' description in 'ir_nec_scancode_to_raw'
drivers/media/i2c/m5mols/m5mols_controls.c:134: warning: No description found for parameter 'info'
drivers/media/dvb-core/dvb_frontend.c:379: warning: No description found for parameter 'fe'
drivers/media/dvb-core/dvb_frontend.c:379: warning: No description found for parameter 'check_wrapped'
drivers/media/dvb-core/dvb_frontend.c:1265: warning: No description found for parameter 'p_out'
drivers/media/dvb-core/dvb_net.c:138: warning: No description found for parameter 'skb'
drivers/media/dvb-core/dvb_net.c:138: warning: No description found for parameter 'dev'
drivers/media/dvb-core/dvb_net.c:312: warning: cannot understand function prototype: 'struct dvb_net_ule_handle '
drivers/media/i2c/m5mols/m5mols_capture.c:42: warning: No description found for parameter 'sd'
drivers/media/i2c/m5mols/m5mols_capture.c:42: warning: No description found for parameter 'addr_num'
drivers/media/i2c/m5mols/m5mols_capture.c:42: warning: No description found for parameter 'addr_den'
drivers/media/i2c/m5mols/m5mols_capture.c:42: warning: No description found for parameter 'val'
drivers/media/i2c/m5mols/m5mols_capture.c:60: warning: No description found for parameter 'info'
drivers/media/platform/davinci/vpif_capture.c:121: warning: No description found for parameter 'sizes'
drivers/media/platform/davinci/vpif_capture.c:174: warning: No description found for parameter 'vq'
drivers/media/platform/davinci/vpif_capture.c:174: warning: Excess function parameter 'vb' description in 'vpif_start_streaming'
drivers/media/platform/davinci/vpif_capture.c:636: warning: No description found for parameter 'iface'
drivers/media/platform/davinci/vpif_capture.c:647: warning: No description found for parameter 'ch'
drivers/media/platform/davinci/vpif_capture.c:647: warning: No description found for parameter 'muxmode'
drivers/media/platform/davinci/vpif_capture.c:676: warning: No description found for parameter 'vpif_cfg'
drivers/media/platform/davinci/vpif_capture.c:676: warning: No description found for parameter 'chan_cfg'
drivers/media/platform/davinci/vpif_capture.c:676: warning: No description found for parameter 'input_index'
drivers/media/platform/davinci/vpif_capture.c:712: warning: No description found for parameter 'vpif_cfg'
drivers/media/platform/davinci/vpif_capture.c:712: warning: No description found for parameter 'ch'
drivers/media/platform/davinci/vpif_capture.c:712: warning: No description found for parameter 'index'
drivers/media/platform/davinci/vpif_capture.c:798: warning: No description found for parameter 'std'
drivers/media/platform/davinci/vpif_capture.c:798: warning: Excess function parameter 'std_id' description in 'vpif_g_std'
drivers/media/platform/davinci/vpif_capture.c:940: warning: No description found for parameter 'fmt'
drivers/media/platform/davinci/vpif_capture.c:940: warning: Excess function parameter 'index' description in 'vpif_enum_fmt_vid_cap'
drivers/media/platform/davinci/vpif_capture.c:1750: warning: No description found for parameter 'dev'
drivers/media/rc/ir-jvc-decoder.c:47: warning: No description found for parameter 'ev'
drivers/media/rc/ir-jvc-decoder.c:47: warning: Excess function parameter 'duration' description in 'ir_jvc_decode'
drivers/media/platform/exynos4-is/mipi-csis.c:229: warning: No description found for parameter 'clk_frequency'
drivers/media/platform/exynos4-is/mipi-csis.c:229: warning: Excess struct member 'clock_frequency' description in 'csis_state'
drivers/media/rc/ir-sanyo-decoder.c:56: warning: No description found for parameter 'ev'
drivers/media/rc/ir-sanyo-decoder.c:56: warning: Excess function parameter 'duration' description in 'ir_sanyo_decode'
drivers/media/rc/ir-sharp-decoder.c:47: warning: No description found for parameter 'ev'
drivers/media/rc/ir-sharp-decoder.c:47: warning: Excess function parameter 'duration' description in 'ir_sharp_decode'
drivers/media/dvb-frontends/sp887x.c:137: warning: No description found for parameter 'fe'
drivers/media/dvb-frontends/sp887x.c:137: warning: No description found for parameter 'fw'
drivers/media/dvb-frontends/sp887x.c:287: warning: No description found for parameter 'n'
drivers/media/dvb-frontends/sp887x.c:287: warning: No description found for parameter 'd'
drivers/media/dvb-frontends/sp887x.c:287: warning: No description found for parameter 'quotient_i'
drivers/media/dvb-frontends/sp887x.c:287: warning: No description found for parameter 'quotient_f'
drivers/media/rc/ir-lirc-codec.c:34: warning: No description found for parameter 'dev'
drivers/media/rc/ir-lirc-codec.c:34: warning: No description found for parameter 'ev'
drivers/media/rc/ir-lirc-codec.c:34: warning: Excess function parameter 'input_dev' description in 'ir_lirc_decode'
drivers/media/rc/ir-lirc-codec.c:34: warning: Excess function parameter 'duration' description in 'ir_lirc_decode'
drivers/media/dvb-frontends/zl10036.c:33: warning: cannot understand function prototype: 'int zl10036_debug; '
drivers/media/dvb-frontends/zl10036.c:179: warning: No description found for parameter 'state'
drivers/media/dvb-frontends/zl10036.c:179: warning: No description found for parameter 'frequency'
drivers/media/rc/ir-xmp-decoder.c:43: warning: No description found for parameter 'ev'
drivers/media/rc/ir-xmp-decoder.c:43: warning: Excess function parameter 'duration' description in 'ir_xmp_decode'
drivers/media/rc/imon.c:500: warning: No description found for parameter 'inode'
drivers/media/rc/imon.c:500: warning: No description found for parameter 'file'
drivers/media/rc/imon.c:550: warning: No description found for parameter 'inode'
drivers/media/rc/imon.c:550: warning: No description found for parameter 'file'
drivers/media/rc/imon.c:584: warning: No description found for parameter 'ictx'
drivers/media/rc/imon.c:676: warning: No description found for parameter 'ictx'
drivers/media/rc/imon.c:709: warning: No description found for parameter 'ictx'
drivers/media/rc/imon.c:709: warning: No description found for parameter 'year'
drivers/media/rc/imon.c:709: warning: No description found for parameter 'month'
drivers/media/rc/imon.c:709: warning: No description found for parameter 'day'
drivers/media/rc/imon.c:709: warning: No description found for parameter 'dow'
drivers/media/rc/imon.c:709: warning: No description found for parameter 'hour'
drivers/media/rc/imon.c:709: warning: No description found for parameter 'minute'
drivers/media/rc/imon.c:709: warning: No description found for parameter 'second'
drivers/media/rc/imon.c:790: warning: No description found for parameter 'd'
drivers/media/rc/imon.c:790: warning: No description found for parameter 'attr'
drivers/media/rc/imon.c:790: warning: No description found for parameter 'buf'
drivers/media/rc/imon.c:831: warning: No description found for parameter 'd'
drivers/media/rc/imon.c:831: warning: No description found for parameter 'attr'
drivers/media/rc/imon.c:831: warning: No description found for parameter 'buf'
drivers/media/rc/imon.c:939: warning: No description found for parameter 'file'
drivers/media/rc/imon.c:939: warning: No description found for parameter 'buf'
drivers/media/rc/imon.c:939: warning: No description found for parameter 'n_bytes'
drivers/media/rc/imon.c:939: warning: No description found for parameter 'pos'
drivers/media/rc/imon.c:1026: warning: No description found for parameter 'file'
drivers/media/rc/imon.c:1026: warning: No description found for parameter 'buf'
drivers/media/rc/imon.c:1026: warning: No description found for parameter 'n_bytes'
drivers/media/rc/imon.c:1026: warning: No description found for parameter 'pos'
drivers/media/rc/imon.c:1073: warning: No description found for parameter 'urb'
drivers/media/rc/imon.c:1094: warning: No description found for parameter 't'
drivers/media/rc/imon.c:1121: warning: No description found for parameter 'rc'
drivers/media/rc/imon.c:1121: warning: No description found for parameter 'rc_proto'
drivers/media/rc/imon.c:1203: warning: No description found for parameter 'a'
drivers/media/rc/imon.c:1203: warning: No description found for parameter 'b'
drivers/media/rc/imon.c:1203: warning: No description found for parameter 'timeout'
drivers/media/rc/imon.c:1203: warning: No description found for parameter 'threshold'
drivers/media/rc/imon.c:1553: warning: No description found for parameter 'ictx'
drivers/media/rc/imon.c:1553: warning: No description found for parameter 'buf'
drivers/media/rc/imon.c:1553: warning: No description found for parameter 'ktype'
drivers/media/rc/imon.c:1599: warning: Incorrect use of kernel-doc format:  * Convert bit count to time duration (in us) and submit
drivers/media/rc/imon.c:1603: warning: No description found for parameter 'context'
drivers/media/rc/imon.c:1616: warning: No description found for parameter 'context'
drivers/media/rc/imon.c:1616: warning: No description found for parameter 'urb'
drivers/media/rc/imon.c:1616: warning: No description found for parameter 'intf'
drivers/media/rc/imon.c:1838: warning: No description found for parameter 'urb'
drivers/media/rc/imon.c:2493: warning: No description found for parameter 'interface'
drivers/media/rc/imon.c:2493: warning: No description found for parameter 'id'
drivers/media/rc/imon.c:2590: warning: No description found for parameter 'interface'
drivers/media/pci/netup_unidvb/netup_unidvb_core.c:85: warning: bad line: 			Bits [0-7]:	DMA packet size, 188 bytes
drivers/media/pci/netup_unidvb/netup_unidvb_core.c:86: warning: bad line: 			Bits [16-23]:	packets count in block, 128 packets
drivers/media/pci/netup_unidvb/netup_unidvb_core.c:87: warning: bad line: 			Bits [24-31]:	blocks count, 8 blocks
drivers/media/pci/netup_unidvb/netup_unidvb_core.c:89: warning: bad line: 			For example, value of 375000000 equals to 3 sec
drivers/media/radio/radio-si476x.c:317: warning: No description found for parameter 'v4l2dev'
drivers/media/radio/radio-si476x.c:317: warning: No description found for parameter 'ctrl_handler'
drivers/media/radio/radio-si476x.c:317: warning: No description found for parameter 'debugfs'
drivers/media/radio/radio-si476x.c:317: warning: No description found for parameter 'audmode'
drivers/media/radio/radio-si476x.c:317: warning: Excess struct member 'kref' description in 'si476x_radio'
drivers/media/radio/radio-si476x.c:317: warning: Excess struct member 'core_lock' description in 'si476x_radio'
drivers/media/tuners/mt2063.c:1413: warning: No description found for parameter 'f_ref'
drivers/media/tuners/mt2063.c:1413: warning: Excess function parameter 'f_Ref' description in 'MT2063_fLO_FractionalTerm'
drivers/media/tuners/mt2063.c:1476: warning: Excess function parameter 'f_Avoid' description in 'MT2063_CalcLO2Mult'
drivers/media/platform/mtk-vcodec/vdec/vdec_h264_if.c:69: warning: No description found for parameter 'reserved'
drivers/media/rc/streamzap.c:201: warning: No description found for parameter 'urb'
drivers/media/rc/streamzap.c:333: warning: No description found for parameter 'intf'
drivers/media/rc/streamzap.c:333: warning: No description found for parameter 'id'
drivers/media/rc/streamzap.c:464: warning: No description found for parameter 'interface'
drivers/media/v4l2-core/v4l2-dv-timings.c:259: warning: No description found for parameter 't1'
drivers/media/v4l2-core/v4l2-dv-timings.c:259: warning: No description found for parameter 't2'
drivers/media/v4l2-core/v4l2-dv-timings.c:259: warning: No description found for parameter 'pclock_delta'
drivers/media/v4l2-core/v4l2-dv-timings.c:259: warning: No description found for parameter 'match_reduced_fps'
drivers/media/platform/mtk-vcodec/vdec/vdec_vp8_if.c:175: warning: Excess struct member 'dev' description in 'vdec_vp8_inst'
drivers/media/v4l2-core/tuner-core.c:242: warning: bad line: 			internal parameters, like LNA mode
drivers/media/v4l2-core/tuner-core.c:765: warning: No description found for parameter 'mode'
drivers/media/platform/exynos4-is/fimc-capture.c:155: warning: No description found for parameter 'ctx'
drivers/media/platform/exynos4-is/fimc-capture.c:868: warning: No description found for parameter 'num_planes'
drivers/media/platform/exynos4-is/fimc-capture.c:1108: warning: No description found for parameter 'fimc'
drivers/media/platform/exynos4-is/media-dev.c:69: warning: No description found for parameter 'p'
drivers/media/platform/exynos4-is/media-dev.c:160: warning: No description found for parameter 'p'
drivers/media/platform/exynos4-is/media-dev.c:160: warning: No description found for parameter 'on'
drivers/media/platform/exynos4-is/media-dev.c:160: warning: Excess function parameter 'fimc' description in 'fimc_pipeline_s_power'
drivers/media/platform/exynos4-is/media-dev.c:160: warning: Excess function parameter 'state' description in 'fimc_pipeline_s_power'
drivers/media/platform/exynos4-is/media-dev.c:229: warning: No description found for parameter 'ep'
drivers/media/platform/exynos4-is/media-dev.c:260: warning: No description found for parameter 'ep'
drivers/media/platform/exynos4-is/media-dev.c:260: warning: Excess function parameter 'fimc' description in '__fimc_pipeline_close'
drivers/media/platform/exynos4-is/media-dev.c:288: warning: No description found for parameter 'ep'
drivers/media/platform/exynos4-is/media-dev.c:288: warning: Excess function parameter 'pipeline' description in '__fimc_pipeline_s_stream'
drivers/media/platform/exynos4-is/media-dev.c:916: warning: No description found for parameter 'fmd'
drivers/media/pci/sta2x11/sta2x11_vip.c:414: warning: No description found for parameter 'priv'
drivers/media/pci/sta2x11/sta2x11_vip.c:442: warning: No description found for parameter 'priv'
drivers/media/pci/sta2x11/sta2x11_vip.c:476: warning: No description found for parameter 'priv'
drivers/media/pci/sta2x11/sta2x11_vip.c:493: warning: No description found for parameter 'priv'
drivers/media/pci/sta2x11/sta2x11_vip.c:524: warning: No description found for parameter 'priv'
drivers/media/pci/sta2x11/sta2x11_vip.c:548: warning: No description found for parameter 'priv'
drivers/media/pci/sta2x11/sta2x11_vip.c:566: warning: No description found for parameter 'file'
drivers/media/pci/sta2x11/sta2x11_vip.c:566: warning: No description found for parameter 'priv'
drivers/media/pci/sta2x11/sta2x11_vip.c:594: warning: No description found for parameter 'priv'
drivers/media/pci/sta2x11/sta2x11_vip.c:651: warning: No description found for parameter 'priv'
drivers/media/pci/sta2x11/sta2x11_vip.c:717: warning: No description found for parameter 'priv'
drivers/media/platform/mtk-vpu/mtk_vpu.c:223: warning: No description found for parameter 'wdt'
drivers/media/platform/mtk-vpu/mtk_vpu.c:223: warning: No description found for parameter 'wdt_refcnt'
drivers/media/v4l2-core/v4l2-mem2mem.c:190: warning: No description found for parameter 'm2m_dev'
drivers/media/v4l2-core/v4l2-mem2mem.c:291: warning: No description found for parameter 'm2m_ctx'
drivers/media/v4l2-core/videobuf-core.c:233: warning: No description found for parameter 'q'
drivers/media/pci/tw68/tw68-risc.c:32: warning: Cannot understand  *  @rp		pointer to current risc program position
 on line 32 - I thought it was a doc line
drivers/media/pci/tw68/tw68-risc.c:144: warning: No description found for parameter 'pci'
drivers/media/pci/tw68/tw68-risc.c:144: warning: No description found for parameter 'buf'
drivers/media/pci/tw68/tw68-risc.c:144: warning: No description found for parameter 'sglist'
drivers/media/pci/tw68/tw68-risc.c:144: warning: No description found for parameter 'top_offset'
drivers/media/pci/tw68/tw68-risc.c:144: warning: No description found for parameter 'bottom_offset'
drivers/media/pci/tw68/tw68-risc.c:144: warning: No description found for parameter 'bpl'
drivers/media/pci/tw68/tw68-risc.c:144: warning: No description found for parameter 'padding'
drivers/media/pci/tw68/tw68-risc.c:144: warning: No description found for parameter 'lines'
drivers/media/usb/siano/smsusb.c:82: warning: No description found for parameter 'work'
drivers/media/usb/siano/smsusb.c:94: warning: bad line: 
drivers/media/usb/siano/smsusb.c:98: warning: No description found for parameter 'urb'
drivers/media/platform/s3c-camif/camif-core.c:112: warning: No description found for parameter 'vp'
drivers/media/radio/radio-wl1273.c:1337: warning: No description found for parameter 'radio'
drivers/media/radio/radio-wl1273.c:1337: warning: Excess function parameter 'core' description in 'wl1273_fm_set_tx_power'
drivers/media/v4l2-core/videobuf2-memops.c:127: warning: cannot understand function prototype: 'const struct vm_operations_struct vb2_common_vm_ops = '
drivers/media/platform/mtk-vcodec/venc/venc_vp8_if.c:55: warning: Enum value 'VENC_VP8_VPU_WORK_BUF_LUMA' not described in enum 'venc_vp8_vpu_work_buf'
drivers/media/platform/mtk-vcodec/venc/venc_vp8_if.c:55: warning: Enum value 'VENC_VP8_VPU_WORK_BUF_LUMA2' not described in enum 'venc_vp8_vpu_work_buf'
drivers/media/platform/mtk-vcodec/venc/venc_vp8_if.c:55: warning: Enum value 'VENC_VP8_VPU_WORK_BUF_LUMA3' not described in enum 'venc_vp8_vpu_work_buf'
drivers/media/platform/mtk-vcodec/venc/venc_vp8_if.c:55: warning: Enum value 'VENC_VP8_VPU_WORK_BUF_CHROMA' not described in enum 'venc_vp8_vpu_work_buf'
drivers/media/platform/mtk-vcodec/venc/venc_vp8_if.c:55: warning: Enum value 'VENC_VP8_VPU_WORK_BUF_CHROMA2' not described in enum 'venc_vp8_vpu_work_buf'
drivers/media/platform/mtk-vcodec/venc/venc_vp8_if.c:55: warning: Enum value 'VENC_VP8_VPU_WORK_BUF_CHROMA3' not described in enum 'venc_vp8_vpu_work_buf'
drivers/media/platform/mtk-vcodec/venc/venc_vp8_if.c:55: warning: Enum value 'VENC_VP8_VPU_WORK_BUF_MV_INFO' not described in enum 'venc_vp8_vpu_work_buf'
drivers/media/platform/mtk-vcodec/venc/venc_vp8_if.c:55: warning: Enum value 'VENC_VP8_VPU_WORK_BUF_BS_HEADER' not described in enum 'venc_vp8_vpu_work_buf'
drivers/media/platform/mtk-vcodec/venc/venc_vp8_if.c:55: warning: Enum value 'VENC_VP8_VPU_WORK_BUF_PROB_BUF' not described in enum 'venc_vp8_vpu_work_buf'
drivers/media/platform/mtk-vcodec/venc/venc_vp8_if.c:55: warning: Enum value 'VENC_VP8_VPU_WORK_BUF_RC_INFO' not described in enum 'venc_vp8_vpu_work_buf'
drivers/media/platform/mtk-vcodec/venc/venc_vp8_if.c:55: warning: Enum value 'VENC_VP8_VPU_WORK_BUF_RC_CODE' not described in enum 'venc_vp8_vpu_work_buf'
drivers/media/platform/mtk-vcodec/venc/venc_vp8_if.c:55: warning: Enum value 'VENC_VP8_VPU_WORK_BUF_RC_CODE2' not described in enum 'venc_vp8_vpu_work_buf'
drivers/media/platform/mtk-vcodec/venc/venc_vp8_if.c:55: warning: Enum value 'VENC_VP8_VPU_WORK_BUF_RC_CODE3' not described in enum 'venc_vp8_vpu_work_buf'
drivers/media/platform/mtk-vcodec/venc/venc_vp8_if.c:55: warning: Enum value 'VENC_VP8_VPU_WORK_BUF_MAX' not described in enum 'venc_vp8_vpu_work_buf'
drivers/media/v4l2-core/videobuf2-core.c:195: warning: No description found for parameter 'vb'
drivers/media/v4l2-core/videobuf2-core.c:236: warning: No description found for parameter 'vb'
drivers/media/v4l2-core/videobuf2-core.c:251: warning: No description found for parameter 'vb'
drivers/media/v4l2-core/videobuf2-core.c:266: warning: No description found for parameter 'vb'
drivers/media/v4l2-core/videobuf2-core.c:266: warning: No description found for parameter 'p'
drivers/media/v4l2-core/videobuf2-core.c:285: warning: No description found for parameter 'vb'
drivers/media/v4l2-core/videobuf2-core.c:297: warning: No description found for parameter 'vb'
drivers/media/v4l2-core/videobuf2-core.c:330: warning: No description found for parameter 'q'
drivers/media/v4l2-core/videobuf2-core.c:330: warning: No description found for parameter 'memory'
drivers/media/v4l2-core/videobuf2-core.c:330: warning: No description found for parameter 'num_buffers'
drivers/media/v4l2-core/videobuf2-core.c:330: warning: No description found for parameter 'num_planes'
drivers/media/v4l2-core/videobuf2-core.c:330: warning: No description found for parameter 'plane_sizes'
drivers/media/v4l2-core/videobuf2-core.c:393: warning: No description found for parameter 'q'
drivers/media/v4l2-core/videobuf2-core.c:393: warning: No description found for parameter 'buffers'
drivers/media/v4l2-core/videobuf2-core.c:419: warning: No description found for parameter 'q'
drivers/media/v4l2-core/videobuf2-core.c:419: warning: No description found for parameter 'buffers'
drivers/media/v4l2-core/videobuf2-core.c:552: warning: No description found for parameter 'q'
drivers/media/v4l2-core/videobuf2-core.c:572: warning: No description found for parameter 'q'
drivers/media/v4l2-core/videobuf2-core.c:585: warning: No description found for parameter 'q'
drivers/media/v4l2-core/videobuf2-core.c:598: warning: No description found for parameter 'q'
drivers/media/v4l2-core/videobuf2-core.c:960: warning: No description found for parameter 'vb'
drivers/media/v4l2-core/videobuf2-core.c:960: warning: No description found for parameter 'pb'
drivers/media/v4l2-core/videobuf2-core.c:973: warning: No description found for parameter 'vb'
drivers/media/v4l2-core/videobuf2-core.c:973: warning: No description found for parameter 'pb'
drivers/media/v4l2-core/videobuf2-core.c:1089: warning: No description found for parameter 'vb'
drivers/media/v4l2-core/videobuf2-core.c:1089: warning: No description found for parameter 'pb'
drivers/media/v4l2-core/videobuf2-core.c:1222: warning: No description found for parameter 'vb'
drivers/media/v4l2-core/videobuf2-core.c:1437: warning: No description found for parameter 'q'
drivers/media/v4l2-core/videobuf2-core.c:1437: warning: No description found for parameter 'nonblocking'
drivers/media/v4l2-core/videobuf2-core.c:1512: warning: No description found for parameter 'q'
drivers/media/v4l2-core/videobuf2-core.c:1512: warning: No description found for parameter 'vb'
drivers/media/v4l2-core/videobuf2-core.c:1512: warning: No description found for parameter 'pb'
drivers/media/v4l2-core/videobuf2-core.c:1512: warning: No description found for parameter 'nonblocking'
drivers/media/v4l2-core/videobuf2-core.c:1560: warning: No description found for parameter 'vb'
drivers/media/v4l2-core/videobuf2-core.c:1635: warning: No description found for parameter 'q'
drivers/media/v4l2-core/videobuf2-core.c:1781: warning: No description found for parameter 'q'
drivers/media/v4l2-core/videobuf2-core.c:1781: warning: No description found for parameter 'off'
drivers/media/v4l2-core/videobuf2-core.c:1781: warning: No description found for parameter '_buffer'
drivers/media/v4l2-core/videobuf2-core.c:1781: warning: No description found for parameter '_plane'
drivers/media/v4l2-core/videobuf2-core.c:2119: warning: No description found for parameter 'vaddr'
drivers/media/v4l2-core/videobuf2-core.c:2119: warning: No description found for parameter 'size'
drivers/media/v4l2-core/videobuf2-core.c:2119: warning: No description found for parameter 'pos'
drivers/media/v4l2-core/videobuf2-core.c:2119: warning: No description found for parameter 'queued'
drivers/media/v4l2-core/videobuf2-core.c:2156: warning: No description found for parameter 'count'
drivers/media/v4l2-core/videobuf2-core.c:2156: warning: No description found for parameter 'type'
drivers/media/v4l2-core/videobuf2-core.c:2156: warning: No description found for parameter 'memory'
drivers/media/v4l2-core/videobuf2-core.c:2156: warning: No description found for parameter 'bufs'
drivers/media/v4l2-core/videobuf2-core.c:2156: warning: No description found for parameter 'q_count'
drivers/media/v4l2-core/videobuf2-core.c:2156: warning: No description found for parameter 'dq_count'
drivers/media/v4l2-core/videobuf2-core.c:2156: warning: No description found for parameter 'read_once'
drivers/media/v4l2-core/videobuf2-core.c:2156: warning: No description found for parameter 'write_immediately'
drivers/media/v4l2-core/videobuf2-v4l2.c:57: warning: No description found for parameter 'vb'
drivers/media/v4l2-core/videobuf2-v4l2.c:57: warning: No description found for parameter 'b'
drivers/media/v4l2-core/videobuf2-v4l2.c:86: warning: No description found for parameter 'vb'
drivers/media/v4l2-core/videobuf2-v4l2.c:86: warning: No description found for parameter 'b'
drivers/media/v4l2-core/videobuf2-v4l2.c:189: warning: No description found for parameter 'vb'
drivers/media/v4l2-core/videobuf2-v4l2.c:189: warning: No description found for parameter 'pb'
drivers/media/v4l2-core/videobuf2-v4l2.c:296: warning: No description found for parameter 'vb'
drivers/media/v4l2-core/videobuf2-v4l2.c:296: warning: No description found for parameter 'pb'
drivers/media/v4l2-core/videobuf2-v4l2.c:296: warning: No description found for parameter 'planes'
drivers/media/rc/st_rc.c:98: warning: No description found for parameter 'irq'
drivers/media/rc/st_rc.c:98: warning: No description found for parameter 'data'
drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c:83: warning: cannot understand function prototype: 'struct ttusb '
drivers/media/pci/solo6x10/solo6x10-enc.c:183: warning: No description found for parameter 'solo_dev'
drivers/media/pci/solo6x10/solo6x10-enc.c:183: warning: No description found for parameter 'ch'
drivers/media/pci/solo6x10/solo6x10-enc.c:183: warning: No description found for parameter 'qp'
drivers/media/platform/mtk-vcodec/venc/venc_h264_if.c:51: warning: Enum value 'VENC_H264_VPU_WORK_BUF_RC_INFO' not described in enum 'venc_h264_vpu_work_buf'
drivers/media/platform/mtk-vcodec/venc/venc_h264_if.c:51: warning: Enum value 'VENC_H264_VPU_WORK_BUF_RC_CODE' not described in enum 'venc_h264_vpu_work_buf'
drivers/media/platform/mtk-vcodec/venc/venc_h264_if.c:51: warning: Enum value 'VENC_H264_VPU_WORK_BUF_REC_LUMA' not described in enum 'venc_h264_vpu_work_buf'
drivers/media/platform/mtk-vcodec/venc/venc_h264_if.c:51: warning: Enum value 'VENC_H264_VPU_WORK_BUF_REC_CHROMA' not described in enum 'venc_h264_vpu_work_buf'
drivers/media/platform/mtk-vcodec/venc/venc_h264_if.c:51: warning: Enum value 'VENC_H264_VPU_WORK_BUF_REF_LUMA' not described in enum 'venc_h264_vpu_work_buf'
drivers/media/platform/mtk-vcodec/venc/venc_h264_if.c:51: warning: Enum value 'VENC_H264_VPU_WORK_BUF_REF_CHROMA' not described in enum 'venc_h264_vpu_work_buf'
drivers/media/platform/mtk-vcodec/venc/venc_h264_if.c:51: warning: Enum value 'VENC_H264_VPU_WORK_BUF_MV_INFO_1' not described in enum 'venc_h264_vpu_work_buf'
drivers/media/platform/mtk-vcodec/venc/venc_h264_if.c:51: warning: Enum value 'VENC_H264_VPU_WORK_BUF_MV_INFO_2' not described in enum 'venc_h264_vpu_work_buf'
drivers/media/platform/mtk-vcodec/venc/venc_h264_if.c:51: warning: Enum value 'VENC_H264_VPU_WORK_BUF_SKIP_FRAME' not described in enum 'venc_h264_vpu_work_buf'
drivers/media/platform/mtk-vcodec/venc/venc_h264_if.c:51: warning: Enum value 'VENC_H264_VPU_WORK_BUF_MAX' not described in enum 'venc_h264_vpu_work_buf'
drivers/media/platform/mtk-vcodec/venc/venc_h264_if.c:60: warning: Enum value 'H264_BS_MODE_SPS' not described in enum 'venc_h264_bs_mode'
drivers/media/platform/mtk-vcodec/venc/venc_h264_if.c:60: warning: Enum value 'H264_BS_MODE_PPS' not described in enum 'venc_h264_bs_mode'
drivers/media/platform/mtk-vcodec/venc/venc_h264_if.c:60: warning: Enum value 'H264_BS_MODE_FRAME' not described in enum 'venc_h264_bs_mode'
drivers/media/usb/pwc/pwc-dec23.c:652: warning: Cannot understand  *
 on line 652 - I thought it was a doc line
drivers/media/dvb-frontends/tua6100.c:34: warning: cannot understand function prototype: 'struct tua6100_priv '
drivers/media/i2c/tvp514x.c:127: warning: No description found for parameter 'hdl'
drivers/media/i2c/tvp514x.c:127: warning: No description found for parameter 'pad'
drivers/media/i2c/tvp514x.c:127: warning: No description found for parameter 'format'
drivers/media/i2c/tvp514x.c:127: warning: No description found for parameter 'int_seq'
drivers/media/i2c/tvp514x.c:219: warning: cannot understand function prototype: 'const struct v4l2_fmtdesc tvp514x_fmt_list[] = '
drivers/media/i2c/tvp514x.c:235: warning: cannot understand function prototype: 'const struct tvp514x_std_info tvp514x_std_list[] = '
drivers/media/i2c/tvp514x.c:941: warning: No description found for parameter 'fmt'
drivers/media/i2c/tvp514x.c:941: warning: Excess function parameter 'format' description in 'tvp514x_set_pad_format'
drivers/media/i2c/tvp514x.c:1208: warning: cannot understand function prototype: 'const struct i2c_device_id tvp514x_id[] = '
drivers/media/usb/gspca/ov519.c:36: warning: No description found for parameter 'fmt'
drivers/media/platform/soc_camera/soc_scale_crop.c:309: warning: Cannot understand  * @icd		- soc-camera device
 on line 309 - I thought it was a doc line
drivers/media/platform/sti/hva/hva-h264.c:140: warning: cannot understand function prototype: 'struct hva_h264_stereo_video_sei '
drivers/media/platform/sti/hva/hva-h264.c:150: warning: Cannot understand  * @frame_width: width in pixels of the buffer containing the input frame
 on line 150 - I thought it was a doc line
drivers/media/platform/sti/hva/hva-h264.c:356: warning: Cannot understand  * @ slice_size: slice size
 on line 356 - I thought it was a doc line
drivers/media/platform/sti/hva/hva-h264.c:369: warning: Cannot understand  * @ bitstream_size: bitstream size
 on line 369 - I thought it was a doc line
drivers/media/platform/sti/hva/hva-h264.c:395: warning: Cannot understand  * @seq_info:  sequence information buffer
 on line 395 - I thought it was a doc line
drivers/media/platform/ti-vpe/vpe.c:933: warning: No description found for parameter 'priv'
drivers/media/platform/vim2m.c:350: warning: No description found for parameter 'priv'
drivers/media/usb/dvb-usb/dib0700_devices.c:3367: warning: No description found for parameter 'adap'
drivers/media/platform/vsp1/vsp1_dl.c:87: warning: No description found for parameter 'has_chain'
drivers/media/platform/pxa_camera.c:247: warning: No description found for parameter 'layout'
drivers/media/platform/pxa_camera.c:867: warning: No description found for parameter 'buf'
drivers/media/platform/pxa_camera.c:867: warning: No description found for parameter 'sg'
drivers/media/platform/pxa_camera.c:867: warning: No description found for parameter 'sglen'
drivers/media/platform/pxa_camera.c:867: warning: Excess function parameter 'vb' description in 'pxa_init_dma_channel'
drivers/media/platform/pxa_camera.c:867: warning: Excess function parameter 'dma' description in 'pxa_init_dma_channel'
drivers/media/platform/pxa_camera.c:867: warning: Excess function parameter 'cibr' description in 'pxa_init_dma_channel'
drivers/media/platform/pxa_camera.c:1029: warning: No description found for parameter 'last_submitted'
drivers/media/platform/pxa_camera.c:1029: warning: No description found for parameter 'last_issued'
drivers/media/i2c/ov5647.c:432: warning: Cannot understand  * @short Subdev core operations registration
 on line 432 - I thought it was a doc line
drivers/media/platform/sh_veu.c:277: warning: No description found for parameter 'priv'
drivers/media/usb/dvb-usb/cinergyT2-fe.c:40: warning: No description found for parameter 'op'
drivers/media/usb/dvb-usb/friio.c:35: warning: No description found for parameter 'd'
drivers/media/usb/dvb-usb/friio.c:35: warning: No description found for parameter 'addr'
drivers/media/usb/dvb-usb/friio.c:35: warning: No description found for parameter 'wbuf'
drivers/media/usb/dvb-usb/friio.c:35: warning: No description found for parameter 'wlen'
drivers/media/usb/dvb-usb/friio.c:35: warning: No description found for parameter 'rbuf'
drivers/media/usb/dvb-usb/friio.c:35: warning: No description found for parameter 'rlen'
drivers/media/usb/dvb-usb/friio-fe.c:301: warning: Cannot understand  * (reg, val) commad list to initialize this module.
 on line 301 - I thought it was a doc line
drivers/media/platform/rcar_jpu.c:265: warning: cannot understand function prototype: 'struct jpu_q_data '
drivers/media/platform/rcar_jpu.c:281: warning: cannot understand function prototype: 'struct jpu_ctx '
drivers/media/platform/rcar_fdp1.c:1139: warning: No description found for parameter 'priv'
drivers/media/i2c/s5k6a3.c:68: warning: No description found for parameter 'clock'
drivers/media/i2c/s5k6a3.c:68: warning: No description found for parameter 'clock_frequency'
drivers/media/i2c/s5k6a3.c:68: warning: No description found for parameter 'power_count'
drivers/media/i2c/s5k6aa.c:429: warning: No description found for parameter 's5k6aa'
drivers/media/i2c/s5k6aa.c:679: warning: No description found for parameter 's5k6aa'
drivers/media/i2c/s5k6aa.c:733: warning: No description found for parameter 's5k6aa'
drivers/media/i2c/s5k6aa.c:733: warning: No description found for parameter 'preset'
drivers/media/i2c/s5k6aa.c:787: warning: No description found for parameter 'sd'
drivers/media/i2c/lm3560.c:69: warning: No description found for parameter 'dev'
drivers/media/dvb-frontends/ix2505v.c:24: warning: cannot understand function prototype: 'int ix2505v_debug; '
drivers/media/dvb-frontends/ix2505v.c:59: warning: No description found for parameter 'state'
drivers/media/dvb-frontends/ix2505v.c:128: warning: No description found for parameter 'fe'
drivers/media/dvb-frontends/drxk_hard.c:3448: warning: Cannot understand * \brief Activate DVBT specific presets
 on line 3448 - I thought it was a doc line
drivers/media/dvb-frontends/drxk_hard.c:3488: warning: Cannot understand * \brief Initialize channelswitch-independent settings for DVBT.
 on line 3488 - I thought it was a doc line
drivers/media/dvb-frontends/drxk_hard.c:3700: warning: Cannot understand * \brief start dvbt demodulating for channel.
 on line 3700 - I thought it was a doc line
drivers/media/dvb-frontends/drxk_hard.c:3736: warning: Cannot understand * \brief Set up dvbt demodulator for channel.
 on line 3736 - I thought it was a doc line
drivers/media/dvb-frontends/drxk_hard.c:4090: warning: Cannot understand * \brief Retrieve lock status .
 on line 4090 - I thought it was a doc line
drivers/media/dvb-frontends/drxk_hard.c:4190: warning: Cannot understand * \brief Setup of the QAM Measurement intervals for signal quality
 on line 4190 - I thought it was a doc line
drivers/media/dvb-frontends/drxk_hard.c:4465: warning: Cannot understand * \brief QAM32 specific setup
 on line 4465 - I thought it was a doc line
drivers/media/dvb-frontends/drxk_hard.c:4661: warning: Cannot understand * \brief QAM64 specific setup
 on line 4661 - I thought it was a doc line
drivers/media/dvb-frontends/drxk_hard.c:4856: warning: Cannot understand * \brief QAM128 specific setup
 on line 4856 - I thought it was a doc line
drivers/media/dvb-frontends/drxk_hard.c:5053: warning: Cannot understand * \brief QAM256 specific setup
 on line 5053 - I thought it was a doc line
drivers/media/dvb-frontends/drxk_hard.c:5248: warning: Cannot understand * \brief Reset QAM block.
 on line 5248 - I thought it was a doc line
drivers/media/dvb-frontends/drxk_hard.c:5276: warning: Cannot understand * \brief Set QAM symbolrate.
 on line 5276 - I thought it was a doc line
drivers/media/dvb-frontends/drxk_hard.c:5345: warning: Cannot understand * \brief Get QAM lock status.
 on line 5345 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:77: warning: Cannot understand * \brief Maximum u32 value.
 on line 77 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:212: warning: Cannot understand * \def DRXJ_DEF_I2C_ADDR
 on line 212 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:218: warning: Cannot understand * \def DRXJ_DEF_DEMOD_DEV_ID
 on line 218 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:224: warning: Cannot understand * \def DRXJ_SCAN_TIMEOUT
 on line 224 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:230: warning: Cannot understand * \def HI_I2C_DELAY
 on line 230 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:238: warning: Cannot understand * \def HI_I2C_BRIDGE_DELAY
 on line 238 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:246: warning: Cannot understand * \brief Time Window for MER and SER Measurement in Units of Segment duration.
 on line 246 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:252: warning: Cannot understand * \brief bit rate and segment rate constants used for SER and BER.
 on line 252 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:264: warning: Cannot understand * \brief Min supported symbolrates.
 on line 264 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:271: warning: Cannot understand * \brief Max supported symbolrates.
 on line 271 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:278: warning: Cannot understand * \def DRXJ_QAM_MAX_WAITTIME
 on line 278 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:294: warning: Cannot understand * \def SCU status and results
 on line 294 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:303: warning: Cannot understand * \def DRX_AUD_MAX_DEVIATION
 on line 303 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:311: warning: Cannot understand * \brief Needed for calculation of NICAM prescale feature in AUD
 on line 311 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:318: warning: Cannot understand * \brief Needed for calculation of NICAM prescale feature in AUD
 on line 318 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:375: warning: Cannot understand */
 on line 375 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:378: warning: Cannot understand * \brief Temporary register definitions.
 on line 378 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:389: warning: Cannot understand * \brief RAM location of MODUS registers
 on line 389 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:398: warning: Cannot understand * \brief RAM location of I2S config registers
 on line 398 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:404: warning: Cannot understand * \brief RAM location of DCO config registers
 on line 404 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:412: warning: Cannot understand * \brief RAM location of Threshold registers
 on line 412 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:419: warning: Cannot understand * \brief RAM location of Carrier Threshold registers
 on line 419 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:425: warning: Cannot understand * \brief FM Matrix register fix
 on line 425 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:434: warning: Cannot understand * \brief Defines required for audio
 on line 434 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:447: warning: Cannot understand * \brief Needed for calculation of prescale feature in AUD
 on line 447 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:454: warning: Cannot understand * \brief Needed for calculation of NICAM prescale feature in AUD
 on line 454 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:488: warning: No description found for parameter 'x'
drivers/media/dvb-frontends/drx39xyj/drxj.c:494: warning: No description found for parameter 'x'
drivers/media/dvb-frontends/drx39xyj/drxj.c:505: warning: Cannot understand * \brief General maximum number of retries for ucode command interfaces
 on line 505 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:811: warning: Cannot understand * \var drxj_default_addr_g
 on line 811 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:820: warning: Cannot understand * \var drxj_default_comm_attr_g
 on line 820 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:891: warning: Cannot understand * \var drxj_default_demod_g
 on line 891 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:901: warning: Cannot understand * \brief Default audio data structure for DRK demodulator instance.
 on line 901 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:1014: warning: No description found for parameter 'flags'
drivers/media/dvb-frontends/drx39xyj/drxj.c:1090: warning: Cannot understand * \fn u32 log1_times100( u32 x)
 on line 1090 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:1202: warning: Cannot understand * \fn u32 frac_times1e6( u16 N, u32 D)
 on line 1202 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:1239: warning: Cannot understand * \brief Values for NICAM prescaler gain. Computed from dB to integer
 on line 1239 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:1284: warning: Cannot understand * \fn bool is_handled_by_aud_tr_if( u32 addr )
 on line 1284 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:1815: warning: Cannot understand * \fn int drxj_dap_rm_write_reg16short
 on line 1815 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:1894: warning: Cannot understand * \fn int drxj_dap_read_aud_reg16
 on line 1894 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:2001: warning: Cannot understand * \fn int drxj_dap_write_aud_reg16
 on line 2001 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:2090: warning: Cannot understand * \fn int drxj_dap_atomic_read_write_block()
 on line 2090 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:2172: warning: Cannot understand * \fn int drxj_dap_atomic_read_reg32()
 on line 2172 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:2219: warning: Cannot understand * \fn int hi_cfg_command()
 on line 2219 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:2262: warning: Cannot understand * \fn int hi_command()
 on line 2262 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:2386: warning: No description found for parameter 'demod'
drivers/media/dvb-frontends/drx39xyj/drxj.c:2454: warning: Cannot understand * \fn int get_device_capabilities()
 on line 2454 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:2660: warning: Cannot understand * \fn int power_up_device()
 on line 2660 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:2714: warning: Cannot understand * \fn int ctrl_set_cfg_mpeg_output()
 on line 2714 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:3360: warning: Cannot understand * \fn int set_mpegtei_handling()
 on line 3360 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:3433: warning: Cannot understand * \fn int bit_reverse_mpeg_output()
 on line 3433 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:3476: warning: Cannot understand * \fn int set_mpeg_start_width()
 on line 3476 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:3526: warning: Cannot understand * \fn int ctrl_set_uio_cfg()
 on line 3526 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:3663: warning: Cannot understand * \fn int ctrl_uio_write()
 on line 3663 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:3872: warning: Cannot understand * \fn int ctrl_i2c_bridge()
 on line 3872 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:3907: warning: Cannot understand * \fn int smart_ant_init()
 on line 3907 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:4120: warning: Cannot understand * \fn int DRXJ_DAP_SCUAtomicReadWriteBlock()
 on line 4120 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:4192: warning: Cannot understand * \fn int DRXJ_DAP_AtomicReadReg16()
 on line 4192 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:4220: warning: Cannot understand * \fn int drxj_dap_scu_atomic_write_reg16()
 on line 4220 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:4241: warning: Cannot understand * \brief Measure result of ADC synchronisation
 on line 4241 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:4301: warning: Cannot understand * \brief Synchronize analog and digital clock domains
 on line 4301 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:4369: warning: Cannot understand * \fn int init_agc ()
 on line 4369 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:4745: warning: Cannot understand * \fn int set_frequency ()
 on line 4745 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:4843: warning: Cannot understand * \fn int get_acc_pkt_err()
 on line 4843 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:4895: warning: Cannot understand * \fn int set_agc_rf ()
 on line 4895 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:5109: warning: Cannot understand * \fn int set_agc_if ()
 on line 5109 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:5338: warning: Cannot understand * \fn int set_iqm_af ()
 on line 5338 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:5384: warning: Cannot understand * \fn int power_down_vsb ()
 on line 5384 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:5482: warning: Cannot understand * \fn int set_vsb_leak_n_gain ()
 on line 5482 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:5698: warning: Cannot understand * \fn int set_vsb()
 on line 5698 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:6210: warning: No description found for parameter 'dev_addr'
drivers/media/dvb-frontends/drx39xyj/drxj.c:6210: warning: No description found for parameter 'pck_errs'
drivers/media/dvb-frontends/drx39xyj/drxj.c:6210: warning: No description found for parameter 'pck_count'
drivers/media/dvb-frontends/drx39xyj/drxj.c:6249: warning: No description found for parameter 'dev_addr'
drivers/media/dvb-frontends/drx39xyj/drxj.c:6249: warning: No description found for parameter 'ber'
drivers/media/dvb-frontends/drx39xyj/drxj.c:6249: warning: No description found for parameter 'cnt'
drivers/media/dvb-frontends/drx39xyj/drxj.c:6294: warning: No description found for parameter 'dev_addr'
drivers/media/dvb-frontends/drx39xyj/drxj.c:6294: warning: No description found for parameter 'ber'
drivers/media/dvb-frontends/drx39xyj/drxj.c:6294: warning: No description found for parameter 'cnt'
drivers/media/dvb-frontends/drx39xyj/drxj.c:6315: warning: No description found for parameter 'dev_addr'
drivers/media/dvb-frontends/drx39xyj/drxj.c:6315: warning: No description found for parameter 'mer'
drivers/media/dvb-frontends/drx39xyj/drxj.c:6344: warning: Cannot understand * \fn int power_down_qam ()
 on line 6344 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:6448: warning: Cannot understand * \fn int set_qam_measurement ()
 on line 6448 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:6660: warning: Cannot understand * \fn int set_qam16 ()
 on line 6660 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:6895: warning: Cannot understand * \fn int set_qam32 ()
 on line 6895 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:7130: warning: Cannot understand * \fn int set_qam64 ()
 on line 7130 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:7366: warning: Cannot understand * \fn int set_qam128 ()
 on line 7366 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:7601: warning: Cannot understand * \fn int set_qam256 ()
 on line 7601 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:7839: warning: Cannot understand * \fn int set_qam ()
 on line 7839 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:8849: warning: Cannot understand * \fn int qam64auto ()
 on line 8849 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:8997: warning: Cannot understand * \fn int qam256auto ()
 on line 8997 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:9081: warning: Cannot understand * \fn int set_qam_channel ()
 on line 9081 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:9298: warning: No description found for parameter 'dev_addr'
drivers/media/dvb-frontends/drx39xyj/drxj.c:9298: warning: No description found for parameter 'rs_errors'
drivers/media/dvb-frontends/drx39xyj/drxj.c:9359: warning: Cannot understand  * \fn int get_sig_strength()
 on line 9359 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:9439: warning: Cannot understand * \fn int ctrl_get_qam_sig_quality()
 on line 9439 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:9725: warning: Cannot understand * \fn int power_down_atv ()
 on line 9725 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:9826: warning: Cannot understand * \brief Power up AUD.
 on line 9826 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:9854: warning: Cannot understand * \fn int set_orx_nsu_aox()
 on line 9854 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:9888: warning: Cannot understand * \fn int ctrl_set_oob()
 on line 9888 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:10423: warning: Cannot understand * \fn int ctrl_set_channel()
 on line 10423 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:10656: warning: Cannot understand * \fn int ctrl_sig_quality()
 on line 10656 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:10772: warning: Cannot understand * \fn int ctrl_lock_status()
 on line 10772 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:10860: warning: Cannot understand * \fn int ctrl_set_standard()
 on line 10860 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:11016: warning: Cannot understand * \fn int ctrl_power_mode()
 on line 11016 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:11175: warning: Cannot understand * \fn int ctrl_set_cfg_pre_saw()
 on line 11175 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:11238: warning: Cannot understand * \fn int ctrl_set_cfg_afe_gain()
 on line 11238 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:11328: warning: Cannot understand * \fn drxj_open()
 on line 11328 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:11547: warning: Cannot understand * \fn drxj_close()
 on line 11547 - I thought it was a doc line
drivers/media/dvb-frontends/drx39xyj/drxj.c:11733: warning: No description found for parameter 'demod'
drivers/media/dvb-frontends/drx39xyj/drxj.c:11733: warning: Excess function parameter 'dev_addr' description in 'drx_ctrl_u_code'
