Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:4718 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751968AbeDIFSN (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 9 Apr 2018 01:18:13 -0400
Date: Mon, 9 Apr 2018 13:17:38 +0800
From: kbuild test robot <lkp@intel.com>
To: Hugo Grostabussiat <bonstra@bonstra.fr.eu.org>
Cc: kbuild-all@01.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org,
        Hugo Grostabussiat <bonstra@bonstra.fr.eu.org>
Subject: Re: [PATCH v2 5/6] usbtv: Enforce standard for color decoding
Message-ID: <201804091218.GkcgM7OY%fengguang.wu@intel.com>
References: <20180408211201.27452-6-bonstra@bonstra.fr.eu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180408211201.27452-6-bonstra@bonstra.fr.eu.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hugo,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on linuxtv-media/master]
[also build test WARNING on v4.16 next-20180406]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Hugo-Grostabussiat/usbtv-Add-SECAM-support-and-fix-color-encoding-selection/20180409-054206
base:   git://linuxtv.org/media_tree.git master
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> drivers/media/usb/usbtv/usbtv-video.c:261:45: sparse: incorrect type in argument 2 (different modifiers) @@    expected unsigned short const [usertype] ( *regs )[2] @@    got ed short const [usertype] ( *regs )[2] @@
   drivers/media/usb/usbtv/usbtv-video.c:261:45:    expected unsigned short const [usertype] ( *regs )[2]
   drivers/media/usb/usbtv/usbtv-video.c:261:45:    got unsigned short [usertype] ( *<noident> )[2]

