Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:56940 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964912AbcDML3u (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Apr 2016 07:29:50 -0400
Date: Wed, 13 Apr 2016 19:29:02 +0800
From: kbuild test robot <lkp@intel.com>
To: Songjun Wu <songjun.wu@atmel.com>
Cc: kbuild-all@01.org, g.liakhovetski@gmx.de, nicolas.ferre@atmel.com,
	linux-arm-kernel@lists.infradead.org,
	Songjun Wu <songjun.wu@atmel.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
	Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>,
	Fabien Dessenne <fabien.dessenne@st.com>,
	Peter Griffin <peter.griffin@linaro.org>,
	Benoit Parrot <bparrot@ti.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Richard =?iso-8859-1?Q?R=F6jfors?= <richard@puffinpack.se>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/2] [media] atmel-isc: add the Image Sensor Controller
 code
Message-ID: <201604131955.rdR7pXLK%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="BXVAT5kNtrzKuDFl"
Content-Disposition: inline
In-Reply-To: <1460533460-32336-2-git-send-email-songjun.wu@atmel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--BXVAT5kNtrzKuDFl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Songjun,

[auto build test ERROR on linuxtv-media/master]
[also build test ERROR on v4.6-rc3 next-20160413]
[if your patch is applied to the wrong git tree, please drop us a note to help improving the system]

url:    https://github.com/0day-ci/linux/commits/Songjun-Wu/atmel-isc-add-driver-for-Atmel-ISC/20160413-155337
base:   git://linuxtv.org/media_tree.git master
config: sparc64-allmodconfig (attached as .config)
reproduce:
        wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # save the attached .config to linux build tree
        make.cross ARCH=sparc64 

All error/warnings (new ones prefixed by >>):

>> drivers/media/platform/atmel/atmel-isc.c:67:18: error: field 'hw' has incomplete type
     struct clk_hw   hw;
                     ^
   In file included from include/linux/list.h:8:0,
                    from include/linux/kobject.h:20,
                    from include/linux/of.h:21,
                    from drivers/media/platform/atmel/atmel-isc.c:27:
   drivers/media/platform/atmel/atmel-isc.c: In function 'isc_clk_enable':
   include/linux/kernel.h:824:48: warning: initialization from incompatible pointer type
     const typeof( ((type *)0)->member ) *__mptr = (ptr); \
                                                   ^
>> drivers/media/platform/atmel/atmel-isc.c:55:24: note: in expansion of macro 'container_of'
    #define to_isc_clk(hw) container_of(hw, struct isc_clk, hw)
                           ^
>> drivers/media/platform/atmel/atmel-isc.c:247:28: note: in expansion of macro 'to_isc_clk'
     struct isc_clk *isc_clk = to_isc_clk(hw);
                               ^
   include/linux/kernel.h:824:48: warning: (near initialization for 'isc_clk')
     const typeof( ((type *)0)->member ) *__mptr = (ptr); \
                                                   ^
>> drivers/media/platform/atmel/atmel-isc.c:55:24: note: in expansion of macro 'container_of'
    #define to_isc_clk(hw) container_of(hw, struct isc_clk, hw)
                           ^
>> drivers/media/platform/atmel/atmel-isc.c:247:28: note: in expansion of macro 'to_isc_clk'
     struct isc_clk *isc_clk = to_isc_clk(hw);
                               ^
   drivers/media/platform/atmel/atmel-isc.c: In function 'isc_clk_disable':
   include/linux/kernel.h:824:48: warning: initialization from incompatible pointer type
     const typeof( ((type *)0)->member ) *__mptr = (ptr); \
                                                   ^
>> drivers/media/platform/atmel/atmel-isc.c:55:24: note: in expansion of macro 'container_of'
    #define to_isc_clk(hw) container_of(hw, struct isc_clk, hw)
                           ^
   drivers/media/platform/atmel/atmel-isc.c:280:28: note: in expansion of macro 'to_isc_clk'
     struct isc_clk *isc_clk = to_isc_clk(hw);
                               ^
   include/linux/kernel.h:824:48: warning: (near initialization for 'isc_clk')
     const typeof( ((type *)0)->member ) *__mptr = (ptr); \
                                                   ^
