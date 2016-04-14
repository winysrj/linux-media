Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:56900 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754749AbcDNOOh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Apr 2016 10:14:37 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Wu, Songjun" <songjun.wu@atmel.com>
Cc: kbuild test robot <lkp@intel.com>, kbuild-all@01.org,
	g.liakhovetski@gmx.de, nicolas.ferre@atmel.com,
	linux-arm-kernel@lists.infradead.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
	Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>,
	Fabien Dessenne <fabien.dessenne@st.com>,
	Peter Griffin <peter.griffin@linaro.org>,
	Benoit Parrot <bparrot@ti.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Richard =?ISO-8859-1?Q?R=F6jfors?= <richard@puffinpack.se>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/2] [media] atmel-isc: add the Image Sensor Controller code
Date: Thu, 14 Apr 2016 17:14:39 +0300
Message-ID: <2713229.ky9ZtMRYDK@avalon>
In-Reply-To: <570F2E3B.1090600@atmel.com>
References: <201604132310.zvahkw1X%fengguang.wu@intel.com> <570F2E3B.1090600@atmel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Songjun,

On Thursday 14 Apr 2016 13:44:27 Wu, Songjun wrote:
> The option 'CONFIG_COMMON_CLK=y' is needed to add to '.config'.
> But I do not validate, '.config' will be generated automatically and
> overwritten when it is changed.

Your driver's Kconfig entry should then contain "depends on COMMON_CLK".

