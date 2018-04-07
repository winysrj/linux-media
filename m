Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:39160 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750807AbeDGFXj (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 7 Apr 2018 01:23:39 -0400
Date: Sat, 7 Apr 2018 13:23:03 +0800
From: kbuild test robot <lkp@intel.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: kbuild-all@01.org,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
Subject: Re: [PATCH 02/16] media: omap3isp: allow it to build with
 COMPILE_TEST
Message-ID: <201804071321.otUnZxqB%fengguang.wu@intel.com>
References: <f618981fec34acc5eee211b34a0018752634af9c.1522949748.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="jI8keyz6grp/JLjh"
Content-Disposition: inline
In-Reply-To: <f618981fec34acc5eee211b34a0018752634af9c.1522949748.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Mauro,

I love your patch! Yet something to improve:

[auto build test ERROR on linuxtv-media/master]
[also build test ERROR on v4.16 next-20180406]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Mauro-Carvalho-Chehab/Make-all-drivers-under-drivers-media-to-build-with-COMPILE_TEST/20180406-164215
base:   git://linuxtv.org/media_tree.git master
config: openrisc-allyesconfig (attached as .config)
compiler: or1k-linux-gcc (GCC) 6.0.0 20160327 (experimental)
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # save the attached .config to linux build tree
        make.cross ARCH=openrisc 

All errors (new ones prefixed by >>):

   In file included from drivers/media/platform/omap3isp/isp.c:78:0:
   drivers/media/platform/omap3isp/isp.h:130:16: error: field 'hw' has incomplete type
     struct clk_hw hw;
                   ^~
   In file included from include/asm-generic/bug.h:5:0,
                    from ./arch/openrisc/include/generated/asm/bug.h:1,
                    from include/linux/bug.h:5,
                    from include/linux/mmdebug.h:5,
                    from include/linux/mm.h:9,
                    from arch/openrisc/include/asm/cacheflush.h:21,
                    from drivers/media/platform/omap3isp/isp.c:45:
   drivers/media/platform/omap3isp/isp.c: In function 'isp_xclk_prepare':
   include/linux/kernel.h:938:32: error: dereferencing pointer to incomplete type 'struct clk_hw'
     BUILD_BUG_ON_MSG(!__same_type(*(ptr), ((type *)0)->member) && \
                                   ^~~~~~
   include/linux/compiler.h:316:19: note: in definition of macro '__compiletime_assert'
      bool __cond = !(condition);    \
                      ^~~~~~~~~
   include/linux/compiler.h:339:2: note: in expansion of macro '_compiletime_assert'
     _compiletime_assert(condition, msg, __compiletime_assert_, __LINE__)
     ^~~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:45:37: note: in expansion of macro 'compiletime_assert'
    #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
                                        ^~~~~~~~~~~~~~~~~~
   include/linux/kernel.h:938:2: note: in expansion of macro 'BUILD_BUG_ON_MSG'
     BUILD_BUG_ON_MSG(!__same_type(*(ptr), ((type *)0)->member) && \
     ^~~~~~~~~~~~~~~~
   include/linux/kernel.h:938:20: note: in expansion of macro '__same_type'
     BUILD_BUG_ON_MSG(!__same_type(*(ptr), ((type *)0)->member) && \
                       ^~~~~~~~~~~
   drivers/media/platform/omap3isp/isp.c:167:26: note: in expansion of macro 'container_of'
    #define to_isp_xclk(_hw) container_of(_hw, struct isp_xclk, hw)
                             ^~~~~~~~~~~~
   drivers/media/platform/omap3isp/isp.c:187:26: note: in expansion of macro 'to_isp_xclk'
     struct isp_xclk *xclk = to_isp_xclk(hw);
                             ^~~~~~~~~~~
   drivers/media/platform/omap3isp/isp.c: At top level:
   drivers/media/platform/omap3isp/isp.c:282:21: error: variable 'isp_xclk_ops' has initializer but incomplete type
    static const struct clk_ops isp_xclk_ops = {
                        ^~~~~~~
>> drivers/media/platform/omap3isp/isp.c:283:2: error: unknown field 'prepare' specified in initializer
     .prepare = isp_xclk_prepare,
     ^
   drivers/media/platform/omap3isp/isp.c:283:13: warning: excess elements in struct initializer
     .prepare = isp_xclk_prepare,
                ^~~~~~~~~~~~~~~~
   drivers/media/platform/omap3isp/isp.c:283:13: note: (near initialization for 'isp_xclk_ops')
>> drivers/media/platform/omap3isp/isp.c:284:2: error: unknown field 'unprepare' specified in initializer
     .unprepare = isp_xclk_unprepare,
     ^
   drivers/media/platform/omap3isp/isp.c:284:15: warning: excess elements in struct initializer
     .unprepare = isp_xclk_unprepare,
                  ^~~~~~~~~~~~~~~~~~
   drivers/media/platform/omap3isp/isp.c:284:15: note: (near initialization for 'isp_xclk_ops')
>> drivers/media/platform/omap3isp/isp.c:285:2: error: unknown field 'enable' specified in initializer
     .enable = isp_xclk_enable,
     ^
   drivers/media/platform/omap3isp/isp.c:285:12: warning: excess elements in struct initializer
     .enable = isp_xclk_enable,
               ^~~~~~~~~~~~~~~
   drivers/media/platform/omap3isp/isp.c:285:12: note: (near initialization for 'isp_xclk_ops')
>> drivers/media/platform/omap3isp/isp.c:286:2: error: unknown field 'disable' specified in initializer
     .disable = isp_xclk_disable,
     ^
   drivers/media/platform/omap3isp/isp.c:286:13: warning: excess elements in struct initializer
     .disable = isp_xclk_disable,
                ^~~~~~~~~~~~~~~~
   drivers/media/platform/omap3isp/isp.c:286:13: note: (near initialization for 'isp_xclk_ops')
>> drivers/media/platform/omap3isp/isp.c:287:2: error: unknown field 'recalc_rate' specified in initializer
     .recalc_rate = isp_xclk_recalc_rate,
     ^
   drivers/media/platform/omap3isp/isp.c:287:17: warning: excess elements in struct initializer
     .recalc_rate = isp_xclk_recalc_rate,
                    ^~~~~~~~~~~~~~~~~~~~
   drivers/media/platform/omap3isp/isp.c:287:17: note: (near initialization for 'isp_xclk_ops')
>> drivers/media/platform/omap3isp/isp.c:288:2: error: unknown field 'round_rate' specified in initializer
     .round_rate = isp_xclk_round_rate,
     ^
   drivers/media/platform/omap3isp/isp.c:288:16: warning: excess elements in struct initializer
     .round_rate = isp_xclk_round_rate,
                   ^~~~~~~~~~~~~~~~~~~
   drivers/media/platform/omap3isp/isp.c:288:16: note: (near initialization for 'isp_xclk_ops')
>> drivers/media/platform/omap3isp/isp.c:289:2: error: unknown field 'set_rate' specified in initializer
     .set_rate = isp_xclk_set_rate,
     ^
   drivers/media/platform/omap3isp/isp.c:289:14: warning: excess elements in struct initializer
     .set_rate = isp_xclk_set_rate,
                 ^~~~~~~~~~~~~~~~~
   drivers/media/platform/omap3isp/isp.c:289:14: note: (near initialization for 'isp_xclk_ops')
   drivers/media/platform/omap3isp/isp.c:294:21: error: variable 'isp_xclk_init_data' has initializer but incomplete type
    static const struct clk_init_data isp_xclk_init_data = {
                        ^~~~~~~~~~~~~
   drivers/media/platform/omap3isp/isp.c:295:2: error: unknown field 'name' specified in initializer
     .name = "cam_xclk",
     ^
   drivers/media/platform/omap3isp/isp.c:295:10: warning: excess elements in struct initializer
     .name = "cam_xclk",
             ^~~~~~~~~~
   drivers/media/platform/omap3isp/isp.c:295:10: note: (near initialization for 'isp_xclk_init_data')
   drivers/media/platform/omap3isp/isp.c:296:2: error: unknown field 'ops' specified in initializer
     .ops = &isp_xclk_ops,
     ^
   drivers/media/platform/omap3isp/isp.c:296:9: warning: excess elements in struct initializer
     .ops = &isp_xclk_ops,
            ^
   drivers/media/platform/omap3isp/isp.c:296:9: note: (near initialization for 'isp_xclk_init_data')
   drivers/media/platform/omap3isp/isp.c:297:2: error: unknown field 'parent_names' specified in initializer
     .parent_names = &isp_xclk_parent_name,
     ^
   drivers/media/platform/omap3isp/isp.c:297:18: warning: excess elements in struct initializer
     .parent_names = &isp_xclk_parent_name,
                     ^
   drivers/media/platform/omap3isp/isp.c:297:18: note: (near initialization for 'isp_xclk_init_data')
   drivers/media/platform/omap3isp/isp.c:298:2: error: unknown field 'num_parents' specified in initializer
     .num_parents = 1,
     ^
   drivers/media/platform/omap3isp/isp.c:298:17: warning: excess elements in struct initializer
     .num_parents = 1,
                    ^
   drivers/media/platform/omap3isp/isp.c:298:17: note: (near initialization for 'isp_xclk_init_data')
   drivers/media/platform/omap3isp/isp.c: In function 'isp_xclk_init':
   drivers/media/platform/omap3isp/isp.c:315:23: error: storage size of 'init' isn't known
     struct clk_init_data init;
                          ^~~~
>> drivers/media/platform/omap3isp/isp.c:341:15: error: implicit declaration of function 'clk_register' [-Werror=implicit-function-declaration]
      xclk->clk = clk_register(NULL, &xclk->hw);
                  ^~~~~~~~~~~~
>> drivers/media/platform/omap3isp/isp.c:347:3: error: implicit declaration of function 'of_clk_add_provider' [-Werror=implicit-function-declaration]
      of_clk_add_provider(np, isp_xclk_src_get, isp);
      ^~~~~~~~~~~~~~~~~~~
   drivers/media/platform/omap3isp/isp.c:315:23: warning: unused variable 'init' [-Wunused-variable]
     struct clk_init_data init;
                          ^~~~
   drivers/media/platform/omap3isp/isp.c: In function 'isp_xclk_cleanup':
>> drivers/media/platform/omap3isp/isp.c:358:3: error: implicit declaration of function 'of_clk_del_provider' [-Werror=implicit-function-declaration]
      of_clk_del_provider(np);
      ^~~~~~~~~~~~~~~~~~~
>> drivers/media/platform/omap3isp/isp.c:364:4: error: implicit declaration of function 'clk_unregister' [-Werror=implicit-function-declaration]
       clk_unregister(xclk->clk);
       ^~~~~~~~~~~~~~
   drivers/media/platform/omap3isp/isp.c: At top level:
   drivers/media/platform/omap3isp/isp.c:282:29: error: storage size of 'isp_xclk_ops' isn't known
    static const struct clk_ops isp_xclk_ops = {
                                ^~~~~~~~~~~~
   drivers/media/platform/omap3isp/isp.c:294:35: error: storage size of 'isp_xclk_init_data' isn't known
    static const struct clk_init_data isp_xclk_init_data = {
                                      ^~~~~~~~~~~~~~~~~~
   drivers/media/platform/omap3isp/isp.c:1020:13: warning: 'isp_resume_modules' defined but not used [-Wunused-function]
    static void isp_resume_modules(struct isp_device *isp)
                ^~~~~~~~~~~~~~~~~~
   drivers/media/platform/omap3isp/isp.c:986:12: warning: 'isp_suspend_modules' defined but not used [-Wunused-function]
    static int isp_suspend_modules(struct isp_device *isp)
               ^~~~~~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors

vim +/prepare +283 drivers/media/platform/omap3isp/isp.c

9b28ee3c Laurent Pinchart   2012-10-22  184  
9b28ee3c Laurent Pinchart   2012-10-22  185  static int isp_xclk_prepare(struct clk_hw *hw)
9b28ee3c Laurent Pinchart   2012-10-22  186  {
9b28ee3c Laurent Pinchart   2012-10-22 @187  	struct isp_xclk *xclk = to_isp_xclk(hw);
9b28ee3c Laurent Pinchart   2012-10-22  188  
9b28ee3c Laurent Pinchart   2012-10-22  189  	omap3isp_get(xclk->isp);
9b28ee3c Laurent Pinchart   2012-10-22  190  
9b28ee3c Laurent Pinchart   2012-10-22  191  	return 0;
9b28ee3c Laurent Pinchart   2012-10-22  192  }
9b28ee3c Laurent Pinchart   2012-10-22  193  
9b28ee3c Laurent Pinchart   2012-10-22  194  static void isp_xclk_unprepare(struct clk_hw *hw)
9b28ee3c Laurent Pinchart   2012-10-22  195  {
9b28ee3c Laurent Pinchart   2012-10-22  196  	struct isp_xclk *xclk = to_isp_xclk(hw);
9b28ee3c Laurent Pinchart   2012-10-22  197  
9b28ee3c Laurent Pinchart   2012-10-22  198  	omap3isp_put(xclk->isp);
9b28ee3c Laurent Pinchart   2012-10-22  199  }
9b28ee3c Laurent Pinchart   2012-10-22  200  
9b28ee3c Laurent Pinchart   2012-10-22  201  static int isp_xclk_enable(struct clk_hw *hw)
9b28ee3c Laurent Pinchart   2012-10-22  202  {
9b28ee3c Laurent Pinchart   2012-10-22  203  	struct isp_xclk *xclk = to_isp_xclk(hw);
9b28ee3c Laurent Pinchart   2012-10-22  204  	unsigned long flags;
9b28ee3c Laurent Pinchart   2012-10-22  205  
9b28ee3c Laurent Pinchart   2012-10-22  206  	spin_lock_irqsave(&xclk->lock, flags);
9b28ee3c Laurent Pinchart   2012-10-22  207  	isp_xclk_update(xclk, xclk->divider);
9b28ee3c Laurent Pinchart   2012-10-22  208  	xclk->enabled = true;
9b28ee3c Laurent Pinchart   2012-10-22  209  	spin_unlock_irqrestore(&xclk->lock, flags);
9b28ee3c Laurent Pinchart   2012-10-22  210  
9b28ee3c Laurent Pinchart   2012-10-22  211  	return 0;
9b28ee3c Laurent Pinchart   2012-10-22  212  }
9b28ee3c Laurent Pinchart   2012-10-22  213  
9b28ee3c Laurent Pinchart   2012-10-22  214  static void isp_xclk_disable(struct clk_hw *hw)
9b28ee3c Laurent Pinchart   2012-10-22  215  {
9b28ee3c Laurent Pinchart   2012-10-22  216  	struct isp_xclk *xclk = to_isp_xclk(hw);
9b28ee3c Laurent Pinchart   2012-10-22  217  	unsigned long flags;
9b28ee3c Laurent Pinchart   2012-10-22  218  
9b28ee3c Laurent Pinchart   2012-10-22  219  	spin_lock_irqsave(&xclk->lock, flags);
9b28ee3c Laurent Pinchart   2012-10-22  220  	isp_xclk_update(xclk, 0);
9b28ee3c Laurent Pinchart   2012-10-22  221  	xclk->enabled = false;
9b28ee3c Laurent Pinchart   2012-10-22  222  	spin_unlock_irqrestore(&xclk->lock, flags);
9b28ee3c Laurent Pinchart   2012-10-22  223  }
9b28ee3c Laurent Pinchart   2012-10-22  224  
9b28ee3c Laurent Pinchart   2012-10-22  225  static unsigned long isp_xclk_recalc_rate(struct clk_hw *hw,
9b28ee3c Laurent Pinchart   2012-10-22  226  					  unsigned long parent_rate)
9b28ee3c Laurent Pinchart   2012-10-22  227  {
9b28ee3c Laurent Pinchart   2012-10-22  228  	struct isp_xclk *xclk = to_isp_xclk(hw);
9b28ee3c Laurent Pinchart   2012-10-22  229  
9b28ee3c Laurent Pinchart   2012-10-22  230  	return parent_rate / xclk->divider;
9b28ee3c Laurent Pinchart   2012-10-22  231  }
9b28ee3c Laurent Pinchart   2012-10-22  232  
9b28ee3c Laurent Pinchart   2012-10-22  233  static u32 isp_xclk_calc_divider(unsigned long *rate, unsigned long parent_rate)
9b28ee3c Laurent Pinchart   2012-10-22  234  {
9b28ee3c Laurent Pinchart   2012-10-22  235  	u32 divider;
9b28ee3c Laurent Pinchart   2012-10-22  236  
9b28ee3c Laurent Pinchart   2012-10-22  237  	if (*rate >= parent_rate) {
9b28ee3c Laurent Pinchart   2012-10-22  238  		*rate = parent_rate;
9b28ee3c Laurent Pinchart   2012-10-22  239  		return ISPTCTRL_CTRL_DIV_BYPASS;
9b28ee3c Laurent Pinchart   2012-10-22  240  	}
9b28ee3c Laurent Pinchart   2012-10-22  241  
aadec012 Laurent Pinchart   2014-09-25  242  	if (*rate == 0)
aadec012 Laurent Pinchart   2014-09-25  243  		*rate = 1;
aadec012 Laurent Pinchart   2014-09-25  244  
9b28ee3c Laurent Pinchart   2012-10-22  245  	divider = DIV_ROUND_CLOSEST(parent_rate, *rate);
9b28ee3c Laurent Pinchart   2012-10-22  246  	if (divider >= ISPTCTRL_CTRL_DIV_BYPASS)
9b28ee3c Laurent Pinchart   2012-10-22  247  		divider = ISPTCTRL_CTRL_DIV_BYPASS - 1;
9b28ee3c Laurent Pinchart   2012-10-22  248  
9b28ee3c Laurent Pinchart   2012-10-22  249  	*rate = parent_rate / divider;
9b28ee3c Laurent Pinchart   2012-10-22  250  	return divider;
9b28ee3c Laurent Pinchart   2012-10-22  251  }
9b28ee3c Laurent Pinchart   2012-10-22  252  
9b28ee3c Laurent Pinchart   2012-10-22  253  static long isp_xclk_round_rate(struct clk_hw *hw, unsigned long rate,
9b28ee3c Laurent Pinchart   2012-10-22  254  				unsigned long *parent_rate)
9b28ee3c Laurent Pinchart   2012-10-22  255  {
9b28ee3c Laurent Pinchart   2012-10-22  256  	isp_xclk_calc_divider(&rate, *parent_rate);
9b28ee3c Laurent Pinchart   2012-10-22  257  	return rate;
9b28ee3c Laurent Pinchart   2012-10-22  258  }
9b28ee3c Laurent Pinchart   2012-10-22  259  
9b28ee3c Laurent Pinchart   2012-10-22  260  static int isp_xclk_set_rate(struct clk_hw *hw, unsigned long rate,
9b28ee3c Laurent Pinchart   2012-10-22  261  			     unsigned long parent_rate)
9b28ee3c Laurent Pinchart   2012-10-22  262  {
9b28ee3c Laurent Pinchart   2012-10-22  263  	struct isp_xclk *xclk = to_isp_xclk(hw);
9b28ee3c Laurent Pinchart   2012-10-22  264  	unsigned long flags;
9b28ee3c Laurent Pinchart   2012-10-22  265  	u32 divider;
9b28ee3c Laurent Pinchart   2012-10-22  266  
9b28ee3c Laurent Pinchart   2012-10-22  267  	divider = isp_xclk_calc_divider(&rate, parent_rate);
9b28ee3c Laurent Pinchart   2012-10-22  268  
9b28ee3c Laurent Pinchart   2012-10-22  269  	spin_lock_irqsave(&xclk->lock, flags);
9b28ee3c Laurent Pinchart   2012-10-22  270  
9b28ee3c Laurent Pinchart   2012-10-22  271  	xclk->divider = divider;
9b28ee3c Laurent Pinchart   2012-10-22  272  	if (xclk->enabled)
9b28ee3c Laurent Pinchart   2012-10-22  273  		isp_xclk_update(xclk, divider);
9b28ee3c Laurent Pinchart   2012-10-22  274  
9b28ee3c Laurent Pinchart   2012-10-22  275  	spin_unlock_irqrestore(&xclk->lock, flags);
9b28ee3c Laurent Pinchart   2012-10-22  276  
9b28ee3c Laurent Pinchart   2012-10-22  277  	dev_dbg(xclk->isp->dev, "%s: cam_xclk%c set to %lu Hz (div %u)\n",
9b28ee3c Laurent Pinchart   2012-10-22  278  		__func__, xclk->id == ISP_XCLK_A ? 'a' : 'b', rate, divider);
9b28ee3c Laurent Pinchart   2012-10-22  279  	return 0;
9b28ee3c Laurent Pinchart   2012-10-22  280  }
9b28ee3c Laurent Pinchart   2012-10-22  281  
9b28ee3c Laurent Pinchart   2012-10-22  282  static const struct clk_ops isp_xclk_ops = {
9b28ee3c Laurent Pinchart   2012-10-22 @283  	.prepare = isp_xclk_prepare,
9b28ee3c Laurent Pinchart   2012-10-22 @284  	.unprepare = isp_xclk_unprepare,
9b28ee3c Laurent Pinchart   2012-10-22 @285  	.enable = isp_xclk_enable,
9b28ee3c Laurent Pinchart   2012-10-22 @286  	.disable = isp_xclk_disable,
9b28ee3c Laurent Pinchart   2012-10-22 @287  	.recalc_rate = isp_xclk_recalc_rate,
9b28ee3c Laurent Pinchart   2012-10-22 @288  	.round_rate = isp_xclk_round_rate,
9b28ee3c Laurent Pinchart   2012-10-22 @289  	.set_rate = isp_xclk_set_rate,
9b28ee3c Laurent Pinchart   2012-10-22  290  };
9b28ee3c Laurent Pinchart   2012-10-22  291  
9b28ee3c Laurent Pinchart   2012-10-22  292  static const char *isp_xclk_parent_name = "cam_mclk";
9b28ee3c Laurent Pinchart   2012-10-22  293  
9b28ee3c Laurent Pinchart   2012-10-22  294  static const struct clk_init_data isp_xclk_init_data = {
9b28ee3c Laurent Pinchart   2012-10-22  295  	.name = "cam_xclk",
9b28ee3c Laurent Pinchart   2012-10-22  296  	.ops = &isp_xclk_ops,
9b28ee3c Laurent Pinchart   2012-10-22  297  	.parent_names = &isp_xclk_parent_name,
9b28ee3c Laurent Pinchart   2012-10-22 @298  	.num_parents = 1,
9b28ee3c Laurent Pinchart   2012-10-22  299  };
9b28ee3c Laurent Pinchart   2012-10-22  300  
64904b57 Laurent Pinchart   2015-03-25  301  static struct clk *isp_xclk_src_get(struct of_phandle_args *clkspec, void *data)
64904b57 Laurent Pinchart   2015-03-25  302  {
64904b57 Laurent Pinchart   2015-03-25  303  	unsigned int idx = clkspec->args[0];
64904b57 Laurent Pinchart   2015-03-25  304  	struct isp_device *isp = data;
64904b57 Laurent Pinchart   2015-03-25  305  
64904b57 Laurent Pinchart   2015-03-25  306  	if (idx >= ARRAY_SIZE(isp->xclks))
64904b57 Laurent Pinchart   2015-03-25  307  		return ERR_PTR(-ENOENT);
64904b57 Laurent Pinchart   2015-03-25  308  
64904b57 Laurent Pinchart   2015-03-25  309  	return isp->xclks[idx].clk;
64904b57 Laurent Pinchart   2015-03-25  310  }
64904b57 Laurent Pinchart   2015-03-25  311  
9b28ee3c Laurent Pinchart   2012-10-22  312  static int isp_xclk_init(struct isp_device *isp)
9b28ee3c Laurent Pinchart   2012-10-22  313  {
64904b57 Laurent Pinchart   2015-03-25  314  	struct device_node *np = isp->dev->of_node;
9b28ee3c Laurent Pinchart   2012-10-22 @315  	struct clk_init_data init;
9b28ee3c Laurent Pinchart   2012-10-22  316  	unsigned int i;
9b28ee3c Laurent Pinchart   2012-10-22  317  
f8e2ff26 Sylwester Nawrocki 2013-12-04  318  	for (i = 0; i < ARRAY_SIZE(isp->xclks); ++i)
f8e2ff26 Sylwester Nawrocki 2013-12-04  319  		isp->xclks[i].clk = ERR_PTR(-EINVAL);
f8e2ff26 Sylwester Nawrocki 2013-12-04  320  
9b28ee3c Laurent Pinchart   2012-10-22  321  	for (i = 0; i < ARRAY_SIZE(isp->xclks); ++i) {
9b28ee3c Laurent Pinchart   2012-10-22  322  		struct isp_xclk *xclk = &isp->xclks[i];
9b28ee3c Laurent Pinchart   2012-10-22  323  
9b28ee3c Laurent Pinchart   2012-10-22  324  		xclk->isp = isp;
9b28ee3c Laurent Pinchart   2012-10-22  325  		xclk->id = i == 0 ? ISP_XCLK_A : ISP_XCLK_B;
9b28ee3c Laurent Pinchart   2012-10-22  326  		xclk->divider = 1;
9b28ee3c Laurent Pinchart   2012-10-22  327  		spin_lock_init(&xclk->lock);
9b28ee3c Laurent Pinchart   2012-10-22  328  
9b28ee3c Laurent Pinchart   2012-10-22  329  		init.name = i == 0 ? "cam_xclka" : "cam_xclkb";
9b28ee3c Laurent Pinchart   2012-10-22  330  		init.ops = &isp_xclk_ops;
9b28ee3c Laurent Pinchart   2012-10-22  331  		init.parent_names = &isp_xclk_parent_name;
9b28ee3c Laurent Pinchart   2012-10-22  332  		init.num_parents = 1;
9b28ee3c Laurent Pinchart   2012-10-22  333  
9b28ee3c Laurent Pinchart   2012-10-22  334  		xclk->hw.init = &init;
f8e2ff26 Sylwester Nawrocki 2013-12-04  335  		/*
f8e2ff26 Sylwester Nawrocki 2013-12-04  336  		 * The first argument is NULL in order to avoid circular
f8e2ff26 Sylwester Nawrocki 2013-12-04  337  		 * reference, as this driver takes reference on the
f8e2ff26 Sylwester Nawrocki 2013-12-04  338  		 * sensor subdevice modules and the sensors would take
f8e2ff26 Sylwester Nawrocki 2013-12-04  339  		 * reference on this module through clk_get().
f8e2ff26 Sylwester Nawrocki 2013-12-04  340  		 */
f8e2ff26 Sylwester Nawrocki 2013-12-04 @341  		xclk->clk = clk_register(NULL, &xclk->hw);
f8e2ff26 Sylwester Nawrocki 2013-12-04  342  		if (IS_ERR(xclk->clk))
f8e2ff26 Sylwester Nawrocki 2013-12-04  343  			return PTR_ERR(xclk->clk);
9b28ee3c Laurent Pinchart   2012-10-22  344  	}
9b28ee3c Laurent Pinchart   2012-10-22  345  
64904b57 Laurent Pinchart   2015-03-25  346  	if (np)
64904b57 Laurent Pinchart   2015-03-25 @347  		of_clk_add_provider(np, isp_xclk_src_get, isp);
64904b57 Laurent Pinchart   2015-03-25  348  
9b28ee3c Laurent Pinchart   2012-10-22  349  	return 0;
9b28ee3c Laurent Pinchart   2012-10-22  350  }
9b28ee3c Laurent Pinchart   2012-10-22  351  
9b28ee3c Laurent Pinchart   2012-10-22  352  static void isp_xclk_cleanup(struct isp_device *isp)
9b28ee3c Laurent Pinchart   2012-10-22  353  {
64904b57 Laurent Pinchart   2015-03-25  354  	struct device_node *np = isp->dev->of_node;
9b28ee3c Laurent Pinchart   2012-10-22  355  	unsigned int i;
9b28ee3c Laurent Pinchart   2012-10-22  356  
64904b57 Laurent Pinchart   2015-03-25  357  	if (np)
64904b57 Laurent Pinchart   2015-03-25 @358  		of_clk_del_provider(np);
64904b57 Laurent Pinchart   2015-03-25  359  
9b28ee3c Laurent Pinchart   2012-10-22  360  	for (i = 0; i < ARRAY_SIZE(isp->xclks); ++i) {
9b28ee3c Laurent Pinchart   2012-10-22  361  		struct isp_xclk *xclk = &isp->xclks[i];
9b28ee3c Laurent Pinchart   2012-10-22  362  
f8e2ff26 Sylwester Nawrocki 2013-12-04  363  		if (!IS_ERR(xclk->clk))
f8e2ff26 Sylwester Nawrocki 2013-12-04 @364  			clk_unregister(xclk->clk);
9b28ee3c Laurent Pinchart   2012-10-22  365  	}
9b28ee3c Laurent Pinchart   2012-10-22  366  }
9b28ee3c Laurent Pinchart   2012-10-22  367  

:::::: The code at line 283 was first introduced by commit
:::::: 9b28ee3c9122cea62f2db02f5bb1e1606bb343a6 [media] omap3isp: Use the common clock framework

:::::: TO: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
:::::: CC: Mauro Carvalho Chehab <mchehab@redhat.com>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--jI8keyz6grp/JLjh
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--jI8keyz6grp/JLjh--
