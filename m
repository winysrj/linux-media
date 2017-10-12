Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:21647 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751496AbdJLVBm (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Oct 2017 17:01:42 -0400
Date: Fri, 13 Oct 2017 05:01:04 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: kbuild-all@01.org, linux-media@vger.kernel.org,
        Shuah Khan <shuahkh@osg.samsung.com>
Subject: [ragnatech:media-tree 2742/2771]
 drivers/media//dvb-core/dvb_frontend.c:2447:1: warning: the frame size of
 1048 bytes is larger than 1024 bytes
Message-ID: <201710130555.XXHdTGuS%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="WIyZ46R2i8wDzkSu"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   git://git.ragnatech.se/linux media-tree
head:   8382e556b1a2f30c4bf866f021b33577a64f9ebf
commit: d73dcf0cdb95a47f7e4e991ab63dd30f6eb67b4e [2742/2771] media: dvb_frontend: cleanup ioctl handling logic
config: i386-randconfig-h1-10130413 (attached as .config)
compiler: gcc-6 (Debian 6.2.0-3) 6.2.0 20160901
reproduce:
        git checkout d73dcf0cdb95a47f7e4e991ab63dd30f6eb67b4e
        # save the attached .config to linux build tree
        make ARCH=i386 

All warnings (new ones prefixed by >>):

   Cyclomatic Complexity 5 include/linux/compiler.h:__read_once_size
   Cyclomatic Complexity 5 include/linux/compiler.h:__write_once_size
   Cyclomatic Complexity 1 arch/x86/include/asm/bitops.h:constant_test_bit
   Cyclomatic Complexity 1 arch/x86/include/asm/bitops.h:variable_test_bit
   Cyclomatic Complexity 1 arch/x86/include/asm/bitops.h:fls
   Cyclomatic Complexity 1 include/linux/log2.h:__ilog2_u32
   Cyclomatic Complexity 3 include/linux/log2.h:is_power_of_2
   Cyclomatic Complexity 1 arch/x86/include/asm/atomic.h:atomic_read
   Cyclomatic Complexity 1 arch/x86/include/asm/atomic.h:atomic_set
   Cyclomatic Complexity 1 arch/x86/include/asm/atomic.h:atomic_inc
   Cyclomatic Complexity 1 arch/x86/include/asm/atomic.h:atomic_dec_and_test
   Cyclomatic Complexity 1 arch/x86/include/asm/current.h:get_current
   Cyclomatic Complexity 1 include/asm-generic/getorder.h:__get_order
   Cyclomatic Complexity 1 include/linux/err.h:PTR_ERR
   Cyclomatic Complexity 1 include/linux/err.h:IS_ERR
   Cyclomatic Complexity 2 include/linux/thread_info.h:test_ti_thread_flag
   Cyclomatic Complexity 2 include/linux/thread_info.h:check_object_size
   Cyclomatic Complexity 2 include/linux/thread_info.h:copy_overflow
   Cyclomatic Complexity 4 include/linux/thread_info.h:check_copy_size
   Cyclomatic Complexity 70 include/linux/ktime.h:ktime_divns
   Cyclomatic Complexity 1 include/linux/ktime.h:ktime_to_us
   Cyclomatic Complexity 1 include/linux/ktime.h:ktime_us_delta
   Cyclomatic Complexity 1 include/linux/ktime.h:ktime_add_us
   Cyclomatic Complexity 1 include/linux/timekeeping.h:ktime_get_boottime
   Cyclomatic Complexity 1 include/linux/refcount.h:refcount_set
   Cyclomatic Complexity 1 include/linux/refcount.h:refcount_inc
   Cyclomatic Complexity 1 include/linux/refcount.h:refcount_dec_and_test
   Cyclomatic Complexity 1 include/linux/sched.h:task_thread_info
   Cyclomatic Complexity 1 include/linux/sched.h:test_tsk_thread_flag
   Cyclomatic Complexity 1 include/linux/sched/signal.h:signal_pending
   Cyclomatic Complexity 1 include/linux/kasan.h:kasan_kmalloc
   Cyclomatic Complexity 28 include/linux/slab.h:kmalloc_index
   Cyclomatic Complexity 1 include/linux/slab.h:kmem_cache_alloc_trace
   Cyclomatic Complexity 1 include/linux/slab.h:kmalloc_order_trace
   Cyclomatic Complexity 67 include/linux/slab.h:kmalloc_large
   Cyclomatic Complexity 5 include/linux/slab.h:kmalloc
   Cyclomatic Complexity 1 include/linux/slab.h:kzalloc
   Cyclomatic Complexity 1 include/linux/semaphore.h:sema_init
   Cyclomatic Complexity 2 include/linux/uaccess.h:copy_to_user
   Cyclomatic Complexity 4 include/linux/poll.h:poll_wait
   Cyclomatic Complexity 1 include/linux/kref.h:kref_init
   Cyclomatic Complexity 1 include/linux/kref.h:kref_get
   Cyclomatic Complexity 2 include/linux/kref.h:kref_put
   Cyclomatic Complexity 2 include/linux/freezer.h:freezing
   Cyclomatic Complexity 2 include/linux/freezer.h:try_to_freeze_unsafe
   Cyclomatic Complexity 2 include/linux/freezer.h:try_to_freeze
   Cyclomatic Complexity 1 drivers/media//dvb-core/dvb_frontend.c:dvb_frontend_put
   Cyclomatic Complexity 1 drivers/media//dvb-core/dvb_frontend.c:dvb_frontend_get
   Cyclomatic Complexity 1 drivers/media//dvb-core/dvb_frontend.c:has_get_frontend
   Cyclomatic Complexity 5 drivers/media//dvb-core/dvb_frontend.c:dvbv3_type
   Cyclomatic Complexity 5 drivers/media//dvb-core/dvb_frontend.c:dvb_frontend_init
   Cyclomatic Complexity 2 drivers/media//dvb-core/dvb_frontend.c:dvb_frontend_swzigzag_update_delay
   Cyclomatic Complexity 20 drivers/media//dvb-core/dvb_frontend.c:dvb_frontend_swzigzag_autotune
   Cyclomatic Complexity 6 drivers/media//dvb-core/dvb_frontend.c:dvb_frontend_is_exiting
   Cyclomatic Complexity 2 drivers/media//dvb-core/dvb_frontend.c:dvb_frontend_should_wakeup
   Cyclomatic Complexity 3 drivers/media//dvb-core/dvb_frontend.c:is_dvbv3_delsys
   Cyclomatic Complexity 4 drivers/media//dvb-core/dvb_frontend.c:emulate_delivery_system
   Cyclomatic Complexity 10 drivers/media//dvb-core/dvb_frontend.c:dvbv5_set_delivery_system
   Cyclomatic Complexity 7 drivers/media//dvb-core/dvb_frontend.c:dvbv3_set_delivery_system
   Cyclomatic Complexity 2 drivers/media//dvb-core/dvb_frontend.c:dvb_frontend_poll
   Cyclomatic Complexity 4 drivers/media//dvb-core/dvb_frontend.c:dvb_frontend_suspend
   Cyclomatic Complexity 2 drivers/media//dvb-core/dvb_frontend.c:dvb_frontend_invoke_release
   Cyclomatic Complexity 1 drivers/media//dvb-core/dvb_frontend.c:dvb_frontend_detach
   Cyclomatic Complexity 1 drivers/media//dvb-core/dvb_frontend.c:dvb_frontend_wakeup
   Cyclomatic Complexity 1 drivers/media//dvb-core/dvb_frontend.c:dvb_frontend_reinitialise
   Cyclomatic Complexity 8 drivers/media//dvb-core/dvb_frontend.c:dvb_frontend_resume
   Cyclomatic Complexity 5 drivers/media//dvb-core/dvb_frontend.c:dvb_frontend_sleep_until
   Cyclomatic Complexity 15 drivers/media//dvb-core/dvb_frontend.c:dtv_property_cache_sync
   Cyclomatic Complexity 12 drivers/media//dvb-core/dvb_frontend.c:dtv_property_legacy_params_sync
   Cyclomatic Complexity 4 drivers/media//dvb-core/dvb_frontend.c:dtv_get_frontend
   Cyclomatic Complexity 5 drivers/media//dvb-core/dvb_frontend.c:dtv_property_dump
   Cyclomatic Complexity 65 drivers/media//dvb-core/dvb_frontend.c:dtv_property_process_get
   Cyclomatic Complexity 5 drivers/media//dvb-core/dvb_frontend.c:dvb_frontend_get_frequency_limits
   Cyclomatic Complexity 10 drivers/media//dvb-core/dvb_frontend.c:dvb_frontend_check_parameters
   Cyclomatic Complexity 5 drivers/media//dvb-core/dvb_frontend.c:dvb_frontend_clear_cache
   Cyclomatic Complexity 3 drivers/media//dvb-core/dvb_frontend.c:dvb_register_frontend
   Cyclomatic Complexity 1 drivers/media//dvb-core/dvb_frontend.c:dvb_frontend_clear_events
   Cyclomatic Complexity 4 drivers/media//dvb-core/dvb_frontend.c:dvb_frontend_add_event
   Cyclomatic Complexity 18 drivers/media//dvb-core/dvb_frontend.c:dtv_set_frontend
   Cyclomatic Complexity 25 drivers/media//dvb-core/dvb_frontend.c:dvb_frontend_swzigzag
   Cyclomatic Complexity 9 drivers/media//dvb-core/dvb_frontend.c:dvb_frontend_get_event
   Cyclomatic Complexity 67 drivers/media//dvb-core/dvb_frontend.c:dvb_frontend_handle_ioctl
   Cyclomatic Complexity 6 drivers/media//dvb-core/dvb_frontend.c:dvb_frontend_ioctl
   Cyclomatic Complexity 44 drivers/media//dvb-core/dvb_frontend.c:dtv_property_process_set
   Cyclomatic Complexity 5 drivers/media//dvb-core/dvb_frontend.c:dvb_frontend_release
   Cyclomatic Complexity 2 drivers/media//dvb-core/dvb_frontend.c:dvb_frontend_free
   Cyclomatic Complexity 44 drivers/media//dvb-core/dvb_frontend.c:dvb_frontend_thread
   Cyclomatic Complexity 4 drivers/media//dvb-core/dvb_frontend.c:dvb_frontend_stop
   Cyclomatic Complexity 7 drivers/media//dvb-core/dvb_frontend.c:dvb_frontend_start
   Cyclomatic Complexity 23 drivers/media//dvb-core/dvb_frontend.c:dvb_frontend_open
   Cyclomatic Complexity 1 drivers/media//dvb-core/dvb_frontend.c:dvb_unregister_frontend
   drivers/media//dvb-core/dvb_frontend.c: In function 'dvb_frontend_handle_ioctl':
>> drivers/media//dvb-core/dvb_frontend.c:2447:1: warning: the frame size of 1048 bytes is larger than 1024 bytes [-Wframe-larger-than=]
    }
    ^

