Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.netup.ru ([77.72.80.15]:57891 "EHLO imap.netup.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755558AbbIYJWV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Sep 2015 05:22:21 -0400
Received: from mail-la0-f46.google.com (mail-la0-f46.google.com [209.85.215.46])
	by imap.netup.ru (Postfix) with ESMTPA id 831F872FC41
	for <linux-media@vger.kernel.org>; Fri, 25 Sep 2015 12:22:17 +0300 (MSK)
Received: by lacdq2 with SMTP id dq2so36486278lac.1
        for <linux-media@vger.kernel.org>; Fri, 25 Sep 2015 02:22:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201509171442.9SuPHPv8%fengguang.wu@intel.com>
References: <201509171442.9SuPHPv8%fengguang.wu@intel.com>
From: Abylay Ospan <aospan@netup.ru>
Date: Fri, 25 Sep 2015 12:21:57 +0300
Message-ID: <CAK3bHNX7boQYW2Wk2_jz-KzbNrkk9mdnaXY52NeYFMy_SCmVGA@mail.gmail.com>
Subject: Re: drivers/media/dvb-frontends/cxd2841er.c:2393:1: warning: the
 frame size of 2992 bytes is larger than 2048 bytes
To: kbuild test robot <fengguang.wu@intel.com>
Cc: Kozlov Sergey <serjk@netup.ru>, kbuild-all@01.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I cannot reproduce this warning. I'm compiling with your config and
following commands:

  git checkout a6dc60ff1209df29ee4668024e93d31f31421932
  make ARCH=x86_64

my gcc version is 4.9.2 (Ubuntu 4.9.2-10ubuntu13)

warning doesn't appear even if I set:
CONFIG_FRAME_WARN=128

Please point me if problem still exist.

thanks !



2015-09-17 9:05 GMT+03:00 kbuild test robot <fengguang.wu@intel.com>:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> head:   72714841b705a5b9bccf37ee85a62352bee3a3ef
> commit: a6dc60ff1209df29ee4668024e93d31f31421932 [media] cxd2841er: Sony CXD2841ER DVB-S/S2/T/T2/C demodulator driver
> date:   5 weeks ago
> config: x86_64-randconfig-b0-09171322 (attached as .config)
> reproduce:
>   git checkout a6dc60ff1209df29ee4668024e93d31f31421932
>   # save the attached .config to linux build tree
>   make ARCH=x86_64
>
> All warnings (new ones prefixed by >>):
>
>    drivers/media/dvb-frontends/cxd2841er.c: In function 'cxd2841er_sleep_tc':
>>> drivers/media/dvb-frontends/cxd2841er.c:2393:1: warning: the frame size of 2992 bytes is larger than 2048 bytes [-Wframe-larger-than=]
>     }
>     ^
>    drivers/media/dvb-frontends/cxd2841er.c: In function 'cxd2841er_set_frontend_tc':
>    drivers/media/dvb-frontends/cxd2841er.c:2274:1: warning: the frame size of 4336 bytes is larger than 2048 bytes [-Wframe-larger-than=]
>     }
>     ^
>
> vim +2393 drivers/media/dvb-frontends/cxd2841er.c
>
>   2377                  case SYS_DVBC_ANNEX_A:
>   2378                          cxd2841er_active_c_to_sleep_tc(priv);
>   2379                          break;
>   2380                  default:
>   2381                          dev_warn(&priv->i2c->dev,
>   2382                                  "%s(): unknown delivery system %d\n",
>   2383                                  __func__, priv->system);
>   2384                  }
>   2385          }
>   2386          if (priv->state != STATE_SLEEP_TC) {
>   2387                  dev_err(&priv->i2c->dev, "%s(): invalid state %d\n",
>   2388                          __func__, priv->state);
>   2389                  return -EINVAL;
>   2390          }
>   2391          cxd2841er_sleep_tc_to_shutdown(priv);
>   2392          return 0;
>> 2393  }
>   2394
>   2395  static int cxd2841er_send_burst(struct dvb_frontend *fe,
>   2396                                  enum fe_sec_mini_cmd burst)
>   2397  {
>   2398          u8 data;
>   2399          struct cxd2841er_priv *priv  = fe->demodulator_priv;
>   2400
>   2401          dev_dbg(&priv->i2c->dev, "%s(): burst mode %s\n", __func__,
>
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation



-- 
Abylay Ospan,
NetUP Inc.
http://www.netup.tv
