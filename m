Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:51300 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750854AbeGEFcd (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Jul 2018 01:32:33 -0400
Date: Thu, 5 Jul 2018 13:31:38 +0800
From: kbuild test robot <lkp@intel.com>
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: kbuild-all@01.org,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>,
        Antti Palosaari <crope@iki.fi>,
        Jemma Denson <jdenson@gmail.com>,
        Patrick Boettcher <patrick.boettcher@posteo.de>,
        Sergey Kozlov <serjk@netup.ru>, Abylay Ospan <aospan@netup.ru>,
        Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>,
        Malcolm Priestley <tvboxspy@gmail.com>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Daniel Scheller <d.scheller.oss@gmail.com>,
        Matthias Schwarzott <zzam@gentoo.org>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux1394-devel@lists.sourceforge.net
Subject: Re: [PATCH 2/2] media: dvb: represent min/max/step/tolerance freqs
 in Hz
Message-ID: <201807051147.ShuvooBh%fengguang.wu@intel.com>
References: <b3d63a8f038d136b26692bc3a14554960e767f4a.1530740760.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="HlL+5n6rz5pIUxbD"
Content-Disposition: inline
In-Reply-To: <b3d63a8f038d136b26692bc3a14554960e767f4a.1530740760.git.mchehab+samsung@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Mauro,

I love your patch! Perhaps something to improve:

[auto build test WARNING on linuxtv-media/master]
[also build test WARNING on v4.18-rc3 next-20180704]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Mauro-Carvalho-Chehab/DVB-represent-frequencies-at-tuner-frontend-info-in-Hz/20180705-105703
base:   git://linuxtv.org/media_tree.git master
config: i386-randconfig-x002-201826 (attached as .config)
compiler: gcc-7 (Debian 7.3.0-16) 7.3.0
reproduce:
        # save the attached .config to linux build tree
        make ARCH=i386 

All warnings (new ones prefixed by >>):

   In file included from arch/x86/include/asm/string.h:3:0,
                    from include/linux/string.h:20,
                    from drivers/media/dvb-core/dvb_frontend.c:30:
   drivers/media/dvb-core/dvb_frontend.c: In function 'dvb_frontend_handle_ioctl':
>> drivers/media/dvb-core/dvb_frontend.c:2396:25: warning: argument to 'sizeof' in '__builtin_memset' call is the same expression as the destination; did you mean to dereference it? [-Wsizeof-pointer-memaccess]
      memset(info, 0, sizeof(info));
                            ^
   arch/x86/include/asm/string_32.h:325:52: note: in definition of macro 'memset'
    #define memset(s, c, count) __builtin_memset(s, c, count)
                                                       ^~~~~
   Cyclomatic Complexity 5 include/linux/compiler.h:__read_once_size
   Cyclomatic Complexity 5 include/linux/compiler.h:__write_once_size
   Cyclomatic Complexity 1 include/linux/kasan-checks.h:kasan_check_read
   Cyclomatic Complexity 1 include/linux/kasan-checks.h:kasan_check_write
   Cyclomatic Complexity 1 arch/x86/include/asm/bitops.h:constant_test_bit
   Cyclomatic Complexity 1 arch/x86/include/asm/bitops.h:variable_test_bit
   Cyclomatic Complexity 1 arch/x86/include/asm/bitops.h:fls
   Cyclomatic Complexity 1 include/linux/log2.h:__ilog2_u32
   Cyclomatic Complexity 3 include/linux/log2.h:is_power_of_2
   Cyclomatic Complexity 1 arch/x86/include/asm/atomic.h:arch_atomic_read
   Cyclomatic Complexity 1 arch/x86/include/asm/atomic.h:arch_atomic_set
   Cyclomatic Complexity 1 include/asm-generic/atomic-instrumented.h:atomic_read
   Cyclomatic Complexity 1 include/asm-generic/atomic-instrumented.h:atomic_set
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
   Cyclomatic Complexity 1 arch/x86/include/asm/refcount.h:refcount_inc
   Cyclomatic Complexity 1 arch/x86/include/asm/refcount.h:refcount_dec_and_test
   Cyclomatic Complexity 1 include/linux/sched.h:task_thread_info
   Cyclomatic Complexity 1 include/linux/sched.h:test_tsk_thread_flag
   Cyclomatic Complexity 1 include/linux/sched/signal.h:signal_pending
   Cyclomatic Complexity 28 include/linux/slab.h:kmalloc_index
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
   Cyclomatic Complexity 1 drivers/media/dvb-core/dvb_frontend.c:dvb_frontend_get
   Cyclomatic Complexity 1 drivers/media/dvb-core/dvb_frontend.c:has_get_frontend
   Cyclomatic Complexity 5 drivers/media/dvb-core/dvb_frontend.c:dvbv3_type
   Cyclomatic Complexity 5 drivers/media/dvb-core/dvb_frontend.c:dvb_frontend_init
   Cyclomatic Complexity 2 drivers/media/dvb-core/dvb_frontend.c:dvb_frontend_swzigzag_update_delay
   Cyclomatic Complexity 20 drivers/media/dvb-core/dvb_frontend.c:dvb_frontend_swzigzag_autotune
   Cyclomatic Complexity 6 drivers/media/dvb-core/dvb_frontend.c:dvb_frontend_is_exiting
   Cyclomatic Complexity 2 drivers/media/dvb-core/dvb_frontend.c:dvb_frontend_should_wakeup
   Cyclomatic Complexity 66 drivers/media/dvb-core/dvb_frontend.c:dtv_property_process_get
   Cyclomatic Complexity 3 drivers/media/dvb-core/dvb_frontend.c:is_dvbv3_delsys
   Cyclomatic Complexity 4 drivers/media/dvb-core/dvb_frontend.c:emulate_delivery_system
   Cyclomatic Complexity 10 drivers/media/dvb-core/dvb_frontend.c:dvbv5_set_delivery_system
   Cyclomatic Complexity 7 drivers/media/dvb-core/dvb_frontend.c:dvbv3_set_delivery_system
   Cyclomatic Complexity 2 drivers/media/dvb-core/dvb_frontend.c:dvb_frontend_poll
   Cyclomatic Complexity 4 drivers/media/dvb-core/dvb_frontend.c:dvb_frontend_suspend
   Cyclomatic Complexity 1 drivers/media/dvb-core/dvb_frontend.c:dvb_frontend_wakeup
   Cyclomatic Complexity 1 drivers/media/dvb-core/dvb_frontend.c:dvb_frontend_reinitialise
   Cyclomatic Complexity 8 drivers/media/dvb-core/dvb_frontend.c:dvb_frontend_resume
   Cyclomatic Complexity 5 drivers/media/dvb-core/dvb_frontend.c:dvb_frontend_sleep_until
   Cyclomatic Complexity 1 drivers/media/dvb-core/dvb_frontend.c:dvb_frontend_clear_events
   Cyclomatic Complexity 2 drivers/media/dvb-core/dvb_frontend.c:dvb_frontend_invoke_release
   Cyclomatic Complexity 2 drivers/media/dvb-core/dvb_frontend.c:__dvb_frontend_free
   Cyclomatic Complexity 2 drivers/media/dvb-core/dvb_frontend.c:dvb_frontend_put
   Cyclomatic Complexity 7 drivers/media/dvb-core/dvb_frontend.c:dvb_frontend_release
   Cyclomatic Complexity 2 drivers/media/dvb-core/dvb_frontend.c:dvb_frontend_free
   Cyclomatic Complexity 1 drivers/media/dvb-core/dvb_frontend.c:dvb_frontend_detach
   Cyclomatic Complexity 12 drivers/media/dvb-core/dvb_frontend.c:dtv_property_legacy_params_sync
   Cyclomatic Complexity 4 drivers/media/dvb-core/dvb_frontend.c:dtv_get_frontend
   Cyclomatic Complexity 4 drivers/media/dvb-core/dvb_frontend.c:dvb_frontend_add_event
   Cyclomatic Complexity 25 drivers/media/dvb-core/dvb_frontend.c:dvb_frontend_swzigzag
   Cyclomatic Complexity 15 drivers/media/dvb-core/dvb_frontend.c:dtv_property_cache_sync
   Cyclomatic Complexity 6 drivers/media/dvb-core/dvb_frontend.c:dvb_frontend_get_frequency_limits
   Cyclomatic Complexity 10 drivers/media/dvb-core/dvb_frontend.c:dvb_frontend_check_parameters
   Cyclomatic Complexity 44 drivers/media/dvb-core/dvb_frontend.c:dvb_frontend_thread
   Cyclomatic Complexity 4 drivers/media/dvb-core/dvb_frontend.c:dvb_frontend_stop
   Cyclomatic Complexity 7 drivers/media/dvb-core/dvb_frontend.c:dvb_frontend_start
   Cyclomatic Complexity 28 drivers/media/dvb-core/dvb_frontend.c:dvb_frontend_open
   Cyclomatic Complexity 2 drivers/media/dvb-core/dvb_frontend.c:dvb_frontend_ioctl
   Cyclomatic Complexity 18 drivers/media/dvb-core/dvb_frontend.c:dtv_set_frontend
   Cyclomatic Complexity 5 drivers/media/dvb-core/dvb_frontend.c:dvb_frontend_clear_cache
   Cyclomatic Complexity 3 drivers/media/dvb-core/dvb_frontend.c:dvb_register_frontend
   Cyclomatic Complexity 1 drivers/media/dvb-core/dvb_frontend.c:dvb_frontend_test_event
   Cyclomatic Complexity 8 drivers/media/dvb-core/dvb_frontend.c:dvb_frontend_get_event
   Cyclomatic Complexity 68 drivers/media/dvb-core/dvb_frontend.c:dvb_frontend_handle_ioctl
   Cyclomatic Complexity 6 drivers/media/dvb-core/dvb_frontend.c:dvb_frontend_do_ioctl
   Cyclomatic Complexity 46 drivers/media/dvb-core/dvb_frontend.c:dtv_property_process_set
   Cyclomatic Complexity 1 drivers/media/dvb-core/dvb_frontend.c:dvb_unregister_frontend
   Cyclomatic Complexity 1 drivers/media/dvb-core/dvb_frontend.c:_GLOBAL__sub_I_00100_0_dvb_frontend_reinitialise
   Cyclomatic Complexity 1 drivers/media/dvb-core/dvb_frontend.c:_GLOBAL__sub_D_00100_1_dvb_frontend_reinitialise

vim +2396 drivers/media/dvb-core/dvb_frontend.c

  2295	
  2296	static int dvb_frontend_handle_ioctl(struct file *file,
  2297					     unsigned int cmd, void *parg)
  2298	{
  2299		struct dvb_device *dvbdev = file->private_data;
  2300		struct dvb_frontend *fe = dvbdev->priv;
  2301		struct dvb_frontend_private *fepriv = fe->frontend_priv;
  2302		struct dtv_frontend_properties *c = &fe->dtv_property_cache;
  2303		int i, err = -ENOTSUPP;
  2304	
  2305		dev_dbg(fe->dvb->device, "%s:\n", __func__);
  2306	
  2307		switch (cmd) {
  2308		case FE_SET_PROPERTY: {
  2309			struct dtv_properties *tvps = parg;
  2310			struct dtv_property *tvp = NULL;
  2311	
  2312			dev_dbg(fe->dvb->device, "%s: properties.num = %d\n",
  2313				__func__, tvps->num);
  2314			dev_dbg(fe->dvb->device, "%s: properties.props = %p\n",
  2315				__func__, tvps->props);
  2316	
  2317			/*
  2318			 * Put an arbitrary limit on the number of messages that can
  2319			 * be sent at once
  2320			 */
  2321			if (!tvps->num || (tvps->num > DTV_IOCTL_MAX_MSGS))
  2322				return -EINVAL;
  2323	
  2324			tvp = memdup_user((void __user *)tvps->props, tvps->num * sizeof(*tvp));
  2325			if (IS_ERR(tvp))
  2326				return PTR_ERR(tvp);
  2327	
  2328			for (i = 0; i < tvps->num; i++) {
  2329				err = dtv_property_process_set(fe, file,
  2330							       (tvp + i)->cmd,
  2331							       (tvp + i)->u.data);
  2332				if (err < 0) {
  2333					kfree(tvp);
  2334					return err;
  2335				}
  2336			}
  2337			kfree(tvp);
  2338			err = 0;
  2339			break;
  2340		}
  2341		case FE_GET_PROPERTY: {
  2342			struct dtv_properties *tvps = parg;
  2343			struct dtv_property *tvp = NULL;
  2344			struct dtv_frontend_properties getp = fe->dtv_property_cache;
  2345	
  2346			dev_dbg(fe->dvb->device, "%s: properties.num = %d\n",
  2347				__func__, tvps->num);
  2348			dev_dbg(fe->dvb->device, "%s: properties.props = %p\n",
  2349				__func__, tvps->props);
  2350	
  2351			/*
  2352			 * Put an arbitrary limit on the number of messages that can
  2353			 * be sent at once
  2354			 */
  2355			if (!tvps->num || (tvps->num > DTV_IOCTL_MAX_MSGS))
  2356				return -EINVAL;
  2357	
  2358			tvp = memdup_user((void __user *)tvps->props, tvps->num * sizeof(*tvp));
  2359			if (IS_ERR(tvp))
  2360				return PTR_ERR(tvp);
  2361	
  2362			/*
  2363			 * Let's use our own copy of property cache, in order to
  2364			 * avoid mangling with DTV zigzag logic, as drivers might
  2365			 * return crap, if they don't check if the data is available
  2366			 * before updating the properties cache.
  2367			 */
  2368			if (fepriv->state != FESTATE_IDLE) {
  2369				err = dtv_get_frontend(fe, &getp, NULL);
  2370				if (err < 0) {
  2371					kfree(tvp);
  2372					return err;
  2373				}
  2374			}
  2375			for (i = 0; i < tvps->num; i++) {
  2376				err = dtv_property_process_get(fe, &getp,
  2377							       tvp + i, file);
  2378				if (err < 0) {
  2379					kfree(tvp);
  2380					return err;
  2381				}
  2382			}
  2383	
  2384			if (copy_to_user((void __user *)tvps->props, tvp,
  2385					 tvps->num * sizeof(struct dtv_property))) {
  2386				kfree(tvp);
  2387				return -EFAULT;
  2388			}
  2389			kfree(tvp);
  2390			err = 0;
  2391			break;
  2392		}
  2393	
  2394		case FE_GET_INFO: {
  2395			struct dvb_frontend_info *info = parg;
> 2396			memset(info, 0, sizeof(info));
  2397	
  2398			dvb_frontend_get_frequency_limits(fe, &info->frequency_min, &info->frequency_max);
  2399			strcpy(info->name, fe->ops.info.name);
  2400			info->frequency_stepsize = fe->ops.info.frequency_stepsize_hz;
  2401			info->frequency_tolerance = fe->ops.info.frequency_tolerance_hz;
  2402			info->symbol_rate_min = fe->ops.info.symbol_rate_min;
  2403			info->symbol_rate_max = fe->ops.info.symbol_rate_max;
  2404			info->symbol_rate_tolerance = fe->ops.info.symbol_rate_tolerance;
  2405			info->caps = fe->ops.info.caps;
  2406	
  2407			/* If the standard is for satellite, convert frequencies to kHz */
  2408			switch (c->delivery_system) {
  2409			case SYS_DVBS:
  2410			case SYS_DVBS2:
  2411			case SYS_TURBO:
  2412			case SYS_ISDBS:
  2413				info->frequency_stepsize = fe->ops.info.frequency_stepsize_hz / kHz;
  2414				info->frequency_tolerance = fe->ops.info.frequency_tolerance_hz / kHz;
  2415				break;
  2416			default:
  2417				info->frequency_stepsize = fe->ops.info.frequency_stepsize_hz;
  2418				info->frequency_tolerance = fe->ops.info.frequency_tolerance_hz;
  2419				break;
  2420			}
  2421	
  2422			/*
  2423			 * Associate the 4 delivery systems supported by DVBv3
  2424			 * API with their DVBv5 counterpart. For the other standards,
  2425			 * use the closest type, assuming that it would hopefully
  2426			 * work with a DVBv3 application.
  2427			 * It should be noticed that, on multi-frontend devices with
  2428			 * different types (terrestrial and cable, for example),
  2429			 * a pure DVBv3 application won't be able to use all delivery
  2430			 * systems. Yet, changing the DVBv5 cache to the other delivery
  2431			 * system should be enough for making it work.
  2432			 */
  2433			switch (dvbv3_type(c->delivery_system)) {
  2434			case DVBV3_QPSK:
  2435				info->type = FE_QPSK;
  2436				break;
  2437			case DVBV3_ATSC:
  2438				info->type = FE_ATSC;
  2439				break;
  2440			case DVBV3_QAM:
  2441				info->type = FE_QAM;
  2442				break;
  2443			case DVBV3_OFDM:
  2444				info->type = FE_OFDM;
  2445				break;
  2446			default:
  2447				dev_err(fe->dvb->device,
  2448					"%s: doesn't know how to handle a DVBv3 call to delivery system %i\n",
  2449					__func__, c->delivery_system);
  2450				info->type = FE_OFDM;
  2451			}
  2452			dev_dbg(fe->dvb->device, "%s: current delivery system on cache: %d, V3 type: %d\n",
  2453				__func__, c->delivery_system, info->type);
  2454	
  2455			/* Set CAN_INVERSION_AUTO bit on in other than oneshot mode */
  2456			if (!(fepriv->tune_mode_flags & FE_TUNE_MODE_ONESHOT))
  2457				info->caps |= FE_CAN_INVERSION_AUTO;
  2458			err = 0;
  2459			break;
  2460		}
  2461	
  2462		case FE_READ_STATUS: {
  2463			enum fe_status *status = parg;
  2464	
  2465			/* if retune was requested but hasn't occurred yet, prevent
  2466			 * that user get signal state from previous tuning */
  2467			if (fepriv->state == FESTATE_RETUNE ||
  2468			    fepriv->state == FESTATE_ERROR) {
  2469				err = 0;
  2470				*status = 0;
  2471				break;
  2472			}
  2473	
  2474			if (fe->ops.read_status)
  2475				err = fe->ops.read_status(fe, status);
  2476			break;
  2477		}
  2478	
  2479		case FE_DISEQC_RESET_OVERLOAD:
  2480			if (fe->ops.diseqc_reset_overload) {
  2481				err = fe->ops.diseqc_reset_overload(fe);
  2482				fepriv->state = FESTATE_DISEQC;
  2483				fepriv->status = 0;
  2484			}
  2485			break;
  2486	
  2487		case FE_DISEQC_SEND_MASTER_CMD:
  2488			if (fe->ops.diseqc_send_master_cmd) {
  2489				struct dvb_diseqc_master_cmd *cmd = parg;
  2490	
  2491				if (cmd->msg_len > sizeof(cmd->msg)) {
  2492					err = -EINVAL;
  2493					break;
  2494				}
  2495				err = fe->ops.diseqc_send_master_cmd(fe, cmd);
  2496				fepriv->state = FESTATE_DISEQC;
  2497				fepriv->status = 0;
  2498			}
  2499			break;
  2500	
  2501		case FE_DISEQC_SEND_BURST:
  2502			if (fe->ops.diseqc_send_burst) {
  2503				err = fe->ops.diseqc_send_burst(fe,
  2504							(enum fe_sec_mini_cmd)parg);
  2505				fepriv->state = FESTATE_DISEQC;
  2506				fepriv->status = 0;
  2507			}
  2508			break;
  2509	
  2510		case FE_SET_TONE:
  2511			if (fe->ops.set_tone) {
  2512				err = fe->ops.set_tone(fe,
  2513						       (enum fe_sec_tone_mode)parg);
  2514				fepriv->tone = (enum fe_sec_tone_mode)parg;
  2515				fepriv->state = FESTATE_DISEQC;
  2516				fepriv->status = 0;
  2517			}
  2518			break;
  2519	
  2520		case FE_SET_VOLTAGE:
  2521			if (fe->ops.set_voltage) {
  2522				err = fe->ops.set_voltage(fe,
  2523							  (enum fe_sec_voltage)parg);
  2524				fepriv->voltage = (enum fe_sec_voltage)parg;
  2525				fepriv->state = FESTATE_DISEQC;
  2526				fepriv->status = 0;
  2527			}
  2528			break;
  2529	
  2530		case FE_DISEQC_RECV_SLAVE_REPLY:
  2531			if (fe->ops.diseqc_recv_slave_reply)
  2532				err = fe->ops.diseqc_recv_slave_reply(fe, parg);
  2533			break;
  2534	
  2535		case FE_ENABLE_HIGH_LNB_VOLTAGE:
  2536			if (fe->ops.enable_high_lnb_voltage)
  2537				err = fe->ops.enable_high_lnb_voltage(fe, (long)parg);
  2538			break;
  2539	
  2540		case FE_SET_FRONTEND_TUNE_MODE:
  2541			fepriv->tune_mode_flags = (unsigned long)parg;
  2542			err = 0;
  2543			break;
  2544	
  2545		/* DEPRECATED dish control ioctls */
  2546	
  2547		case FE_DISHNETWORK_SEND_LEGACY_CMD:
  2548			if (fe->ops.dishnetwork_send_legacy_command) {
  2549				err = fe->ops.dishnetwork_send_legacy_command(fe,
  2550								 (unsigned long)parg);
  2551				fepriv->state = FESTATE_DISEQC;
  2552				fepriv->status = 0;
  2553			} else if (fe->ops.set_voltage) {
  2554				/*
  2555				 * NOTE: This is a fallback condition.  Some frontends
  2556				 * (stv0299 for instance) take longer than 8msec to
  2557				 * respond to a set_voltage command.  Those switches
  2558				 * need custom routines to switch properly.  For all
  2559				 * other frontends, the following should work ok.
  2560				 * Dish network legacy switches (as used by Dish500)
  2561				 * are controlled by sending 9-bit command words
  2562				 * spaced 8msec apart.
  2563				 * the actual command word is switch/port dependent
  2564				 * so it is up to the userspace application to send
  2565				 * the right command.
  2566				 * The command must always start with a '0' after
  2567				 * initialization, so parg is 8 bits and does not
  2568				 * include the initialization or start bit
  2569				 */
  2570				unsigned long swcmd = ((unsigned long)parg) << 1;
  2571				ktime_t nexttime;
  2572				ktime_t tv[10];
  2573				int i;
  2574				u8 last = 1;
  2575	
  2576				if (dvb_frontend_debug)
  2577					dprintk("%s switch command: 0x%04lx\n",
  2578						__func__, swcmd);
  2579				nexttime = ktime_get_boottime();
  2580				if (dvb_frontend_debug)
  2581					tv[0] = nexttime;
  2582				/* before sending a command, initialize by sending
  2583				 * a 32ms 18V to the switch
  2584				 */
  2585				fe->ops.set_voltage(fe, SEC_VOLTAGE_18);
  2586				dvb_frontend_sleep_until(&nexttime, 32000);
  2587	
  2588				for (i = 0; i < 9; i++) {
  2589					if (dvb_frontend_debug)
  2590						tv[i + 1] = ktime_get_boottime();
  2591					if ((swcmd & 0x01) != last) {
  2592						/* set voltage to (last ? 13V : 18V) */
  2593						fe->ops.set_voltage(fe, (last) ? SEC_VOLTAGE_13 : SEC_VOLTAGE_18);
  2594						last = (last) ? 0 : 1;
  2595					}
  2596					swcmd = swcmd >> 1;
  2597					if (i != 8)
  2598						dvb_frontend_sleep_until(&nexttime, 8000);
  2599				}
  2600				if (dvb_frontend_debug) {
  2601					dprintk("%s(%d): switch delay (should be 32k followed by all 8k)\n",
  2602						__func__, fe->dvb->num);
  2603					for (i = 1; i < 10; i++)
  2604						pr_info("%d: %d\n", i,
  2605							(int)ktime_us_delta(tv[i], tv[i - 1]));
  2606				}
  2607				err = 0;
  2608				fepriv->state = FESTATE_DISEQC;
  2609				fepriv->status = 0;
  2610			}
  2611			break;
  2612	
  2613		/* DEPRECATED statistics ioctls */
  2614	
  2615		case FE_READ_BER:
  2616			if (fe->ops.read_ber) {
  2617				if (fepriv->thread)
  2618					err = fe->ops.read_ber(fe, parg);
  2619				else
  2620					err = -EAGAIN;
  2621			}
  2622			break;
  2623	
  2624		case FE_READ_SIGNAL_STRENGTH:
  2625			if (fe->ops.read_signal_strength) {
  2626				if (fepriv->thread)
  2627					err = fe->ops.read_signal_strength(fe, parg);
  2628				else
  2629					err = -EAGAIN;
  2630			}
  2631			break;
  2632	
  2633		case FE_READ_SNR:
  2634			if (fe->ops.read_snr) {
  2635				if (fepriv->thread)
  2636					err = fe->ops.read_snr(fe, parg);
  2637				else
  2638					err = -EAGAIN;
  2639			}
  2640			break;
  2641	
  2642		case FE_READ_UNCORRECTED_BLOCKS:
  2643			if (fe->ops.read_ucblocks) {
  2644				if (fepriv->thread)
  2645					err = fe->ops.read_ucblocks(fe, parg);
  2646				else
  2647					err = -EAGAIN;
  2648			}
  2649			break;
  2650	
  2651		/* DEPRECATED DVBv3 ioctls */
  2652	
  2653		case FE_SET_FRONTEND:
  2654			err = dvbv3_set_delivery_system(fe);
  2655			if (err)
  2656				break;
  2657	
  2658			err = dtv_property_cache_sync(fe, c, parg);
  2659			if (err)
  2660				break;
  2661			err = dtv_set_frontend(fe);
  2662			break;
  2663		case FE_GET_EVENT:
  2664			err = dvb_frontend_get_event(fe, parg, file->f_flags);
  2665			break;
  2666	
  2667		case FE_GET_FRONTEND: {
  2668			struct dtv_frontend_properties getp = fe->dtv_property_cache;
  2669	
  2670			/*
  2671			 * Let's use our own copy of property cache, in order to
  2672			 * avoid mangling with DTV zigzag logic, as drivers might
  2673			 * return crap, if they don't check if the data is available
  2674			 * before updating the properties cache.
  2675			 */
  2676			err = dtv_get_frontend(fe, &getp, parg);
  2677			break;
  2678		}
  2679	
  2680		default:
  2681			return -ENOTSUPP;
  2682		} /* switch */
  2683	
  2684		return err;
  2685	}
  2686	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--HlL+5n6rz5pIUxbD
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
swIf042wNTj/B4o64I2XDgIA

--HlL+5n6rz5pIUxbD--