> On 4/14/2016 00:01, kbuild test robot wrote:
> > Hi Songjun,
> > 
> > [auto build test ERROR on linuxtv-media/master]
> > [also build test ERROR on v4.6-rc3 next-20160413]
> > [if your patch is applied to the wrong git tree, please drop us a note to
> > help improving the system]
> > 
> > url:   
> > https://github.com/0day-ci/linux/commits/Songjun-Wu/atmel-isc-add-driver-> > for-Atmel-ISC/20160413-155337 base:   git://linuxtv.org/media_tree.git
> > master
> > config: powerpc-allyesconfig (attached as .config)
> > 
> > reproduce:
> >          wget
> >          https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/p
> >          lain/sbin/make.cross -O ~/bin/make.cross chmod +x
> >          ~/bin/make.cross
> >          # save the attached .config to linux build tree
> >          make.cross ARCH=powerpc
> > 
> > All errors (new ones prefixed by >>):
> >                      from include/linux/of.h:21,
> >     
> >                      from drivers/media/platform/atmel/atmel-isc.c:27:
> >     drivers/media/platform/atmel/atmel-isc.c: In function
> >     'isc_clk_enable':
> >     include/linux/kernel.h:824:48: error: initialization from incompatible
> >     pointer type [-Werror=incompatible-pointer-types]>     
> >       const typeof( ((type *)0)->member ) *__mptr = (ptr); \
> >       
> >                                                     ^
> >     
> >     drivers/media/platform/atmel/atmel-isc.c:55:24: note: in expansion of
> >     macro 'container_of'>     
> >      #define to_isc_clk(hw) container_of(hw, struct isc_clk, hw)
> >      
> >                             ^
> >     
> >     drivers/media/platform/atmel/atmel-isc.c:247:28: note: in expansion of
> >     macro 'to_isc_clk'>     
> >       struct isc_clk *isc_clk = to_isc_clk(hw);
> >       
> >                                 ^
> >     
> >     include/linux/kernel.h:824:48: note: (near initialization for
> >     'isc_clk')
> >     
> >       const typeof( ((type *)0)->member ) *__mptr = (ptr); \
> >       
> >                                                     ^
> >     
> >     drivers/media/platform/atmel/atmel-isc.c:55:24: note: in expansion of
> >     macro 'container_of'>     
> >      #define to_isc_clk(hw) container_of(hw, struct isc_clk, hw)
> >      
> >                             ^
> >     
> >     drivers/media/platform/atmel/atmel-isc.c:247:28: note: in expansion of
> >     macro 'to_isc_clk'>     
> >       struct isc_clk *isc_clk = to_isc_clk(hw);
> >       
> >                                 ^
> >     
> >     drivers/media/platform/atmel/atmel-isc.c: In function
> >     'isc_clk_disable':
> >     include/linux/kernel.h:824:48: error: initialization from incompatible
> >     pointer type [-Werror=incompatible-pointer-types]>     
> >       const typeof( ((type *)0)->member ) *__mptr = (ptr); \
> >       
> >                                                     ^
> >     
> >     drivers/media/platform/atmel/atmel-isc.c:55:24: note: in expansion of
> >     macro 'container_of'>     
> >      #define to_isc_clk(hw) container_of(hw, struct isc_clk, hw)
> >      
> >                             ^
> >     
> >     drivers/media/platform/atmel/atmel-isc.c:280:28: note: in expansion of
> >     macro 'to_isc_clk'>     
> >       struct isc_clk *isc_clk = to_isc_clk(hw);
> >       
> >                                 ^
> >     
> >     include/linux/kernel.h:824:48: note: (near initialization for
> >     'isc_clk')
> >     
> >       const typeof( ((type *)0)->member ) *__mptr = (ptr); \
> >       
> >                                                     ^
> >     
> >     drivers/media/platform/atmel/atmel-isc.c:55:24: note: in expansion of
> >     macro 'container_of'>     
> >      #define to_isc_clk(hw) container_of(hw, struct isc_clk, hw)
> >      
> >                             ^
> >     
> >     drivers/media/platform/atmel/atmel-isc.c:280:28: note: in expansion of
> >     macro 'to_isc_clk'>     
> >       struct isc_clk *isc_clk = to_isc_clk(hw);
> >       
> >                                 ^
> >     
> >     drivers/media/platform/atmel/atmel-isc.c: In function
> >     'isc_clk_is_enabled':
> >     include/linux/kernel.h:824:48: error: initialization from incompatible
> >     pointer type [-Werror=incompatible-pointer-types]>     
> >       const typeof( ((type *)0)->member ) *__mptr = (ptr); \
> >       
> >                                                     ^
> >     
> >     drivers/media/platform/atmel/atmel-isc.c:55:24: note: in expansion of
> >     macro 'container_of'>     
> >      #define to_isc_clk(hw) container_of(hw, struct isc_clk, hw)
> >      
> >                             ^
> >     
> >     drivers/media/platform/atmel/atmel-isc.c:295:28: note: in expansion of
> >     macro 'to_isc_clk'>     
> >       struct isc_clk *isc_clk = to_isc_clk(hw);
> >       
> >                                 ^
> >     
> >     include/linux/kernel.h:824:48: note: (near initialization for
> >     'isc_clk')
> >     
> >       const typeof( ((type *)0)->member ) *__mptr = (ptr); \
> >       
> >                                                     ^
> >     
> >     drivers/media/platform/atmel/atmel-isc.c:55:24: note: in expansion of
> >     macro 'container_of'>     
> >      #define to_isc_clk(hw) container_of(hw, struct isc_clk, hw)
> >      
> >                             ^
> >     
> >     drivers/media/platform/atmel/atmel-isc.c:295:28: note: in expansion of
> >     macro 'to_isc_clk'>     
> >       struct isc_clk *isc_clk = to_isc_clk(hw);
> >       
> >                                 ^
> >     
> >     drivers/media/platform/atmel/atmel-isc.c: In function
> >     'isc_clk_recalc_rate': include/linux/kernel.h:824:48: error:
> >     initialization from incompatible pointer type
> >     [-Werror=incompatible-pointer-types]>     
> >       const typeof( ((type *)0)->member ) *__mptr = (ptr); \
> >       
> >                                                     ^
> >     
> >     drivers/media/platform/atmel/atmel-isc.c:55:24: note: in expansion of
> >     macro 'container_of'>     
> >      #define to_isc_clk(hw) container_of(hw, struct isc_clk, hw)
> >      
> >                             ^
> >     
> >     drivers/media/platform/atmel/atmel-isc.c:309:28: note: in expansion of
> >     macro 'to_isc_clk'>     
> >       struct isc_clk *isc_clk = to_isc_clk(hw);
> >       
> >                                 ^
> >     
> >     include/linux/kernel.h:824:48: note: (near initialization for
> >     'isc_clk')
> >     
> >       const typeof( ((type *)0)->member ) *__mptr = (ptr); \
> >       
> >                                                     ^
> >     
> >     drivers/media/platform/atmel/atmel-isc.c:55:24: note: in expansion of
> >     macro 'container_of'>     
> >      #define to_isc_clk(hw) container_of(hw, struct isc_clk, hw)
> >      
> >                             ^
> >     
> >     drivers/media/platform/atmel/atmel-isc.c:309:28: note: in expansion of
> >     macro 'to_isc_clk'>     
> >       struct isc_clk *isc_clk = to_isc_clk(hw);
> >       
> >                                 ^
> >     
> >     drivers/media/platform/atmel/atmel-isc.c: At top level:
> >     drivers/media/platform/atmel/atmel-isc.c:315:14: warning: 'struct
> >     clk_rate_request' declared inside parameter list>     
> >            struct clk_rate_request *req)
> >            
> >                   ^
> >     
> >     drivers/media/platform/atmel/atmel-isc.c:315:14: warning: its scope is
> >     only this definition or declaration, which is probably not what you
> >     want drivers/media/platform/atmel/atmel-isc.c: In function
> >     'isc_clk_determine_rate':
> >     drivers/media/platform/atmel/atmel-isc.c:324:18: error: implicit
> >     declaration of function 'clk_hw_get_num_parents'
> >     [-Werror=implicit-function-declaration]>     
> >       for (i = 0; i < clk_hw_get_num_parents(hw); i++) {
> >       
> >                       ^
> >     
> >     drivers/media/platform/atmel/atmel-isc.c:325:12: error: implicit
> >     declaration of function 'clk_hw_get_parent_by_index'
> >     [-Werror=implicit-function-declaration]>     
> >        parent = clk_hw_get_parent_by_index(hw, i);
> >        
> >                 ^
> >     
> >     drivers/media/platform/atmel/atmel-isc.c:325:10: warning: assignment
> >     makes pointer from integer without a cast [-Wint-conversion]>     
> >        parent = clk_hw_get_parent_by_index(hw, i);
> >        
> >               ^
> >     
> >     drivers/media/platform/atmel/atmel-isc.c:329:17: error: implicit
> >     declaration of function 'clk_hw_get_rate'
> >     [-Werror=implicit-function-declaration]>     
> >        parent_rate = clk_hw_get_rate(parent);
> >        
> >                      ^
> >     
> >     In file included from include/linux/list.h:8:0,
> >     
> >                      from include/linux/kobject.h:20,
> >                      from include/linux/of.h:21,
> >>> 
> >                      from drivers/media/platform/atmel/atmel-isc.c:27:
> >>> drivers/media/platform/atmel/atmel-isc.c:335:22: error: dereferencing
> >>> pointer to incomplete type 'struct clk_rate_request'>>> 
> >         tmp_diff = abs(req->rate - tmp_rate);
> >         
> >                           ^
> >     
> >     include/linux/kernel.h:222:38: note: in definition of macro
> >     '__abs_choose_expr'>     
> >       __builtin_types_compatible_p(typeof(x),   signed type) || \
> >       
> >                                           ^
> >     
> >     drivers/media/platform/atmel/atmel-isc.c:335:15: note: in expansion of
> >     macro 'abs'>     
> >         tmp_diff = abs(req->rate - tmp_rate);
> >         
> >                    ^
> >     
> >     include/linux/kernel.h:216:3: error: first argument to
> >     '__builtin_choose_expr' not a constant>     
> >        __builtin_choose_expr(     \
> >        ^
> >     
> >     include/linux/kernel.h:224:54: note: in definition of macro
> >     '__abs_choose_expr'>     
> >       ({ signed type __x = (x); __x < 0 ? -__x : __x; }), other)
> >       
> >                                                           ^
> >     
> >     include/linux/kernel.h:212:3: note: in expansion of macro
> >     '__abs_choose_expr'>     
> >        __abs_choose_expr(x, long,    \
> >        ^
> >     
> >     include/linux/kernel.h:213:3: note: in expansion of macro
> >     '__abs_choose_expr'>     
> >        __abs_choose_expr(x, int,    \
> >        ^
> >     
> >     include/linux/kernel.h:214:3: note: in expansion of macro
> >     '__abs_choose_expr'>     
> >        __abs_choose_expr(x, short,    \
> >        ^
> >     
> >     include/linux/kernel.h:215:3: note: in expansion of macro
> >     '__abs_choose_expr'>     
> >        __abs_choose_expr(x, char,    \
> >        ^
> >     
> >     drivers/media/platform/atmel/atmel-isc.c:335:15: note: in expansion of
> >     macro 'abs'>     
> >         tmp_diff = abs(req->rate - tmp_rate);
> >         
> >                    ^
> >     
> >     include/linux/kernel.h:221:43: error: first argument to
> >     '__builtin_choose_expr' not a constant>     
> >      #define __abs_choose_expr(x, type, other) __builtin_choose_expr( \
> >      
> >                                                ^
> >     
> >     include/linux/kernel.h:224:54: note: in definition of macro
> >     '__abs_choose_expr'>     
> >       ({ signed type __x = (x); __x < 0 ? -__x : __x; }), other)
> >       
> >                                                           ^
> >     
> >     include/linux/kernel.h:212:3: note: in expansion of macro
> >     '__abs_choose_expr'>     
> >        __abs_choose_expr(x, long,    \
> >        ^
> >     
> >     include/linux/kernel.h:213:3: note: in expansion of macro
> >     '__abs_choose_expr'>     
> >        __abs_choose_expr(x, int,    \
> >        ^
> >     
> >     include/linux/kernel.h:214:3: note: in expansion of macro
> >     '__abs_choose_expr'>     
> >        __abs_choose_expr(x, short,    \
> >        ^
> >     
> >     include/linux/kernel.h:215:3: note: in expansion of macro
> >     '__abs_choose_expr'>     
> >        __abs_choose_expr(x, char,    \
> >        ^
> >     
> >     drivers/media/platform/atmel/atmel-isc.c:335:15: note: in expansion of
> >     macro 'abs'>     
> >         tmp_diff = abs(req->rate - tmp_rate);
> >         
> >                    ^
> >     
> >     include/linux/kernel.h:221:43: error: first argument to
> >     '__builtin_choose_expr' not a constant>     
> >      #define __abs_choose_expr(x, type, other) __builtin_choose_expr( \
> >      
> >                                                ^
> >     
> >     include/linux/kernel.h:224:54: note: in definition of macro
> >     '__abs_choose_expr'>     
> >       ({ signed type __x = (x); __x < 0 ? -__x : __x; }), other)
> >       
> >                                                           ^
> >     
> >     include/linux/kernel.h:212:3: note: in expansion of macro
> >     '__abs_choose_expr'>     
> >        __abs_choose_expr(x, long,    \
> >        ^
> >     
> >     include/linux/kernel.h:213:3: note: in expansion of macro
> >     '__abs_choose_expr'>     
> >        __abs_choose_expr(x, int,    \
> >        ^
> >     
> >     include/linux/kernel.h:214:3: note: in expansion of macro
> >     '__abs_choose_expr'>     
> >        __abs_choose_expr(x, short,    \
> >        ^
> >     
> >     drivers/media/platform/atmel/atmel-isc.c:335:15: note: in expansion of
> >     macro 'abs'>     
> >         tmp_diff = abs(req->rate - tmp_rate);
> >         
> >                    ^
> >     
> >     include/linux/kernel.h:221:43: error: first argument to
> >     '__builtin_choose_expr' not a constant>     
> >      #define __abs_choose_expr(x, type, other) __builtin_choose_expr( \
> >      
> >                                                ^
> >     
> >     include/linux/kernel.h:224:54: note: in definition of macro
> >     '__abs_choose_expr'>     
> >       ({ signed type __x = (x); __x < 0 ? -__x : __x; }), other)
> >       
> >                                                           ^
> >     
> >     include/linux/kernel.h:212:3: note: in expansion of macro
> >     '__abs_choose_expr'>     
> >        __abs_choose_expr(x, long,    \
> >        ^
> >     
> >     include/linux/kernel.h:213:3: note: in expansion of macro
> >     '__abs_choose_expr'>     
> >        __abs_choose_expr(x, int,    \
> >        ^
> >     
> >     drivers/media/platform/atmel/atmel-isc.c:335:15: note: in expansion of
> >     macro 'abs'>     
> >         tmp_diff = abs(req->rate - tmp_rate);
> >         
> >                    ^
> >     
> >     include/linux/kernel.h:221:43: error: first argument to
> >     '__builtin_choose_expr' not a constant>     
> >      #define __abs_choose_expr(x, type, other) __builtin_choose_expr( \
> >      
> >                                                ^
> >     
> >     include/linux/kernel.h:224:54: note: in definition of macro
> >     '__abs_choose_expr'>     
> >       ({ signed type __x = (x); __x < 0 ? -__x : __x; }), other)
> >       
> >                                                           ^
> >     
> >     include/linux/kernel.h:212:3: note: in expansion of macro
> >     '__abs_choose_expr'>     
> >        __abs_choose_expr(x, long,    \
> >        ^
> >     
> >     drivers/media/platform/atmel/atmel-isc.c:335:15: note: in expansion of
> >     macro 'abs'>     
> >         tmp_diff = abs(req->rate - tmp_rate);
> >         
> >                    ^
> >     
> >     include/linux/kernel.h:221:43: error: first argument to
> >     '__builtin_choose_expr' not a constant>     
> >      #define __abs_choose_expr(x, type, other) __builtin_choose_expr( \
> >      
> >                                                ^
> >     
> >     include/linux/kernel.h:211:16: note: in expansion of macro
> >     '__abs_choose_expr'>     
> >      #define abs(x) __abs_choose_expr(x, long long,    \
> >      
> >                     ^
> >     
> >     drivers/media/platform/atmel/atmel-isc.c:335:15: note: in expansion of
> >     macro 'abs'>     
> >         tmp_diff = abs(req->rate - tmp_rate);
> >         
> >                    ^
> >     
> >     In file included from include/linux/printk.h:277:0,
> >     
> >                      from include/linux/kernel.h:13,
> >                      from include/linux/list.h:8,
> >                      from include/linux/kobject.h:20,
> >                      from include/linux/of.h:21,
> >>> 
> >                      from drivers/media/platform/atmel/atmel-isc.c:27:
> >>> drivers/media/platform/atmel/atmel-isc.c:354:4: error: implicit
> >>> declaration of function '__clk_get_name'
> >>> [-Werror=implicit-function-declaration]>>> 
> >         __clk_get_name((req->best_parent_hw)->clk),
> >         ^
> >     
> >     include/linux/dynamic_debug.h:79:10: note: in definition of macro
> >     'dynamic_pr_debug'>     
> >             ##__VA_ARGS__);  \
> >             
> >               ^
> >     
> >     drivers/media/platform/atmel/atmel-isc.c:352:2: note: in expansion of
> >     macro 'pr_debug'>     
> >       pr_debug("ISC CLK: %s, best_rate = %ld, parent clk: %s @ %ld\n",
> >       ^
> >     
> >     In file included from include/linux/list.h:8:0,
> >     
> >                      from include/linux/kobject.h:20,
> >                      from include/linux/of.h:21,
> >     
> >                      from drivers/media/platform/atmel/atmel-isc.c:27:
> >     drivers/media/platform/atmel/atmel-isc.c: In function
> >     'isc_clk_set_parent':
> >     include/linux/kernel.h:824:48: error: initialization from incompatible
> >     pointer type [-Werror=incompatible-pointer-types]>     
> >       const typeof( ((type *)0)->member ) *__mptr = (ptr); \
> >       
> >                                                     ^
> >     
> >     drivers/media/platform/atmel/atmel-isc.c:55:24: note: in expansion of
> >     macro 'container_of'>     
> >      #define to_isc_clk(hw) container_of(hw, struct isc_clk, hw)
> >      
> >                             ^
> >     
> >     drivers/media/platform/atmel/atmel-isc.c:367:28: note: in expansion of
> >     macro 'to_isc_clk'>     
> >       struct isc_clk *isc_clk = to_isc_clk(hw);
> >       
> >                                 ^
> >     
> >     include/linux/kernel.h:824:48: note: (near initialization for
> >     'isc_clk')
> >     
> >       const typeof( ((type *)0)->member ) *__mptr = (ptr); \
> >       
> >                                                     ^
> >     
> >     drivers/media/platform/atmel/atmel-isc.c:55:24: note: in expansion of
> >     macro 'container_of'>     
> >      #define to_isc_clk(hw) container_of(hw, struct isc_clk, hw)
> >      
> >                             ^
> >     
> >     drivers/media/platform/atmel/atmel-isc.c:367:28: note: in expansion of
> >     macro 'to_isc_clk'>     
> >       struct isc_clk *isc_clk = to_isc_clk(hw);
> >       
> >                                 ^
> >     
> >     drivers/media/platform/atmel/atmel-isc.c: In function
> >     'isc_clk_get_parent':
> >     include/linux/kernel.h:824:48: error: initialization from incompatible
> >     pointer type [-Werror=incompatible-pointer-types]>     
> >       const typeof( ((type *)0)->member ) *__mptr = (ptr); \
> >       
> >                                                     ^
> >     
> >     drivers/media/platform/atmel/atmel-isc.c:55:24: note: in expansion of
> >     macro 'container_of'>     
> >      #define to_isc_clk(hw) container_of(hw, struct isc_clk, hw)
> >      
> >                             ^
> >     
> >     drivers/media/platform/atmel/atmel-isc.c:379:28: note: in expansion of
> >     macro 'to_isc_clk'>     
> >       struct isc_clk *isc_clk = to_isc_clk(hw);
> >       
> >                                 ^
> >     
> >     include/linux/kernel.h:824:48: note: (near initialization for
> >     'isc_clk')
> >     
> >       const typeof( ((type *)0)->member ) *__mptr = (ptr); \
> >       
> >                                                     ^
> >     
> >     drivers/media/platform/atmel/atmel-isc.c:55:24: note: in expansion of
> >     macro 'container_of'>     
> >      #define to_isc_clk(hw) container_of(hw, struct isc_clk, hw)
> >      
> >                             ^
> >     
> >     drivers/media/platform/atmel/atmel-isc.c:379:28: note: in expansion of
> >     macro 'to_isc_clk'>     
> >       struct isc_clk *isc_clk = to_isc_clk(hw);
> >       
> >                                 ^
> >     
> >     drivers/media/platform/atmel/atmel-isc.c: In function
> >     'isc_clk_set_rate':
> >     include/linux/kernel.h:824:48: error: initialization from incompatible
> >     pointer type [-Werror=incompatible-pointer-types]>     
> >       const typeof( ((type *)0)->member ) *__mptr = (ptr); \
> >       
> >                                                     ^
> >     
> >     drivers/media/platform/atmel/atmel-isc.c:55:24: note: in expansion of
> >     macro 'container_of'>     
> >      #define to_isc_clk(hw) container_of(hw, struct isc_clk, hw)
> >      
> >                             ^
> >     
> >     drivers/media/platform/atmel/atmel-isc.c:388:28: note: in expansion of
> >     macro 'to_isc_clk'>     
> >       struct isc_clk *isc_clk = to_isc_clk(hw);
> >       
> >                                 ^
> >     
> >     include/linux/kernel.h:824:48: note: (near initialization for
> >     'isc_clk')
> >     
> >       const typeof( ((type *)0)->member ) *__mptr = (ptr); \
> >       
> >                                                     ^
> >     
> >     drivers/media/platform/atmel/atmel-isc.c:55:24: note: in expansion of
> >     macro 'container_of'>     
> >      #define to_isc_clk(hw) container_of(hw, struct isc_clk, hw)
> >      
> >                             ^
> >     
> >     drivers/media/platform/atmel/atmel-isc.c:388:28: note: in expansion of
> >     macro 'to_isc_clk'>     
> >       struct isc_clk *isc_clk = to_isc_clk(hw);
> >       
> >                                 ^
> >     
> >     drivers/media/platform/atmel/atmel-isc.c: At top level:
> >     drivers/media/platform/atmel/atmel-isc.c:403:21: error: variable
> >     'isc_clk_ops' has initializer but incomplete type>     
> >      static const struct clk_ops isc_clk_ops = {
> >      
> >                          ^
> >     
> >     drivers/media/platform/atmel/atmel-isc.c:404:2: error: unknown field
> >     'enable' specified in initializer>     
> >       .enable  = isc_clk_enable,
> >       ^
> >     
> >     drivers/media/platform/atmel/atmel-isc.c:404:13: warning: excess
> >     elements in struct initializer>     
> >       .enable  = isc_clk_enable,
> >       
> >                  ^
> >     
> >     drivers/media/platform/atmel/atmel-isc.c:404:13: note: (near
> >     initialization for 'isc_clk_ops')
> >     drivers/media/platform/atmel/atmel-isc.c:405:2: error: unknown field
> >     'disable' specified in initializer>     
> >       .disable = isc_clk_disable,
> >       ^
> >     
> >     drivers/media/platform/atmel/atmel-isc.c:405:13: warning: excess
> >     elements in struct initializer>     
> >       .disable = isc_clk_disable,
> >       
> >                  ^
> >     
> >     drivers/media/platform/atmel/atmel-isc.c:405:13: note: (near
> >     initialization for 'isc_clk_ops')
> >     drivers/media/platform/atmel/atmel-isc.c:406:2: error: unknown field
> >     'is_enabled' specified in initializer>     
> >       .is_enabled = isc_clk_is_enabled,
> >       ^
> >     
> >     drivers/media/platform/atmel/atmel-isc.c:406:16: warning: excess
> >     elements in struct initializer>     
> >       .is_enabled = isc_clk_is_enabled,
> >       
> >                     ^
> >     
> >     drivers/media/platform/atmel/atmel-isc.c:406:16: note: (near
> >     initialization for 'isc_clk_ops')
> >     drivers/media/platform/atmel/atmel-isc.c:407:2: error: unknown field
> >     'recalc_rate' specified in initializer>     
> >       .recalc_rate = isc_clk_recalc_rate,
> >       ^
> >     
> >     drivers/media/platform/atmel/atmel-isc.c:407:17: warning: excess
> >     elements in struct initializer>     
> >       .recalc_rate = isc_clk_recalc_rate,
> >       
> >                      ^
> > 
> > vim +335 drivers/media/platform/atmel/atmel-isc.c
> > 
> >     323
> >     324		for (i = 0; i < clk_hw_get_num_parents(hw); i++) {
> >     325			parent = clk_hw_get_parent_by_index(hw, i);
> >     326			if (!parent)
> >     327				continue;
> >     328
> >     
> >   > 329			parent_rate = clk_hw_get_rate(parent);
> >   > 
> >     330			if (!parent_rate)
> >     331				continue;
> >     332
> >     333			for (div = 1; div < ISC_CLK_MAX_DIV + 2; div++) {
> >     334				tmp_rate = DIV_ROUND_CLOSEST(parent_rate, div);
> >     
> >   > 335				tmp_diff = abs(req->rate - tmp_rate);
> >   > 
> >     336
> >     337				if (best_diff < 0 || best_diff > tmp_diff) {
> >     338					best_rate = tmp_rate;
> >     339					best_diff = tmp_diff;
> >     340					req->best_parent_rate = parent_rate;
> >     341					req->best_parent_hw = parent;
> >     342				}
> >     343
> >     344				if (!best_diff || tmp_rate < req->rate)
> >     345					break;
> >     346			}
> >     347
> >     348			if (!best_diff)
> >     349				break;
> >     350		}
> >     351
> >     352		pr_debug("ISC CLK: %s, best_rate = %ld, parent clk: %s @ 
%ld\n",
> >     353			 __func__, best_rate,
> >     
> >   > 354			 __clk_get_name((req->best_parent_hw)->clk),
> >   > 
> >     355			 req->best_parent_rate);
> >     356
> >     357		if (best_rate < 0)
> > 
> > ---
> > 0-DAY kernel test infrastructure                Open Source Technology
> > Center https://lists.01.org/pipermail/kbuild-all                   Intel
> > Corporation

-- 
Regards,

Laurent Pinchart