vim +2447 drivers/media//dvb-core/dvb_frontend.c

9682cea27 drivers/media/dvb/dvb-core/dvb_frontend.c Mauro Carvalho Chehab 2012-01-01  2078  
9682cea27 drivers/media/dvb/dvb-core/dvb_frontend.c Mauro Carvalho Chehab 2012-01-01  2079  
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2080  static int dvb_frontend_handle_ioctl(struct file *file,
13c97bf56 drivers/media/dvb/dvb-core/dvb_frontend.c Steven Toth           2008-09-04  2081  				     unsigned int cmd, void *parg)
13c97bf56 drivers/media/dvb/dvb-core/dvb_frontend.c Steven Toth           2008-09-04  2082  {
13c97bf56 drivers/media/dvb/dvb-core/dvb_frontend.c Steven Toth           2008-09-04  2083  	struct dvb_device *dvbdev = file->private_data;
13c97bf56 drivers/media/dvb/dvb-core/dvb_frontend.c Steven Toth           2008-09-04  2084  	struct dvb_frontend *fe = dvbdev->priv;
13c97bf56 drivers/media/dvb/dvb-core/dvb_frontend.c Steven Toth           2008-09-04  2085  	struct dvb_frontend_private *fepriv = fe->frontend_priv;
5bfaaddef drivers/media/dvb/dvb-core/dvb_frontend.c Mauro Carvalho Chehab 2012-01-01  2086  	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2087  	int i, err;
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2088  
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2089  	dev_dbg(fe->dvb->device, "%s:\n", __func__);
13c97bf56 drivers/media/dvb/dvb-core/dvb_frontend.c Steven Toth           2008-09-04  2090  
^1da177e4 drivers/media/dvb/dvb-core/dvb_frontend.c Linus Torvalds        2005-04-16  2091  	switch(cmd) {
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2092  	case FE_SET_PROPERTY: {
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2093  		struct dtv_properties *tvps = parg;
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2094  		struct dtv_property *tvp = NULL;
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2095  
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2096  		dev_dbg(fe->dvb->device, "%s: properties.num = %d\n",
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2097  			__func__, tvps->num);
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2098  		dev_dbg(fe->dvb->device, "%s: properties.props = %p\n",
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2099  			__func__, tvps->props);
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2100  
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2101  		/*
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2102  		 * Put an arbitrary limit on the number of messages that can
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2103  		 * be sent at once
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2104  		 */
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2105  		if (!tvps->num || (tvps->num > DTV_IOCTL_MAX_MSGS))
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2106  			return -EINVAL;
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2107  
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2108  		tvp = memdup_user(tvps->props, tvps->num * sizeof(*tvp));
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2109  		if (IS_ERR(tvp))
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2110  			return PTR_ERR(tvp);
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2111  
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2112  		for (i = 0; i < tvps->num; i++) {
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2113  			err = dtv_property_process_set(fe, tvp + i, file);
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2114  			if (err < 0) {
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2115  				kfree(tvp);
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2116  				return err;
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2117  			}
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2118  			(tvp + i)->result = err;
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2119  		}
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2120  
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2121  		if (c->state == DTV_TUNE)
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2122  			dev_dbg(fe->dvb->device, "%s: Property cache is full, tuning\n", __func__);
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2123  
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2124  		kfree(tvp);
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2125  		break;
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2126  	}
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2127  	case FE_GET_PROPERTY: {
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2128  		struct dtv_properties *tvps = parg;
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2129  		struct dtv_property *tvp = NULL;
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2130  		struct dtv_frontend_properties getp = fe->dtv_property_cache;
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2131  
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2132  		dev_dbg(fe->dvb->device, "%s: properties.num = %d\n",
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2133  			__func__, tvps->num);
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2134  		dev_dbg(fe->dvb->device, "%s: properties.props = %p\n",
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2135  			__func__, tvps->props);
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2136  
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2137  		/*
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2138  		 * Put an arbitrary limit on the number of messages that can
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2139  		 * be sent at once
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2140  		 */
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2141  		if (!tvps->num || (tvps->num > DTV_IOCTL_MAX_MSGS))
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2142  			return -EINVAL;
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2143  
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2144  		tvp = memdup_user(tvps->props, tvps->num * sizeof(*tvp));
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2145  		if (IS_ERR(tvp))
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2146  			return PTR_ERR(tvp);
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2147  
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2148  		/*
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2149  		 * Let's use our own copy of property cache, in order to
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2150  		 * avoid mangling with DTV zigzag logic, as drivers might
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2151  		 * return crap, if they don't check if the data is available
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2152  		 * before updating the properties cache.
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2153  		 */
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2154  		if (fepriv->state != FESTATE_IDLE) {
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2155  			err = dtv_get_frontend(fe, &getp, NULL);
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2156  			if (err < 0) {
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2157  				kfree(tvp);
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2158  				return err;
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2159  			}
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2160  		}
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2161  		for (i = 0; i < tvps->num; i++) {
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2162  			err = dtv_property_process_get(fe, &getp, tvp + i, file);
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2163  			if (err < 0) {
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2164  				kfree(tvp);
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2165  				return err;
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2166  			}
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2167  			(tvp + i)->result = err;
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2168  		}
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2169  
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2170  		if (copy_to_user((void __user *)tvps->props, tvp,
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2171  				 tvps->num * sizeof(struct dtv_property))) {
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2172  			kfree(tvp);
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2173  			return -EFAULT;
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2174  		}
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2175  		kfree(tvp);
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2176  		break;
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2177  	}
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2178  
^1da177e4 drivers/media/dvb/dvb-core/dvb_frontend.c Linus Torvalds        2005-04-16  2179  	case FE_GET_INFO: {
0c53c70f6 drivers/media/dvb/dvb-core/dvb_frontend.c Johannes Stezenbach   2005-05-16  2180  		struct dvb_frontend_info* info = parg;
9474c5e63 drivers/media/dvb/dvb-core/dvb_frontend.c Mauro Carvalho Chehab 2012-01-05  2181  
dea74869f drivers/media/dvb/dvb-core/dvb_frontend.c Patrick Boettcher     2006-05-14  2182  		memcpy(info, &fe->ops.info, sizeof(struct dvb_frontend_info));
2030c0325 drivers/media/dvb/dvb-core/dvb_frontend.c Guillaume Audirac     2010-05-06  2183  		dvb_frontend_get_frequency_limits(fe, &info->frequency_min, &info->frequency_max);
^1da177e4 drivers/media/dvb/dvb-core/dvb_frontend.c Linus Torvalds        2005-04-16  2184  
5bfaaddef drivers/media/dvb/dvb-core/dvb_frontend.c Mauro Carvalho Chehab 2012-01-01  2185  		/*
5bfaaddef drivers/media/dvb/dvb-core/dvb_frontend.c Mauro Carvalho Chehab 2012-01-01  2186  		 * Associate the 4 delivery systems supported by DVBv3
5bfaaddef drivers/media/dvb/dvb-core/dvb_frontend.c Mauro Carvalho Chehab 2012-01-01  2187  		 * API with their DVBv5 counterpart. For the other standards,
5bfaaddef drivers/media/dvb/dvb-core/dvb_frontend.c Mauro Carvalho Chehab 2012-01-01  2188  		 * use the closest type, assuming that it would hopefully
5bfaaddef drivers/media/dvb/dvb-core/dvb_frontend.c Mauro Carvalho Chehab 2012-01-01  2189  		 * work with a DVBv3 application.
5bfaaddef drivers/media/dvb/dvb-core/dvb_frontend.c Mauro Carvalho Chehab 2012-01-01  2190  		 * It should be noticed that, on multi-frontend devices with
5bfaaddef drivers/media/dvb/dvb-core/dvb_frontend.c Mauro Carvalho Chehab 2012-01-01  2191  		 * different types (terrestrial and cable, for example),
5bfaaddef drivers/media/dvb/dvb-core/dvb_frontend.c Mauro Carvalho Chehab 2012-01-01  2192  		 * a pure DVBv3 application won't be able to use all delivery
5bfaaddef drivers/media/dvb/dvb-core/dvb_frontend.c Mauro Carvalho Chehab 2012-01-01  2193  		 * systems. Yet, changing the DVBv5 cache to the other delivery
5bfaaddef drivers/media/dvb/dvb-core/dvb_frontend.c Mauro Carvalho Chehab 2012-01-01  2194  		 * system should be enough for making it work.
5bfaaddef drivers/media/dvb/dvb-core/dvb_frontend.c Mauro Carvalho Chehab 2012-01-01  2195  		 */
5bfaaddef drivers/media/dvb/dvb-core/dvb_frontend.c Mauro Carvalho Chehab 2012-01-01  2196  		switch (dvbv3_type(c->delivery_system)) {
5bfaaddef drivers/media/dvb/dvb-core/dvb_frontend.c Mauro Carvalho Chehab 2012-01-01  2197  		case DVBV3_QPSK:
9474c5e63 drivers/media/dvb/dvb-core/dvb_frontend.c Mauro Carvalho Chehab 2012-01-05  2198  			info->type = FE_QPSK;
5bfaaddef drivers/media/dvb/dvb-core/dvb_frontend.c Mauro Carvalho Chehab 2012-01-01  2199  			break;
5bfaaddef drivers/media/dvb/dvb-core/dvb_frontend.c Mauro Carvalho Chehab 2012-01-01  2200  		case DVBV3_ATSC:
9474c5e63 drivers/media/dvb/dvb-core/dvb_frontend.c Mauro Carvalho Chehab 2012-01-05  2201  			info->type = FE_ATSC;
5bfaaddef drivers/media/dvb/dvb-core/dvb_frontend.c Mauro Carvalho Chehab 2012-01-01  2202  			break;
5bfaaddef drivers/media/dvb/dvb-core/dvb_frontend.c Mauro Carvalho Chehab 2012-01-01  2203  		case DVBV3_QAM:
9474c5e63 drivers/media/dvb/dvb-core/dvb_frontend.c Mauro Carvalho Chehab 2012-01-05  2204  			info->type = FE_QAM;
5bfaaddef drivers/media/dvb/dvb-core/dvb_frontend.c Mauro Carvalho Chehab 2012-01-01  2205  			break;
5bfaaddef drivers/media/dvb/dvb-core/dvb_frontend.c Mauro Carvalho Chehab 2012-01-01  2206  		case DVBV3_OFDM:
9474c5e63 drivers/media/dvb/dvb-core/dvb_frontend.c Mauro Carvalho Chehab 2012-01-05  2207  			info->type = FE_OFDM;
5bfaaddef drivers/media/dvb/dvb-core/dvb_frontend.c Mauro Carvalho Chehab 2012-01-01  2208  			break;
5bfaaddef drivers/media/dvb/dvb-core/dvb_frontend.c Mauro Carvalho Chehab 2012-01-01  2209  		default:
36bdbc3ff drivers/media/dvb-core/dvb_frontend.c     Antti Palosaari       2012-08-15  2210  			dev_err(fe->dvb->device,
5bfaaddef drivers/media/dvb/dvb-core/dvb_frontend.c Mauro Carvalho Chehab 2012-01-01  2211  					"%s: doesn't know how to handle a DVBv3 call to delivery system %i\n",
5bfaaddef drivers/media/dvb/dvb-core/dvb_frontend.c Mauro Carvalho Chehab 2012-01-01  2212  					__func__, c->delivery_system);
5bfaaddef drivers/media/dvb/dvb-core/dvb_frontend.c Mauro Carvalho Chehab 2012-01-01  2213  			fe->ops.info.type = FE_OFDM;
5bfaaddef drivers/media/dvb/dvb-core/dvb_frontend.c Mauro Carvalho Chehab 2012-01-01  2214  		}
36bdbc3ff drivers/media/dvb-core/dvb_frontend.c     Antti Palosaari       2012-08-15  2215  		dev_dbg(fe->dvb->device, "%s: current delivery system on cache: %d, V3 type: %d\n",
36bdbc3ff drivers/media/dvb-core/dvb_frontend.c     Antti Palosaari       2012-08-15  2216  				 __func__, c->delivery_system, fe->ops.info.type);
5bfaaddef drivers/media/dvb/dvb-core/dvb_frontend.c Mauro Carvalho Chehab 2012-01-01  2217  
c9d57de61 drivers/media/dvb-core/dvb_frontend.c     Malcolm Priestley     2015-08-31  2218  		/* Set CAN_INVERSION_AUTO bit on in other than oneshot mode */
c9d57de61 drivers/media/dvb-core/dvb_frontend.c     Malcolm Priestley     2015-08-31  2219  		if (!(fepriv->tune_mode_flags & FE_TUNE_MODE_ONESHOT))
^1da177e4 drivers/media/dvb/dvb-core/dvb_frontend.c Linus Torvalds        2005-04-16  2220  			info->caps |= FE_CAN_INVERSION_AUTO;
^1da177e4 drivers/media/dvb/dvb-core/dvb_frontend.c Linus Torvalds        2005-04-16  2221  		err = 0;
^1da177e4 drivers/media/dvb/dvb-core/dvb_frontend.c Linus Torvalds        2005-04-16  2222  		break;
^1da177e4 drivers/media/dvb/dvb-core/dvb_frontend.c Linus Torvalds        2005-04-16  2223  	}
^1da177e4 drivers/media/dvb/dvb-core/dvb_frontend.c Linus Torvalds        2005-04-16  2224  
6757ccc57 drivers/media/dvb/dvb-core/dvb_frontend.c Peter Beutner         2005-07-07  2225  	case FE_READ_STATUS: {
0df289a20 drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2015-06-07  2226  		enum fe_status *status = parg;
6757ccc57 drivers/media/dvb/dvb-core/dvb_frontend.c Peter Beutner         2005-07-07  2227  
25985edce drivers/media/dvb/dvb-core/dvb_frontend.c Lucas De Marchi       2011-03-30  2228  		/* if retune was requested but hasn't occurred yet, prevent
6757ccc57 drivers/media/dvb/dvb-core/dvb_frontend.c Peter Beutner         2005-07-07  2229  		 * that user get signal state from previous tuning */
01886255d drivers/media/dvb/dvb-core/dvb_frontend.c Janne Grunau          2009-09-01  2230  		if (fepriv->state == FESTATE_RETUNE ||
01886255d drivers/media/dvb/dvb-core/dvb_frontend.c Janne Grunau          2009-09-01  2231  		    fepriv->state == FESTATE_ERROR) {
6757ccc57 drivers/media/dvb/dvb-core/dvb_frontend.c Peter Beutner         2005-07-07  2232  			err=0;
6757ccc57 drivers/media/dvb/dvb-core/dvb_frontend.c Peter Beutner         2005-07-07  2233  			*status = 0;
^1da177e4 drivers/media/dvb/dvb-core/dvb_frontend.c Linus Torvalds        2005-04-16  2234  			break;
6757ccc57 drivers/media/dvb/dvb-core/dvb_frontend.c Peter Beutner         2005-07-07  2235  		}
^1da177e4 drivers/media/dvb/dvb-core/dvb_frontend.c Linus Torvalds        2005-04-16  2236  
dea74869f drivers/media/dvb/dvb-core/dvb_frontend.c Patrick Boettcher     2006-05-14  2237  		if (fe->ops.read_status)
dea74869f drivers/media/dvb/dvb-core/dvb_frontend.c Patrick Boettcher     2006-05-14  2238  			err = fe->ops.read_status(fe, status);
6757ccc57 drivers/media/dvb/dvb-core/dvb_frontend.c Peter Beutner         2005-07-07  2239  		break;
6757ccc57 drivers/media/dvb/dvb-core/dvb_frontend.c Peter Beutner         2005-07-07  2240  	}
48caa6f12 drivers/media/dvb-core/dvb_frontend.c     Antti Palosaari       2012-08-09  2241  
^1da177e4 drivers/media/dvb/dvb-core/dvb_frontend.c Linus Torvalds        2005-04-16  2242  	case FE_DISEQC_RESET_OVERLOAD:
dea74869f drivers/media/dvb/dvb-core/dvb_frontend.c Patrick Boettcher     2006-05-14  2243  		if (fe->ops.diseqc_reset_overload) {
dea74869f drivers/media/dvb/dvb-core/dvb_frontend.c Patrick Boettcher     2006-05-14  2244  			err = fe->ops.diseqc_reset_overload(fe);
^1da177e4 drivers/media/dvb/dvb-core/dvb_frontend.c Linus Torvalds        2005-04-16  2245  			fepriv->state = FESTATE_DISEQC;
^1da177e4 drivers/media/dvb/dvb-core/dvb_frontend.c Linus Torvalds        2005-04-16  2246  			fepriv->status = 0;
^1da177e4 drivers/media/dvb/dvb-core/dvb_frontend.c Linus Torvalds        2005-04-16  2247  		}
^1da177e4 drivers/media/dvb/dvb-core/dvb_frontend.c Linus Torvalds        2005-04-16  2248  		break;
^1da177e4 drivers/media/dvb/dvb-core/dvb_frontend.c Linus Torvalds        2005-04-16  2249  
^1da177e4 drivers/media/dvb/dvb-core/dvb_frontend.c Linus Torvalds        2005-04-16  2250  	case FE_DISEQC_SEND_MASTER_CMD:
dea74869f drivers/media/dvb/dvb-core/dvb_frontend.c Patrick Boettcher     2006-05-14  2251  		if (fe->ops.diseqc_send_master_cmd) {
8d7e50635 drivers/media/dvb-core/dvb_frontend.c     Dan Carpenter         2015-06-06  2252  			struct dvb_diseqc_master_cmd *cmd = parg;
8d7e50635 drivers/media/dvb-core/dvb_frontend.c     Dan Carpenter         2015-06-06  2253  
8d7e50635 drivers/media/dvb-core/dvb_frontend.c     Dan Carpenter         2015-06-06  2254  			if (cmd->msg_len > sizeof(cmd->msg)) {
8d7e50635 drivers/media/dvb-core/dvb_frontend.c     Dan Carpenter         2015-06-06  2255  				err = -EINVAL;
8d7e50635 drivers/media/dvb-core/dvb_frontend.c     Dan Carpenter         2015-06-06  2256  				break;
8d7e50635 drivers/media/dvb-core/dvb_frontend.c     Dan Carpenter         2015-06-06  2257  			}
8d7e50635 drivers/media/dvb-core/dvb_frontend.c     Dan Carpenter         2015-06-06  2258  			err = fe->ops.diseqc_send_master_cmd(fe, cmd);
^1da177e4 drivers/media/dvb/dvb-core/dvb_frontend.c Linus Torvalds        2005-04-16  2259  			fepriv->state = FESTATE_DISEQC;
^1da177e4 drivers/media/dvb/dvb-core/dvb_frontend.c Linus Torvalds        2005-04-16  2260  			fepriv->status = 0;
^1da177e4 drivers/media/dvb/dvb-core/dvb_frontend.c Linus Torvalds        2005-04-16  2261  		}
^1da177e4 drivers/media/dvb/dvb-core/dvb_frontend.c Linus Torvalds        2005-04-16  2262  		break;
^1da177e4 drivers/media/dvb/dvb-core/dvb_frontend.c Linus Torvalds        2005-04-16  2263  
^1da177e4 drivers/media/dvb/dvb-core/dvb_frontend.c Linus Torvalds        2005-04-16  2264  	case FE_DISEQC_SEND_BURST:
dea74869f drivers/media/dvb/dvb-core/dvb_frontend.c Patrick Boettcher     2006-05-14  2265  		if (fe->ops.diseqc_send_burst) {
0df289a20 drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2015-06-07  2266  			err = fe->ops.diseqc_send_burst(fe,
0df289a20 drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2015-06-07  2267  						(enum fe_sec_mini_cmd)parg);
^1da177e4 drivers/media/dvb/dvb-core/dvb_frontend.c Linus Torvalds        2005-04-16  2268  			fepriv->state = FESTATE_DISEQC;
^1da177e4 drivers/media/dvb/dvb-core/dvb_frontend.c Linus Torvalds        2005-04-16  2269  			fepriv->status = 0;
^1da177e4 drivers/media/dvb/dvb-core/dvb_frontend.c Linus Torvalds        2005-04-16  2270  		}
^1da177e4 drivers/media/dvb/dvb-core/dvb_frontend.c Linus Torvalds        2005-04-16  2271  		break;
^1da177e4 drivers/media/dvb/dvb-core/dvb_frontend.c Linus Torvalds        2005-04-16  2272  
^1da177e4 drivers/media/dvb/dvb-core/dvb_frontend.c Linus Torvalds        2005-04-16  2273  	case FE_SET_TONE:
dea74869f drivers/media/dvb/dvb-core/dvb_frontend.c Patrick Boettcher     2006-05-14  2274  		if (fe->ops.set_tone) {
0df289a20 drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2015-06-07  2275  			err = fe->ops.set_tone(fe,
0df289a20 drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2015-06-07  2276  					       (enum fe_sec_tone_mode)parg);
0df289a20 drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2015-06-07  2277  			fepriv->tone = (enum fe_sec_tone_mode)parg;
^1da177e4 drivers/media/dvb/dvb-core/dvb_frontend.c Linus Torvalds        2005-04-16  2278  			fepriv->state = FESTATE_DISEQC;
^1da177e4 drivers/media/dvb/dvb-core/dvb_frontend.c Linus Torvalds        2005-04-16  2279  			fepriv->status = 0;
^1da177e4 drivers/media/dvb/dvb-core/dvb_frontend.c Linus Torvalds        2005-04-16  2280  		}
^1da177e4 drivers/media/dvb/dvb-core/dvb_frontend.c Linus Torvalds        2005-04-16  2281  		break;
^1da177e4 drivers/media/dvb/dvb-core/dvb_frontend.c Linus Torvalds        2005-04-16  2282  
^1da177e4 drivers/media/dvb/dvb-core/dvb_frontend.c Linus Torvalds        2005-04-16  2283  	case FE_SET_VOLTAGE:
dea74869f drivers/media/dvb/dvb-core/dvb_frontend.c Patrick Boettcher     2006-05-14  2284  		if (fe->ops.set_voltage) {
0df289a20 drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2015-06-07  2285  			err = fe->ops.set_voltage(fe,
0df289a20 drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2015-06-07  2286  						  (enum fe_sec_voltage)parg);
0df289a20 drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2015-06-07  2287  			fepriv->voltage = (enum fe_sec_voltage)parg;
^1da177e4 drivers/media/dvb/dvb-core/dvb_frontend.c Linus Torvalds        2005-04-16  2288  			fepriv->state = FESTATE_DISEQC;
^1da177e4 drivers/media/dvb/dvb-core/dvb_frontend.c Linus Torvalds        2005-04-16  2289  			fepriv->status = 0;
^1da177e4 drivers/media/dvb/dvb-core/dvb_frontend.c Linus Torvalds        2005-04-16  2290  		}
^1da177e4 drivers/media/dvb/dvb-core/dvb_frontend.c Linus Torvalds        2005-04-16  2291  		break;
^1da177e4 drivers/media/dvb/dvb-core/dvb_frontend.c Linus Torvalds        2005-04-16  2292  
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2293  	case FE_DISEQC_RECV_SLAVE_REPLY:
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2294  		if (fe->ops.diseqc_recv_slave_reply)
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2295  			err = fe->ops.diseqc_recv_slave_reply(fe, (struct dvb_diseqc_slave_reply*) parg);
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2296  		break;
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2297  
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2298  	case FE_ENABLE_HIGH_LNB_VOLTAGE:
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2299  		if (fe->ops.enable_high_lnb_voltage)
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2300  			err = fe->ops.enable_high_lnb_voltage(fe, (long) parg);
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2301  		break;
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2302  
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2303  	case FE_SET_FRONTEND_TUNE_MODE:
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2304  		fepriv->tune_mode_flags = (unsigned long) parg;
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2305  		err = 0;
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2306  		break;
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2307  
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2308  	/* DEPRECATED dish control ioctls */
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2309  
^1da177e4 drivers/media/dvb/dvb-core/dvb_frontend.c Linus Torvalds        2005-04-16  2310  	case FE_DISHNETWORK_SEND_LEGACY_CMD:
dea74869f drivers/media/dvb/dvb-core/dvb_frontend.c Patrick Boettcher     2006-05-14  2311  		if (fe->ops.dishnetwork_send_legacy_command) {
0df289a20 drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2015-06-07  2312  			err = fe->ops.dishnetwork_send_legacy_command(fe,
0df289a20 drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2015-06-07  2313  							 (unsigned long)parg);
^1da177e4 drivers/media/dvb/dvb-core/dvb_frontend.c Linus Torvalds        2005-04-16  2314  			fepriv->state = FESTATE_DISEQC;
^1da177e4 drivers/media/dvb/dvb-core/dvb_frontend.c Linus Torvalds        2005-04-16  2315  			fepriv->status = 0;
dea74869f drivers/media/dvb/dvb-core/dvb_frontend.c Patrick Boettcher     2006-05-14  2316  		} else if (fe->ops.set_voltage) {
83b75b049 drivers/media/dvb/dvb-core/dvb_frontend.c NooneImportant        2005-11-08  2317  			/*
83b75b049 drivers/media/dvb/dvb-core/dvb_frontend.c NooneImportant        2005-11-08  2318  			 * NOTE: This is a fallback condition.  Some frontends
83b75b049 drivers/media/dvb/dvb-core/dvb_frontend.c NooneImportant        2005-11-08  2319  			 * (stv0299 for instance) take longer than 8msec to
83b75b049 drivers/media/dvb/dvb-core/dvb_frontend.c NooneImportant        2005-11-08  2320  			 * respond to a set_voltage command.  Those switches
83b75b049 drivers/media/dvb/dvb-core/dvb_frontend.c NooneImportant        2005-11-08  2321  			 * need custom routines to switch properly.  For all
2030c0325 drivers/media/dvb/dvb-core/dvb_frontend.c Guillaume Audirac     2010-05-06  2322  			 * other frontends, the following should work ok.
83b75b049 drivers/media/dvb/dvb-core/dvb_frontend.c NooneImportant        2005-11-08  2323  			 * Dish network legacy switches (as used by Dish500)
83b75b049 drivers/media/dvb/dvb-core/dvb_frontend.c NooneImportant        2005-11-08  2324  			 * are controlled by sending 9-bit command words
83b75b049 drivers/media/dvb/dvb-core/dvb_frontend.c NooneImportant        2005-11-08  2325  			 * spaced 8msec apart.
25985edce drivers/media/dvb/dvb-core/dvb_frontend.c Lucas De Marchi       2011-03-30  2326  			 * the actual command word is switch/port dependent
83b75b049 drivers/media/dvb/dvb-core/dvb_frontend.c NooneImportant        2005-11-08  2327  			 * so it is up to the userspace application to send
83b75b049 drivers/media/dvb/dvb-core/dvb_frontend.c NooneImportant        2005-11-08  2328  			 * the right command.
83b75b049 drivers/media/dvb/dvb-core/dvb_frontend.c NooneImportant        2005-11-08  2329  			 * The command must always start with a '0' after
83b75b049 drivers/media/dvb/dvb-core/dvb_frontend.c NooneImportant        2005-11-08  2330  			 * initialization, so parg is 8 bits and does not
83b75b049 drivers/media/dvb/dvb-core/dvb_frontend.c NooneImportant        2005-11-08  2331  			 * include the initialization or start bit
83b75b049 drivers/media/dvb/dvb-core/dvb_frontend.c NooneImportant        2005-11-08  2332  			 */
c6eb8eafd drivers/media/dvb/dvb-core/dvb_frontend.c Hans Verkuil          2008-09-03  2333  			unsigned long swcmd = ((unsigned long) parg) << 1;
9056a23ba drivers/media/dvb-core/dvb_frontend.c     Tina Ruchandani       2015-05-31  2334  			ktime_t nexttime;
9056a23ba drivers/media/dvb-core/dvb_frontend.c     Tina Ruchandani       2015-05-31  2335  			ktime_t tv[10];
83b75b049 drivers/media/dvb/dvb-core/dvb_frontend.c NooneImportant        2005-11-08  2336  			int i;
83b75b049 drivers/media/dvb/dvb-core/dvb_frontend.c NooneImportant        2005-11-08  2337  			u8 last = 1;
83b75b049 drivers/media/dvb/dvb-core/dvb_frontend.c NooneImportant        2005-11-08  2338  			if (dvb_frontend_debug)
b3ad24d2e drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2016-10-13  2339  				dprintk("%s switch command: 0x%04lx\n",
b3ad24d2e drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2016-10-13  2340  					__func__, swcmd);
6b3f99989 drivers/media/dvb-core/dvb_frontend.c     Abhilash Jindal       2016-01-31  2341  			nexttime = ktime_get_boottime();
83b75b049 drivers/media/dvb/dvb-core/dvb_frontend.c NooneImportant        2005-11-08  2342  			if (dvb_frontend_debug)
b9b1b3a8f drivers/media/dvb-core/dvb_frontend.c     Ezequiel Garcia       2012-10-23  2343  				tv[0] = nexttime;
83b75b049 drivers/media/dvb/dvb-core/dvb_frontend.c NooneImportant        2005-11-08  2344  			/* before sending a command, initialize by sending
83b75b049 drivers/media/dvb/dvb-core/dvb_frontend.c NooneImportant        2005-11-08  2345  			 * a 32ms 18V to the switch
83b75b049 drivers/media/dvb/dvb-core/dvb_frontend.c NooneImportant        2005-11-08  2346  			 */
dea74869f drivers/media/dvb/dvb-core/dvb_frontend.c Patrick Boettcher     2006-05-14  2347  			fe->ops.set_voltage(fe, SEC_VOLTAGE_18);
83b75b049 drivers/media/dvb/dvb-core/dvb_frontend.c NooneImportant        2005-11-08  2348  			dvb_frontend_sleep_until(&nexttime, 32000);
83b75b049 drivers/media/dvb/dvb-core/dvb_frontend.c NooneImportant        2005-11-08  2349  
83b75b049 drivers/media/dvb/dvb-core/dvb_frontend.c NooneImportant        2005-11-08  2350  			for (i = 0; i < 9; i++) {
83b75b049 drivers/media/dvb/dvb-core/dvb_frontend.c NooneImportant        2005-11-08  2351  				if (dvb_frontend_debug)
6b3f99989 drivers/media/dvb-core/dvb_frontend.c     Abhilash Jindal       2016-01-31  2352  					tv[i+1] = ktime_get_boottime();
c6eb8eafd drivers/media/dvb/dvb-core/dvb_frontend.c Hans Verkuil          2008-09-03  2353  				if ((swcmd & 0x01) != last) {
83b75b049 drivers/media/dvb/dvb-core/dvb_frontend.c NooneImportant        2005-11-08  2354  					/* set voltage to (last ? 13V : 18V) */
dea74869f drivers/media/dvb/dvb-core/dvb_frontend.c Patrick Boettcher     2006-05-14  2355  					fe->ops.set_voltage(fe, (last) ? SEC_VOLTAGE_13 : SEC_VOLTAGE_18);
83b75b049 drivers/media/dvb/dvb-core/dvb_frontend.c NooneImportant        2005-11-08  2356  					last = (last) ? 0 : 1;
83b75b049 drivers/media/dvb/dvb-core/dvb_frontend.c NooneImportant        2005-11-08  2357  				}
c6eb8eafd drivers/media/dvb/dvb-core/dvb_frontend.c Hans Verkuil          2008-09-03  2358  				swcmd = swcmd >> 1;
83b75b049 drivers/media/dvb/dvb-core/dvb_frontend.c NooneImportant        2005-11-08  2359  				if (i != 8)
83b75b049 drivers/media/dvb/dvb-core/dvb_frontend.c NooneImportant        2005-11-08  2360  					dvb_frontend_sleep_until(&nexttime, 8000);
83b75b049 drivers/media/dvb/dvb-core/dvb_frontend.c NooneImportant        2005-11-08  2361  			}
83b75b049 drivers/media/dvb/dvb-core/dvb_frontend.c NooneImportant        2005-11-08  2362  			if (dvb_frontend_debug) {
b3ad24d2e drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2016-10-13  2363  				dprintk("%s(%d): switch delay (should be 32k followed by all 8k)\n",
46b4f7c17 drivers/media/dvb/dvb-core/dvb_frontend.c Harvey Harrison       2008-04-08  2364  					__func__, fe->dvb->num);
83b75b049 drivers/media/dvb/dvb-core/dvb_frontend.c NooneImportant        2005-11-08  2365  				for (i = 1; i < 10; i++)
b3ad24d2e drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2016-10-13  2366  					pr_info("%d: %d\n", i,
9056a23ba drivers/media/dvb-core/dvb_frontend.c     Tina Ruchandani       2015-05-31  2367  					(int) ktime_us_delta(tv[i], tv[i-1]));
83b75b049 drivers/media/dvb/dvb-core/dvb_frontend.c NooneImportant        2005-11-08  2368  			}
83b75b049 drivers/media/dvb/dvb-core/dvb_frontend.c NooneImportant        2005-11-08  2369  			err = 0;
83b75b049 drivers/media/dvb/dvb-core/dvb_frontend.c NooneImportant        2005-11-08  2370  			fepriv->state = FESTATE_DISEQC;
83b75b049 drivers/media/dvb/dvb-core/dvb_frontend.c NooneImportant        2005-11-08  2371  			fepriv->status = 0;
^1da177e4 drivers/media/dvb/dvb-core/dvb_frontend.c Linus Torvalds        2005-04-16  2372  		}
^1da177e4 drivers/media/dvb/dvb-core/dvb_frontend.c Linus Torvalds        2005-04-16  2373  		break;
^1da177e4 drivers/media/dvb/dvb-core/dvb_frontend.c Linus Torvalds        2005-04-16  2374  
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2375  	/* DEPRECATED statistics ioctls */
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2376  
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2377  	case FE_READ_BER:
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2378  		if (fe->ops.read_ber) {
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2379  			if (fepriv->thread)
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2380  				err = fe->ops.read_ber(fe, (__u32 *) parg);
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2381  			else
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2382  				err = -EAGAIN;
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2383  		}
^1da177e4 drivers/media/dvb/dvb-core/dvb_frontend.c Linus Torvalds        2005-04-16  2384  		break;
^1da177e4 drivers/media/dvb/dvb-core/dvb_frontend.c Linus Torvalds        2005-04-16  2385  
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2386  	case FE_READ_SIGNAL_STRENGTH:
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2387  		if (fe->ops.read_signal_strength) {
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2388  			if (fepriv->thread)
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2389  				err = fe->ops.read_signal_strength(fe, (__u16 *) parg);
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2390  			else
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2391  				err = -EAGAIN;
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2392  		}
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2393  		break;
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2394  
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2395  	case FE_READ_SNR:
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2396  		if (fe->ops.read_snr) {
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2397  			if (fepriv->thread)
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2398  				err = fe->ops.read_snr(fe, (__u16 *) parg);
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2399  			else
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2400  				err = -EAGAIN;
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2401  		}
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2402  		break;
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2403  
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2404  	case FE_READ_UNCORRECTED_BLOCKS:
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2405  		if (fe->ops.read_ucblocks) {
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2406  			if (fepriv->thread)
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2407  				err = fe->ops.read_ucblocks(fe, (__u32 *) parg);
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2408  			else
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2409  				err = -EAGAIN;
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2410  		}
^1da177e4 drivers/media/dvb/dvb-core/dvb_frontend.c Linus Torvalds        2005-04-16  2411  		break;
^1da177e4 drivers/media/dvb/dvb-core/dvb_frontend.c Linus Torvalds        2005-04-16  2412  
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2413  	/* DEPRECATED DVBv3 ioctls */
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2414  
9682cea27 drivers/media/dvb/dvb-core/dvb_frontend.c Mauro Carvalho Chehab 2012-01-01  2415  	case FE_SET_FRONTEND:
be431b16c drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2013-03-18  2416  		err = dvbv3_set_delivery_system(fe);
04be0f76a drivers/media/dvb/dvb-core/dvb_frontend.c Mauro Carvalho Chehab 2012-01-01  2417  		if (err)
04be0f76a drivers/media/dvb/dvb-core/dvb_frontend.c Mauro Carvalho Chehab 2012-01-01  2418  			break;
04be0f76a drivers/media/dvb/dvb-core/dvb_frontend.c Mauro Carvalho Chehab 2012-01-01  2419  
e399ce77e drivers/media/dvb/dvb-core/dvb_frontend.c Mauro Carvalho Chehab 2012-01-01  2420  		err = dtv_property_cache_sync(fe, c, parg);
5bfaaddef drivers/media/dvb/dvb-core/dvb_frontend.c Mauro Carvalho Chehab 2012-01-01  2421  		if (err)
5bfaaddef drivers/media/dvb/dvb-core/dvb_frontend.c Mauro Carvalho Chehab 2012-01-01  2422  			break;
5bfaaddef drivers/media/dvb/dvb-core/dvb_frontend.c Mauro Carvalho Chehab 2012-01-01  2423  		err = dtv_set_frontend(fe);
^1da177e4 drivers/media/dvb/dvb-core/dvb_frontend.c Linus Torvalds        2005-04-16  2424  		break;
^1da177e4 drivers/media/dvb/dvb-core/dvb_frontend.c Linus Torvalds        2005-04-16  2425  	case FE_GET_EVENT:
^1da177e4 drivers/media/dvb/dvb-core/dvb_frontend.c Linus Torvalds        2005-04-16  2426  		err = dvb_frontend_get_event (fe, parg, file->f_flags);
^1da177e4 drivers/media/dvb/dvb-core/dvb_frontend.c Linus Torvalds        2005-04-16  2427  		break;
^1da177e4 drivers/media/dvb/dvb-core/dvb_frontend.c Linus Torvalds        2005-04-16  2428  
bb31d2381 drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2016-02-04  2429  	case FE_GET_FRONTEND: {
bb31d2381 drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2016-02-04  2430  		struct dtv_frontend_properties getp = fe->dtv_property_cache;
36cb557a2 drivers/media/dvb/dvb-core/dvb_frontend.c Andrew de Quincey     2006-01-09  2431  
bb31d2381 drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2016-02-04  2432  		/*
bb31d2381 drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2016-02-04  2433  		 * Let's use our own copy of property cache, in order to
bb31d2381 drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2016-02-04  2434  		 * avoid mangling with DTV zigzag logic, as drivers might
bb31d2381 drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2016-02-04  2435  		 * return crap, if they don't check if the data is available
bb31d2381 drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2016-02-04  2436  		 * before updating the properties cache.
bb31d2381 drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2016-02-04  2437  		 */
bb31d2381 drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2016-02-04  2438  		err = dtv_get_frontend(fe, &getp, parg);
bb31d2381 drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2016-02-04  2439  		break;
bb31d2381 drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2016-02-04  2440  	}
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2441  
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2442  	default:
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2443  		return -ENOTSUPP;
d73dcf0cd drivers/media/dvb-core/dvb_frontend.c     Mauro Carvalho Chehab 2017-09-18  2444  	} /* switch */
^1da177e4 drivers/media/dvb/dvb-core/dvb_frontend.c Linus Torvalds        2005-04-16  2445  
^1da177e4 drivers/media/dvb/dvb-core/dvb_frontend.c Linus Torvalds        2005-04-16  2446  	return err;
^1da177e4 drivers/media/dvb/dvb-core/dvb_frontend.c Linus Torvalds        2005-04-16 @2447  }
^1da177e4 drivers/media/dvb/dvb-core/dvb_frontend.c Linus Torvalds        2005-04-16  2448  

:::::: The code at line 2447 was first introduced by commit
:::::: 1da177e4c3f41524e886b7f1b8a0c1fc7321cac2 Linux-2.6.12-rc2

:::::: TO: Linus Torvalds <torvalds@ppc970.osdl.org>
:::::: CC: Linus Torvalds <torvalds@ppc970.osdl.org>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--WIyZ46R2i8wDzkSu
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--WIyZ46R2i8wDzkSu--