>> drivers/media/platform/atmel/atmel-isc.c:55:24: note: in expansion of macro 'container_of'
    #define to_isc_clk(hw) container_of(hw, struct isc_clk, hw)
                           ^
   drivers/media/platform/atmel/atmel-isc.c:280:28: note: in expansion of macro 'to_isc_clk'
     struct isc_clk *isc_clk = to_isc_clk(hw);
                               ^
   drivers/media/platform/atmel/atmel-isc.c: In function 'isc_clk_is_enabled':
   include/linux/kernel.h:824:48: warning: initialization from incompatible pointer type
     const typeof( ((type *)0)->member ) *__mptr = (ptr); \
                                                   ^
>> drivers/media/platform/atmel/atmel-isc.c:55:24: note: in expansion of macro 'container_of'
    #define to_isc_clk(hw) container_of(hw, struct isc_clk, hw)
                           ^
   drivers/media/platform/atmel/atmel-isc.c:295:28: note: in expansion of macro 'to_isc_clk'
     struct isc_clk *isc_clk = to_isc_clk(hw);
                               ^
   include/linux/kernel.h:824:48: warning: (near initialization for 'isc_clk')
     const typeof( ((type *)0)->member ) *__mptr = (ptr); \
                                                   ^
>> drivers/media/platform/atmel/atmel-isc.c:55:24: note: in expansion of macro 'container_of'
    #define to_isc_clk(hw) container_of(hw, struct isc_clk, hw)
                           ^
   drivers/media/platform/atmel/atmel-isc.c:295:28: note: in expansion of macro 'to_isc_clk'
     struct isc_clk *isc_clk = to_isc_clk(hw);
                               ^
   drivers/media/platform/atmel/atmel-isc.c: In function 'isc_clk_recalc_rate':
   include/linux/kernel.h:824:48: warning: initialization from incompatible pointer type
     const typeof( ((type *)0)->member ) *__mptr = (ptr); \
                                                   ^
>> drivers/media/platform/atmel/atmel-isc.c:55:24: note: in expansion of macro 'container_of'
    #define to_isc_clk(hw) container_of(hw, struct isc_clk, hw)
                           ^
   drivers/media/platform/atmel/atmel-isc.c:309:28: note: in expansion of macro 'to_isc_clk'
     struct isc_clk *isc_clk = to_isc_clk(hw);
                               ^
   include/linux/kernel.h:824:48: warning: (near initialization for 'isc_clk')
     const typeof( ((type *)0)->member ) *__mptr = (ptr); \
                                                   ^
>> drivers/media/platform/atmel/atmel-isc.c:55:24: note: in expansion of macro 'container_of'
    #define to_isc_clk(hw) container_of(hw, struct isc_clk, hw)
                           ^
   drivers/media/platform/atmel/atmel-isc.c:309:28: note: in expansion of macro 'to_isc_clk'
     struct isc_clk *isc_clk = to_isc_clk(hw);
                               ^
   drivers/media/platform/atmel/atmel-isc.c: At top level:
>> drivers/media/platform/atmel/atmel-isc.c:315:14: warning: 'struct clk_rate_request' declared inside parameter list
          struct clk_rate_request *req)
                 ^
>> drivers/media/platform/atmel/atmel-isc.c:315:14: warning: its scope is only this definition or declaration, which is probably not what you want
   drivers/media/platform/atmel/atmel-isc.c: In function 'isc_clk_determine_rate':