vim +261 drivers/media/usb/usbtv/usbtv-video.c

   142	
   143	static int usbtv_select_norm(struct usbtv *usbtv, v4l2_std_id norm)
   144	{
   145		int ret;
   146		/* These are the series of register values used to configure the
   147		 * decoder for a specific standard.
   148		 * The first 21 register writes are copied from the
   149		 * Settings\DecoderDefaults registry keys present in the Windows driver
   150		 * .INF file, and control various image tuning parameters (color
   151		 * correction, sharpness, ...).
   152		 */
   153		static const u16 pal[][2] = {
   154			/* "AVPAL" tuning sequence from .INF file */
   155			{ USBTV_BASE + 0x0003, 0x0004 },
   156			{ USBTV_BASE + 0x001a, 0x0068 },
   157			{ USBTV_BASE + 0x0100, 0x00d3 },
   158			{ USBTV_BASE + 0x010e, 0x0072 },
   159			{ USBTV_BASE + 0x010f, 0x00a2 },
   160			{ USBTV_BASE + 0x0112, 0x00b0 },
   161			{ USBTV_BASE + 0x0115, 0x0015 },
   162			{ USBTV_BASE + 0x0117, 0x0001 },
   163			{ USBTV_BASE + 0x0118, 0x002c },
   164			{ USBTV_BASE + 0x012d, 0x0010 },
   165			{ USBTV_BASE + 0x012f, 0x0020 },
   166			{ USBTV_BASE + 0x0220, 0x002e },
   167			{ USBTV_BASE + 0x0225, 0x0008 },
   168			{ USBTV_BASE + 0x024e, 0x0002 },
   169			{ USBTV_BASE + 0x024f, 0x0002 },
   170			{ USBTV_BASE + 0x0254, 0x0059 },
   171			{ USBTV_BASE + 0x025a, 0x0016 },
   172			{ USBTV_BASE + 0x025b, 0x0035 },
   173			{ USBTV_BASE + 0x0263, 0x0017 },
   174			{ USBTV_BASE + 0x0266, 0x0016 },
   175			{ USBTV_BASE + 0x0267, 0x0036 },
   176			/* End image tuning */
   177			{ USBTV_BASE + 0x024e, 0x0002 },
   178			{ USBTV_BASE + 0x024f, 0x0002 },
   179		};
   180	
   181		static const u16 ntsc[][2] = {
   182			/* "AVNTSC" tuning sequence from .INF file */
   183			{ USBTV_BASE + 0x0003, 0x0004 },
   184			{ USBTV_BASE + 0x001a, 0x0079 },
   185			{ USBTV_BASE + 0x0100, 0x00d3 },
   186			{ USBTV_BASE + 0x010e, 0x0068 },
   187			{ USBTV_BASE + 0x010f, 0x009c },
   188			{ USBTV_BASE + 0x0112, 0x00f0 },
   189			{ USBTV_BASE + 0x0115, 0x0015 },
   190			{ USBTV_BASE + 0x0117, 0x0000 },
   191			{ USBTV_BASE + 0x0118, 0x00fc },
   192			{ USBTV_BASE + 0x012d, 0x0004 },
   193			{ USBTV_BASE + 0x012f, 0x0008 },
   194			{ USBTV_BASE + 0x0220, 0x002e },
   195			{ USBTV_BASE + 0x0225, 0x0008 },
   196			{ USBTV_BASE + 0x024e, 0x0002 },
   197			{ USBTV_BASE + 0x024f, 0x0001 },
   198			{ USBTV_BASE + 0x0254, 0x005f },
   199			{ USBTV_BASE + 0x025a, 0x0012 },
   200			{ USBTV_BASE + 0x025b, 0x0001 },
   201			{ USBTV_BASE + 0x0263, 0x001c },
   202			{ USBTV_BASE + 0x0266, 0x0011 },
   203			{ USBTV_BASE + 0x0267, 0x0005 },
   204			/* End image tuning */
   205			{ USBTV_BASE + 0x024e, 0x0002 },
   206			{ USBTV_BASE + 0x024f, 0x0002 },
   207		};
   208	
   209		static const u16 secam[][2] = {
   210			/* "AVSECAM" tuning sequence from .INF file */
   211			{ USBTV_BASE + 0x0003, 0x0004 },
   212			{ USBTV_BASE + 0x001a, 0x0073 },
   213			{ USBTV_BASE + 0x0100, 0x00dc },
   214			{ USBTV_BASE + 0x010e, 0x0072 },
   215			{ USBTV_BASE + 0x010f, 0x00a2 },
   216			{ USBTV_BASE + 0x0112, 0x0090 },
   217			{ USBTV_BASE + 0x0115, 0x0035 },
   218			{ USBTV_BASE + 0x0117, 0x0001 },
   219			{ USBTV_BASE + 0x0118, 0x0030 },
   220			{ USBTV_BASE + 0x012d, 0x0004 },
   221			{ USBTV_BASE + 0x012f, 0x0008 },
   222			{ USBTV_BASE + 0x0220, 0x002d },
   223			{ USBTV_BASE + 0x0225, 0x0028 },
   224			{ USBTV_BASE + 0x024e, 0x0008 },
   225			{ USBTV_BASE + 0x024f, 0x0002 },
   226			{ USBTV_BASE + 0x0254, 0x0069 },
   227			{ USBTV_BASE + 0x025a, 0x0016 },
   228			{ USBTV_BASE + 0x025b, 0x0035 },
   229			{ USBTV_BASE + 0x0263, 0x0021 },
   230			{ USBTV_BASE + 0x0266, 0x0016 },
   231			{ USBTV_BASE + 0x0267, 0x0036 },
   232			/* End image tuning */
   233			{ USBTV_BASE + 0x024e, 0x0002 },
   234			{ USBTV_BASE + 0x024f, 0x0002 },
   235		};
   236	
   237		ret = usbtv_configure_for_norm(usbtv, norm);
   238	
   239		if (!ret) {
   240			/* Masks for norms using a NTSC or PAL color encoding. */
   241			static const v4l2_std_id ntsc_mask =
   242				V4L2_STD_NTSC | V4L2_STD_NTSC_443;
   243			static const v4l2_std_id pal_mask =
   244				V4L2_STD_PAL | V4L2_STD_PAL_60 | V4L2_STD_PAL_M;
   245	
   246			if (norm & ntsc_mask)
   247				ret = usbtv_set_regs(usbtv, ntsc, ARRAY_SIZE(ntsc));
   248			else if (norm & pal_mask)
   249				ret = usbtv_set_regs(usbtv, pal, ARRAY_SIZE(pal));
   250			else if (norm & V4L2_STD_SECAM)
   251				ret = usbtv_set_regs(usbtv, secam, ARRAY_SIZE(secam));
   252			else
   253				ret = -EINVAL;
   254		}
   255	
   256		if (!ret) {
   257			/* Configure the decoder for the color standard */
   258			u16 cfg[][2] = {
   259				{ USBTV_BASE + 0x016f, usbtv_norm_to_16f_reg(norm) }
   260			};
 > 261			ret = usbtv_set_regs(usbtv, cfg, ARRAY_SIZE(cfg));
   262		}
   263	
   264		return ret;
   265	}
   266	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
