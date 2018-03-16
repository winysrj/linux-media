Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:47697 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751996AbeCPQkC (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Mar 2018 12:40:02 -0400
From: "Yeh, Andy" <andy.yeh@intel.com>
To: lkp <lkp@intel.com>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>
CC: "kbuild-all@01.org" <kbuild-all@01.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "tfiga@chromium.org" <tfiga@chromium.org>,
        "Chen, JasonX Z" <jasonx.z.chen@intel.com>,
        "Chiang, AlanX" <alanx.chiang@intel.com>,
        "Lai, Jim" <jim.lai@intel.com>
Subject: RE: [PATCH v8] media: imx258: Add imx258 camera sensor driver
Date: Fri, 16 Mar 2018 16:37:42 +0000
Message-ID: <8E0971CCB6EA9D41AF58191A2D3978B61D54E854@PGSMSX111.gar.corp.intel.com>
References: <1521044659-12598-1-git-send-email-andy.yeh@intel.com>
 <201803162216.TRtTPIDB%fengguang.wu@intel.com>
In-Reply-To: <201803162216.TRtTPIDB%fengguang.wu@intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ikp,

Per sync with Sakari, Mauro'd handle the pull request for "v4l2_find_nearest_size" patch (https://patchwork.kernel.org/patch/10207087/) early next week.
Hence only fixed a typo in v9.1. https://patchwork.linuxtv.org/patch/47976/
Thanks a lot!

Regards, Andy

-----Original Message-----
From: lkp 
Sent: Friday, March 16, 2018 10:14 PM
To: Yeh, Andy <andy.yeh@intel.com>
Cc: kbuild-all@01.org; linux-media@vger.kernel.org; tfiga@chromium.org; sakari.ailus@linux.intel.com; Yeh, Andy <andy.yeh@intel.com>; Chen, JasonX Z <jasonx.z.chen@intel.com>; Chiang, AlanX <alanx.chiang@intel.com>; Lai, Jim <jim.lai@intel.com>
Subject: Re: [PATCH v8] media: imx258: Add imx258 camera sensor driver

Hi Jason,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on linus/master]
[also build test ERROR on v4.16-rc5 next-20180316] [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Andy-Yeh/media-imx258-Add-imx258-camera-sensor-driver/20180316-201540
config: i386-allmodconfig (attached as .config)
compiler: gcc-7 (Debian 7.3.0-1) 7.3.0
reproduce:
        # save the attached .config to linux build tree
        make ARCH=i386 

All errors (new ones prefixed by >>):

   drivers/media/i2c/imx258.c: In function 'imx258_set_pad_format':
>> drivers/media/i2c/imx258.c:869:9: error: implicit declaration of 
>> function 'v4l2_find_nearest_size'; did you mean 
>> 'v4l2_find_nearest_format'? [-Werror=implicit-function-declaration]
     mode = v4l2_find_nearest_size(
            ^~~~~~~~~~~~~~~~~~~~~~
            v4l2_find_nearest_format
>> drivers/media/i2c/imx258.c:870:49: error: 'width' undeclared (first 
>> use in this function)
      supported_modes, ARRAY_SIZE(supported_modes), width, height,
                                                    ^~~~~
   drivers/media/i2c/imx258.c:870:49: note: each undeclared identifier is reported only once for each function it appears in
>> drivers/media/i2c/imx258.c:870:56: error: 'height' undeclared (first use in this function); did you mean 'hweight8'?
      supported_modes, ARRAY_SIZE(supported_modes), width, height,
                                                           ^~~~~~
                                                           hweight8
>> drivers/media/i2c/imx258.c:871:3: error: 'fmr' undeclared (first use in this function); did you mean 'fmt'?
      fmr->format.width, fmt->format.height);
      ^~~
      fmt
   cc1: some warnings being treated as errors

vim +869 drivers/media/i2c/imx258.c

   850	
   851	static int imx258_set_pad_format(struct v4l2_subdev *sd,
   852			       struct v4l2_subdev_pad_config *cfg,
   853			       struct v4l2_subdev_format *fmt)
   854	{
   855		struct imx258 *imx258 = to_imx258(sd);
   856		const struct imx258_mode *mode;
   857		struct v4l2_mbus_framefmt *framefmt;
   858		s32 vblank_def;
   859		s32 vblank_min;
   860		s64 h_blank;
   861		s64 pixel_rate;
   862		s64 link_freq;
   863	
   864		mutex_lock(&imx258->mutex);
   865	
   866		/* Only one raw bayer(GBRG) order is supported */
   867		fmt->format.code = MEDIA_BUS_FMT_SGRBG10_1X10;
   868	
 > 869		mode = v4l2_find_nearest_size(
 > 870			supported_modes, ARRAY_SIZE(supported_modes), width, height,
 > 871			fmr->format.width, fmt->format.height);
   872		imx258_update_pad_format(mode, fmt);
   873		if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
   874			framefmt = v4l2_subdev_get_try_format(sd, cfg, fmt->pad);
   875			*framefmt = fmt->format;
   876		} else {
   877			imx258->cur_mode = mode;
   878			__v4l2_ctrl_s_ctrl(imx258->link_freq, mode->link_freq_index);
   879	
   880			link_freq = link_freq_menu_items[mode->link_freq_index];
   881			pixel_rate = link_freq_to_pixel_rate(link_freq);
   882			__v4l2_ctrl_s_ctrl_int64(imx258->pixel_rate, pixel_rate);
   883			/* Update limits and set FPS to default */
   884			vblank_def = imx258->cur_mode->vts_def -
   885				     imx258->cur_mode->height;
   886			vblank_min = imx258->cur_mode->vts_min -
   887				     imx258->cur_mode->height;
   888			__v4l2_ctrl_modify_range(
   889				imx258->vblank, vblank_min,
   890				IMX258_VTS_MAX - imx258->cur_mode->height, 1,
   891				vblank_def);
   892			__v4l2_ctrl_s_ctrl(imx258->vblank, vblank_def);
   893			h_blank =
   894				link_freq_configs[mode->link_freq_index].pixels_per_line
   895				 - imx258->cur_mode->width;
   896			__v4l2_ctrl_modify_range(imx258->hblank, h_blank,
   897						 h_blank, 1, h_blank);
   898		}
   899	
   900		mutex_unlock(&imx258->mutex);
   901	
   902		return 0;
   903	}
   904	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
