Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:28990 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750971AbeGEFcJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Jul 2018 01:32:09 -0400
Date: Thu, 5 Jul 2018 13:31:46 +0800
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
Message-ID: <201807051210.jRsEu6Xc%fengguang.wu@intel.com>
References: <b3d63a8f038d136b26692bc3a14554960e767f4a.1530740760.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="7JfCtLOvnd9MIVvH"
Content-Disposition: inline
In-Reply-To: <b3d63a8f038d136b26692bc3a14554960e767f4a.1530740760.git.mchehab+samsung@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--7JfCtLOvnd9MIVvH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Mauro,

I love your patch! Perhaps something to improve:

[auto build test WARNING on linuxtv-media/master]
[also build test WARNING on v4.18-rc3 next-20180704]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Mauro-Carvalho-Chehab/DVB-represent-frequencies-at-tuner-frontend-info-in-Hz/20180705-105703
base:   git://linuxtv.org/media_tree.git master
config: x86_64-randconfig-x004-201826 (attached as .config)
compiler: gcc-7 (Debian 7.3.0-16) 7.3.0
reproduce:
        # save the attached .config to linux build tree
        make ARCH=x86_64 

All warnings (new ones prefixed by >>):

   drivers/media/dvb-core/dvb_frontend.c: In function 'dvb_frontend_handle_ioctl':
>> drivers/media/dvb-core/dvb_frontend.c:2396:25: warning: argument to 'sizeof' in 'memset' call is the same expression as the destination; did you mean to dereference it? [-Wsizeof-pointer-memaccess]
      memset(info, 0, sizeof(info));
                            ^

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

--7JfCtLOvnd9MIVvH
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
AQA=

--7JfCtLOvnd9MIVvH--