>> drivers/media/platform/atmel/atmel-isc.c:324:2: error: implicit declaration of function 'clk_hw_get_num_parents' [-Werror=implicit-function-declaration]
     for (i = 0; i < clk_hw_get_num_parents(hw); i++) {
     ^
>> drivers/media/platform/atmel/atmel-isc.c:325:3: error: implicit declaration of function 'clk_hw_get_parent_by_index' [-Werror=implicit-function-declaration]
      parent = clk_hw_get_parent_by_index(hw, i);
      ^
>> drivers/media/platform/atmel/atmel-isc.c:325:10: warning: assignment makes pointer from integer without a cast
      parent = clk_hw_get_parent_by_index(hw, i);
             ^
>> drivers/media/platform/atmel/atmel-isc.c:329:3: error: implicit declaration of function 'clk_hw_get_rate' [-Werror=implicit-function-declaration]
      parent_rate = clk_hw_get_rate(parent);
      ^
   In file included from include/linux/list.h:8:0,
                    from include/linux/kobject.h:20,
                    from include/linux/of.h:21,
                    from drivers/media/platform/atmel/atmel-isc.c:27:
>> drivers/media/platform/atmel/atmel-isc.c:335:22: error: dereferencing pointer to incomplete type
       tmp_diff = abs(req->rate - tmp_rate);
                         ^
   include/linux/kernel.h:222:38: note: in definition of macro '__abs_choose_expr'
     __builtin_types_compatible_p(typeof(x),   signed type) || \
                                         ^
>> drivers/media/platform/atmel/atmel-isc.c:335:15: note: in expansion of macro 'abs'
       tmp_diff = abs(req->rate - tmp_rate);
                  ^
>> drivers/media/platform/atmel/atmel-isc.c:335:22: error: dereferencing pointer to incomplete type
       tmp_diff = abs(req->rate - tmp_rate);
                         ^
   include/linux/kernel.h:223:38: note: in definition of macro '__abs_choose_expr'
     __builtin_types_compatible_p(typeof(x), unsigned type),  \
                                         ^

vim +/hw +67 drivers/media/platform/atmel/atmel-isc.c

    21	 * CBC: Contrast and Brightness control
    22	 * SUB: This module performs YCbCr444 to YCbCr420 chrominance subsampling
    23	 * RLP: This module performs rounding, range limiting
    24	 *      and packing of the incoming data
    25	 */
    26	
  > 27	#include <linux/of.h>
    28	#include <linux/clk.h>
    29	#include <linux/clkdev.h>
    30	#include <linux/clk-provider.h>
    31	#include <linux/interrupt.h>
    32	#include <linux/module.h>
    33	#include <linux/platform_device.h>
    34	#include <linux/regmap.h>
    35	#include <linux/delay.h>
    36	#include <linux/videodev2.h>
    37	
    38	#include <media/v4l2-device.h>
    39	#include <media/v4l2-ioctl.h>
    40	#include <media/v4l2-of.h>
    41	#include <media/videobuf2-dma-contig.h>
    42	
    43	#include "atmel-isc-regs.h"
    44	
    45	#define ATMEL_ISC_NAME	  "atmel_isc"
    46	
    47	#define ISC_MAX_BUF_NUM		VIDEO_MAX_FRAME
    48	#define ISC_MAX_SUPPORT_WIDTH   2592
    49	#define ISC_MAX_SUPPORT_HEIGHT  1944
    50	
    51	#define ISC_ISPCK_SOURCE_MAX    2
    52	#define ISC_MCK_SOURCE_MAX      3
    53	#define ISC_CLK_MAX_DIV		255
    54	
  > 55	#define to_isc_clk(hw) container_of(hw, struct isc_clk, hw)
    56	
    57	static u32 sensor_preferred;
    58	
    59	static DEFINE_SPINLOCK(isc_clk_lock);
    60	
    61	enum isc_clk_id {
    62		ISC_ISPCK = 0,
    63		ISC_MCK = 1,
    64	};
    65	
    66	struct isc_clk {
  > 67		struct clk_hw   hw;
    68		struct clk      *clk;
    69		struct regmap   *regmap;
    70		spinlock_t      *lock;
    71		enum isc_clk_id id;
    72		u32		div;
    73		u8		parent_id;
    74	};
    75	
    76	struct isc_buffer {
    77		struct vb2_v4l2_buffer  vb;
    78		struct list_head	list;
    79	};
    80	
    81	struct isc_subdev_entity {
    82		struct v4l2_subdev		*sd;
    83		struct v4l2_async_subdev	*asd;
    84		struct v4l2_async_notifier      notifier;
    85	
    86		u32 hsync_active;
    87		u32 vsync_active;
    88		u32 pclk_sample;
    89	
    90		struct list_head list;
    91	};
    92	
    93	/*
    94	 * struct isc_format - ISC media bus format information
    95	 * @fourcc:		Fourcc code for this format
    96	 * @isc_mbus_code:      V4L2 media bus format code if ISC is preferred
    97	 * @sd_mbus_code:       V4L2 media bus format code if subdev is preferred
    98	 * @bpp:		Bytes per pixel (when stored in memory)
    99	 * @reg_sd_bps:		reg value for bits per sample if subdev is preferred
   100	 *			(when transferred over a bus)
   101	 * @reg_isc_bps:	reg value for bits per sample if ISC is preferred
   102	 *			(when transferred over a bus)
   103	 * @pipeline:		pipeline switch if ISC is preferred
   104	 * @isc_support:	ISC can convert raw format to this format
   105	 * @sd_support:		Subdev supports this format
   106	 */
   107	struct isc_format {
   108		u32	fourcc;
   109		u32	isc_mbus_code;
   110		u32	sd_mbus_code;
   111	
   112		u8	bpp;
   113	
   114		u32	reg_sd_bps;
   115		u32	reg_isc_bps;
   116	
   117		u32	reg_wb_cfg;
   118		u32	reg_cfa_cfg;
   119		u32	reg_rlp_mode;
   120		u32	reg_dcfg_imode;
   121		u32	reg_dctrl_dview;
   122	
   123		u32	pipeline;
   124	
   125		bool	isc_support;
   126		bool	sd_support;
   127	};
   128	
   129	struct isc_device {
   130		struct regmap		*regmap;
   131		struct clk		*hclock;
   132		struct clk		*ispck;
   133		struct isc_clk		isc_clks[2];
   134	
   135		struct device		*dev;
   136		struct v4l2_device	v4l2_dev;
   137		struct video_device	video_dev;
   138	
   139		struct vb2_queue	vb2_vidq;
   140		struct vb2_alloc_ctx	*alloc_ctx;
   141	
   142		spinlock_t		dma_queue_lock;
   143		struct list_head	dma_queue;
   144		struct isc_buffer	*cur_frm;
   145		unsigned int		sequence;
   146		bool			stop;
   147	
   148		struct v4l2_format	fmt;
   149	
   150		struct isc_format	**user_formats;
   151		int			num_user_formats;
   152		const struct isc_format	*current_fmt;
   153	
   154		struct mutex		lock;
   155	
   156		struct isc_subdev_entity	*current_subdev;
   157		struct list_head		subdev_entities;
   158	};
   159	
   160	struct reg_mask {
   161		u32 reg;
   162		u32 mask;
   163	};
   164	
   165	/* WB-->CFA-->CC-->GAM-->CSC-->CBC-->SUB422-->SUB420 */
   166	const struct reg_mask pipeline_regs[] = {
   167		{ ISC_WB_CTRL,  ISC_WB_CTRL_MASK },
   168		{ ISC_CFA_CTRL, ISC_CFA_CTRL_MASK },
   169		{ ISC_CC_CTRL,  ISC_CC_CTRL_MASK },
   170		{ ISC_GAM_CTRL, ISC_GAM_CTRL_MASK | ISC_GAM_CTRL_ALL_CHAN_MASK },
   171		{ ISC_CSC_CTRL, ISC_CSC_CTRL_MASK },
   172		{ ISC_CBC_CTRL, ISC_CBC_CTRL_MASK },
   173		{ ISC_SUB422_CTRL, ISC_SUB422_CTRL_MASK },
   174		{ ISC_SUB420_CTRL, ISC_SUB420_CTRL_MASK }
   175	};
   176	
   177	#define RAW_FMT_INDEX_START	0
   178	#define RAW_FMT_INDEX_END	11
   179	#define ISC_FMT_INDEX_START	12
   180	#define ISC_FMT_INDEX_END	12
   181	
   182	/*
   183	 * index(0~11):  raw formats.
   184	 * index(12~12): the formats which can be converted from raw format by ISC.
   185	 * index():      the formats which can only be provided by subdev.
   186	 */
   187	static struct isc_format isc_formats[] = {
   188	{V4L2_PIX_FMT_SBGGR8, MEDIA_BUS_FMT_SBGGR8_1X8, MEDIA_BUS_FMT_SBGGR8_1X8,
   189	1, ISC_PFE_CFG0_BPS_EIGHT, ISC_PFE_CFG0_BPS_EIGHT, ISC_WB_CFG_BAYCFG_BGBG,
   190	ISC_CFA_CFG_BAY_BGBG, ISC_RLP_CFG_MODE_DAT8, ISC_DCFG_IMODE_PACKED8,
   191	ISC_DCTRL_DVIEW_PACKED, 0x0, false, false},
   192	{V4L2_PIX_FMT_SGBRG8, MEDIA_BUS_FMT_SGBRG8_1X8, MEDIA_BUS_FMT_SGBRG8_1X8,
   193	1, ISC_PFE_CFG0_BPS_EIGHT, ISC_PFE_CFG0_BPS_EIGHT, ISC_WB_CFG_BAYCFG_GBGB,
   194	ISC_CFA_CFG_BAY_GBGB, ISC_RLP_CFG_MODE_DAT8, ISC_DCFG_IMODE_PACKED8,
   195	ISC_DCTRL_DVIEW_PACKED, 0x0, false, false},
   196	{V4L2_PIX_FMT_SGRBG8, MEDIA_BUS_FMT_SGRBG8_1X8, MEDIA_BUS_FMT_SGRBG8_1X8,
   197	1, ISC_PFE_CFG0_BPS_EIGHT, ISC_PFE_CFG0_BPS_EIGHT, ISC_WB_CFG_BAYCFG_GRGR,
   198	ISC_CFA_CFG_BAY_GRGR, ISC_RLP_CFG_MODE_DAT8, ISC_DCFG_IMODE_PACKED8,
   199	ISC_DCTRL_DVIEW_PACKED, 0x0, false, false},
   200	{V4L2_PIX_FMT_SRGGB8, MEDIA_BUS_FMT_SRGGB8_1X8, MEDIA_BUS_FMT_SRGGB8_1X8,
   201	1, ISC_PFE_CFG0_BPS_EIGHT, ISC_PFE_CFG0_BPS_EIGHT, ISC_WB_CFG_BAYCFG_RGRG,
   202	ISC_CFA_CFG_BAY_RGRG, ISC_RLP_CFG_MODE_DAT8, ISC_DCFG_IMODE_PACKED8,
   203	ISC_DCTRL_DVIEW_PACKED, 0x0, false, false},
   204	
   205	{V4L2_PIX_FMT_SBGGR10, MEDIA_BUS_FMT_SBGGR10_1X10, MEDIA_BUS_FMT_SBGGR10_1X10,
   206	2, ISC_PFG_CFG0_BPS_TEN, ISC_PFG_CFG0_BPS_TEN, ISC_WB_CFG_BAYCFG_BGBG,
   207	ISC_CFA_CFG_BAY_BGBG, ISC_RLP_CFG_MODE_DAT10, ISC_DCFG_IMODE_PACKED16,
   208	ISC_DCTRL_DVIEW_PACKED, 0x0, false, false},
   209	{V4L2_PIX_FMT_SGBRG10, MEDIA_BUS_FMT_SGBRG10_1X10, MEDIA_BUS_FMT_SGBRG10_1X10,
   210	2, ISC_PFG_CFG0_BPS_TEN, ISC_PFG_CFG0_BPS_TEN, ISC_WB_CFG_BAYCFG_GBGB,
   211	ISC_CFA_CFG_BAY_GBGB, ISC_RLP_CFG_MODE_DAT10, ISC_DCFG_IMODE_PACKED16,
   212	ISC_DCTRL_DVIEW_PACKED, 0x0, false, false},
   213	{V4L2_PIX_FMT_SGRBG10, MEDIA_BUS_FMT_SGRBG10_1X10, MEDIA_BUS_FMT_SGRBG10_1X10,
   214	2, ISC_PFG_CFG0_BPS_TEN, ISC_PFG_CFG0_BPS_TEN, ISC_WB_CFG_BAYCFG_GRGR,
   215	ISC_CFA_CFG_BAY_GRGR, ISC_RLP_CFG_MODE_DAT10, ISC_DCFG_IMODE_PACKED16,
   216	ISC_DCTRL_DVIEW_PACKED, 0x0, false, false},
   217	{V4L2_PIX_FMT_SRGGB10, MEDIA_BUS_FMT_SRGGB10_1X10, MEDIA_BUS_FMT_SRGGB10_1X10,
   218	2, ISC_PFG_CFG0_BPS_TEN, ISC_PFG_CFG0_BPS_TEN, ISC_WB_CFG_BAYCFG_RGRG,
   219	ISC_CFA_CFG_BAY_RGRG, ISC_RLP_CFG_MODE_DAT10, ISC_DCFG_IMODE_PACKED16,
   220	ISC_DCTRL_DVIEW_PACKED, 0x0, false, false},
   221	
   222	{V4L2_PIX_FMT_SBGGR12, MEDIA_BUS_FMT_SBGGR12_1X12, MEDIA_BUS_FMT_SBGGR12_1X12,
   223	2, ISC_PFG_CFG0_BPS_TWELVE, ISC_PFG_CFG0_BPS_TWELVE, ISC_WB_CFG_BAYCFG_BGBG,
   224	ISC_CFA_CFG_BAY_BGBG, ISC_RLP_CFG_MODE_DAT12, ISC_DCFG_IMODE_PACKED16,
   225	ISC_DCTRL_DVIEW_PACKED, 0x0, false, false},
   226	{V4L2_PIX_FMT_SGBRG12, MEDIA_BUS_FMT_SGBRG12_1X12, MEDIA_BUS_FMT_SGBRG12_1X12,
   227	2, ISC_PFG_CFG0_BPS_TWELVE, ISC_PFG_CFG0_BPS_TWELVE, ISC_WB_CFG_BAYCFG_GBGB,
   228	ISC_CFA_CFG_BAY_GBGB, ISC_RLP_CFG_MODE_DAT12, ISC_DCFG_IMODE_PACKED16,
   229	ISC_DCTRL_DVIEW_PACKED, 0x0, false, false},
   230	{V4L2_PIX_FMT_SGRBG12, MEDIA_BUS_FMT_SGRBG12_1X12, MEDIA_BUS_FMT_SGRBG12_1X12,
   231	2, ISC_PFG_CFG0_BPS_TWELVE, ISC_PFG_CFG0_BPS_TWELVE, ISC_WB_CFG_BAYCFG_GRGR,
   232	ISC_CFA_CFG_BAY_GRGR, ISC_RLP_CFG_MODE_DAT12, ISC_DCFG_IMODE_PACKED16,
   233	ISC_DCTRL_DVIEW_PACKED, 0x0, false, false},
   234	{V4L2_PIX_FMT_SRGGB12, MEDIA_BUS_FMT_SRGGB12_1X12, MEDIA_BUS_FMT_SRGGB12_1X12,
   235	2, ISC_PFG_CFG0_BPS_TWELVE, ISC_PFG_CFG0_BPS_TWELVE, ISC_WB_CFG_BAYCFG_RGRG,
   236	ISC_CFA_CFG_BAY_RGRG, ISC_RLP_CFG_MODE_DAT12, ISC_DCFG_IMODE_PACKED16,
   237	ISC_DCTRL_DVIEW_PACKED, 0x0, false, false},
   238	
   239	{V4L2_PIX_FMT_YUYV, MEDIA_BUS_FMT_YUYV8_2X8, MEDIA_BUS_FMT_YUYV8_2X8,
   240	2, ISC_PFE_CFG0_BPS_EIGHT, ISC_PFE_CFG0_BPS_EIGHT, ISC_WB_CFG_BAYCFG_BGBG,
   241	ISC_CFA_CFG_BAY_BGBG, ISC_RLP_CFG_MODE_DAT8, ISC_DCFG_IMODE_PACKED8,
   242	ISC_DCTRL_DVIEW_PACKED, 0x7f, false, false},
   243	};
   244	
   245	static int isc_clk_enable(struct clk_hw *hw)
   246	{
 > 247		struct isc_clk *isc_clk = to_isc_clk(hw);
   248		u32 id = isc_clk->id;
   249		struct regmap *regmap = isc_clk->regmap;
   250		unsigned long flags;

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--BXVAT5kNtrzKuDFl
Content-Type: application/octet-stream
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
0/J/0p33xtfLAgA=

--BXVAT5kNtrzKuDFl--
